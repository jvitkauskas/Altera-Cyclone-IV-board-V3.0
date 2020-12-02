/* system.h
 *
 * Machine generated for a CPU named "nios_f" as defined in:
 * e:\AA_IO_BD\new\TFT_SD_for24TFT\lcd_at_nios_qii_part\software\lcd_syslib\..\..\nios_ii_sys.ptf
 *
 * Generated: 2015-04-17 20:42:26.102
 *
 */

#ifndef __SYSTEM_H_
#define __SYSTEM_H_

/*

DO NOT MODIFY THIS FILE

   Changing this file will have subtle consequences
   which will almost certainly lead to a nonfunctioning
   system. If you do modify this file, be aware that your
   changes will be overwritten and lost when this file
   is generated again.

DO NOT MODIFY THIS FILE

*/

/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2003 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
*                                                                             *
******************************************************************************/

/*
 * system configuration
 *
 */

#define ALT_SYSTEM_NAME "nios_ii_sys"
#define ALT_CPU_NAME "nios_f"
#define ALT_CPU_ARCHITECTURE "altera_nios2"
#define ALT_DEVICE_FAMILY "CYCLONEIVE"
#define ALT_STDIN "/dev/jtag_uart"
#define ALT_STDIN_TYPE "altera_avalon_jtag_uart"
#define ALT_STDIN_BASE 0x03002060
#define ALT_STDIN_DEV jtag_uart
#define ALT_STDIN_PRESENT
#define ALT_STDOUT "/dev/jtag_uart"
#define ALT_STDOUT_TYPE "altera_avalon_jtag_uart"
#define ALT_STDOUT_BASE 0x03002060
#define ALT_STDOUT_DEV jtag_uart
#define ALT_STDOUT_PRESENT
#define ALT_STDERR "/dev/jtag_uart"
#define ALT_STDERR_TYPE "altera_avalon_jtag_uart"
#define ALT_STDERR_BASE 0x03002060
#define ALT_STDERR_DEV jtag_uart
#define ALT_STDERR_PRESENT
#define ALT_CPU_FREQ 100000000
#define ALT_IRQ_BASE NULL
#define ALT_LEGACY_INTERRUPT_API_PRESENT

/*
 * processor configuration
 *
 */

#define NIOS2_CPU_IMPLEMENTATION "fast"
#define NIOS2_BIG_ENDIAN 0
#define NIOS2_INTERRUPT_CONTROLLER_ID 0

#define NIOS2_ICACHE_SIZE 4096
#define NIOS2_DCACHE_SIZE 0
#define NIOS2_ICACHE_LINE_SIZE 32
#define NIOS2_ICACHE_LINE_SIZE_LOG2 5
#define NIOS2_DCACHE_LINE_SIZE 0
#define NIOS2_DCACHE_LINE_SIZE_LOG2 0
#define NIOS2_FLUSHDA_SUPPORTED

#define NIOS2_EXCEPTION_ADDR 0x02800020
#define NIOS2_RESET_ADDR 0x03001800
#define NIOS2_BREAK_ADDR 0x03001020

#define NIOS2_HAS_DEBUG_STUB

#define NIOS2_CPU_ID_SIZE 1
#define NIOS2_CPU_ID_VALUE 0

/*
 * A define for each class of peripheral
 *
 */

#define __ALTERA_AVALON_NEW_SDRAM_CONTROLLER
#define __ALTERA_AVALON_EPCS_FLASH_CONTROLLER
#define __ALTERA_AVALON_JTAG_UART
#define __ALTERA_AVALON_SYSID
#define __ALTERA_AVALON_TIMER
#define __ALTERA_AVALON_PIPELINE_BRIDGE
#define __ALTERA_AVALON_PIO

/*
 * sdram configuration
 *
 */

