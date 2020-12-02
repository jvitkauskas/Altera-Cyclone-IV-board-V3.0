`timescale 1ns / 1ps
////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:    17:27:40 08/28/08
// Design Name:    
// Module Name:    speed_select
// Project Name:   
// Target Device:  
// Tool versions:  
// Description:
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module speed_select(
				clk,rst_n,
				bps_start,clk_bps
			);

input clk;	// 50MHz主时钟
input rst_n;	//低电平复位信号
input bps_start;	//接收到数据后，波特率时钟启动信号置位
output clk_bps;	// clk_bps的高电平为接收或者发送数据位的中间采样点 

/*
parameter 		bps9600 	= 5207,	//波特率为9600bps
			 	bps19200 	= 2603,	//波特率为19200bps
				bps38400 	= 1301,	//波特率为38400bps
				bps57600 	= 867,	//波特率为57600bps
				bps115200	= 433;	//波特率为115200bps

parameter 		bps9600_2 	= 2603,
				bps19200_2	= 1301,
				bps38400_2	= 650,
				bps57600_2	= 433,
				bps115200_2 = 216;  
*/

	//以下波特率分频计数值可参照上面的参数进行更改
`define		BPS_PARA		5207	//波特率为9600时的分频计数值
`define 	BPS_PARA_2		2603	//波特率为9600时的分频计数值的一半，用于数据采样

reg[12:0] cnt;			//分频计数
reg clk_bps_r;			//波特率时钟寄存器

//----------------------------------------------------------
reg[2:0] uart_ctrl;	// uart波特率选择寄存器
//----------------------------------------------------------

always @ (posedge clk or negedge rst_n)
	if(!rst_n) cnt <= 13'd0;
	else if((cnt == `BPS_PARA) || !bps_start) cnt <= 13'd0;	//波特率计数清零
	else cnt <= cnt+1'b1;			//波特率时钟计数启动

always @ (posedge clk or negedge rst_n)
	if(!rst_n) clk_bps_r <= 1'b0;
	else if(cnt == `BPS_PARA_2) clk_bps_r <= 1'b1;	// clk_bps_r高电平为接收数据位的中间采样点,同时也作为发送数据的数据改变点
	else clk_bps_r <= 1'b0;

assign clk_bps = clk_bps_r;

endmodule



