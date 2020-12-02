/*学习VGA显示原理,显示彩条信号。
连接开发板的VGA接口和电脑显示器，
拨码开关1，2同时不上拨，  则显示8色方格（棋盘格）
拨码开关1抬上去，2不上拨，则显示变换方向的8色方格（棋盘格）
拨码开关1，2同时拨上ON，则显示8色横条
拨码开关1不拨，2拨上ON，则显示8色竖条
*/
module VGA(
   clock,
   switch,
   disp_RGB,
   hsync,
   vsync
);
input  clock;     //系统输入时钟 50MHz
input  [1:0]switch;
output [2:0]disp_RGB;    //VGA数据输出
output  hsync;     //VGA行同步信号
output  vsync;     //VGA场同步信号

reg [9:0] hcount;     //VGA行扫描计数器
reg [9:0]   vcount;     //VGA场扫描计数器
reg [2:0]   data;
reg [2:0]  h_dat;
reg [2:0]   v_dat;

//reg [9:0]   timer;

reg   flag;
wire  hcount_ov;
wire  vcount_ov;
wire  dat_act;
wire  hsync;
wire   vsync;
reg  vga_clk;
//VGA行、场扫描时序参数表
parameter hsync_end   = 10'd95,
   hdat_begin  = 10'd143,
   hdat_end  = 10'd783,
   hpixel_end  = 10'd799,
   vsync_end  = 10'd1,
   vdat_begin  = 10'd34,
   vdat_end  = 10'd514,
   vline_end  = 10'd524;


always @(posedge clock)
begin
 vga_clk = ~vga_clk;
end

//************************VGA驱动部分******************************* 
//行扫描     
always @(posedge vga_clk)
begin
 if (hcount_ov)
  hcount <= 10'd0;
 else
  hcount <= hcount + 10'd1;
end
assign hcount_ov = (hcount == hpixel_end);
//场扫描
always @(posedge vga_clk)
begin
 if (hcount_ov)
 begin
  if (vcount_ov)
   vcount <= 10'd0;
  else
   vcount <= vcount + 10'd1;
 end
end
assign  vcount_ov = (vcount == vline_end);
//数据、同步信号输
assign dat_act =    ((hcount >= hdat_begin) && (hcount < hdat_end))
     && ((vcount >= vdat_begin) && (vcount < vdat_end));
assign hsync = (hcount > hsync_end);
assign vsync = (vcount > vsync_end);
assign disp_RGB = (dat_act) ?  data : 3'h00;       

//************************显示数据处理部分******************************* 
//图片显示延时计数器
/*always @(posedge vga_clk)
begin
 flag <= vcount_ov;
 if(vcount_ov && ~flag)
  timer <= timer + 1'b1;
end
*/

always @(posedge vga_clk)
begin
 case(switch[1:0])
  2'd0: data <= h_dat;      //选择横彩条
  2'd1: data <= v_dat;      //选择竖彩条
  2'd2: data <= (v_dat ^ h_dat); //产生棋盘格
  2'd3: data <= (v_dat ~^ h_dat); //产生棋盘格
 endcase
end

always @(posedge vga_clk)  //产生竖彩条
begin
 if(hcount < 223)
  v_dat <= 3'h7;      //白   
 else if(hcount < 303)
  v_dat <= 3'h6;   //黄
 else if(hcount < 383)
  v_dat <= 3'h5;   //青
 else if(hcount < 463)
  v_dat <= 3'h4;    //绿
 else if(hcount < 543)
  v_dat <= 3'h3;   //紫
 else if(hcount < 623)
  v_dat <= 3'h2;   //红
 else if(hcount < 703)
  v_dat <= 3'h1;   //蓝
 else 
  v_dat <= 3'h0;   //黑
end

always @(posedge vga_clk)  //产生横彩条
begin
 if(vcount < 94)
  h_dat <= 3'h7;        //白
 else if(vcount < 154)
  h_dat <= 3'h6;   //黄
 else if(vcount < 214)
  h_dat <= 3'h5;   //青
 else if(vcount < 274)
  h_dat <= 3'h4;    //绿
 else if(vcount < 334)
  h_dat <= 3'h3;   //紫
 else if(vcount < 394)
  h_dat <= 3'h2;   //红
 else if(vcount < 454)
  h_dat <= 3'h1;   //蓝
 else 
  h_dat <= 3'h0;   //黑
end

endmodule

