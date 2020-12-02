#include "ili932x.h"
#include "unistd.h"       // usleep()
#include "ascii_8x16.h"   // ascii码字库
#include "GB16.h"         // 汉字字库


// 8位总线模式，通过两次写操作写入高8位和低8位
void ili_WrDB_2x8b(u8 DH, u8 DL)
{	
  ili_DB->DATA=DH;	
  ili_nWR=0;
	ili_nWR=1;
	ili_DB->DATA=DL;	
  ili_nWR=0;
	ili_nWR=1;
}


// 写命令
void ili_WrCmd(u8 DH, u8 DL)
{
  ili_RS=0;  
  ili_WrDB_2x8b(DH, DL);
}


// 写数据
void ili_WrData(u8 DH, u8 DL)
{
  ili_RS=1;
  ili_WrDB_2x8b(DH, DL);
}


// 向DB总线写数据
void ili_WrDB_16b(u16 data)
{
  ili_WrData(data>>8, data);
}


// 写寄存器
void ili_WrReg(u8 cmd, u16 data)
{
  ili_WrCmd(0x00, cmd);
  ili_WrDB_16b(data);
}


// 延时ms
void ili_DelayMs(u32 n)
{
  usleep(n*1000);
}


// ILI93525初始化
void ili_Initial(void)
{ 
  // 硬件复位
  ili_nRST=0;
  ili_DelayMs(1);
  ili_nRST=1;
  // 打开片选，输出使能
  ili_nCS=0;
  DB_o_EN;
  //
  ili_WrReg(0xE3, 0x3008);
  ili_WrReg(0xE7, 0x0012);
  ili_WrReg(0xEF, 0x1231); // Set the internal timing
  ili_WrReg(0x01, 0x0000); // Set SS and SM bit
  ili_WrReg(0x02, 0x0700); // Set 1 line inversion
  // 屏幕旋转控制
#if   ID_AM==000
  ili_WrReg(0x03, 0x1000); // TRI=0, DFM=x, BGR=0, HWM=0, ORG=0, I/D[1:0]=00, AM=0
#elif ID_AM==001
  ili_WrReg(0x03, 0x1008); // TRI=0, DFM=x, BGR=0, HWM=0, ORG=0, I/D[1:0]=00, AM=0
#elif ID_AM==010
  ili_WrReg(0x03, 0x1010); // TRI=0, DFM=x, BGR=0, HWM=0, ORG=0, I/D[1:0]=01, AM=0
#elif ID_AM==011
  ili_WrReg(0x03, 0x1018); // TRI=0, DFM=x, BGR=0, HWM=0, ORG=0, I/D[1:0]=01, AM=1
#elif ID_AM==100
  ili_WrReg(0x03, 0x1020); // TRI=0, DFM=x, BGR=0, HWM=0, ORG=0, I/D[1:0]=10, AM=0
#elif ID_AM==101
  ili_WrReg(0x03, 0x1028); // TRI=0, DFM=x, BGR=0, HWM=0, ORG=0, I/D[1:0]=10, AM=1
#elif ID_AM==110
  ili_WrReg(0x03, 0x1030); // TRI=0, DFM=x, BGR=0, HWM=0, ORG=0, I/D[1:0]=11, AM=0
#elif ID_AM==111
  ili_WrReg(0x03, 0x1038); // TRI=0, DFM=x, BGR=0, HWM=0, ORG=0, I/D[1:0]=11, AM=1
#endif
  ili_WrReg(0x04, 0x0000); // Resize register
  ili_WrReg(0x08, 0x0404); // Set the back porch and front porch
  ili_WrReg(0x09, 0x0000); // Set non-display area refresh cycle ISC[3:0]
  ili_WrReg(0x0A, 0x0000); // FMARK function
  ili_WrReg(0x0C, 0x0000); // RGB interface setting
  ili_WrReg(0x0D, 0x0000); // Frame marker Position
  ili_WrReg(0x0F, 0x0000); // RGB interface polarity
  // Power on sequence VGHVGL
  ili_WrReg(0x10, 0x0000); // SAP, BT[3:0], AP, DSTB, SLP, STB
  ili_WrReg(0x11, 0x0007); // DC1[2:0], DC0[2:0], VC[2:0]
  ili_WrReg(0x12, 0x0000); // VREG1OUT voltage
  ili_WrReg(0x13, 0x1300); // VDV[4:0] for VCOM amplitude
  ili_WrReg(0x07, 0x0001);
  ili_DelayMs(50);         // Dis-charge capacitor power voltage
  ili_WrReg(0x10, 0x1590); // SAP, BT[3:0], AP, DSTB, SLP, STB
  ili_WrReg(0x11, 0x0227); // DC1[2:0], DC0[2:0], VC[2:0]
  ili_DelayMs(50);
  ili_WrReg(0x12, 0x001E); // Internal reference voltage= Vci;
  ili_DelayMs(50);
  ili_WrReg(0x13, 0x1500); // Set VDV[4:0] for VCOM amplitude
  ili_WrReg(0x29, 0x0026); // Set VCM[5:0] for VCOMH
  ili_WrReg(0x2B, 0x000F); // Set Frame Rate
  ili_DelayMs(50);
  ili_WrReg(0x20, 0x0000);
  ili_WrReg(0x21, 0x013f);
  // GRAM起始位置
#if   ID_AM==000
  ili_WrReg(0x20, 0x00EF);
  ili_WrReg(0x21, 0x013F);
#elif ID_AM==001
  ili_WrReg(0x20, 0x00EF);
  ili_WrReg(0x21, 0x013F);
#elif ID_AM==010
  ili_WrReg(0x20, 0x0000);
  ili_WrReg(0x21, 0x013F);
#elif ID_AM==011
  ili_WrReg(0x20, 0x0000);
  ili_WrReg(0x21, 0x013F);
#elif ID_AM==100
  ili_WrReg(0x20, 0x00EF);
  ili_WrReg(0x21, 0x0000);
#elif ID_AM==101
  ili_WrReg(0x20, 0x00EF);
  ili_WrReg(0x21, 0x0000);
#elif ID_AM==110
  ili_WrReg(0x20, 0x0000);
  ili_WrReg(0x21, 0x0000);
#elif ID_AM==111
  ili_WrReg(0x20, 0x0000);
  ili_WrReg(0x21, 0x0000);
#endif
  // Adjust the Gamma Curve
  ili_WrReg(0x30, 0x0007);
  ili_WrReg(0x31, 0x0007);
  ili_WrReg(0x32, 0x0107);
  ili_WrReg(0x35, 0x0206);
  ili_WrReg(0x36, 0x0406);
  ili_WrReg(0x37, 0x0101);
  ili_WrReg(0x38, 0x0101);
  ili_WrReg(0x39, 0x0207);
  ili_WrReg(0x3C, 0x0504);
  ili_WrReg(0x3D, 0x0806);
  // Set GRAM area
  ili_WrReg(0x50, 0x0000); // Horizontal GRAM Start Address
  ili_WrReg(0x51, 0x00EF); // Horizontal GRAM End Address
  ili_WrReg(0x52, 0x0000); // Vertical GRAM Start Address
  ili_WrReg(0x53, 0x013F); // Vertical GRAM Start Address
  ili_WrReg(0x60, 0x2700); // Gate Scan Line
  ili_WrReg(0x61, 0x0001); // NDL,VLE, REV
  ili_WrReg(0x6A, 0x0000); // Set scrolling line
  // Partial Display Control
  ili_WrReg(0x80, 0x0000);
  ili_WrReg(0x81, 0x0000);
  ili_WrReg(0x82, 0x0000);
  ili_WrReg(0x83, 0x0000);
  ili_WrReg(0x84, 0x0000);
  ili_WrReg(0x85, 0x0000);
  // Panel Control
  ili_WrReg(0x90, 0x0010);
  ili_WrReg(0x92, 0x0600);
  ili_WrReg(0x93, 0x0003);
  ili_WrReg(0x95, 0x0110);
  ili_WrReg(0x97, 0x0000);
  ili_WrReg(0x98, 0x0000);
  ili_WrReg(0x07, 0x0173); // 262K color and display ON
  // 关闭片选
  ili_nCS=1;}


