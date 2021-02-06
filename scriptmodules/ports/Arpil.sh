#!/usr/bin/env bash

# This is an unofficial addon script to the RetroPie Project. This script has not been approved by 
# the RetroPie team, and is not an official package. 

rp_module_id="arpil"
rp_module_desc="Archipelago for RetroPie Launcher"
rp_module_licence="MIT https://github.com/Tallmyr/ARPIL/blob/main/LICENCE"
rp_module_help="Copy A Link to the Past Japan 1.0 ROM to $romdir/ports/Arpil"
rp_module_section="exp"

function depends_arpil() {
    getDepends jq python3 python3-pip
}

function sources_arpil() {
    gitPullOrClone "$md_build/arpil" "https://github.com/Tallmyr/ARPIL" "dev"
    commit=$(curl 'https://api.github.com/repos/Berserker66/MultiWorld-Utilities/tags?per_page=1' | jq -r '.[0].commit.sha')
    gitPullOrClone "$md_build/berserker" "https://github.com/Berserker66/MultiWorld-Utilities" "main" "$commit"
}

function install_arpil() {
    md_ret_files=(
        'arpil/LICENCE'
        'arpil/launcher.sh'
        'berserker'
    )
}

function configure_arpil() {
    addPort "$md_id" "arpil" "Arpil" "$md_inst/launcher.sh"
    rmDirExists "$romdir/ports/$md_id/berserker"

    [[ "$md_mode" = "remove" ]] && return
    chown -R "$user":"$user" "$md_inst/launcher.sh"
    chmod +x "$md_inst/launcher.sh"
    pip3 install -r "$md_inst/berserker/requirements.txt"

    mkRomDir ports/"$md_id"/output
    mkRomDir ports/"$md_id"/roms
    mkRomDir ports/"$md_id"/YAML

    cp "$md_inst/berserker/playerSettings.yaml" "$romdir/ports/$md_id/YAML/playerSettings.yaml" 
    mv "$md_inst/berserker" "$romdir/ports/$md_id"
}
