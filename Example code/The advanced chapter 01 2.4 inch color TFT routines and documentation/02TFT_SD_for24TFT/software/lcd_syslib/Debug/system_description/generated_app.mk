# generated_app.mk
#
# Machine generated for a CPU named "nios_f" as defined in:
# e:\AA_IO_BD\new\TFT_SD_for24TFT\lcd_at_nios_qii_part\software\lcd_syslib\..\..\nios_ii_sys.ptf
#
# Generated: 2015-04-17 20:44:41.634

# DO NOT MODIFY THIS FILE
#
#   Changing this file will have subtle consequences
#   which will almost certainly lead to a nonfunctioning
#   system. If you do modify this file, be aware that your
#   changes will be overwritten and lost when this file
#   is generated again.
#
# DO NOT MODIFY THIS FILE

# assuming the Quartus project directory is the same as the PTF directory
QUARTUS_PROJECT_DIR = E:/AA_IO_BD/new/TFT_SD_for24TFT/lcd_at_nios_qii_part

# the simulation directory is a subdirectory of the PTF directory
SIMDIR = $(QUARTUS_PROJECT_DIR)/nios_ii_sys_sim

DBL_QUOTE := "


# macros defined by/for epcs
EPCS_BOOT_ROM_FLASHTARGET_ALT_SIM_PREFIX = $(EPCS_BOOT_ROM_FLASHTARGET_TMP1:0=)
EPCS_BOOT_ROM_FLASHTARGET_TMP1 = $(ALT_SIM_OPTIMIZE:1=RUN_ON_HDL_SIMULATOR_ONLY_)
BOOTS_FROM_EPCS = 1
BOOT_COPIER_EPCS = boot_loader_epcs.srec
CPU_CLASS = altera_nios2
CPU_RESET_ADDRESS = 0x3001800


all: delete_placeholder_warning sim flashfiles

delete_placeholder_warning: do_delete_placeholder_warning
.PHONY: delete_placeholder_warning

sim: $(SIMDIR)/dummy_file
.PHONY: sim

flashfiles: $(EPCS_BOOT_ROM_FLASHTARGET_ALT_SIM_PREFIX)epcs_boot_rom.flash
.PHONY: flashfiles

verifysysid: dummy_verifysysid_file
.PHONY: verifysysid

do_delete_placeholder_warning:
	rm -f $(SIMDIR)/contents_file_warning.txt
.PHONY: do_delete_placeholder_warning

$(SIMDIR)/dummy_file: $(ELF)
	if [ ! -d $(SIMDIR) ]; then mkdir $(SIMDIR) ; fi
	@echo Hardware simulation is not enabled for the target SOPC Builder system. Skipping creation of hardware simulation model contents and simulation symbol files. \(Note: This does not affect the instruction set simulator.\)
	touch $(SIMDIR)/dummy_file

$(EPCS_BOOT_ROM_FLASHTARGET_ALT_SIM_PREFIX)epcs_boot_rom.flash: $(ELF)
	@if [ $(BOOTS_FROM_EPCS) -eq 1 ]; then echo Post-processing to create $(notdir $@) ; elf2flash --input=$(ELF) --flash= --boot=$(DBL_QUOTE)$(shell $(DBL_QUOTE)$(QUARTUS_ROOTDIR)/sopc_builder/bin/find_sopc_component_dir$(DBL_QUOTE) $(CPU_CLASS) $(QUARTUS_PROJECT_DIR))/$(BOOT_COPIER_EPCS)$(DBL_QUOTE) --outfile=$(EPCS_BOOT_ROM_FLASHTARGET_ALT_SIM_PREFIX)epcs_boot_rom.flash --sim_optimize=$(ALT_SIM_OPTIMIZE) --epcs --base=0x0 --end=0x7FFFFFFF  ; fi

dummy_verifysysid_file:
	nios2-download $(JTAG_CABLE)                                --sidp=0x03002068 --id=0 --timestamp=1429273175
.PHONY: dummy_verifysysid_file


generated_app_clean:
	$(RM) $(SIMDIR)/dummy_file
	$(RM) $(EPCS_BOOT_ROM_FLASHTARGET_ALT_SIM_PREFIX)epcs_boot_rom.flash
.PHONY: generated_app_clean
