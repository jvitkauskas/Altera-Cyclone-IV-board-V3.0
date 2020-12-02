#ifndef ILI932X_H_
#define ILI932X_H_
//
#include "my_types.h"
#include "my_regs.h"
//
#define White          0xFFFF
#define Black          0x0000
#define Blue           0x001F
#define Blue2          0x051F
#define Red            0xF800
#define Magenta        0xF81F
#define Green          0x07E0
#define Cyan           0x7FFF
#define Yellow         0xFFE0
//
#define ID_AM    110
//
#define DB_o_EN  ili_DB->DIRECTION=0xFF
#define DB_i_EN  ili_DB->DIRECTION=0x00
//
void ili_WrDB_2x8b(u8 DH, u8 DL);
void ili_WrCmd(u8 DH, u8 DL);
void ili_WrData(u8 DH, u8 DL);
void ili_WrReg(u8 cmd, u16 data);
void ili_WrDB_16b(u16 data);
//
void ili_DelayMs(u32 n);
void ili_Initial(void);
void ili_SetCursor(u8 x, u16 y);
void ili_SetDispArea(u16 x0, u16 y0, u8 xLength, u16 yLength, u16 xOffset, u16 yOffset);
void ili_ClearScreen(u32 bColor);
//
void ili_PlotPoint(u8 x, u16 y, u16 color);
void ili_PlotPixel(u8 x, u16 y, u16 color);
void ili_PlotBigPoint(u8 x, u16 y, u16 color);
//
void ili_PutAscii_8x16(u16 x, u16 y, uc8 c, u32 fColor, u32 bColor);
void ili_PutGb_16x16(u16 x, u16 y, uc8 c[2], u32 fColor, u32 bColor);
void ili_PutString(u16 x, u16 y, uc8 *s, u32 fColor, u32 bColor);
//
void ili_DispColorBar(void);
//
#endif /* ILI932X_H_ */
