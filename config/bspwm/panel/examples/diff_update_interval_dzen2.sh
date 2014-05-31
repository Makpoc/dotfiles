#!/bin/zsh
#
# Dzen statusbar, compiled from various sources
# Requires weather.com key and mocp
# Source: https://bbs.archlinux.org/viewtopic.php?pid=309200#p309200 (user quarks)
##################################################################

# Configuration
##################################################################
# Dzen's font
DZENFNT="-*-terminus-*-r-normal-*-*-120-*-*-*-*-iso8859-*"
# Dzen's background colour
DZENBG='#000000'
# Dzen's forground colour
DZENFG='#999999'
# Dzen's X position
DZENX=780
# Dzen's Y posit
DZENY=1
# Dzen's width
DZENWIDTH=2000
# Dzen's alignment (l=left c=center r=right)
DZENALIGN=l
# Gauge background colour
GAUGEBG='#323232'
# Gauge foreground colour
GAUGEFG='#8ba574'
# Path to your Dzen icons
ICONPATH=/home/quarks/dzen/dzen_bitmaps
# Network interface
INTERFACE=eth0
# Sound device for volume control
SNDDEVICE=Master
# Date formating
DATE_FORMAT='%A, %d.%m.%Y %H:%M:%S'
# What tiem zones to use
TIME_ZONES=(Australia/Sydney America/Los_Angeles America/New_York)
# Path to weather script
WEATHER_FORECASTER=/home/quarks/dzen/dzenWeather.pl
# Main loop interval in seconds
SLEEP=1

# Function calling intervals in seconds
DATEIVAL=20
GTIMEIVAL=60
CPUTEMPIVAL=60
MUSICIVAL=2
VOLUMEIVAL=1
# Update weather every 30 minutes
WEATHERIVAL=1800
##################################################################


# Time and date 
##################################################################
DATE_FORMAT='%A, %d.%m.%Y %H:%M:%S'

fdate() {
    date +${DATE_FORMAT}
}
##################################################################


# Global time
##################################################################
fgtime() {
    local i

    for i in $TIME_ZONES
        { print -n "${i:t}:" $(TZ=$i date +'%H:%M')' ' }
}
##################################################################

# CPU use
##################################################################
fcpu() {
   gcpubar -c 5 -i 0.1 -fg $GAUGEFG -bg $GAUGEBG -h 7 -w 70 | tail -1
}
##################################################################


# CPU temp   
##################################################################
fcputemp() {
   print -n ${(@)$(</proc/acpi/thermal_zone/THRM/temperature)[2,3]}
}
##################################################################


# HD partitions used and free space
##################################################################
fhd() {
   # Todo
}
##################################################################

# Network
##################################################################

# Here we remember the previous rx/tx counts
RXB=`cat /sys/class/net/${INTERFACE}/statistics/rx_bytes`
TXB=`cat /sys/class/net/${INTERFACE}/statistics/tx_bytes`


# MOCP song info and control
##################################################################
fmusic() {
   artist=`mocp -i | grep 'Artist' | cut -c 8-`
   songtitle=`mocp -i | grep 'SongTitle' | cut -c 11-`
   totaltime=`mocp -i | grep 'TotalTime' | cut -c 12-`
   currenttime=`mocp -i | grep 'CurrentTime' | cut -c 14-`
   state=`mocp -i | grep 'State' | cut -c 8-`
   print -n "$(echo $artist -$songtitle [)$(echo $currenttime/$totaltime] [)$(echo $state])"
}

# For Creative Audigy 2 ZS
fvolume() {
    percentage=`amixer sget Master | sed -ne 's/^.*Mono: .*\[\([0-9]*\)%\].*$/\1/p'`
    # print -n "$(echo $percentage | gdbar -fg $GAUGEFG -bg $GAUGEBG -h 7 -w 60)"

if [[ $percentage == 100 ]]
then
    print -n "$(echo $percentage | gdbar -fg '#319845' -bg $GAUGEBG -h 7 -w 60)" # Volume full
elif [[ $percentage -gt 50 ]]
then
    print -n "$(echo $percentage | gdbar -fg '#7CA655' -bg $GAUGEBG -h 7 -w 60)" # Volume half to full
elif [[ $percentage -gt 25 ]]
then
    print -n "$(echo $percentage | gdbar -fg $GAUGEFG -bg $GAUGEBG -h 7 -w 60)" # Volume quarter to half 
elif [[ $percentage -lt 26 ]]
then
    print -n "$(echo $percentage | gdbar -fg '#888E82' -bg $GAUGEBG -h 7 -w 60)" # Volume low to quarter
fi

}


