#!/bin/bash

mkdir -p /data/pulseaudio/conf
mkdir -p /data/snapserver/conf
mkdir -p /data/init

if [ ! -f /data/pulseaudio/conf/default.pa ]; then
	cp -pR /etc/pulse/* /data/pulseaudio/conf/
fi

if [ ! -f /data/snapserver/conf ]; then
	cp /etc/default/snapserver /data/snapserver/conf
fi

rm -Rf /etc/pulse
rm -f /etc/default/snapserver

ln -s /data/pulseaudio/conf /etc/pulseaudio
ln -s /data/snapserver/conf/snapserver /etc/default/snapserver

useradd -d /home/pulseaudio -m -s /bin/bash pulseaudio

chown -R pulseaudio:root /home/pulseaudio

mkdir -p /run/snapcast/
mount -t tmpfs -o size=50m tmpfs /run/snapcast/

chown pulseaudio:pulseaudio /run/snapcast/

service dbus start

gosu pulseaudio mkdir -p /home/pulseaudio/.config/pulse

cp /etc/pulseaudio/default.pa /home/pulseaudio/.config/pulse/

chown pulseaudio:pulseaudio /home/pulseaudio/.config/pulse/default.pa

if [ -f /data/init/init-device.sh ]; then
	/data/init/init-device.sh
fi

service snapserver restart

gosu pulseaudio /usr/bin/pulseaudio --disallow-exit --daemonize=no --realtime --log-target=stderr -vvvvv

