#!/bin/bash
set -x

correct_permissons(){
    chmod 700 /var/spool/slurmctld
}

init_munge(){
   chown munge:munge /run/munge
   sudo -u munge /usr/sbin/munged -S /run/munge/munge.socket.2 -v &
}


init_sssd(){
}

export -f init_munge && init_munge

/opt/slurm/sbin/slurmctld -Dv
