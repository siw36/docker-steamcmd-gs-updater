FROM debian:stretch-slim
LABEL maintainer="Robin 'siw36' Klussmann" \
  org.label-schema.name="steamcmd-gs-updater-image-replicas" \
  org.label-schema.description="Steam CMD game server updater Docker image" \
  org.label-schema.url="https://github.com/siw36/docker-csgo" \
  org.label-schema.vcs-url="https://github.com/siw36/docker-csgo" \
  org.label-schema.vendor="replicas.io" \
  org.label-schema.schema-version="1.0"

ENV USER gs
ENV HOME /home/$USER
ENV SERVER $HOME/gameserver
ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8

COPY update.sh $HOME/update.sh

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6 \
		lib32gcc1 \
		curl \
		ca-certificates \
	&& useradd -m -u 1337 $USER \
	&& mkdir -p $HOME/steamcmd \
  $$ mkdir -p $SERVER \
	&& curl https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz | tar -C $HOME/steamcmd -xvz \
  && apt-get -y remove curl \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
  && rm -rf /tmp/* /var/tmp/* \
  #&& chown -R 1337:1337 $HOME
  #&& chmod -R 777 $HOME

USER 1337

WORKDIR $HOME

#ENTRYPOINT $HOME/update.sh
ENTRYPOINT echo whoami
