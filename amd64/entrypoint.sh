#!/bin/bash

useradd -d /home/pulseaudio -m -s /bin/bash pulseaudio

chown -R pulseaudio:root /home/pulseaudio

gosu pulseaudio pulseaudio -D

snapserver 
