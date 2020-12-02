#include <unistd.h>
#include "sd_card.h"


// debug switch
#ifdef ENABLE_SD_CARD_DEBUG
  #include "debug.h"
  #define SD_CARD_DEBUG(x)  DEBUG(x)
#else
  #define SD_CARD_DEBUG(x)
#endif


// error macro
#define INIT_CMD0_ERROR   0x01
#define INIT_CMD1_ERROR   0x02
#define WRITE_BLOCK_ERROR 0x03
#define READ_BLOCK_ERROR  0x04


// SD-CARD(SPI mode) initial with low speed
// insert a certain delay
#define SD_CARD_INIT_DELAY usleep(10)


// CID info structure
typedef union
{
  u8 data[16];
  struct
  {
    u8 MID;   // Manufacture ID; Binary
    u8 OLD[2];// OEM/Application ID; ASCII
    u8 PNM[5];// Product Name; ASCII
    u8 PRV;   // Product Revision; BCD
    u8 PSN[4];// Serial Number; Binary
    u8 MDT[2];// Manufacture Data Code; BCD; upper 4 bits of first byte are reserved
    u8 CRC;   // CRC7_checksum; Binary; LSB are reserved
  };
}CID_Info_STR;


// CSD info structure
typedef struct
{
  u8 data[16];
  u32 capacity_MB;
  u8 READ_BL_LEN;
  u16 C_SIZE;
  u8 C_SIZE_MULT;
}CSD_Info_STR;


// flags
u16 gByteOffset=0;       // byte offset in one sector
u16 gSectorOffset=0;     // sector offset in SD-CARD
bool gSectorOpened=FALSE;// set to 1 when a sector is opened.
bool gSD_CARDInit=FALSE; // set it to 1 when SD-CARD is initialized


// SD-CARD port init
void SD_CARD_Port_Init()
{
  sd_CLK=1;
  sd_DOUT=1;
  sd_nCS=1;
}


// write a byte to SD-CARD
void SD_CARD_Write_Byte(u8 byte)
{
  u8 i;
  for(i=0;i<8;i++)
  { // MSB First
    sd_DIN=(byte >> (7-i)) & 0x1;
    sd_CLK=0;if(gSD_CARDInit) SD_CARD_INIT_DELAY;
    sd_CLK=1;if(gSD_CARDInit) SD_CARD_INIT_DELAY;
  }
}


// read a byte to SD-CARD
u8 SD_CARD_Read_Byte()
{
  u8 i,byte;
  byte=0;
  for(i=0;i<8;i++)
  { // MSB First
    sd_CLK=0;if(gSD_CARDInit) SD_CARD_INIT_DELAY;
    byte<<=1;if(sd_DOUT) byte++;
    sd_CLK=1;if(gSD_CARDInit) SD_CARD_INIT_DELAY;
  }
  return byte;
}


// write a command to SD-CARD
// return: the second byte of response register of SD-CARD
u8 SD_CARD_Write_CMD(u8 *CMD)
{
  u8 temp,retry;
  u8 i;

  sd_nCS=1; // set chipselect (disable SD-CARD)
  SD_CARD_Write_Byte(0xFF); // send 8 clock impulse
  sd_nCS=0; // clear chipselect (enable SD-CARD)

  // write 6 bytes command to SD-CARD
  for(i=0;i<6;i++) SD_CARD_Write_Byte(*CMD++);

  // get 16 bits response
  SD_CARD_Read_Byte(); // read the first byte, ignore it.
  retry=0;
  do
  { // only last 8 bits is valid
    temp=SD_CARD_Read_Byte();
    retry++;
  }
  while((temp==0xff) && (retry<100));
  return temp;
}


// SD-CARD initialization(SPI mode)
u8 SD_CARD_Init()
{
  u8 retry,temp;
  u8 i;
  u8 CMD[]={0x40,0x00,0x00,0x00,0x00,0x95};

  SD_CARD_Port_Init();
  usleep(500000);

  SD_CARD_DEBUG(("SD-CARD Init!\n"));
  gSD_CARDInit=TRUE; // Set init flag of SD-CARD
  
  for(i=0;i<10;i++) SD_CARD_Write_Byte(0xff);// send 74 clock at least!!!

  // write CMD0 to SD-CARD
  retry=0;
  do
  { // retry 200 times to write CMD0
    temp=SD_CARD_Write_CMD(CMD);
    retry++;
    if(retry==100) return INIT_CMD0_ERROR;// CMD0 error!
  }
  while(temp!=1);

  //write CMD1 to SD-CARD
  CMD[0]=0x41;// Command 1
  CMD[5]=0xFF;
  retry=0;
  do
  { // retry 100 times to write CMD1
    temp=SD_CARD_Write_CMD(CMD);
    retry++;
    if(retry==100)  return INIT_CMD1_ERROR;// CMD1 error!
  }
  while(temp!=0);

  gSD_CARDInit=FALSE; // clear init flag of SD-CARD

  sd_nCS=1; // disable SD-CARD
  SD_CARD_DEBUG(("SD-CARD Init Suc!\n"));
  return 0x55;// All commands have been taken.
}


