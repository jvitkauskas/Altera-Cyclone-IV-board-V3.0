
/*
TFT实际控制器型号MTM3225A 2。8“
GUANFU_WANG
*/
/*
GUANFU_WANG@126.COM
QQ:21578936
未经许可禁止任何商业用途
*/


#include  "english_16x8.h"
#include"ILI9331.h"
#include"main.h"

/*******************************************************************************
* Function Name  : GPIO_Config
* Description    : Configures the different GPIO ports pins.
* Input          : None
* Output         : None
* Return         : None
*******************************************************************************/

void LCD_GPIO_OUTPUT(void)
{
  GPIO_InitTypeDef GPIO_InitStructure;

  /* Enable GPIOB clock */
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0|GPIO_Pin_1|GPIO_Pin_2|GPIO_Pin_3|GPIO_Pin_4|GPIO_Pin_5|GPIO_Pin_6|GPIO_Pin_7;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_Init(GPIOA, &GPIO_InitStructure);
}
void LCD_GPIO_INPUT(void)
{
  GPIO_InitTypeDef GPIO_InitStructure;

  /* Enable GPIOB clock */
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0|GPIO_Pin_1|GPIO_Pin_2|GPIO_Pin_3|GPIO_Pin_4|GPIO_Pin_5|GPIO_Pin_6|GPIO_Pin_7;
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
  //GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_Init(GPIOA, &GPIO_InitStructure);

}

void  LCD_Set_GPIO_Config(void)
{
  
  GPIO_InitTypeDef GPIO_InitStructure;
  /* Enable GPIOB clock */
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);
  GPIO_InitStructure.GPIO_Pin =LCD_CS_BIT|LCD_RS_BIT|LCD_RD_BIT|LCD_RST_BIT|CMOS_CS_BIT;                               
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_Init(GPIOC, &GPIO_InitStructure);
  
  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOB|RCC_APB2Periph_AFIO, ENABLE);
  GPIO_InitStructure.GPIO_Pin =LCD_BL_BIT|LCD_WR_BIT|PCLK_ON_BIT;                               
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_Init(GPIOB, &GPIO_InitStructure); 
  
  LCD_RD_H();
  LCD_RS_H();
  LCD_CS_H();  
  LCD_WR_H();
}

  





void LCD_WR_DATA16(unsigned int data)//写积存器数据
{
     LCD_RD_H();
     LCD_RS_H();
     LCD_CS_L(); 
     
      GPIOA->ODR=(GPIOB->ODR&0XFF00)| (unsigned char)(data>>8);
     LCD_WR_L();
    delay_us(2);
     LCD_WR_H();

     GPIOA->ODR=(GPIOB->ODR&0XFF00)|(unsigned char)data;     
     LCD_WR_L();
     delay_us(2);
     LCD_WR_H();
     
     LCD_CS_H();
  
}
void LCD_WR_REG16(unsigned int index)//写积存器命令
{
     LCD_RD_H();
     LCD_RS_L();
     LCD_CS_L(); 
     
     GPIOA->ODR=(GPIOA->ODR&0XFF00)| (unsigned char)(index>>8); 
     LCD_WR_L();
     delay_us(2);
     LCD_WR_H();

     GPIOA->ODR=(GPIOA->ODR&0XFF00)|(unsigned char)index;     
     LCD_WR_L();
     delay_us(2);
     LCD_WR_H();
     
     LCD_CS_H();
}
unsigned int LCD_RD_DATA16(void)//读积存器数据
{
     unsigned int data;
  //   LCD_WR_H();
   //  LCD_RS_H();
  //   LCD_GPIO_INPUT();
  //   LCD_CS_L(); 
 
     LCD_RD_L();
    asm("NOP");
     LCD_RD_H();

      data=(0x00ff&DATA_LCD_PIN); 
     data=data<<8;     
	 
     LCD_RD_L();
      asm("NOP");  
     LCD_RD_H();
      data|=(0x00ff&DATA_LCD_PIN);
     
   //  LCD_CS_H();
   //  LCD_GPIO_OUTPUT();
     return data;
  
}
void LCD_WR_REG(unsigned int index,unsigned int data)
{
     LCD_WR_REG16(index);
     LCD_WR_DATA16(data);
}


