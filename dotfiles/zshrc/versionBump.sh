versionBumpFunc() {
  CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  if [[ "$CURRENT_BRANCH" != "master" && "$CURRENT_BRANCH" != "main" ]]; then
    echo "Please checkout main/master before attempting this"
    return 1
  fi
  if [[ -z $1 ]]; then
    echo "You must call this with version you are bumping to. e.g. versionBump 1.2.3"  
    return 1
  fi
  if ! git diff-index --quiet HEAD --; then
    echo "You have uncomitted changes!"  
    return 1
  fi
  echo "Bumping version to $1"
  git pl
  git co -b release-$1
  npm version --no-git-tag-version $1
  git ad
  git ci "bump version to $1"
  git upstream
}

alias versionBump='versionBumpFunc'