#define SDRAM_NAME "/dev/sdram"
#define SDRAM_TYPE "altera_avalon_new_sdram_controller"
#define SDRAM_BASE 0x02800000
#define SDRAM_SPAN 8388608
#define SDRAM_REGISTER_DATA_IN 1
#define SDRAM_SIM_MODEL_BASE 1
#define SDRAM_SDRAM_DATA_WIDTH 16
#define SDRAM_SDRAM_ADDR_WIDTH 12
#define SDRAM_SDRAM_ROW_WIDTH 12
#define SDRAM_SDRAM_COL_WIDTH 8
#define SDRAM_SDRAM_NUM_CHIPSELECTS 1
#define SDRAM_SDRAM_NUM_BANKS 4
#define SDRAM_REFRESH_PERIOD 15.625
#define SDRAM_POWERUP_DELAY 100.0
#define SDRAM_CAS_LATENCY 2
#define SDRAM_T_RFC 70.0
#define SDRAM_T_RP 20.0
#define SDRAM_T_MRD 3
#define SDRAM_T_RCD 20.0
#define SDRAM_T_AC 5.5
#define SDRAM_T_WR 14.0
#define SDRAM_INIT_REFRESH_COMMANDS 2
#define SDRAM_INIT_NOP_DELAY 0.0
#define SDRAM_SHARED_DATA 0
#define SDRAM_SDRAM_BANK_WIDTH 2
#define SDRAM_TRISTATE_BRIDGE_SLAVE ""
#define SDRAM_STARVATION_INDICATOR 0
#define SDRAM_IS_INITIALIZED 1
#define ALT_MODULE_CLASS_sdram altera_avalon_new_sdram_controller

/*
 * epcs configuration
 *
 */

#define EPCS_NAME "/dev/epcs"
#define EPCS_TYPE "altera_avalon_epcs_flash_controller"
#define EPCS_BASE 0x03001800
#define EPCS_SPAN 2048
#define EPCS_IRQ 0
#define EPCS_IRQ_INTERRUPT_CONTROLLER_ID 0
#define EPCS_DATABITS 8
#define EPCS_TARGETCLOCK 20
#define EPCS_CLOCKUNITS "MHz"
#define EPCS_CLOCKMULT 1000000
#define EPCS_NUMSLAVES 1
#define EPCS_ISMASTER 1
#define EPCS_CLOCKPOLARITY 0
#define EPCS_CLOCKPHASE 0
#define EPCS_LSBFIRST 0
#define EPCS_EXTRADELAY 0
#define EPCS_TARGETSSDELAY 100
#define EPCS_DELAYUNITS "us"
#define EPCS_DELAYMULT "1e-006"
#define EPCS_PREFIX "epcs_"
#define EPCS_REGISTER_OFFSET 0x400
#define EPCS_IGNORE_LEGACY_CHECK 1
#define EPCS_USE_ASMI_ATOM 0
#define EPCS_CLOCKUNIT "kHz"
#define EPCS_DELAYUNIT "us"
#define EPCS_DISABLEAVALONFLOWCONTROL 0
#define EPCS_INSERT_SYNC 0
#define EPCS_SYNC_REG_DEPTH 2
#define ALT_MODULE_CLASS_epcs altera_avalon_epcs_flash_controller

/*
 * jtag_uart configuration
 *
 */

#define JTAG_UART_NAME "/dev/jtag_uart"
#define JTAG_UART_TYPE "altera_avalon_jtag_uart"
#define JTAG_UART_BASE 0x03002060
#define JTAG_UART_SPAN 8
#define JTAG_UART_IRQ 1
#define JTAG_UART_IRQ_INTERRUPT_CONTROLLER_ID 0
#define JTAG_UART_WRITE_DEPTH 64
#define JTAG_UART_READ_DEPTH 64
#define JTAG_UART_WRITE_THRESHOLD 8
#define JTAG_UART_READ_THRESHOLD 8
#define JTAG_UART_READ_CHAR_STREAM ""
#define JTAG_UART_SHOWASCII 1
#define JTAG_UART_RELATIVEPATH 1
#define JTAG_UART_READ_LE 0
#define JTAG_UART_WRITE_LE 0
#define JTAG_UART_ALTERA_SHOW_UNRELEASED_JTAG_UART_FEATURES 1
#define ALT_MODULE_CLASS_jtag_uart altera_avalon_jtag_uart

