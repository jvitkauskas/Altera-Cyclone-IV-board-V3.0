//Legal Notice: (C)2015 Altera Corporation. All rights reserved.  Your
//use of Altera Corporation's design tools, logic functions and other
//software and tools, and its AMPP partner logic functions, and any
//output files any of the foregoing (including device programming or
//simulation files), and any associated documentation or information are
//expressly subject to the terms and conditions of the Altera Program
//License Subscription Agreement or other applicable license agreement,
//including, without limitation, that your use is for the sole purpose
//of programming logic devices manufactured by Altera and sold by Altera
//or its authorized distributors.  Please refer to the applicable
//agreement for further details.

// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ads_nirq (
                  // inputs:
                   address,
                   chipselect,
                   clk,
                   in_port,
                   reset_n,
                   write_n,
                   writedata,

                  // outputs:
                   irq,
                   readdata
                )
;

  output           irq;
  output  [ 31: 0] readdata;
  input   [  1: 0] address;
  input            chipselect;
  input            clk;
  input            in_port;
  input            reset_n;
  input            write_n;
  input   [ 31: 0] writedata;

  wire             clk_en;
  reg              d1_data_in;
  reg              d2_data_in;
  wire             data_in;
  reg              edge_capture;
  wire             edge_capture_wr_strobe;
  wire             edge_detect;
  wire             irq;
  reg              irq_mask;
  wire             read_mux_out;
  reg     [ 31: 0] readdata;
  assign clk_en = 1;
  //s1, which is an e_avalon_slave
  assign read_mux_out = ({1 {(address == 0)}} & data_in) |
    ({1 {(address == 2)}} & irq_mask) |
    ({1 {(address == 3)}} & edge_capture);

  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          readdata <= 0;
      else if (clk_en)
          readdata <= {{{32 - 1}{1'b0}},read_mux_out};
    end


  assign data_in = in_port;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          irq_mask <= 0;
      else if (chipselect && ~write_n && (address == 2))
          irq_mask <= writedata;
    end


  assign irq = |(edge_capture & irq_mask);
  assign edge_capture_wr_strobe = chipselect && ~write_n && (address == 3);
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          edge_capture <= 0;
      else if (clk_en)
          if (edge_capture_wr_strobe && writedata[0])
              edge_capture <= 0;
          else if (edge_detect)
              edge_capture <= -1;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
        begin
          d1_data_in <= 0;
          d2_data_in <= 0;
        end
      else if (clk_en)
        begin
          d1_data_in <= data_in;
          d2_data_in <= d1_data_in;
        end
    end


  assign edge_detect = ~d1_data_in & d2_data_in;

endmodule

