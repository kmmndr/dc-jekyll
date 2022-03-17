#!/bin/sh

cd $WORKDIR
if [ ! -f _config.yml ]; then
  echo "Initializing new project ..."
  jekyll new .
  bundle add webrick
  bundle add jekyll-admin --group=jekyll_plugins
fi

if [ Gemfile -nt Gemfile.lock ]; then
  echo "Gemfile has changed, installing ..."
  bundle install
fi

export JEKYLL_ADMIN_PASSWORD=$(caddy hash-password -algorithm scrypt -plaintext $JEKYLL_ADMIN_PASSWORD)
goreman -exit-on-error -set-ports=false -f /Procfile start
