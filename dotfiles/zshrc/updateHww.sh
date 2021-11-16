# Update HWW downstream
updateHwwFunc() {
  CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  if [[ "$CURRENT_BRANCH" != "main" && "$CURRENT_BRANCH" != "master" ]]; then
    echo "Please checkout main/master before attempting this, or alter this check to support another branch"
    return 1
  fi
  if ! git diff-index --quiet HEAD --; then
    echo "You have uncomitted changes!"  
    return 1
  fi
  GITHUB_DIR=".github"
  WORKFLOWS_DIR="$GITHUB_DIR/workflows"
  ISSUE_COMMENT_TEMPLATE_DIR="$GITHUB_DIR/ISSUE_COMMENT_TEMPLATE"
  BOOSTER_PACK_DIR="$GITHUB_DIR/hww-booster-pack-updates"

  git checkout ${CURRENT_BRANCH} && git pull && git checkout hww-booster-pack-updater && git pull
  mkdir -p $WORKFLOWS_DIR
  mkdir -p $ISSUE_COMMENT_TEMPLATE_DIR

  # Delete all existing workflows beginning with hww-, then replace with updated versions 
  rm $WORKFLOWS_DIR/hwwmemexreports-* $WORKFLOWS_DIR/hww-* $ISSUE_COMMENT_TEMPLATE_DIR/hww-*
  mv $BOOSTER_PACK_DIR/workflows/* $WORKFLOWS_DIR/
  mv $BOOSTER_PACK_DIR/ISSUE_COMMENT_TEMPLATE/* $ISSUE_COMMENT_TEMPLATE_DIR/

  # Add, commit, and push
  git add --all && git commit -m "Accept booster pack updates" && git push 
  # Checkout main branch
  git checkout ${CURRENT_BRANCH} && git merge hww-booster-pack-updater && git push
  git branch -D hww-booster-pack-updater
}

alias updateHww='updateHwwFunc'
