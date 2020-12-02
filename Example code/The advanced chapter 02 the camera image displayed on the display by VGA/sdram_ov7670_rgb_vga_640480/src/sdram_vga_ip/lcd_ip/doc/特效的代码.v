/*******所有代码仅在lcd_display改写即可******/
//LCD VGA接口都一样
module lcd_display
(
	input			clk,
	input			rst_n,
	
	input	[8:0]	x_pos,
	input	[8:0]	y_pos,
	output	[15:0]	lcd_data
);

//定义颜色变量RGB--5|6|5
parameter RED    	=	16'hF800;  /*11111,000000,00000	F800 红*/
parameter GREEN     =	16'h07E0;  /*00000,111111,00000	07E0 绿*/
parameter BLUE      =	16'h001F;  /*00000,000000,11111	001F 蓝*/
parameter WHITE     =	16'hFFFF;  /*11111,111111,11111	FFFF 白*/
parameter BLACK     =	16'h0000;  /*00000,000000,00000	0000 黑*/
parameter YELLOW    =	16'hFFE0;  /*11111,111111,00000	FFE0 黄*/
parameter CYAN      =	16'hF81F;  /*11111,000000,11111	F81F 青*/
parameter ROYAL     =	16'h07FF;  /*00000,111111,11111	07FF 品*/ 
...
...
endmodule

