/*
GUANFU_WANG@126.COM
QQ:21578936
未经许可禁止任何商业用途
*/
/*
OV7725
*/
#include "ov7670.h"
#include "main.h"
#include "ov7670config.h"
#include "stm32f10x_lib.h"


////////////////////////////
//功能：提供7660时钟
//返回：无
/*
void XCLK_init_ON(void)
{
  
    GPIO_InitTypeDef GPIO_InitStructure;
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_8; 
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz; 
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP ; 
    GPIO_Init(GPIOA, &GPIO_InitStructure);
    RCC_MCOConfig(RCC_MCO_HSE  );//hsi
}
void XCLK_init_OFF(void)
{
  
    GPIO_InitTypeDef GPIO_InitStructure;
    RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
    GPIO_InitStructure.GPIO_Pin = GPIO_Pin_8; 
    GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz; 
    GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
    GPIO_Init(GPIOA, &GPIO_InitStructure);
}
*/
void ov7670_GPIO_Init(void)
{
  
  GPIO_InitTypeDef GPIO_InitStructure;
   // Enable GPIOC  clock
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOD, ENABLE);
  GPIO_InitStructure.GPIO_Pin =  OV7670_VSYNC_BIT;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
  //GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_Init(GPIOD, &GPIO_InitStructure);
 
}

/********************************************************************
函数功能：7670中断配制
入口参数：无。
返    回：无。
备    注：无。
********************************************************************/
void ov7670_Interrupts_Config(void)
{
  NVIC_InitTypeDef NVIC_InitStructure;

  
#ifdef  VECT_TAB_RAM  
  /* Set the Vector Table base location at 0x20000000 */ 
  NVIC_SetVectorTable(NVIC_VectTab_RAM, 0x0); 
#else  /* VECT_TAB_FLASH  */
  /* Set the Vector Table base location at 0x08000000 */ 
  NVIC_SetVectorTable(NVIC_VectTab_FLASH, 0x0);   
#endif

  /* Configure one bit for preemption priority */
  NVIC_PriorityGroupConfig(NVIC_PriorityGroup_1);
  
  /* Enable the EXTI9_5 Interrupt 
  NVIC_InitStructure.NVIC_IRQChannel = EXTI9_5_IRQChannel;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&NVIC_InitStructure);
  */
  
  
    /* Configure one bit for preemption priority */
  NVIC_PriorityGroupConfig(NVIC_PriorityGroup_1);
  
  /* Enable the EXTI9_5 Interrupt */
  NVIC_InitStructure.NVIC_IRQChannel = EXTI2_IRQChannel;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 1;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 1;
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&NVIC_InitStructure);
  

  

}



void OV7670_EXTI_Config(void)
{
  EXTI_InitTypeDef EXTI_InitStructure;
  
 // GPIO_EXTILineConfig(GPIO_PORT_SOURCE_HREF_CMOS, GPIO_PIN_SOURCE_HREF_CMOS);
 /// EXTI_InitStructure.EXTI_Line = EXTI_LINE_HREF_CMOS;
 /// EXTI_InitStructure.EXTI_Mode = EXTI_Mode_Interrupt;
 // EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Falling;
 // EXTI_InitStructure.EXTI_LineCmd = ENABLE;
 // EXTI_Init(&EXTI_InitStructure);
//  EXTI_GenerateSWInterrupt(EXTI_LINE_HREF_CMOS);
  

  GPIO_EXTILineConfig(GPIO_PORT_SOURCE_VSYNC_CMOS, GPIO_PIN_SOURCE_VSYNC_CMOS);
  EXTI_InitStructure.EXTI_Line = EXTI_LINE_VSYNC_CMOS;
  EXTI_InitStructure.EXTI_Mode = EXTI_Mode_Interrupt;
  
  
  
  #if  (CMOS_MD==0 )
 EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Rising ;
#elif CMOS_MD==1
 EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Rising ;
#elif CMOS_MD==2
 EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Falling ;
#elif (CMOS_MD==3)|(CMOS_MD==5)
 EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Falling ;
 #elif (CMOS_MD==4)
 EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Falling ;
#endif
 
  EXTI_InitStructure.EXTI_LineCmd = ENABLE;
  EXTI_Init(&EXTI_InitStructure);
  EXTI_GenerateSWInterrupt(EXTI_LINE_VSYNC_CMOS);

}




