#!/bin/bash

# start the ssh-agent
#eval $(ssh-agent -s)

# swaps 8 and 9 - the back and forward buttons on x7 mouse
xmodmap -e "pointer = 1 2 3 4 5 6 7 9 8 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24" &

# https://unix.stackexchange.com/questions/265503/how-do-i-fix-no-such-secret-collection-at-path-for-gnome-keyring-and-arch-l/295652#295652
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# set thinkpad's trackpoint speed (and other properties):
# xinput --list # to get the device name
# xinput list-props "TPPS/2 IBM TrackPoint"
# T480
#xinput set-prop "TPPS/2 IBM TrackPoint" "libinput Accel Speed" 0.7 # between 0 and 1
# E490
xinput set-prop "TPPS/2 Elan TrackPoint" "libinput Accel Speed" 0.4 # between 0 and 1
xinput set-prop "TPPS/2 Elan TrackPoint" "libinput Accel Profile Enabled" 0, 1

setxkbmap -option grp:alt_shift_toggle -layout us,bg -variant ",phonetic" && fbxkb &

# update fonts
xset +fp /usr/share/fonts/local
xset +fp ~/.fonts
xset fp rehash

# disable pc speaker
xset -b

#(xrandr --output HDMI1 --auto --right-of eDP1 --rotate right)
MONITOR1=$(xrandr --listactivemonitors | command egrep -i -o "edp[-]?[0-9]+" | head -1)
[[ -z $MONITOR1 ]] && MONITOR1="eDP1"

MONITOR2=$(xrandr --listactivemonitors | command egrep -i -o "hdmi[-]?[0-9]+" | head -1)
[[ -z $MONITOR2 ]] && MONITOR2="HDMI"

export MONITOR1
export MONITOR2

xrandr --output $MONITOR2 --auto --mode 1920x1200 --right-of $MONITOR1 &

[[ -f ~/.Xdefaults ]] && xrdb -load ~/.Xdefaults
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

for xres in ~/.*.xresources; do
  xrdb -merge $xres
done

sxhkd &

# https://wiki.archlinux.org/index.php/java#Non-reparenting_window_managers
export _JAVA_AWT_WM_NONREPARENTING=1 &

exec xautolock -detectsleep -locker /home/makpoc/scripts/i3lock/i3lock_blur -time 7 &

# Disable tapping and scrolling after keypress
# See https://wiki.archlinux.org/index.php/Touchpad_Synaptics#Disable_touchpad_while_typing
syndaemon -i 0.8 -t -K -R -d &

xsetroot -cursor_name left_ptr &

#nitrogen --restore &

# Enable gnome-keyring
# https://wiki.archlinux.org/index.php/GNOME/Keyring#Using_the_keyring_outside_GNOME
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK
# add ssh keys to agent
ssh-add ~/.ssh/git.acronis.com
ssh-add ~/.ssh/github.com

# urxvtd(1)
urxvtd -q -o -f

# set a dark theme for GTK based apps
export GTK_THEME=Adwaita-dark

exec bspwm
