
module speed_select(clk,sclk,rst);
input clk;
input rst;
output sclk;
reg sclk;
reg [12:0] count;

always@(posedge clk or negedge rst)
begin
  if(!rst)
  begin
    count<=13'b0_0000_0000_0000;
    sclk<=1'b0;
  end
  else
  begin
  if(count<=5208)
  begin
    count<=count+13'b0_0000_0000_0001;
    if(count<=2604)
      sclk<=1'b1;
    else
      sclk<=1'b0;
  end
  else
    count<=13'b0_0000_0000_0000;
  end
 end
 endmodule 
