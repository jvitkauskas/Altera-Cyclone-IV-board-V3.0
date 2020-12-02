/*******************************************************************
**我们的FPGA开发网
**网站：www.OurFPGA.com
**淘宝：OurFPGA.taobao.com
**邮箱: OurFPGA@gmail.com
**欢迎大家登陆网站，参与FPGA及电子技术讨论，下载免费视频教程及资料
*****************文件信息********************************************
**创建日期：   2011.06.07
**版本号：     version 1.0
**功能描述：   led灯闪烁实验，4个LED灯会以一定频率闪烁
********************************************************************/




module led_twinkle(led,clk);// 模块名及端口参数
	output [3:0] led;
	input clk;
	reg[3:0] led;// 输出端口定义为寄存器型
	reg[24:0] counter;  // 中间变量counter定义为寄存器型
	
	always@(posedge clk)//在时钟负延跳变
		begin // 顺序语句，到end止
			counter<=counter+1;  //<=与 =区别
		    //if(counter==25'b1011111010111100001000000) //判别counter中的数值为25000000时
		    if(counter==25'd25000000)
			
				begin	
					led<=~led;// led[0]-led[3]反转一次
			 		counter<=0;//重新计数
				end   
		end
endmodule
	