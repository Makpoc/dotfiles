#!/bin/sh
# Source: https://bbs.archlinux.org/viewtopic.php?pid=311378#p311378 (user redbeard0531)
# I took the "many dzens" approach which allowed me to have a more active bar. redbeard_dzen.png
# 
# * Clicking on the workspace list takes you to that workspace
# * Hovering over the title bar shows a full width slave for large window titles (note the ... here)
# * Hovering over the |{KERNEL,MAIN,DAEMON}| displays a scrollable view of those log files
# * Scrolling changes the volume and clicking toggles mute. (updated in realtime using inotify)
# * Hovering over the weather displays the forecast
# * Hovering over the system stats shows more (to be expanded later)
# * Hovering over the clock shows `cal -3` (note that the "important" part of the time is highlighted to make is easy to see)
# 
# The only real problem I have (other than running out of pixels) is that the script doesn't quit cleanly. To reload it I have to run "killall dzonky dzen2 inotail watchfile inotifywatch ;sleep 1; dzonky". If anybody has some suggestions to work around this, I'm all ears. Also, i get segfaults if I use scrolling and ^cs(), but i use $EVENTSCLEARABLE to get around that for now.
# 
# dependencies:
# svn copy of dven2 and gadgets
# xte (a virtual keyboard in xautomation package)
# inotifytools
# inotail
# perl weather.com thingy
# icons

FG='#aaaaaa'
BG='black'
FONT='-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*'
BIGFONT='-*-terminus-*-r-normal-*-*-140-*-*-*-*-iso8859-*'
ICONPATH=/home/mstearn/bin/dzen_bitmaps

EVENTS="entertitle=scrollend,uncollapse;leavetitle=collapse;button4=scrollup;button5=scrolldown"
EVENTSCLEARABLE="entertitle=uncollapse;leavetitle=collapse"

logger (){
while true
do
    read line
    echo "$line"
done \
  | awk 'BEGIN {print "^fg(white)|^fg()'$1'^fg(white)|^fg()";fflush()}; {print ;fflush()}' \
  | sed -re 's/(([^ ]* +){3})/^fg(white)\1^fg()/'

}

key_symulator(){
while true
do
   read key
   if echo $key | grep '^[1-9]$'
   then
       xte 'keydown Alt_L' "key $key" 'keyup Alt_L'
   fi
done
}

alias my_dzen='dzen2 -xs 1 -h 18 -x $BASE -tw $WIDTH -fg $FG -bg $BG'

set_pos (){ # set_pos width_in_pixels
    BASE=$(echo $BASE + $WIDTH | bc)
    WIDTH=$1
}

BASE=0
WIDTH=0

set_pos 155
watchfile ~/.xmonad-status \
  | awk -F '|' '{print $1;fflush()}' \
  | my_dzen  -e 'button1=menuprint' -ta c -w 160 -m h -l 9 \
  | key_symulator &

set_pos 340
watchfile ~/.xmonad-status \
  | awk -F '|' '/\|/ {print $3 "\n" $3;fflush()}' \
  | my_dzen -fn $FONT -e $EVENTSCLEARABLE -ta l -l 1 -u &

set_pos 75
gcpubar -h 18 -w 50 -gs 0 -gw 1 -i 2  -s g -l "^i(${ICONPATH}/cpu-scaled.xpm)" \
  | my_dzen -fn $FONT -e '' -ta l&

set_pos 60
inotail -f -n 50 /var/log/kernel.log \
  | logger KERNEL \
  | my_dzen -fn $FONT -e $EVENTS -ta c -l 20 &

set_pos 50
inotail -f -n 50 /var/log/messages.log \
  | logger MAIN \
  | my_dzen -fn $FONT -e $EVENTS -ta c -l 20 &

set_pos 60
inotail -f -n 50 /var/log/daemon.log \
  | logger DAEMON \
  | my_dzen -fn $FONT -e $EVENTS -ta c -l 20 &


set_pos 100
while [ $? -ne 1  -a  $? -ge 0  ]  && echo -n '^fg()'
do
    if (amixer sget Master | grep -qF '[off]')
    then
        color='#3C55A6'
        icon=${ICONPATH}/vol-mute.xbm
    else
        color='#7CA655'
        icon=${ICONPATH}/vol-hi.xbm
    fi

    percentage=$(amixer sget Master | sed -ne 's/^.*Front Left: .*\[\([0-9]*\)%\].*$/\1/p')

    echo $percentage | gdbar -fg $color -bg darkred -h 18 -w 50 -l "^fg(lightblue)^i($icon)^p(2)^fg()"
    inotifywait -t 30 /dev/snd/controlC0 -qq
done \
  | my_dzen -fn $FONT -ta l -e \
       'button1=exec:amixer sset Master toggle -q;button4=exec:amixer sset Master 1+ -q;button5=exec:amixer sset Master 1- -q;' &


set_pos 45
while echo -n ' ' 
do
    ~/bin/dzenWeather/dzen_weather.pl
    sleep 300 # 5 min
done \
  | my_dzen -fn $FONT -ta l -w 145 -l 2 -u -e $EVENTSCLEARABLE &

 
set_pos 373
CONKY1='^cs()
^tw()^i('$ICONPATH'/temp.xbm)$acpitemp^p(3)^i('$ICONPATH'/${exec if (acpitool -a |grep -qF on-line) ; then echo -n power-ac.xbm; else echo -n power-bat.xbm; fi})$battery^fg(white)^i('$ICONPATH'/net-wifi.xbm)(${wireless_essid wlan0} ${wireless_link_qual_perc wlan0} ^fg(#BA9093)${addr wlan0}^fg(#80AA83)^p(3)^i('${ICONPATH}'/arr_up.xbm)${upspeedf wlan0}^p(3)^i('${ICONPATH}'/arr_down.xbm)${downspeedf wlan0}^fg(white))  
LOADS: ^fg(#ff0000)${loadavg 1 2 3}
UPTIME: $uptime
'
conky -t "$CONKY1" \
  | my_dzen -fn $FONT -e $EVENTSCLEARABLE -ta r -l 10 -w 300&


set_pos 182
CONKY2='^tw()${time %a %b %d ^fg(white)%I:%M^fg():%S%P}^p(5)
${execi 3600  (cal -3 | awk "BEGIN {print \\"^cs()\\"}; {print \\"^p(15)\\", \\$0}")} '
conky -t "$CONKY2" \
  | my_dzen -fn $BIGFONT -e $EVENTSCLEARABLE -ta r -w 550 -l 8 &

# vim:set nospell ts=4 sts=4 sw=4:
