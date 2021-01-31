#!/bin/bash
# shellcheck source=../RetroPie-Setup/scriptmodules/helpers.sh
#setup required sources for joy2key
scriptdir="$HOME/RetroPie-Setup"
source "$HOME/RetroPie-Setup/scriptmodules/helpers.sh"
SCRIPTID="arpil"

#start joy2key
joy2keyStart

#Set folders
PORTS="$HOME/RetroPie/roms/ports/$SCRIPTID"
YAML="$PORTS/YAML"
ROMS="$PORTS/roms"

#Set constants
HEIGHT=15
WIDTH=40
BACKTITLE="Archipelago for RetroPie Launcher"

#New Game
# shellcheck disable=SC2068
newgame() {

    #Get list of available YAML's
    yamllist=("$YAML"/*.yaml)
    i=0
    #Convert to list that works with Dialog
    for yaml in "${yamllist[@]}"; do
        options+=("$i ${yaml##*/}")
        ((i = i + 1))
    done

    #New Game Dialog
    TITLE="New Game"
    MENU="Select your YAML file:"

    CHOICE=$(dialog --clear \
        --backtitle "$BACKTITLE" \
        --title "$TITLE" \
        --menu "$MENU" \
        $HEIGHT $WIDTH 3 \
        ${options[@]} \
        2>&1 >/dev/tty)

    #Print selected YAML
    echo "${yamllist[$CHOICE]}"
}

#Main Menu
main() {

    #Main Menu Dialog
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
