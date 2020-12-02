/*-------------------------------------------------------------------------
This confidential and proprietary software may be only used as authorized
by a licensing agreement from amfpga.
(C) COPYRIGHT 2013.amfpga ALL RIGHTS RESERVED
Filename			:		sdram_ov7670_vga.v
Author				:		Amfpga
Data				:		2013-02-1
Version				:		1.0
Description			:		sdram vga controller with ov7670 display.
Modification History	:
Data			By			Version			Change Description
===========================================================================
13/02/1
--------------------------------------------------------------------------*/
module key_down_scan
#(
	parameter KEY_WIDTH = 2
)
(
	input						clk,	//50MHz
	input						rst_n,	
	input		[KEY_WIDTH-1:0]	key_data,	

	output						key_flag,
	output		[KEY_WIDTH-1:0]	key_value	
);

//---------------------------------
//escape the jitters
reg [19:0]	delay_cnt;	//scan counter
reg	[KEY_WIDTH-1:0]	key_data_r;
always @(posedge clk or negedge rst_n)
begin
	if(!rst_n)	
		begin
		key_data_r <= {KEY_WIDTH{1'b1}};
		delay_cnt <= 0;
		end
	else 
		begin
		key_data_r <= key_data;								//lock the key value
		if((key_data == key_data_r) && (key_data != {KEY_WIDTH{1'b1}}))	//20ms escape jitter
			begin
			if(delay_cnt < 20'hfffff)
				delay_cnt <= delay_cnt + 1'b1;
			end
		else//if(key_data != key_data_r || key_data ==2'b11)
			delay_cnt <= 0;
		end
end
wire	key_trigger = (delay_cnt == 20'hfffff) ? 1'b1 : 1'b0;//key is down
assign	key_value = (key_trigger == 1'b1) ? key_data : 2'b11;

//-----------------------------------
localparam	KEY_DELAY = 20'd1_00000;	//50MHz, 1/50s
reg	[19:0]	key_cnt;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		key_cnt <= 0;
	else if(key_trigger)
		begin
		if(key_cnt < KEY_DELAY)	
			key_cnt <= key_cnt + 1'b1;
		else
			key_cnt <= 0;
		end
	else
		key_cnt <= 0;
end
assign	key_flag = (key_cnt == KEY_DELAY) ? 1'b1 : 1'b0;

endmodule
