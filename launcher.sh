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
BERSERKER="/$PORTS/berserker"

#Set constants
HEIGHT=0
WIDTH=80
BACKTITLE="Archipelago for RetroPie Launcher"

#Bootup Tests - This makes sure that the Romfile exist, otherwize throws an error with instructions
romcheck() {
    ZELDA="Zelda no Densetsu - Kamigami no Triforce (Japan).sfc"
    FILE="$ZELDA"
    if [ -f "$FILE" ]; then
        main
    else
        dialog --clear \
            --title "Error" \
            --backtitle "$BACKTITLE" \
            --msgbox "Zelda no Densetsu - Kamigami no Triforce (Japan).sfc was not found. Please add this to the Ports/$SCRIPTID rom folder ($PORTS)" 10 80
    fi
}

#New Game
# shellcheck disable=SC2068,SC2128
newgame() {
    unset options
    #Get list of available YAML's
    yamllist=("$YAML"/*.yaml)
    i=0
    #Convert to list that works with Dialog
    for yaml in "${yamllist[@]}"; do
        ((i = i + 1))
        options+=("$i ${yaml##*/}")
    done

    #New Game Dialog
    TITLE="New Game"
    MENU="Select your YAML file:"

    CHOICE=$(dialog --clear \
        --backtitle "$BACKTITLE" \
        --title "$TITLE" \
        --menu "$MENU" \
        "$HEIGHT" "$WIDTH" "$i" \
        ${options[@]} \
        2>&1 >/dev/tty)

    clear

    #If cancel, return to main
    [ -z "$CHOICE" ] && main

    #run Berserker Mystery
    python3 "$BERSERKER"/Mystery.py --weights "${yamllist[$CHOICE - 1]}" --outputpath "$PORTS/output"

    #Move rom to the right dir and rename to Date and Time
    dt=$(date '+%d%m%Y-%H%M%S')
    oldrom=("$PORTS"/output/*.sfc)
    newrom="$PORTS/roms/$dt.sfc"
    echo "$oldrom"
    mv "$oldrom" "$newrom"

    #Launch Game using default SNES settings
    /opt/retropie/supplementary/runcommand/runcommand.sh 0 _SYS_ snes "$newrom"

}

# shellcheck disable=SC2068,SC2128
continuegame() {
    unset options
    #Get list of available ROMS's
    romlist=("$ROMS"/*.sfc)
    i=0
    #Convert to list that works with Dialog
    for rom in "${romlist[@]}"; do
        [ "$rom" = "$ROMS/*.sfc" ] && main
        ((i = i + 1))
        options+=("$i ${rom##*/}")
    done

    #List Roms
    TITLE="Continue Game"
    MENU="Select your ROM file:"

    CHOICE=$(dialog --clear \
        --backtitle "$BACKTITLE" \
        --title "$TITLE" \
        --menu "$MENU" \
        "$HEIGHT" "$WIDTH" "$i" \
        ${options[@]} \
        2>&1 >/dev/tty-)

    clear
    #If cancel, return to main
    [ -z "$CHOICE" ] && main

    #Set rom path
    rom="${romlist[$CHOICE - 1]}"

    #Launch Game using default SNES settings
    /opt/retropie/supplementary/runcommand/runcommand.sh 0 _SYS_ snes "$rom"
}
# shellcheck disable=SC2068,SC2128
deletegame() {
    unset options
    #Get list of available ROMS's
    romlist=("$ROMS"/*.sfc)
    i=0
    #Convert to list that works with Dialog
    for rom in "${romlist[@]}"; do
        [ "$rom" = "$ROMS/*.sfc" ] && main
        ((i = i + 1))
        options+=("$i ${rom##*/}")
    done

    #List Roms
    TITLE="Delete Game"
    MENU="What Rom do you wish to delete?:"

    CHOICE=$(dialog --clear \
        --backtitle "$BACKTITLE" \
        --title "$TITLE" \
        --menu "$MENU" \
        "$HEIGHT" "$WIDTH" "$i" \
        ${options[@]} \
        2>&1 >/dev/tty)

    clear
    #If cancel, return to main
    [ -z "$CHOICE" ] && main

    #Set rom path
    rom="${romlist[$CHOICE - 1]}"

    #Confirm
    dialog --title "Delete Rom" \
        --backtitle "Linux Shell Script Tutorial Example" \
        --yesno "Are you sure you want to permanently delete ${rom##*/}" 7 60
    response=$?
    case $response in
    0)
        dialog --title "Rom Deleted" \
            --backtitle "$BACKTITLE" \
            --msgbox "Rom has been deleted."
        rm "$rom"
        deletegame
        ;;
    1)
        dialog --title "Rom Deleted" \
            --backtitle "$BACKTITLE" \
            --msgbox "Rom has been deleted."
        deletegame
        ;;
    esac
}

#Main Menu
main() {
    unset options
    #Main Menu Dialog
    TITLE="Main Menu"
    MENU="Choose one of the following options:"

    OPTIONS=(1 "New Game")

    count=$(find "$ROMS"/*.sfc | wc -l)
    if [ "$count" != 0 ]
    then 
    read -p "Thingy exists"
    OPTIONS+=(2 "Continue Game"
              3 "Delete Game")
    fi 

    OPTIONS+=(4 "Exit")


    CHOICE=$(dialog --clear \
        --backtitle "$BACKTITLE" \
        --title "$TITLE" \
        --no-cancel \
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
