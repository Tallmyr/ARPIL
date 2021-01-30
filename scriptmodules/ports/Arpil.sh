#!/usr/bin/env bash

# This is an unofficial addon script to the RetroPie Project. This script has not been approved by 
# the RetroPie team, and is not an official package.

rp_module_id="arpil"
rp_module_desc="Archipelago for RetroPie Launcher"
rp_module_licence="MIT https://github.com/Tallmyr/ARPIL/blob/main/LICENCE"
rp_module_help="Copy A Link to the Past Japan 1.0 ROM to $romdir/ports/Arpil"
rp_module_section="exp"

function sources_arpil() {
    gitPullOrClone "$md_build" "https://github.com/Tallmyr/ARPIL" "dev"
}

function install_arpil() {
    md_ret_files=(
        'LICENCE'
        'launcher.sh'
    )
}

function configure_arpil() {
    addPort "$md_id" "arpil" "Arpil" "$md_inst/launcher.sh"

    [[ "$md_mode" != "install" ]] && return
}