void LCD_Init(void)
{   

 
  
        LCD_GPIO_OUTPUT();
        LCD_Set_GPIO_Config(); 
        LCD_BL_L(); 
        LCD_RST_H();
        Delay(1);
        
        CMOS_CS_H();
        PCLK_ON_L();
        
        LCD_RST_L();
         Delay(20);
        LCD_RST_H();
         Delay(5);
  //  delay_ms(5000);
     	//	 LCD_WR_REG(0x00E3,0x3008);        
	///     LCD_WR_REG(0x00E7,0x0012);
	//     LCD_WR_REG(0x00Ef,0x1231); 	// Set the internal timing;   
    //  LCD_WR_REG(0xe5,0x8000);
      //  LCD_WR_REG(0x00, 0x0100);
       LCD_WR_REG(0x00E7,0x1014);
      
   /*     */
       LCD_WR_REG(0x01, 0x0100);
      
      //   LCD_WR_REG(0x00, 0x0100);
       Delay(10);

      LCD_WR_REG(0x02, 0x0700); // set 1 line inversion
      Delay(5);
        // LCD_WR_REG(0x03, 0x10B0); // set GRAM write direction and BGR=1.
#if   ID_AM==000       
	     LCD_WR_REG(0x0003,0x1000);//屏幕旋转控制 TFM=0,TRI=0,SWAP=1,16 bits system interface  swap RGB to BRG，此处ORG和HWM 为0
#elif ID_AM==001        
	     LCD_WR_REG(0x0003,0x1008);      
#elif ID_AM==010  
	     LCD_WR_REG(0x0003,0x1010);        
#elif ID_AM==011
	     LCD_WR_REG(0x0003,0x1018);
#elif ID_AM==100  
	     LCD_WR_REG(0x0003,0x1020);      
#elif ID_AM==101  
	     LCD_WR_REG(0x0003,0x1028);      
#elif ID_AM==110  
	     LCD_WR_REG(0x0003,0x1030);      
#elif ID_AM==111  
	     LCD_WR_REG(0x0003,0x1038);
#endif    
         LCD_WR_REG(0x04, 0x0000); // Resize register
         LCD_WR_REG(0x08, 0x0204); // set the back porch and front porch
         LCD_WR_REG(0x09, 0x0000); // set non-display area refresh cycle ISC[3:0]
         LCD_WR_REG(0x0A, 0x0000); // FMARK function
         LCD_WR_REG(0x0C, 0x0001); // RGB interface setting
         LCD_WR_REG(0x0D, 0x0000); // Frame marker Position
         LCD_WR_REG(0x0F, 0x0000); // RGB interface polarity
//Power On sequence //
         LCD_WR_REG(0x10, 0x0000); // SAP, BT[3:0], AP, DSTB, SLP, STB
         LCD_WR_REG(0x11, 0x0000); // DC1[2:0], DC0[2:0], VC[2:0]
         LCD_WR_REG(0x12, 0x0000); // VREG1OUT voltage
         LCD_WR_REG(0x13, 0x0000); // VDV[4:0] for VCOM amplitude
//	 LCD_WR_REG(0x07, 0x0001); // 
  /*  */     	   
          Delay(10); // Dis-charge capacitor power voltage
         
         LCD_WR_REG(0x10, 0x1290); // SAP, BT[3:0], AP, DSTB, SLP, STB
         LCD_WR_REG(0x11, 0x0227); // DC1[2:0], DC0[2:0], VC[2:0]
         Delay(35); // Delay 50ms
        
         LCD_WR_REG(0x12, 0x0018); // Internal reference voltage= Vci;
         Delay(35); // Delay 50ms
         LCD_WR_REG(0x13, 0x1700); // Set VDV[4:0] for VCOM amplitude
         LCD_WR_REG(0x29, 0x0018); // Set VCM[5:0] for VCOMH
         LCD_WR_REG(0x2B, 0x000c); // Set Frame Rate
         
         
   /*   
         LCD_WR_REG(0x10, 0x1790); // SAP, BT[3:0], AP, DSTB, SLP, STB 
         LCD_WR_REG(0x11, 0x0227); // DC1[2:0], DC0[2:0], VC[2:0]
         Delay(15); // Delay 50ms
        
         LCD_WR_REG(0x12, 0x00d5); // Internal reference voltage= Vci;
         Delay(15); // Delay 50ms
         LCD_WR_REG(0x13, 0x1800); // Set VDV[4:0] for VCOM amplitude
         LCD_WR_REG(0x29, 0x001b); // Set VCM[5:0] for VCOMH
         LCD_WR_REG(0x2B, 0x000d); // Set Frame Rate
       
          
         LCD_WR_REG(0x10, 0x1590); // SAP, BT[3:0], AP, DSTB, SLP, STB
         LCD_WR_REG(0x11, 0x0227); // DC1[2:0], DC0[2:0], VC[2:0]
         Delay(5); // Delay 50ms
         LCD_WR_REG(0x12, 0x001e); // Internal reference voltage= Vci;
         Delay(15); // Delay 50ms
         LCD_WR_REG(0x13, 0x1500); // Set VDV[4:0] for VCOM amplitude
         LCD_WR_REG(0x29, 0x001f); // Set VCM[5:0] for VCOMH
         LCD_WR_REG(0x2B, 0x000d); // Set Frame Rate
         Delay(15); // Delay 50ms        
  */
#if   ID_AM==000         
	     LCD_WR_REG(0x0020,0x00ef);//GRAM水平起始位置
	     LCD_WR_REG(0x0021,0x013f);      
#elif ID_AM==001
	     LCD_WR_REG(0x0020,0x00ef);
	     LCD_WR_REG(0x0021,0x013f);      
#elif ID_AM==010
	     LCD_WR_REG(0x0020,0x0000);
	     LCD_WR_REG(0x0021,0x013f);      
#elif ID_AM==011
	     LCD_WR_REG(0x0020,0x0000);
	     LCD_WR_REG(0x0021,0x013f);       
#elif ID_AM==100
	     LCD_WR_REG(0x0020,0x00ef);
	     LCD_WR_REG(0x0021,0x0000);      
#elif ID_AM==101  
	     LCD_WR_REG(0x0020,0x00ef);
	     LCD_WR_REG(0x0021,0x0000);      
#elif ID_AM==110
	     LCD_WR_REG(0x0020,0x0000);
	     LCD_WR_REG(0x0021,0x0000);      
#elif ID_AM==111
	     LCD_WR_REG(0x0020,0x0000);
	     LCD_WR_REG(0x0021,0x0000);         
#endif  
// ----------- Adjust the Gamma Curve ----------//
        /*     
            LCD_WR_REG(0x0030, 0x0000);
	    LCD_WR_REG(0x0031, 0x0203);
	    LCD_WR_REG(0x0032, 0x0001);
            LCD_WR_REG(0x0035, 0x0205);
	    LCD_WR_REG(0x0036, 0x030C);
	    LCD_WR_REG(0x0037, 0x0607);
	    LCD_WR_REG(0x0038, 0x0405);
	    LCD_WR_REG(0x0039, 0x0707);
	    LCD_WR_REG(0x003C, 0x0502);
	    LCD_WR_REG(0x003D, 0x1308);
             
               */ 
		LCD_WR_REG(0x0030,0x0007);
		LCD_WR_REG(0x0031,0x0707);
		LCD_WR_REG(0x0032,0x0107);
		LCD_WR_REG(0x0035,0x0106);
		LCD_WR_REG(0x0036,0x0406);
		LCD_WR_REG(0x0037,0x0101);
		LCD_WR_REG(0x0038,0x0101);
		LCD_WR_REG(0x0039,0x0207);
		LCD_WR_REG(0x003C,0x0504);
		LCD_WR_REG(0x003D,0x0706);
  
           
                
//------------------ Set GRAM area ---------------//
         LCD_WR_REG(0x0050, 0x0000); // Horizontal GRAM Start Address
         LCD_WR_REG(0x0051, 0x00EF); // Horizontal GRAM End Address
         LCD_WR_REG(0x0052, 0x0000); // Vertical GRAM Start Address
         LCD_WR_REG(0x0053, 0x013F); // Vertical GRAM Start Address
         LCD_WR_REG(0x0060, 0xa700); // Gate Scan Line
         LCD_WR_REG(0x0061, 0x0001); // NDL,VLE, REV
         LCD_WR_REG(0x006A, 0x0000); // set scrolling line
//-------------- Partial Display Control ---------//

//-------------- Panel Control -------------------//
         LCD_WR_REG(0x90, 0x0010);
         LCD_WR_REG(0x92, 0x0000);
         LCD_WR_REG(0x93, 0x0003);
         LCD_WR_REG(0x95, 0x0110);
         LCD_WR_REG(0x97, 0x0000);
         LCD_WR_REG(0x98, 0x0000);

		 
		// LCD_WR_REG(0x07, 0x0031); // 262K color and display ON   0133
	Delay(5); // Delay 5ms
		 
         LCD_WR_REG(0x07, 0x0173); // 262K color and display ON   0133
         Delay(10); // Delay 5ms
	 LCD_Clear(000);
        
	 Delay(20); // Delay 5ms
         LCD_BL_H();
}


