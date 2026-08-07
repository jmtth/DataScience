-include .env
export

FILE ?= data_2022_dec.csv
COMPOSE = docker compose

help:
	@echo "Usage: make [target]"
	@echo "Targets:"
	@echo "  run                  Start the Docker containers"
	@echo "  setup                Create necessary directories for data"
	@echo "  load_data            Load all data from CSV files into PostgreSQL"
	@echo "  load_automatic_table Load automatic table from automatic_table.sh into PostgreSQL"
	@echo "  load_items_table     Load items table from items_table.sh into PostgreSQL"
	@echo "  create_customers     Create customers table from customers_table.sql"
	@echo "  fclean               Stop and remove Docker containers and volumes, and clean up data directory"
	@echo "  help                 Show this help message"

run: setup
	$(COMPOSE) up -d

setup:
	mkdir -p data

load_data: load_automatic_table load_items_table
	
load_automatic_table:
	$(COMPOSE) exec -T postgres sh < automatic_table.sh

load_items_table:
	$(COMPOSE) exec -T postgres sh < items_table.sh

create_customers:
	$(COMPOSE) exec -T postgres psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < ../ex01/customers_table.sql

remove_duplicates:
	$(COMPOSE) exec -T postgres psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < ../ex02/remove_duplicates.sql

fusion:
	$(COMPOSE) exec -T postgres psql -U $(POSTGRES_USER) -d $(POSTGRES_DB) < ../ex03/fusion.sql

data_warehouse: create_customers remove_duplicates fusion
	

fclean:
	$(COMPOSE) down -v
	rm -rf data

.PHONY: help run setup load_data load_automatic_table load_items_table remove_duplicates fusion fclean 