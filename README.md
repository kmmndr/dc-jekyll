# dc-jekyll

Simple CMS-like using [jekyll](https://jekyllrb.com/) and
[jekyll-admin](https://github.com/jekyll/jekyll-admin/).

## Requirements

The following tools are required:
- [make](https://www.gnu.org/software/make/)
- [docker](https://www.docker.com/)
- [dc-traefik](https://github.com/kmmndr/dc-traefik) (optional for remote deployment)

## Getting started

Out of the box, there are two options to start dc-jekyll. Start locally or
deploy/start on a remote server, both are only requiring Docker daemon.

### Start locally

This is the easiest way to start hacking locally.

Before anything else, generate an environment file.

```shell
make generate-env
```

Then start

```shell
make local-start
```

And finally open your browser on http://127.0.0.1:8080 for jekyll generated
site or http://127.0.0.1:8080/admin to access administration tool.

### Deploy online

On the remote host a docker daemon accessible through ssh is required, and
[dc-traefik](https://github.com/kmmndr/dc-traefik) web proxy.

As you probably do not want to use `admin` as a password, create an environment
file for your configuration

```shell
cat > override.env <<END_OF_FILE
stage=\${1:-'default'}
case $stage in
	'production')
		cat <<-EOF
		DOCKER_HOST=ssh://user@remote-host.online
		# This must be really online to allow LetsEncrypt to provide TLS certificates
		APP_FQDN=remote-host.online
		#
		JEKYLL_ADMIN_LOGIN=admin
		JEKYLL_ADMIN_PASSWORD=your-secret-password
		# You may use a command line tool to retrieve password
		# JEKYLL_ADMIN_PASSWORD=\$(pass show jekyll-admin)
		JEKYLL_SITE_REPOSITORY= # url of site git repository
		JEKYLL_SITE_KEY= # ssh deploy key in base64
		EOF
		;;
esac
END_OF_FILE

chmod +x override.env

make -e stage=production generate-env
```

Then deploy

```shell
make -e stage=production traefik-deploy
```

It take few minutes for traefik to get a valid TLS certificate. After a while,
enjoy browsing your new website https://remote-host.online :-)
