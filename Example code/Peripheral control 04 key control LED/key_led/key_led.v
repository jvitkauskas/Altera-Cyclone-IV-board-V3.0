/*******************************************************************
**我们的FPGA开发网
**网站：www.OurFPGA.com
**淘宝：OurFPGA.taobao.com
**邮箱: OurFPGA@gmail.com
**欢迎大家登陆网站，参与FPGA及电子技术讨论，下载免费视频教程及资料
*****************文件信息********************************************
**创建日期：   2011.06.01
**版本号：     version 1.0
**功能描述：   读取按键信号实验
如果按下的是key1,那么点亮LED1
如果按下的是key2,那么点亮LED1-LED2
以此类推，如果下按key4，那么全部点亮4个led
********************************************************************/


module key_led(key,led);//
input[3:0]key;//
output[3:0]led;
reg[3:0]led_r;
reg[3:0]buffer;
assign led=led_r;

always@(key)
begin
	buffer=key;
	case(buffer)
		8'b1110:led_r=8'b1110;//如果按下的是key1,那么点亮LED1
		8'b1101:led_r=8'b1100;//如果按下的是key2,那么点亮LED1-LED2
		8'b1011:led_r=8'b1000;//key3
		8'b0111:led_r=8'b0000;//key4
	    default:led_r=8'b1111;
	endcase
end
endmodule