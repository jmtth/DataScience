FILE ?= data_2022_dec.csv
USER_ID := $(shell id -u)
GROUP_ID := $(shell id -g)
export USER_ID
export GROUP_ID
COMPOSE = USER_ID=$(USER_ID) GROUP_ID=$(GROUP_ID) docker compose

help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  run                 Start the Docker containers"
	@echo "  setup               Create necessary directories for data"
	@echo "  load_data           Load data from import_data.sh into PostgreSQL"
	@echo "  load_table          Load table from table.sh into PostgreSQL"
	@echo "  load_automatic_table Load automatic table from automatic_table.sh into PostgreSQL"
	@echo "  load_items_table    Load items table from items_table.sh into PostgreSQL"

run: setup
	$(COMPOSE) up -d

setup:
	mkdir -p data/postgres data/pgadmin

load_data:
	$(COMPOSE) exec -T postgres sh -s -- "$(FILE)" < import_data.sh
	
load_table:
	$(COMPOSE) exec -T postgres sh -s -- "$(FILE)" < ../ex02/table.sh

load_automatic_table:
	$(COMPOSE) exec -T postgres sh < ../ex03/automatic_table.sh

load_items_table:
	$(COMPOSE) exec -T postgres sh < ../ex04/items_table.sh

clean:
	$(COMPOSE) down -v
	rm -rf data/postgres data/pgadmin

.PHONY: help run setup load_data load_table load_automatic_table load_items_table clean