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
BERSERKER="/opt/retropie/ports/$SCRIPTID/berserker"

#Set constants
HEIGHT=40
WIDTH=80
BACKTITLE="Archipelago for RetroPie Launcher"

#Bootup Tests - This makes sure that the Romfile exist, otherwize throws an error with instructions
romcheck() {
    ZELDA="Zelda no Densetsu - Kamigami no Triforce (Japan).sfc"
    echo "Check if rom exist"
    FILE="$ZELDA"
    if [ -f "$FILE" ]; then
        pause
        main
    else
        dialog --clear \
            --title "Error" \
            --msgbox "Zelda no Densetsu - Kamigami no Triforce (Japan).sfc was not found. Please add this to the Ports/$SCRIPTID rom folder ($PORTS)" $HEIGHT $WIDTH
    fi
}

#New Game
# shellcheck disable=SC2068,SC2128
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

    clear
    #run Berserker Mystery
    python3 "$BERSERKER"/Mystery.py --weights "${yamllist[$CHOICE]}" --outputpath "$PORTS/output"

    #Move rom to the right dir and rename to Date and Time
    dt=$(date '+%d%m%Y-%H%M%S')
    oldrom=("$PORTS"/output/*.sfc)
    newrom="$PORTS/roms/$dt.sfc"
    echo "$oldrom"
    mv "$oldrom" "$newrom"

    #Launch Game using default SNES settings
    /opt/retropie/supplementary/runcommand/runcommand.sh 0 _SYS_ snes "$newrom"
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
cd "$PORTS" || exit
romcheck

#Stop joy2key
joy2keyStop
