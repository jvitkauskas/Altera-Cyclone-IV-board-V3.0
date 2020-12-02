/*******************************************************************
**我们的FPGA开发网
**网站：www.OurFPGA.com
**淘宝：OurFPGA.taobao.com
**邮箱: OurFPGA@gmail.com
**欢迎大家登陆网站，参与FPGA及电子技术讨论，下载免费视频教程及资料
*****************文件信息********************************************
**创建日期：   2011.06.01
**版本号：     version 1.0
**功能描述：   蜂鸣器输出报警声实验 滴。。滴。。滴。。
********************************************************************/


module	beep(clk,beep);					//模块名称beep		
input	clk;							//系统时钟	
output	beep;							//蜂鸣器输出端				
reg beep_r;								//寄存器
reg[27:0]count;

assign beep = beep_r;					//脉冲输出

always@(posedge clk)
begin
	count <= count + 1'b1;
end

always @(count[9])
begin
	beep_r = !(count[13]&count[24]&count[27]);
end

endmodule