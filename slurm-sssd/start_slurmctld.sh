#!/bin/bash

#
podman run --tty -i --name slurmctld --hostname slurmctld \
	--net slurm \
	-v ./configs/slurm.conf:/opt/slurm/etc/slurm.conf:z \
	-v ./statedir:/var/spool/slurmctld:z \
	--mount=type=tmpfs,tmpfs-size=1M,tmpfs-mode=1755,destination=/run/munge \
	localhost/sssd-slurm ./entrypoint.sh slurmctld