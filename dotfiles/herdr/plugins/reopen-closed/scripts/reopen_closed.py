#!/usr/bin/env python3
"""Reopen closed herdr panes, tabs and workspaces.

  record   Run by the pane.closed / tab.closed / workspace.closed hooks. Reads
           the closed item out of session.json, which herdr has not re-saved
           yet, and pushes a snapshot onto the stack.
  reopen   Run by the keybound action. Pops the newest snapshot, rebuilds it
           and runs `claude --resume <id>` in every pane that held a Claude
           session.
  list     Print the stack, newest first.

Scrollback and other processes are not restored: a reopened shell pane gets
back its position and cwd only.
"""
import contextlib
import fcntl
import functools
import glob
import json
import os
import shlex
import socket
import sys
import time

HERDR_DIR = os.path.dirname(
    os.environ.get("HERDR_CONFIG_PATH") or os.path.expanduser("~/.config/herdr/config.toml")
)
SESSION_PATH = os.path.join(HERDR_DIR, "session.json")
SOCKET_PATH = os.environ.get("HERDR_SOCKET_PATH") or os.path.join(HERDR_DIR, "herdr.sock")
STATE_DIR = os.environ.get("HERDR_PLUGIN_STATE_DIR") or os.path.expanduser(
    "~/.local/state/herdr/plugins/reopen-closed"
)
STACK_PATH = os.path.join(STATE_DIR, "closed.jsonl")
# Old id -> the id it was reopened as, so a pane whose neighbour, tab or
# workspace was itself closed and reopened still lands back next to it.
REMAP_PATH = os.path.join(STATE_DIR, "remap.json")
CLAUDE_PROJECTS = os.path.join(
    os.environ.get("CLAUDE_CONFIG_DIR") or os.path.expanduser("~/.claude"), "projects"
)

MAX_ENTRIES = 50
MAX_REMAP = 500

# session.json split direction -> API split direction
DIRECTIONS = {"Horizontal": "right", "Vertical": "down"}
# Label of the tab panes are parked in while a pane is put back; never recorded.
SCRATCH_TAB = "reopen-closed-scratch"


class ApiError(Exception):
    pass


def api(method, **params):
    """One request over herdr's JSON socket API."""
    request = {
        "id": "reopen-closed",
        "method": method,
        "params": {k: v for k, v in params.items() if v is not None},
    }
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as sock:
        sock.connect(SOCKET_PATH)
        sock.sendall(json.dumps(request).encode() + b"\n")
        buf = b""
        while not buf.endswith(b"\n"):
            chunk = sock.recv(65536)
            if not chunk:
                break
            buf += chunk
    response = json.loads(buf)
    if "error" in response:
        raise ApiError(f"{method}: {response['error'].get('message')}")
    return response["result"]


def notify(title, body=None):
    try:
        api("notification.show", title=title, body=body, sound="none")
    except (OSError, ValueError, ApiError):
        pass


@contextlib.contextmanager
def locked():
    os.makedirs(STATE_DIR, exist_ok=True)
    with open(os.path.join(STATE_DIR, "lock"), "w") as f:
        fcntl.flock(f, fcntl.LOCK_EX)
        yield


def read_stack():
    entries = []
    try:
        with open(STACK_PATH) as f:
            for line in f:
                try:
                    entries.append(json.loads(line))
                except ValueError:
                    pass
    except FileNotFoundError:
        pass
    return entries


def write_atomic(path, text):
    tmp = path + ".tmp"
    with open(tmp, "w") as f:
        f.write(text)
    os.replace(tmp, path)


def write_stack(entries):
    write_atomic(STACK_PATH, "".join(json.dumps(e) + "\n" for e in entries[-MAX_ENTRIES:]))


def read_remap():
    try:
        with open(REMAP_PATH) as f:
            return json.load(f)
    except (FileNotFoundError, ValueError):
        return {}


def write_remap(remap):
    write_atomic(REMAP_PATH, json.dumps(dict(list(remap.items())[-MAX_REMAP:])))


def resolve(remap, old_id):
    """The id old_id was last reopened as (itself if never)."""
    seen = set()
    while old_id in remap and old_id not in seen:
        seen.add(old_id)
        old_id = remap[old_id]
    return old_id


# --- snapshots ---------------------------------------------------------------


def convert_layout(node, ids, closed):
    """session.json layout tree -> {"pane": id} | {"split", "ratio", "first", "second"},
    leaving out panes in closed (None if that leaves nothing)."""
    if "Pane" in node:
        pane_id = ids[node["Pane"]]
        return None if pane_id in closed else {"pane": pane_id}
    split = node["Split"]
    first = convert_layout(split["first"], ids, closed)
    second = convert_layout(split["second"], ids, closed)
    if first and second:
        return {
            "split": DIRECTIONS[split["direction"]],
            "ratio": split["ratio"],
            "first": first,
            "second": second,
        }
    return first or second


