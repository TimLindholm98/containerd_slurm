from fedora

ARG SLURM_ARCHIVE="slurm-23.11.5"


RUN dnf install git make gcc -y

ARG MUNGE_ID=1100
RUN groupadd -g $MUNGE_ID -o munge
RUN useradd -m -u $MUNGE_ID -g $MUNGE_ID -o -s /bin/bash munge

RUN dnf install munge-devel munge libjwt-devel libcgroup -y


ARG SLURM_ID=1101
RUN groupadd -g $SLURM_ID -o slurm
RUN useradd -m -u $SLURM_ID -g $SLURM_ID -o -s /bin/bash slurm

COPY $SLURM_ARCHIVE /opt/$SLURM_ARCHIVE

WORKDIR /opt/$SLURM_ARCHIVE

RUN mkdir /opt/slurm

RUN ./configure --with-jwt --prefix /opt/slurm 
RUN make -j 12 install

WORKDIR /opt/slurm

COPY entrypoint.sh .
COPY ./secrets/munge.key /etc/munge/munge.key
RUN chown munge:munge /etc/munge/munge.key && chmod 700 /etc/munge/munge.key

RUN rm -rf /opt/$SLURM_ARCHIVE

EXPOSE 6817
EXPOSE 6818
EXPOSE 60000-63000

ENTRYPOINT ./entrypoint.sh
CMD ["init"]
