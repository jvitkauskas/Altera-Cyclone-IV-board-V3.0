/*
GUANFU_WANG@126.COM
QQ:21578936
未经许可禁止任何商业用途
*/
    #include "main.h"

    struct tm time_set;


   static const u8 bmp_tou[54]={//构造bmp首部
	0x42, 0x4D, 0x36, 0x84, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x36, 0x00, 0x00, 0x00, 0x28, 0x00, 
	0x00, 0x00, 0x40, 0x01, 0x00, 0x00, 0xF0, 0x00, 0x00, 0x00, 0x01, 0x00, 0x18, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x84, 0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 
	0x00, 0x00, 0x00, 0x00, 0x00, 0x00
       };

  
     
     //文件系统结构体定义
    FATFS fs;         /* Work area (file system object) for logical drives */
    FIL fsrca;     /* file objects */
    //BYTE buffer[1024];   /* file copy buffer */
    FRESULT res;         /* FatFs function common result code */
    UINT br, bw;         /* File read/write count */
    char buffer[960],i=0;
    XCHAR file_name[]="IMG00000.bmp";
       int tx,ty,rgb_datr;
    unsigned char R,G,B; 
    int TPX=0,TPY=0; 
    u8 RTC_FG=0;
    DIR dirs;
 unsigned char key_p=0,key_val1=0,key_val2=0;
// unsigned char date1=0xa1,date2=0xb5;
  // unsigned int date=0;