//(140,16,640,480) is good for VGA
//(272,16,320,240) is good for QVGA
/*
void OV7670_config_window(unsigned int startx,unsigned int starty,unsigned int width, unsigned int height)
{
	unsigned int endx;
	unsigned int endy;// "v*2"必须
	unsigned char temp_reg1, temp_reg2;
	unsigned char state,temp;
	
	endx=(startx+width);
	endy=(starty+height+height);// "v*2"必须
	state = rdOV7670Reg(0x03, &temp_reg1 );
	temp_reg1 &= 0xf0;
	state = rdOV7670Reg(0x32, &temp_reg2 );
	temp_reg2 &= 0xc0;
	
	// Horizontal
	temp = temp_reg2|((endx&0x7)<<3)|(startx&0x7);
	state = wrOV7670Reg(0x32, temp );
	temp = (startx&0x7F8)>>3;
	state = wrOV7670Reg(0x17, temp );
	temp = (endx&0x7F8)>>3;
	state = wrOV7670Reg(0x18, temp );
	
	// Vertical
	temp = temp_reg1|((endy&0x3)<<2)|(starty&0x3);
	state = wrOV7670Reg(0x03, temp );
	temp = starty>>2;
	state = wrOV7670Reg(0x19, temp );
	temp = endy>>2;
	state = wrOV7670Reg(0x1A, temp );
}

*/


////////////////////////////
//功能：写OV7660寄存器
//返回：1-成功	0-失败
#if  (CMOS_MD==0 )|(CMOS_MD==1 )
    unsigned char wrOV7670Reg(unsigned char regID, unsigned char regDat)
    {
		startSCCB();
	if(0==SCCBwriteByte(0x42))
	{
		stopSCCB();
		return(0);
	}
	delay_us(20);
  	if(0==SCCBwriteByte(regID))
	{
		stopSCCB();
		return(0);
	}
	delay_us(20);
  	if(0==SCCBwriteByte(regDat))
	{
		stopSCCB();
		return(0);
	}
  	stopSCCB();
	
  	return(1);
     }
#elif (CMOS_MD==2 )|(CMOS_MD==3 ) 
   unsigned char wrOV7670Reg(unsigned char Page,unsigned char regID, unsigned int regDat)
   {     
      
        startSCCB();     
	if(0==SCCBwriteByte(0xba))
	{
		stopSCCB();
		return(0);
	}
	delay_us(20);
  	if(0==SCCBwriteByte(0xf0))
	{
		stopSCCB();
		return(0);
	}
	delay_us(20);
  	if(0==SCCBwriteByte((unsigned char)( Page>>8)))
	{
		stopSCCB();
		return(0);
	}
        if(0==SCCBwriteByte((unsigned char)( Page)))
	{
		stopSCCB();
		return(0);
	}
        stopSCCB();
   //////////////////////////////////////////////////////////////     
	startSCCB();
	if(0==SCCBwriteByte(0xba))
	{
		stopSCCB();
		return(0);
	}
	delay_us(20);
  	if(0==SCCBwriteByte(regID))
	{
		stopSCCB();
		return(0);
	}
	delay_us(20);
  	if(0==SCCBwriteByte((unsigned char)(regDat>>8)))
	{
		stopSCCB();
		return(0);
	}
        
   	if(0==SCCBwriteByte((unsigned char)regDat))
	{
		stopSCCB();
		return(0);
	}
        
  	stopSCCB();
	
  	return(1);
}
#elif (CMOS_MD==4 )
    unsigned char wr_CFOK82C_Reg(unsigned char regID, unsigned int regDat)
    {
		startSCCB();
	if(0==SCCBwriteByte(0x90))
	{
		stopSCCB();
		return(0);
	}
	delay_us(20);
  	if(0==SCCBwriteByte(regID))
	{
		stopSCCB();
		return(0);
	}
	delay_us(20);
  	if(0==SCCBwriteByte((unsigned char)(regDat>>8)))
	{
		stopSCCB();
		return(0);
	}
        if(0==SCCBwriteByte((unsigned char)regDat))
	{
		stopSCCB();
		return(0);
	}
  	stopSCCB();
	
  	return(1);
     }

