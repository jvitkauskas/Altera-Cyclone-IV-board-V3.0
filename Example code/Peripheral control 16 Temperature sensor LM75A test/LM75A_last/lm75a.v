module LM75A_test(clk,rst_n,scl,sda,cs,seg);
input clk,rst_n; //fu复位信号低电平有效，时钟50MHz;
output scl;  //I2C时钟，250KHz；时钟周期为4us;
inout sda;   //I2C数据端；
output[3:0] cs;  //数码管片选；
output[7:0] seg;  //数码管段选；
wire done;    // I2C读取一个数据完毕，更新数码管段选寄存器；
wire[15:0] data;//温度数据；
I2C_READ I2C_READ(
        .clk(clk),
 .rst_n(rst_n),
 .scl(scl),
 .sda(sda),
 .data(data)
              );
SEG_D  SEG_D(
       .clk(clk),
.rst_n(rst_n),
.cs(cs),
.seg(seg),
.data(data)
         );
endmodule