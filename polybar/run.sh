#!/usr/bin/env bash

mkdir -p ~/.polybar/pid/

if [[ "$DISPLAY_MODE" == "mobile" ]]; then
    ########################
    # Bars for mobile view #
    ########################
    polybar-msg -p $(cat ~/.polybar/pid/mobile_top) cmd quit

    echo "---" | tee -a /tmp/polybar_mobile_top.log

    polybar -c ~/dotfiles/polybar/config.ini mobile_top >> /tmp/polybar_mobile_top.log 2>&1 &
    echo $! > ~/.polybar/pid/mobile_top

    echo "Mobile topbar launched..."

    polybar-msg -p $(cat ~/.polybar/pid/mobile_bottom) cmd quit

    echo "---" | tee -a /tmp/polybar_mobile_bottom.log

    polybar -c ~/dotfiles/polybar/config.ini mobile_bottom >> /tmp/polybar_mobile_bottom.log 2>&1 &
    echo $! > ~/.polybar/pid/mobile_bottom

    echo "Mobile bottombar launched..."
else
    ######################
    # Topbar for desktop #
    ######################
    polybar-msg -p $(cat ~/.polybar/pid/topbar) cmd quit

    echo "---" | tee -a /tmp/polybar_topbar.log

    polybar -c ~/dotfiles/polybar/config.ini topbar >> /tmp/polybar_topbar.log 2>&1 &
    echo $! > ~/.polybar/pid/topbar

    echo "Topbar launched..."
fi