// writing a Block(512Byte, 1 sector) to SD-CARD
// return 0 if sector writing is completed.
u8 SD_CARD_Write_Sector(u32 addr,u8 *buf)
{
  u8 temp,retry;
  u16 i;

  // CMD24 for writing blocks
  u8 CMD[]={0x58,0x00,0x00,0x00,0x00,0xFF};
  SD_CARD_DEBUG(("Write A Sector Starts!!\n"));

  addr=addr << 9;// addr=addr * 512

  CMD[1]=((addr & 0xFF000000) >>24 );
  CMD[2]=((addr & 0x00FF0000) >>16 );
  CMD[3]=((addr & 0x0000FF00) >>8 );

  // write CMD24 to SD-CARD(write 1 block/512 bytes, 1 sector)
  retry=0;
  do
  { // retry 100 times to write CMD24
    temp=SD_CARD_Write_CMD(CMD);
    retry++;
    if(retry==100) return(temp);//CMD24 error!
  }
  while(temp!=0);

  // before writing, send 100 clock to SD-CARD
  for(i=0;i<100;i++) SD_CARD_Read_Byte();

  // write start byte to SD-CARD
  SD_CARD_Write_Byte(0xFE);

  SD_CARD_DEBUG(("\n"));
  // now write real bolck data(512 bytes) to SD-CARD
  for(i=0;i<512;i++) SD_CARD_Write_Byte(*buf++);

  SD_CARD_DEBUG(("CRC-Byte\n"));
  SD_CARD_Write_Byte(0xFF);// dummy CRC
  SD_CARD_Write_Byte(0xFF);// dummy CRC

  // read response
  temp=SD_CARD_Read_Byte();
  if( (temp & 0x1F)!=0x05 ) // data block accepted ?
  {
    sd_nCS=1; // disable SD-CARD
    return WRITE_BLOCK_ERROR;// error!
  }

  // wait till SD-CARD is not busy
  while(SD_CARD_Read_Byte()!=0xff){};

  sd_nCS=1; // disable SD-CARD

  SD_CARD_DEBUG(("Write Sector suc!!\n"));
  return 0;
}


// read bytes in a block(normally 512KB, 1 sector) from SD-CARD
// return 0 if no error.
u8 SD_CARD_Read_Sector(u8 *CMD,u8 *buf,u16 n_bytes)
{
  u16 i;
  u8 retry,temp;

  // write CMD to SD-CARD
  retry=0;
  do
  { // Retry 100 times to write CMD
    temp=SD_CARD_Write_CMD(CMD);
    retry++;
    if(retry==100) return READ_BLOCK_ERROR;// block read error!
  }
  while(temp!=0);

  // read start byte form SD-CARD (0xFE/Start Byte)
  while(SD_CARD_Read_Byte()!=0xfe);

  // read bytes in a block(normally 512KB, 1 sector) from SD-CARD
  for(i=0;i<n_bytes;i++)  *buf++=SD_CARD_Read_Byte();

  SD_CARD_Read_Byte();// dummy CRC
  SD_CARD_Read_Byte();// dummy CRC

  sd_nCS=1; // disable SD-CARD
  return 0;
}


// return: [0]-success or something error!
u8 SD_CARD_Read_Sector_Start(u32 sector)
{
  u8 retry;
  // CMD16 for reading Blocks
  u8 CMD[]={0x51,0x00,0x00,0x00,0x00,0xFF};
  u8 temp;

  // address conversation(logic block address-->byte address)
  sector=sector << 9;// sector=sector * 512
  CMD[1]=((sector & 0xFF000000) >>24 );
  CMD[2]=((sector & 0x00FF0000) >>16 );
  CMD[3]=((sector & 0x0000FF00) >>8 );

  // write CMD16 to SD-CARD
  retry=0;
  do
  {
    temp=SD_CARD_Write_CMD(CMD);
    retry++;
    if(retry==100) return READ_BLOCK_ERROR;// READ_BLOCK_ERROR
  }
  while( temp!=0 );

  // read start byte form SD-CARD (feh/start byte)
  while (SD_CARD_Read_Byte() != 0xfe);

  SD_CARD_DEBUG(("Open a Sector Succ!\n"));
  gSectorOpened=TRUE;
  return 0;
}


