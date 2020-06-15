#!/bin/zsh

function set_background() {
  if [[ ! -z $1 ]]; then
    feh --bg-fill --no-xinerama $1
  fi
}

bspc subscribe all | while read line; do
  FOCUSED_MONITOR=$(bspc query -M -m --names)
  if [[ -z $FOCUSED_MONITOR ]]; then
    if [[ -f "$HOME/.wallpaper/$MONITOR" ]]; then
      # maybe we've just started X and events have not yet arrived
      set_background "$HOME/.wallpaper/$MONITOR"
    fi
  fi

  BG=$(cat ~/.fehbg | grep -o $FOCUSED_MONITOR)
  if [[ "z$BG" == "z" ]]; then
    # not current background. Need to switch
    set_background "$HOME/.wallpaper/$FOCUSED_MONITOR"
  else
    # leave it as it is
  fi
done
