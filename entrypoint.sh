#!/bin/sh

export JEKYLL_ADMIN_PASSWORD=$(caddy hash-password -algorithm scrypt -plaintext $JEKYLL_ADMIN_PASSWORD)
export GIT_USER_NAME=${GIT_USER_NAME:-'Jekyll Admin'}
export GIT_USER_EMAIL=${GIT_USER_EMAIL:-'admin@jekyll.localhost'}
mkdir $HOME/.ssh
echo $JEKYLL_SITE_KEY | base64 -d > $HOME/.ssh/jekyll-admin
echo -e "Host *\n\tIdentityFile ~/.ssh/jekyll-admin\n\tStrictHostKeyChecking no\n" >> $HOME/.ssh/config
chmod 0600 /root/.ssh/jekyll-admin

git config --global user.email "$GIT_USER_EMAIL"
git config --global user.name "$GIT_USER_NAME"

cd $WORKDIR
if [ -z $JEKYLL_SITE_REPOSITORY ]; then
  echo '*** No repository configured for site ***'

else
  echo "*** Site repository $JEKYLL_SITE_REPOSITORY ***"

  if [ ! -f _config.yml ]; then
    echo 'Cloning ...'
    git clone $JEKYLL_SITE_REPOSITORY $WORKDIR
  else
    if git remote | grep origin > /dev/null; then
      echo 'Fetching ...'
      git fetch
      git merge
    fi
  fi
fi

if [ ! -f _config.yml ]; then
  echo "Initializing new project ..."
  jekyll new .
  mkdir -p vendor/bundle
  bundle config --local path 'vendor/bundle'
  bundle add webrick
  bundle add jekyll-admin --group=jekyll_plugins

  git config --global init.defaultBranch master
  git init .
  git add .
  git commit -m 'Initial commit'
fi

if [ ! -z $JEKYLL_SITE_REPOSITORY ]; then
  if ! git remote | grep origin > /dev/null; then
    echo "No remote detected, adding $JEKYLL_SITE_REPOSITORY ..."
    git remote add origin $JEKYLL_SITE_REPOSITORY
    git push --set-upstream origin master
  fi

  echo 'Pushing existing data ...'
  git push
fi

bundle install

goreman -exit-on-error -set-ports=false -f /Procfile start
