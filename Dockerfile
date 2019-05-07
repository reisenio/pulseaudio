FROM debian:latest

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y pulseaudio wget bluez libavahi-client3 libavahi-common3

RUN wget https://github.com/badaix/snapcast/releases/download/v0.15.0/snapserver_0.15.0_amd64.deb \
  && dpkg -i snapserver_0.15.0_amd64.deb \
  && apt-get -f install \
  && rm -y snapserver_0.15.0_amd64.deb

RUN apt-get -y remove wget \
 && apt-get -y autoremove \
 && apt-get -y clean \
 && rm -rf /var/lib/apt/lists/*

# Verify if gosu is working
RUN gosu nobody true

COPY entrypoint.sh /usr/sbin/

RUN chmod 755 /usr/sbin/entrypoint.sh

CMD ["/usr/sbin/entrypoint.sh"]
