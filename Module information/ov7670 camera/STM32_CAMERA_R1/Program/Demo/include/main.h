/*
GUANFU_WANG@126.COM
QQ:21578936
未经许可禁止任何商业用途
*/
/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

/* Includes ------------------------------------------------------------------*/
#define Key_BIT          GPIO_Pin_12
#define Key_STATE	 GPIOC->IDR&Key_BIT 

#include "stm32f10x_it.h"
#include "delay.h"
#include "ili9331.h"
#include "ov7670.h"
#include "hw_config.h"
#include "RTC_Time.h"
#include "ff.h"
#include "diskio.h"
#include "SPI_SD_driver.h"
#include "Touch.h"
#define LED_ON()   GPIOC->BRR  =GPIO_Pin_11
#define LED_OFF()  GPIOC->BSRR =GPIO_Pin_11 
static vu32 TimeDisplay = 0,TimingDelay = 0; 
   



void LED_GPIO_Init(void);
void Key_GPIO_Init(void);
void Demo_Init(void);
void Decrement_TimingDelay(void);
void USART1_init(void);
ErrorStatus Get_HSEStartUpStatus(void);






  



#endif /* __MAIN_H */




