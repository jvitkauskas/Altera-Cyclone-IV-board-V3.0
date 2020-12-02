/*************************************************************************
* Copyright (c) 2006 Altera Corporation, San Jose, California, USA.      *
* All rights reserved. All use of this software and documentation is     *
* subject to the License Agreement located at the end of this file below.*
*************************************************************************/

/* Includes */

#include "alt_types.h"
#include <stdio.h>
#include <unistd.h>
#include "system.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"

/*  Macros to clear the LCD screen. */

#define ESC 27
#define CLEAR_LCD_STRING "[2J"

/* One nice define for going to menu entry functions. */

#define MenuCase(letter,proc) case letter:proc(); break;

/* Board Diagnositics Peripheral Function prototypes */

/* UART Related Prototypes */
#ifdef JTAG_UART_NAME
static void UARTSendLots( void );
static void UARTReceiveChars( void );
#endif

/* Seven Segment Related Prototypes */
#ifdef SEVEN_SEG_PIO_NAME
static void SevenSegCount( void );
static void SevenSegControl( void );
#endif

/* LED Related Prototype */
#ifdef LED_PIO_NAME
static void TestLEDs( void );
#endif

/* Button/Switch (SW0-SW3) Related Prototype */
#ifdef BUTTON_PIO_NAME
static void TestButtons( void );
#endif

/* LCD Related Prototype */
#ifdef LCD_DISPLAY_NAME
static void TestLCD( void );
#endif

/* Define the EOT character to terminate nios2-terminal
 * upon exiting the Main Menu.
 */

#define EOT 0x4

/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2006 Altera Corporation, San Jose, California, USA.           *
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
* Altera does not recommend, suggest or require that this reference design    *
* file be used in conjunction or combination with any other product.          *
******************************************************************************/