def base36(n):
    digits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    out = ""
    while True:
        n, d = divmod(n, 36)
        out = digits[d] + out
        if n == 0:
            return out


def snapshot_workspace(ws, closed, remap):
    """A session.json workspace, keyed by current API ids (wG, wG:t1, wG:pA).

    session.json is only re-saved 5s after the last change, so it can still
    hold panes and tabs closed just before this one (ids in closed, dropped
    here), and things reopened since under their old ids (renamed via remap).
    """
    ids = {
        int(n): resolve(remap, f"{ws['id']}:p{base36(public)}")
        for n, public in ws["public_pane_numbers"].items()
    }
    tabs = []
    active_tab = 0
    for i, (number, tab) in enumerate(zip(ws["public_tab_numbers"], ws["tabs"])):
        tab_id = resolve(remap, f"{ws['id']}:t{base36(number)}")
        layout = convert_layout(tab["layout"], ids, closed)
        if tab_id in closed or layout is None:
            continue
        if i == ws.get("active_tab"):
            active_tab = len(tabs)
        tabs.append({
            "id": tab_id,
            "label": tab.get("custom_name"),
            "layout": layout,
            "focused": ids.get(tab.get("focused")),
            "panes": {
                ids[int(n)]: {"cwd": p.get("cwd"), "agent_session": p.get("agent_session")}
                for n, p in tab["panes"].items()
                if ids[int(n)] not in closed
            },
        })
    return {
        "id": resolve(remap, ws["id"]),
        "label": ws.get("custom_name"),
        "cwd": ws.get("identity_cwd"),
        "tabs": tabs,
        "active_tab": active_tab,
    }


def leaves(node):
    if "pane" in node:
        return [node["pane"]]
    return leaves(node["first"]) + leaves(node["second"])


def find_parent(node, pane_id):
    """(parent split of pane_id, whether pane_id is its first child), or None."""
    if "pane" in node:
        return None
    for key in ("first", "second"):
        if node[key].get("pane") == pane_id:
            return node, key == "first"
        found = find_parent(node[key], pane_id)
        if found:
            return found
    return None


def target(entry):
    if entry["kind"] == "pane":
        return ("pane", entry["pane"]["id"])
    if entry["kind"] == "tab":
        return ("tab", entry["tab"]["id"])
    return ("workspace", entry["workspace"]["id"])


def make_entry(event, ws):
    """The stack entry for a close event, given its workspace's snapshot."""
    ws_meta = {k: ws[k] for k in ("id", "label", "cwd")}
    if event["type"] == "workspace_closed":
        return {"kind": "workspace", "workspace": ws} if ws["tabs"] else None
    if event["type"] == "tab_closed":
        tab = next((t for t in ws["tabs"] if t["id"] == event["tab_id"]), None)
        if tab is None or tab["label"] == SCRATCH_TAB:
            return None
        return {"kind": "tab", "workspace": ws_meta, "tab": tab}

    pane_id = event["pane_id"]
    # Plugin panes (e.g. the confirm-close prompt) are not in any tab.
    tab = next((t for t in ws["tabs"] if pane_id in t["panes"]), None)
    if tab is None:
        return None
    found = find_parent(tab["layout"], pane_id)
    if found is None:
        # A tab's last pane takes the tab (or workspace) with it, and only
        # pane.closed fires for that.
        if len(ws["tabs"]) == 1:
            return {"kind": "workspace", "workspace": ws}
        return {"kind": "tab", "workspace": ws_meta, "tab": tab}
    parent, first = found
    return {
        "kind": "pane",
        "workspace": ws_meta,
        "tab_id": tab["id"],
        "pane": {"id": pane_id, **tab["panes"][pane_id]},
        # It goes back beside this subtree, the other half of its split.
        "anchor": {
            "sibling": parent["second" if first else "first"],
            "direction": parent["split"],
            "before": first,
            "ratio": parent["ratio"],
        },
    }


def record():
    event = json.loads(os.environ["HERDR_PLUGIN_EVENT_JSON"])["data"]
    with open(SESSION_PATH) as f:
        session = json.load(f)
    with locked():
        stack = read_stack()
        closed = {target(e)[1] for e in stack}
        remap = read_remap()
        ws = next(
            (w for w in session["workspaces"] if resolve(remap, w["id"]) == event["workspace_id"]),
            None,
        )
        if ws is None or event["workspace_id"] in closed:
            return
        entry = make_entry(event, snapshot_workspace(ws, closed, remap))
        if entry is None:
            return
        entry["closed_at"] = time.time()
        stack.append(entry)
        write_stack(stack)


# --- reopening ---------------------------------------------------------------


