#!/bin/bash
#
# Usage:  kbd_bright.sh <U|D>

MODE=`echo $1 | tr '[a-z]' '[A-Z]'`
BRIGHTNESS='/sys/class/leds/asus::kbd_backlight/brightness'
KBDVALUE=`cat $BRIGHTNESS` 

if [ "$MODE" = "U" ]
then
  NEWVALUE=$(( $KBDVALUE + 1 ))
  if [ $NEWVALUE -le 3 ]
  then
      echo $NEWVALUE > $BRIGHTNESS
  else
      echo 3 > $BRIGHTNESS
  fi
else
  NEWVALUE=$(( $KBDVALUE - 1 ))
  if [ $NEWVALUE -ge 0 ]
  then
      echo $NEWVALUE > $BRIGHTNESS
  else
      echo 0 > $BRIGHTNESS
  fi
fi

cat $BRIGHTNESS
