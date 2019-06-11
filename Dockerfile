FROM debian:stretch-slim

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
  TZ=Europe/Berlin \
  DEBIAN_FRONTEND=noninteractive

RUN dpkg --add-architecture i386 \
  && apt-get -y update \
  && apt-get -y upgrade \
  && apt-get -y --no-install-recommends --no-install-suggests install \
    curl \
    dnsutils \
    locales \
    net-tools \
    locales \
    ca-certificates \
    gdb \
    libc6-i386 \
    lib32stdc++6 \
    lib32gcc1 \
    lib32ncurses5 \
    lib32z1 \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && update-locale LANG=en_US.UTF-8 \
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
