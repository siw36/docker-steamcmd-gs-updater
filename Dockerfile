FROM centos:latest

LABEL name="siw36/steamcmd-gs-updater" \
  maintainer="https://github.com/siw36" \
  vendor="ReplicasIO" \
  version="1" \
  release="1" \
  summary="SteamCMD game server updater" \
  description="This image will install/update a chosen steam APP. See README.md for details." \
  url="https://www.replicas.io" \
  io.k8s.description="This image will install/update a chosen steam APP. See README.md for details." \
  io.k8s.display-name="SteamCMD-GS-Updater" \
  io.openshift.expose-services="" \
  io.openshift.tags="replicas.io,gs,gameserver,steamcmd" \
  io.openshift.non-scalable="true"

ENV HOME=/home/gs \
  SERVER=/home/gs/gameserver \
  LC_ALL=en_US.UTF-8 \
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US.UTF-8 \
  TZ=Europe/Berlin

RUN yum -y update-minimal --setopt=tsflags=nodocs \
  && yum -y --setopt=protected_multilib=false --setopt=tsflags=nodocs install \
    tar \
    gzip \
    curl \
    ca-certificates \
    glibc.i686 \
    libgcc.i686 \
  && yum -y clean all

RUN mkdir -p $HOME/steamcmd $SERVER \
	&& curl https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -C $HOME/steamcmd -xvz \
  && rpm -e --nodeps curl gzip tar \
  && yum -y clean all \
  && rm -rf /tmp/* /var/tmp/* /var/cache/{yum,rpm}

COPY update.sh $HOME/update.sh

RUN chgrp -R 0 $HOME \
  && chmod -R g=u $HOME \
  && chmod -R 775 $HOME

USER 1337

WORKDIR $HOME

ENTRYPOINT [ "/home/gs/update.sh" ]

CMD run
