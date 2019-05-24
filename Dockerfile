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
  echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests lib32stdc++6 lib32gcc1 wget ca-certificates \
	&& mkdir -p $HOME/steamcmd \
  && apt-get remove -y wget \
  && apt-get clean autoclean \
  && apt-get autoremove -y \
  && rm -rf /var/lib/{apt,dpkg,cache,log} \
  && useradd -m $USER \
  && chown -R $USER:$USER $HOME \
  && chmod 777 $SERVER/update.sh

USER $USER

RUN set -x \
  && curl http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $HOME/steamcmd -xvz

WORKDIR $HOME

ENTRYPOINT $SERVER/update.sh