void SD_CARD_Read_Data(u16 n_bytes,u8 *buf)
{
  u16 i;
  for(i=0;((i<n_bytes) && (gByteOffset<512));i++)
  {
    *buf++=SD_CARD_Read_Byte();
    gByteOffset++;// increase byte offset in a sector
  }
  if(gByteOffset==512)
  {
    SD_CARD_Read_Byte(); // Dummy CRC
    SD_CARD_Read_Byte(); // Dummy CRC
    gByteOffset=0;       // clear byte offset in a sector
    gSectorOffset++;     // one sector is read completely
    gSectorOpened=FALSE; // set to 1 when a sector is opened
    sd_nCS=1;            // disable SD-CARD
  }
}


// read block date by logic block address(sector offset)
void SD_CARD_Read_Data_LBA(u32 LBA,u16 n_bytes,u8 *buf)
{ // if one sector is read completely; open the next sector
  if(gByteOffset==0) SD_CARD_Read_Sector_Start(LBA);
  SD_CARD_Read_Data(n_bytes,buf);
}


// dummy read out the rest bytes in a sector
void SD_CARD_Read_Sector_End()
{
  u8 temp[1];
  while((gByteOffset!=0x00) | (gSectorOpened==TRUE))
    SD_CARD_Read_Data(1,temp); // dummy read
}


// read CSD registers of SD-CARD
// return 0 if no error.
u8 SD_CARD_Read_CSD(u8 *buf)
{ // command for reading CSD registers
  u8 CMD[]={0x49,0x00,0x00,0x00,0x00,0xFF};
  return SD_CARD_Read_Sector(CMD,buf,16);// read 16 bytes
}


// read CID register of SD-CARD
// return 0 if no error.
u8 SD_CARD_Read_CID(u8 *buf)
{ // command for reading CID registers
  u8 CMD[]={0x4A,0x00,0x00,0x00,0x00,0xFF};
  return SD_CARD_Read_Sector(CMD,buf,16);//read 16 bytes
}


void SD_CARD_Get_Info(void)
{
  CID_Info_STR CID;
  CSD_Info_STR CSD;

  SD_CARD_Read_CID(CID.data);
  SD_CARD_DEBUG(("SD-CARD CID:\n"));
  SD_CARD_DEBUG(("  Manufacturer ID(MID): 0x%.2X\n", CID.MID));
  SD_CARD_DEBUG(("  OEM/Application ID(OLD): %c%c\n", CID.OLD[0], CID.OLD[1]));
  SD_CARD_DEBUG(("  Product Name(PNM): %c%c%c%c%c\n", CID.PNM[0], CID.PNM[1], CID.PNM[2], CID.PNM[3], CID.PNM[4]));
  SD_CARD_DEBUG(("  Product Revision: 0x%.2X\n", CID.PRV));
  SD_CARD_DEBUG(("  Serial Number(PSN): 0x%.2X%.2X%.2X%.2X\n", CID.PSN[0], CID.PSN[1], CID.PSN[2], CID.PSN[3]));
  SD_CARD_DEBUG(("  Manufacture Date Code(MDT): 0x%.1X%.2X\n", CID.MDT[0] & 0x0F, CID.MDT[1]));
  SD_CARD_DEBUG(("  CRC-7 Checksum(CRC7):0x%.2X\n", CID.CRC >> 1));

  SD_CARD_Read_CSD(CSD.data);
  CSD.C_SIZE = ((CSD.data[6]&0x03) << 10) | (CSD.data[7] << 2) | ((CSD.data[8]&0xC0) >>6);
  CSD.C_SIZE_MULT = ((CSD.data[9]&0x03) << 1) | ((CSD.data[10]&0x80) >> 7);
  CSD.READ_BL_LEN = (CSD.data[5]&0x0F);
  CSD.capacity_MB = (((CSD.C_SIZE)+1) << (((CSD.C_SIZE_MULT) +2) + (CSD.READ_BL_LEN))) >> 20;
  SD_CARD_DEBUG(("SD-CARD CSD:\n"));
  SD_CARD_DEBUG(("  max.read data block length: %d\n", 1<<CSD.READ_BL_LEN));
  SD_CARD_DEBUG(("  device size: %d\n", CSD.C_SIZE));
  SD_CARD_DEBUG(("  device size multiplier: %d\n", CSD.C_SIZE_MULT));
  SD_CARD_DEBUG(("  device capacity: %d MB\n", CSD.capacity_MB));
}


void SD_CARD_DEMO(void)
{
  u16 i;
  u8 buf[512];

  // init SD-CARD
  while(SD_CARD_Init() != 0x55);
  // Get CID & CSD
  SD_CARD_Get_Info();
  // read the 1st block(sector) of SD-Card
  SD_CARD_Read_Data_LBA(0,512,buf);
  for(i=0; i<512; i++)
  {
    SD_CARD_DEBUG(("%.2X ", buf[i]));
    if((i+1) % 16 == 0) SD_CARD_DEBUG(("\n"));
  }
}
