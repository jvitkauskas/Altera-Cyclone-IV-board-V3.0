/*-------------------------------------------------------------------------
This confidential and proprietary software may be only used as authorized
by a licensing agreement from CrazyBingo.
(C) COPYRIGHT 2012 CrazyBingo. ALL RIGHTS RESERVED
Filename			:		clk_generator.v
Author				:		CrazyBingo
Data				:		2012-11-27
Version				:		1.0
Description			:		clk for uart bps.
Modification History	:
Data			By			Version			Change Description
===========================================================================
12/11/27		CrazyBingo	1.0				Original
--------------------------------------------------------------------------*/
/***********************************
	fc	=	50*10^6
	fo	=	fc*N/(2^32)
	N	=	fo*(2^32)/fc
		=	fo*(2^32)/(50*10^6)
************************************/
`timescale 1 ns / 1 ns
module clk_generator
(
	input	clk,
	input	rst_n,
	output	clk_bps,
	output	clk_smp
);

//------------------------------------------
/************clk_smp	= 16*clk_bps************
Freq_Word1	<=	32'd25770;		Freq_Word1	<=	32'd412317;		//300	bps
Freq_Word1	<=	32'd51540;		Freq_Word2	<=	32'd824634;		//600	bps
Freq_Word1	<=	32'd103079;		Freq_Word2	<=	32'd1649267;	//1200	bps
Freq_Word1	<=	32'd206158;		Freq_Word2	<=	32'd3298535;	//2400	bps
Freq_Word1	<=	32'd412317;		Freq_Word2	<=	32'd6597070;	//4800	bps
Freq_Word1	<=	32'd824634;		Freq_Word2	<=	32'd13194140;	//9600	bps
Freq_Word1	<=	32'd1649267;	Freq_Word2	<=	32'd26388279;	//19200	bps
Freq_Word1	<=	32'd3298535;	Freq_Word2	<=	32'd52776558;	//38400	bps
Freq_Word1	<=	32'd3693672;	Freq_Word2	<=	32'd59098750;	//43000	bps
Freq_Word1	<=	32'd4810363;	Freq_Word2	<=	32'd76965814;	//56000	bps
Freq_Word1	<=	32'd4947802;	Freq_Word2	<=	32'd79164837;	//57600	bps
Freq_Word1	<=	32'd9895605;	Freq_Word2	<=	32'd158329674;	//115200bps
*****************************************************/
//only want to generate beautiful clk for bsp and sample
reg	[31:0]	bps_cnt1;
reg	[31:0]	bps_cnt2;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		bps_cnt1 <= 0;
		bps_cnt2 <= 0;
		end
	else
		begin
		//bps_cnt1 <= bps_cnt1 + 32'h7FFF_FFFF;	//test
		bps_cnt1 <= bps_cnt1 + 32'd9895605;		//Bps=115200bps
		//bps_cnt1 <= bps_cnt1 + 32'd25770;		//Bps=300bps
		bps_cnt2 <= bps_cnt2 + 32'd158329674;	//Bps=115200bps*16
		end
end

//------------------------------------------
//clk_bps sync bps generater
reg	clk_bps_r0,clk_bps_r1,clk_bps_r2;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		clk_bps_r0 <= 0;
		clk_bps_r1 <= 0;
		clk_bps_r2 <= 0;
		end
	else
		begin
		if(bps_cnt1 < 32'h7FFF_FFFF)
			clk_bps_r0 <= 0;
		else
			clk_bps_r0 <= 1;
		clk_bps_r1 <= clk_bps_r0;
		clk_bps_r2 <= clk_bps_r1;
		end
end
assign	clk_bps = ~clk_bps_r2 & clk_bps_r1;

//------------------------------------------
//clk_smp sync receive bps generator
reg	clk_smp_r0,clk_smp_r1,clk_smp_r2;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		clk_smp_r0 <= 0;
		clk_smp_r1 <= 0;
		clk_smp_r2 <= 0;
		end
	else
		begin
		if(bps_cnt2 < 32'h7FFF_FFFF)
			clk_smp_r0 <= 0;
		else
			clk_smp_r0 <= 1;
		clk_smp_r1 <= clk_smp_r0;
		clk_smp_r2 <= clk_smp_r1;
		end
end
assign	clk_smp = ~clk_smp_r2 & clk_smp_r1;

endmodule
