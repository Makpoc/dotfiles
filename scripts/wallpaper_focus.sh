#!/bin/zsh

bspc subscribe all | while read line; do
  FOCUSED_MONITOR=$(bspc query -M -m --names)
  BG=$(cat ~/.fehbg | grep $FOCUSED_MONITOR)

  if [[ "z$BG" == "z" ]]; then
    # not current background. Need to switch
    feh --bg-fill --no-xinerama ~/.wallpaper/$FOCUSED_MONITOR
  else
    # leave it as it is
  fi
done