def claude_session(pane):
    session = pane.get("agent_session") or {}
    if session.get("agent") == "claude" and session.get("kind") == "id":
        return session.get("value")
    return None


@functools.lru_cache(maxsize=None)
def transcript_cwd(session_id):
    """Where a Claude session was started; `claude --resume` only finds it from there."""
    pattern = os.path.join(CLAUDE_PROJECTS, "*", glob.escape(session_id) + ".jsonl")
    for path in glob.glob(pattern):
        with open(path) as f:
            for _, line in zip(range(50), f):
                try:
                    cwd = json.loads(line).get("cwd")
                except ValueError:
                    continue
                if cwd:
                    return cwd
    return None


def pane_cwd(pane):
    session = claude_session(pane)
    cwd = (session and transcript_cwd(session)) or pane.get("cwd")
    return cwd if cwd and os.path.isdir(cwd) else None


def entry_panes(entry):
    if entry["kind"] == "pane":
        return [entry["pane"]]
    tabs = [entry["tab"]] if entry["kind"] == "tab" else entry["workspace"]["tabs"]
    return [p for t in tabs for p in t["panes"].values()]


class Live:
    def __init__(self):
        panes = api("pane.list")["panes"]
        self.panes = {p["pane_id"]: p for p in panes}
        self.workspaces = {p["workspace_id"] for p in panes}
        self.ids = set(self.panes) | self.workspaces | {p["tab_id"] for p in panes}
        self.sessions = {claude_session(p) for p in panes} - {None}

    def still_open(self, entry):
        """entry's pane/tab/workspace is open (ids are never reused, so it was
        not really closed, e.g. a server restart), or every Claude session in
        it is open in some pane already."""
        sessions = {claude_session(p) for p in entry_panes(entry)} - {None}
        return target(entry)[1] in self.ids or (bool(sessions) and sessions <= self.sessions)