//-------------------------------------------
//<1>竖彩条显示
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_data <= 16'b0;
	else
		begin
		if		(x_pos == 9'd0)		lcd_data <= RED;
		else if	(x_pos == 9'd60)	lcd_data <= GREEN;
		else if	(x_pos == 9'd120)	lcd_data <= BLUE;
		else if	(x_pos == 9'd180)	lcd_data <= WHITE;
		else if	(x_pos == 9'd240)	lcd_data <= BLACK;
		else if	(x_pos == 9'd300)	lcd_data <= YELLOW;
		else if	(x_pos == 9'd360)	lcd_data <= CYAN;
		else if	(x_pos == 9'd420)	lcd_data <= ROYAL;
		end
end

//-------------------------------------------
//<2>横彩条显示
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_data <= 16'b0;
	else
		begin
		if		(y_pos == 9'd0)		lcd_data <= RED;
		else if	(y_pos == 9'd34)	lcd_data <= GREEN;
		else if	(y_pos == 9'd68)	lcd_data <= BLUE;
		else if	(y_pos == 9'd102)	lcd_data <= WHITE;
		else if	(y_pos == 9'd136)	lcd_data <= BLACK;
		else if	(y_pos == 9'd170)	lcd_data <= YELLOW;
		else if	(y_pos == 9'd204)	lcd_data <= CYAN;
		else if	(y_pos == 9'd238)	lcd_data <= ROYAL;
		end
end

//-------------------------------------------
//<3>棋盘显示
reg	[15:0]	lcd_datax,lcd_datay;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_datax <= 16'b0;
	else
		begin
		if		(x_pos == 9'd0)		lcd_datax <= RED;
		else if	(x_pos == 9'd60)	lcd_datax <= GREEN;
		else if	(x_pos == 9'd120)	lcd_datax <= BLUE;
		else if	(x_pos == 9'd180)	lcd_datax <= WHITE;
		else if	(x_pos == 9'd240)	lcd_datax <= BLACK;
		else if	(x_pos == 9'd300)	lcd_datax <= YELLOW;
		else if	(x_pos == 9'd360)	lcd_datax <= CYAN;
		else if	(x_pos == 9'd420)	lcd_datax <= ROYAL;
		end
end

always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_datay <= 16'b0;
	else
		begin
		if		(y_pos == 9'd0)		lcd_datay <= RED;
		else if	(y_pos == 9'd34)	lcd_datay <= GREEN;
		else if	(y_pos == 9'd68)	lcd_datay <= BLUE;
		else if	(y_pos == 9'd102)	lcd_datay <= WHITE;
		else if	(y_pos == 9'd136)	lcd_datay <= BLACK;
		else if	(y_pos == 9'd170)	lcd_datay <= YELLOW;
		else if	(y_pos == 9'd204)	lcd_datay <= CYAN;
		else if	(y_pos == 9'd238)	lcd_datay <= ROYAL;
		end
end

assign lcd_data = lcd_datax^lcd_datay;	//异或实现棋盘

//-------------------------------------------
//<4>花纹显示
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_data <= 16'b0;
	else
		lcd_data <= x_pos * y_pos;	//占资源
end

//-------------------------------------------
//<5>RGB 三色渐变色带显示
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_data <= 16'b0;
	else
		begin
		if		(y_pos >= 9'd0 && y_pos < 9'd91)	lcd_data <= {x_pos[8:4],11'b0};
		else if	(y_pos >= 9'd91 && y_pos < 9'd182)	lcd_data <= {5'b0,x_pos[8:3],5'b0};
		else if	(y_pos >= 9'd182 && y_pos < 9'd272)	lcd_data <= {11'b0,x_pos[8:4]};
		end
end

//------------------------------------------
//<6>ColorTest 显示（见vga_ctrl.c）
	/***************ColorTest***************
	 * 			第一列	第二列	第三列	第四列
	 * 	第一行	X00		X01		X10		X11
	 * 	第二行	0X0		0X1		1X0		1X1
	 * 	第三行	00X		01X		10X		11X
	 * ***************0~~MAX变化*************/	
	`define		RGB_X00		16'h0000	//G、B不变
	`define		RGB_X01		16'h001f
	`define		RGB_X10		16'h07e0
	`define		RGB_X11		16'h07ff	
	`define		RGB_0X0		16'h0000	//R、B不变
	`define		RGB_0X1		16'h001f
	`define		RGB_1X0		16'hf800
	`define		RGB_1X1		16'hf81f	
	`define		RGB_00X		16'h0000	//R、G不变
	`define		RGB_01X		16'h07e0
	`define		RGB_10X		16'hf800
	`define		RGB_11X		16'hffe0
reg	[6:0]cnt_color;	//色带递增数据
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		lcd_data <= 16'b0;
		cnt_color <= 0;
		end
	else
		begin
		//色变增量
		if(x_pos == 9'd0 || x_pos == 9'd479 || x_pos == 9'd119 || x_pos == 9'd239 || x_pos == 9'd359)	//Delay 1 pxiel
			cnt_color <= 0;
		else
			cnt_color <= cnt_color + 1'b1;
		//色带函数
		if	(y_pos >= 9'd0 && y_pos < 9'd91)			//第一行(第一、二、三、四列)
			begin
			if		(x_pos >= 9'd0 && x_pos < 9'd120)	lcd_data <= {cnt_color[6:2],11'b0} | `RGB_X00;
			else if	(x_pos >= 9'd120 && x_pos < 9'd240)	lcd_data <= {cnt_color[6:2],11'b0} | `RGB_X01;
			else if	(x_pos >= 9'd240 && x_pos < 9'd360)	lcd_data <= {cnt_color[6:2],11'b0} | `RGB_X10;
			else if	(x_pos >= 9'd360 && x_pos < 9'd480)	lcd_data <= {cnt_color[6:2],11'b0} | `RGB_X11;
			end
		else if	(y_pos >= 9'd91 && y_pos < 9'd182)	//第二行(第一、二、三、四列)
			begin
			if		(x_pos >= 9'd0 && x_pos < 9'd120)	lcd_data <= {5'b0,cnt_color[6:1],5'b0} | `RGB_0X0;
			else if	(x_pos >= 9'd120 && x_pos < 9'd240)	lcd_data <= {5'b0,cnt_color[6:1],5'b0} | `RGB_0X1;
			else if	(x_pos >= 9'd240 && x_pos < 9'd360)	lcd_data <= {5'b0,cnt_color[6:1],5'b0} | `RGB_1X0;
			else if	(x_pos >= 9'd360 && x_pos < 9'd480)	lcd_data <= {5'b0,cnt_color[6:1],5'b0} | `RGB_1X1;
			end
		else if	(y_pos >= 9'd182 && y_pos < 9'd272)	//第三行(第一、二、三、四列)
			begin
			if		(x_pos >= 9'd0 && x_pos < 9'd120)	lcd_data <= {11'b0,cnt_color[6:2]} | `RGB_00X;
			else if	(x_pos >= 9'd120 && x_pos < 9'd240)	lcd_data <= {11'b0,cnt_color[6:2]} | `RGB_01X;
			else if	(x_pos >= 9'd240 && x_pos < 9'd360)	lcd_data <= {11'b0,cnt_color[6:2]} | `RGB_10X;
			else if	(x_pos >= 9'd360 && x_pos < 9'd480)	lcd_data <= {11'b0,cnt_color[6:2]} | `RGB_11X;
			end
		end
end


//--------------------------------------------
//<7>RGB 三色快动态显示
reg	[13:0]	cnt;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt <= 0;
	else
		cnt <= cnt + 1'b1;
end
wire	move_flag = (cnt == 14'h2fff) ? 1'b1 : 1'b0;	

//RGB 方块滚动函数
reg	[8:0]	left_pos_r,left_pos_g,left_pos_b;
reg	[8:0]	up_pos_r,up_pos_g,up_pos_b;
reg	[1:0]	block_pos_r,block_pos_g,block_pos_b;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		left_pos_r <= 9'd0;	up_pos_r <= 9'd0;	block_pos_r <= 2'b00;
		left_pos_g <= 9'd32;up_pos_g <= 9'd32;	block_pos_g <= 2'b00;
		left_pos_b <= 9'd64;up_pos_b <= 9'd64;	block_pos_b <= 2'b00;
		end
	else if(move_flag == 1'b1)
		begin
		case(block_pos_r)	//red block moving track
		2'b00 :	if(left_pos_r < 9'd448)	left_pos_r <= left_pos_r + 1'b1;
				else					block_pos_r <= 2'b01;
		2'b01 :	if(up_pos_r < 9'd240)	up_pos_r <= up_pos_r + 1'b1;
				else					block_pos_r <= 2'b11;				
		2'b11 :	if(left_pos_r > 9'd0)	left_pos_r <= left_pos_r - 1'b1;
				else					block_pos_r <= 2'b10;
		2'b10 :	if(up_pos_r > 9'd0)		up_pos_r <= up_pos_r - 1'b1;
				else					block_pos_r <= 2'b00;
		endcase
		case(block_pos_g)	//green block moving track
		2'b00 :	if(left_pos_g < 9'd416)	left_pos_g <= left_pos_g + 1'b1;
				else					block_pos_g <= 2'b01;
		2'b01 :	if(up_pos_g < 9'd208)	up_pos_g <= up_pos_g + 1'b1;
				else					block_pos_g <= 2'b11;				
		2'b11 :	if(left_pos_g > 9'd32)	left_pos_g <= left_pos_g - 1'b1;
				else					block_pos_g <= 2'b10;
		2'b10 :	if(up_pos_g > 9'd32)	up_pos_g <= up_pos_g - 1'b1;
				else					block_pos_g <= 2'b00;
		endcase
		case(block_pos_b)	//blue block moving track
		2'b00 :	if(left_pos_b < 9'd384)	left_pos_b <= left_pos_b + 1'b1;
				else					block_pos_b <= 2'b01;
		2'b01 :	if(up_pos_b < 9'd176)	up_pos_b <= up_pos_b + 1'b1;
				else					block_pos_b <= 2'b11;				
		2'b11 :	if(left_pos_b > 9'd64)	left_pos_b <= left_pos_b - 1'b1;
				else					block_pos_b <= 2'b10;
		2'b10 :	if(up_pos_b > 9'd64)	up_pos_b <= up_pos_b - 1'b1;
				else					block_pos_b <= 2'b00;
		endcase
		end
end

//滚动RGB 32*32的3个方块
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		lcd_data <= 0;
	else
		begin
		if((x_pos >= left_pos_r && x_pos < left_pos_r + 6'd32) && (y_pos >= up_pos_r && y_pos < up_pos_r + 6'd32))
			lcd_data <= RED;
		else if((x_pos >= left_pos_g && x_pos < left_pos_g + 6'd32) && (y_pos >= up_pos_g && y_pos < up_pos_g + 6'd32))
			lcd_data <= GREEN;
		else if((x_pos >= left_pos_b && x_pos < left_pos_b + 6'd32) && (y_pos >= up_pos_b && y_pos < up_pos_b + 6'd32))
			lcd_data <= BLUE;
		else 
			lcd_data <= BLACK;
		end
end
end

//--------------------------------------------
//<8>显示圆形


//--------------------------------------------
//<9>显示256*256悟字（16*16字模，最笨的方法）
parameter	WU_DATA0	=	16'h0E00;
parameter	WU_DATA1	=	16'h0000;
parameter	WU_DATA2	=	16'hFFFF;
parameter	WU_DATA3	=	16'h1000;
parameter	WU_DATA4	=	16'h0900;
parameter	WU_DATA5	=	16'h4100;
parameter	WU_DATA6	=	16'h497E;
parameter	WU_DATA7	=	16'h4F42;
parameter	WU_DATA8	=	16'h7942;
parameter	WU_DATA9	=	16'h4942;
parameter	WU_DATA10	=	16'h4942;
parameter	WU_DATA11	=	16'h4F42;
parameter	WU_DATA12	=	16'h417E;
parameter	WU_DATA13	=	16'h4100;
parameter	WU_DATA14	=	16'h0100;
parameter	WU_DATA15	=	16'h0000;
reg	pixel_data;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		pixel_data <= 0;
	else
		begin
		//if(x_pos < 9'd256 && y_pos < 9'd256) //特定区域显示
		case(x_pos[7:4])
		4'h0 : pixel_data <=	WU_DATA0[4'd15 - y_pos[7:4]];
		4'h1 : pixel_data <=	WU_DATA1[4'd15 - y_pos[7:4]];
		4'h2 : pixel_data <=	WU_DATA2[4'd15 - y_pos[7:4]];
		4'h3 : pixel_data <=	WU_DATA3[4'd15 - y_pos[7:4]];
		4'h4 : pixel_data <=	WU_DATA4[4'd15 - y_pos[7:4]];
		4'h5 : pixel_data <=	WU_DATA5[4'd15 - y_pos[7:4]];
		4'h6 : pixel_data <=	WU_DATA6[4'd15 - y_pos[7:4]];
		4'h7 : pixel_data <=	WU_DATA7[4'd15 - y_pos[7:4]];
		4'h8 : pixel_data <=	WU_DATA8[4'd15 - y_pos[7:4]];
		4'h9 : pixel_data <=	WU_DATA9[4'd15 - y_pos[7:4]];
		4'ha : pixel_data <=	WU_DATA10[4'd15 - y_pos[7:4]];
		4'hb : pixel_data <=	WU_DATA11[4'd15 - y_pos[7:4]];
		4'hc : pixel_data <=	WU_DATA12[4'd15 - y_pos[7:4]];
		4'hd : pixel_data <=	WU_DATA13[4'd15 - y_pos[7:4]];
		4'he : pixel_data <=	WU_DATA14[4'd15 - y_pos[7:4]];
		4'hf : pixel_data <=	WU_DATA15[4'd15 - y_pos[7:4]];
		endcase
		end
end
assign lcd_data = (pixel_data == 1'b1) ? BLUE : WHITE;

//--------------------------------------------
//<10>显示英文(用CPLD实现不可能的任务)
//显示“Crazy Bingo” 
parameter   CHAR_C  =   128'h03E00C1810041004100410081C100000;      /*"C"*/
parameter   CHAR_r  =   128'h0104010401FC00840104010001800000;      /*"r"*/
parameter   CHAR_a  =   128'h00000098012401440144014400FC0004;      /*"a"*/
parameter   CHAR_z  =   128'h00000184010C013401440184010C0000;      /*"z"*/
parameter   CHAR_y  =   128'h010101810171000E0018016001800100;      /*"y"*/
parameter   CHAR_B  =   128'h10041FFC1104110411040E8800700000;      /*"B"*/
parameter   CHAR_i  =   128'h00000104190419FC0004000400000000;      /*"i"*/
parameter   CHAR_n  =   128'h010401FC008401000100010400FC0004;      /*"n"*/
parameter   CHAR_g  =   128'h000000D601290129012901C901060000;      /*"g"*/
parameter   CHAR_o  =   128'h000000F8010401040104010400F80000;      /*"o"*/
parameter   CHAR_kg	=   128'h00000000000000000000000000000000;      /*" "*/

//固定坐标显示数据的字模    
reg [128:0] char_data;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        char_data <= 0;
    else
        begin
        if(y_pos >= 9'd64 && y_pos < 9'd128)    //提前一个pixel确保时序
            case(x_pos)                         //显示英文"Crazy Bingo"
            9'd63   :   char_data <= CHAR_C;
            9'd95   :   char_data <= CHAR_r;
            9'd127  :   char_data <= CHAR_a;
            9'd159  :   char_data <= CHAR_z;
            9'd191  :   char_data <= CHAR_y;
            9'd223  :   char_data <= CHAR_kg;
            9'd255  :   char_data <= CHAR_B;
            9'd287  :   char_data <= CHAR_i;
            9'd319  :   char_data <= CHAR_n;
            9'd351  :   char_data <= CHAR_g;
            9'd383  :   char_data <= CHAR_o;
            9'd415	:	char_data <= 0;
            default ;
            endcase
        else
            char_data <= 0;
        end
end

//提取ASCII的每一列编码
wire    [15:0]  char_0	=	char_data[127:112];
wire    [15:0]  char_1	=	char_data[111:96];
wire    [15:0]  char_2	=	char_data[95:80];
wire    [15:0]  char_3	=	char_data[79:64];
wire    [15:0]  char_4	=	char_data[63:48];
wire    [15:0]  char_5	=	char_data[47:32];
wire    [15:0]  char_6	=	char_data[31:16];
wire    [15:0]  char_7	=	char_data[15:0];

//在固定位置显示的像素点
reg	pixel_data;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        pixel_data <= 0;
    else
        case(x_pos[4:2])
        3'd0    :   pixel_data <= char_0[4'd15 - y_pos[5:2]];
        3'd1    :   pixel_data <= char_1[4'd15 - y_pos[5:2]];
        3'd2    :   pixel_data <= char_2[4'd15 - y_pos[5:2]];
        3'd3    :   pixel_data <= char_3[4'd15 - y_pos[5:2]];
        3'd4    :   pixel_data <= char_4[4'd15 - y_pos[5:2]];
        3'd5    :   pixel_data <= char_5[4'd15 - y_pos[5:2]];
        3'd6    :   pixel_data <= char_6[4'd15 - y_pos[5:2]];
        3'd7    :   pixel_data <= char_7[4'd15 - y_pos[5:2]];
        endcase
end
assign lcd_data = (pixel_data == 1'b1) ? BLUE : YELLOW;

//--------------------------------------------
//<11>显示英文(用CPLD实现不可能的任务)
//显示“跟着彬哥走”
parameter   HZ_GEN 	=   256'h001019F0241027E02520392000003FFC4B084A90464078A00130001000100000;  /*"跟"*/
parameter   HZ_ZHE 	=   256'h0000010801100120954055FE16541AD46AD4AA842AFE02000200020000000000;  /*"着"*/
parameter   HZ_BIN 	=   256'h0040048005007FF8090004400480FFF809020882044408881110662000C00000;  /*"彬"*/
parameter   HZ_GE  	=   256'h010001000100010059705550555059604104FFFE820082000200020002000000;  /*"哥"*/
parameter   HZ_ZOU 	=   256'h000401080110012009C009200910FFF01288128C128402040004000400040000;  /*"走"*/
parameter	HZ_th	=	256'h00000000000000000000000000003F983F980000000000000000000000000000;	/*"！"*/

//固定坐标显示数据的字模    
reg [255:0] hz_data;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        hz_data <= 0;
    else
        begin//提前一个pixel确保时序,“跟着彬哥走”
        if(y_pos >= 9'd64 && y_pos < 9'd128)    
            case(x_pos) 
            9'd63   :   hz_data <= HZ_GEN;
            9'd127  :   hz_data <= HZ_ZHE;
            9'd191  :   hz_data <= HZ_BIN;
            9'd255  :   hz_data <= HZ_GE;
            9'd319  :   hz_data <= HZ_ZOU;
            9'd383  :   hz_data <= HZ_th;
            9'd447	:	hz_data	<= 0;
            default ;
            endcase
        else
            hz_data <= 0;
        end
end

//提取汉字的每一列编码
wire    [15:0]  hz_0	=	hz_data[255:240];
wire    [15:0]  hz_1	=	hz_data[239:224];
wire    [15:0]  hz_2	=	hz_data[223:208];
wire    [15:0]  hz_3	=	hz_data[207:192];
wire    [15:0]  hz_4	=	hz_data[191:176];
wire    [15:0]  hz_5	=	hz_data[175:160];
wire    [15:0]  hz_6	=	hz_data[159:144];
wire    [15:0]  hz_7	=	hz_data[143:128];
wire    [15:0]  hz_8	=	hz_data[127:112];
wire    [15:0]  hz_9	=	hz_data[111:96];
wire    [15:0]  hz_a	=	hz_data[95:80];
wire    [15:0]  hz_b	=	hz_data[79:64];
wire    [15:0]  hz_c	=	hz_data[63:48];
wire    [15:0]  hz_d	=	hz_data[47:32];
wire    [15:0]  hz_e	=	hz_data[31:16];
wire    [15:0]  hz_f	=	hz_data[15:0];

//在固定位置显示的像素点
reg	pixel_data;
always@(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        pixel_data <= 0;
    else
        case(x_pos[5:2])
        4'h0    :   pixel_data <= hz_0[4'd15 - y_pos[5:2]];
        4'h1    :   pixel_data <= hz_1[4'd15 - y_pos[5:2]];
        4'h2    :   pixel_data <= hz_2[4'd15 - y_pos[5:2]];
        4'h3    :   pixel_data <= hz_3[4'd15 - y_pos[5:2]];
        4'h4    :   pixel_data <= hz_4[4'd15 - y_pos[5:2]];
        4'h5    :   pixel_data <= hz_5[4'd15 - y_pos[5:2]];
        4'h6    :   pixel_data <= hz_6[4'd15 - y_pos[5:2]];
        4'h7    :   pixel_data <= hz_7[4'd15 - y_pos[5:2]];
        4'h8    :   pixel_data <= hz_8[4'd15 - y_pos[5:2]];
        4'h9    :   pixel_data <= hz_9[4'd15 - y_pos[5:2]];
        4'ha    :   pixel_data <= hz_a[4'd15 - y_pos[5:2]];
        4'hb    :   pixel_data <= hz_b[4'd15 - y_pos[5:2]];
        4'hc    :   pixel_data <= hz_c[4'd15 - y_pos[5:2]];
        4'hd    :   pixel_data <= hz_d[4'd15 - y_pos[5:2]];
        4'he    :   pixel_data <= hz_e[4'd15 - y_pos[5:2]];
        4'hf    :   pixel_data <= hz_f[4'd15 - y_pos[5:2]];
        endcase
end
assign lcd_data = (pixel_data == 1'b1) ? BLUE : YELLOW;




