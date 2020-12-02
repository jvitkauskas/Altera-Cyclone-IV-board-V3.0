
/* Includes ------------------------------------------------------------------*/
#include "stm32f10x_it.h"
#include "main.h"
#include "hw_config.h"


/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/
ErrorStatus HSEStartUpStatus;

/* Extern variables ----------------------------------------------------------*/
/* Private function prototypes -----------------------------------------------*/
static void RCC_Config(void);
/* Private functions ---------------------------------------------------------*/

/********************************************************************
函数功能：系统初始化
入口参数：无。
返    回：无。
备    注：
            设置系统时钟
			初始化各外设时钟
			打开需要用的外设
			中断设置
			配制IO引脚，定义IO功能
			初始化存储器
			初始化USB
********************************************************************/
void System_Init(void)
{

  /* RCC configuration */
  RCC_Config();		 //与时钟相关的寄存器配制
  NVIC_Configuration_rtc();
  RTC_Configuration();
  SPI_Configuration();	//SPI配置
  SysTick_Config();		//定时器配置
 
  disk_initialize (0);
  Touch_Config(); 
   
}

/*******************************************************************************
* Function Name  : Set_System
* Description    : Configures Main system clocks & power
* Input          : None.
* Return         : None.
*******************************************************************************/
static void RCC_Config(void)
{

  /* RCC system reset(for debug purpose) */
  RCC_DeInit();	   //将RCC寄存器设备缺省值

  /* Enable HSE */
  RCC_HSEConfig(RCC_HSE_ON);  //外部高速振荡器HSE 开启

  /* Wait till HSE is ready */
  HSEStartUpStatus = RCC_WaitForHSEStartUp();	//等待HSE启动

  if (HSEStartUpStatus == SUCCESS)	  //如果HSE晶振稳定且就绪
  {
    /* Enable Prefetch Buffer */
    FLASH_PrefetchBufferCmd(FLASH_PrefetchBuffer_Enable);  //预取指缓存使能

    /* Flash 2 wait state */
    FLASH_SetLatency(FLASH_Latency_2);	//设置FLASH存储器延时时钟周期数为2延时周期

    /* HCLK = SYSCLK */
    RCC_HCLKConfig(RCC_SYSCLK_Div1);  //设置AHB时钟＝系统时钟

    /* PCLK2 = HCLK */
    RCC_PCLK2Config(RCC_HCLK_Div1);	 //设置APB2时钟 ＝ HCLK

    /* PCLK1 = HCLK/2 */
    RCC_PCLK1Config(RCC_HCLK_Div2);	   //设置APB1时钟 ＝ HCLK/2

    /* ADCCLK = PCLK2/6 */
    RCC_ADCCLKConfig(RCC_PCLK2_Div6);	//设置ADC时钟＝PCLK/6

	//PLL设置
	//PLL输入时钟＝HSE时钟频率   输出 9倍频（HSE×9）
    RCC_PLLConfig(RCC_PLLSource_HSE_Div1, RCC_PLLMul_9);     //72M

    /* Enable PLL */
    RCC_PLLCmd(ENABLE);

    /* Wait till PLL is ready */
    while (RCC_GetFlagStatus(RCC_FLAG_PLLRDY) == RESET)	 //等待PLL就绪
    {}

    /* Select PLL as system clock source */
    RCC_SYSCLKConfig(RCC_SYSCLKSource_PLLCLK);	//选择PLL作为系统时钟

    /* Wait till PLL is used as system clock source */
	//等待设置系统时钟为PLL成功
	//返回值为	00：HSI  04：HSE  08：PLL
    while (RCC_GetSYSCLKSource() != 0x08)  
    {}
     
     

     RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA | RCC_APB2Periph_GPIOB |RCC_APB2Periph_GPIOC | RCC_APB2Periph_GPIOD , ENABLE);
      /* DMA1 and DMA2 clock enable */
     //RCC_AHBPeriphClockCmd(RCC_AHBPeriph_DMA1 | RCC_AHBPeriph_DMA2, ENABLE);
     // 改变指定管脚的映射 GPIO_Remap_SWJ_JTAGDisable ，JTAG-DP 禁用 + SW-DP 使能
     //GPIO_PinRemapConfig(GPIO_Remap_SWJ_JTAGDisable , ENABLE);
      Key_GPIO_Init();
     
    
  }
}

/*******************************************************************************
* Function Name  : SysTick_Config
* Description    : Configure a SysTick Base time to 10 ms.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/
 void SysTick_Config(void)
{
  /* Configure HCLK clock as SysTick clock source */
  SysTick_CLKSourceConfig(SysTick_CLKSource_HCLK);	//设置SysTick时钟为AHB时钟
 
  /* SysTick interrupt each 100 Hz with HCLK equal to 72MHz */
  SysTick_SetReload(720000);   //设置重装值

  /* Enable the SysTick Interrupt */
  SysTick_ITConfig(ENABLE);
}

