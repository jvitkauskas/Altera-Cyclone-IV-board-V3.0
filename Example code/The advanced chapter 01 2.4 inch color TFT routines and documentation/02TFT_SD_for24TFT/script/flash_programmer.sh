#!/bin/sh
#
# This file was automatically generated.
#
# It can be overwritten by nios2-flash-programmer-generate or nios2-flash-programmer-gui.
#

#
# Converting SOF File: D:\Amy-S\lcd\lcd_at_nios.sof to: "..\flash/lcd_at_nios_epcs.flash"
#
bin/sof2flash --input="D:/Amy-S/lcd/lcd_at_nios.sof" --output="../flash/lcd_at_nios_epcs.flash" --epcs --verbose 

#
# Programming File: "..\flash/lcd_at_nios_epcs.flash" To Device: epcs
#
bin/nios2-flash-programmer "../flash/lcd_at_nios_epcs.flash" --base=0x3001800 --epcs --sidp=0x3002068 --id=0x24702180 --timestamp=1290604208 --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-0]' --program --verbose 

#
# Converting ELF File: D:\Amy-S\lcd\software\lcd_at_nios\lcd_at_nios.elf to: "..\flash/lcd_at_nios_epcs_1_.flash"
#
bin/elf2flash --input="D:/Amy-S/lcd/software/lcd_at_nios/lcd_at_nios.elf" --output="../flash/lcd_at_nios_epcs_1_.flash" --epcs --after="../flash/lcd_at_nios_epcs.flash" --verbose 

#
# Programming File: "..\flash/lcd_at_nios_epcs_1_.flash" To Device: epcs
#
bin/nios2-flash-programmer "../flash/lcd_at_nios_epcs_1_.flash" --base=0x3001800 --epcs --sidp=0x3002068 --id=0x24702180 --timestamp=1290604208 --device=1 --instance=0 '--cable=USB-Blaster on localhost [USB-0]' --program --verbose --go 

