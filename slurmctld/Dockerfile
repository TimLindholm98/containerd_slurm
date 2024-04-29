from fedora

# This can be a folder or a tar file but the you need to unarchive it in the build process.
ARG SLURM_ARCHIVE="slurm-23.11.5"

# Base packages
RUN dnf install git make gcc -y

# Create slumr user the SLURM_ID arg needs to be the same as the cluster nodes
ARG MUNGE_ID=1100
RUN groupadd -g $MUNGE_ID -o munge
RUN useradd -m -u $MUNGE_ID -g $MUNGE_ID -o -s /bin/bash munge
# Install the munge packages after. Otherwise the installer will create the uid and gid for munge
# Then its not garanted that its the same across the cluster.
RUN dnf install munge-devel munge libjwt-devel -y

# Create slumr user the SLURM_ID arg needs to be the same as the cluster nodes
ARG SLURM_ID=1101
RUN groupadd -g $SLURM_ID -o slurm
RUN useradd -m -u $SLURM_ID -g $SLURM_ID -o -s /bin/bash slurm

# Compile slurm
COPY $SLURM_ARCHIVE /opt/$SLURM_ARCHIVE
WORKDIR /opt/$SLURM_ARCHIVE
RUN mkdir /opt/slurm
RUN ./configure --with-jwt --prefix /opt/slurm 
RUN make -j 6 install

# Change workdir before we copy over files
WORKDIR /opt/slurm

# Copy over munge credentials
COPY secrets/munge.key /etc/munge/munge.key
RUN chown munge:munge /etc/munge/munge.key && chmod 700 /etc/munge/munge.key

# Remove the slurm build filess
RUN rm -rf /opt/$SLURM_ARCHIVE

# Open ports for comunication (slurm)
# 6817 incomming slurmctld, 6818 incomming slurmd and srun port-range
EXPOSE 6817
EXPOSE 6818
EXPOSE 60000-63000

# Startup
COPY entrypoint.sh .
ENTRYPOINT ./entrypoint.sh
CMD ["init"]