/*******************************************************************************
* Function Name  : Delay
* Description    : Inserts a delay time.
* Input          : nCount: specifies the delay time length (time base 10 ms).
* Output         : None
* Return         : None
*******************************************************************************/
void Delay(u32 nCount)
{
  TimingDelay = nCount;

  /* Enable the SysTick Counter */
  SysTick_CounterCmd(SysTick_Counter_Enable);
  
  while(TimingDelay != 0)
  {
  }

  /* Disable the SysTick Counter */
  SysTick_CounterCmd(SysTick_Counter_Disable);

  /* Clear the SysTick Counter */
  SysTick_CounterCmd(SysTick_Counter_Clear);
}

/*******************************************************************************
* Function Name  : Decrement_TimingDelay
* Description    : Decrements the TimingDelay variable.
* Input          : None
* Output         : TimingDelay
* Return         : None
*******************************************************************************/
void Decrement_TimingDelay(void)
{
  if (TimingDelay != 0x00)
  {
    TimingDelay--;
  }
}
void RTC_Configuration(void)
{
  
   struct tm time_now;
  /* Enable PWR and BKP clocks */
  RCC_APB1PeriphClockCmd(RCC_APB1Periph_PWR | RCC_APB1Periph_BKP, ENABLE);

  /* Allow access to BKP Domain */
  PWR_BackupAccessCmd(ENABLE);

  /* Reset Backup Domain */
  BKP_DeInit();

  /* Enable LSE */
  RCC_LSEConfig(RCC_LSE_OFF);//LSE oscillator OFF
  /* Wait till LSE is ready */
  //while (RCC_GetFlagStatus(RCC_FLAG_LSERDY) == RESET)
 // {}

  /* Select LSE as RTC Clock Source */
 // RCC_RTCCLKConfig(RCC_RTCCLKSource_LSE);
   RCC_RTCCLKConfig(RCC_RTCCLKSource_HSE_Div128);//HSE clock divided by 128  selected as RTC clock
  /* Enable RTC Clock */
  RCC_RTCCLKCmd(ENABLE);

  /* Wait for RTC registers synchronization */
  RTC_WaitForSynchro();

  /* Wait until last write operation on RTC registers has finished */
  RTC_WaitForLastTask();

  /* Enable the RTC Second */
  RTC_ITConfig(RTC_IT_SEC, ENABLE);

  /* Wait until last write operation on RTC registers has finished */
  RTC_WaitForLastTask();

  /* Set RTC prescaler: set RTC period to 1sec */
  RTC_SetPrescaler(62499); /* RTC period = RTCCLK/RTC_PR = (32.768 KHz)/(32767+1) */

  /* Wait until last write operation on RTC registers has finished */
  RTC_WaitForLastTask();
  
        time_now.tm_year = 2011;
	time_now.tm_mon = 2;
	time_now.tm_mday = 26;
	time_now.tm_hour = 21;
	time_now.tm_min = 07;
	time_now.tm_sec = 00;
        time_now.tm_isdst=0;//刚加的
	Time_SetCalendarTime(time_now);
}


void NVIC_Configuration_rtc(void)
{
  NVIC_InitTypeDef NVIC_InitStructure;

  /* Configure one bit for preemption priority */
  NVIC_PriorityGroupConfig(NVIC_PriorityGroup_1);

  /* Enable the RTC Interrupt */
  NVIC_InitStructure.NVIC_IRQChannel = RTC_IRQChannel;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 1;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&NVIC_InitStructure);
}
/*******************************************************************************
* Function Name  : NVIC_Configuration
* Description    : Configures Vector Table base location.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/
void NVIC_Configuration(void)
{
#ifdef  VECT_TAB_RAM  
  /* Set the Vector Table base location at 0x20000000 */ 
  NVIC_SetVectorTable(NVIC_VectTab_RAM, 0x0); 
#else  /* VECT_TAB_FLASH  */
  /* Set the Vector Table base location at 0x08000000 */ 
  NVIC_SetVectorTable(NVIC_VectTab_FLASH, 0x0);   
#endif
}


