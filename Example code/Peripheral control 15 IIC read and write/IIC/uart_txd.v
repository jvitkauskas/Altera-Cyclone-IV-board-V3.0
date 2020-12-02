
module uart_txd(clk,rst,data_bus,host_ready,load_tram_datareg,serial_out);
input clk;                                          //时钟信号
input rst;                                          //复位
input[7:0] data_bus;                                //数据信号，输入数据总线数据，8bit
input host_ready;                                   //控制信号，为高电平表示主机数据准备完毕
input load_tram_datareg;                            //控制信号，为高电平表示输入数据寄存器从数据数据总线取数据
output serial_out;                                  //数据信号，UART发送的数据信号


reg[7:0] tram_datareg;                              //UART发送数据寄存器
reg[8:0] tram_shiftreg;                             //UART发送数据移位寄存器
reg load_tram_shiftreg;                             //装载移位寄存器标志位
reg[1:0] state;
reg[1:0] next_state;
reg[3:0] count;
reg clear;                                          //对count计数器清零
reg shift;                                          //寄存器移位信号
reg start;                                          //开始发送数据信号

//三种状态：空闲、等待、发送状态
parameter[1:0] idle=2'b00;
parameter[1:0] waiting=2'b01;
parameter[1:0] sending=2'b10;

assign serial_out=tram_shiftreg[0];                 //移位寄存器最低位输出

always@(posedge clk)
begin
  if(!rst)
    next_state<=idle;
  
  state=next_state;
  case(state)
  idle:begin                                        //空闲
       clear=0;
       shift=0;
       start=0;
       if(host_ready)
       begin
         load_tram_shiftreg<=1;
         next_state<=waiting;
       end
       end
  waiting:begin                                     //等待
          start<=1;
          next_state<=sending;
          end
  sending:begin                                     //发送
          if(count!=9) 
            shift<=1;
          else
          begin
            clear<=1;
            next_state<=idle;
          end
          end
  default:next_state<=idle;
  endcase
end

always@(posedge clk)
begin
  if(!rst)
  begin
    tram_shiftreg<=9'b1_1111_1111;                       //移位寄存器内容复位
    count<=0;
  end
  else
  begin
    if(load_tram_datareg)
      tram_datareg<=data_bus;                            //取数据总线
    if(load_tram_shiftreg)
      tram_shiftreg<={tram_datareg,1'b1};
    if(start)
      tram_shiftreg[0]<=0;                               //开始传输信号，起始位为0
    if(clear)
      count<=0;                                          //计数器清空
    else if(shift)
      count<=count+1;
    if(shift)
      tram_shiftreg<={1'b1,tram_shiftreg[8:1]};
  end
end
endmodule    
  
        