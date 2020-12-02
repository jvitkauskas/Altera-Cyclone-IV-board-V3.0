module SEG_D(clk,rst_n,seg,data,cs);  
  
input clk;  
input rst_n;  
input [15:0]data;//ÏÔÊ¾Êı¾İ  
output [7:0] seg;  
output [3:0] cs;  
  
reg [7:0] seg;  
reg [3:0] cs;  
reg [4:0] dataout_buf;  
reg [1:0] disp_dat;  
reg [16:0] delay_cnt;  
  
always@(posedge clk,negedge rst_n)  
   begin   
        if(!rst_n)  
             delay_cnt<=16'd0;  
         else if(delay_cnt==16'd50000)  
           delay_cnt<=16'd0;  
         else   
           delay_cnt<=delay_cnt +1;  
   end   
  
always@(posedge clk,negedge rst_n)  
   begin   
      if(!rst_n)  
          disp_dat<=2'd0;  
        else if(delay_cnt==16'd50000)  
          disp_dat<=disp_dat+1'b1;  
        else  
          disp_dat<=disp_dat;  
    end  
      
always@(disp_dat)  
   begin   
       case(disp_dat)  
           2'b00: cs=4'b1110;  
            2'b01: cs=4'b1101;  
            2'b10: cs=4'b1011;  
            default cs=4'b1111;  
     endcase   
  
   end  
  
always@(cs)  
   begin   
      case(cs)  
        4'b1110:dataout_buf=data[8:5];  
          4'b1101:dataout_buf=data[12:9];  
          4'b1011:dataout_buf={1'b0,data[15:13]};  
          default dataout_buf=0;  
        endcase   
   end   
always@(dataout_buf)  
begin   
     case(dataout_buf)  
          4'h0 : seg = 8'hc0; //0  
          4'h1 : seg = 8'hf9; //1  
         4'h2 : seg = 8'ha4; //2  
         4'h3 : seg = 8'hb0; //3  
          4'h4 : seg = 8'h99; //4  
         4'h5 : seg = 8'h92; //5  
          4'h6 : seg = 8'h82; //6  
           4'h7 : seg = 8'hf8; //7  
           4'h8 : seg = 8'h80; //8  
          4'h9 : seg = 8'h90; //9  
            4'ha : seg = 8'h88; //a  
            4'hb : seg = 8'h83; //b  
            4'hc : seg = 8'hc6; //c  
            4'hd : seg = 8'ha1; //d  
            4'he : seg = 8'h86; //e  
            4'hf : seg = 8'h8e; //f  
       default : seg =8'hc0;  //0  
         
    endcase   
  
end  
endmodule   