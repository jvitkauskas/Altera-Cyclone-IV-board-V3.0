
/*
TFT实际控制器型号OTM3225A 2。8“
GUANFU_WANG
*/
/*
GUANFU_WANG@126.COM
QQ:21578936
未经许可禁止任何商业用途
*/
#include "stm32f10x_lib.h"


///////////////////////////////////////////////////////
#define	BLACK	0x0000
#define	BLUE	0x001F
#define	RED 	0xF800
#define	GREEN 	0x07E0
#define CYAN	0x07FF
#define MAGENTA 0xF81F
#define YELLOW	0xFFE0
#define WHITE	0xFFFF		


#define ID_AM         001


#define DATA_LCD_PORT GPIOA->ODR
#define DATA_LCD_PIN  GPIOA->IDR

//#define DATA_INPUT()   DATA_LCD_DDR = 0x00;
//#define DATA_OUPUT()   DATA_LCD_DDR = 0xFF;

#define LCD_CS_BIT   GPIO_Pin_9  // 
#define LCD_RS_BIT   GPIO_Pin_8  // 
#define LCD_RD_BIT   GPIO_Pin_7  //
#define LCD_WR_BIT   GPIO_Pin_1  //
#define LCD_BL_BIT   GPIO_Pin_2  // 
#define LCD_RST_BIT   GPIO_Pin_5  // pa15
#define CMOS_CS_BIT   GPIO_Pin_4  // pa15
#define PCLK_ON_BIT   GPIO_Pin_0  // pa15

#define CMOS_CS_H() GPIOC->BSRR =CMOS_CS_BIT
#define CMOS_CS_L() GPIOC->BRR  =CMOS_CS_BIT

#define PCLK_ON_H() GPIOB->BSRR =PCLK_ON_BIT
#define PCLK_ON_L() GPIOB->BRR =PCLK_ON_BIT

#define LCD_CS_H() GPIOC->BSRR =LCD_CS_BIT
#define LCD_CS_L() GPIOC->BRR =LCD_CS_BIT

#define LCD_RS_H() GPIOC->BSRR =LCD_RS_BIT
#define LCD_RS_L() GPIOC->BRR =LCD_RS_BIT

#define LCD_WR_L() GPIOB->BSRR =LCD_WR_BIT
#define LCD_WR_H() GPIOB->BRR =LCD_WR_BIT

#define LCD_RD_H() GPIOC->BSRR =LCD_RD_BIT
#define LCD_RD_L() GPIOC->BRR =LCD_RD_BIT

#define LCD_BL_H()  GPIOB->BSRR =LCD_BL_BIT
#define LCD_BL_L()  GPIOB->BRR =LCD_BL_BIT

#define LCD_RST_H()  GPIOC->BSRR =LCD_RST_BIT
#define LCD_RST_L()  GPIOC->BRR =LCD_RST_BIT

void  LCD_GPIO_OUTPUT(void);
void  LCD_GPIO_INPUT(void);
void  LCD_Set_GPIO_Config(void);
unsigned int LCD_RD_DATA16(void);//读积存器数据  

void LCD_WR_REG(unsigned int index,unsigned int data);
void LCD_WR_REG16(unsigned int index);//写积存器命令
void LCD_WR_DATA16(unsigned int data);//西积存器数据
void LCD_Init(void);
void LCD_Clear(unsigned int Color);
void LCD_write_english(unsigned char data,unsigned int color,unsigned int xcolor);//写字符
void LCD_write_english_string(unsigned int x,unsigned int y,unsigned char *s,unsigned int color,unsigned int xcolor);//英文字符串显示
void LCD_SetCursor(unsigned int Xpos, unsigned int Ypos);
void Lcd_SetBox(unsigned int xStart,unsigned int yStart,unsigned int xLong,unsigned int yLong);
void LCD_write_SUM(unsigned int x,unsigned int y,unsigned char SUM,unsigned int color,unsigned int xcolor);//写数字
void Test(void);
void Test_tu(void);
void BMP_write_english(unsigned char x,unsigned char val_d,unsigned char color);//写字符
