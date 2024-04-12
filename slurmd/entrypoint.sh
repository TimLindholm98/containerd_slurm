#!/bin/bash

set -x
init(){
    chmod 700 /var/spool/slurmd
    chown munge:munge /run/munge
    sudo -u munge /usr/sbin/munged -S /run/munge/munge.socket.2 -v &
}
export -f init
init

if [ -n "$1" ] || [ "$1" != "init"  ]; then
    /bin/bash -c "$1"
else
    /opt/slurm/sbin/slurmd -Dvv
fi
