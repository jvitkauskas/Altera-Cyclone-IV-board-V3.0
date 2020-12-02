/*
GUANFU_WANG@126.COM
QQ:21578936
未经许可禁止任何商业用途
*/
#include "Touch.h"

void Touch_Config(void) 
{ 

        
        GPIO_InitTypeDef GPIO_InitStructure; 

        RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE); 
        //SPI接口配置 
        
        ///TP 片选 CS  PB11
        GPIO_InitStructure.GPIO_Pin = GPIO_Pin_11;
        GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
        GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
        GPIO_Init(GPIOB, &GPIO_InitStructure);
        


        /*PB10-INT,输入*/ 
        GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10; 
        GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IPU; //上拉 
        GPIO_Init(GPIOB, &GPIO_InitStructure); 
        TP_CS_H(); 


        tp_EXTI_Config();
        tp_Interrupts_Config();

} 
/*************************************************************************
 * Function Name: SdTranserByte
 * Parameters: unsigned char ch
 * Return: unsigned char 
 *
 * Description: Transfer byte by SPI
 *
 *************************************************************************/
unsigned char SdTranserByte (unsigned char ch)
{

    return(SPI_ReadWriteByte( ch ));
}
//不触摸的时候返回0 
u16 GetTouchX(void) 
{ 
     u16 tmp_x; 
     SPI_SetSpeed(0); //设置SPI为低速模式
     TP_CS_L(); 
     // delay();
     SdTranserByte(0xd0 );
 
     tmp_x=SdTranserByte(0); 
     tmp_x<<=8; 
     tmp_x|=SdTranserByte(0); 
     tmp_x>>=3; 
     TP_CS_H(); 
     return tmp_x; 
} 
//不触摸的时候返回0xfff 
u16 GetTouchY(void) 
{ 
    u16 tmp_y; 
    SPI_SetSpeed(0); //设置SPI为低速模式
    TP_CS_L(); 

    // delay(); 
    SdTranserByte(0x90); //命令行 90-power-down 
// delay(); 
    tmp_y=SdTranserByte(0); 
    tmp_y<<=8; 
    tmp_y|=SdTranserByte(0); 
    tmp_y>>=3; 

    TP_CS_H(); 
    return tmp_y; 
} 


void tp_Interrupts_Config(void)
{
    NVIC_InitTypeDef NVIC_InitStructure;

 
  /* Configure one bit for preemption priority */
    NVIC_PriorityGroupConfig(NVIC_PriorityGroup_1);
  

    /* Configure one bit for preemption priority */
    NVIC_PriorityGroupConfig(NVIC_PriorityGroup_1);
  

    NVIC_InitStructure.NVIC_IRQChannel = EXTI15_10_IRQChannel;
    NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 1;
    NVIC_InitStructure.NVIC_IRQChannelSubPriority = 3;
    NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
    NVIC_Init(&NVIC_InitStructure);

}


void tp_EXTI_Config(void)
{
    EXTI_InitTypeDef EXTI_InitStructure;
  
    GPIO_EXTILineConfig(GPIO_PORT_SOURCE_tp, GPIO_PIN_SOURCE_tp);
    EXTI_InitStructure.EXTI_Line = EXTI_LINE_tp;
    EXTI_InitStructure.EXTI_Mode = EXTI_Mode_Interrupt;
    EXTI_InitStructure.EXTI_Trigger = EXTI_Trigger_Rising ;
    EXTI_InitStructure.EXTI_LineCmd = ENABLE;
    EXTI_Init(&EXTI_InitStructure);
    EXTI_GenerateSWInterrupt(EXTI_LINE_tp);

}
int  GUI_TOUCH_X_MeasureX(void) 
{
	unsigned char t=0,t1,count=0;
	unsigned short int databuffer[10]={5,7,9,3,2,6,4,0,3,1};//数据组
	unsigned short temp=0,X=0;	
 	
	while(/*GPIO_ReadInputDataBit(GPIOB,GPIO_Pin_0)==0&&*/count<10)//循环读数10次
	{	   	  
		databuffer[count]=GetTouchX();
		count++; 
	}  
	if(count==10)//一定要读到10次数据,否则丢弃
	{  
	    do//将数据X升序排列
		{	
			t1=0;		  
			for(t=0;t<count-1;t++)
			{
				if(databuffer[t]>databuffer[t+1])//升序排列
				{
					temp=databuffer[t+1];
					databuffer[t+1]=databuffer[t];
					databuffer[t]=temp;
					t1=1; 
				}  
			}
		}while(t1); 	    		 	 		  
		X=(databuffer[3]+databuffer[4]+databuffer[5])/3;	  
//		if(X<=3730&&Y<=3730) //个人的屏根据初始参数修改.
//		{
//			if(X>=330)X-=330;
//			else X=0;
//			if(Y>=420)Y-=420;
//			else Y=0;  
//			drawbigpoint(240-X/14,320-Y/10);	 
//		}  
	}
	return(X);  
}

int  GUI_TOUCH_X_MeasureY(void) 
{
  	unsigned char t=0,t1,count=0;
	unsigned short int databuffer[10]={5,7,9,3,2,6,4,0,3,1};//数据组
	unsigned short temp=0,Y=0;	
 
        while(/*GPIO_ReadInputDataBit(GPIOB,GPIO_Pin_0)==0&&*/count<10)	//循环读数10次
	{	   	  
		databuffer[count]=GetTouchY();
		count++;  
	}  
	if(count==10)//一定要读到10次数据,否则丢弃
	{  
	    do//将数据X升序排列
		{	
			t1=0;		  
			for(t=0;t<count-1;t++)
			{
				if(databuffer[t]>databuffer[t+1])//升序排列
				{
					temp=databuffer[t+1];
					databuffer[t+1]=databuffer[t];
					databuffer[t]=temp;
					t1=1; 
				}  
			}
		}while(t1); 	    		 	 		  
		Y=(databuffer[3]+databuffer[4]+databuffer[5])/3;	  
//		if(X<=3730&&Y<=3730) //个人的屏根据初始参数修改.
//		{
//			if(X>=330)X-=330;
//			else X=0;
//			if(Y>=420)Y-=420;
//			else Y=0;  
//			drawbigpoint(240-X/14,320-Y/10);	 
//		}   
	}
	return(Y); 
}