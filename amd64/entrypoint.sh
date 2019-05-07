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

if [ -f /data/init/init-device.sh ]; then
	/data/init/init-device.sh
fi

rm -Rf /etc/pulse
rm -f /etc/default/snapserver

ln -s /data/pulseaudio/conf /etc/pulseaudio
ln -s /data/snapserver/conf/snapserver /etc/default/snapserver

useradd -d /home/pulseaudio -m -s /bin/bash pulseaudio

chown -R pulseaudio:root /home/pulseaudio

gosu pulseaudio pulseaudio -D

snapserver 