/**********************************************
函数名：Lcd全屏擦除函数
功能：将Lcd整屏擦为指定颜色
入口参数：color 指定Lcd全屏颜色 RGB(5-6-5)
返回值：无
***********************************************/
void LCD_Clear(unsigned int Color)
{
  unsigned long index = 0;
  
#if   ID_AM==000         
	     LCD_WR_REG(0x0020,0x00ef);//GRAM水平起始位置
	     LCD_WR_REG(0x0021,0x013f);      
#elif ID_AM==001
	     LCD_WR_REG(0x0020,0x00ef);
	     LCD_WR_REG(0x0021,0x013f);      
#elif ID_AM==010
	     LCD_WR_REG(0x0020,0x0000);
	     LCD_WR_REG(0x0021,0x013f);      
#elif ID_AM==011
	     LCD_WR_REG(0x0020,0x0000);
	     LCD_WR_REG(0x0021,0x013f);       
#elif ID_AM==100
	     LCD_WR_REG(0x0020,0x00ef);
	     LCD_WR_REG(0x0021,0x0000);      
#elif ID_AM==101  
	     LCD_WR_REG(0x0020,0x00ef);
	     LCD_WR_REG(0x0021,0x0000);      
#elif ID_AM==110
	     LCD_WR_REG(0x0020,0x0000);
	     LCD_WR_REG(0x0021,0x0000);      
#elif ID_AM==111
	     LCD_WR_REG(0x0020,0x0000);
	     LCD_WR_REG(0x0021,0x0000);         
#endif     

             LCD_WR_REG(0x0050,0x00);//水平 GRAM起始位置
             LCD_WR_REG(0x0051,239);//水平GRAM终止位置
             LCD_WR_REG(0x0052,0x00);//垂直GRAM起始位置
             LCD_WR_REG(0x0053,319);//垂直GRAM终止位置 
             LCD_WR_REG16(0x0022);
  
 // LCD_RD_H();
//  LCD_RS_H();
  //LCD_CS_L();   
  for(index = 0; index < 76800; index++)
  {
   // LCD_WR_DATA16(Color);
 
    LCD_WR_DATA16(Color);
 
   
  } 
  // LCD_CS_H();
}

