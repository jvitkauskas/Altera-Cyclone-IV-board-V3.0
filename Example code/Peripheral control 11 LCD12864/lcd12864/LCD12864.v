/*******************************************************************
**我们的FPGA开发网
**网站：www.OurFPGA.com
**淘宝：OurFPGA.taobao.com
**邮箱: OurFPGA@gmail.com
**欢迎大家登陆网站，参与FPGA及电子技术讨论，下载免费视频教程及资料
*****************文件信息********************************************
**创建日期：   2011.06.01
**版本号：     version 1.0
**功能描述：   本实验是用LCD12864显示英文
正常显示为：
Our FPGA EDA
NIOS II
SOPC
FPGA

注意：1602与12864共用一个20针排座，开发板正对自己时，排座最右边第一个孔为1，最左边的孔为20.（PCB上也有白色字符标记
）当插12864液晶时，请确认液晶的编号1与排座孔1对应，通常情况下，正确的插好的12864液晶是露在开发板PCB外面的。
********************************************************************/

module LCD12864 (clk, rs, rw, en,dat);  
input clk;  
 output [7:0] dat; 
 output  rs,rw,en; 
 //tri en; 
 reg e; 
 reg [7:0] dat; 
 reg rs;   
 reg  [15:0] counter; 
 reg [5:0] current,next; 
 reg clkr; 
 reg [1:0] cnt; 
 parameter  set0=6'h0; 
 parameter  set1=6'h1; 
 parameter  set2=6'h2; 
 parameter  set3=6'h3; 
 parameter  set4=6'h4; 
 parameter  set5=6'h5;
 parameter  set6=6'h6;  

 parameter  dat0=6'h7; 
 parameter  dat1=6'h8; 
 parameter  dat2=6'h9; 
 parameter  dat3=6'hA; 
 parameter  dat4=6'hB; 
 parameter  dat5=6'hC;
 parameter  dat6=6'hD; 
 parameter  dat7=6'hE; 
 parameter  dat8=6'hF; 
 parameter  dat9=6'h10;

 parameter  dat10=6'h12; 
 parameter  dat11=6'h13; 
 parameter  dat12=6'h14; 
 parameter  dat13=6'h15; 
 parameter  dat14=6'h16; 
 parameter  dat15=6'h17;
 parameter  dat16=6'h18; 
 parameter  dat17=6'h19; 
 parameter  dat18=6'h1A; 
 parameter  dat19=6'h1B; 
 parameter  dat20=6'h1C;
 parameter  dat21=6'h1D; 
 parameter  dat22=6'h1E; 
 parameter  dat23=6'h1F; 
 parameter  dat24=6'h20; 
 parameter  dat25=6'h21; 
 parameter  dat26=6'h22;     
  
 parameter  nul=6'hF1; 
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

    dat0:   begin  rs<=1; dat<="O"; next<=dat1; end //显示第一行
    dat1:   begin  rs<=1; dat<="u"; next<=dat2; end 
    dat2:   begin  rs<=1; dat<="r"; next<=dat3; end 
    dat3:   begin  rs<=1; dat<=" ";next<=dat4; end 
    dat4:   begin  rs<=1; dat<="F"; next<=dat5; end 
    dat5:   begin  rs<=1; dat<="P"; next<=dat6; end 
    dat6:   begin  rs<=1; dat<="G"; next<=dat7; end 
    dat7:   begin  rs<=1; dat<="A";next<=dat8; end 
    dat8:   begin  rs<=1; dat<=" "; next<=dat9; end 
    dat9:   begin  rs<=1; dat<="E";next<= dat10 ; end 
    dat10:  begin  rs<=1; dat<="D"; next<=dat11; end 
    dat11:  begin  rs<=1; dat<="A"; next<=set4; end 

    set4:   begin  rs<=0; dat<=8'h90; next<=dat12; end //显示第二行

    dat12:   begin  rs<=1; dat<="N"; next<=dat13; end 
    dat13:   begin  rs<=1; dat<="I";next<=dat14; end 
    dat14:   begin  rs<=1; dat<="O"; next<=dat15; end 
    dat15:   begin  rs<=1; dat<="S"; next<=dat16; end 
    dat16:   begin  rs<=1; dat<=" "; next<=dat17; end 
    dat17:   begin  rs<=1; dat<="I"; next<=dat18; end 
    dat18:   begin  rs<=1; dat<="I"; next<=set5; end 

    set5:   begin  rs<=0; dat<=8'h88; next<=dat19; end //显示第三行

    dat19:   begin  rs<=1; dat<="S"; next<=dat20; end 
    dat20:   begin  rs<=1; dat<="O"; next<=dat21; end 
    dat21:   begin  rs<=1; dat<="P"; next<=dat22; end 
    dat22:   begin  rs<=1; dat<="C"; next<=set6 ; end 

    set6:   begin  rs<=0; dat<=8'h98; next<=dat23; end //显示第四行

    dat23:   begin  rs<=1; dat<="F"; next<=dat24; end 
    dat24:   begin  rs<=1; dat<="P"; next<=dat25; end 
    dat25:   begin  rs<=1; dat<="G"; next<=dat26; end 
    dat26:   begin  rs<=1; dat<="A"; next<=nul;   end 

     nul:   begin rs<=0;  dat<=8'h00;                    // 把液晶的E 脚 拉高 
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