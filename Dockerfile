FROM centos:latest
LABEL maintainer="Robin 'siw36' Klussmann" \
  author="Robin 'siw36' Klussmann" \
  org.label-schema.name="steamcmd-gs-updater-image-replicas" \
  org.label-schema.description="Steam CMD game server updater Docker image" \
  org.label-schema.url="https://github.com/siw36/docker-csgo" \
  org.label-schema.vcs-url="https://github.com/siw36/docker-csgo" \
  org.label-schema.vendor="replicas.io" \
  org.label-schema.schema-version="0.1" \
  io.k8s.description="SteamCMD game server updater" \
  io.k8s.display-name="SteamCMD Updater" \
  io.openshift.tags="steamcmd" \
  version=0.1

ENV HOME=/home/gs \
  SERVER=/home/gs/gameserver \
  LC_ALL=en_US.UTF-8 \
  LANG=en_US.UTF-8 \
  LANGUAGE=en_US.UTF-8 \
  TZ=Europe/Berlin \
  GS_GID=1337 \
  GS_UID=1337

RUN yum -y fs documentation && \
  yum -y install \
  tar \
  gzip \
  curl \
  ca-certificates \
  glibc.i686 \
  libgcc.i686 \
  && yum -y update && yum -y clean all

COPY update.sh $HOME/update.sh

RUN mkdir -p $HOME/steamcmd $SERVER \
	&& curl https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -C $HOME/steamcmd -xvz \
  && groupadd -r -g $GS_GID gs \
  && useradd -rMl -u $GS_UID -d $HOME -g gs gs \
  && yum -y remove curl gzip tar \
  && yum -y clean all \
  && rm -rf /tmp/* /var/tmp/* /var/cache/{dnf,microdnf}

RUN chown -R gs:gs $HOME \
  && chmod -R 777 $HOME

USER gs

WORKDIR $HOME

ENTRYPOINT $HOME/update.sh