/*
 * sysid configuration
 *
 */

#define SYSID_NAME "/dev/sysid"
#define SYSID_TYPE "altera_avalon_sysid"
#define SYSID_BASE 0x03002068
#define SYSID_SPAN 8
#define SYSID_ID 0u
#define SYSID_TIMESTAMP 1429273175u
#define SYSID_REGENERATE_VALUES 0
#define ALT_MODULE_CLASS_sysid altera_avalon_sysid

/*
 * sys_clk_timer configuration
 *
 */

#define SYS_CLK_TIMER_NAME "/dev/sys_clk_timer"
#define SYS_CLK_TIMER_TYPE "altera_avalon_timer"
#define SYS_CLK_TIMER_BASE 0x03002000
#define SYS_CLK_TIMER_SPAN 32
#define SYS_CLK_TIMER_IRQ 2
#define SYS_CLK_TIMER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define SYS_CLK_TIMER_ALWAYS_RUN 1
#define SYS_CLK_TIMER_FIXED_PERIOD 1
#define SYS_CLK_TIMER_SNAPSHOT 0
#define SYS_CLK_TIMER_PERIOD 1
#define SYS_CLK_TIMER_PERIOD_UNITS "ms"
#define SYS_CLK_TIMER_RESET_OUTPUT 0
#define SYS_CLK_TIMER_TIMEOUT_PULSE_OUTPUT 0
#define SYS_CLK_TIMER_LOAD_VALUE 99999
#define SYS_CLK_TIMER_COUNTER_SIZE 32
#define SYS_CLK_TIMER_MULT 0.0010
#define SYS_CLK_TIMER_TICKS_PER_SEC 1000
#define SYS_CLK_TIMER_FREQ 100000000
#define ALT_MODULE_CLASS_sys_clk_timer altera_avalon_timer

/*
 * high_res_timer configuration
 *
 */

#define HIGH_RES_TIMER_NAME "/dev/high_res_timer"
#define HIGH_RES_TIMER_TYPE "altera_avalon_timer"
#define HIGH_RES_TIMER_BASE 0x03002020
#define HIGH_RES_TIMER_SPAN 32
#define HIGH_RES_TIMER_IRQ 3
#define HIGH_RES_TIMER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define HIGH_RES_TIMER_ALWAYS_RUN 0
#define HIGH_RES_TIMER_FIXED_PERIOD 0
#define HIGH_RES_TIMER_SNAPSHOT 1
#define HIGH_RES_TIMER_PERIOD 1
#define HIGH_RES_TIMER_PERIOD_UNITS "us"
#define HIGH_RES_TIMER_RESET_OUTPUT 0
#define HIGH_RES_TIMER_TIMEOUT_PULSE_OUTPUT 0
#define HIGH_RES_TIMER_LOAD_VALUE 99
#define HIGH_RES_TIMER_COUNTER_SIZE 32
#define HIGH_RES_TIMER_MULT "1.0E-6"
#define HIGH_RES_TIMER_TICKS_PER_SEC 1000000
#define HIGH_RES_TIMER_FREQ 100000000
#define ALT_MODULE_CLASS_high_res_timer altera_avalon_timer

/*
 * watchdog_timer configuration
 *
 */

