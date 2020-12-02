

module iic_com(
			clk,rst_n,
			sw1,sw2,
			scl,sda,
			dis_data
		);

input clk;		// 50MHz
input rst_n;	//复位信号，低有效
input sw1,sw2;	//按键1、2,(1按下执行写入操作，2按下执行读操作)
output scl;		// 24C02的时钟端口
inout sda;		// 24C02的数据端口
output[7:0] dis_data;	//数码管显示的数据


		//按键检测
reg sw1_r,sw2_r;	//键值锁存寄存器，每20ms检测一次键值 
reg[19:0] cnt_20ms;	//20ms计数寄存器

always @ (posedge clk or negedge rst_n)
	if(!rst_n) cnt_20ms <= 20'd0;
	else cnt_20ms <= cnt_20ms+1'b1;	//不断计数

always @ (posedge clk or negedge rst_n)
	if(!rst_n) begin
			sw1_r <= 1'b1;	//键值寄存器复位，没有键盘按下时键值都为1
			sw2_r <= 1'b1;
		end
	else if(cnt_20ms == 20'hfffff) begin
			sw1_r <= sw1;	//按键1值锁存
			sw2_r <= sw2;	//按键2值锁存
		end

//---------------------------------------------
		//分频部分
reg[2:0] cnt;	// cnt=0:scl上升沿，cnt=1:scl高电平中间，cnt=2:scl下降沿，cnt=3:scl低电平中间
reg[8:0] cnt_delay;	//500循环计数，产生iic所需要的时钟
reg scl_r;		//时钟脉冲寄存器

always @ (posedge clk or negedge rst_n)
	if(!rst_n) cnt_delay <= 9'd0;
	else if(cnt_delay == 9'd499) cnt_delay <= 9'd0;	//计数到10us为scl的周期，即100KHz
	else cnt_delay <= cnt_delay+1'b1;	//时钟计数

always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) cnt <= 3'd5;
	else begin
		case (cnt_delay)
			9'd124:	cnt <= 3'd1;	//cnt=1:scl高电平中间,用于数据采样
			9'd249:	cnt <= 3'd2;	//cnt=2:scl下降沿
			9'd374:	cnt <= 3'd3;	//cnt=3:scl低电平中间,用于数据变化
			9'd499:	cnt <= 3'd0;	//cnt=0:scl上升沿
			default: cnt <= 3'd5;
			endcase
		end
end


`define SCL_POS		(cnt==3'd0)		//cnt=0:scl上升沿
`define SCL_HIG		(cnt==3'd1)		//cnt=1:scl高电平中间,用于数据采样
`define SCL_NEG		(cnt==3'd2)		//cnt=2:scl下降沿
`define SCL_LOW		(cnt==3'd3)		//cnt=3:scl低电平中间,用于数据变化


always @ (posedge clk or negedge rst_n)
	if(!rst_n) scl_r <= 1'b0;
	else if(cnt==3'd0) scl_r <= 1'b1;	//scl信号上升沿
   	else if(cnt==3'd2) scl_r <= 1'b0;	//scl信号下降沿

assign scl = scl_r;	//产生iic所需要的时钟
//---------------------------------------------
		//需要写入24C02的地址和数据
				
`define	DEVICE_READ	8'b1010_0001	//被寻址器件地址（读操作）
`define DEVICE_WRITE	8'b1010_0000	//被寻址器件地址（写操作）
`define	WRITE_DATA	8'b1111_0001	//写入EEPROM的数据
`define BYTE_ADDR		8'b0000_0011	//写入/读出EEPROM的地址寄存器	
reg[7:0] db_r;		//在IIC上传送的数据寄存器
reg[7:0] read_data;	//读出EEPROM的数据寄存器

//---------------------------------------------
		//读、写时序
parameter 	IDLE 	= 4'd0;
parameter 	START1 	= 4'd1;
parameter 	ADD1 	= 4'd2;
parameter 	ACK1 	= 4'd3;
parameter 	ADD2 	= 4'd4;
parameter 	ACK2 	= 4'd5;
parameter 	START2 	= 4'd6;
parameter 	ADD3 	= 4'd7;
parameter 	ACK3	= 4'd8;
parameter 	DATA 	= 4'd9;
parameter 	ACK4	= 4'd10;
parameter 	STOP1 	= 4'd11;
parameter 	STOP2 	= 4'd12;

reg[3:0] cstate;	//状态寄存器
reg sda_r;		//输出数据寄存器
reg sda_link;	//输出数据sda信号inout方向控制位		
reg[3:0] num;	//


always @ (posedge clk or negedge rst_n) begin
	if(!rst_n) begin
			cstate <= IDLE;
			sda_r <= 1'b1;
			sda_link <= 1'b0;
			num <= 4'd0;
			read_data <= 8'b0000_0000;
		end
	else 	  
		case (cstate)
			IDLE:	begin
					sda_link <= 1'b1;			//数据线sda为output
					sda_r <= 1'b1;
					if(!sw1_r || !sw2_r) begin	//SW1,SW2键有一个被按下			
						db_r <= `DEVICE_WRITE;	//送器件地址（写操作）
						cstate <= START1;		
						end
					else cstate <= IDLE;	//没有任何键被按下
				end
			START1: begin
					if(`SCL_HIG) begin		//scl为高电平期间
						sda_link <= 1'b1;	//数据线sda为output
						sda_r <= 1'b0;		//拉低数据线sda，产生起始位信号
						cstate <= ADD1;
						num <= 4'd0;		//num计数清零
						end
					else cstate <= START1; //等待scl高电平中间位置到来
				end
			ADD1:	begin
					if(`SCL_LOW) begin
							if(num == 4'd8) begin	
									num <= 4'd0;			//num计数清零
									sda_r <= 1'b1;
									sda_link <= 1'b0;		//sda置为高阻态(input)
									cstate <= ACK1;
								end
							else begin
									cstate <= ADD1;
									num <= num+1'b1;
									case (num)
										4'd0: sda_r <= db_r[7];
										4'd1: sda_r <= db_r[6];
										4'd2: sda_r <= db_r[5];
										4'd3: sda_r <= db_r[4];
										4'd4: sda_r <= db_r[3];
										4'd5: sda_r <= db_r[2];
										4'd6: sda_r <= db_r[1];
										4'd7: sda_r <= db_r[0];
										default: ;
										endcase
							//		sda_r <= db_r[4'd7-num];	//送器件地址，从高位开始
								end
						end
			//		else if(`SCL_POS) db_r <= {db_r[6:0],1'b0};	//器件地址左移1bit
					else cstate <= ADD1;
				end
			ACK1:	begin
					if(/*!sda*/`SCL_NEG) begin	//注：24C01/02/04/08/16器件可以不考虑应答位
							cstate <= ADD2;	//从机响应信号
							db_r <= `BYTE_ADDR;	// 1地址		
						end
					else cstate <= ACK1;		//等待从机响应
				end
			ADD2:	begin
					if(`SCL_LOW) begin
							if(num==4'd8) begin	
									num <= 4'd0;			//num计数清零
									sda_r <= 1'b1;
									sda_link <= 1'b0;		//sda置为高阻态(input)
									cstate <= ACK2;
								end
							else begin
									sda_link <= 1'b1;		//sda作为output
									num <= num+1'b1;
									case (num)
										4'd0: sda_r <= db_r[7];
										4'd1: sda_r <= db_r[6];
										4'd2: sda_r <= db_r[5];
										4'd3: sda_r <= db_r[4];
										4'd4: sda_r <= db_r[3];
										4'd5: sda_r <= db_r[2];
										4'd6: sda_r <= db_r[1];
										4'd7: sda_r <= db_r[0];
										default: ;
										endcase
							//		sda_r <= db_r[4'd7-num];	//送EEPROM地址（高bit开始）		
									cstate <= ADD2;					
								end
						end
			//		else if(`SCL_POS) db_r <= {db_r[6:0],1'b0};	//器件地址左移1bit
					else cstate <= ADD2;				
				end
			ACK2:	begin
					if(/*!sda*/`SCL_NEG) begin		//从机响应信号
						if(!sw1_r) begin
								cstate <= DATA; 	//写操作
								db_r <= `WRITE_DATA;	//写入的数据							
							end	
						else if(!sw2_r) begin
								db_r <= `DEVICE_READ;	//送器件地址（读操作），特定地址读需要执行该步骤以下操作
								cstate <= START2;		//读操作
							end
						end
					else cstate <= ACK2;	//等待从机响应
				end
			START2: begin	//读操作起始位
					if(`SCL_LOW) begin
						sda_link <= 1'b1;	//sda作为output
						sda_r <= 1'b1;		//拉高数据线sda
						cstate <= START2;
						end
					else if(`SCL_HIG) begin	//scl为高电平中间
						sda_r <= 1'b0;		//拉低数据线sda，产生起始位信号
						cstate <= ADD3;
						end	 
					else cstate <= START2;
				end
			ADD3:	begin	//送读操作地址
					if(`SCL_LOW) begin
							if(num==4'd8) begin	
									num <= 4'd0;			//num计数清零
									sda_r <= 1'b1;
									sda_link <= 1'b0;		//sda置为高阻态(input)
									cstate <= ACK3;
								end
							else begin
									num <= num+1'b1;
									case (num)
										4'd0: sda_r <= db_r[7];
										4'd1: sda_r <= db_r[6];
										4'd2: sda_r <= db_r[5];
										4'd3: sda_r <= db_r[4];
										4'd4: sda_r <= db_r[3];
										4'd5: sda_r <= db_r[2];
										4'd6: sda_r <= db_r[1];
										4'd7: sda_r <= db_r[0];
										default: ;
										endcase									
								//	sda_r <= db_r[4'd7-num];	//送EEPROM地址（高bit开始）		
									cstate <= ADD3;					
								end
						end
				//	else if(`SCL_POS) db_r <= {db_r[6:0],1'b0};	//器件地址左移1bit
					else cstate <= ADD3;				
				end
			ACK3:	begin
					if(/*!sda*/`SCL_NEG) begin
							cstate <= DATA;	//从机响应信号
							sda_link <= 1'b0;
						end
					else cstate <= ACK3; 		//等待从机响应
				end
			DATA:	begin
					if(!sw2_r) begin	 //读操作
							if(num<=4'd7) begin
								cstate <= DATA;
								if(`SCL_HIG) begin	
									num <= num+1'b1;	
									case (num)
										4'd0: read_data[7] <= sda;
										4'd1: read_data[6] <= sda;  
										4'd2: read_data[5] <= sda; 
										4'd3: read_data[4] <= sda; 
										4'd4: read_data[3] <= sda; 
										4'd5: read_data[2] <= sda; 
										4'd6: read_data[1] <= sda; 
										4'd7: read_data[0] <= sda; 
										default: ;
										endcase																		
					//				read_data[4'd7-num] <= sda;	//读数据（高bit开始）
									end
				//				else if(`SCL_NEG) read_data <= {read_data[6:0],read_data[7]};	//数据循环右移
								end
							else if((`SCL_LOW) && (num==4'd8)) begin
								num <= 4'd0;			//num计数清零
								cstate <= ACK4;
								end
							else cstate <= DATA;
						end
					else if(!sw1_r) begin	//写操作
							sda_link <= 1'b1;	
							if(num<=4'd7) begin
								cstate <= DATA;
								if(`SCL_LOW) begin
									sda_link <= 1'b1;		//数据线sda作为output
									num <= num+1'b1;
									case (num)
										4'd0: sda_r <= db_r[7];
										4'd1: sda_r <= db_r[6];
										4'd2: sda_r <= db_r[5];
										4'd3: sda_r <= db_r[4];
										4'd4: sda_r <= db_r[3];
										4'd5: sda_r <= db_r[2];
										4'd6: sda_r <= db_r[1];
										4'd7: sda_r <= db_r[0];
										default: ;
										endcase									
								//	sda_r <= db_r[4'd7-num];	//写入数据（高bit开始）
									end
			//					else if(`SCL_POS) db_r <= {db_r[6:0],1'b0};	//写入数据左移1bit
							 	end
							else if((`SCL_LOW) && (num==4'd8)) begin
									num <= 4'd0;
									sda_r <= 1'b1;
									sda_link <= 1'b0;		//sda置为高阻态
									cstate <= ACK4;
								end
							else cstate <= DATA;
						end
				end
			ACK4: begin
					if(/*!sda*/`SCL_NEG) begin
//						sda_r <= 1'b1;
						cstate <= STOP1;						
						end
					else cstate <= ACK4;
				end
			STOP1:	begin
					if(`SCL_LOW) begin
							sda_link <= 1'b1;
							sda_r <= 1'b0;
							cstate <= STOP1;
						end
					else if(`SCL_HIG) begin
							sda_r <= 1'b1;	//scl为高时，sda产生上升沿（结束信号）
							cstate <= STOP2;
						end
					else cstate <= STOP1;
				end
			STOP2:	begin
					if(`SCL_LOW) sda_r <= 1'b1;
					else if(cnt_20ms==20'hffff0) cstate <= IDLE;
					else cstate <= STOP2;
				end
			default: cstate <= IDLE;
			endcase
end

assign sda = sda_link ? sda_r:1'bz;
assign dis_data = read_data;



endmodule


