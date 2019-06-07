FROM ubuntu:18.04

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

RUN apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y --no-install-recommends --no-install-suggests install \
    curl \
    net-tools \
    ca-certificates \
    gzip \
    tar \
    lib32gcc1 \
    lib32stdc++6 \
    gdb \
    locales \
  && locale-gen $LC_ALL \
  && update-locale LANG=$LANG LANGUAGE=$LANGUAGE LC_ALL=$LC_ALL \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-ca-certificates \
  && mkdir -p $HOME/steamcmd $SERVER \
  && curl https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -C $HOME/steamcmd -xvz \
  && apt-get purge -y curl \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

COPY update.sh $HOME/update.sh

RUN chgrp -R 0 $HOME \
  && chmod -R g=u $HOME \
  && chmod -R 775 $HOME

USER 1337

WORKDIR $HOME

ENTRYPOINT [ "/home/gs/update.sh" ]

CMD run