# Command to toggle pause/unpause
TOGGLE="mocp -G"
# Command to increase the volume
CI="amixer -c0 sset Master 2dB+ >/dev/null"
# Command to decrease the volume
CD="amixer -c0 sset Master 2dB- >/dev/null"
##################################################################


# Weather script
##################################################################
fweather() {
   $WEATHER_FORECASTER
   }
##################################################################  



# Main function
##################################################################

DATECOUNTER=0;GTIMECOUNTER=0;CPUTEMPCOUNTER=0;MUSICCOUNTER=0;WEATHERCOUNTER=0;VOLUMECOUNTER=0

# Execute everything once
PDATE=$(fdate)
PGTIME=$(fgtime)
PCPU=$(fcpu)
PCPUTEMP=$(fcputemp)
PHD=$(fhd)
PVOLUME=$(fvolume)
PMUSIC=$(fmusic)
PWEATHER=$(fweather)

# Main loop
while :; do

PCPU=$(fcpu)
PHD=$(fhd)

   if [ $DATECOUNTER -ge $DATEIVAL ]; then
     PDATE=$(fdate)
     DATECOUNTER=0
   fi

   if [ $GTIMECOUNTER -ge $GTIMEIVAL ]; then
     PGTIME=$(fgtime)
     GTIMECOUNTER=0
   fi

   if [ $CPUTEMPCOUNTER -ge $CPUTEMPIVAL ]; then
     PCPUTEMP=$(fcputemp)
     CPUTEMPCOUNTER=0
   fi

   if [ $MUSICCOUNTER -ge $MUSICIVAL ]; then
     PMUSIC=$(fmusic)
     MUSICCOUNTER=0
   fi

   if [ $VOLUMECOUNTER -ge $VOLUMEIVAL ]; then
     PVOLUME=$(fvolume)
     VOLUMECOUNTER=0
   fi

   if [ $WEATHERCOUNTER -ge $WEATHERIVAL ]; then
     PWEATHER=$(fweather)
     WEATHERCOUNTER=0
   fi

    # Get new rx/tx counts
    RXBN=`cat /sys/class/net/${INTERFACE}/statistics/rx_bytes`
    TXBN=`cat /sys/class/net/${INTERFACE}/statistics/tx_bytes`

    # Calculate the rates
    # format the values to 4 digit fields
    RXR=$(printf "%4d\n" $(echo "($RXBN - $RXB) / 1024/${SLEEP}" | bc))
    TXR=$(printf "%4d\n" $(echo "($TXBN - $TXB) / 1024/${SLEEP}" | bc))

    # Print out 
    echo "| ^fg(#80AA83)^p(0)^i(${ICONPATH}/load.xbm) ^fg()${PCPU} | ^fg(#80AA83)^i(${ICONPATH}/temp.xbm)^fg()${PCPUTEMP}° | ${INTERFACE}:^fg(white)${RXR}kB/s^fg(#80AA83)^p(0)^i(${ICONPATH}/arr_down.xbm)^fg(white)${TXR}kB/s^fg(orange3)^p(0)^i(${ICONPATH}/arr_up.xbm)^fg() | ^fg()${PGTIME}| ^fg(#FFFFFF)${PDATE}   ^fg()Eindhoven: ^fg()${PWEATHER} | ^fg(#80AA83)^p(0)^i(${ICONPATH}/volume.xbm)^fg()${PVOLUME} | ^fg(#80AA83)^p(0)^i(${ICONPATH}/music.xbm)^fg()${PMUSIC}"

    # Reset old rates
    RXB=$RXBN; TXB=$TXBN

   DATECOUNTER=$((DATECOUNTER+1))
   GTIMECOUNTER=$((GTIMECOUNTER+1))
   CPUTEMPCOUNTER=$((CPUTEMPCOUNTER+1))
   WEATHERCOUNTER=$((WEATHERCOUNTER+1))
   MUSICCOUNTER=$((MUSICCOUNTER+1))
   VOLUMECOUNTER=$((VOLUMECOUNTER+1))

sleep $SLEEP

# Pass it to dzen
done | dzen2 -bg $DZENBG -fg $DZENFG -x $DZENX -y $DZENY -ta $DZENALIGN -h 16 -p -e "button2=exec:$TOGGLE;button4=exec:$CI;button5=exec:$CD" -fn $DZENFNT
