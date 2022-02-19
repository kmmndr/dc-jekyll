build:
	docker-compose build

start: build
	docker-compose up

console: build
	docker-compose run --rm jekyll /bin/ash

clean:
	docker-compose down -v
