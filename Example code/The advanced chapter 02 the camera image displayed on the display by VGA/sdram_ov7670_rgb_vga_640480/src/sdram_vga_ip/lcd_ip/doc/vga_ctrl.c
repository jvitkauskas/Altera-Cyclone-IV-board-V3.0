/*
 * vga_ctrl.c
 *
 *  Created on: 2010-11-27
 *      Author: Administrator
 */

#include "system.h"                         //包含基本的硬件描述信息
#include "unistd.h"
#include "alt_types.h"
#include "vga_ctrl.h"

#define	Write_CLK	{	MCU_CLK = 0;MCU_CLK = 1;	}
/*****************VGA 初始化************************/
void VGA_Init(void)
{
	MCU_Flag = 0;	//写标志拉低，可读SRAM
	MCU_CLK = 0;
	MCU_CMD = 0;
	MCU_Data = 0;
}

/*****************VGA 坐标设定************************/
void Write_Addr(alt_u16 Xpos,alt_u16 Ypos)
{
	MCU_Flag = 0;

	MCU_CMD = 0;	//写X坐标
	MCU_Data = Xpos;
	Write_CLK;

	MCU_CMD = 1;	//写Y坐标
	MCU_Data = Ypos;
	Write_CLK;

	MCU_CMD = 2;	//定位
	Write_CLK;
}

/***************写数据准备***********************/
void Write_DataPrep(void)
{
	MCU_Flag = 1;
	MCU_CMD = 3;
}

/************写数据MCU_Flag=1********************/
void Write_Data(alt_u16 Data)
{
	MCU_Data = Data;
	Write_CLK;
}

/************打开VGA显示********************/
void Display_VGA(void)
{
	MCU_Flag = 0;
}

/**************ColorTest****************/
void ColorTest(void)
{
	//定义各块色度
	#define	RGB_x00	0x0000
	#define	RGB_x01	0x000f
	#define	RGB_x10	0x03e0
	#define	RGB_x11	0x03ef
	#define	RGB_0x0	0x0000
	#define	RGB_0x1	0x000f
	#define	RGB_1x0	0x7800
	#define	RGB_1x1	0x780f
	#define	RGB_00x	0x0000
	#define	RGB_01x	0x03e0
	#define	RGB_10x	0x7800
	#define	RGB_11x	0x7be0

    #define	RGB_X00	0x0000
	#define	RGB_X01	0x001f
	#define	RGB_X10	0x07e0
	#define	RGB_X11	0x07ff
	#define	RGB_0X0	0x0000
	#define	RGB_0X1	0x001f
	#define	RGB_1X0	0xf800
	#define	RGB_1X1	0xf81f
	#define	RGB_00X	0x0000
	#define	RGB_01X	0x07e0
	#define	RGB_10X	0xf800
	#define	RGB_11X	0xffe0
	alt_u16 i,j;
	/***************ColorTest***************
	 * 			第一列	第二列	第三列	第四列
	 * 	第一行	x00		x01		x10		x11
	 * 	第二行	X00		X01		X10		X11
	 * 	第三行	0x0		0x1		1x0		1x1
	 * 	第四行	0X0		0X1		1X0		1X1
	 * 	第五行	00x		01x		10x		11x
	 * 	第六行	00X		01X		10X		11X
	 * ***************0~~MAX变化*************/

	Write_Addr(0,0);
	Write_DataPrep();
	for(i=0;i<128;i++)	//第一行ColorTest测试	16Bit
	{
		for(j=0;j<256;j++)	Write_Data((j&0xf8)<<8|RGB_x00);
		for(j=0;j<256;j++)	Write_Data((j&0xf8)<<8|RGB_x01);
		for(j=0;j<256;j++)	Write_Data((j&0xf8)<<8|RGB_x10);
		for(j=0;j<256;j++)	Write_Data((j&0xf8)<<8|RGB_x11);
	}
	for(i=0;i<128;i++)	//第二行ColorTest测试	16Bit
	{
		for(j=0;j<256;j++)	Write_Data((j&0xf8)<<8|RGB_X00);
		for(j=0;j<256;j++)	Write_Data((j&0xf8)<<8|RGB_X01);
		for(j=0;j<256;j++)	Write_Data((j&0xf8)<<8|RGB_X10);
		for(j=0;j<256;j++)	Write_Data((j&0xf8)<<8|RGB_X11);
	}


	for(i=0;i<128;i++)	//第三行ColorTest测试	16Bit
	{
		for(j=0;j<256;j++)	Write_Data((j&0xfc)<<3|RGB_0x0);
		for(j=0;j<256;j++)	Write_Data((j&0xfc)<<3|RGB_0x1);
		for(j=0;j<256;j++)	Write_Data((j&0xfc)<<3|RGB_1x0);
		for(j=0;j<256;j++)	Write_Data((j&0xfc)<<3|RGB_1x1);
	}
	for(i=0;i<128;i++)	//第四行ColorTest测试	16Bit
	{
		for(j=0;j<256;j++)	Write_Data((j&0xfc)<<3|RGB_0X0);
		for(j=0;j<256;j++)	Write_Data((j&0xfc)<<3|RGB_0X1);
		for(j=0;j<256;j++)	Write_Data((j&0xfc)<<3|RGB_1X0);
		for(j=0;j<256;j++)	Write_Data((j&0xfc)<<3|RGB_1X1);
	}

	for(i=0;i<128;i++)	//第五行ColorTest测试	16Bit
	{
		for(j=0;j<256;j++)	Write_Data((j&0xf8)>>3|RGB_00x);
		for(j=0;j<256;j++)	Write_Data((j&0xf8)>>3|RGB_01x);
		for(j=0;j<256;j++)	Write_Data((j&0xf8)>>3|RGB_10x);
		for(j=0;j<256;j++)	Write_Data((j&0xf8)>>3|RGB_11x);
	}
	for(i=0;i<128;i++)	//第六行ColorTest测试	16Bit
	{
		for(j=0;j<256;j++)	Write_Data((j&0xf8)>>3|RGB_00X);
		for(j=0;j<256;j++)	Write_Data((j&0xf8)>>3|RGB_01X);
		for(j=0;j<256;j++)	Write_Data((j&0xf8)>>3|RGB_10X);
		for(j=0;j<256;j++)	Write_Data((j&0xf8)>>3|RGB_11X);
	}
	Display_VGA();
}

/**************写入整幅图片******************/
void Disp_Image(alt_u8 *Image)
{
	alt_u32 i;
	Write_Addr(0,0);
	Write_DataPrep();
	for(i=0;i<786432;i++)
	{
		Write_Data(*(Image+i*2)|*(Image+i*2+1)<<8);
	}
	Display_VGA();
}






