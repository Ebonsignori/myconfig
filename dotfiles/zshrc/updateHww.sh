# Update HWW downstream
updateHwwFunc() {
  CURRENT_BRANCH="$(git rev-parse --abbrev-ref HEAD)"
  if [[ "$CURRENT_BRANCH" != "main" && "$CURRENT_BRANCH" != "master" ]]; then
    echo "Please checkout main/master before attempting this"
    return 1
  fi
  if ! git diff-index --quiet HEAD --; then
    echo "You have uncomitted changes!"  
    return 1
  fi
  git checkout main
  git pull 
  git checkout hww-booster-pack-updater 
  git pull
  mkdir -p .github/ISSUE_COMMENT_TEMPLATE
  # Delete all existing workflows beginning with hww-, then replace with updated versions 
  rm .github/workflows/hww-*  
  rm .github/ISSUE_COMMENT_TEMPLATE/hww-*
  mv .github/hww-booster-pack-updates/workflows/* .github/workflows/
  mv .github/hww-booster-pack-updates/ISSUE_COMMENT_TEMPLATE/* .github/ISSUE_COMMENT_TEMPLATE/
  # Add, commit, and push
  git add --all
  git commit -m "Accept booster pack updates"
  git push
  git checkout main
  #Remove this line if you want to review the changes before merging them
  git merge hww-booster-pack-updater
  git push
  git branch -D hww-booster-pack-updater
}

alias updateHww='updateHwwFunc'
