
//把按下的数字键在数码管上面显示出来

module IR(clk,rst_n,IR,led_cs,led_db);

  input   clk;
  input   rst_n;
  input   IR;
  output [3:0] led_cs;
  output [7:0] led_db;
 
  reg [3:0] led_cs;
  reg [7:0] led_db;
 
  reg [7:0] led1,led2,led3,led4;
  reg [15:0] irda_data;    // save irda data,than send to 7 segment led
  reg [31:0] get_data;     // use for saving 32 bytes irda data
  reg [5:0]  data_cnt;     // 32 bytes irda data counter
  reg [2:0]  cs,ns;
  reg error_flag;          // 32 bytes data期间，数据错误标志

  //----------------------------------------------------------------------------
  reg irda_reg0;       //为了避免亚稳态,避免驱动多个寄存器，这一个不使用。
  reg irda_reg1;       //这个才可以使用，以下程序中代表irda的状态
  reg irda_reg2;       //为了确定irda的边沿，再打一次寄存器，以下程序中代表irda的前一状态
  wire irda_neg_pulse; //确定irda的下降沿
  wire irda_pos_pulse; //确定irda的上升沿
  wire irda_chang;     //确╥rda的跳变沿
  
  reg[15:0] cnt_scan;//扫描频率计数器
   
  always @ (posedge clk) //在此采用跟随寄存器
    if(!rst_n)
      begin
        irda_reg0 <= 1'b0;
        irda_reg1 <= 1'b0;
        irda_reg2 <= 1'b0;
      end
    else
      begin
        led_cs <= 4'b0000; //是数码管的位选择处于导通状态
        irda_reg0 <= IR;
        irda_reg1 <= irda_reg0;
        irda_reg2 <= irda_reg1;
      end
     
  assign irda_chang = irda_neg_pulse | irda_pos_pulse;  //IR接收信号的改变，上升或者下降
  assign irda_neg_pulse = irda_reg2 & (~irda_reg1);  //IR接收信号irda下降沿
  assign irda_pos_pulse = (~irda_reg2) & irda_reg1;      //IR接收信号irda上升沿


  reg [10:0] counter;  //分频1750次
  reg [8:0]  counter2; //计数分频后的点数
  wire check_9ms;  // check leader 9ms time
  wire check_4ms;  // check leader 4.5ms time
  wire low;        // check  data="0" time
  wire high;       // check  data="1" time
 
  //----------------------------------------------------------------------------
  //分频1750计数
  always @ (posedge clk)
    if (!rst_n)
      counter <= 11'd0;
    else if (irda_chang)  //irda电平跳变了，就重新开始计数
      counter <= 11'd0;
    else if (counter == 11'd1750)
      counter <= 11'd0;
    else
      counter <= counter + 1'b1;
  
  //---------------------------------------------------------------------------- 
  always @ (posedge clk)
    if (!rst_n)
      counter2 <= 9'd0;
    else if (irda_chang)  //irda电平跳变了，就重新开始计点
      counter2 <= 9'd0;
    else if (counter == 11'd1750)
      counter2 <= counter2 +1'b1;
  

  assign check_9ms = ((217 < counter2) & (counter2 < 297)); 
  //257  为了增加稳定性，取一定范围
  assign check_4ms = ((88 < counter2) & (counter2 < 168));  //128
  assign low  = ((6 < counter2) & (counter2 < 26));         // 16
  assign high = ((38 < counter2) & (counter2 < 58));        // 48

  //----------------------------------------------------------------------------
  // generate statemachine  状态机
    parameter IDLE       = 3'b000, //初始状态
              LEADER_9   = 3'b001, //9ms
              LEADER_4   = 3'b010, //4ms
              DATA_STATE = 3'b100; //传输数据
 
  always @ (posedge clk)
    if (!rst_n)
      cs <= IDLE;
    else
      cs <= ns; //状态位
     
  always @ ( * )
    case (cs)
      IDLE:
        if (~irda_reg1)
          ns = LEADER_9;
        else
          ns = IDLE;
   
      LEADER_9:
        if (irda_pos_pulse)   //leader 9ms check
          begin
            if (check_9ms)
              ns = LEADER_4;
            else
              ns = IDLE;
          end
        else  //完备的if---else--- ;防止生成latch
          ns =LEADER_9;
   
      LEADER_4:
        if (irda_neg_pulse)  // leader 4.5ms check
          begin
            if (check_4ms)
              ns = DATA_STATE;
            else
              ns = IDLE;
          end
        else
          ns = LEADER_4;
   
      DATA_STATE:
        if ((data_cnt == 6'd32) & irda_reg2 & irda_reg1)
          ns = IDLE;
        else if (error_flag)
          ns = IDLE;
        else
          ns = DATA_STATE;
      default:
        ns = IDLE;
    endcase

  //状态机中的输出,用时序电路来描述
  always @ (posedge clk)
    if (!rst_n)
      begin
        data_cnt <= 6'd0;
        get_data <= 32'd0;
        error_flag <= 1'b0;
      end
  
    else if (cs == IDLE)
      begin
        data_cnt <= 6'd0;
        get_data <= 32'd0;
        error_flag <= 1'b0;
      end
  
    else if (cs == DATA_STATE)
      begin
        if (irda_pos_pulse)  // low 0.56ms check
          begin
            if (!low)  //error
              error_flag <= 1'b1;
          end
        else if (irda_neg_pulse)  //check 0.56ms/1.68ms data 0/1
          begin
            if (low)
              get_data[0] <= 1'b0;
            else if (high)
              get_data[0] <= 1'b1;
            else
              error_flag <= 1'b1;
             
            get_data[31:1] <= get_data[30:0];
            data_cnt <= data_cnt + 1'b1;
          end
      end

  always @ (posedge clk)
    if (!rst_n)
      irda_data <= 16'd0;
    else if ((data_cnt ==6'd32) & irda_reg1)
  begin
   led1 <= get_data[7:0];  //数据反码
   led2 <= get_data[15:8]; //数据码
   led3 <= get_data[23:16];//用户码
   led4 <= get_data[31:24];
  end
 
//把遥控器的按下的键在数码管上面显示出来
always@(led2) 
begin
	case(led2)
	
	                     //在数码管上面显示0到9
        8'b01101000: //遥控板0的码值
			led_db=8'b1100_0000;  //显示0

		8'b00110000: //遥控板1的码值
			led_db=8'b1111_1001;  //显示1

		8'b00011000: //遥控板2的码值
			led_db=8'b1010_0100;  //显示2

		8'b01111010: //遥控板3的码值
			led_db=8'b1011_0000;  //显示3

		8'b00010000: //遥控板4的码值
			led_db=8'b1001_1001;  //显示4

		8'b00111000: //遥控板5的码值
			led_db=8'b1001_0010;  //显示5

		8'b01011010: //遥控板6的码值
			led_db=8'b1000_0010;  //显示6

		8'b01000010: //遥控板7的码值
			led_db=8'b1111_1000;  //显示7

		8'b01001010: //遥控板8的码值
			led_db=8'b1000_0000;  //显示8

		8'b01010010: //遥控板9的码值
			led_db=8'b1001_0000;  //显示9
			
	  //在没有按下键时，显示F
	   default: led_db=8'b1000_1110;

	 endcase
end

endmodule 


