#ifndef SD_CARD_H_
#define SD_CARD_H_


#include "my_types.h"
#include "my_regs.h"


#define ENABLE_SD_CARD_DEBUG // turn on debug message


void SD_CARD_Port_Init();
void SD_CARD_Write_Byte(u8 byte);
u8 SD_CARD_Read_Byte();
u8 SD_CARD_Write_CMD(u8 *CMD);
//
u8 SD_CARD_Init();
u8 SD_CARD_Write_Sector(u32 addr,u8 *buf);
u8 SD_CARD_Read_Sector(u8 *CMD,u8 *buf,u16 n_bytes);
u8 SD_CARD_Read_Sector_Start(u32 sector);
void SD_CARD_Read_Data(u16 n_bytes,u8 *buf);
void SD_CARD_Read_Data_LBA(u32 LBA,u16 n_bytes,u8 *buf);
void SD_CARD_Read_Sector_End();
u8 SD_CARD_Read_CSD(u8 *buf);
u8 SD_CARD_Read_CID(u8 *buf);
void SD_CARD_Get_Info(void);
void SD_CARD_DEMO(void);


#endif /* SD_CARD_H_ */