#define WATCHDOG_TIMER_NAME "/dev/watchdog_timer"
#define WATCHDOG_TIMER_TYPE "altera_avalon_timer"
#define WATCHDOG_TIMER_BASE 0x03002040
#define WATCHDOG_TIMER_SPAN 32
#define WATCHDOG_TIMER_IRQ 4
#define WATCHDOG_TIMER_IRQ_INTERRUPT_CONTROLLER_ID 0
#define WATCHDOG_TIMER_ALWAYS_RUN 1
#define WATCHDOG_TIMER_FIXED_PERIOD 1
#define WATCHDOG_TIMER_SNAPSHOT 0
#define WATCHDOG_TIMER_PERIOD 10
#define WATCHDOG_TIMER_PERIOD_UNITS "ms"
#define WATCHDOG_TIMER_RESET_OUTPUT 1
#define WATCHDOG_TIMER_TIMEOUT_PULSE_OUTPUT 0
#define WATCHDOG_TIMER_LOAD_VALUE 999999
#define WATCHDOG_TIMER_COUNTER_SIZE 32
#define WATCHDOG_TIMER_MULT 0.0010
#define WATCHDOG_TIMER_TICKS_PER_SEC 100
#define WATCHDOG_TIMER_FREQ 100000000
#define ALT_MODULE_CLASS_watchdog_timer altera_avalon_timer

/*
 * pipeline_bridge_0 configuration
 *
 */

#define PIPELINE_BRIDGE_0_NAME "/dev/pipeline_bridge_0"
#define PIPELINE_BRIDGE_0_TYPE "altera_avalon_pipeline_bridge"
#define PIPELINE_BRIDGE_0_BASE 0x01000000
#define PIPELINE_BRIDGE_0_SPAN 512
#define PIPELINE_BRIDGE_0_IS_DOWNSTREAM 1
#define PIPELINE_BRIDGE_0_IS_UPSTREAM 1
#define PIPELINE_BRIDGE_0_IS_WAITREQUEST 1
#define PIPELINE_BRIDGE_0_ENABLE_ARBITERLOCK 0
#define ALT_MODULE_CLASS_pipeline_bridge_0 altera_avalon_pipeline_bridge

/*
 * ili_db configuration
 *
 */

#define ILI_DB_NAME "/dev/ili_db"
#define ILI_DB_TYPE "altera_avalon_pio"
#define ILI_DB_BASE 0x01000000
#define ILI_DB_SPAN 16
#define ILI_DB_DO_TEST_BENCH_WIRING 0
#define ILI_DB_DRIVEN_SIM_VALUE 0
#define ILI_DB_HAS_TRI 1
#define ILI_DB_HAS_OUT 0
#define ILI_DB_HAS_IN 0
#define ILI_DB_CAPTURE 0
#define ILI_DB_DATA_WIDTH 8
#define ILI_DB_RESET_VALUE 255
#define ILI_DB_EDGE_TYPE "NONE"
#define ILI_DB_IRQ_TYPE "NONE"
#define ILI_DB_BIT_CLEARING_EDGE_REGISTER 0
#define ILI_DB_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ILI_DB_FREQ 100000000
#define ALT_MODULE_CLASS_ili_db altera_avalon_pio

/*
 * ili_nrst configuration
 *
 */

#define ILI_NRST_NAME "/dev/ili_nrst"
#define ILI_NRST_TYPE "altera_avalon_pio"
#define ILI_NRST_BASE 0x01000010
#define ILI_NRST_SPAN 16
#define ILI_NRST_DO_TEST_BENCH_WIRING 0
#define ILI_NRST_DRIVEN_SIM_VALUE 0
#define ILI_NRST_HAS_TRI 0
#define ILI_NRST_HAS_OUT 1
#define ILI_NRST_HAS_IN 0
#define ILI_NRST_CAPTURE 0
#define ILI_NRST_DATA_WIDTH 1
#define ILI_NRST_RESET_VALUE 1
#define ILI_NRST_EDGE_TYPE "NONE"
#define ILI_NRST_IRQ_TYPE "NONE"
#define ILI_NRST_BIT_CLEARING_EDGE_REGISTER 0
#define ILI_NRST_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ILI_NRST_FREQ 100000000
#define ALT_MODULE_CLASS_ili_nrst altera_avalon_pio

/*
 * ili_ncs configuration
 *
 */

