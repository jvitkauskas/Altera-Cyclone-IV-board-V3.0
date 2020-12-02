#!/bin/sh
#
# generated.sh - shell script fragment - not very useful on its own
#
# Machine generated for a CPU named "cpu" as defined in:
# e:\AA_IO_BD\new\2.4TFT_ok\ColorbarforE4\software\TFT_software_syslib\..\..\nios32.ptf
#
# Generated: 2015-04-30 14:12:19.209

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
ptf=e:\AA_IO_BD\new\2.4TFT_ok\ColorbarforE4\software\TFT_software_syslib\..\..\nios32.ptf

# This variable indicates whether there is a CPU debug core
nios2_debug_core=yes

# This variable indicates how to connect to the CPU debug core
nios2_instance=0

# This variable indicates the CPU module name
nios2_cpu_name=cpu

# Include operating system specific parameters, if they are supplied.

if test -f /cygdrive/c/altera/11.0/nios2eds/components/altera_hal/build/os.sh ; then
   . /cygdrive/c/altera/11.0/nios2eds/components/altera_hal/build/os.sh
fi
