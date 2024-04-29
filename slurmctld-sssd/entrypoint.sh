#!/bin/bash
set -x

init_sssd(){
    sssd -d 3
}

correct_permissons(){
    chmod 700 /var/spool/slurmctld
}

init_munge(){
   chown munge:munge /run/munge
   sudo -u munge /usr/sbin/munged -S /run/munge/munge.socket.2 -v &
}

start_slurmctld(){
    /opt/slurm/sbin/slurmctld -Dv
}

export -f correct_permissons
export -f init_munge
export -f init_sssd

init_sssd && \
    correct_permissons && \
    init_munge && \
    start_slurmctld
