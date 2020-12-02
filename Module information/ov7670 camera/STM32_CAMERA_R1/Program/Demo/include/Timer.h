#ifndef __TIMER_H__
#define __TIMER_H__




/*-----------------------------------------------------------------------
	说明：
		用硬定时器0产生多个软定时器
		TMR0每10mS进一次中断
-------------------------------------------------------------------------*/
#define TIMER_NUMBER	7

/*------------------------------------------------------------------------
		下面对各个定时器的用途和定时的时间间隔做定义

--------------------------------------------------------------------------*/
// 显示设置		2mS
#define T_SETPARA				0		
#define T_SETPARA_TIME			2

// 显示选择量程		2mS
#define T_SELECT				1		
#define T_SELECT_TIME			2

// 显示测试		2mS
#define T_WORK					1		
#define T_WORK_TIME				2

// 按键扫描定时器   20ms
#define T_SCAN_KEYBOARD			3	   		
#define T_SCAN_KEYBOARD_TIME	15

// 
#define T_SCAN_SD_CARD			4		
#define T_SCAN_SD_CARD_TIME		3

// 
#define T_GuiWelcome			5		
#define T_GuiWelcome_TIME		15

// POWER
#define T_POWER					6		
#define T_POWER_TIME			10000


#define OSTask_Init()	InitTaskTimer() 


/*------------------------ 函数区 --------------------------------*/
void InitTaskTimer(void);
void SetTimer(u8 TimerNO, u16 Time1);
void Timer(void);
//byte TimerOver(byte TimerNo);
bool TimerOver(u8 TimerNo);
void KillTimer(u16  TimerNO);
bool TimerExist(u16 TimerNO);

#endif
