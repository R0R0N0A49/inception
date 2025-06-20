COMPOSE_FILE = srcs/docker-compose.yml

all: up

up:
	@mkdir -p /home/trebours/data/mysql
	@mkdir -p /home/trebours/data/wordpress
	@docker compose -f $(COMPOSE_FILE) up --build -d

down:
	@docker compose -f $(COMPOSE_FILE) down

clean:
	@docker compose -f $(COMPOSE_FILE) down -v --remove-orphans
	@docker system prune -f --volumes

status:
	@docker compose -f $(COMPOSE_FILE) ps

logs:
	@docker compose -f $(COMPOSE_FILE) logs -f --tail=100

re: clean all

.PHONY: clean all up down status logs