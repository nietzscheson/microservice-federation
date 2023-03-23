.PHONY:
init: down volume up
down:
	docker-compose down
volume:
	docker volume prune -f
pull:
	docker-compose pull
build:
	docker-compose build
up: pull build
	docker-compose up -d
	make ps
ps:
	docker-compose ps
test: test.user test.product test.order
test.user:
	@docker-compose run --rm user python -m pytest tests/ -v -s
test.product:
	@docker-compose run --rm product python -m pytest tests/ -v -s
test.order:
	@docker-compose run --rm order python -m pytest tests/ -v -s
debug:
	docker-compose -f docker-compose.yml -f docker-compose.debug.yml up --build
prune:
	make down
	docker volume prune -f
	docker system prune -f
upgrade:
	docker-compose run --rm user flask db upgrade
	docker-compose run --rm product flask db upgrade
	docker-compose run --rm order flask db upgrade
fixtures:
	@docker-compose run --rm user flask fixtures
	@docker-compose run --rm product flask fixtures
	@docker-compose run --rm order flask fixtures
migrate:
	docker-compose run --rm user flask db migrate
	docker-compose run --rm product flask db migrate
	docker-compose run --rm order flask db migrate
