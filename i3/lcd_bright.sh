#!/bin/bash
#
# lcd_bright.sh v0.1a
#
# Mark H. Harris
# 08/31/2017
#
# Usage:  lcd_bright.sh <U|D> <value>
#

MODE=`echo $1 | tr '[a-z]' '[A-Z]'`
BRIGHTNESS='/sys/class/backlight/intel_backlight/brightness'
LCDVALUE=`cat $BRIGHTNESS` 

if [ "$MODE" = "U" ]
then
  NEWVALUE=$(( $LCDVALUE + $2 ))
  if [ $NEWVALUE -le 937 ]
  then
      echo $NEWVALUE > $BRIGHTNESS
  else
      echo 937 > $BRIGHTNESS
  fi
else
  NEWVALUE=$(( $LCDVALUE - $2 ))
  if [ $NEWVALUE -ge 0 ]
  then
      echo $NEWVALUE > $BRIGHTNESS
  else
      echo 0 > $BRIGHTNESS
  fi
fi

cat $BRIGHTNESS
