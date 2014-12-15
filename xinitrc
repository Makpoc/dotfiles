# https://wiki.archlinux.org/index.php/All_Mouse_Buttons_Working#xmodmap_tweaking
xmodmap -e "pointer = 1 2 3 4 5 6 7 9 8 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24" &
xscreensaver &

xset +fp /usr/share/fonts/local
xset +fp ~/.fonts
xset fp rehash

(/usr/bin/xrandr --output VGA1 --mode 1920x1080 && /usr/bin/xrandr --output HDMI1 --mode 1920x1080 && /usr/bin/xrandr --output HDMI1 --rotate left --right-of VGA1) &&  nitrogen --restore &

[[ -f ~/.Xdefaults ]] && xrdb -load ~/.Xdefaults
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# https://wiki.archlinux.org/index.php/java#Non-reparenting_window_managers
export _JAVA_AWT_WM_NONREPARENTING=1

xscreensaver &
#compton &
xsetroot -cursor_name left_ptr &
# created service
#urxvtd -q -f -o
exec $1
#exec ~/bin/bspwm_run.sh
#exec openbox-session