void LCD_write_english(unsigned char data,unsigned int color,unsigned int xcolor)//写字符
{

  unsigned char avl,i,n;
   LCD_WR_REG16(0x0022);  
  for (i=0;i<16;i++)
  { 
      avl=english[data-32][i];
	  for (n=0;n<8;n++)
	   {
	     if(avl&0x80) LCD_WR_DATA16(color);
             else LCD_WR_DATA16(xcolor);
           
	     avl<<=1;
	   }
	}
}
void LCD_write_english_string(unsigned int x,unsigned int y,unsigned char *s,unsigned int color,unsigned int xcolor)//英文字符串显示
{
 unsigned int k=0;
 while (*s) 
  {
     Lcd_SetBox(y,x+k,15,8);
     LCD_write_english( *s,color,xcolor);
     k=k+8;
     s++;
  
  }

}  

void LCD_write_SUM(unsigned int x,unsigned int y,unsigned char SUM,unsigned int color,unsigned int xcolor)//写数字
{

  unsigned char avl,i,n;
   Lcd_SetBox(y,x,15,8);
   LCD_WR_REG16(0x0022);  
  for (i=0;i<16;i++)
  { 
      avl=english[SUM+16][i];
	  for (n=0;n<8;n++)
	   {
	     if(avl&0x80) LCD_WR_DATA16(color);
             else LCD_WR_DATA16(xcolor);
           
	     avl<<=1;
	   }
	}
}
/**********************************************
函数名：Lcd块选函数
功能：选定Lcd上指定的矩形区域

注意：xStart和 yStart随着屏幕的旋转而改变，位置是矩形框的四个角

入口参数：xStart x方向的起始点
          ySrart y方向的终止点
          xLong 要选定矩形的x方向长度
          yLong  要选定矩形的y方向长度
返回值：无
***********************************************/
void Lcd_SetBox(unsigned int xStart,unsigned int yStart,unsigned int xLong,unsigned int yLong)
{
  
#if ID_AM==000    
	LCD_SetCursor(xStart+xLong-1,312-yStart+yLong-1);

#elif ID_AM==001
	LCD_SetCursor(xStart+xLong-1,312-yStart+yLong-1);
     
#elif ID_AM==010
	LCD_SetCursor(xStart,312-yStart+yLong-1);
     
#elif ID_AM==011 
	LCD_SetCursor(xStart,312-yStart+yLong-1);
     
#elif ID_AM==100
	LCD_SetCursor(xStart+xLong-1,312-yStart);     
     
#elif ID_AM==101
	LCD_SetCursor(xStart+xLong-1,312-yStart);     
     
#elif ID_AM==110
	LCD_SetCursor(xStart,312-yStart); 
     
#elif ID_AM==111
	LCD_SetCursor(xStart,312-yStart);  
     
#endif
     
	LCD_WR_REG(0x0050,xStart);//水平 GRAM起始位置
	LCD_WR_REG(0x0051,xStart+xLong-1);//水平GRAM终止位置
	LCD_WR_REG(0x0052,312-yStart);//垂直GRAM起始位置
	LCD_WR_REG(0x0053,312-yStart+yLong-1);//垂直GRAM终止位置 
}


