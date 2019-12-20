#!/bin/zsh

#set -x

if [ $# -ne 1 ]
then
  echo "Usage: set_wallpaper [ /file/path ]"
  echo "Please only provide one file."
  exit;
elif [[ ! -e $1 ]]
then
  echo "File is not valid"
  exit;
elif [[ ! -f $1 ]]
then
  echo "Please provide a file"
  exit;
fi

echo "Cleaning up old wallpapers"

rm -rf ~/.wallpaper/
mkdir -p ~/.wallpaper/
echo '' > ~/.fehbg

# kill previous instances of the wallpaper monitoring script
ps -ef | command grep "[s]h `which wallpaper_focus.sh`" | awk '{print $2}' | xargs kill 2>/dev/null

img=$1

echo "Detecting monitors..."
INT_CONNECTED_MON=$(xrandr | command egrep "eDP[-0-9]* connected")
EXT_CONNECTED_MON=$(xrandr | command egrep "HDMI[-0-9]* connected")

INT_MON_NAME=$(echo "$INT_CONNECTED_MON" | command egrep -o "eDP[-0-9]*")
EXT_MON_NAME=$(echo "$EXT_CONNECTED_MON" | command egrep -o "HDMI[-0-9]*")

INT_MON_RES=$(echo "$INT_CONNECTED_MON" | command egrep -o "[0-9]{4}x[0-9]{3,4}")
EXT_MON_RES=$(echo "$EXT_CONNECTED_MON" | command egrep -o "[0-9]{4}x[0-9]{3,4}")

if [[ -z $INT_MON_NAME || -z $INT_MON_RES || -z $EXT_MON_NAME || -z $EXT_MON_RES ]]; then
  # copy without any transformations
  echo "Failed to detect monitors. Using clean image"
  cp $img ~/.wallpaper/$INT_MON_NAME
  cp $img ~/.wallpaper/$EXT_MON_NAME
  echo "Done!"
  exit
fi

echo "Creating images, please wait..."
blur_coefficient=5
A=$(echo "($blur_coefficient + 1) * 2.4" | bc -l)
B=$(echo "($blur_coefficient + 1) * 1.2" | bc -l)

# blur left (internal) image - for when EXT is focused
convert \
  <(convert $img -blur $A,$B -resize "${INT_MON_RES}^" -gravity center -extent ${INT_MON_RES} - ) \
  <(convert $img -resize "${EXT_MON_RES}^" -gravity center -extent ${EXT_MON_RES} - ) \
  +append \
  ~/.wallpaper/$EXT_MON_NAME
# blur right (external) image - for when INT is focused
convert \
  <(convert $img -resize "${INT_MON_RES}^" -gravity center -extent ${INT_MON_RES} - ) \
  <(convert $img -blur $A,$B -resize "${EXT_MON_RES}^" -gravity center -extent ${EXT_MON_RES} -) \
  +append \
  ~/.wallpaper/$INT_MON_NAME

echo "Done !"

wallpaper_focus.sh &
