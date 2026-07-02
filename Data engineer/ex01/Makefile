FILE ?= data_2022_dec.csv

run: setup
	docker-compose up -d

setup:
	mkdir -p data/postgres data/pgadmin

load_data:
	docker compose exec -T postgres sh -s -- "$(FILE)" < import_data.sh
	
load_table:
	docker compose exec -T postgres sh -s -- "$(FILE)" < ../ex02/table.sh

load_automatic_table:
	docker compose exec -T postgres sh < ../ex03/automatic_table.sh

load_items_table:
	docker compose exec -T postgres sh < ../ex04/items_table.sh
