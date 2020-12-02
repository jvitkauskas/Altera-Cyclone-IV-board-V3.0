#ifndef ADS7843_H_
#define ADS7843_H_

#include "my_types.h"
#include "my_regs.h"


#define CHX 0x90
#define CHY 0xD0


void ads_SPIStart(void);
void ads_SPIWrite(u8 cmd);
u16 ads_SPIRead(void);
bool ads_ReadXY(void);
bool ads_GetXY(void);
u8 *intostr(u16 n);

#endif /* ADS7843_H_ */
