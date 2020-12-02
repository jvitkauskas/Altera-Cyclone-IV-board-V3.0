
/*FPGA通过ps2接收键盘数据，然后把接收到的字母A到Z键值转换相应的ASII码，通过串口发送到PC机上。
实验时，需要接键盘，还要用调试助手，下载程序后，在键盘上按下一个键，比如A，则在PC调试助手上可看到A
*/


`timescale 1ns / 1ps

module ps2_key(clk,rst_n,ps2k_clk,ps2k_data,rs232_tx);

input clk;			//50M时钟信号
input rst_n;		//复位信号
input ps2k_clk;		//PS2接口时钟信号
input ps2k_data;	//PS2接口数据信号
output rs232_tx;	// RS232发送数据信号


wire[7:0] ps2_byte;	// 1byte键值
wire ps2_state;		//按键状态标志位

wire bps_start;		//接收到数据后，波特率时钟启动信号置位
wire clk_bps;		// clk_bps的高电平为接收或者发送数据位的中间采样点 

ps2scan			ps2scan(	.clk(clk),			  	//按键扫描模块
								.rst_n(rst_n),				
								.ps2k_clk(ps2k_clk),
								.ps2k_data(ps2k_data),
								.ps2_byte(ps2_byte),
								.ps2_state(ps2_state)
								);

speed_select	speed_select(	.clk(clk),
										.rst_n(rst_n),
										.bps_start(bps_start),
										.clk_bps(clk_bps)
										);

my_uart_tx		my_uart_tx(		.clk(clk),
										.rst_n(rst_n),
										.clk_bps(clk_bps),
										.rx_data(ps2_byte),
										.rx_int(ps2_state),
										.rs232_tx(rs232_tx),
										.bps_start(bps_start)
										);

endmodule
