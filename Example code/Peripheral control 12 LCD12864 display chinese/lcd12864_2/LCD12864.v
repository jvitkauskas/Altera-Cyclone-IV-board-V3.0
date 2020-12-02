
module  LCD12864 (clk, rs, rw, en,dat);  

input clk;           //系统时钟输入50M
 output [7:0] dat;   //LCD的8位数据口
 output  rs,rw,en;   //LCD的控制脚

 reg e; 
 reg [7:0] dat; 
 reg rs;   
 reg  [15:0] counter; 
 reg [6:0] current,next; 
 reg clkr; 
 reg [1:0] cnt; 
//定义的一些状态机。
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
 parameter  dat10=6'h11; 
 parameter  dat11=6'h12; 
 parameter  dat12=6'h13; 
 parameter  dat13=6'h14; 
 parameter  dat14=6'h15; 
 parameter  dat15=6'h16;
 parameter  dat16=6'h17; 
 parameter  dat17=6'h18; 
 parameter  dat18=6'h19; 
 parameter  dat19=6'h1A; 
 parameter  dat20=6'h1B;
 parameter  dat21=6'h1C; 
 parameter  dat22=6'h1D; 
 parameter  dat23=6'h1E; 
 parameter  dat24=6'h1F; 
 parameter  dat25=6'h20; 
 parameter  dat26=6'h21; 
 parameter  dat27=6'h22; 
 parameter  dat28=6'h23; 
 parameter  dat29=6'h24; 
 parameter  dat30=6'h25; 
 parameter  dat31=6'h26; 
 parameter  dat32=6'h27; 
 parameter  dat33=6'h28; 
 parameter  dat34=6'h29; 
 parameter  dat35=6'h2A;
 parameter  dat36=6'h2B; 
 parameter  dat37=6'h2C; 
 parameter  dat38=6'h2D; 
 parameter  dat39=6'h2E;
 parameter  dat40=6'h3F;  
	

 parameter  nul=6'h35; 
always @(posedge clk)         // 
 begin 
  counter=counter+1; 
  if(counter==16'h000f)  
  clkr=~clkr; 
end 

always @(posedge clkr) 
begin 
 current=next; 
  case(current) 
    set0:   begin  rs<=0; dat<=8'h31; next<=set1; end  //*设置8位格式,*
    set1:   begin  rs<=0; dat<=8'h0C; next<=set2; end  //*整体显示,关光标,不闪烁*/  
    set2:   begin  rs<=0; dat<=8'h06; next<=set3; end   //*设定输入方式,增量不移位*/  
    set3:   begin  rs<=0; dat<=8'h01; next<=dat0; end   //*清除显示*/  

    dat0:   begin  rs<=1; dat<=8'hce; next<=dat1; end //显示第一行
    dat1:   begin  rs<=1; dat<=8'hd2; next<=dat2; end    
    //上面是‘我 ’字的ACSII码值 CED2
    
    dat2:   begin  rs<=1; dat<=8'hc3; next<=dat3; end 
    dat3:   begin  rs<=1; dat<=8'hc7;next<=dat4; end 
    //上面是‘们’字的ACSII码值C3C7
    
    dat4:   begin  rs<=1; dat<=8'hb5; next<=dat5; end 
    dat5:   begin  rs<=1; dat<=8'hc4; next<=dat6; end 
    //上面是‘的’字的ACSII码值b5c4
    
    dat6:   begin  rs<=1; dat<="F"; next<=dat7; end 
    dat7:   begin  rs<=1; dat<="P";next<=dat8; end 
    dat8:   begin  rs<=1; dat<="G"; next<=dat9; end 
    dat9:   begin  rs<=1; dat<="A";next<= dat10 ; end 
    
    dat10:   begin  rs<=1; dat<=8'hbf; next<=dat11; end 
    dat11:   begin  rs<=1; dat<=8'haa; next<=dat12; end 
     //上面是‘开’字的ACSII码值bfaa
     
    dat12:   begin  rs<=1; dat<=8'hb7;next<=dat13; end 
    dat13:   begin  rs<=1; dat<=8'ha2; next<=dat14; end 
    //上面是‘发’字的ACSII码值b7a2
	 
    dat14:   begin  rs<=1; dat<=8'hcd; next<=dat15; end 
    dat15:   begin  rs<=1; dat<=8'hf8; next<=set4; end 
    //上面是‘网’字的ACSII码值cdf8  

	 
    set4:   begin  rs<=0; dat<=8'h90; next<=dat16; end //显示第二行
	 
    dat16:   begin  rs<=1; dat<=8'hee; next<=dat17; end 
    dat17:   begin  rs<=1; dat<=8'ha3; next<=dat18; end 
    //上面是‘睿’字的ACSII码值eea3  
	 
	 dat18:   begin  rs<=1; dat<=8'hd6; next<=dat19; end 
    dat19:   begin  rs<=1; dat<=8'hc7; next<=dat20; end 
    //上面是‘智’字的ACSII码值d6c7  
	 
    dat20:   begin  rs<=1; dat<="F"; next<=dat21; end 
    dat21:   begin  rs<=1; dat<="P"; next<=dat22; end 
    dat22:   begin  rs<=1; dat<="G"; next<=dat23; end 
    dat23:   begin  rs<=1; dat<="A"; next<=dat24 ; end
    
    dat24:   begin  rs<=1; dat<=8'hbf; next<=dat25; end 
    dat25:   begin  rs<=1; dat<=8'haa; next<=dat26; end  
  //上面是‘开’字的ACSII码值bfaa
	 
	 
    dat26:   begin  rs<=1; dat<=8'hb7; next<=dat27; end 
    dat27:   begin  rs<=1; dat<=8'ha2; next<=dat28; end 
    //上面是‘发’字的ACSII码值b7a2
    
    dat28:   begin  rs<=1; dat<=8'hb0; next<=dat29; end 
    dat29:   begin  rs<=1; dat<=8'he5; next<=set5 ; end 
    //上面是‘板’字的ACSII码值
    
    set5:   begin  rs<=0; dat<=8'h88; next<=dat30; end //显示第三行

    dat30:   begin  rs<=1; dat<=8'hd7; next<=dat31; end 
    dat31:   begin  rs<=1; dat<=8'ha3; next<=dat32; end 
	    //上面是‘祝’字的ACSII码值
	 
	 
    dat32:   begin  rs<=1; dat<=8'hc4; next<=dat33; end 
    dat33:   begin  rs<=1; dat<=8'hfa; next<=dat34; end 
      //上面是‘您’字的ACSII码值
	
    dat34:   begin  rs<=1; dat<=8'hb3; next<=dat35;   end 
    dat35:   begin  rs<=1; dat<=8'hc9; next<=dat36;   end 
      //上面是‘成’字的ACSII码值
	
    dat36:   begin  rs<=1; dat<=8'hb9; next<=dat37;   end 
    dat37:   begin  rs<=1; dat<=8'ha6; next<=dat38;   end 
	   //上面是‘功’字的ACSII码值
	 
    dat38:   begin  rs<=1; dat<="!"; next<=dat40;   end 
    dat40:   begin  rs<=1; dat<="!"; next<=nul;     end 
	
	 
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