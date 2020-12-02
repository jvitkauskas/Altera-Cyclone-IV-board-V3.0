#ifndef __KEY_H__
#define __KEY_H__
#include "gui.h"

u8 		ReadKeyValue(void);
void 	KeyScan_Init(void);
u8	 	KeyScan_GetKey(u8 *KeyType);
bool	KeyScan_CheckRepeat(void);
void 	KeyScan_ServiceLoop(void);

//----------------------------------------------------------------------------------------------------------
#define		KEY_PORT 		GPIOG
#define 	KEYA1			GPIO_Pin_7
#define		KEYA2			GPIO_Pin_8

#define		KEYB1			GPIO_Pin_14
#define		KEYB2			GPIO_Pin_13
#define		KEYB3			GPIO_Pin_11
#define		KEYB4			GPIO_Pin_9

#define 	KEYB_ALL_LOW()     	  	GPIO_ResetBits(KEY_PORT, KEYB1|KEYB2|KEYB3|KEYB4)
#define 	KEYB1_LOW_ELSE_HIGH() 	GPIO_ResetBits(KEY_PORT, KEYB1); GPIO_SetBits(KEY_PORT, KEYB2|KEYB3|KEYB4)
#define 	KEYB2_LOW_ELSE_HIGH() 	GPIO_ResetBits(KEY_PORT, KEYB2); GPIO_SetBits(KEY_PORT, KEYB1|KEYB3|KEYB4)
#define 	KEYB3_LOW_ELSE_HIGH() 	GPIO_ResetBits(KEY_PORT, KEYB3); GPIO_SetBits(KEY_PORT, KEYB1|KEYB2|KEYB4)
#define 	KEYB4_LOW_ELSE_HIGH() 	GPIO_ResetBits(KEY_PORT, KEYB4); GPIO_SetBits(KEY_PORT, KEYB1|KEYB2|KEYB3)

#define		READ_KEYA()		((GPIO_ReadInputDataBit(KEY_PORT,KEYA1)<<1) | GPIO_ReadInputDataBit(KEY_PORT,KEYA2))

#define		NO_KEY_DOWN		0x03
#define		DUBUG_KEY_DOWN	0x00
#define		KEY_AT_A1		0x01	// key at A1 line
#define		KEY_AT_A2		0x02	// key at A2 line


#define		NO_KEY			  0xFF	// No  key
#define		KEY_AT_A1B1		GUI_KEY_RIGHT  	// KEY right	按键左
#define		KEY_AT_A1B2		GUI_KEY_LEFT	// key left		按键右
#define		KEY_AT_A1B3		GUI_KEY_DOWN	// key below	按键下
#define		KEY_AT_A1B4		GUI_KEY_UP		// key up		按键上
#define		KEY_AT_A2B1		GUI_KEY_END		// key begin	按键开始
#define		KEY_AT_A2B2		GUI_KEY_ENTER	// key ok		按键确定
#define		KEY_AT_A2B3		GUI_KEY_DELETE	// key cancel   按键取消
#define		KEY_AT_A2B4		GUI_KEY_CONTROL	// key set		按键设置
#define		GUI_KEY_START	GUI_KEY_END


#define		KEY_RIGHT		KEY_AT_A1B1		
#define		KEY_LEFT		KEY_AT_A1B2		// key left
#define		KEY_BELOW		KEY_AT_A1B3		// key below
#define		KEY_UP			KEY_AT_A1B4		// key up
#define		KEY_BEGIN		KEY_AT_A2B1		// key begin
#define		KEY_OK			KEY_AT_A2B2		// key confirm
#define		KEY_CANCEL		KEY_AT_A2B3		// key cancel
#define		KEY_SET			KEY_AT_A2B4		// key set
//----------------------------------------------------------------------------------------------------------



#define 	C_Null			0xff
#define 	C_Record		1 << 2
#define 	C_Prev			1 << 1
#define 	C_Next			1 << 0
#define 	C_StopR			C_Record
#define 	C_StopP			C_Next
#define 	C_VolDn			1 << 4
#define 	C_VolUp			1 << 5

//for uc_KeyScanState
#define C_KeyStateFirst				0x00
#define C_KeyStateDebounce			0x01
#define C_KeyStateRepeat			0x02
#define C_KeyStateReleaseDebounce	0x03
#define C_KeyStateAfterLKey			0x04

//for uc_KeyState
#define C_NullKey			C_Null	// 无按键
#define C_SKeyState			0x01	// 短按键（未抬起）
#define C_LKeyState			0x02	// 长按键（未抬起）
#define C_SReleaseKeyState	0x03	// 抬起的短按键
#define C_LReleaseKeyState	0x04	// 抬起的长按键

//for uc_KeyCount
#define C_LKeyLimit			35		// 20 ms * 35 = 700 ms 长键
#define C_RepeatTim			10		// 20 ms * 10 = 200 ms 重复键

#endif 

