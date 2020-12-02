/*-------------------------------------------------------------------------
This confidential and proprietary software may be only used as authorized
by a licensing agreement from CrazyBingo.
(C) COPYRIGHT 2012 CrazyBingo. ALL RIGHTS RESERVED
Filename			:		data_generate.v
Author				:		CrazyBingo
Data				:		2012-03-12
Version				:		1.0
Description			:		data generate uart.
Modification History	:
Data			By			Version			Change Description
===========================================================================
12/03/12		CrazyBingo	1.0				Original
12/03/21		CrazyBingo	1.0				Complete
--------------------------------------------------------------------------*/
`timescale 1 ns / 1 ns
module data_generate
(
	input				clk,			//50 MHz	
	input				rst_n,      	//Global reset
	
	input				sdram_init_done,
	//sys 2 sram 控制总线
	output	reg			wr_load,
	output	reg			rd_load,
	output	reg	[15:0]	sys_data,
	output	reg			sys_we,
	output	reg	[1:0]	wr_bank,
	output	reg	[1:0]	rd_bank
);

`define RED		16'hF800   /*111110,000000,000000	F800 红*/
`define GREEN	16'h07E0   /*000000,111111,000000	07E0 绿*/
`define BLUE  	16'h001F   /*000000,000000,111110	001F 蓝*/
`define WHITE 	16'hFFFF   /*111110,111111,111110	FFFF 白*/
`define BLACK 	16'h0000   /*000000,000000,000000	0000 黑*/
`define YELLOW	16'hFFE0   /*111110,111111,000000	FFE0 黄*/
`define CYAN  	16'hF81F   /*111110,000000,111110	F81F 青*/
`define ROYAL 	16'h07FF   /*000000,111111,111110	07FF 品*/ 


localparam	DELAY_CNT	=	8'd255;
localparam	SYSADDR_CNT	=	23'd307200;	//23'd786432;	//1024*768


//-------------------------------------
//delay for 2s for next image
reg	[25:0]	disp_cnt;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		disp_cnt <= 0;
	else if(state == 4'd6)
		if(disp_cnt < 26'd50_000000)	//2s
			disp_cnt <= disp_cnt + 1'b1;
		else
			disp_cnt <= disp_cnt;
	else
		disp_cnt <= 0;
end
wire	disp_done = (disp_cnt == 26'd50_000000) ? 1'b1 : 1'b0;


//----------------------------------------
//display bank choose
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		wr_bank <= 2'b00; 
		rd_bank <= 2'b11;
		end
	else
		begin
		wr_bank <= image_cnt; 
		rd_bank <= image_cnt - 1'b1;
		end		
end

//---------------------------------------
reg	[1:0]	image_cnt;
reg	[3:0]	state;
reg	[22:0]	addr_cnt;
reg	[10:0]	lcd_xpos;
reg	[10:0]	lcd_ypos;
localparam	H_DISP = 11'd640;
localparam	V_DISP = 11'd480;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		image_cnt <= 0;
		addr_cnt <= 0;
		state <= 0;
		sys_data <= 0;
		sys_we <= 0;
		wr_load <= 0; 
		rd_load <= 0;
		lcd_xpos <= 0;
		lcd_ypos <= 0;
		end
	else if(sdram_init_done)
		begin
		case(state)
		4'd0:	begin	wr_load <= 1'b0; rd_load <= 1'b0; 	state <= 4'd1;	end
		4'd1:	begin	wr_load <= 1'b1; rd_load <= 1'b1;	state <= 4'd2;	end
		4'd2:	begin	wr_load <= 1'b0; rd_load <= 1'b0;	state <= 4'd3;	end
		4'd3:	
			begin 	
			state <= 4'd4;	
//-----------------------------------------------------------------------------------------------	
			addr_cnt <= addr_cnt + 1'b1;

			if(lcd_xpos < H_DISP -'b1)
				lcd_xpos <= lcd_xpos + 1'b1;
			else
				lcd_xpos <= 11'd0;
				
			if(lcd_xpos == H_DISP - 1'b1)
				begin
				if(lcd_ypos < V_DISP - 1'b1)
					lcd_ypos <= lcd_ypos + 1'b1;
				else
					lcd_ypos <= 11'd0;
				end
			else
				lcd_ypos <= lcd_ypos;
			
			case(image_cnt)
			2'd0:	sys_data <= lcd_xpos * lcd_ypos;
			2'd1:	sys_data <= (lcd_xpos >= (H_DISP/8)*0 && lcd_xpos < (H_DISP/8)*1) ? `RED	:
							(lcd_xpos >= (H_DISP/8)*1 && lcd_xpos < (H_DISP/8)*2) ? `GREEN	:
							(lcd_xpos >= (H_DISP/8)*2 && lcd_xpos < (H_DISP/8)*3) ? `BLUE	:
							(lcd_xpos >= (H_DISP/8)*3 && lcd_xpos < (H_DISP/8)*4) ? `WHITE	:
							(lcd_xpos >= (H_DISP/8)*4 && lcd_xpos < (H_DISP/8)*5) ? `BLACK	:
							(lcd_xpos >= (H_DISP/8)*5 && lcd_xpos < (H_DISP/8)*6) ? `YELLOW	:
							(lcd_xpos >= (H_DISP/8)*6 && lcd_xpos < (H_DISP/8)*7) ? `CYAN	:	`ROYAL;
			2'd2:	sys_data <= lcd_xpos;
			2'd3:	sys_data <= lcd_ypos; 
			endcase
//----------------------------------------------------------------------------------------------		
//			sys_data <= lcd_xpos; 
//			sys_data <= lcd_ypos; 
//-----------------------------------------------------------------------------------------------
//			sys_data <= lcd_xpos * lcd_ypos;
//			sys_data <= addr_cnt[19:10] * addr_cnt[9:0];
//----------------------------------------------------------------------------------------------		
//			sys_data <= (lcd_xpos >= (H_DISP/8)*0 && lcd_xpos < (H_DISP/8)*1) ? `RED	:
//						(lcd_xpos >= (H_DISP/8)*1 && lcd_xpos < (H_DISP/8)*2) ? `GREEN	:
//						(lcd_xpos >= (H_DISP/8)*2 && lcd_xpos < (H_DISP/8)*3) ? `BLUE	:
//						(lcd_xpos >= (H_DISP/8)*3 && lcd_xpos < (H_DISP/8)*4) ? `WHITE	:
//						(lcd_xpos >= (H_DISP/8)*4 && lcd_xpos < (H_DISP/8)*5) ? `BLACK	:
//						(lcd_xpos >= (H_DISP/8)*5 && lcd_xpos < (H_DISP/8)*6) ? `YELLOW	:
//						(lcd_xpos >= (H_DISP/8)*6 && lcd_xpos < (H_DISP/8)*7) ? `CYAN	:	`ROYAL;

