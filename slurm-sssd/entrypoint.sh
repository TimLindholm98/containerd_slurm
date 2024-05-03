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
    chmod 600 /opt/slurm/etc/jwt_hs256.key && \
        chown slurm:root /opt/slurm/etc/jwt_hs256.key && \
        chmod 700 /var/spool/slurmctld && \
        /opt/slurm/sbin/slurmctld -Dv
}

start_slurmd(){
    chmod 700 /var/spool/slurmd && \
        /opt/slurm/sbin/slurmd -Dvv
}

start_slurmdbd(){
    mkdir -p /var/spool/slurmdbd && \
        hmod 700 /var/spool/slurmdbd && \
        chown slurm:root /var/spool/slurmdbd && \
        chmod 600 /opt/slurm/etc/slurmdbd.conf && \
        chown slurm:root /opt/slurm/etc/slurmdbd.conf && \
        chmod 600 /opt/slurm/etc/jwt_hs256.key && \
        chown slurm:root /opt/slurm/etc/jwt_hs256.key && \
        /opt/slurm/sbin/slurmdbd -Dvv
}

start_slurmrestd(){
    mkdir -p /var/spool/slurmrestd && \
        chmod 700 /var/spool/slurmrestd && \
        chown slurm:root /var/spool/slurmrestd && \
        chmod 600 /opt/slurm/etc/jwt_hs256.key && \
        chown slurm:root /opt/slurm/etc/jwt_hs256.key && \
        /opt/slurm/sbin/slurmrestd -Dvv
}

export -f init_sssd
export -f init_munge
export -f start_slurmctld
export -f start_slurmd
export -f start_slurmdbd
export -f start_slurmrestd

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
elif [[ $1 == "slurmrestd" ]]; then
    init_sssd && \
        init_munge && \
        start_slurmrestd
fi
