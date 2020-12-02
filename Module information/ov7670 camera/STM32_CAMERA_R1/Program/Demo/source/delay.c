/*
GUANFU_WANG@126.COM
QQ:21578936
未经许可禁止任何商业用途
*/
#include "delay.h"

void delay_us(unsigned int i)
 {     
    while( i--)
       {	
         asm("NOP");
        }
 }		  