//----------------------------------------------------------------------------------------------			
//			sys_data <= (lcd_ypos >= (V_DISP/4)*0 && lcd_ypos < (V_DISP/4)*1) ? `RED	:
//						(lcd_ypos >= (V_DISP/4)*1 && lcd_ypos < (V_DISP/4)*2) ? `GREEN	:
//						(lcd_ypos >= (V_DISP/4)*2 && lcd_ypos < (V_DISP/4)*3) ? `WHITE	:	`BLUE;
//
//----------------------------------------------------------------------------------------------				
			// sys_data <= (lcd_xpos >= (H_DISP/16)*0  &&  lcd_xpos < (H_DISP/16)*1 ) ? `RED		:
						// (lcd_xpos >= (H_DISP/16)*1  &&  lcd_xpos  < (H_DISP/16)*2 ) ? `GREEN	:
						// (lcd_xpos >= (H_DISP/16)*2  &&  lcd_xpos  < (H_DISP/16)*3 ) ? `BLUE	:
						// (lcd_xpos >= (H_DISP/16)*3  &&  lcd_xpos  < (H_DISP/16)*4 ) ? `WHITE	:
						// (lcd_xpos >= (H_DISP/16)*4  &&  lcd_xpos  < (H_DISP/16)*5 ) ? `BLACK	:
						// (lcd_xpos >= (H_DISP/16)*5  &&  lcd_xpos  < (H_DISP/16)*6 ) ? `YELLOW	:
						// (lcd_xpos >= (H_DISP/16)*6  &&  lcd_xpos  < (H_DISP/16)*7 ) ? `CYAN	:
						// (lcd_xpos >= (H_DISP/16)*7  &&  lcd_xpos  < (H_DISP/16)*8 ) ? `ROYAL	:							
						// (lcd_xpos >= (H_DISP/16)*8  &&  lcd_xpos  < (H_DISP/16)*9 ) ? `RED		:
						// (lcd_xpos >= (H_DISP/16)*9  &&  lcd_xpos  < (H_DISP/16)*10) ? `GREEN	:
						// (lcd_xpos >= (H_DISP/16)*10 &&  lcd_xpos  < (H_DISP/16)*11) ? `BLUE	:
						// (lcd_xpos >= (H_DISP/16)*11 &&  lcd_xpos  < (H_DISP/16)*12) ? `WHITE  	:
						// (lcd_xpos >= (H_DISP/16)*12 &&  lcd_xpos  < (H_DISP/16)*13) ? `BLACK  	:
						// (lcd_xpos >= (H_DISP/16)*13 &&  lcd_xpos  < (H_DISP/16)*14) ? `YELLOW 	:
						// (lcd_xpos >= (H_DISP/16)*14 &&  lcd_xpos  < (H_DISP/16)*15) ? `CYAN   	: `ROYAL;