u8 Check_RTC_MY(void)
{
   if(BKP_ReadBackupRegister(BKP_DR1)!=0xA5A5)
    {
              // u32 delay; 
  	
        
        
       //启用PWR和BKP的时钟（from APB1）
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_PWR | RCC_APB1Periph_BKP, ENABLE);
        

	//后备域解锁
	PWR_BackupAccessCmd(ENABLE);
 
	//备份寄存器模块复位
	BKP_DeInit();
        
       // RCC_LSEConfig(RCC_LSE_OFF); 
	//外部32.768K其哟偶那个
	RCC_LSEConfig(RCC_LSE_ON);
        
        return 1; 
    } 
   else 
   {
                  //清除RCC中复位标志
        RCC_ClearFlag();
        
        //虽然RTC模块不需要重新配置，且掉电后依靠后备电池依然运行
        RCC_RTCCLKCmd(ENABLE);
        //等待RTC时钟与APB1时钟同步
        RTC_WaitForSynchro();
        
        //使能秒中断
        RTC_ITConfig(RTC_IT_SEC,ENABLE);
        //等待操作完成
        RTC_WaitForLastTask();
        
        RCC_ClearFlag();
    
    /* Enable PWR and BKP clocks */
        RCC_APB1PeriphClockCmd(RCC_APB1Periph_PWR|RCC_APB1Periph_BKP,ENABLE);
    
    /* Allow access to BKP Domain */
        PWR_BackupAccessCmd(ENABLE);
        
        return 0;  //RTC OK
     
   }
}


void Setup_RTC(void)
{      
        struct tm time_now;
       //等待稳定
	while (RCC_GetFlagStatus(RCC_FLAG_LSERDY) == RESET){};
	//RTC时钟源配置成LSE（外部32.768K）
	RCC_RTCCLKConfig(RCC_RTCCLKSource_LSE);

	//RTC开启
	RCC_RTCCLKCmd(ENABLE);

	//开启后需要等待APB1时钟与RTC时钟同步，才能读写寄存器
	RTC_WaitForSynchro();

	//读写寄存器前，要确定上一个操作已经结束
	RTC_WaitForLastTask();


	//设置RTC分频器，使RTC时钟为1Hz
	//RTC period = RTCCLK/RTC_PR = (32.768 KHz)/(32767+1)
	RTC_SetPrescaler(32767);


	//等待寄存器写入完成
	RTC_WaitForLastTask();

	//使能秒中断
	RTC_ITConfig(RTC_IT_SEC, ENABLE);    

	//等待写入完成
	RTC_WaitForLastTask();
        
        
        time_now.tm_year = 2011;
	time_now.tm_mon = 2;
	time_now.tm_mday = 26;
	time_now.tm_hour = 21;
	time_now.tm_min = 07;
	time_now.tm_sec = 00;
        time_now.tm_isdst=0;//刚加的
	Time_SetCalendarTime(time_now);
        BKP_WriteBackupRegister(BKP_DR1,0xA5A5);//配置完成后，向后备寄存器中写特殊字符0xA5A5
        
        RCC_ClearFlag();
    
        // Enable PWR and BKP clocks
        RCC_APB1PeriphClockCmd(RCC_APB1Periph_PWR|RCC_APB1Periph_BKP,ENABLE);
    
        // Allow access to BKP Domain 
        PWR_BackupAccessCmd(ENABLE);
}
/*

void Setup_RTC(void)
{   
     struct tm time_now;
    if(BKP_ReadBackupRegister(BKP_DR1)!=0xA5A5)
    {
      
        RTC_Configuration();
        
        
	time_now.tm_year = 2010;
	time_now.tm_mon = 6;
	time_now.tm_mday = 30;
	time_now.tm_hour = 12;
	time_now.tm_min = 00;
	time_now.tm_sec = 00;
        time_now.tm_isdst=0;//刚加的
	Time_SetCalendarTime(time_now);
        BKP_WriteBackupRegister(BKP_DR1,0xA5A5);//配置完成后，向后备寄存器中写特殊字符0xA5A5
    }
    else
    {
             //清除RCC中复位标志
        RCC_ClearFlag();
        
        //虽然RTC模块不需要重新配置，且掉电后依靠后备电池依然运行
        RCC_RTCCLKCmd(ENABLE);
        //等待RTC时钟与APB1时钟同步
        RTC_WaitForSynchro();
        
        //使能秒中断
        RTC_ITConfig(RTC_IT_SEC,ENABLE);
        //等待操作完成
        RTC_WaitForLastTask();
     }
    RCC_ClearFlag();
    
    // Enable PWR and BKP clocks
    RCC_APB1PeriphClockCmd(RCC_APB1Periph_PWR|RCC_APB1Periph_BKP,ENABLE);
    
    // Allow access to BKP Domain 
    PWR_BackupAccessCmd(ENABLE);
}
*/
/******************* (C) COPYRIGHT 2008 STMicroelectronics *****END OF FILE****/
