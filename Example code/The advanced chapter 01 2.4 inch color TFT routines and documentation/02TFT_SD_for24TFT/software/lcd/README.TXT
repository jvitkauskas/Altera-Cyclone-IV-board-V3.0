/******************************************************************************
 *
 * Description
 * ************* 
 * A program which provides a means to test most of the devices on a Nios
 * Development Board.  The devices covered in this test are, as follows:
 *  - Seven Segment Display
 *  - The D0-D7 LEDs (located just under the FPGA on most Development boards).
 *      Blinking LED test runs until user tells it to stop.
 *  - UART test 
 *      Tests UART functionality for the UART defined as STDOUT.
 *      * Currently, only tested on the JTAG UART device.
 *  - The LCD Display
 *      Displays a short message on the LCD Display.
 *  - Buttons/Switches (SW0-SW3 on the Development boards, located right
 *    under the FPGA.
 *      This detects button presses, in a tight loop, and returns any
 *      non-zero value.  
 *  
 * Requirements
 * **************
 * This program requires the following devices to be configured:
 *   an LED PIO named 'led_pio',
 *   a Seven Segment Display PIO named 'seven_seg_pio',
 *   an LCD Display named 'lcd_display',
 *   a Button PIO named 'button_pio',
 *   a JTAG connection [MANDATORY] 
 *   	- to test the JTAG UART functionality and to implement the menu-based
          user interface
 *
 * Known Issues
 * **************
 *   If this design is run on the ISS, terminal output will take several 
 * minutes per iteration.
 *   If any of the required components don't exist in your system, the menu 
 *   item will not appear in the main or top level menu. 
 * 
 * Peripherals Exercised by SW
 * *****************************
 * LEDs
 * Seven Segment Display
 * LCD
 * Buttons (SW0-SW3)
 * JTAG UART
 * 
 * Software Files
 * ****************
 * board_diag.c 
 *    - Implements a top level menu allowing the user to choose which 
 * board components to test.
 * 
 * board_diag.h
 *    - A file containing the common includes and definitions for
 * use within this code.
 * 
 * 
 */
