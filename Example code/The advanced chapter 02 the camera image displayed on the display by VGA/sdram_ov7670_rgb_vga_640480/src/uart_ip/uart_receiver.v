/*-------------------------------------------------------------------------
This confidential and proprietary software may be only used as authorized
by a licensing agreement from CrazyBingo.
(C) COPYRIGHT 2012 CrazyBingo. ALL RIGHTS RESERVED
Filename			:		uart_receiver.v
Author				:		CrazyBingo
Data				:		2011-01-28
Version				:		1.0
Description			:		data receive for uart.
Modification History	:
Data			By			Version			Change Description
===========================================================================
11/01/28		CrazyBingo	1.0				Original
--------------------------------------------------------------------------*/
`timescale 1 ns / 1 ns
module uart_receiver
(
	input				clk,
	input				clk_smp,	//clk_smp=16*clk_bps
	input				rst_n,
	
	input				rxd,
	output				rxd_flag,	//the flag of receive over
	output	reg	[7:0]	rxd_data	
);

//---------------------------------
//sync the data: rxd_sync
reg	rxd_sync_r0,rxd_sync_r1;				
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		rxd_sync_r0 <= 1;
		rxd_sync_r1 <= 1;
		end
	else if(clk_smp == 1)
		begin
		rxd_sync_r0 <= rxd;
		rxd_sync_r1 <= rxd_sync_r0;
		end
end
wire	rxd_sync = rxd_sync_r1;

//---------------------------------
//sample signal, receive data
parameter	R_IDLE		=	1'b0;		//>=7 clk_smp : receive flag 
parameter	R_SAMPLE	=	1'b1;		//sample data programmer
reg			rxd_state;
reg	[3:0]	smp_cnt;					//sample cycle counter
reg	[2:0]	rxd_cnt;					//the lenth of data
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		smp_cnt <= 0;
		rxd_cnt <= 0;
		rxd_data <= 0;
		rxd_state <= R_IDLE;
		end
	else if(clk_smp == 1)
		begin
		case(rxd_state)
		R_IDLE:
			begin
			rxd_cnt <= 0;
			if(rxd_sync == 1'b0)
				begin
				smp_cnt <= smp_cnt + 1'b1;
				if(smp_cnt == 4'd7)		//8 clk_smp enable
					rxd_state <= R_SAMPLE;
				end
			else
				smp_cnt <= 0;
			end
		R_SAMPLE:	
			begin
			smp_cnt <= smp_cnt +1'b1;
			if(smp_cnt == 4'd7)
				begin
				rxd_cnt <= rxd_cnt +1'b1;
				if(rxd_cnt == 4'd7)
					rxd_state <= R_IDLE;
				case(rxd_cnt)
				3'd0:	rxd_data[0] <= rxd_sync;
				3'd1:	rxd_data[1] <= rxd_sync;
				3'd2:	rxd_data[2] <= rxd_sync;
				3'd3:	rxd_data[3] <= rxd_sync;
				3'd4:	rxd_data[4] <= rxd_sync;
				3'd5:	rxd_data[5] <= rxd_sync;
				3'd6:	rxd_data[6] <= rxd_sync;
				3'd7:	rxd_data[7] <= rxd_sync;
				endcase
				end
			end
		endcase
		end
end
wire	rxd_flag_r = (rxd_cnt == 4'd7) ? 1'b1 : 1'b0;

//---------------------------------
//the signal flag of rxd receive over
reg	rxd_flag_r0,rxd_flag_r1;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		rxd_flag_r0 <= 0;
		rxd_flag_r1 <= 0;
		end
	else
		begin
		rxd_flag_r0 <= rxd_flag_r;
		rxd_flag_r1 <= rxd_flag_r0;
		end
end
assign	rxd_flag = ~rxd_flag_r1 & rxd_flag_r0;

endmodule
