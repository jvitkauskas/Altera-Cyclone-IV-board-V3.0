module I2C_READ(
       clk,
rst_n,
scl,sda,data
              );
 
 input clk;//总线时钟 50MHz  
input rst_n;//异步复位,低电平有效  
  
output scl;//SCL 时钟  
inout  sda;// SDA 数据总线  
output [15:0] data;//温度数据  
  
reg [15:0]data_r;//温度数据寄存器  
reg scl;//SCL 总线寄存器  
reg sda_r;//SDA 总线寄存器  
reg sda_link;//SDA 总线数据方向标志  
reg [7:0]scl_cnt;//SCL 时钟产生计数器  
reg [2:0]cnt;//用来标记SCL时钟计数器  
reg [25:0]timer_cnt;//定时器,每隔2s 读取一次温度数据  
reg [3:0]data_cnt;//数据串并转换寄存器  
reg [7:0]address_reg;//器件地址寄存器  
reg [8:0]state;//状态寄存器  
//////////////////////////////////////////////////////////////////////////////////  
//进程1、2、3：产生SCL 总线时钟  
always@(posedge clk or negedge rst_n)  
    begin  
        if(!rst_n)  
            scl_cnt <= 8'd0;  
        else if(scl_cnt == 8'd199)  
            scl_cnt <= 8'd0;  
        else  
            scl_cnt <= scl_cnt + 1'b1;  
    end  
always@(posedge clk or negedge rst_n)  
    begin  
        if(!rst_n)  
            cnt <= 3'd5;  
        else   
            case(scl_cnt)  
                8'd49: cnt <= 3'd1;//高电平中间  
                8'd99: cnt <= 3'd2;//下降沿  
                8'd149:cnt <= 3'd3;//低电平中间  
                8'd199:cnt <= 3'd0;//上升沿  
               default: cnt <= 3'd5;  
            endcase  
    end  
`define SCL_HIG (cnt == 3'd1)  
`define SCL_NEG (cnt == 3'd2)  
`define SCL_LOW (cnt == 3'd3)  
`define SCL_POS (cnt == 3'd0)  
always@(posedge clk or negedge rst_n)  
    begin  
        if(!rst_n)  
            scl <= 1'b0;  
        else if(`SCL_POS)  
            scl <= 1'b1;  
        else if(`SCL_NEG)  
            scl <= 1'b0;  
    end  
//////////////////////////////////////////////////////////////////////////////////  
//进程4：定时器,每隔1s 读取一次温度数据  
always@(posedge clk or negedge rst_n)  
    begin  
        if(!rst_n)  
            timer_cnt <= 26'd0;  
        else if(timer_cnt == 26'd49999999)  
            timer_cnt <= 26'd0;  
        else   
            timer_cnt <= timer_cnt + 1'b1;  
    end  
//////////////////////////////////////////////////////////////////////////////////  
//状态机定义  
parameter IDLE  = 9'b0_0000_0000,  
             START  = 9'b0_0000_0010,  
             ADDRESS    = 9'b0_0000_0100,  
             ACK1       = 9'b0_0000_1000,  
             READ1  = 9'b0_0001_0000,  
             ACK2       = 9'b0_0010_0000,  
             READ2  = 9'b0_0100_0000,  
             NACK       = 9'b0_1000_0000,  
             STOP       = 9'b1_0000_0000;  
`define DEVICE_ADDRESS 8'b1001_0001//器件地址,读操作  
//////////////////////////////////////////////////////////////////////////////////  
//进程5：状态机描述  
always@(posedge clk or negedge rst_n)  
    begin  
        if(!rst_n)  
            begin  
                data_r  <= 16'd0;  
                sda_r       <= 1'b1;  
                sda_link    <= 1'b1;  
                state       <= IDLE;  
                address_reg <= 15'd0;  
                data_cnt    <= 4'd0;  
            end  
        else   
            case(state)  
                IDLE:  
                    begin  
                        sda_r   <= 1'b1;  
                        sda_link <= 1'b1;  
                        if(timer_cnt == 26'd49999999)  
                            state <= START;  
                        else  
                            state <= IDLE;  
                    end  
                START://产生起始信号  
                    begin  
                        if(`SCL_HIG)  
                            begin  
                                sda_r       <= 1'b0;  
                                sda_link    <= 1'b1;  
                                address_reg <= `DEVICE_ADDRESS;  
                                state           <= ADDRESS;  
                                data_cnt        <= 4'd0;  
                            end  
                        else  
                            state <= START;  
                    end  
                ADDRESS://主机对器件进行寻址  
                    begin  
                        if(`SCL_LOW)  
                            begin  
                                if(data_cnt == 4'd8)//寻址完成,SDA改变方向,器件准备输出应答讯号  
                                    begin  
                                        state   <= ACK1;  
                                        data_cnt <=  4'd0;  
                                        sda_r       <= 1'b1;  
                                        sda_link    <= 1'b0;  
                                    end  
                                else//寻址过程中,SDA对器件作为输入  
                                    begin  
                                        state   <= ADDRESS;  
                                        data_cnt <= data_cnt + 1'b1;  
                                        case(data_cnt)  
                                            4'd0: sda_r <= address_reg[7];  
                                            4'd0: sda_r <= address_reg[7];  
                                            4'd1: sda_r <= address_reg[6];  
                                            4'd2: sda_r <= address_reg[5];  
                                            4'd3: sda_r <= address_reg[4];  
                                            4'd4: sda_r <= address_reg[3];  
                                            4'd5: sda_r <= address_reg[2];  
                                            4'd6: sda_r <= address_reg[1];  
                                            4'd7: sda_r <= address_reg[0];  
                                            default: ;  
                                        endcase  
                                    end  
                            end  
                        else  
                            state <= ADDRESS;  
                    end  
                ACK1://器件输出应答信号  
                    begin  
                        if(!sda && (`SCL_HIG))  
                            state <= READ1;  
                        else if(`SCL_NEG)  
                            state <= READ1;  
                        else  
                            state <= ACK1;  
                    end  
                READ1://读器件数据,高字节  
                    begin  
                        if((`SCL_LOW) && (data_cnt == 4'd8))//读高字节数据完成,SDA改变方向,主机准备输出应答讯号  
                            begin  
                                state   <= ACK2;  
                                data_cnt <= 4'd0;  
                                sda_r       <= 1'b1;  
                                sda_link    <= 1'b1;  
                            end  
                        else if(`SCL_HIG)//读数据过程中,器件作为输出  
                            begin  
                                data_cnt <= data_cnt + 1'b1;  
                                case(data_cnt)  
                                    4'd0: data_r[15] <= sda;  
                                    4'd1: data_r[14] <= sda;  
                                    4'd2: data_r[13] <= sda;  
                                    4'd3: data_r[12] <= sda;  
                                    4'd4: data_r[11] <= sda;  
                                    4'd5: data_r[10] <= sda;  
                                    4'd6: data_r[9]  <= sda;  
                                    4'd7: data_r[8]  <= sda;  
                                    default: ;  
                                endcase  
                            end  
                        else  
                            state <= READ1;  
                    end  
                ACK2://主机输出应答讯号  
                    begin     
                        if(`SCL_LOW)  
                            sda_r <= 1'b0;  
                        else if(`SCL_NEG)  
                            begin  
                                sda_r   <= 1'b1;  
                                sda_link    <= 1'b0;  
                                state       <= READ2;  
                            end  
                        else  
                            state <= ACK2;  
                    end  
                READ2://读低字节数据  
                    begin  
                        if((`SCL_LOW) && (data_cnt == 4'd8))  
                            begin  
                                state   <= NACK;  
                                data_cnt <= 4'd0;  
                                sda_r       <= 1'b1;  
                                sda_link    <= 1'b1;  
                            end  
                        else if(`SCL_HIG)  
                            begin  
                                data_cnt <= data_cnt + 1'b1;  
                                case(data_cnt)  
                                    4'd0: data_r[7] <= sda;  
                                    4'd1: data_r[6] <= sda;  
                                    4'd2: data_r[5] <= sda;  
                                    4'd3: data_r[4] <= sda;  
                                    4'd4: data_r[3] <= sda;  
                                    4'd5: data_r[2] <= sda;  
                                    4'd6: data_r[1]  <= sda;  
                                    4'd7: data_r[0]  <= sda;  
                                    default: ;  
                                endcase  
                            end  
                        else  
                            state <= READ2;  
                    end  
                NACK://主机非应答  
                    begin  
                        if(`SCL_LOW)  
                            begin  
                                state <= STOP;  
                                sda_r   <= 1'b0;  
                            end  
                        else  
                            state <= NACK;  
                    end  
                STOP:  
                    begin  
                        if(`SCL_HIG)  
                            begin  
                                state <= IDLE;  
                                sda_r <= 1'b1;  
                            end  
                        else  
                            state <= STOP;  
                    end  
                default: state <= IDLE;  
            endcase  
    end  
assign sda   = sda_link ? sda_r: 1'bz;  
assign data  = data_r;  
endmodule
