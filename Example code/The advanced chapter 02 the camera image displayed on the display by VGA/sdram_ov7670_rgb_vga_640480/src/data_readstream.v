/*-------------------------------------------------------------------------
This confidential and proprietary software may be only used as authorized
by a licensing agreement from CrazyBingo.
(C) COPYRIGHT 2012 CrazyBingo. ALL RIGHTS RESERVED
Filename			:		data_readstream.v
Author				:		CrazyBingo
Data				:		2012-3-13
Version				:		1.0
Description			:		led test for sram2fifo design.
Modification History	:
Data			By			Version			Change Description
===========================================================================
12/03/13		CrazyBingo	1.0				Original
--------------------------------------------------------------------------*/
`timescale 1ns/1ns
module data_readstream
(
	input	clk,
	input	rst_n,
	
	input	clk_bps,
	input	read_valid,
	
	output	reg	txd_en,
	output	reg	sys_rd
);

//localparam	DELAY_CNT	=	5'd4;
//localparam	DATA_CNT	=	19'd64;
localparam	DELAY_CNT	=	5'd16;
localparam	DATA_CNT	=	22'd1024;//{1'b1,2'b00,20'b0};	//19'd4096;

//------------------------------------------
//计数模块
reg	[4:0]	cnt;	//16
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt <= 0;
	else if(read_valid & clk_bps)
		begin
		if(cnt < DELAY_CNT)
			cnt <= cnt + 1'b1;
		else
			cnt <= 0;
		end
	else
		cnt <= cnt;
end
wire delay_16 = (cnt == DELAY_CNT) ? 1'b1 : 1'b0;

//--------------------------
//读写使能信号
reg	[22:0]	dcnt;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		dcnt <= 0;
		sys_rd <= 0;
		txd_en <= 0;
		end
	else if(dcnt < DATA_CNT && delay_16 == 1'b1 && clk_bps == 1'b1)
		begin
		dcnt  <= dcnt + 1'b1;
		sys_rd <= 1'b1;
		txd_en <= 1'b1;
		end
	else
		begin
		dcnt <= dcnt;
		sys_rd <= 1'b0;
		txd_en <= 1'b0;
		end
end

endmodule