/*************************************************
函数名：Lcd光标起点定位函数
功能：指定320240液晶上的一点作为写数据的起始点
入口参数：x 坐标 0~239
          y 坐标 0~319
返回值：无
*************************************************/
void LCD_SetCursor(unsigned int Xpos, unsigned int Ypos)
{
 // CLR_RS;
  LCD_WR_REG(0x20, Xpos);
  LCD_WR_REG(0x21, Ypos);
}

/*
void Test_tu(void)
{
   unsigned int i;
  // unsigned char  val;
  LCD_WR_REG(0x0020,20);//Lcd光标GRAM水平起始位置
  LCD_WR_REG(0x0021,105); //Lcd光标垂直GRAM起始位置     

  LCD_WR_REG(0x0050,20);//水平 GRAM起始位置
  LCD_WR_REG(0x0051,207);//水平GRAM终止位置
  LCD_WR_REG(0x0052,105);//垂直GRAM起始位置
  LCD_WR_REG(0x0053,207);//垂直GRAM终止位置 
  LCD_WR_REG16(0x0022);
    	
   LCD_RD_H();
   LCD_RS_H();
   LCD_CS_L(); 
  for (i=0;i<21218;)
  { 

     LCD_WR_L();
	 //LCD_WR_L();
     DATA_LCD_PORT=gImage[i++];
     LCD_WR_H();

     LCD_WR_L();
	 //LCD_WR_L();
     DATA_LCD_PORT=gImage[i++];
     LCD_WR_H(); 

	}
   LCD_CS_H();
}
*/




void Test(void)
{       
        unsigned long n,i;
       LCD_WR_REG(0x0020,0x0000);//GRAM水平起始位置
       LCD_WR_REG(0x0021,0x0000); 
        for(i=0;i<7;i++)
          
        {       
        
            
	        LCD_WR_REG(0x0050,0x00);//水平 GRAM起始位置
	        LCD_WR_REG(0x0051,239);//水平GRAM终止位置
	        LCD_WR_REG(0x0052,0x00);//垂直GRAM起始位置
	        LCD_WR_REG(0x0053,319);//垂直GRAM终止位置 
           
            LCD_WR_REG16(0x0022);       
                for(n=0;n<76800;n++)
                { 
                  
                  
                  if(i==0)LCD_WR_DATA16(BLUE);   
                  if(i==1)LCD_WR_DATA16(RED); 
                  if(i==2)LCD_WR_DATA16(GREEN);
                  if(i==3)LCD_WR_DATA16(CYAN); 
                  if(i==4)LCD_WR_DATA16(MAGENTA); 
                  if(i==5)LCD_WR_DATA16(YELLOW);
				  
                  if(i==6)LCD_WR_DATA16(0x0102); 
                }    
                Delay(100);                
        }       
}
