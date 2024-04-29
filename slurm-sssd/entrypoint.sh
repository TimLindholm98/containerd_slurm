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
    chmod 700 /var/spool/slurmctld && \
        /opt/slurm/sbin/slurmctld -Dv
}

start_slurmd(){
    chmod 700 /var/spool/slurmd && \
        /opt/slurm/sbin/slurmd -Dvvv
}

start_slurmdbd(){
    mkdir -p /var/spool/slurmdbd && \
        chmod 700 /var/spool/slurmdbd && \
        chmod 600 /opt/slurm/etc/slurmdbd.conf && \
        chown slurm:slurm /var/spool/slurmdbd && \
        chown slurm:slurm /opt/slurm/etc/slurmdbd.conf && \
        /opt/slurm/sbin/slurmdbd -Dvvv
}

export -f init_sssd
export -f init_munge
export -f start_slurmctld
export -f start_slurm
export -f start_slurmdbd

if [[ $1 == "slurmctld" ]]; then
    init_sssd && \
        init_munge && \
        start_slurmctld
elif [[ $1 == "slurmd" ]]; then
    init_sssd && \
        init_munge && \
        start_slurmd
elif [[ $1 == "slurmdbd" ]]; then
    init_sssd && \
        init_munge && \
        start_slurmdbd
fi