#define ILI_NCS_NAME "/dev/ili_ncs"
#define ILI_NCS_TYPE "altera_avalon_pio"
#define ILI_NCS_BASE 0x01000020
#define ILI_NCS_SPAN 16
#define ILI_NCS_DO_TEST_BENCH_WIRING 0
#define ILI_NCS_DRIVEN_SIM_VALUE 0
#define ILI_NCS_HAS_TRI 0
#define ILI_NCS_HAS_OUT 1
#define ILI_NCS_HAS_IN 0
#define ILI_NCS_CAPTURE 0
#define ILI_NCS_DATA_WIDTH 1
#define ILI_NCS_RESET_VALUE 1
#define ILI_NCS_EDGE_TYPE "NONE"
#define ILI_NCS_IRQ_TYPE "NONE"
#define ILI_NCS_BIT_CLEARING_EDGE_REGISTER 0
#define ILI_NCS_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ILI_NCS_FREQ 100000000
#define ALT_MODULE_CLASS_ili_ncs altera_avalon_pio

/*
 * ili_nwr configuration
 *
 */

#define ILI_NWR_NAME "/dev/ili_nwr"
#define ILI_NWR_TYPE "altera_avalon_pio"
#define ILI_NWR_BASE 0x01000030
#define ILI_NWR_SPAN 16
#define ILI_NWR_DO_TEST_BENCH_WIRING 0
#define ILI_NWR_DRIVEN_SIM_VALUE 0
#define ILI_NWR_HAS_TRI 0
#define ILI_NWR_HAS_OUT 1
#define ILI_NWR_HAS_IN 0
#define ILI_NWR_CAPTURE 0
#define ILI_NWR_DATA_WIDTH 1
#define ILI_NWR_RESET_VALUE 1
#define ILI_NWR_EDGE_TYPE "NONE"
#define ILI_NWR_IRQ_TYPE "NONE"
#define ILI_NWR_BIT_CLEARING_EDGE_REGISTER 0
#define ILI_NWR_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ILI_NWR_FREQ 100000000
#define ALT_MODULE_CLASS_ili_nwr altera_avalon_pio

/*
 * ili_nrd configuration
 *
 */

#define ILI_NRD_NAME "/dev/ili_nrd"
#define ILI_NRD_TYPE "altera_avalon_pio"
#define ILI_NRD_BASE 0x01000040
#define ILI_NRD_SPAN 16
#define ILI_NRD_DO_TEST_BENCH_WIRING 0
#define ILI_NRD_DRIVEN_SIM_VALUE 0
#define ILI_NRD_HAS_TRI 0
#define ILI_NRD_HAS_OUT 1
#define ILI_NRD_HAS_IN 0
#define ILI_NRD_CAPTURE 0
#define ILI_NRD_DATA_WIDTH 1
#define ILI_NRD_RESET_VALUE 1
#define ILI_NRD_EDGE_TYPE "NONE"
#define ILI_NRD_IRQ_TYPE "NONE"
#define ILI_NRD_BIT_CLEARING_EDGE_REGISTER 0
#define ILI_NRD_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ILI_NRD_FREQ 100000000
#define ALT_MODULE_CLASS_ili_nrd altera_avalon_pio

/*
 * ili_rs configuration
 *
 */

#define ILI_RS_NAME "/dev/ili_rs"
#define ILI_RS_TYPE "altera_avalon_pio"
#define ILI_RS_BASE 0x01000050
#define ILI_RS_SPAN 16
#define ILI_RS_DO_TEST_BENCH_WIRING 0
#define ILI_RS_DRIVEN_SIM_VALUE 0
#define ILI_RS_HAS_TRI 0
#define ILI_RS_HAS_OUT 1
#define ILI_RS_HAS_IN 0
#define ILI_RS_CAPTURE 0
#define ILI_RS_DATA_WIDTH 1
#define ILI_RS_RESET_VALUE 1
#define ILI_RS_EDGE_TYPE "NONE"
#define ILI_RS_IRQ_TYPE "NONE"
#define ILI_RS_BIT_CLEARING_EDGE_REGISTER 0
#define ILI_RS_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ILI_RS_FREQ 100000000
#define ALT_MODULE_CLASS_ili_rs altera_avalon_pio

