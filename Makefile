COMPOSE_FILE = srcs/docker-compose.yml

all: up

up:
	@mkdir -p /home/trebours/data/mysql
	@mkdir -p /home/trebours/data/wordpress
	@docker compose -f $(COMPOSE_FILE) up --build -d

down:
	@docker compose -f $(COMPOSE_FILE) down

clean:
	@docker ps -aq | xargs -r docker stop > /dev/null 2>&1 || true
	@docker ps -aq | xargs -r docker rm -f > /dev/null 2>&1 || true
	@docker images -q | xargs -r docker rmi -f > /dev/null 2>&1 || true
	@docker volume ls -q | xargs -r docker volume rm -f > /dev/null 2>&1 || true
	@docker network ls -q | grep -vE 'bridge|host|none' | xargs -r docker network rm > /dev/null 2>&1 || true
	@docker system prune -f --volumes > /dev/null 2>&1 || true
	@echo "✅ Docker cleanup finish."


status:
	@docker compose -f $(COMPOSE_FILE) ps

data:
	@docker exec -it mariadb bash

logs:
	@docker compose -f $(COMPOSE_FILE) logs -f --tail=100

re: clean all

.PHONY: clean all up down status logs