//----------------------------------------------------------------------------------------------
//			 if(lcd_ypos < V_DISP/2)		
//				sys_data <= (lcd_xpos >= (H_DISP/8)*0 && lcd_xpos < (H_DISP/8)*1) ? `RED	:
//							(lcd_xpos >= (H_DISP/8)*1 && lcd_xpos < (H_DISP/8)*2) ? `GREEN	:
//							(lcd_xpos >= (H_DISP/8)*2 && lcd_xpos < (H_DISP/8)*3) ? `BLUE	:
//							(lcd_xpos >= (H_DISP/8)*3 && lcd_xpos < (H_DISP/8)*4) ? `WHITE	:
//							(lcd_xpos >= (H_DISP/8)*4 && lcd_xpos < (H_DISP/8)*5) ? `BLACK	:
//							(lcd_xpos >= (H_DISP/8)*5 && lcd_xpos < (H_DISP/8)*6) ? `YELLOW:
//							(lcd_xpos >= (H_DISP/8)*6 && lcd_xpos < (H_DISP/8)*7) ? `CYAN	:	`ROYAL;
//			else
//				sys_data <= (lcd_ypos >= (V_DISP/8)*4 && lcd_ypos < (V_DISP/8)*5) ? `BLACK	:
//							(lcd_ypos >= (V_DISP/8)*5 && lcd_ypos < (V_DISP/8)*6) ? `YELLOW	:
//							(lcd_ypos >= (V_DISP/8)*6 && lcd_ypos < (V_DISP/8)*7) ? `CYAN	:	`ROYAL;
			end
		4'd4:	begin 	state <= 4'd5;	sys_we <= 1'b1;	end
		4'd5:	begin
				sys_we <= 1'b0;
				if(addr_cnt < SYSADDR_CNT)
					state <= 4'd3;
				else					
					state <= 4'd6;
				end
		4'd6:	begin
				addr_cnt <= 0;
				lcd_xpos <= 0;
				lcd_ypos <= 0;
				if(disp_done)	
					begin
					image_cnt <= image_cnt + 1'b1;
					state <= 4'd0;	
					end
				else
					state <= 4'd6;
				end
		default:;
		endcase
		end
	else
		begin
		image_cnt <= 0;
		addr_cnt <= 0;
		state <= 0;
		sys_data <= 0;
		sys_we <= 0;
		wr_load <= 0; 
		rd_load <= 0;
		lcd_xpos <= 0;
		lcd_ypos <= 0;
		end
end
endmodule
