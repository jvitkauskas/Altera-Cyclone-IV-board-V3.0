/*******************************************************************
**我们的FPGA开发网
**网站：www.OurFPGA.com
**淘宝：OurFPGA.taobao.com
**邮箱: OurFPGA@gmail.com
**欢迎大家登陆网站，参与FPGA及电子技术讨论，下载免费视频教程及资料
*****************文件信息********************************************
**创建日期：   2011.06.01
**版本号：     version 1.0
**功能描述：   半加器(不考虑来自低位的进位将两个1位二进制数相加)
********************************************************************/

module half_adder(A,B,S,CO);
	input A,B;
	output S,CO;
     assign	S=A^B;  //异或
	assign   CO=A&B;//直接赋值，与
	
endmodule
	