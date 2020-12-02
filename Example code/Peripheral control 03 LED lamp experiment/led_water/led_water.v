/*******************************************************************
**我们的FPGA开发网
**网站：www.OurFPGA.com
**淘宝：OurFPGA.taobao.com
**邮箱: OurFPGA@gmail.com
**欢迎大家登陆网站，参与FPGA及电子技术讨论，下载免费视频教程及资料
*****************文件信息********************************************
**创建日期：   2011.06.07
**版本号：     version 1.0
**功能描述：   led流水灯实验
********************************************************************/


module led_water(led,clk);// 模块名及端口参数
output[3:0]led;				// 输出端口定义
input clk; // 输入端口定义，50M 时钟
reg[3:0] led;//变量led_out 定义为寄存器型
//reg[4:0] led1;//变量led_out 定义为寄存器型
reg[24:0] counter;//变量led_out 定义为寄存器型

always@(posedge clk)
begin
    counter<=counter+1;
	if(counter==25'd25000000)
	begin
		led<=led<<1;// led 向左移位，空闲位自动添0 补位
		counter<=0;//计数器清0
		if(led==8'b0000)//每到时间临界点后,左移一位,一直到8位全部都变为0
		led<=8'b1111;//重新赋值为全1,
	end
	
end
endmodule
	
