
/*
GUANFU_WANG@126.COM
QQ:21578936
未经许可禁止任何商业用途
*/

#ifndef _OV7670_H
#define _OV7670_H


#include "SCCB.h"

#define CMOS_MD   0
/*
支持OV7670/OV7725/MT9M111/MT9D111/cf0k82c/ck0k24c
条件编译开关：OV7670.h文件
#define CMOS_MD 0 //OV7670
#define CMOS_MD 1 //OV7725
#define CMOS_MD 2 //MT9M111
#define CMOS_MD 3 //MT9D111
#define CMOS_MD 4 //ck0k82c-v1
#define CMOS_MD 5 //ck0k24c-v1
*/
#if   CMOS_MD==0 
   #define CHANGE_REG_NUM 166
   #define n_NUM 2
   extern const char change_reg[CHANGE_REG_NUM][n_NUM];
#elif CMOS_MD==1
   #define CHANGE_REG_NUM 85
   #define n_NUM 2
   extern const char change_reg[CHANGE_REG_NUM][n_NUM];
#elif CMOS_MD==2
   #define CHANGE_REG_NUM 158
   #define n_NUM 3
   extern const int change_reg[CHANGE_REG_NUM][n_NUM];
#elif CMOS_MD==3
   #define CHANGE_REG_NUM 168
   #define n_NUM 3
   extern const int change_reg[CHANGE_REG_NUM][n_NUM];
#elif CMOS_MD==4
   #define CHANGE_REG_NUM 49
   #define n_NUM 2
   extern  const  int change_reg[CHANGE_REG_NUM][n_NUM];
#elif CMOS_MD==5 
   #define CHANGE_REG_NUM 40
   #define n_NUM 3
   extern  const  int change_reg[CHANGE_REG_NUM][n_NUM];
#endif


//#define OV7670_HREF_BIT     GPIO_Pin_5//PC5
#define OV7670_VSYNC_BIT    GPIO_Pin_2//PD2




  #define GPIO_VSYNC_CMOS                    GPIOD
  #define RCC_APB2Periph_GPIO_VSYNC_CMOS     RCC_APB2Periph_GPIOD
  #define GPIO_PIN_VSYNC_CMOS                GPIO_Pin_2
  #define EXTI_LINE_VSYNC_CMOS               EXTI_Line2
  #define GPIO_PORT_SOURCE_VSYNC_CMOS        GPIO_PortSourceGPIOD
  #define GPIO_PIN_SOURCE_VSYNC_CMOS         GPIO_PinSource2


/////////////////////////////////////////

#if   (CMOS_MD==0 )|(CMOS_MD==1 )
    unsigned char wrOV7670Reg(unsigned char regID, unsigned char regDat);
#elif (CMOS_MD==2 )|(CMOS_MD==3 )|(CMOS_MD==5 )
   unsigned char wrOV7670Reg(unsigned char Page,unsigned char regID, unsigned int regDat);
#elif (CMOS_MD==4 )
      unsigned char wr_CFOK82C_Reg(unsigned char regID, unsigned int regDat);
      unsigned char CFOK82C_set_ccm(unsigned int index);
#endif 
       unsigned char  CFOK82C_set_gamma(unsigned int index);
unsigned char rdOV7670Reg(unsigned char regID, unsigned char *regDat);
void OV7670_config_window(unsigned int startx,unsigned int starty,unsigned int width, unsigned int height);
unsigned char OV7670_init(void);
void ov7670_GPIO_Init(void);
void OV7670_EXTI_Config(void);
void ov7670_Interrupts_Config(void);
void OV7670_config_window(unsigned int startx,unsigned int starty,unsigned int width, unsigned int height);

#endif /* _OV7670_H */



