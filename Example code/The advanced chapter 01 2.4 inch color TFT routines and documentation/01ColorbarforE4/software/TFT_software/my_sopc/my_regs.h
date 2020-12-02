#ifndef MY_REGS_H_
#define MY_REGS_H_

#include "system.h"
#include "my_types.h"

#define ILI9325
#define ADS7843
#define SD_CARD

// PIO Data structure
typedef struct
{
    vu32 DATA           : 32;
    vu32 DIRECTION      : 32;
    vu32 INTERRUPT_MASK : 32;
    vu32 EDGE_CAPTURE   : 32;

}PIO_STR;

// ili9325 I/O
#ifdef ILI9325
  #define ili_nCS   *(vu32 *)(ILI_NCS_BASE  | (1<<31))
  #define ili_nRST  *(vu32 *)(ILI_NRST_BASE | (1<<31))
  #define ili_RS    *(vu32 *)(ILI_RS_BASE   | (1<<31))
  #define ili_nWR   *(vu32 *)(ILI_NWR_BASE  | (1<<31))
  #define ili_nRD   *(vu32 *)(ILI_NRD_BASE  | (1<<31))
  #define ili_DB    ((PIO_STR *)(ILI_DB_BASE  | (1<<31)))
#endif

// ADS7843 I/O
#ifdef ADS7843
//  #define ads_nIRQ  *(vu32 *)(ADS_NIRQ_BASE | (1<<31))
//  #define ads_BUSY  *(vu32 *)(ADS_BUSY_BASE | (1<<31))
  #define ads_nCS   *(vu32 *)(ADS_NCS_BASE  | (1<<31))
  #define ads_CLK   *(vu32 *)(ADS_CLK_BASE  | (1<<31))
  #define ads_DIN   *(vu32 *)(ADS_DIN_BASE  | (1<<31))
  #define ads_DOUT  *(vu32 *)(ADS_DOUT_BASE | (1<<31))
#endif

// SD Card I/O
#ifdef SD_CARD
  #define sd_CLK    *(vu32 *)(SD_CLK_BASE     | (1<<31))
  #define sd_nCS    *(vu32 *)(SD_NCS_BASE     | (1<<31))
  #define sd_DIN    *(vu32 *)(SD_DIN_BASE     | (1<<31))
  #define sd_DOUT   *(vu32 *)(SD_DOUT_BASE    | (1<<31))
#endif

#endif /* MY_REGS_H_ */
