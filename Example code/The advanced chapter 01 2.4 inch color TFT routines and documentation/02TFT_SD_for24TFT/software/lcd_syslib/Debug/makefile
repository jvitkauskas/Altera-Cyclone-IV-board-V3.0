# ********************************************************************** 
# 
# THIS IS AN AUTO-GENERATED FILE. DO NOT EDIT DIRECTLY
# 
# To change the settings in here:
# 		- Right click on the project
#		- Select "Properties" option
#       - Use property pages to set options. Details given below 
#
# ********************************************************************** 
 
# These flags can be set from C/C++ build property page -> nios2-elf-gcc -> General
CFLAGS = -DALT_DEBUG -O0 -g -Wall

ASFLAGS = -Wa,-gdwarf2

# These flags can be set from C/C++ build property page -> nios2-elf-ar.archiver -> General
ARFLAGS = -src

# This project
SYSTEM_NAME := lcd_syslib
# Location of this project
SYSTEM_DIR := /cygdrive/e/AA_IO_BD/new/TFT_SD_for24TFT/lcd_at_nios_qii_part/software/lcd_syslib

# Configuration for system library project
# The configuration can be changed from system library properties -> C/C++ build -> Configuration drop-down box.
# If changed a new configuration folder (e.g. Release) is generated with all the generated and built files
SYS_CONFIG := Debug

PTF := /cygdrive/e/AA_IO_BD/new/TFT_SD_for24TFT/lcd_at_nios_qii_part/nios_ii_sys.ptf

RM := rm -rf


# **********************************************************************
# Check for a space in the environment var SOPC_KIT_NIOS2

space = $(empty) $(empty)
space-to-question = $(subst $(space),?,$1)

HOST_OS :=  $(shell uname | head -c 3 | tr [:upper:] [:lower:])

SOPC_KIT_NIOS2 := $(strip $(SOPC_KIT_NIOS2))
ifneq ($(call space-to-question,$(SOPC_KIT_NIOS2)),$(SOPC_KIT_NIOS2))
# If there is a space in your SOPC_KIT_NIOS2 path, then it must be
# fixed.
ifeq ($(HOST_OS),cyg)
# Use short 8.3 dos path on Windows/Cygwin
SOPC_KIT_NIOS2 := $(shell cygpath --dos "$(SOPC_KIT_NIOS2)")
else
# Use a symlink to a unique dir in /tmp/altera_nios2 dir on Unix
SHELL := /bin/bash
USER = $(shell whoami)
DATE = $(shell date +%Y-%m-%d)
TMP_DIR = /tmp/altera_nios2-$(USER)
CREATE_TMP_DIR := $(shell mkdir -p $(TMP_DIR))
NIOS_VERSION_ID := $(shell nios2-elf-gcc -v 2>&1 | grep Altera | sed -e 's/[^0-9]//g')
TMP_SOPC_KIT_NIOS2 := $(TMP_DIR)/altera_nios2_kit_tmp-$(DATE)-$(NIOS_VERSION_ID)
CREATE_TMP_NIOS_DIR_CMD := if [ ! -d $(TMP_SOPC_KIT_NIOS2) ]; then ln -s "$(SOPC_KIT_NIOS2)" "$(TMP_SOPC_KIT_NIOS2)"; fi
CREATE_TMP_NIOS_DIR := $(shell $(CREATE_TMP_NIOS_DIR_CMD))
SOPC_KIT_NIOS2 := $(TMP_SOPC_KIT_NIOS2)
endif

export SOPC_KIT_NIOS2
endif
# **********************************************************************

# Include makefile for the OS we are building on as specified in system library project
SYSTEM_MAKEFILE := $(SOPC_KIT_NIOS2)/components/altera_hal/build/system.mk
include $(SYSTEM_MAKEFILE)

includes:
	@echo $(CC) -DALTERA_INCLUDES -S $(CPPFLAGS) $(CFLAGS) $(GTF_GENERATED)/$(firstword $(C_SRCS))

