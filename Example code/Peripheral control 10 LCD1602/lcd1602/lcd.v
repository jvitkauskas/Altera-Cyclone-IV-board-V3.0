/*******************************************************************
**我们的FPGA开发网
**网站：www.OurFPGA.com
**淘宝：OurFPGA.taobao.com
**邮箱: OurFPGA@gmail.com
**欢迎大家登陆网站，参与FPGA及电子技术讨论，下载免费视频教程及资料
*****************文件信息********************************************
**创建日期：   2011.06.01
**版本号：     version 1.0
**功能描述：   本实验是用LCD1602显示英文
显示“HELLO WORLD!”
注意：1602与12864共用一个20针排座，开发板正对自己时，排座最右边第一个孔为1，最左边的孔为20.（PCB上也有白色字符标记
）当插1602液晶时，请确认液晶的编号1与排座孔1对应，通常情况下，正确的插好的1602液晶是露在开发板PCB外面的。

如不能正常显示，先查有没有插错方向。另可以调节数码管旁边的RW可调电阻(背光)，向右边旋转。


********************************************************************/

module lcd(clk, rs, rw, en,dat);  
input clk;  
 output [7:0] dat; 
 output  rs,rw,en; 
 //tri en; 
 reg e; 
 reg [7:0] dat; 
 reg rs;   
 reg  [15:0] counter; 
 reg [4:0] current,next; 
 reg clkr; 
 reg [1:0] cnt; 
 parameter  set0=4'h0; 
 parameter  set1=4'h1; 
 parameter  set2=4'h2; 
 parameter  set3=4'h3; 
 parameter  dat0=4'h4; 
 parameter  dat1=4'h5; 
 parameter  dat2=4'h6; 
 parameter  dat3=4'h7; 
 parameter  dat4=4'h8; 
 parameter  dat5=4'h9; 

 parameter  dat6=4'hA; 
 parameter  dat7=4'hB; 
 parameter  dat8=4'hC; 
 parameter  dat9=4'hD; 
 parameter  dat10=4'hE; 
 parameter  dat11=5'h10; 
 parameter  nul=4'hF; 
always @(posedge clk)      
 begin 
  counter=counter+1; 
  if(counter==16'h000f)  
  clkr=~clkr; 
end 
always @(posedge clkr) 
begin 
 current=next; 
  case(current) 
    set0:   begin  rs<=0; dat<=8'h30; next<=set1; end 
    set1:   begin  rs<=0; dat<=8'h0c; next<=set2; end 
    set2:   begin  rs<=0; dat<=8'h6; next<=set3; end 
    set3:   begin  rs<=0; dat<=8'h1; next<=dat0; end 
    dat0:   begin  rs<=1; dat<="H"; next<=dat1; end 
    dat1:   begin  rs<=1; dat<="E"; next<=dat2; end 
    dat2:   begin  rs<=1; dat<="L"; next<=dat3; end 
    dat3:   begin  rs<=1; dat<="L"; next<=dat4; end 
    dat4:   begin  rs<=1; dat<="O"; next<=dat5; end 
    dat5:   begin  rs<=1; dat<=" "; next<=dat6; end 

    dat6:   begin  rs<=1; dat<="W"; next<=dat7; end 
    dat7:   begin  rs<=1; dat<="O"; next<=dat8; end 
    dat8:   begin  rs<=1; dat<="R"; next<=dat9; end 
    dat9:   begin  rs<=1; dat<="L"; next<=dat10; end 
    dat10:   begin  rs<=1; dat<="D"; next<=dat11; end 
    dat11:   begin  rs<=1; dat<="!"; next<=nul; end 
     nul:   begin rs<=0;  dat<=8'h00;                    //行一遍 然后 把液晶的E 脚 拉高 
              if(cnt!=2'h2)  
                  begin  
                       e<=0;next<=set0;cnt<=cnt+1;  
                  end  
                   else  
                     begin next<=nul; e<=1; 
                    end    
              end 
   default:   next=set0; 
    endcase 
 end 
assign en=clkr|e; 
assign rw=0; 
endmodule  