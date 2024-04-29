#!/bin/bash

podman run -d --name linux1 --hostname linux1 \
	--privileged \
	--net slurm \
	-v ./configs/slurm.conf:/opt/slurm/etc/slurm.conf:z \
	-v ./configs/cgroup.conf:/opt/slurm/etc/cgroup.conf:z \
	--mount=type=tmpfs,tmpfs-size=1M,tmpfs-mode=1755,destination=/run/munge \
	--mount=type=tmpfs,tmpfs-size=5M,tmpfs-mode=1700,destination=/var/spool/slurmd \
	--mount=type=tmpfs,tmpfs-size=5M,tmpfs-mode=1700,destination=/sys/fs/cgroup \
	localhost/sssd-slurm ./entrypoint.sh slurmd