unsigned char CFOK82C_set_ccm(unsigned int index)
{
    unsigned int i;
    //unsigned int r6;
    const unsigned int  regs[]=
    {
        72,                                  //digital gain
        2,                                   //sign
        3,4,                                 //scale
        9,10,11,12,13,14,15,16,17,           //magnitude
        21,22,23,24,25,26,27,28,29,30,       //delta matrix
        94,95,96
    };
    const unsigned int value[][26]=
    {
        //default
        {
          /*   
            0,
            0x6e,
            0x2923,0x0524,                 
            146,22,8,171,147,88,77,169,160,
            373,22,67,12,0,21,31,22,152,76,
            26684,12296,2
             */ 
            0,
            110,
            10531,1316,
            125,108,58,129,141,112,95,128,138,
            145,6,231,221,15,65,208,72,59,43,
            26953,11283,2
           
        },
        //direct sun
        {
        
          /*   128,
            0xea,
            0x3922,0x4e4,
            0x8d,0x71,0xc5,0x9d,0xf8,0x53,0x0d,0xa7,0x90,
            0,0,0,0,0,0,0,0,0,0,*/
         
           128,
            174,
            14627,1828,
            128,7,52,122,215,7,59,99,232,
            0,0,0,0,0,0,0,0,0,0,
            21331,0,0

        },
        //incandescent
        {

           /*  128,
            0xee,
            0x2922,0x4a4,
            0x8c,0xcc,0x6e,0xa6,0x86,0x72,0x06,0x85,0xc6,
            0,0,0,0,0,0,0,0,0,0,*/
        
              
              128,
            110,
            10532,1316,
            245,244,168,137,174,216,131,158,160,
            0,0,0,0,0,0,0,0,0,0,
            32832,0,0
        },
        //fluorescent
        {
            /*
            0,
            0xea,
            0x3922,0x4e4,
            0x8d,0xba,0x7b,0x9c,0xfe,0x61,0x08,0xb9,0x9a,
            0,0,0,0,0,0,0,0,0,0
           */ 
            128,
            166,
            10531,1316,
            197,160,77,230,132,3,122,91,131,
            0,0,0,0,0,0,0,0,0,0,
            32844,0,0
       
        },
        //sepia
        {
            128,
            36,
            10516,2276,
            9,142,17,24,134,43,10,147,17,
            0,0,0,0,0,0,0,0,0,0,
            20560,0,0
        },
    };
    wr_CFOK82C_Reg(1,1);
    for(i=0; i<26; i++)
    {
        if( 0==wr_CFOK82C_Reg(regs[i],value[index][i])){return 0; } 
    }
    

  return 1;
} 


  
 


 unsigned char  CFOK82C_set_gamma(unsigned int index)
{
    const u16 regs[]=
    {
        0x58,0x53,0x54,0x55,0x56,0x57,
    };
    const u16 value[][11]=
    {
        //default
        {
            //0x0,0x09,0x0f,0x1b,0x2f,0x52,0x71,0x8f,0xab,0xc6,0xe0
            0,10,18,31,54,94,130,164,196,226,255
        },
        //solarize
        {
           // 224,23,17,128,220,175,105,53,33,8,0
           0,4,8,16,32,64,96,128,160,192,224
        },
        //neg art
        {
           // 224,204,194,178,174,118,89,64,41,20,0
           0,4,8,16,32,64,96,128,160,192,224
        }
    };
     unsigned int i;
    //dbg_print("mt9v111_set_gamma to index :%d \n",index);
      if( 0==wr_CFOK82C_Reg(1,1)){return 0;}
      if( 0==wr_CFOK82C_Reg(regs[0],value[index][0])){return 0;}    
    //mt9v111_write_ifp_reg();
    for(i=0; i<5; i++)
    {
       if( 0==wr_CFOK82C_Reg(regs[i+1],value[index][2*i+1]|(value[index][2*i+2]<<8))){return 0;}   
    }
    
    unsigned int  values2[] = 
    {
        0x0006, 0xCE12, 0x00F0, 0x370D, 0xE20C, 0xFDF5,
        0x280B, 0xDE0D, 0x00F4, 0x280A, 0xBD20, 0xF8E4,
        0x1E0A, 0x0050, 0xD812, 0xFCEC, 0x1407, 0x0028,
        0xD413, 0xFEEC, 0x1405, 0x0028
    };
    unsigned int addr;
     for(addr = 0x80; addr <= 0x95; addr++)
    {
      if( 0==wr_CFOK82C_Reg(addr, values2[addr-0x80])){return 0;}     
    }
  /*  */
    return 1;
}

