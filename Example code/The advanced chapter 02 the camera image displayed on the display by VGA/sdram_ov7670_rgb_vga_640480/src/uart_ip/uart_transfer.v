/**************************************************************
 *	File Name		:		uart_transfer.v		
 *	Author			:		Crazy Bingo
 *	Version			:		Quartus II 9.1 SP2
 *	CreateDate		:		2011/01/28
 *	Description		:		txd data Transfer
**************************************************************/
`timescale 1ns/1ns
module uart_transfer
(
	input			clk,
	input			clk_bps,
	input			rst_n,
	input			txd_en,		//txd data mark
	input	[7:0]	txd_data,
	
	output			txd_flag,	//txd data over mark
	output	reg		txd
);

//-------------------------------------
//transfer data from cpu to pc
parameter	T_IDLE	=	1'b0;	//test the flag to transfer data
parameter	T_SEND	=	1'b1;	//uart transfer data
reg			txd_state;
reg	[3:0]	txd_cnt;			//txd data counter
reg			txd_flag_r;
always@(posedge clk	or negedge rst_n)
begin
	if(!rst_n)
		begin
		txd_cnt <= 0;
		txd	<= 1'b1;	
		txd_flag_r <= 0;
		txd_state <= T_IDLE;
		end
	else
		begin
		case(txd_state)
		T_IDLE:		
			begin
			txd_cnt <= 0;
			txd <= 1;
			txd_flag_r <= 0;
			if(txd_en == 1)
				txd_state <= T_SEND;
			else
				txd_state <= T_IDLE;
			end	
		T_SEND:	
			begin
			if(clk_bps == 1)
				begin
				if(txd_cnt < 4'd9)
					begin
					txd_cnt <= txd_cnt + 1'b1;
					txd_flag_r <= 0;
					txd_state <= T_SEND;
					end
				else
					begin
					txd_cnt <= 0;
					txd_flag_r <= 1;
					txd_state <= T_IDLE;
					end
				case(txd_cnt)
				4'd0:	txd <= 0;
				4'd1:	txd <= txd_data[0];
				4'd2:	txd <= txd_data[1];
				4'd3:	txd <= txd_data[2];
				4'd4:	txd <= txd_data[3];
				4'd5:	txd <= txd_data[4];
				4'd6:	txd <= txd_data[5];
				4'd7:	txd <= txd_data[6];
				4'd8:	txd <= txd_data[7];
				4'd9:	txd <= 1;
				endcase
				end	
			else
				begin
				begin
				txd <= txd;
				txd_cnt <= txd_cnt;
				txd_flag_r <= txd_flag_r;
				txd_state <= txd_state;
				end
				end
			end		
		endcase
		end
end

//-------------------------------------
//Capture the falling of data transfer over
reg	txd_flag_r0,txd_flag_r1;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		txd_flag_r0 <= 0;
		txd_flag_r1 <= 0;
		end
	else
		begin
		txd_flag_r0 <= txd_flag_r;
		txd_flag_r1 <= txd_flag_r0;
		end
end
assign	txd_flag = txd_flag_r1 & ~txd_flag_r0;

endmodule

