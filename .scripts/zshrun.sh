#!/bin/bash

# Window Choices

if [ "$DISPLAY" ]; then
  WINTITLE=$(xprop -id $WINDOWID | awk '/WM_NAME/{print $3; exit}' | tr -d '"')
  if [[ $WINTITLE != "Termite" ]] ; then
    case $WINTITLE in
      "clock")
        tty-clock -csC 3
        ;;

      "irc")
        weechat
        ;;

      "music")
        ncmpcpp
        ;;

      "archey")
        watch -c archey3
        ;;

      "processes")
        htop
        ;;

      "rss")
        newsbeuter
        ;;

      "torrent")
        rtorrent
        ;;

    esac;
  fi
else
  exit 0
fi
#echo $WINTITLE
