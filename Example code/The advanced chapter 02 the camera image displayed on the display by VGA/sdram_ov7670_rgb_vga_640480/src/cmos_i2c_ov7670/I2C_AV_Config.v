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
module I2C_AV_Config 
(
	//Global clock
	input				iCLK,		//25MHz
	input				iRST_N,		//Global Reset
	
	//I2C Side
	output				I2C_SCLK,	//I2C CLOCK
	inout				I2C_SDAT,	//I2C DATA
	
	output	reg			Config_Done,//Config Done
	output	reg	[7:0]	LUT_INDEX,	//LUT Index
	output		[7:0]	I2C_RDATA	//I2C Read Data
);

//	LUT Data Number
parameter	LUT_SIZE	=	168;


/////////////////////	I2C Control Clock	////////////////////////
//	Clock Setting
parameter	CLK_Freq	=	25_000000;	//25 MHz
parameter	I2C_Freq	=	10_000;		//10 KHz
reg	[15:0]	mI2C_CLK_DIV;				//CLK DIV
reg			mI2C_CTRL_CLK;				//I2C Control Clock
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
		begin
		mI2C_CLK_DIV	<=	0;
		mI2C_CTRL_CLK	<=	0;
		end
	else
		begin
		 if( mI2C_CLK_DIV	< (CLK_Freq/I2C_Freq)/2)
			 mI2C_CLK_DIV	<=	mI2C_CLK_DIV + 1'd1;
		 else
			 begin
			 mI2C_CLK_DIV	<=	0;
			mI2C_CTRL_CLK	<=	~mI2C_CTRL_CLK;
			end
		end
end


//-------------------------------------
reg	i2c_en_r0, i2c_en_r1;
always@(posedge iCLK or negedge iRST_N)
begin
	if(!iRST_N)
		begin
		i2c_en_r0 <= 0;
		i2c_en_r1 <= 0;
		end
	else
		begin
		i2c_en_r0 <= mI2C_CTRL_CLK;
		i2c_en_r1 <= i2c_en_r0;
		end
end
wire	i2c_negclk = (i2c_en_r1 & ~i2c_en_r0) ? 1'b1 : 1'b0;		//negedge i2c_sclk transfer data

//////////////////////	Config Control	////////////////////////////
// Internal Registers/Wires
//reg	[23:0]	mI2C_DATA;		//I2C Data
wire		mI2C_END;		//I2C Transfer End
wire		mI2C_ACK;		//I2C Transfer ACK
//reg	[7:0]	LUT_INDEX;		//LUT Index
reg	[1:0]	mSetup_ST;		//State Machine
reg			mI2C_GO;		//I2C Transfer Start
reg			mI2C_WR;		//I2C Write / Read Data
always@(posedge iCLK or negedge iRST_N)		//25MHz	mI2C_CTRL_CLK
begin
	if(!iRST_N)
		begin
		Config_Done <= 0;
		LUT_INDEX	<=	0;
		mSetup_ST	<=	0;
		mI2C_GO		<=	0;
		mI2C_WR     <=	0;	
		end
	else if(i2c_negclk)
		begin
		if(LUT_INDEX < LUT_SIZE)
			begin
			Config_Done <= 0;
			case(mSetup_ST)
			0:	begin						//IDLE State
				if(~mI2C_END)				//END Transfer
					mSetup_ST	<=	1;		
				else						//Transfe ing
					mSetup_ST	<=	0;				
				mI2C_GO		<=	1;			//Go Transfer
				if(LUT_INDEX < 8'd2)	
					mI2C_WR <= 0;			//Read Data
				else
					mI2C_WR <= 1;			//Write Data
				end
			1:	
				begin						//Write data
				if(mI2C_END)
					begin
					mI2C_WR     <=	0;
					mI2C_GO		<=	0;
					if(~mI2C_ACK)			//ACK ACTIVE
						mSetup_ST	<=	2;	//INDEX ++
					else
						mSetup_ST	<=	0;	//Repeat Transfer						
					end
				end
			2:	begin						//Address Add
				LUT_INDEX	<=	LUT_INDEX + 8'd1;
				mSetup_ST	<=	0;
				mI2C_GO		<=	0;
				mI2C_WR     <=	0;
				end
			endcase
			end
		else
			begin
			Config_Done <= 1'b1;
			LUT_INDEX 	<= LUT_INDEX;
			mSetup_ST	<=	0;
			mI2C_GO		<=	0;
			mI2C_WR     <=	0;
			end
	end
end


////////////////////////////////////////////////////////////////////
wire	[15:0]	LUT_DATA;		//{ID-Address£¬SUB-Address£¬Data}
I2C_OV7670_RGB565_Config	u_I2C_OV7670_RGB565_Config
//I2C_OV7670_YUV422_Config	u_I2C_OV7670_YUV422_Config
(
	.LUT_INDEX		(LUT_INDEX),
	.LUT_DATA		(LUT_DATA)
);

////////////////////////////////////////////////////////////////////
I2C_Controller 	u_I2C_Controller	
(	
	.iCLK			(iCLK),
	.iRST_N			(iRST_N),
							
	.I2C_CLK		(mI2C_CTRL_CLK),	//	Controller Work Clock
	.I2C_EN			(i2c_negclk),		//	I2C DATA ENABLE
	.I2C_WDATA		({8'h42, LUT_DATA}),//	DATA:[SLAVE_ADDR,SUB_ADDR,DATA]
	.I2C_SCLK		(I2C_SCLK),			//	I2C CLOCK
	.I2C_SDAT		(I2C_SDAT),			//	I2C DATA
	
	.GO				(mI2C_GO),			//	Go Transfer
	.WR				(mI2C_WR),      	//	END transfor
	.ACK			(mI2C_ACK),			//	ACK
	.END			(mI2C_END),			//	END transfor 
	.I2C_RDATA		(I2C_RDATA)			//	ID
);		
////////////////////////////////////////////////////////////////////

endmodule

