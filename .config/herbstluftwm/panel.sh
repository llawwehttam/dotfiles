#!/bin/bash

set -f

monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi
# geometry has the format: WxH+X+Y
x=${geometry[0]}
y=${geometry[1]}
panel_width=${geometry[2]}
panel_height=16
font="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"
#font="-misc-inconsolata-medium-r-normal--0-0-0-0-p-0-iso10646-1"
bgcolor="#3f3f3f" #$(herbstclient get frame_border_normal_color)
selbg=$(herbstclient get window_border_active_color)
selfg="#dcdccc" #'#101010'
textwidth="textwidth";

# Functions
function uniq_linebuffered() {
    awk '$0 != l { print ; l=$0 ; fflush(); }' "$@"
}

function vol() {
	pulsevol=$(~/.scripts/pulsevol.sh query | awk '{ print $2 }')
	pulsemute=$(~/.scripts/pulsevol.sh query | awk '{ print $4 }')
	if [ $pulsemute = "yes" ]; then
		pulsevol=$pulsevol" M"
	fi
}

function systemps() {
  temps=$(~/.scripts/sensors.sh -c)
}

herbstclient pad $monitor $panel_height
{
    # events:
    while true ; do
        date +'date ^fg(#efefef)%H:%M:%S^fg(#909090), %A ^fg(#efefef)%d^fg(#909090)-%m-%Y'
        sleep 1 || break
    done > >(uniq_linebuffered)  &
    childpid=$!
    herbstclient --idle
    kill $childpid
} 2> /dev/null | {
    TAGS=( $(herbstclient tag_status $monitor) )
    visible=true
    date=""
    windowtitle=""
    while true ; do
        bordercolor="#26221C"
        separator="^bg()^fg($selbg)|"
        # draw tags
        for i in "${TAGS[@]}" ; do
            case ${i:0:1} in
                '#')
                    echo -n "^bg(#019FDE)^fg(#141414)"
                    ;;
                '+')
                    echo -n "^bg(#CC7F4C)^fg(#141414)"
                    ;;
                '-')
                    echo -n "^bg(#DFAF8F)^fg(#141414)"
                    ;;
                '%')
                    echo -n "^bg(#60b48a)^fg(#141414)"
                    ;;
                ':')
                    echo -n "^bg()^fg(#ffffff)"
                    ;;
                '!')
                    echo -n "^bg(#FF0675)^fg(#141414)"
                    ;;
                *)
                    echo -n "^bg()^fg(#ababab)"
                    ;;
            esac
            if [ ! -z "$dzen2_svn" ] ; then
                echo -n "^ca(1,herbstclient focus_monitor $monitor && "'herbstclient use "'${i:1}'") '"${i:1} ^ca()"
            else
                echo -n " ${i:1} "
            fi
        done
        echo -n "$separator"
        echo -n "^bg()^fg() ${windowtitle//^/^^}"
        # small adjustments
        vol
        systemps
        right="$separator^fg(#efefef) $temps $separator^fg(#efefef) Vol: $pulsevol $separator $date $separator"
        right_text_only=$(echo -n "$right"|sed 's.\^[^(]*([^)]*)..g')
        # get width of right aligned text.. and add some space..
        width=$($textwidth "$font" "$right_text_only")
        echo -n "^pa($(($panel_width - $width)))$right"
        echo
        # wait for next event
        read line || break
        cmd=( $line )
        # find out event origin
        case "${cmd[0]}" in
            tag*)
                #echo "reseting tags" >&2
                TAGS=( $(herbstclient tag_status $monitor) )
                ;;
            date)
                #echo "reseting date" >&2
                date="${cmd[@]:1}"
                ;;
            quit_panel)
                exit
                ;;
            togglehidepanel)
                echo "^togglehide()"
                if $visible ; then
                    visible=false
                    herbstclient pad $monitor 0
                else
                    visible=true
                    herbstclient pad $monitor $panel_height
                fi
                ;;
            reload)
                exit
                ;;
            focus_changed|window_title_changed)
                windowtitle="${cmd[@]:2}"
                ;;
            #player)
            #    ;;
        esac
        done
} 2> /dev/null | dzen2 -w $panel_width -x $x -y $y -fn $font -h $panel_height -ta l -bg "$bgcolor" -fg '#dcdccc'