class Rebuilder:
    def __init__(self, live, remap):
        self.live = live
        self.remap = remap

    def resolve(self, old_id):
        return resolve(self.remap, old_id)

    def run(self, entry):
        """Rebuild entry; return the pane to focus."""
        if entry["kind"] == "pane":
            return self.reopen_pane(entry)
        if entry["kind"] == "tab":
            return self.reopen_tab(entry["workspace"], entry["tab"])
        ws = entry["workspace"]
        ws_meta = {k: ws[k] for k in ("id", "label", "cwd")}
        # The first tab recreates the workspace; the rest are added to it.
        focused = [self.reopen_tab(ws_meta, tab) for tab in ws["tabs"]]
        return focused[min(ws["active_tab"], len(focused) - 1)]

    def prune(self, node, tab_id):
        """node with ids resolved, keeping only panes still open in tab_id."""
        if "pane" in node:
            pane_id = self.resolve(node["pane"])
            info = self.live.panes.get(pane_id)
            return {"pane": pane_id} if info and info["tab_id"] == tab_id else None
        first, second = self.prune(node["first"], tab_id), self.prune(node["second"], tab_id)
        if first and second:
            return {**node, "first": first, "second": second}
        return first or second

    def reopen_pane(self, entry):
        pane, anchor = entry["pane"], entry["anchor"]
        cwd = pane_cwd(pane)
        alive = [p for p in map(self.resolve, leaves(anchor["sibling"])) if p in self.live.panes]
        if alive:
            sibling = self.prune(anchor["sibling"], self.live.panes[alive[0]]["tab_id"])
        else:
            # Its neighbours are gone too; fall back to any pane left in its tab.
            tab_id = self.resolve(entry["tab_id"])
            sibling = next(
                ({"pane": p} for p, info in self.live.panes.items() if info["tab_id"] == tab_id),
                None,
            )
        if sibling is None:
            _, new_id, cwd = self.new_tab(entry["workspace"], None, cwd)
        else:
            new_id = self.split_beside(sibling, anchor, cwd)
        self.restored(pane["id"], new_id, pane, cwd)
        return new_id

    def split_beside(self, sibling, anchor, cwd):
        """Split a new pane in next to the whole sibling subtree."""
        # herdr can only split a single pane. Park the sibling's other panes in
        # a scratch tab so its first pane fills the region, split that, then
        # move them back in their old arrangement.
        root, *others = leaves(sibling)
        info = self.live.panes[root]
        if others:
            scratch = api(
                "pane.move",
                pane_id=others[0],
                destination={
                    "type": "new_tab",
                    "workspace_id": info["workspace_id"],
                    "label": SCRATCH_TAB,
                },
            )["move_result"]["pane"]["tab_id"]
            for p in others[1:]:
                api(
                    "pane.move",
                    pane_id=p,
                    destination={"type": "tab", "tab_id": scratch, "split": "right", "target_pane_id": others[0]},
                )
        new_id = api(
            "pane.split",
            target_pane_id=root,
            direction=anchor["direction"],
            ratio=anchor["ratio"],
            cwd=cwd,
        )["pane"]["pane_id"]
        if anchor["before"]:
            # herdr only splits right/down; swap to put it back left/above.
            api("pane.swap", source_pane_id=new_id, target_pane_id=root)

        def build(node, pane_id):
            if "pane" in node:
                return
            moved = leaves(node["second"])[0]
            api(
                "pane.move",
                pane_id=moved,
                destination={
                    "type": "tab",
                    "tab_id": info["tab_id"],
                    "split": node["split"],
                    "target_pane_id": pane_id,
                    "ratio": node["ratio"],
                },
            )
            build(node["first"], pane_id)
            build(node["second"], moved)

        build(sibling, root)
        return new_id

    def new_tab(self, ws_meta, label, cwd):
        """Open a tab in ws_meta's workspace, recreating the workspace if it is
        gone. Returns (tab id, root pane id, root pane cwd)."""
        ws_id = self.resolve(ws_meta["id"])
        if ws_id in self.live.workspaces:
            res = api("tab.create", workspace_id=ws_id, cwd=cwd, label=label)
            return res["tab"]["tab_id"], res["root_pane"]["pane_id"], cwd
        cwd = ws_meta["cwd"] or cwd
        res = api("workspace.create", cwd=cwd, label=ws_meta["label"])
        new_ws = res["workspace"]["workspace_id"]
        self.remap[ws_meta["id"]] = new_ws
        self.live.workspaces.add(new_ws)
        if label:
            api("tab.rename", tab_id=res["tab"]["tab_id"], label=label)
        return res["tab"]["tab_id"], res["root_pane"]["pane_id"], cwd

    def reopen_tab(self, ws_meta, tab):
        first = tab["panes"][leaves(tab["layout"])[0]]
        tab_id, root, root_cwd = self.new_tab(ws_meta, tab["label"], pane_cwd(first))
        self.remap[tab["id"]] = tab_id
        created = {}  # old pane id -> (new pane id, cwd it was created in)

        def build(node, pane_id, cwd):
            if "pane" in node:
                created[node["pane"]] = (pane_id, cwd)
                return
            # Split the whole region first, then subdivide each half.
            second_cwd = pane_cwd(tab["panes"][leaves(node["second"])[0]])
            new_id = api(
                "pane.split",
                target_pane_id=pane_id,
                direction=node["split"],
                ratio=node["ratio"],
                cwd=second_cwd,
            )["pane"]["pane_id"]
            build(node["first"], pane_id, cwd)
            build(node["second"], new_id, second_cwd)

        build(tab["layout"], root, root_cwd)
        for old_id, (new_id, cwd) in created.items():
            self.restored(old_id, new_id, tab["panes"][old_id], cwd)
        return created.get(tab["focused"], (root,))[0]

    def restored(self, old_id, new_id, pane, created_cwd):
        self.remap[old_id] = new_id
        session = claude_session(pane)
        # Never open one conversation in two panes.
        if not session or session in self.live.sessions:
            return
        self.live.sessions.add(session)
        command = f"claude --resume {shlex.quote(session)}"
        cwd = pane_cwd(pane)
        if cwd and cwd != created_cwd:
            command = f"cd {shlex.quote(cwd)} && {command}"
        api("pane.send_input", pane_id=new_id, text=command, keys=["enter"])


def reopen(focus):
    with locked():
        live = Live()
        stack = read_stack()
        entry = None
        while stack:
            candidate = stack.pop()
            if not live.still_open(candidate):
                entry = candidate
                break
        write_stack(stack)
        if entry is None:
            notify("Nothing to reopen")
            return
        remap = read_remap()
        try:
            pane_id = Rebuilder(live, remap).run(entry)
        finally:
            write_remap(remap)
    if focus:
        api("pane.focus", pane_id=pane_id)


def list_stack():
    for entry in reversed(read_stack()):
        when = time.strftime("%m-%d %H:%M:%S", time.localtime(entry.get("closed_at", 0)))
        sessions = [s for s in map(claude_session, entry_panes(entry)) if s]
        name = entry["workspace"].get("label") or entry["workspace"].get("cwd")
        print(f"{when}  {entry['kind']:<9} {target(entry)[1]:<8} {name}  claude={sessions}")


def main():
    command = sys.argv[1] if len(sys.argv) > 1 else ""
    if command == "record":
        record()
    elif command == "reopen":
        try:
            reopen(focus="--no-focus" not in sys.argv)
        except Exception as e:
            notify("Reopen failed", str(e))
            raise
    elif command == "list":
        list_stack()
    else:
        sys.exit(f"usage: {sys.argv[0]} record|reopen [--no-focus]|list")


if __name__ == "__main__":
    main()
