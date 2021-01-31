# Archipelago for RetroPie Laucher

***This is currently unreleased. This is still under development. Look at Dev branches for progress.***

## What is this?

This is RetroPie "Ports" script to install Berserker MultiWorld and generate games from a handy menu.
This will automatically download and install Berserker MultiWorld from source, and allow you to create your own Randomized Zelda 3 games with right from your couch.

This project is not endorsed or connected to either RetroPie or Berserker MultiWorld. You can find these projects here:

[Berserker MultiWorld](https://berserkermulti.world/) - [Github](https://github.com/Berserker66/MultiWorld-Utilities)

[RetroPie](https://retropie.org.uk/)

## How to install?

1. Download arpil.sh from releases and copy to the ports scriptmodules folder on RPI:
*~/RetroPie-Setup/scriptmodules/ports*
2. Run RetroPie Setup and install the ARPIL package found under "ext".
3. Copy your A Link to the Past v1.0 Japan ROM to  *romdir*/ports/arpil/
4. Copy any YAML files you want to the YAML directory in *romdir*/ports/YAML
*(the default YAML is copied automatically)*

## FAQ

**Q: Why is this called "Archipelago" and not Berserker MultiWorld *something*?**

Berserker MultiWorld will be renamed soon, and I figured i'd be one step ahead.

**Q: Will this be included in RetroPie or RetroPie-Extras by default?**

Have not considered so far yet. It is possible

**Q: Does this support Multiworld, or just single player?**

First release is single player games only. Automating joining of Multiworld games are planned for later releases

**Q: Can't I just use the Archipelago website and copy the roms over?**

Of course you can. I wanted something more convinient, and more importantly, I was bored.
