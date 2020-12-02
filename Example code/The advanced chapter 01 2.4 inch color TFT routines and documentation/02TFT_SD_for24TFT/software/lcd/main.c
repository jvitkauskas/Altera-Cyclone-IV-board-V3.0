#include <stdio.h>                    // printf()
#include <unistd.h>                   // usleep()
#include "my_types.h"                 // 数据类型
#include "debug.h"                    // debug
#include "sd_card.h"                  // sd_card
#include "ili932x.h"                  // ili9325


#define ENABLE_APP_DEBUG // turn on debug message
#ifdef ENABLE_APP_DEBUG
    #define APP_DEBUG(x)    DEBUG(x)
#else
    #define APP_DEBUG(x)
#endif


#define PIC_NUM      2    // 图片数量
#define START_SECTOR 8337 // 数据存储的起始扇区，注意没有用文件系统，所以初始地址是物理扇区，非逻辑扇区，在winhex查看时有两个，只用其中一个。
void DispPic_Demo(void)
{
  u16 i, j;
  u8 pic_num=0;         // 照片数量
  u8 sector_buf[512];
  u32 sector_addr;

  sector_addr=START_SECTOR;
  do
  {
    ili_nCS=0;
    DB_o_EN;

    ili_SetDispArea(0, 0, 240, 320, 0, 0);
    for(j=0;j<300;j++)   //300表示一幅图片含有300x512字节的信息
    {
      SD_CARD_Read_Data_LBA(sector_addr+j, 512, sector_buf);//每次读出512字节放到缓冲区
      for(i=0;i<256;i++) //然后写到液晶屏，可以显示256个像素，每个像素16位即2个字节
        ili_WrData(sector_buf[2*i+1],sector_buf[2*i]);
    }


    ili_nCS=1;

    sector_addr += 304;//304根据实际winhex查看结果值
    pic_num++;
    usleep(2*1000*1000); // 延时2s
  }while(pic_num < PIC_NUM);
}


int main()
{
  ili_Initial();            // 初始化ILI9325
  while(SD_CARD_Init() != 0x55);// 初始化SD卡
  while(1)
  {
    DispPic_Demo();
  }
  return 0;
}
