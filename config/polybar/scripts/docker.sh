#!/bin/sh

if [ "$(systemctl is-active docker.service)" != "active" ]; then
    echo "%{F#ff1a1a}%{F-}"
    exit
fi

running_containers=$(docker ps --format='{{ .ID }}' | wc -l)
if [ $running_containers == 0 ]; then
  echo "%{F#2eb82e}%{F-}"
  exit
fi

echo %{F#e5e600}%{F-} $running_containers
