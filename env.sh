#!/bin/sh

stage=${1:-'default'}

cat <<EOF
COMPOSE_PROJECT_NAME=jekyll-$stage
STAGE=$stage
EOF

case $stage in
	'default')
		cat <<-EOF
		JEKYLL_ADMIN_LOGIN=admin
		JEKYLL_ADMIN_PASSWORD=admin
		EOF
		;;
esac