// 设定Cursor
void ili_SetCursor(u8 x, u16 y)
{
  ili_WrReg(0x20, x);
  ili_WrReg(0x21, y);
}


// 设定显示区域
void ili_SetDispArea(u16 x0, u16 y0, u8 xLength, u16 yLength, u16 xOffset, u16 yOffset)
{
#if ID_AM==000
  ili_SetCursor(x0+xLength-1+xOffset, y0+yLength-1+yOffset);
#elif ID_AM==001
  ili_SetCursor(x0+xLength-1+xOffset, y0+yLength-1+yOffset);
#elif ID_AM==010
  ili_SetCursor(x0+xOffset, y0+yLength-1+yOffset);
#elif ID_AM==011
  ili_SetCursor(x0+xOffset, y0+yLength-1+yOffset);
#elif ID_AM==100
  ili_SetCursor(x0+xLength-1+xOffset, y0+yOffset);
#elif ID_AM==101
  ili_SetCursor(x0+xLength-1+xOffset, y0+yOffset);
#elif ID_AM==110
  ili_SetCursor(x0+xOffset, y0+yOffset);
#elif ID_AM==111
  ili_SetCursor(x0+xOffset, y0+yOffset);
#endif
  ili_WrReg(0x50, x0+xOffset);             // 水平 GRAM起始位置
  ili_WrReg(0x51, x0+xLength-1+xOffset);   // 水平GRAM终止位置
  ili_WrReg(0x52, y0+yOffset);             // 垂直GRAM起始位置
  ili_WrReg(0x53, y0+yLength-1+yOffset);   // 垂直GRAM终止位置
  ili_WrCmd(0x00, 0x22);
}          


