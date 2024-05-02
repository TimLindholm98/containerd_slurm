build :
	docker build -t slurm-sssd slurm-sssd
up :
	docker compose up -d
down :
	docker compose down
restart : down up
upgrade : build restart
create_network:
	docker network create slurm

init: create_network build up
