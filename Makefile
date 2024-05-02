build :
	cd slurm-sssd && \
		docker build -t slurm-sssd .
up :
	cd slurm-sssd && \
		docker compose up -d
down :
	cd slurm-sssd && \
		docker compose down
restart : down up
upgrade : build restart
create_network:
	docker network create slurm

init: create_network build up
