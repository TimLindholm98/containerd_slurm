build :
	podman build -t slurmd slurmd/
	podman build -t slurmctld slurmctld/
up :
	podman-compose up -d
down :
	podman-compose down
restart : down up
upgrade : build restart
