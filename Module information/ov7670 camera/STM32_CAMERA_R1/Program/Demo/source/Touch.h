

#include "stm32f10x_lib.h"
#include "SPI_SD_driver.h"

#define RCC_APB2Periph_tp          RCC_APB2Periph_GPIOB
#define GPIO_PIN_tp                GPIO_Pin_10
#define EXTI_LINE_tp               EXTI_Line10
#define GPIO_PORT_SOURCE_tp        GPIO_PortSourceGPIOB
#define GPIO_PIN_SOURCE_tp         GPIO_PinSource3

#define TP_CS_H() GPIO_SetBits(GPIOB,GPIO_Pin_11)
#define TP_CS_L() GPIO_ResetBits(GPIOB,GPIO_Pin_11) 
unsigned char SdTranserByte (unsigned char ch);
void Touch_Config(void) ;
u16 GetTouchX(void) ;
u16 GetTouchY(void) ;
void tp_EXTI_Config(void);
void tp_Interrupts_Config(void);
void tp_Interrupts_Config_off(void);
int  GUI_TOUCH_X_MeasureY(void) ;
int  GUI_TOUCH_X_MeasureX(void) ;