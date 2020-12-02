#!/bin/sh
#
# generated.sh - shell script fragment - not very useful on its own
#
# Machine generated for a CPU named "nios_f" as defined in:
# e:\AA_IO_BD\new\TFT_SD_for24TFT\lcd_at_nios_qii_part\software\lcd_syslib\..\..\nios_ii_sys.ptf
#
# Generated: 2015-04-17 20:45:11.257

# DO NOT MODIFY THIS FILE
#
#   Changing this file will have subtle consequences
#   which will almost certainly lead to a nonfunctioning
#   system. If you do modify this file, be aware that your
#   changes will be overwritten and lost when this file
#   is generated again.
#
# DO NOT MODIFY THIS FILE

# This variable indicates where the PTF file for this design is located
ptf=e:\AA_IO_BD\new\TFT_SD_for24TFT\lcd_at_nios_qii_part\software\lcd_syslib\..\..\nios_ii_sys.ptf

# This variable indicates whether there is a CPU debug core
nios2_debug_core=yes

# This variable indicates how to connect to the CPU debug core
nios2_instance=0

# This variable indicates the CPU module name
nios2_cpu_name=nios_f

# These variables indicate what the System ID peripheral should hold
sidp=0x03002068
id=0u
timestamp=1429273175u

# Include operating system specific parameters, if they are supplied.

if test -f /cygdrive/c/altera/11.1sp2/nios2eds/components/altera_hal/build/os.sh ; then
   . /cygdrive/c/altera/11.1sp2/nios2eds/components/altera_hal/build/os.sh
fi
