#!/bin/sh

# pacman only
if ! updates_arch=$(checkupdates 2> /dev/null | wc -l ); then
    updates_arch=0
fi

# pacman + aur
if ! updates_aur=$(yay -Qum 2> /dev/null | wc -l); then
    updates_aur=0
fi

updates=$(("$updates_arch" + "$updates_aur"))

if [ "$updates" -gt 100 ]; then
  color="%{F#ff1a1a}" # red
elif [ "$updates" -gt 50 ]; then
  color="%{F#ff9900}" # orange
elif [ "$updates" -gt 0 ]; then
  color="%{F#e5e600}" # yellow
else
  color="%{F#2eb82e}" # green
fi

echo "$color%{F-} $updates"
/home/makpoc/.config/polybar/scripts/arch-updates.sh
