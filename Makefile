default: help
include makefiles/*.mk

.PHONY: build
build: docker-compose-build

.PHONY: start
start: docker-compose-build docker-compose-start ##- Start

.PHONY: deploy
deploy: docker-compose-build docker-compose-pull docker-compose-deploy

.PHONY: stop
stop: docker-compose-stop ##- Stop

.PHONY: logs
logs: docker-compose-logs ##- Logs

.PHONY: clean
clean: docker-compose-clean ##- Stop and remove volumes

.PHONY: status
status: docker-compose-ps ##- Print container's status

.PHONY: console
console: environment docker-compose-build ##- Enter console
	-$(load_env); docker-compose run --rm jekyll /bin/ash