/*
 * ads_busy configuration
 *
 */

#define ADS_BUSY_NAME "/dev/ads_busy"
#define ADS_BUSY_TYPE "altera_avalon_pio"
#define ADS_BUSY_BASE 0x01000060
#define ADS_BUSY_SPAN 16
#define ADS_BUSY_DO_TEST_BENCH_WIRING 0
#define ADS_BUSY_DRIVEN_SIM_VALUE 0
#define ADS_BUSY_HAS_TRI 0
#define ADS_BUSY_HAS_OUT 0
#define ADS_BUSY_HAS_IN 1
#define ADS_BUSY_CAPTURE 0
#define ADS_BUSY_DATA_WIDTH 1
#define ADS_BUSY_RESET_VALUE 0
#define ADS_BUSY_EDGE_TYPE "NONE"
#define ADS_BUSY_IRQ_TYPE "NONE"
#define ADS_BUSY_BIT_CLEARING_EDGE_REGISTER 0
#define ADS_BUSY_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ADS_BUSY_FREQ 100000000
#define ALT_MODULE_CLASS_ads_busy altera_avalon_pio

/*
 * ads_nirq configuration
 *
 */

#define ADS_NIRQ_NAME "/dev/ads_nirq"
#define ADS_NIRQ_TYPE "altera_avalon_pio"
#define ADS_NIRQ_BASE 0x010000b0
#define ADS_NIRQ_SPAN 16
#define ADS_NIRQ_IRQ 5
#define ADS_NIRQ_IRQ_INTERRUPT_CONTROLLER_ID 0
#define ADS_NIRQ_DO_TEST_BENCH_WIRING 0
#define ADS_NIRQ_DRIVEN_SIM_VALUE 0
#define ADS_NIRQ_HAS_TRI 0
#define ADS_NIRQ_HAS_OUT 0
#define ADS_NIRQ_HAS_IN 1
#define ADS_NIRQ_CAPTURE 1
#define ADS_NIRQ_DATA_WIDTH 1
#define ADS_NIRQ_RESET_VALUE 0
#define ADS_NIRQ_EDGE_TYPE "FALLING"
#define ADS_NIRQ_IRQ_TYPE "EDGE"
#define ADS_NIRQ_BIT_CLEARING_EDGE_REGISTER 1
#define ADS_NIRQ_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ADS_NIRQ_FREQ 100000000
#define ALT_MODULE_CLASS_ads_nirq altera_avalon_pio

/*
 * ads_clk configuration
 *
 */

#define ADS_CLK_NAME "/dev/ads_clk"
#define ADS_CLK_TYPE "altera_avalon_pio"
#define ADS_CLK_BASE 0x01000080
#define ADS_CLK_SPAN 16
#define ADS_CLK_DO_TEST_BENCH_WIRING 0
#define ADS_CLK_DRIVEN_SIM_VALUE 0
#define ADS_CLK_HAS_TRI 0
#define ADS_CLK_HAS_OUT 1
#define ADS_CLK_HAS_IN 0
#define ADS_CLK_CAPTURE 0
#define ADS_CLK_DATA_WIDTH 1
#define ADS_CLK_RESET_VALUE 0
#define ADS_CLK_EDGE_TYPE "NONE"
#define ADS_CLK_IRQ_TYPE "NONE"
#define ADS_CLK_BIT_CLEARING_EDGE_REGISTER 0
#define ADS_CLK_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ADS_CLK_FREQ 100000000
#define ALT_MODULE_CLASS_ads_clk altera_avalon_pio

/*
 * ads_dout configuration
 *
 */