#elif  (CMOS_MD==5 )
   unsigned char wrOV7670Reg(unsigned char Page,unsigned char regID, unsigned int regDat)
   {     
      
        startSCCB();     
	if(0==SCCBwriteByte(0x90))
	{
		stopSCCB();
		return(0);
	}
	delay_us(20);
  	if(0==SCCBwriteByte(0xf0))
	{
		stopSCCB();
		return(0);
	}
	delay_us(20);
  	if(0==SCCBwriteByte((unsigned char)( Page>>8)))
	{
		stopSCCB();
		return(0);
	}
        if(0==SCCBwriteByte((unsigned char)( Page)))
	{
		stopSCCB();
		return(0);
	}
        stopSCCB();
   //////////////////////////////////////////////////////////////     
	startSCCB();
	if(0==SCCBwriteByte(0x90))
	{
		stopSCCB();
		return(0);
	}
	delay_us(20);
  	if(0==SCCBwriteByte(regID))
	{
		stopSCCB();
		return(0);
	}
	delay_us(20);
  	if(0==SCCBwriteByte((unsigned char)(regDat>>8)))
	{
		stopSCCB();
		return(0);
	}
        
   	if(0==SCCBwriteByte((unsigned char)regDat))
	{
		stopSCCB();
		return(0);
	}
        
  	stopSCCB();
	
  	return(1);
}

#endif 
/* OV7670_init() */
//返回1成功，返回0失败
unsigned char OV7670_init(void)
{
	unsigned char temp;
	
	unsigned int i=0;

	//uchar ovidmsb=0,ovidlsb=0;
	ov7670_GPIO_Init();
	SCCB_GPIO_Config();//io init..
 #if   (CMOS_MD==0 )| (CMOS_MD==1 )


	temp=0x80;
	if(0==wrOV7670Reg(0x12, temp)) //Reset SCCB
	{
          return 0 ;
	}
	Delay(10);

        
        for(i=0;i<CHANGE_REG_NUM;i++)
	{
		if( 0==wrOV7670Reg(change_reg[i][0],change_reg[i][1]))
		{
			return 0;
		}
	}
        //OV7670_config_window(272,16,320,240);
  #elif(CMOS_MD==2 )| (CMOS_MD==3)|(CMOS_MD==5)
        Delay(5);
        for(i=0;i<CHANGE_REG_NUM;i++)
	{
	       if(change_reg[i][0]>2)
               {
                  Delay(change_reg[i][2]); // Delay 5ms();
               }
               else
               {
                  if( 0==wrOV7670Reg(change_reg[i][0],change_reg[i][1],change_reg[i][2]))
		  {
			return 0;
		  }
               }
             // delay_us(10);
	}
   #elif(CMOS_MD==4 )
        
     /*          if( 0==wr_CFOK82C_Reg(0x01,0x04)) {return 0; }
         if( 0==wr_CFOK82C_Reg(0x07,0x00)) {return 0; }
         
         if( 0==wr_CFOK82C_Reg(0x0d,0x01)) {return 0; }
         Delay(5);
         if( 0==wr_CFOK82C_Reg(0x0d,0x00)) {return 0; }
         Delay(5);    
         if( 0==wr_CFOK82C_Reg(0x01,0x01)) {return 0; }
         if( 0==wr_CFOK82C_Reg(0x07,0x00)) {return 0; }
         Delay(5);
         if( 0==wr_CFOK82C_Reg(0x07,0x01)) {return 0; }    
       Delay(5);
*/   
        for(i=0;i<CHANGE_REG_NUM;i++)
	{

                  if( 0==wr_CFOK82C_Reg(change_reg[i][0],change_reg[i][1]))
		  {
			return 0;
		  }

	}  
        CFOK82C_set_gamma(2);
       //  CFOK82C_set_ccm(0);
       //return temp; //ok
  #endif      
	return 0x01; //ok
} 

