init:
	docker run --name demo -v "$$PWD"/:/db/ -e POSTGRES_PASSWORD=password1 -d -p 5432:5432 -h 0.0.0.0 postgres
	sleep 2
	docker exec -it demo psql -U postgres -c "CREATE DATABASE db_acdemic"
	sleep 2
	docker exec -it demo psql -U postgres -f /db/seed_db.sql

update:
	docker rm -f demo
	sleep 2
	docker run --name demo -v "$$PWD"/:/db/ -e POSTGRES_PASSWORD=password1 -d -p 5432:5432 -h 0.0.0.0 postgres
	sleep 2
	docker exec -it demo psql -U postgres -c "CREATE DATABASE db_acdemic"
	sleep 2
	docker exec -it demo psql -U postgres -f /db/seed_db.sql