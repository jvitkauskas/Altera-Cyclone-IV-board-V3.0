/*-------------------------------------------------------------------------
This confidential and proprietary software may be only used as authorized
by a licensing agreement from amfpga.
(C) COPYRIGHT 2013.www.amfpga.com ALL RIGHTS RESERVED
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
`timescale 1ns/1ns
module I2C_Controller 
(
	//Global iCLK
	input				iCLK,		
	input				iRST_N,		
	
	//I2C transfer
	input				I2C_CLK,	//DATA Transfer Enable
	input				I2C_EN,		//I2C DATA ENABLE
	input		[23:0]	I2C_WDATA,	//DATA:[SLAVE_ADDR, SUB_ADDR, DATA]
	output				I2C_SCLK,	//I2C iCLK
 	inout				I2C_SDAT,	//I2C DATA
	input				WR,     	//Write | Read
	input				GO,      	//GO transfor
	output				ACK,      	//ACK
	output	reg			END,     	//END transfor 
	output	reg	[7:0]	I2C_RDATA	//I2C Data read
);

//------------------------------------
//I2C Signal
reg		I2C_BIT;
reg 	SCLK;	//I2C Free Clock
reg	[5:0]	SD_COUNTER;

//Write: ID-Address + SUB-Address + W-Data
wire 	I2C_SCLK1 = 	(GO == 1 &&
						((SD_COUNTER >= 5 && SD_COUNTER <=12 || SD_COUNTER == 14) ||	
						(SD_COUNTER >= 16 && SD_COUNTER <=23 || SD_COUNTER == 25) ||
						(SD_COUNTER >= 27 && SD_COUNTER <=34 || SD_COUNTER == 36))) ? I2C_CLK : SCLK;

//I2C Read: {ID-Address + SUB-Address} + {ID-Address + R-Data}						
wire 	I2C_SCLK2 = 	(GO == 1 &&
						((SD_COUNTER >= 5 && SD_COUNTER <=12 || SD_COUNTER == 14) ||
						(SD_COUNTER >= 16 && SD_COUNTER <=23 || SD_COUNTER == 25) ||
						(SD_COUNTER >= 33 && SD_COUNTER <=40 || SD_COUNTER == 42) ||
						(SD_COUNTER >= 45 && SD_COUNTER <=52 || SD_COUNTER == 54))) ? I2C_CLK : SCLK;						
assign	I2C_SCLK = WR ? I2C_SCLK1 : I2C_SCLK2;	

wire	SDO1	=		((SD_COUNTER == 13 || SD_COUNTER == 14)|| 
						(SD_COUNTER == 24 || SD_COUNTER == 25) || 
						(SD_COUNTER == 35 || SD_COUNTER == 36)) ? 1'b0 : 1'b1;		//input | output
						
wire	SDO2	=		((SD_COUNTER == 13 || SD_COUNTER == 14)|| 
						(SD_COUNTER == 24 || SD_COUNTER == 25) || 
						(SD_COUNTER == 41 || SD_COUNTER == 42) ||
						(SD_COUNTER >= 44 && SD_COUNTER <= 52)) ? 1'b0 : 1'b1;		//input | output
wire	SDO = WR ? SDO1 : SDO2;
assign	I2C_SDAT = SDO ? I2C_BIT : 1'bz;



//------------------------------------
//Write ACK | Read ACK
reg		ACKW1, ACKW2, ACKW3;		//0 AVTIVE
reg 	ACKR1, ACKR2, ACKR3;		//0 ACTIVE
assign	ACK = WR ? (ACKW1 | ACKW2 | ACKW3) : (ACKR1 | ACKR2 | ACKR3);


//------------------------------------
//I2C COUNTER
always @(posedge iCLK or negedge iRST_N) 
begin
	if (!iRST_N) 
		SD_COUNTER <= 6'b0;
	else if(I2C_EN)
		begin
		if (GO == 0 || END == 1) 
			SD_COUNTER <= 6'b0;
		else if (SD_COUNTER < 6'd63) 
			SD_COUNTER <= SD_COUNTER + 6'd1;	
		end
	else
		SD_COUNTER <= SD_COUNTER;
end

//------------------------------------
//I2C Transfer
always @(posedge iCLK or negedge iRST_N) 
begin
    if(!iRST_N) 
		begin 
		SCLK <= 1;
		I2C_BIT <= 1; 
		ACKW1 <= 1; ACKW2 <= 1; ACKW3 <= 1; 
		ACKR1 <= 1; ACKR2 <= 1; ACKR3 <= 1;
		END <= 0;
		I2C_RDATA <= 8'h0;	
		end
	else if(I2C_EN)		//data change enable
		begin
		if(GO)
			begin
			if(WR)		//I2C Write: ID-Address + SUB-Address + W-Data
				begin
				case(SD_COUNTER)
				//IDLE
				6'd0 :	begin
						SCLK <= 1;
						I2C_BIT <= 1;
						ACKW1 <= 1; ACKW2 <= 1; ACKW3 <= 1;
						ACKR1 <= 1; ACKR2 <= 1; ACKR3 <= 1;
						END <= 0;
						end
				//Start
				6'd1 :	begin 
						SCLK <= 1;
						I2C_BIT <= 1;
						ACKW1 <= 1; ACKW2 <= 1; ACKW3 <= 1; 
						END <= 0;
						end
				6'd2  : I2C_BIT <= 0;		//I2C_SDAT = 0
				6'd3  : SCLK <= 0;			//I2C_SCLK = 0
				
				//SLAVE ADDR--ACK1
				6'd4  : I2C_BIT <= I2C_WDATA[23];	//Bit8
				6'd5  : I2C_BIT <= I2C_WDATA[22];	//Bit7
				6'd6  : I2C_BIT <= I2C_WDATA[21];	//Bit6
				6'd7  : I2C_BIT <= I2C_WDATA[20];	//Bit5
				6'd8  : I2C_BIT <= I2C_WDATA[19];	//Bit4
				6'd9  : I2C_BIT <= I2C_WDATA[18];	//Bit3
				6'd10 : I2C_BIT <= I2C_WDATA[17];	//Bit2
				6'd11 : I2C_BIT <= I2C_WDATA[16];	//Bit1
				6'd12 : I2C_BIT <= 0;				//High-Z, Input
				6'd13 : ACKW1 	<= I2C_SDAT;		//ACK1
				6'd14 : I2C_BIT <= 0;				//Delay
				
				//SUB ADDR--ACK2
				6'd15 : I2C_BIT <= I2C_WDATA[15];	//Bit8
				6'd16 : I2C_BIT <= I2C_WDATA[14];	//Bit7
				6'd17 : I2C_BIT <= I2C_WDATA[13];	//Bit6
				6'd18 : I2C_BIT <= I2C_WDATA[12];	//Bit5
				6'd19 : I2C_BIT <= I2C_WDATA[11];	//Bit4
				6'd20 : I2C_BIT <= I2C_WDATA[10];	//Bit3
				6'd21 : I2C_BIT <= I2C_WDATA[9];   //Bit2
				6'd22 : I2C_BIT <= I2C_WDATA[8];	//Bit1
				6'd23 : I2C_BIT <= 0;				//High-Z, Input
				6'd24 : ACKW2 	<= I2C_SDAT;		//ACK2
				6'd25 : I2C_BIT <= 0;				//Delay
				
				//Write DATA--ACK3
				6'd26 : I2C_BIT <= I2C_WDATA[7];	//Bit8 
				6'd27 : I2C_BIT <= I2C_WDATA[6];	//Bit7
				6'd28 : I2C_BIT <= I2C_WDATA[5];	//Bit6
				6'd29 : I2C_BIT <= I2C_WDATA[4];	//Bit5
				6'd30 : I2C_BIT <= I2C_WDATA[3];	//Bit4
				6'd31 : I2C_BIT <= I2C_WDATA[2];	//Bit3
				6'd32 : I2C_BIT <= I2C_WDATA[1];	//Bit2
				6'd33 : I2C_BIT <= I2C_WDATA[0];	//Bit1
				6'd34 : I2C_BIT <= 0;				//High-Z, Input
				6'd35 : ACKW3 	<= I2C_SDAT;		//ACK3
				6'd36 : I2C_BIT <= 0;				//Delay

				//Stop
				6'd37 : begin	SCLK <= 0; I2C_BIT <= 0; end
				6'd38 : SCLK <= 1;	
				6'd39 : begin I2C_BIT <= 1; END <= 1; end 
				default : begin I2C_BIT <= 1; SCLK <= 1; end
				endcase
				end
			else		//I2C Read: {ID-Address + SUB-Address} + {ID-Address + R-Data}
				begin
				case(SD_COUNTER)
				//IDLE
				6'd0 :	begin
						SCLK <= 1;
						I2C_BIT <= 1;
						ACKW1 <= 1; ACKW2 <= 1; ACKW3 <= 1;
						ACKR1 <= 1; ACKR2 <= 1; ACKR3 <= 1; 
						END <= 0;
						end
				//I2C Read1: {ID-Address + SUB-Address}
				//Start
				6'd1 :	begin 
						SCLK <= 1;
						I2C_BIT <= 1;
						ACKR1 <= 1; ACKR2 <= 1; ACKR3 <= 1; 
						END <= 0;
						end
				6'd2  : I2C_BIT <= 0;		//I2C_SDAT = 0
				6'd3  : SCLK <= 0;			//I2C_SCLK = 0
				
				//SLAVE ADDR--ACK1
				6'd4  : I2C_BIT <= I2C_WDATA[23];	//Bit8
				6'd5  : I2C_BIT <= I2C_WDATA[22];	//Bit7
				6'd6  : I2C_BIT <= I2C_WDATA[21];	//Bit6
				6'd7  : I2C_BIT <= I2C_WDATA[20];	//Bit5
				6'd8  : I2C_BIT <= I2C_WDATA[19];	//Bit4
				6'd9  : I2C_BIT <= I2C_WDATA[18];	//Bit3
				6'd10 : I2C_BIT <= I2C_WDATA[17];	//Bit2
				6'd11 : I2C_BIT <= I2C_WDATA[16];	//Bit1
				6'd12 : I2C_BIT <= 0;				//High-Z, Input
				6'd13 : ACKR1 	<= I2C_SDAT;		//ACK1
				6'd14 : I2C_BIT <= 0;				//Delay
				
				//SUB ADDR--ACK2
				6'd15 : I2C_BIT <= I2C_WDATA[15];	//Bit8
				6'd16 : I2C_BIT <= I2C_WDATA[14];	//Bit7
				6'd17 : I2C_BIT <= I2C_WDATA[13];	//Bit6
				6'd18 : I2C_BIT <= I2C_WDATA[12];	//Bit5
				6'd19 : I2C_BIT <= I2C_WDATA[11];	//Bit4
				6'd20 : I2C_BIT <= I2C_WDATA[10];	//Bit3
				6'd21 : I2C_BIT <= I2C_WDATA[9];    //Bit2
				6'd22 : I2C_BIT <= I2C_WDATA[8];	//Bit1
				6'd23 : I2C_BIT <= 0;				//High-Z, Input
				6'd24 : ACKR2 	<= I2C_SDAT;		//ACK2
				6'd25 : I2C_BIT <= 0;				//Delay

				//Stop
				6'd26 : begin	SCLK <= 0; I2C_BIT <= 0; end
				6'd27 : SCLK <= 1;	
				6'd28 : begin I2C_BIT <= 1; /*END <= 1;*/end 

				//I2C Read2: {ID-Address + R-Data}
				//Start
				6'd29 :	begin 
						SCLK <= 1;
						I2C_BIT <= 1;
						end
				6'd30 : I2C_BIT <= 0;		//I2C_SDAT = 0
				6'd31 : SCLK <= 0;			//I2C_SCLK = 0
				
				//SLAVE ADDR--ACK3
				6'd32 : I2C_BIT <= I2C_WDATA[23];	//Bit8
				6'd33 : I2C_BIT <= I2C_WDATA[22];	//Bit7
				6'd34 : I2C_BIT <= I2C_WDATA[21];	//Bit6
				6'd35 : I2C_BIT <= I2C_WDATA[20];	//Bit5
				6'd36 : I2C_BIT <= I2C_WDATA[19];	//Bit4
				6'd37 : I2C_BIT <= I2C_WDATA[18];	//Bit3
				6'd38 : I2C_BIT <= I2C_WDATA[17];	//Bit2
				6'd39 : I2C_BIT <= 1'b1;			//Bit1	Read Data Flag
				6'd40 : I2C_BIT <= 0;				//High-Z, Input
				6'd41 : ACKR3 	<= I2C_SDAT;		//ACK3
				6'd42 : I2C_BIT <= 0;				//Delay
				
				//Read DATA--ACK4
				6'd43 : I2C_BIT 	<= 0;			//Delay
				6'd44 : I2C_BIT 	<= 0;			//High-Z, Input
				6'd45 : I2C_RDATA[7] <= I2C_SDAT;	//Bit8	, Input
				6'd46 : I2C_RDATA[6] <= I2C_SDAT;	//Bit7	, Input 
				6'd47 : I2C_RDATA[5] <= I2C_SDAT;	//Bit6	, Input 
				6'd48 : I2C_RDATA[4] <= I2C_SDAT;	//Bit5	, Input 
				6'd49 : I2C_RDATA[3] <= I2C_SDAT;	//Bit4	, Input 
				6'd50 : I2C_RDATA[2] <= I2C_SDAT;	//Bit3	, Input 
				6'd51 : I2C_RDATA[1] <= I2C_SDAT;	//Bit2	, Input 
				6'd52 : I2C_RDATA[0] <= I2C_SDAT;	//Bit1	, Input 	
				6'd53 : I2C_BIT 	<= 1;			//Output //ACK4 NACK
				6'd54 : I2C_BIT 	<= 0;			//Delay
				
				//Stop
				6'd55 : begin	SCLK <= 0; I2C_BIT <= 0; end
				6'd56 : SCLK <= 1;	
				6'd57 : begin I2C_BIT <= 1; END <= 1; end 
				default : begin I2C_BIT <= 1; SCLK <= 1; end
				endcase
				end
			end
		else
			begin
			SCLK <= 1;
			I2C_BIT <= 1; 
			ACKW1 <= 1; ACKW2 <= 1; ACKW3 <= 1; 
			ACKR1 <= 1; ACKR2 <= 1; ACKR3 <= 1;
			END <= 0;
			I2C_RDATA <= I2C_RDATA;
			end
		end
end
		
endmodule