#define ADS_DOUT_NAME "/dev/ads_dout"
#define ADS_DOUT_TYPE "altera_avalon_pio"
#define ADS_DOUT_BASE 0x01000090
#define ADS_DOUT_SPAN 16
#define ADS_DOUT_DO_TEST_BENCH_WIRING 0
#define ADS_DOUT_DRIVEN_SIM_VALUE 0
#define ADS_DOUT_HAS_TRI 0
#define ADS_DOUT_HAS_OUT 0
#define ADS_DOUT_HAS_IN 1
#define ADS_DOUT_CAPTURE 0
#define ADS_DOUT_DATA_WIDTH 1
#define ADS_DOUT_RESET_VALUE 0
#define ADS_DOUT_EDGE_TYPE "NONE"
#define ADS_DOUT_IRQ_TYPE "NONE"
#define ADS_DOUT_BIT_CLEARING_EDGE_REGISTER 0
#define ADS_DOUT_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ADS_DOUT_FREQ 100000000
#define ALT_MODULE_CLASS_ads_dout altera_avalon_pio

/*
 * ads_din configuration
 *
 */

#define ADS_DIN_NAME "/dev/ads_din"
#define ADS_DIN_TYPE "altera_avalon_pio"
#define ADS_DIN_BASE 0x010000a0
#define ADS_DIN_SPAN 16
#define ADS_DIN_DO_TEST_BENCH_WIRING 0
#define ADS_DIN_DRIVEN_SIM_VALUE 0
#define ADS_DIN_HAS_TRI 0
#define ADS_DIN_HAS_OUT 1
#define ADS_DIN_HAS_IN 0
#define ADS_DIN_CAPTURE 0
#define ADS_DIN_DATA_WIDTH 1
#define ADS_DIN_RESET_VALUE 0
#define ADS_DIN_EDGE_TYPE "NONE"
#define ADS_DIN_IRQ_TYPE "NONE"
#define ADS_DIN_BIT_CLEARING_EDGE_REGISTER 0
#define ADS_DIN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ADS_DIN_FREQ 100000000
#define ALT_MODULE_CLASS_ads_din altera_avalon_pio

/*
 * ads_ncs configuration
 *
 */

#define ADS_NCS_NAME "/dev/ads_ncs"
#define ADS_NCS_TYPE "altera_avalon_pio"
#define ADS_NCS_BASE 0x010000c0
#define ADS_NCS_SPAN 16
#define ADS_NCS_DO_TEST_BENCH_WIRING 0
#define ADS_NCS_DRIVEN_SIM_VALUE 0
#define ADS_NCS_HAS_TRI 0
#define ADS_NCS_HAS_OUT 1
#define ADS_NCS_HAS_IN 0
#define ADS_NCS_CAPTURE 0
#define ADS_NCS_DATA_WIDTH 1
#define ADS_NCS_RESET_VALUE 1
#define ADS_NCS_EDGE_TYPE "NONE"
#define ADS_NCS_IRQ_TYPE "NONE"
#define ADS_NCS_BIT_CLEARING_EDGE_REGISTER 0
#define ADS_NCS_BIT_MODIFYING_OUTPUT_REGISTER 0
#define ADS_NCS_FREQ 100000000
#define ALT_MODULE_CLASS_ads_ncs altera_avalon_pio

/*
 * sd_ncs configuration
 *
 */

#define SD_NCS_NAME "/dev/sd_ncs"
#define SD_NCS_TYPE "altera_avalon_pio"
#define SD_NCS_BASE 0x010000d0
#define SD_NCS_SPAN 16
#define SD_NCS_DO_TEST_BENCH_WIRING 0
#define SD_NCS_DRIVEN_SIM_VALUE 0
#define SD_NCS_HAS_TRI 0
#define SD_NCS_HAS_OUT 1
#define SD_NCS_HAS_IN 0
#define SD_NCS_CAPTURE 0
#define SD_NCS_DATA_WIDTH 1
#define SD_NCS_RESET_VALUE 0
#define SD_NCS_EDGE_TYPE "NONE"
#define SD_NCS_IRQ_TYPE "NONE"
#define SD_NCS_BIT_CLEARING_EDGE_REGISTER 0
#define SD_NCS_BIT_MODIFYING_OUTPUT_REGISTER 0
#define SD_NCS_FREQ 100000000
#define ALT_MODULE_CLASS_sd_ncs altera_avalon_pio

