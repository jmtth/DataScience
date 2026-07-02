run: setup
	docker-compose up -d

setup:
	mkdir -p data/postgres data/pgadmin

load_first_data:
	docker compose exec -T postgres sh < import_data.sh
	