int main(void)
{ 
  
  System_Init();
 // date= date1<<8| date2;
  LCD_Init();
  //GPIOB->BSRR =GPIO_Pin_11;
  Key_GPIO_Init();
  LED_GPIO_Init();
   //while (1){Test();}
   
  // Setup_RTC();  
  LCD_write_english_string(5,66-16,"STM32-Camera-R1_ILI9331",0X001F,0X0000);
    
  LCD_write_english_string(5,66,"Guanfu_Wang 2013-09-18",0X001F,0X0000); 

  if(Key_STATE)
  {
  #if   CMOS_MD==0
       LCD_write_english_string(5,66+16,"OV7670  Init......",0Xf800,0X0000);
  #elif CMOS_MD==1
       LCD_write_english_string(5,66+16,"OV7725  Init......",0Xf800,0X0000);
  #elif CMOS_MD==3
       LCD_write_english_string(5,66+16,"MT9D111 Init......",0Xf800,0X0000);
  #elif CMOS_MD==2
       LCD_write_english_string(5,66+16,"MT9M111 Init......",0Xf800,0X0000);
  #elif CMOS_MD==4
       LCD_write_english_string(5,66+16,"CF0K82C Init......",0Xf800,0X0000);
  #elif CMOS_MD==5
       LCD_write_english_string(5,66+16,"CF0K24C Init......",0Xf800,0X0000);
  #endif
   time_set=Time_GetCalendarTime(); 
   while(1!=OV7670_init());//初始化ov7670 
 while(1!=OV7670_init());//初始化ov7670 
  LCD_write_english_string(70,66+16,"Init....ok",0Xf800,0X0000);

  key_val1=0; 
  Delay(50);
  OV7670_EXTI_Config();//
  ov7670_Interrupts_Config();
 
  }
  else{RTC_FG=2;}
  
  
  //
  while (1)
  {         
   
                  
    
           
              
              if(RTC_FG==2)
                 {
              time_set=Time_GetCalendarTime();
              LCD_write_SUM(77+63,176,(time_set.tm_year/1000),0,0xE71C   );
              LCD_write_SUM(85+63,176,(time_set.tm_year%1000/100),0,0xE71C    );
              LCD_write_SUM(93+63,176,(time_set.tm_year%1000%100/10),0,0xE71C    );
              LCD_write_SUM(101+63,176,(time_set.tm_year%1000%100%10),0,0xE71C    );
              LCD_write_english_string(109+63,176,"-",0,0xE71C  );
       
              LCD_write_SUM(180,176,(time_set.tm_mon+1)/10,0,0xE71C   );
              LCD_write_SUM(188,176,(time_set.tm_mon+1)%10,0,0xE71C    );       
              LCD_write_english_string(196,176,"-",0X00,0xE71C    );
       
              LCD_write_SUM(204,176,(time_set.tm_mday/10),0,0xE71C   );
              LCD_write_SUM(212,176,(time_set.tm_mday%10),0,0xE71C   );       
              LCD_write_english_string(220,176,"  ",0X00,0xE71C   );
       
              LCD_write_SUM(236,176,(time_set.tm_hour/10),0,0xE71C   );
              LCD_write_SUM(244,176,(time_set.tm_hour%10),0,0xE71C   );       
              LCD_write_english_string(252,176,":",0X00,0xE71C    );
       
              LCD_write_SUM(260,176,(time_set.tm_min/10),0,0xE71C   );
              LCD_write_SUM(268,176,(time_set.tm_min%10),0,0xE71C    );       
              LCD_write_english_string(276,176,":",0X00,0xE71C   );
       
              LCD_write_SUM(284,176,(time_set.tm_sec/10),0,0xE71C   );
              LCD_write_SUM(292,176,(time_set.tm_sec%10),0,0xE71C   ); 

                 }
                 else
                 {
                       //  TPY=GUI_TOUCH_X_MeasureY();
                       //  TPX=GUI_TOUCH_X_MeasureX(); 
                    //   if(time_set.tm_sec==0){key_val1=1;}      
                 }
    

   //    if(key_val1)else LED_OFF();
       if(key_val1==1)
       {
      
       // EXTI->IMR &= ~EXTI_LINE_VSYNC_CMOS;//屏蔽VSYNC的中断请求
        LCD_WR_H();
        PCLK_ON_L();//禁止外部CLK，使单片机WR与TFT WR相连
        CMOS_CS_H();//禁止外部数据线，使单片机数据与TFT数据线相连	
        LCD_GPIO_OUTPUT();	
 
 
        LCD_WR_REG(0x0050,0x00);//水平 GRAM起始位置
        LCD_WR_REG(0x0051,239);//水平GRAM终止位置
        LCD_WR_REG(0x0052,0x00);//垂直GRAM起始位置
        LCD_WR_REG(0x0053,319);//垂直GRAM终止位置 
        
        file_name[7]++;//更新文件名字
        if(file_name[7]>'9')
        {
            file_name[7]='0';
            file_name[6]++;
            if(file_name[6]>'9')
            {
                 file_name[6]='0';
                 file_name[5]++;
                 if(file_name[5]>'9')
                 {
                      file_name[5]='0';
                      file_name[4]++; 
                      if(file_name[4]>'9')
                       {
                            file_name[4]='0';
                            file_name[3]++;            
                       } 
                 } 
             }
         }   

        f_mount(0, &fs); 
        res = f_open(&fsrca,file_name, FA_CREATE_ALWAYS | FA_WRITE);  
        res = f_write(&fsrca, bmp_tou,54, &bw);  
        ////////////////////////////////////////////
      //  if(res==FR_OK)
       // {
	for (ty = 0; ty < 240; ty++)
          {
            
	    for(tx=319;tx>=0;tx--)
            { 	   
                   
                   LCD_WR_REG(0x0020,ty);//
	           LCD_WR_REG(0x0021,320-tx);//
                   LCD_WR_REG16(0x0022);
                   LCD_GPIO_INPUT();
                   LCD_WR_H();
                   LCD_RS_H();
                   
                   LCD_CS_L(); 
                    
                  /////////// rgb_datr=LCD_RD_DATA16();//无用的读取////              
                   LCD_RD_L();
                   LCD_RD_H(); 
                   
                   LCD_RD_L();; 
                   LCD_RD_H();
                   delay_us(1);
                   ////////////////////////////////////////////
                   //rgb_datr=LCD_RD_DATA16();//读GRAM//////////   
                 /* */ LCD_RD_L();
                   delay_us(10);
                   rgb_datr=(0xff&DATA_LCD_PIN)<<8;  
                   LCD_RD_H(); 
                   delay_us(4);
                    LCD_RD_L();
                   delay_us(10);
                   rgb_datr|=0xff&DATA_LCD_PIN;  
                   LCD_RD_H();
                  
                   LCD_CS_H();
                   LCD_GPIO_OUTPUT();
                   ///////R G B色空域变换/////////////不同的TFT 可能R与B需要对换
                   R = (rgb_datr>>8)&0xF8;
                   G = (rgb_datr>>3)&0xFC;
                   B = (rgb_datr<<3)&0xF8;
		   buffer[tx*3+2] = B;
		   buffer[tx*3+1] = G;
		   buffer[tx*3+0] = R;
	     }
           
             res = f_write(&fsrca, buffer, 960, &bw);
             
        }

        ///////////////////////////////////////////
        f_close(&fsrca);   
        f_mount(0, NULL);// Unregister a work area before discard it   
        key_val1=0;

    }
  }   
         
    
 }