/*
 * sd_clk configuration
 *
 */

#define SD_CLK_NAME "/dev/sd_clk"
#define SD_CLK_TYPE "altera_avalon_pio"
#define SD_CLK_BASE 0x010000e0
#define SD_CLK_SPAN 16
#define SD_CLK_DO_TEST_BENCH_WIRING 0
#define SD_CLK_DRIVEN_SIM_VALUE 0
#define SD_CLK_HAS_TRI 0
#define SD_CLK_HAS_OUT 1
#define SD_CLK_HAS_IN 0
#define SD_CLK_CAPTURE 0
#define SD_CLK_DATA_WIDTH 1
#define SD_CLK_RESET_VALUE 0
#define SD_CLK_EDGE_TYPE "NONE"
#define SD_CLK_IRQ_TYPE "NONE"
#define SD_CLK_BIT_CLEARING_EDGE_REGISTER 0
#define SD_CLK_BIT_MODIFYING_OUTPUT_REGISTER 0
#define SD_CLK_FREQ 100000000
#define ALT_MODULE_CLASS_sd_clk altera_avalon_pio

/*
 * sd_din configuration
 *
 */

#define SD_DIN_NAME "/dev/sd_din"
#define SD_DIN_TYPE "altera_avalon_pio"
#define SD_DIN_BASE 0x010000f0
#define SD_DIN_SPAN 16
#define SD_DIN_DO_TEST_BENCH_WIRING 0
#define SD_DIN_DRIVEN_SIM_VALUE 0
#define SD_DIN_HAS_TRI 0
#define SD_DIN_HAS_OUT 1
#define SD_DIN_HAS_IN 0
#define SD_DIN_CAPTURE 0
#define SD_DIN_DATA_WIDTH 1
#define SD_DIN_RESET_VALUE 0
#define SD_DIN_EDGE_TYPE "NONE"
#define SD_DIN_IRQ_TYPE "NONE"
#define SD_DIN_BIT_CLEARING_EDGE_REGISTER 0
#define SD_DIN_BIT_MODIFYING_OUTPUT_REGISTER 0
#define SD_DIN_FREQ 100000000
#define ALT_MODULE_CLASS_sd_din altera_avalon_pio

/*
 * sd_dout configuration
 *
 */

#define SD_DOUT_NAME "/dev/sd_dout"
#define SD_DOUT_TYPE "altera_avalon_pio"
#define SD_DOUT_BASE 0x01000100
#define SD_DOUT_SPAN 16
#define SD_DOUT_DO_TEST_BENCH_WIRING 0
#define SD_DOUT_DRIVEN_SIM_VALUE 0
#define SD_DOUT_HAS_TRI 0
#define SD_DOUT_HAS_OUT 0
#define SD_DOUT_HAS_IN 1
#define SD_DOUT_CAPTURE 0
#define SD_DOUT_DATA_WIDTH 1
#define SD_DOUT_RESET_VALUE 0
#define SD_DOUT_EDGE_TYPE "NONE"
#define SD_DOUT_IRQ_TYPE "NONE"
#define SD_DOUT_BIT_CLEARING_EDGE_REGISTER 0
#define SD_DOUT_BIT_MODIFYING_OUTPUT_REGISTER 0
#define SD_DOUT_FREQ 100000000
#define ALT_MODULE_CLASS_sd_dout altera_avalon_pio

/*
 * system library configuration
 *
 */

#define ALT_MAX_FD 32
#define ALT_SYS_CLK SYS_CLK_TIMER
#define ALT_TIMESTAMP_CLK none

/*
 * Devices associated with code sections.
 *
 */

#define ALT_TEXT_DEVICE       SDRAM
#define ALT_RODATA_DEVICE     SDRAM
#define ALT_RWDATA_DEVICE     SDRAM
#define ALT_EXCEPTIONS_DEVICE SDRAM
#define ALT_RESET_DEVICE      EPCS


#endif /* __SYSTEM_H_ */
