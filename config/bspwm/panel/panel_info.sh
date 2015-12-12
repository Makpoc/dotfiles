#!/bin/bash
# source: https://bitbucket.org/Ippytraxx/dotfiles/src/4375ca07b865/.config/bspwm/?at=default -> info.sh
#set -x

HEIGHT=16
WIDTH=520
Y=0
X=1400
FG_COLOUR="#CCCCCC"
BG_COLOUR="#141415"
#FONT="PF Arma Five:size=7"
#FONT=-artwiz-cure-*-*-*-*-*-*-*-*-*-*-*-*
FONT="cure:size=8"

UPDATE_INTERVAL=60

ICON_COLOR="#019BAA"
SEP="^fg(#767676) | ^fg()"

BAR_STYLE="-w 33 -h 10 -s o -ss 1 -sw 4 -nonl"
BAR_FG_COLOR="#CCCCCC"
BAR_BG_COLOR="#333333"

NOW_PLAYING_ICON="/home/makpoc/.config/herbstluftwm/dzen2_icons/note.xbm"
NOW_PLAYING_FORMAT="%a - %t"

VOLUME_ICON="/home/makpoc/.config/herbstluftwm/dzen2_icons/spkr_01.xbm"
MUTE_ICON="/home/makpoc/.config/herbstluftwm/dzen2_icons/spkr_02.xbm"

CLOCK_ICON="/home/makpoc/.config/herbstluftwm/dzen2_icons/clock.xbm"
CLOCK_FORMAT="%H:%M"

PACMAN_ICON="/home/makpoc/.icons/sm4tik-icon-pack/xbm/pacman.xbm"

UPSPEED_ICON="/home/makpoc/.config/herbstluftwm/dzen2_icons/net_up_03.xbm"
DOWNSPEED_ICON="/home/makpoc/.config/herbstluftwm/dzen2_icons/net_down_03.xbm"

# -------------------------------------------- CACHES
PACMAN_CACHE_TIMEOUT=10
PACMAN_TIMER=0

# -------------------------------------------- FUNCTIONS

icon() 
{
    echo "^fg($ICON_COLOR)^i($1)^fg()"
}

bar() 
{
    echo $1 | gdbar $BAR_STYLE -fg $BAR_FG_COLOR -bg $BAR_BG_COLOR
}

now_playing() 
{
    mpc current
}

volume() 
{   
    mute=$(pamixer --get-mute)
    if [ "$mute" == "true" ]; then
        echo -n "$(icon $MUTE_ICON) "
    else
        echo -n "$(icon $VOLUME_ICON) "
    fi

    volume=$(pamixer --get-volume)
    echo -n "$(bar $volume)"
}

getclock() 
{
    echo `clock -f 'S[%a, %e %b - %H:%M:%S]'`
}

pacman_updates()
{
    # to work properly this function requires an
    # up-to-date pacman status. This can be
    # accomplished using the following root cron:
    # @hourly (date && pacman -Sy) >/var/log/hourly_pacman_updates.log 2>&1
    pacman=$(pacman -Qu | wc -l)
    result=""
    if [ $pacman -eq 0 ]; then
        result="up to date"
    elif [ $pacman -eq 1 ]; then
        result="$pacman update"
    else
        result="$pacman updates"
    fi

    echo "P$(icon $PACMAN_ICON) : [$result]"
}

PACMAN_VAL=$(pacman_updates)

downspeed()
{
    rx1=$(cat /sys/class/net/enp4s0/statistics/rx_bytes)
    sleep 2
    rx2=$(cat /sys/class/net/enp4s0/statistics/rx_bytes)
    rxdiff=$(echo $((rx2 -rx1)))
    rxtrue=$(echo "$((rxdiff /1024 / 2))")

    echo "$rxtrue kb/s"
}
upspeed()
{
    tx1=$(cat /sys/class/net/enp4s0/statistics/tx_bytes)
    sleep 2
    tx2=$(cat /sys/class/net/enp4s0/statistics/tx_bytes)
    txdiff=$(echo $((tx2 -tx1)))
    txtrue=$(echo "$((txdiff /1024 / 2))")
    
    echo "$txtrue kb/s"
}

# -------------------------------------------- SCRIPT EXECUTION LOOP, PIPED INTO DZEN2

while :; do
    if [ $PACMAN_TIMER -ge $PACMAN_CACHE_TIMEOUT ]; then
        PACMAN_TIMER=0
        PACMAN_VAL=$(pacman_updates)
    else
        PACMAN_TIMER=$((PACMAN_TIMER + 1))
    fi
    echo -n $PACMAN_VAL
    #echo $(getclock)
    echo

    sleep $UPDATE_INTERVAL
done

