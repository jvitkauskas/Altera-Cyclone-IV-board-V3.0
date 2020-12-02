/*-------------------------------------------------------------------------
This confidential and proprietary software may be only used as authorized
by a licensing agreement from amfpga.
(C) COPYRIGHT 2013.www.amfpga.com ALL RIGHTS RESERVED
Filename			:		sdram_ov7670_vga.v
Author				:		Amfpga
Data				:		2013-02-1
Version				:		1.0
Description			:		sdram vga controller with ov7670 display.
Modification History	:
Data			By			Version			Change Description
===========================================================================
13/02/1
--------------------------------------------------------------------------*/

`timescale 1ns/1ns
module	I2C_OV7670_RGB565_Config
(
	input		[7:0]	LUT_INDEX,
	output	reg	[15:0]	LUT_DATA
);


parameter	Read_DATA	=	0;			//Read data LUT Address
parameter	SET_OV7670	=	2;			//SET_OV LUT Adderss
/////////////////////	Config Data LUT	  //////////////////////////	
always@(*)
begin
	case(LUT_INDEX)
	//Audio Config Data
	//Read Data Index
//	Read_DATA + 0 :		LUT_DATA	=	{8'h0A, 8'h76};	//PID	厂商高位识别号 （只读） 
//	Read_DATA + 1 :		LUT_DATA	=	{8'h0B, 8'h73};	//VER	厂商低位识别号 （只读）
	Read_DATA + 0 :		LUT_DATA	=	{8'h1C, 8'h7F};	//MIDH	厂商识别字节-高（只读）
	Read_DATA + 1 :		LUT_DATA	=	{8'h1D, 8'hA2};	//MIDL	厂商识别字节-低（只读）
//	OV7670 : VGA RGB565
	SET_OV7670 + 0 	: 	LUT_DATA	= 	16'h1204;	//复位，VGA，RGB565 (00:YUV,04:RGB)(8x全局复位)
	SET_OV7670 + 1 	: 	LUT_DATA	= 	16'h40d0;	//RGB565, 00-FF(d0)（YUV下要改01-FE(80)）
	SET_OV7670 + 2 	: 	LUT_DATA	= 	16'h3a04;	//TSLB(TSLB[3], COM13[0])00:YUYV, 01:YVYU, 10:UYVY(CbYCrY), 11:VYUY
	SET_OV7670 + 3 	: 	LUT_DATA	=	16'h3dc8;	//COM13(TSLB[3], COM13[0])00:YUYV, 01:YVYU, 10:UYVY(CbYCrY), 11:VYUY
	SET_OV7670 + 4 	: 	LUT_DATA	= 	16'h1e31;	//默认01，Bit[5]水平镜像，Bit[4]竖直镜像
	SET_OV7670 + 5 	: 	LUT_DATA	= 	16'h6b00;	//旁路PLL倍频；0x0A：关闭内部LDO；0x00：打开LDO
	SET_OV7670 + 6 	: 	LUT_DATA	= 	16'h32b6;	//HREF 控制(80)
	SET_OV7670 + 7 	: 	LUT_DATA	= 	16'h1713;	//HSTART 输出格式-行频开始高8位(11) 
	SET_OV7670 + 8 	: 	LUT_DATA	= 	16'h1801;	//HSTOP  输出格式-行频结束高8位(61)
	SET_OV7670 + 9 	: 	LUT_DATA	= 	16'h1902;	//VSTART 输出格式-场频开始高8位(03)
	SET_OV7670 + 10	: 	LUT_DATA	= 	16'h1a7a;	//VSTOP  输出格式-场频结束高8位(7b)
	SET_OV7670 + 11	: 	LUT_DATA	= 	16'h030a;	//VREF	 帧竖直方向控制(00)
	SET_OV7670 + 12 : 	LUT_DATA	= 	16'h0c00;	//DCW使能 禁止(00)
	SET_OV7670 + 13 : 	LUT_DATA	= 	16'h3e00;	//PCLK分频00 Normal，10（1分频）,11（2分频）,12（4分频）,13（8分频）14（16分频）
	SET_OV7670 + 14 : 	LUT_DATA	= 	16'h7000;	//00:Normal, 80:移位1, 00:彩条, 80:渐变彩条   7000
	SET_OV7670 + 15 : 	LUT_DATA	= 	16'h7100;	//00:Normal, 00:移位1, 80:彩条, 80：渐变彩条  7100
	SET_OV7670 + 16 : 	LUT_DATA	= 	16'h7211;	//默认 水平，垂直8抽样(11)	        
	SET_OV7670 + 17 : 	LUT_DATA	= 	16'h7300;	//DSP缩放时钟分频00 Normal，10（1分频）,11（2分频）,12（4分频）,13（8分频）14（16分频） 
	SET_OV7670 + 18 : 	LUT_DATA	= 	16'ha202;	//默认 像素始终延迟	(02)
	SET_OV7670 + 19 : 	LUT_DATA	= 	16'h1180;	//内部工作时钟设置，直接使用外部时钟源(80)
	SET_OV7670 + 20 : 	LUT_DATA	= 	16'h7a20;
	SET_OV7670 + 21 : 	LUT_DATA	= 	16'h7b1c;
	SET_OV7670 + 22 : 	LUT_DATA	= 	16'h7c28;
	SET_OV7670 + 23 : 	LUT_DATA	= 	16'h7d3c;
	SET_OV7670 + 24 : 	LUT_DATA	= 	16'h7e55;
	SET_OV7670 + 25 : 	LUT_DATA	= 	16'h7f68;
	SET_OV7670 + 26 : 	LUT_DATA	= 	16'h8076;
	SET_OV7670 + 27 : 	LUT_DATA	= 	16'h8180;
	SET_OV7670 + 28 : 	LUT_DATA	= 	16'h8288;
	SET_OV7670 + 29 : 	LUT_DATA	= 	16'h838f;
	SET_OV7670 + 30 : 	LUT_DATA	= 	16'h8496;
	SET_OV7670 + 31 : 	LUT_DATA	= 	16'h85a3;
	SET_OV7670 + 32 : 	LUT_DATA	= 	16'h86af;
	SET_OV7670 + 33 : 	LUT_DATA	= 	16'h87c4;
	SET_OV7670 + 34 : 	LUT_DATA	= 	16'h88d7;
	SET_OV7670 + 35 : 	LUT_DATA	= 	16'h89e8;
	SET_OV7670 + 36 : 	LUT_DATA	= 	16'h13e0;
	SET_OV7670 + 37 : 	LUT_DATA	= 	16'h0000;
	SET_OV7670 + 38 : 	LUT_DATA	= 	16'h1000;
	SET_OV7670 + 39 : 	LUT_DATA	= 	16'h0d00;
	SET_OV7670 + 40 : 	LUT_DATA	= 	16'h1428;	//
	SET_OV7670 + 41 : 	LUT_DATA	= 	16'ha505;
	SET_OV7670 + 42 : 	LUT_DATA	= 	16'hab07;
	SET_OV7670 + 43 : 	LUT_DATA	= 	16'h2475;
	SET_OV7670 + 44 : 	LUT_DATA	= 	16'h2563;
	SET_OV7670 + 45 : 	LUT_DATA	= 	16'h26a5;
	SET_OV7670 + 46 : 	LUT_DATA	= 	16'h9f78;
	SET_OV7670 + 47 : 	LUT_DATA	= 	16'ha068;
	SET_OV7670 + 48 : 	LUT_DATA	= 	16'ha103;
	SET_OV7670 + 49 : 	LUT_DATA	= 	16'ha6df;
	SET_OV7670 + 50 : 	LUT_DATA	= 	16'ha7df;
	SET_OV7670 + 51 : 	LUT_DATA	= 	16'ha8f0;
	SET_OV7670 + 52 : 	LUT_DATA	= 	16'ha990;
	SET_OV7670 + 53 : 	LUT_DATA	= 	16'haa94;
	SET_OV7670 + 54 : 	LUT_DATA	= 	16'h13ef;	//
	SET_OV7670 + 55	: 	LUT_DATA	= 	16'h0e61;
	SET_OV7670 + 56	: 	LUT_DATA	= 	16'h0f4b;
	SET_OV7670 + 57	: 	LUT_DATA	= 	16'h1602;

	
	SET_OV7670 + 58 : 	LUT_DATA	= 	16'h2102;
	SET_OV7670 + 59 : 	LUT_DATA	= 	16'h2291;
	SET_OV7670 + 60 : 	LUT_DATA	= 	16'h2907;
	SET_OV7670 + 61 : 	LUT_DATA	= 	16'h330b;
	SET_OV7670 + 62 : 	LUT_DATA	= 	16'h350b;
	SET_OV7670 + 63 : 	LUT_DATA	= 	16'h371d;
	SET_OV7670 + 64 : 	LUT_DATA	= 	16'h3871;
	SET_OV7670 + 65 : 	LUT_DATA	= 	16'h392a;
	SET_OV7670 + 66 : 	LUT_DATA	= 	16'h3c78;
	SET_OV7670 + 67 : 	LUT_DATA	= 	16'h4d40;
	SET_OV7670 + 68	: 	LUT_DATA	= 	16'h4e20;
	SET_OV7670 + 69	: 	LUT_DATA	= 	16'h6900;
	
	SET_OV7670 + 70 : 	LUT_DATA	= 	16'h7419;
	SET_OV7670 + 71 : 	LUT_DATA	= 	16'h8d4f;
	SET_OV7670 + 72 : 	LUT_DATA	= 	16'h8e00;
	SET_OV7670 + 73 : 	LUT_DATA	= 	16'h8f00;
	SET_OV7670 + 74 : 	LUT_DATA	= 	16'h9000;
	SET_OV7670 + 75 : 	LUT_DATA	= 	16'h9100;
	SET_OV7670 + 76 : 	LUT_DATA	= 	16'h9200;
	SET_OV7670 + 77 : 	LUT_DATA	= 	16'h9600;
	SET_OV7670 + 78 : 	LUT_DATA	= 	16'h9a80;
	SET_OV7670 + 79 : 	LUT_DATA	= 	16'hb084;
	SET_OV7670 + 80 : 	LUT_DATA	= 	16'hb10c;
	SET_OV7670 + 81 : 	LUT_DATA	= 	16'hb20e;
	SET_OV7670 + 82 : 	LUT_DATA	= 	16'hb382;
	SET_OV7670 + 83	: 	LUT_DATA	= 	16'hb80a;

	SET_OV7670 + 84  :	LUT_DATA	=	16'h4314;
	SET_OV7670 + 85  :	LUT_DATA	=	16'h44f0;
	SET_OV7670 + 86  :	LUT_DATA	=	16'h4534;
	SET_OV7670 + 87  :	LUT_DATA	=	16'h4658;
	SET_OV7670 + 88  :	LUT_DATA	=	16'h4728;
	SET_OV7670 + 89  :	LUT_DATA	=	16'h483a;
	SET_OV7670 + 90  :	LUT_DATA	=	16'h5988;
	SET_OV7670 + 91  :	LUT_DATA	=	16'h5a88;
	SET_OV7670 + 92  :	LUT_DATA	=	16'h5b44;
	SET_OV7670 + 93  :	LUT_DATA	=	16'h5c67;
	SET_OV7670 + 94  :	LUT_DATA	=	16'h5d49;
	SET_OV7670 + 95  :	LUT_DATA	=	16'h5e0e;
	SET_OV7670 + 96  :	LUT_DATA	=	16'h6404;
	SET_OV7670 + 97  :	LUT_DATA	=	16'h6520;
	SET_OV7670 + 98  :	LUT_DATA	=	16'h6605;
	SET_OV7670 + 99  :	LUT_DATA	=	16'h9404;
	SET_OV7670 + 100 :	LUT_DATA	=	16'h9508;
	SET_OV7670 + 101 :	LUT_DATA	=	16'h6c0a;
	SET_OV7670 + 102 :	LUT_DATA	=	16'h6d55;
	SET_OV7670 + 103 :	LUT_DATA	=	16'h6e11;
	SET_OV7670 + 104 :	LUT_DATA	=	16'h6f9f;
	SET_OV7670 + 105 :	LUT_DATA	=	16'h6a40;
	SET_OV7670 + 106 :	LUT_DATA	=	16'h0140;
	SET_OV7670 + 107 :	LUT_DATA	=	16'h0240;
	SET_OV7670 + 108 :	LUT_DATA	=	16'h13e7;
	SET_OV7670 + 109 :	LUT_DATA	=	16'h1500;
	
	SET_OV7670 + 110 :	LUT_DATA	= 	16'h4f80;
	SET_OV7670 + 111 :	LUT_DATA	= 	16'h5080;
	SET_OV7670 + 112 :	LUT_DATA	= 	16'h5100;
	SET_OV7670 + 113 :	LUT_DATA	= 	16'h5222;
	SET_OV7670 + 114 :	LUT_DATA	= 	16'h535e;
	SET_OV7670 + 115 :	LUT_DATA	= 	16'h5480;
	SET_OV7670 + 116 :	LUT_DATA	= 	16'h589e;
	
	SET_OV7670 + 117 : 	LUT_DATA	=	16'h4108;
	SET_OV7670 + 118 : 	LUT_DATA	=	16'h3f00;
	SET_OV7670 + 119 : 	LUT_DATA	=	16'h7505;
	SET_OV7670 + 120 : 	LUT_DATA	=	16'h76e1;
	SET_OV7670 + 121 : 	LUT_DATA	=	16'h4c00;
	SET_OV7670 + 122 : 	LUT_DATA	=	16'h7701;
	
	SET_OV7670 + 123 : 	LUT_DATA	=	16'h4b09;
	SET_OV7670 + 124 : 	LUT_DATA	=	16'hc9F0;//16'hc960;
	SET_OV7670 + 125 : 	LUT_DATA	=	16'h4138;
	SET_OV7670 + 126 : 	LUT_DATA	=	16'h5640;
	
	
	SET_OV7670 + 127 : 	LUT_DATA	=	16'h3411;
	SET_OV7670 + 128 : 	LUT_DATA	=	16'h3b02;
	SET_OV7670 + 129 : 	LUT_DATA	=	16'ha489;
	SET_OV7670 + 130 : 	LUT_DATA	=	16'h9600;
	SET_OV7670 + 131 : 	LUT_DATA	=	16'h9730;
	SET_OV7670 + 132 : 	LUT_DATA	=	16'h9820;
	SET_OV7670 + 133 : 	LUT_DATA	=	16'h9930;
	SET_OV7670 + 134 : 	LUT_DATA	=	16'h9a84;
	SET_OV7670 + 135 : 	LUT_DATA	=	16'h9b29;
	SET_OV7670 + 136 : 	LUT_DATA	=	16'h9c03;
	SET_OV7670 + 137 : 	LUT_DATA	=	16'h9d4c;
	SET_OV7670 + 138 : 	LUT_DATA	=	16'h9e3f;
	SET_OV7670 + 139 : 	LUT_DATA	=	16'h7804;
	
	
	SET_OV7670 + 140 :	LUT_DATA	=	16'h7901;
	SET_OV7670 + 141 :	LUT_DATA	= 	16'hc8f0;
	SET_OV7670 + 142 :	LUT_DATA	= 	16'h790f;
	SET_OV7670 + 143 :	LUT_DATA	= 	16'hc800;
	SET_OV7670 + 144 :	LUT_DATA	= 	16'h7910;
	SET_OV7670 + 145 :	LUT_DATA	= 	16'hc87e;
	SET_OV7670 + 146 :	LUT_DATA	= 	16'h790a;
	SET_OV7670 + 147 :	LUT_DATA	= 	16'hc880;
	SET_OV7670 + 148 :	LUT_DATA	= 	16'h790b;
	SET_OV7670 + 149 :	LUT_DATA	= 	16'hc801;
	SET_OV7670 + 150 :	LUT_DATA	= 	16'h790c;
	SET_OV7670 + 151 :	LUT_DATA	= 	16'hc80f;
	SET_OV7670 + 152 :	LUT_DATA	= 	16'h790d;
	SET_OV7670 + 153 :	LUT_DATA	= 	16'hc820;
	SET_OV7670 + 154 :	LUT_DATA	= 	16'h7909;
	SET_OV7670 + 155 :	LUT_DATA	= 	16'hc880;
	SET_OV7670 + 156 :	LUT_DATA	= 	16'h7902;
	SET_OV7670 + 157 :	LUT_DATA	= 	16'hc8c0;
	SET_OV7670 + 158 :	LUT_DATA	= 	16'h7903;
	SET_OV7670 + 159 :	LUT_DATA	= 	16'hc840;
	SET_OV7670 + 160 :	LUT_DATA	= 	16'h7905;
	SET_OV7670 + 161 :	LUT_DATA	= 	16'hc830; 
	SET_OV7670 + 162 :	LUT_DATA	= 	16'h7926;
	
	SET_OV7670 + 163 :	LUT_DATA	= 	16'h0903;
	SET_OV7670 + 164 :	LUT_DATA	= 	16'h3b42;
	default		 :	LUT_DATA	=	0;
	endcase
end

endmodule
