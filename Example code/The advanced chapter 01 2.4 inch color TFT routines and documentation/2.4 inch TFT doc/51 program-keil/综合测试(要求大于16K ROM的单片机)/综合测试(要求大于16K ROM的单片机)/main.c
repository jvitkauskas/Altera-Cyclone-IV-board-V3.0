#include <reg51.h>
#include <intrins.h>
#include <sys\sys.h>
#include <lcd\lcd.h>
#include <font\font.h>
#include <touch\touch.h>
/* 
代码测试环境:单片机STC12LE5A60S2,晶振33M  单片机工作电压3.3V
程序默认IO连接方式：
控制线：RS-P3^5;    WR-P3^6;   RD-P3^7;   CS-P1^0;   REST-P1^2;
数据线: DB0-DB7依次连接P0^0-P0^7;  DB8-DB15依次连接P2^0-P2^7;（8位模式下DB0-DB7可以不连接）
触摸功能连接方式：(不使用触摸可不连接)
T_CLK-P1^7;  T_CS-P1^4;  T_DIN-P3^0;  T_OUT-P3^1;  T_IRQ-P3^4;
*/	
sbit key1=P3^2;
sbit key2=P3^3;
sbit key3=P3^4;
u8 ref=0;//刷新显示

u8 jiance() //检测触摸和按键
{
	if (tpstate()==0) //如果触摸按下，则进入绘图程序
	 {
	 	LCD_Clear(WHITE); //清屏
		BACK_COLOR=WHITE;
		POINT_COLOR=RED;
	 	point();
		return 1;
	 }	
	if(key1==0)	//如果按键1按下,进入校准程序 
	   {
		Touch_Adjust();//校准
		return 1;
	   }
	 if(key2==0)	//三色刷屏
	   {
		 LCD_Clear(RED);
		 delayms(3000);
		 LCD_Clear(GREEN);
		 delayms(3000);
		 LCD_Clear(BLUE);
		 delayms(3000);
		 return 1;
	   }
	   return 0;
}
void xianshi()//显示信息
{   
	u16 lx,ly;
	BACK_COLOR=WHITE;
	POINT_COLOR=RED;	
	showhanzi(10,0,0);  //晶
	showhanzi(45,0,1);  //耀
    LCD_ShowString(10,35,"http://ttmcu.taobao.com");
	LCD_ShowString(10,55,"LCD_W:");	LCD_ShowNum(70,55,LCD_W,3);
	LCD_ShowString(110,55,"LCD_H:");LCD_ShowNum(160,55,LCD_H,3);	
	lx=10;ly=75;			
	LCD_ShowString(lx,ly,"VX:");lx+=40;LCD_ShowNum(lx,ly,vx,5);					
	lx+=60;
	LCD_ShowString(lx,ly,"Vy:");lx+=40;LCD_ShowNum(lx,ly,vy,5);					
	lx=10;ly=95; 
	LCD_ShowString(lx,ly,"CHX:");lx+=40;LCD_ShowNum(lx,ly,chx,5);					
	lx+=60; 
	LCD_ShowString(lx,ly,"CHY:");lx+=40;LCD_ShowNum(lx,ly,chy,5);
}
void showimage() //显示40*40图片
{
  	int i,j,k; 
	LCD_Clear(WHITE); //清屏  
	xianshi(); //显示信息
	for(k=3;k<8;k++)
	{
	   	for(j=0;j<6;j++)
		{	
			Address_set(40*j,40*k,40*j+39,40*k+39);		//坐标设置
		    for(i=0;i<1600;i++)
			 { 	
				 if(jiance()) //检测触摸和按键
				 {	
				 	ref=1;
				  	return;	
				 }		
			  	 LCD_WR_DATA8(image[i*2+1],image[i*2]);	 //发送颜色数据为提高速度高8位低8位分别传递	   						
			 }	
		 }
	}
	ref=0;				
}
main()
{ 
	spistar()  ;//模拟SPI初始化
	Lcd_Init();   //tft初始化
	LCD_Clear(WHITE); //清屏
	BACK_COLOR=BLACK;;POINT_COLOR=WHITE; 
    showimage(); //显示40*40图片

	while(1)
	{
	    if(jiance()) //检测触摸和按键
	  {	
	  	showimage(); //显示40*40图片
	  }
	  if(ref){showimage();} //显示40*40图片

    }


}
