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

COPY update.sh $SERVER/update.sh

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		lib32stdc++6 \
		lib32gcc1 \
		wget \
		ca-certificates \
	&& useradd -m $USER \
  && chown -R $USER:$USER $HOME \
	&& su $USER -c \
		"mkdir -p $HOME/steamcmd \
		&& cd $HOME/steamcmd \
		&& wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar zxf -" \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
  && rm -rf /tmp/* /var/tmp/* \
  && chmod -R 777 $HOME/steamcmd/

USER $USER

WORKDIR $HOME

ENTRYPOINT $SERVER/update.sh
