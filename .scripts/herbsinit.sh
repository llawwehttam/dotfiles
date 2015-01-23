#!/bin/bash
function hc() {
  herbstclient "$@"
}

# 1440p Monitor Index 9 - Sys
hc focus_monitor 2 && hc use_index 8 &&
hc split vertical 0.2 && hc spawn termite -t clock && sleep 0.3 &&
hc focus down && hc split horizontal 0.65 && hc spawn termite -t processes && sleep 0.3 &&
hc focus right && hc spawn termite -t torrent && sleep 0.3 &&

# Monitor 1 Index 1 - Main 1
hc focus_monitor 0 && hc use_index 0 &&
hc split horizontal 0.3 && hc split vertical 0.3 && hc spawn termite -t archey && sleep 0.3 &&
hc focus down && hc spawn termite -t rss && sleep 0.3 &&
hc focus right && hc spawn termite && sleep 0.3 &&

# Monitor 2 Index 8 - MusIrc
hc focus_monitor 1 && hc use_index 7 &&
hc split horizontal &&
hc spawn termite -t music && sleep 0.3 &&
hc focus right && hc spawn termite -t irc && sleep 0.3 &&
hc focus_monitor 0
