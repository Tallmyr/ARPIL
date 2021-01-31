#!/bin/bash
# shellcheck source=../RetroPie-Setup/scriptmodules/helpers.sh
#setup required sources for joy2key
scriptdir="$HOME/RetroPie-Setup"
source "$HOME/RetroPie-Setup/scriptmodules/helpers.sh"

#start joy2key
joy2keyStart


#Main Menu
main() {
HEIGHT=15
WIDTH=40
BACKTITLE="Archipelago for RetroPie Launcher"
TITLE="Main Menu"
MENU="Choose one of the following options:"

OPTIONS=(1 "New Game"
         2 "Continue Game"
         3 "Delete Game"
         4 "Exit")

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH 4 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear
case $CHOICE in
        1)
           newgame
            ;;
        2)
            continuegame
            ;;
        3)
            deletegame
            ;;
        4)
            exit
            ;;
esac
}

#Launch Main Menu
main

#Stop joy2key
joy2keyStop