void Key_GPIO_Init(void)
{
  
  GPIO_InitTypeDef GPIO_InitStructure;
   // Enable GPIOC  clock
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);
  GPIO_InitStructure.GPIO_Pin =   Key_BIT;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
  //GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_Init(GPIOC, &GPIO_InitStructure);

}

void LED_GPIO_Init(void)
{
  
  GPIO_InitTypeDef GPIO_InitStructure;
   // Enable GPIOC  clock
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);
  GPIO_InitStructure.GPIO_Pin =   GPIO_Pin_11;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_Init(GPIOC, &GPIO_InitStructure);

}
void USART1_init(void)
{
    GPIO_InitTypeDef GPIO_InitStructure;
    USART_InitTypeDef USART_InitStructure;
    NVIC_InitTypeDef NVIC_InitStructure;
    
    RCC_APB2PeriphClockCmd (RCC_APB2Periph_GPIOA|RCC_APB2Periph_AFIO|RCC_APB2Periph_USART1 ,ENABLE);    
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_9;
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;  //推挽输出-TX
    GPIO_Init(GPIOA, &GPIO_InitStructure); 
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10;
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING; //浮空输入-RX
    GPIO_Init(GPIOA, &GPIO_InitStructure);

 /* Enable the USART1 Interrupt */
    NVIC_InitStructure.NVIC_IRQChannel = USART1_IRQChannel;
    NVIC_InitStructure.NVIC_IRQChannelSubPriority = 1;
    NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
    NVIC_Init(&NVIC_InitStructure);

   USART_InitStructure.USART_BaudRate = 9600;
  USART_InitStructure.USART_WordLength = USART_WordLength_8b;
  USART_InitStructure.USART_StopBits = USART_StopBits_1;
  USART_InitStructure.USART_Parity = USART_Parity_No;
  USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
  USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
  
    /* Configure USART1 */
  USART_Init(USART1, &USART_InitStructure);
  
    /* Enable USART1 Receive and Transmit interrupts */
  USART_ITConfig(USART1, USART_IT_RXNE, ENABLE);
//  USART_ITConfig(USART1, USART_IT_TXE, ENABLE);
  
    /* Enable the USART1 */
  USART_Cmd(USART1, ENABLE);
  




  
}

#ifdef  DEBUG
/*******************************************************************************
* Function Name  : assert_failed
* Description    : Reports the name of the source file and the source line number
*                  where the assert error has occurred.
* Input          : - file: pointer to the source file name
*                  - line: assert error line source number
* Output         : None
* Return         : None
*******************************************************************************/
void assert_failed(u8* file, u32 line)
{
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */



  /* Infinite loop */
  while (1)
  {
  }
}
#endif

/******************* (C) COPYRIGHT 2008 STMicroelectronics *****END OF FILE****/
