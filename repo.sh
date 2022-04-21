#!/bin/sh

SITEDIR=$WORKDIR/_site

if ! git -C $WORKDIR rev-parse 2>/dev/null; then
  echo "$WORKDIR is not a git repository"
  echo 'Git commit disabled.'
  # tail -f /dev/null # infinite sleep
fi

if [ ! -d $SITEDIR ]; then
  echo 'Waiting for site to be rendered ...'
  while [ ! -d $SITEDIR ]
  do
    sleep 2
  done
  echo
fi


# wait for changes
cd $WORKDIR
while true; do
  echo 'Waiting for changes ...'
  inotifywait -q -r -e modify,close_write,move,create,delete $SITEDIR

  echo 'Pushing changes ...'
  git add .
  git commit -m 'Changed from jekyll-admin'
  git log -1 --abbrev-commit --graph
  git fetch
  git merge
  git push

  echo 'Uploading done'
done