// 清屏
void ili_ClearScreen(u32 bColor)
{
  u32 i;

  ili_nCS=0;
  DB_o_EN;

  ili_SetDispArea(0, 0, 240, 320, 0, 0);
  for (i=0; i<76800; i++) ili_WrDB_16b(bColor);

  ili_nCS=1;
}


// 画点（单次操作）
void ili_PlotPoint(u8 x, u16 y, u16 color)
{
  ili_nCS=0;
  DB_o_EN;

  ili_SetCursor(x, y);
  ili_WrCmd(0x00, 0x22);
  ili_WrDB_16b(color);

  ili_nCS=1;
}


// 画点（连续操作的一部分）
void ili_PlotPixel(u8 x, u16 y, u16 color)
{
  ili_SetCursor(x, y);
  ili_WrCmd(0x00, 0x22);
  ili_WrDB_16b(color);
}


// 画一个大点
void ili_PlotBigPoint(u8 x, u16 y, u16 color)
{
  u8 i, j;
  ili_nCS=0;
  DB_o_EN;
  for(i=0; i<3; i++)
  {
    for(j=0; j<3; j++) ili_PlotPixel(x+i, y+j, color);
  }
  ili_nCS=1;
}


// 打印ASCII码（8x16）
void ili_PutAscii_8x16(u16 x, u16 y, uc8 c, u32 fColor, u32 bColor)
{
  u32 i, j;
  u8 temp;

  ili_nCS=0;
  DB_o_EN;

  ili_SetDispArea(x, y, 8, 16, 0, 0);
  for(i=0; i<16; i++) 
  {
    temp = ascii_8x16_tab[c*16+i];
    for(j=0; j<8; j++) 
    {
      if((temp&0x80) == 0x80) 
        ili_WrDB_16b(fColor);
      else
        ili_WrDB_16b(bColor);
      temp <<= 1;
    }
  }

  ili_nCS=1;
}


// 打印汉字（16x16）
void ili_PutGB16(u16 x, u16 y, uc8 c[2], u32 fColor, u32 bColor)
{
  u32 i, j, k;
  u16 temp;

  ili_nCS=0;
  DB_o_EN;

  ili_SetDispArea(x, y, 16, 16, 0, 0);
  for(k=0; k<64; k++) // 64表示自建汉字库中的个数，循环查询内码
  { 
    if ( (GB16[k].Index[0]==c[0])
      && (GB16[k].Index[1]==c[1]) )
    { 
      for(i=0; i<32; i++) 
      {
        temp = GB16[k].Msk[i];
        for(j=0; j<8; j++) 
        {
          if((temp&0x80)==0x80) 
            ili_WrDB_16b(fColor);
          else
            ili_WrDB_16b(bColor);
          temp <<= 1;
        } 
      }
    }  
  }

  ili_nCS=1;
}


// 打印字符串
void ili_PutString(u16 x, u16 y, uc8 *s, u32 fColor, u32 bColor)
{
  u8 l=0;
  while(*s != '\0')
  {
    if(*s < 0x80)
    {
      ili_PutAscii_8x16(x+l*8, y, *s, fColor, bColor);
      s++; 
      l++;
    }
    else
    {
      ili_PutGB16(x+l*8, y, (u8*)s, fColor, bColor);
      s+=2;
      l+=2;
    }
  }
}


// 彩条测试
void ili_DispColorBar(void)
{
  u16 V, H;

  ili_nCS=0;
  DB_o_EN;

  ili_SetDispArea(0, 0, 240, 320, 0, 0);
  for(H=0; H<240; H++)
  {
    for(V=0; V<40; V++) ili_WrDB_16b(White);
  }
  for(H=0;H<240;H++)
  {
    for(V=40; V<80; V++) ili_WrDB_16b(Black);
  }
  for(H=0;H<240;H++)
  {
    for(V=80; V<120; V++) ili_WrDB_16b(Blue);
  }
  for(H=0;H<240;H++)
  {
    for(V=120; V<160; V++) ili_WrDB_16b(Red);
  }
  for(H=0;H<240;H++)
  {
    for(V=160; V<200; V++) ili_WrDB_16b(Magenta);
  }
  for(H=0;H<240;H++)
  {
    for(V=200; V<240; V++) ili_WrDB_16b(Green);
  }
  for(H=0;H<240;H++)
  {
    for(V=240; V<280; V++) ili_WrDB_16b(Cyan);
  }
  for(H=0;H<240;H++)
  {
    for(V=280;V<320;V++) ili_WrDB_16b(Yellow);
  }

  ili_nCS=1;
}
