#!/bin/bash
set -x

init_sssd(){
    sssd -d 3
}

init_munge(){
   chown munge:munge /run/munge
   sudo -u munge /usr/sbin/munged -S /run/munge/munge.socket.2 -v &
}

start_slurmctld(){
    chmod 700 /var/spool/slurmctld
    /opt/slurm/sbin/slurmctld -Dv
}

start_slurmd(){
    chmod 700 /var/spool/slurmd
    /opt/slurm/sbin/slurmd -Dvvv
}

export -f init_sssd
export -f init_munge
export -f start_slurmctld
export -f start_slurmd

if [[ $1 == "slurmctld" ]]; then
    init_sssd && \
        init_munge && \
        start_slurmctld
elif [[ $1 == "slurmd" ]]; then
    init_sssd && \
        init_munge && \
        start_slurmd
fi
