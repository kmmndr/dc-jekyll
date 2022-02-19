#!/bin/sh

cd $WORKDIR
if [ ! -f _config.yml ]; then
  echo "Initializing new project ..."
  jekyll new .
  bundle add webrick
  bundle add jekyll-admin --group=jekyll_plugins
fi

if [ Gemfile -nt Gemfile.lock ]; then
  bundle install
fi

goreman -exit-on-error -set-ports=false -f /Procfile start
