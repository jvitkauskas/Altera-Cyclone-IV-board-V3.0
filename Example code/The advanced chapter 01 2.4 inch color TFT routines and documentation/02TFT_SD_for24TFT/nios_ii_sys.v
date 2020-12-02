//megafunction wizard: %Altera SOPC Builder%
//GENERATION: STANDARD
//VERSION: WM1.0


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

module ads_busy_s1_arbitrator (
                                // inputs:
                                 ads_busy_s1_readdata,
                                 clk,
                                 pipeline_bridge_0_m1_address_to_slave,
                                 pipeline_bridge_0_m1_burstcount,
                                 pipeline_bridge_0_m1_chipselect,
                                 pipeline_bridge_0_m1_latency_counter,
                                 pipeline_bridge_0_m1_read,
                                 pipeline_bridge_0_m1_write,
                                 reset_n,

                                // outputs:
                                 ads_busy_s1_address,
                                 ads_busy_s1_readdata_from_sa,
                                 ads_busy_s1_reset_n,
                                 d1_ads_busy_s1_end_xfer,
                                 pipeline_bridge_0_m1_granted_ads_busy_s1,
                                 pipeline_bridge_0_m1_qualified_request_ads_busy_s1,
                                 pipeline_bridge_0_m1_read_data_valid_ads_busy_s1,
                                 pipeline_bridge_0_m1_requests_ads_busy_s1
                              )
;

  output  [  1: 0] ads_busy_s1_address;
  output  [ 31: 0] ads_busy_s1_readdata_from_sa;
  output           ads_busy_s1_reset_n;
  output           d1_ads_busy_s1_end_xfer;
  output           pipeline_bridge_0_m1_granted_ads_busy_s1;
  output           pipeline_bridge_0_m1_qualified_request_ads_busy_s1;
  output           pipeline_bridge_0_m1_read_data_valid_ads_busy_s1;
  output           pipeline_bridge_0_m1_requests_ads_busy_s1;
  input   [ 31: 0] ads_busy_s1_readdata;
  input            clk;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input            reset_n;

  wire    [  1: 0] ads_busy_s1_address;
  wire             ads_busy_s1_allgrants;
  wire             ads_busy_s1_allow_new_arb_cycle;
  wire             ads_busy_s1_any_bursting_master_saved_grant;
  wire             ads_busy_s1_any_continuerequest;
  wire             ads_busy_s1_arb_counter_enable;
  reg              ads_busy_s1_arb_share_counter;
  wire             ads_busy_s1_arb_share_counter_next_value;
  wire             ads_busy_s1_arb_share_set_values;
  wire             ads_busy_s1_beginbursttransfer_internal;
  wire             ads_busy_s1_begins_xfer;
  wire             ads_busy_s1_end_xfer;
  wire             ads_busy_s1_firsttransfer;
  wire             ads_busy_s1_grant_vector;
  wire             ads_busy_s1_in_a_read_cycle;
  wire             ads_busy_s1_in_a_write_cycle;
  wire             ads_busy_s1_master_qreq_vector;
  wire             ads_busy_s1_non_bursting_master_requests;
  wire    [ 31: 0] ads_busy_s1_readdata_from_sa;
  reg              ads_busy_s1_reg_firsttransfer;
  wire             ads_busy_s1_reset_n;
  reg              ads_busy_s1_slavearbiterlockenable;
  wire             ads_busy_s1_slavearbiterlockenable2;
  wire             ads_busy_s1_unreg_firsttransfer;
  wire             ads_busy_s1_waits_for_read;
  wire             ads_busy_s1_waits_for_write;
  reg              d1_ads_busy_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_ads_busy_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_ads_busy_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ads_busy_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ads_busy_s1;
  wire             pipeline_bridge_0_m1_requests_ads_busy_s1;
  wire             pipeline_bridge_0_m1_saved_grant_ads_busy_s1;
  wire    [  8: 0] shifted_address_to_ads_busy_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_ads_busy_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~ads_busy_s1_end_xfer;
    end


  assign ads_busy_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_ads_busy_s1));
  //assign ads_busy_s1_readdata_from_sa = ads_busy_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ads_busy_s1_readdata_from_sa = ads_busy_s1_readdata;

  assign pipeline_bridge_0_m1_requests_ads_busy_s1 = (({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'h60) & pipeline_bridge_0_m1_chipselect) & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);
  //ads_busy_s1_arb_share_counter set values, which is an e_mux
  assign ads_busy_s1_arb_share_set_values = 1;

  //ads_busy_s1_non_bursting_master_requests mux, which is an e_mux
  assign ads_busy_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_ads_busy_s1;

  //ads_busy_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign ads_busy_s1_any_bursting_master_saved_grant = 0;

  //ads_busy_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign ads_busy_s1_arb_share_counter_next_value = ads_busy_s1_firsttransfer ? (ads_busy_s1_arb_share_set_values - 1) : |ads_busy_s1_arb_share_counter ? (ads_busy_s1_arb_share_counter - 1) : 0;

  //ads_busy_s1_allgrants all slave grants, which is an e_mux
  assign ads_busy_s1_allgrants = |ads_busy_s1_grant_vector;

  //ads_busy_s1_end_xfer assignment, which is an e_assign
  assign ads_busy_s1_end_xfer = ~(ads_busy_s1_waits_for_read | ads_busy_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_ads_busy_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_ads_busy_s1 = ads_busy_s1_end_xfer & (~ads_busy_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //ads_busy_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign ads_busy_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_ads_busy_s1 & ads_busy_s1_allgrants) | (end_xfer_arb_share_counter_term_ads_busy_s1 & ~ads_busy_s1_non_bursting_master_requests);

  //ads_busy_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_busy_s1_arb_share_counter <= 0;
      else if (ads_busy_s1_arb_counter_enable)
          ads_busy_s1_arb_share_counter <= ads_busy_s1_arb_share_counter_next_value;
    end


  //ads_busy_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_busy_s1_slavearbiterlockenable <= 0;
      else if ((|ads_busy_s1_master_qreq_vector & end_xfer_arb_share_counter_term_ads_busy_s1) | (end_xfer_arb_share_counter_term_ads_busy_s1 & ~ads_busy_s1_non_bursting_master_requests))
          ads_busy_s1_slavearbiterlockenable <= |ads_busy_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 ads_busy/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = ads_busy_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //ads_busy_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign ads_busy_s1_slavearbiterlockenable2 = |ads_busy_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 ads_busy/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = ads_busy_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //ads_busy_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign ads_busy_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_ads_busy_s1 = pipeline_bridge_0_m1_requests_ads_busy_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_ads_busy_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_ads_busy_s1 = pipeline_bridge_0_m1_granted_ads_busy_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~ads_busy_s1_waits_for_read;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_ads_busy_s1 = pipeline_bridge_0_m1_qualified_request_ads_busy_s1;

  //pipeline_bridge_0/m1 saved-grant ads_busy/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_ads_busy_s1 = pipeline_bridge_0_m1_requests_ads_busy_s1;

  //allow new arb cycle for ads_busy/s1, which is an e_assign
  assign ads_busy_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign ads_busy_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign ads_busy_s1_master_qreq_vector = 1;

  //ads_busy_s1_reset_n assignment, which is an e_assign
  assign ads_busy_s1_reset_n = reset_n;

  //ads_busy_s1_firsttransfer first transaction, which is an e_assign
  assign ads_busy_s1_firsttransfer = ads_busy_s1_begins_xfer ? ads_busy_s1_unreg_firsttransfer : ads_busy_s1_reg_firsttransfer;

  //ads_busy_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign ads_busy_s1_unreg_firsttransfer = ~(ads_busy_s1_slavearbiterlockenable & ads_busy_s1_any_continuerequest);

  //ads_busy_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_busy_s1_reg_firsttransfer <= 1'b1;
      else if (ads_busy_s1_begins_xfer)
          ads_busy_s1_reg_firsttransfer <= ads_busy_s1_unreg_firsttransfer;
    end


  //ads_busy_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign ads_busy_s1_beginbursttransfer_internal = ads_busy_s1_begins_xfer;

  assign shifted_address_to_ads_busy_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //ads_busy_s1_address mux, which is an e_mux
  assign ads_busy_s1_address = shifted_address_to_ads_busy_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_ads_busy_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_ads_busy_s1_end_xfer <= 1;
      else 
        d1_ads_busy_s1_end_xfer <= ads_busy_s1_end_xfer;
    end


  //ads_busy_s1_waits_for_read in a cycle, which is an e_mux
  assign ads_busy_s1_waits_for_read = ads_busy_s1_in_a_read_cycle & ads_busy_s1_begins_xfer;

  //ads_busy_s1_in_a_read_cycle assignment, which is an e_assign
  assign ads_busy_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_ads_busy_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ads_busy_s1_in_a_read_cycle;

  //ads_busy_s1_waits_for_write in a cycle, which is an e_mux
  assign ads_busy_s1_waits_for_write = ads_busy_s1_in_a_write_cycle & 0;

  //ads_busy_s1_in_a_write_cycle assignment, which is an e_assign
  assign ads_busy_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_ads_busy_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ads_busy_s1_in_a_write_cycle;

  assign wait_for_ads_busy_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //ads_busy/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_ads_busy_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave ads_busy/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ads_clk_s1_arbitrator (
                               // inputs:
                                ads_clk_s1_readdata,
                                clk,
                                pipeline_bridge_0_m1_address_to_slave,
                                pipeline_bridge_0_m1_burstcount,
                                pipeline_bridge_0_m1_chipselect,
                                pipeline_bridge_0_m1_latency_counter,
                                pipeline_bridge_0_m1_read,
                                pipeline_bridge_0_m1_write,
                                pipeline_bridge_0_m1_writedata,
                                reset_n,

                               // outputs:
                                ads_clk_s1_address,
                                ads_clk_s1_chipselect,
                                ads_clk_s1_readdata_from_sa,
                                ads_clk_s1_reset_n,
                                ads_clk_s1_write_n,
                                ads_clk_s1_writedata,
                                d1_ads_clk_s1_end_xfer,
                                pipeline_bridge_0_m1_granted_ads_clk_s1,
                                pipeline_bridge_0_m1_qualified_request_ads_clk_s1,
                                pipeline_bridge_0_m1_read_data_valid_ads_clk_s1,
                                pipeline_bridge_0_m1_requests_ads_clk_s1
                             )
;

  output  [  1: 0] ads_clk_s1_address;
  output           ads_clk_s1_chipselect;
  output  [ 31: 0] ads_clk_s1_readdata_from_sa;
  output           ads_clk_s1_reset_n;
  output           ads_clk_s1_write_n;
  output  [ 31: 0] ads_clk_s1_writedata;
  output           d1_ads_clk_s1_end_xfer;
  output           pipeline_bridge_0_m1_granted_ads_clk_s1;
  output           pipeline_bridge_0_m1_qualified_request_ads_clk_s1;
  output           pipeline_bridge_0_m1_read_data_valid_ads_clk_s1;
  output           pipeline_bridge_0_m1_requests_ads_clk_s1;
  input   [ 31: 0] ads_clk_s1_readdata;
  input            clk;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input   [ 31: 0] pipeline_bridge_0_m1_writedata;
  input            reset_n;

  wire    [  1: 0] ads_clk_s1_address;
  wire             ads_clk_s1_allgrants;
  wire             ads_clk_s1_allow_new_arb_cycle;
  wire             ads_clk_s1_any_bursting_master_saved_grant;
  wire             ads_clk_s1_any_continuerequest;
  wire             ads_clk_s1_arb_counter_enable;
  reg              ads_clk_s1_arb_share_counter;
  wire             ads_clk_s1_arb_share_counter_next_value;
  wire             ads_clk_s1_arb_share_set_values;
  wire             ads_clk_s1_beginbursttransfer_internal;
  wire             ads_clk_s1_begins_xfer;
  wire             ads_clk_s1_chipselect;
  wire             ads_clk_s1_end_xfer;
  wire             ads_clk_s1_firsttransfer;
  wire             ads_clk_s1_grant_vector;
  wire             ads_clk_s1_in_a_read_cycle;
  wire             ads_clk_s1_in_a_write_cycle;
  wire             ads_clk_s1_master_qreq_vector;
  wire             ads_clk_s1_non_bursting_master_requests;
  wire    [ 31: 0] ads_clk_s1_readdata_from_sa;
  reg              ads_clk_s1_reg_firsttransfer;
  wire             ads_clk_s1_reset_n;
  reg              ads_clk_s1_slavearbiterlockenable;
  wire             ads_clk_s1_slavearbiterlockenable2;
  wire             ads_clk_s1_unreg_firsttransfer;
  wire             ads_clk_s1_waits_for_read;
  wire             ads_clk_s1_waits_for_write;
  wire             ads_clk_s1_write_n;
  wire    [ 31: 0] ads_clk_s1_writedata;
  reg              d1_ads_clk_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_ads_clk_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_ads_clk_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ads_clk_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ads_clk_s1;
  wire             pipeline_bridge_0_m1_requests_ads_clk_s1;
  wire             pipeline_bridge_0_m1_saved_grant_ads_clk_s1;
  wire    [  8: 0] shifted_address_to_ads_clk_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_ads_clk_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~ads_clk_s1_end_xfer;
    end


  assign ads_clk_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_ads_clk_s1));
  //assign ads_clk_s1_readdata_from_sa = ads_clk_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ads_clk_s1_readdata_from_sa = ads_clk_s1_readdata;

  assign pipeline_bridge_0_m1_requests_ads_clk_s1 = ({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'h80) & pipeline_bridge_0_m1_chipselect;
  //ads_clk_s1_arb_share_counter set values, which is an e_mux
  assign ads_clk_s1_arb_share_set_values = 1;

  //ads_clk_s1_non_bursting_master_requests mux, which is an e_mux
  assign ads_clk_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_ads_clk_s1;

  //ads_clk_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign ads_clk_s1_any_bursting_master_saved_grant = 0;

  //ads_clk_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign ads_clk_s1_arb_share_counter_next_value = ads_clk_s1_firsttransfer ? (ads_clk_s1_arb_share_set_values - 1) : |ads_clk_s1_arb_share_counter ? (ads_clk_s1_arb_share_counter - 1) : 0;

  //ads_clk_s1_allgrants all slave grants, which is an e_mux
  assign ads_clk_s1_allgrants = |ads_clk_s1_grant_vector;

  //ads_clk_s1_end_xfer assignment, which is an e_assign
  assign ads_clk_s1_end_xfer = ~(ads_clk_s1_waits_for_read | ads_clk_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_ads_clk_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_ads_clk_s1 = ads_clk_s1_end_xfer & (~ads_clk_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //ads_clk_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign ads_clk_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_ads_clk_s1 & ads_clk_s1_allgrants) | (end_xfer_arb_share_counter_term_ads_clk_s1 & ~ads_clk_s1_non_bursting_master_requests);

  //ads_clk_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_clk_s1_arb_share_counter <= 0;
      else if (ads_clk_s1_arb_counter_enable)
          ads_clk_s1_arb_share_counter <= ads_clk_s1_arb_share_counter_next_value;
    end


  //ads_clk_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_clk_s1_slavearbiterlockenable <= 0;
      else if ((|ads_clk_s1_master_qreq_vector & end_xfer_arb_share_counter_term_ads_clk_s1) | (end_xfer_arb_share_counter_term_ads_clk_s1 & ~ads_clk_s1_non_bursting_master_requests))
          ads_clk_s1_slavearbiterlockenable <= |ads_clk_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 ads_clk/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = ads_clk_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //ads_clk_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign ads_clk_s1_slavearbiterlockenable2 = |ads_clk_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 ads_clk/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = ads_clk_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //ads_clk_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign ads_clk_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_ads_clk_s1 = pipeline_bridge_0_m1_requests_ads_clk_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_ads_clk_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_ads_clk_s1 = pipeline_bridge_0_m1_granted_ads_clk_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~ads_clk_s1_waits_for_read;

  //ads_clk_s1_writedata mux, which is an e_mux
  assign ads_clk_s1_writedata = pipeline_bridge_0_m1_writedata;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_ads_clk_s1 = pipeline_bridge_0_m1_qualified_request_ads_clk_s1;

  //pipeline_bridge_0/m1 saved-grant ads_clk/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_ads_clk_s1 = pipeline_bridge_0_m1_requests_ads_clk_s1;

  //allow new arb cycle for ads_clk/s1, which is an e_assign
  assign ads_clk_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign ads_clk_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign ads_clk_s1_master_qreq_vector = 1;

  //ads_clk_s1_reset_n assignment, which is an e_assign
  assign ads_clk_s1_reset_n = reset_n;

  assign ads_clk_s1_chipselect = pipeline_bridge_0_m1_granted_ads_clk_s1;
  //ads_clk_s1_firsttransfer first transaction, which is an e_assign
  assign ads_clk_s1_firsttransfer = ads_clk_s1_begins_xfer ? ads_clk_s1_unreg_firsttransfer : ads_clk_s1_reg_firsttransfer;

  //ads_clk_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign ads_clk_s1_unreg_firsttransfer = ~(ads_clk_s1_slavearbiterlockenable & ads_clk_s1_any_continuerequest);

  //ads_clk_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_clk_s1_reg_firsttransfer <= 1'b1;
      else if (ads_clk_s1_begins_xfer)
          ads_clk_s1_reg_firsttransfer <= ads_clk_s1_unreg_firsttransfer;
    end


  //ads_clk_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign ads_clk_s1_beginbursttransfer_internal = ads_clk_s1_begins_xfer;

  //~ads_clk_s1_write_n assignment, which is an e_mux
  assign ads_clk_s1_write_n = ~(pipeline_bridge_0_m1_granted_ads_clk_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect));

  assign shifted_address_to_ads_clk_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //ads_clk_s1_address mux, which is an e_mux
  assign ads_clk_s1_address = shifted_address_to_ads_clk_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_ads_clk_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_ads_clk_s1_end_xfer <= 1;
      else 
        d1_ads_clk_s1_end_xfer <= ads_clk_s1_end_xfer;
    end


  //ads_clk_s1_waits_for_read in a cycle, which is an e_mux
  assign ads_clk_s1_waits_for_read = ads_clk_s1_in_a_read_cycle & ads_clk_s1_begins_xfer;

  //ads_clk_s1_in_a_read_cycle assignment, which is an e_assign
  assign ads_clk_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_ads_clk_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ads_clk_s1_in_a_read_cycle;

  //ads_clk_s1_waits_for_write in a cycle, which is an e_mux
  assign ads_clk_s1_waits_for_write = ads_clk_s1_in_a_write_cycle & 0;

  //ads_clk_s1_in_a_write_cycle assignment, which is an e_assign
  assign ads_clk_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_ads_clk_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ads_clk_s1_in_a_write_cycle;

  assign wait_for_ads_clk_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //ads_clk/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_ads_clk_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave ads_clk/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ads_din_s1_arbitrator (
                               // inputs:
                                ads_din_s1_readdata,
                                clk,
                                pipeline_bridge_0_m1_address_to_slave,
                                pipeline_bridge_0_m1_burstcount,
                                pipeline_bridge_0_m1_chipselect,
                                pipeline_bridge_0_m1_latency_counter,
                                pipeline_bridge_0_m1_read,
                                pipeline_bridge_0_m1_write,
                                pipeline_bridge_0_m1_writedata,
                                reset_n,

                               // outputs:
                                ads_din_s1_address,
                                ads_din_s1_chipselect,
                                ads_din_s1_readdata_from_sa,
                                ads_din_s1_reset_n,
                                ads_din_s1_write_n,
                                ads_din_s1_writedata,
                                d1_ads_din_s1_end_xfer,
                                pipeline_bridge_0_m1_granted_ads_din_s1,
                                pipeline_bridge_0_m1_qualified_request_ads_din_s1,
                                pipeline_bridge_0_m1_read_data_valid_ads_din_s1,
                                pipeline_bridge_0_m1_requests_ads_din_s1
                             )
;

  output  [  1: 0] ads_din_s1_address;
  output           ads_din_s1_chipselect;
  output  [ 31: 0] ads_din_s1_readdata_from_sa;
  output           ads_din_s1_reset_n;
  output           ads_din_s1_write_n;
  output  [ 31: 0] ads_din_s1_writedata;
  output           d1_ads_din_s1_end_xfer;
  output           pipeline_bridge_0_m1_granted_ads_din_s1;
  output           pipeline_bridge_0_m1_qualified_request_ads_din_s1;
  output           pipeline_bridge_0_m1_read_data_valid_ads_din_s1;
  output           pipeline_bridge_0_m1_requests_ads_din_s1;
  input   [ 31: 0] ads_din_s1_readdata;
  input            clk;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input   [ 31: 0] pipeline_bridge_0_m1_writedata;
  input            reset_n;

  wire    [  1: 0] ads_din_s1_address;
  wire             ads_din_s1_allgrants;
  wire             ads_din_s1_allow_new_arb_cycle;
  wire             ads_din_s1_any_bursting_master_saved_grant;
  wire             ads_din_s1_any_continuerequest;
  wire             ads_din_s1_arb_counter_enable;
  reg              ads_din_s1_arb_share_counter;
  wire             ads_din_s1_arb_share_counter_next_value;
  wire             ads_din_s1_arb_share_set_values;
  wire             ads_din_s1_beginbursttransfer_internal;
  wire             ads_din_s1_begins_xfer;
  wire             ads_din_s1_chipselect;
  wire             ads_din_s1_end_xfer;
  wire             ads_din_s1_firsttransfer;
  wire             ads_din_s1_grant_vector;
  wire             ads_din_s1_in_a_read_cycle;
  wire             ads_din_s1_in_a_write_cycle;
  wire             ads_din_s1_master_qreq_vector;
  wire             ads_din_s1_non_bursting_master_requests;
  wire    [ 31: 0] ads_din_s1_readdata_from_sa;
  reg              ads_din_s1_reg_firsttransfer;
  wire             ads_din_s1_reset_n;
  reg              ads_din_s1_slavearbiterlockenable;
  wire             ads_din_s1_slavearbiterlockenable2;
  wire             ads_din_s1_unreg_firsttransfer;
  wire             ads_din_s1_waits_for_read;
  wire             ads_din_s1_waits_for_write;
  wire             ads_din_s1_write_n;
  wire    [ 31: 0] ads_din_s1_writedata;
  reg              d1_ads_din_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_ads_din_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_ads_din_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ads_din_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ads_din_s1;
  wire             pipeline_bridge_0_m1_requests_ads_din_s1;
  wire             pipeline_bridge_0_m1_saved_grant_ads_din_s1;
  wire    [  8: 0] shifted_address_to_ads_din_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_ads_din_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~ads_din_s1_end_xfer;
    end


  assign ads_din_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_ads_din_s1));
  //assign ads_din_s1_readdata_from_sa = ads_din_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ads_din_s1_readdata_from_sa = ads_din_s1_readdata;

  assign pipeline_bridge_0_m1_requests_ads_din_s1 = ({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'ha0) & pipeline_bridge_0_m1_chipselect;
  //ads_din_s1_arb_share_counter set values, which is an e_mux
  assign ads_din_s1_arb_share_set_values = 1;

  //ads_din_s1_non_bursting_master_requests mux, which is an e_mux
  assign ads_din_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_ads_din_s1;

  //ads_din_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign ads_din_s1_any_bursting_master_saved_grant = 0;

  //ads_din_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign ads_din_s1_arb_share_counter_next_value = ads_din_s1_firsttransfer ? (ads_din_s1_arb_share_set_values - 1) : |ads_din_s1_arb_share_counter ? (ads_din_s1_arb_share_counter - 1) : 0;

  //ads_din_s1_allgrants all slave grants, which is an e_mux
  assign ads_din_s1_allgrants = |ads_din_s1_grant_vector;

  //ads_din_s1_end_xfer assignment, which is an e_assign
  assign ads_din_s1_end_xfer = ~(ads_din_s1_waits_for_read | ads_din_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_ads_din_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_ads_din_s1 = ads_din_s1_end_xfer & (~ads_din_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //ads_din_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign ads_din_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_ads_din_s1 & ads_din_s1_allgrants) | (end_xfer_arb_share_counter_term_ads_din_s1 & ~ads_din_s1_non_bursting_master_requests);

  //ads_din_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_din_s1_arb_share_counter <= 0;
      else if (ads_din_s1_arb_counter_enable)
          ads_din_s1_arb_share_counter <= ads_din_s1_arb_share_counter_next_value;
    end


  //ads_din_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_din_s1_slavearbiterlockenable <= 0;
      else if ((|ads_din_s1_master_qreq_vector & end_xfer_arb_share_counter_term_ads_din_s1) | (end_xfer_arb_share_counter_term_ads_din_s1 & ~ads_din_s1_non_bursting_master_requests))
          ads_din_s1_slavearbiterlockenable <= |ads_din_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 ads_din/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = ads_din_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //ads_din_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign ads_din_s1_slavearbiterlockenable2 = |ads_din_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 ads_din/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = ads_din_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //ads_din_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign ads_din_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_ads_din_s1 = pipeline_bridge_0_m1_requests_ads_din_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_ads_din_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_ads_din_s1 = pipeline_bridge_0_m1_granted_ads_din_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~ads_din_s1_waits_for_read;

  //ads_din_s1_writedata mux, which is an e_mux
  assign ads_din_s1_writedata = pipeline_bridge_0_m1_writedata;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_ads_din_s1 = pipeline_bridge_0_m1_qualified_request_ads_din_s1;

  //pipeline_bridge_0/m1 saved-grant ads_din/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_ads_din_s1 = pipeline_bridge_0_m1_requests_ads_din_s1;

  //allow new arb cycle for ads_din/s1, which is an e_assign
  assign ads_din_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign ads_din_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign ads_din_s1_master_qreq_vector = 1;

  //ads_din_s1_reset_n assignment, which is an e_assign
  assign ads_din_s1_reset_n = reset_n;

  assign ads_din_s1_chipselect = pipeline_bridge_0_m1_granted_ads_din_s1;
  //ads_din_s1_firsttransfer first transaction, which is an e_assign
  assign ads_din_s1_firsttransfer = ads_din_s1_begins_xfer ? ads_din_s1_unreg_firsttransfer : ads_din_s1_reg_firsttransfer;

  //ads_din_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign ads_din_s1_unreg_firsttransfer = ~(ads_din_s1_slavearbiterlockenable & ads_din_s1_any_continuerequest);

  //ads_din_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_din_s1_reg_firsttransfer <= 1'b1;
      else if (ads_din_s1_begins_xfer)
          ads_din_s1_reg_firsttransfer <= ads_din_s1_unreg_firsttransfer;
    end


  //ads_din_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign ads_din_s1_beginbursttransfer_internal = ads_din_s1_begins_xfer;

  //~ads_din_s1_write_n assignment, which is an e_mux
  assign ads_din_s1_write_n = ~(pipeline_bridge_0_m1_granted_ads_din_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect));

  assign shifted_address_to_ads_din_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //ads_din_s1_address mux, which is an e_mux
  assign ads_din_s1_address = shifted_address_to_ads_din_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_ads_din_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_ads_din_s1_end_xfer <= 1;
      else 
        d1_ads_din_s1_end_xfer <= ads_din_s1_end_xfer;
    end


  //ads_din_s1_waits_for_read in a cycle, which is an e_mux
  assign ads_din_s1_waits_for_read = ads_din_s1_in_a_read_cycle & ads_din_s1_begins_xfer;

  //ads_din_s1_in_a_read_cycle assignment, which is an e_assign
  assign ads_din_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_ads_din_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ads_din_s1_in_a_read_cycle;

  //ads_din_s1_waits_for_write in a cycle, which is an e_mux
  assign ads_din_s1_waits_for_write = ads_din_s1_in_a_write_cycle & 0;

  //ads_din_s1_in_a_write_cycle assignment, which is an e_assign
  assign ads_din_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_ads_din_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ads_din_s1_in_a_write_cycle;

  assign wait_for_ads_din_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //ads_din/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_ads_din_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave ads_din/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ads_dout_s1_arbitrator (
                                // inputs:
                                 ads_dout_s1_readdata,
                                 clk,
                                 pipeline_bridge_0_m1_address_to_slave,
                                 pipeline_bridge_0_m1_burstcount,
                                 pipeline_bridge_0_m1_chipselect,
                                 pipeline_bridge_0_m1_latency_counter,
                                 pipeline_bridge_0_m1_read,
                                 pipeline_bridge_0_m1_write,
                                 reset_n,

                                // outputs:
                                 ads_dout_s1_address,
                                 ads_dout_s1_readdata_from_sa,
                                 ads_dout_s1_reset_n,
                                 d1_ads_dout_s1_end_xfer,
                                 pipeline_bridge_0_m1_granted_ads_dout_s1,
                                 pipeline_bridge_0_m1_qualified_request_ads_dout_s1,
                                 pipeline_bridge_0_m1_read_data_valid_ads_dout_s1,
                                 pipeline_bridge_0_m1_requests_ads_dout_s1
                              )
;

  output  [  1: 0] ads_dout_s1_address;
  output  [ 31: 0] ads_dout_s1_readdata_from_sa;
  output           ads_dout_s1_reset_n;
  output           d1_ads_dout_s1_end_xfer;
  output           pipeline_bridge_0_m1_granted_ads_dout_s1;
  output           pipeline_bridge_0_m1_qualified_request_ads_dout_s1;
  output           pipeline_bridge_0_m1_read_data_valid_ads_dout_s1;
  output           pipeline_bridge_0_m1_requests_ads_dout_s1;
  input   [ 31: 0] ads_dout_s1_readdata;
  input            clk;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input            reset_n;

  wire    [  1: 0] ads_dout_s1_address;
  wire             ads_dout_s1_allgrants;
  wire             ads_dout_s1_allow_new_arb_cycle;
  wire             ads_dout_s1_any_bursting_master_saved_grant;
  wire             ads_dout_s1_any_continuerequest;
  wire             ads_dout_s1_arb_counter_enable;
  reg              ads_dout_s1_arb_share_counter;
  wire             ads_dout_s1_arb_share_counter_next_value;
  wire             ads_dout_s1_arb_share_set_values;
  wire             ads_dout_s1_beginbursttransfer_internal;
  wire             ads_dout_s1_begins_xfer;
  wire             ads_dout_s1_end_xfer;
  wire             ads_dout_s1_firsttransfer;
  wire             ads_dout_s1_grant_vector;
  wire             ads_dout_s1_in_a_read_cycle;
  wire             ads_dout_s1_in_a_write_cycle;
  wire             ads_dout_s1_master_qreq_vector;
  wire             ads_dout_s1_non_bursting_master_requests;
  wire    [ 31: 0] ads_dout_s1_readdata_from_sa;
  reg              ads_dout_s1_reg_firsttransfer;
  wire             ads_dout_s1_reset_n;
  reg              ads_dout_s1_slavearbiterlockenable;
  wire             ads_dout_s1_slavearbiterlockenable2;
  wire             ads_dout_s1_unreg_firsttransfer;
  wire             ads_dout_s1_waits_for_read;
  wire             ads_dout_s1_waits_for_write;
  reg              d1_ads_dout_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_ads_dout_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_ads_dout_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ads_dout_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ads_dout_s1;
  wire             pipeline_bridge_0_m1_requests_ads_dout_s1;
  wire             pipeline_bridge_0_m1_saved_grant_ads_dout_s1;
  wire    [  8: 0] shifted_address_to_ads_dout_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_ads_dout_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~ads_dout_s1_end_xfer;
    end


  assign ads_dout_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_ads_dout_s1));
  //assign ads_dout_s1_readdata_from_sa = ads_dout_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ads_dout_s1_readdata_from_sa = ads_dout_s1_readdata;

  assign pipeline_bridge_0_m1_requests_ads_dout_s1 = (({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'h90) & pipeline_bridge_0_m1_chipselect) & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);
  //ads_dout_s1_arb_share_counter set values, which is an e_mux
  assign ads_dout_s1_arb_share_set_values = 1;

  //ads_dout_s1_non_bursting_master_requests mux, which is an e_mux
  assign ads_dout_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_ads_dout_s1;

  //ads_dout_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign ads_dout_s1_any_bursting_master_saved_grant = 0;

  //ads_dout_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign ads_dout_s1_arb_share_counter_next_value = ads_dout_s1_firsttransfer ? (ads_dout_s1_arb_share_set_values - 1) : |ads_dout_s1_arb_share_counter ? (ads_dout_s1_arb_share_counter - 1) : 0;

  //ads_dout_s1_allgrants all slave grants, which is an e_mux
  assign ads_dout_s1_allgrants = |ads_dout_s1_grant_vector;

  //ads_dout_s1_end_xfer assignment, which is an e_assign
  assign ads_dout_s1_end_xfer = ~(ads_dout_s1_waits_for_read | ads_dout_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_ads_dout_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_ads_dout_s1 = ads_dout_s1_end_xfer & (~ads_dout_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //ads_dout_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign ads_dout_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_ads_dout_s1 & ads_dout_s1_allgrants) | (end_xfer_arb_share_counter_term_ads_dout_s1 & ~ads_dout_s1_non_bursting_master_requests);

  //ads_dout_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_dout_s1_arb_share_counter <= 0;
      else if (ads_dout_s1_arb_counter_enable)
          ads_dout_s1_arb_share_counter <= ads_dout_s1_arb_share_counter_next_value;
    end


  //ads_dout_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_dout_s1_slavearbiterlockenable <= 0;
      else if ((|ads_dout_s1_master_qreq_vector & end_xfer_arb_share_counter_term_ads_dout_s1) | (end_xfer_arb_share_counter_term_ads_dout_s1 & ~ads_dout_s1_non_bursting_master_requests))
          ads_dout_s1_slavearbiterlockenable <= |ads_dout_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 ads_dout/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = ads_dout_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //ads_dout_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign ads_dout_s1_slavearbiterlockenable2 = |ads_dout_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 ads_dout/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = ads_dout_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //ads_dout_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign ads_dout_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_ads_dout_s1 = pipeline_bridge_0_m1_requests_ads_dout_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_ads_dout_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_ads_dout_s1 = pipeline_bridge_0_m1_granted_ads_dout_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~ads_dout_s1_waits_for_read;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_ads_dout_s1 = pipeline_bridge_0_m1_qualified_request_ads_dout_s1;

  //pipeline_bridge_0/m1 saved-grant ads_dout/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_ads_dout_s1 = pipeline_bridge_0_m1_requests_ads_dout_s1;

  //allow new arb cycle for ads_dout/s1, which is an e_assign
  assign ads_dout_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign ads_dout_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign ads_dout_s1_master_qreq_vector = 1;

  //ads_dout_s1_reset_n assignment, which is an e_assign
  assign ads_dout_s1_reset_n = reset_n;

  //ads_dout_s1_firsttransfer first transaction, which is an e_assign
  assign ads_dout_s1_firsttransfer = ads_dout_s1_begins_xfer ? ads_dout_s1_unreg_firsttransfer : ads_dout_s1_reg_firsttransfer;

  //ads_dout_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign ads_dout_s1_unreg_firsttransfer = ~(ads_dout_s1_slavearbiterlockenable & ads_dout_s1_any_continuerequest);

  //ads_dout_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_dout_s1_reg_firsttransfer <= 1'b1;
      else if (ads_dout_s1_begins_xfer)
          ads_dout_s1_reg_firsttransfer <= ads_dout_s1_unreg_firsttransfer;
    end


  //ads_dout_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign ads_dout_s1_beginbursttransfer_internal = ads_dout_s1_begins_xfer;

  assign shifted_address_to_ads_dout_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //ads_dout_s1_address mux, which is an e_mux
  assign ads_dout_s1_address = shifted_address_to_ads_dout_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_ads_dout_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_ads_dout_s1_end_xfer <= 1;
      else 
        d1_ads_dout_s1_end_xfer <= ads_dout_s1_end_xfer;
    end


  //ads_dout_s1_waits_for_read in a cycle, which is an e_mux
  assign ads_dout_s1_waits_for_read = ads_dout_s1_in_a_read_cycle & ads_dout_s1_begins_xfer;

  //ads_dout_s1_in_a_read_cycle assignment, which is an e_assign
  assign ads_dout_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_ads_dout_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ads_dout_s1_in_a_read_cycle;

  //ads_dout_s1_waits_for_write in a cycle, which is an e_mux
  assign ads_dout_s1_waits_for_write = ads_dout_s1_in_a_write_cycle & 0;

  //ads_dout_s1_in_a_write_cycle assignment, which is an e_assign
  assign ads_dout_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_ads_dout_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ads_dout_s1_in_a_write_cycle;

  assign wait_for_ads_dout_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //ads_dout/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_ads_dout_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave ads_dout/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ads_ncs_s1_arbitrator (
                               // inputs:
                                ads_ncs_s1_readdata,
                                clk,
                                pipeline_bridge_0_m1_address_to_slave,
                                pipeline_bridge_0_m1_burstcount,
                                pipeline_bridge_0_m1_chipselect,
                                pipeline_bridge_0_m1_latency_counter,
                                pipeline_bridge_0_m1_read,
                                pipeline_bridge_0_m1_write,
                                pipeline_bridge_0_m1_writedata,
                                reset_n,

                               // outputs:
                                ads_ncs_s1_address,
                                ads_ncs_s1_chipselect,
                                ads_ncs_s1_readdata_from_sa,
                                ads_ncs_s1_reset_n,
                                ads_ncs_s1_write_n,
                                ads_ncs_s1_writedata,
                                d1_ads_ncs_s1_end_xfer,
                                pipeline_bridge_0_m1_granted_ads_ncs_s1,
                                pipeline_bridge_0_m1_qualified_request_ads_ncs_s1,
                                pipeline_bridge_0_m1_read_data_valid_ads_ncs_s1,
                                pipeline_bridge_0_m1_requests_ads_ncs_s1
                             )
;

  output  [  1: 0] ads_ncs_s1_address;
  output           ads_ncs_s1_chipselect;
  output  [ 31: 0] ads_ncs_s1_readdata_from_sa;
  output           ads_ncs_s1_reset_n;
  output           ads_ncs_s1_write_n;
  output  [ 31: 0] ads_ncs_s1_writedata;
  output           d1_ads_ncs_s1_end_xfer;
  output           pipeline_bridge_0_m1_granted_ads_ncs_s1;
  output           pipeline_bridge_0_m1_qualified_request_ads_ncs_s1;
  output           pipeline_bridge_0_m1_read_data_valid_ads_ncs_s1;
  output           pipeline_bridge_0_m1_requests_ads_ncs_s1;
  input   [ 31: 0] ads_ncs_s1_readdata;
  input            clk;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input   [ 31: 0] pipeline_bridge_0_m1_writedata;
  input            reset_n;

  wire    [  1: 0] ads_ncs_s1_address;
  wire             ads_ncs_s1_allgrants;
  wire             ads_ncs_s1_allow_new_arb_cycle;
  wire             ads_ncs_s1_any_bursting_master_saved_grant;
  wire             ads_ncs_s1_any_continuerequest;
  wire             ads_ncs_s1_arb_counter_enable;
  reg              ads_ncs_s1_arb_share_counter;
  wire             ads_ncs_s1_arb_share_counter_next_value;
  wire             ads_ncs_s1_arb_share_set_values;
  wire             ads_ncs_s1_beginbursttransfer_internal;
  wire             ads_ncs_s1_begins_xfer;
  wire             ads_ncs_s1_chipselect;
  wire             ads_ncs_s1_end_xfer;
  wire             ads_ncs_s1_firsttransfer;
  wire             ads_ncs_s1_grant_vector;
  wire             ads_ncs_s1_in_a_read_cycle;
  wire             ads_ncs_s1_in_a_write_cycle;
  wire             ads_ncs_s1_master_qreq_vector;
  wire             ads_ncs_s1_non_bursting_master_requests;
  wire    [ 31: 0] ads_ncs_s1_readdata_from_sa;
  reg              ads_ncs_s1_reg_firsttransfer;
  wire             ads_ncs_s1_reset_n;
  reg              ads_ncs_s1_slavearbiterlockenable;
  wire             ads_ncs_s1_slavearbiterlockenable2;
  wire             ads_ncs_s1_unreg_firsttransfer;
  wire             ads_ncs_s1_waits_for_read;
  wire             ads_ncs_s1_waits_for_write;
  wire             ads_ncs_s1_write_n;
  wire    [ 31: 0] ads_ncs_s1_writedata;
  reg              d1_ads_ncs_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_ads_ncs_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_ads_ncs_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ads_ncs_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ads_ncs_s1;
  wire             pipeline_bridge_0_m1_requests_ads_ncs_s1;
  wire             pipeline_bridge_0_m1_saved_grant_ads_ncs_s1;
  wire    [  8: 0] shifted_address_to_ads_ncs_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_ads_ncs_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~ads_ncs_s1_end_xfer;
    end


  assign ads_ncs_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_ads_ncs_s1));
  //assign ads_ncs_s1_readdata_from_sa = ads_ncs_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ads_ncs_s1_readdata_from_sa = ads_ncs_s1_readdata;

  assign pipeline_bridge_0_m1_requests_ads_ncs_s1 = ({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'hc0) & pipeline_bridge_0_m1_chipselect;
  //ads_ncs_s1_arb_share_counter set values, which is an e_mux
  assign ads_ncs_s1_arb_share_set_values = 1;

  //ads_ncs_s1_non_bursting_master_requests mux, which is an e_mux
  assign ads_ncs_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_ads_ncs_s1;

  //ads_ncs_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign ads_ncs_s1_any_bursting_master_saved_grant = 0;

  //ads_ncs_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign ads_ncs_s1_arb_share_counter_next_value = ads_ncs_s1_firsttransfer ? (ads_ncs_s1_arb_share_set_values - 1) : |ads_ncs_s1_arb_share_counter ? (ads_ncs_s1_arb_share_counter - 1) : 0;

  //ads_ncs_s1_allgrants all slave grants, which is an e_mux
  assign ads_ncs_s1_allgrants = |ads_ncs_s1_grant_vector;

  //ads_ncs_s1_end_xfer assignment, which is an e_assign
  assign ads_ncs_s1_end_xfer = ~(ads_ncs_s1_waits_for_read | ads_ncs_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_ads_ncs_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_ads_ncs_s1 = ads_ncs_s1_end_xfer & (~ads_ncs_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //ads_ncs_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign ads_ncs_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_ads_ncs_s1 & ads_ncs_s1_allgrants) | (end_xfer_arb_share_counter_term_ads_ncs_s1 & ~ads_ncs_s1_non_bursting_master_requests);

  //ads_ncs_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_ncs_s1_arb_share_counter <= 0;
      else if (ads_ncs_s1_arb_counter_enable)
          ads_ncs_s1_arb_share_counter <= ads_ncs_s1_arb_share_counter_next_value;
    end


  //ads_ncs_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_ncs_s1_slavearbiterlockenable <= 0;
      else if ((|ads_ncs_s1_master_qreq_vector & end_xfer_arb_share_counter_term_ads_ncs_s1) | (end_xfer_arb_share_counter_term_ads_ncs_s1 & ~ads_ncs_s1_non_bursting_master_requests))
          ads_ncs_s1_slavearbiterlockenable <= |ads_ncs_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 ads_ncs/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = ads_ncs_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //ads_ncs_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign ads_ncs_s1_slavearbiterlockenable2 = |ads_ncs_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 ads_ncs/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = ads_ncs_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //ads_ncs_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign ads_ncs_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_ads_ncs_s1 = pipeline_bridge_0_m1_requests_ads_ncs_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_ads_ncs_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_ads_ncs_s1 = pipeline_bridge_0_m1_granted_ads_ncs_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~ads_ncs_s1_waits_for_read;

  //ads_ncs_s1_writedata mux, which is an e_mux
  assign ads_ncs_s1_writedata = pipeline_bridge_0_m1_writedata;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_ads_ncs_s1 = pipeline_bridge_0_m1_qualified_request_ads_ncs_s1;

  //pipeline_bridge_0/m1 saved-grant ads_ncs/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_ads_ncs_s1 = pipeline_bridge_0_m1_requests_ads_ncs_s1;

  //allow new arb cycle for ads_ncs/s1, which is an e_assign
  assign ads_ncs_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign ads_ncs_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign ads_ncs_s1_master_qreq_vector = 1;

  //ads_ncs_s1_reset_n assignment, which is an e_assign
  assign ads_ncs_s1_reset_n = reset_n;

  assign ads_ncs_s1_chipselect = pipeline_bridge_0_m1_granted_ads_ncs_s1;
  //ads_ncs_s1_firsttransfer first transaction, which is an e_assign
  assign ads_ncs_s1_firsttransfer = ads_ncs_s1_begins_xfer ? ads_ncs_s1_unreg_firsttransfer : ads_ncs_s1_reg_firsttransfer;

  //ads_ncs_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign ads_ncs_s1_unreg_firsttransfer = ~(ads_ncs_s1_slavearbiterlockenable & ads_ncs_s1_any_continuerequest);

  //ads_ncs_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_ncs_s1_reg_firsttransfer <= 1'b1;
      else if (ads_ncs_s1_begins_xfer)
          ads_ncs_s1_reg_firsttransfer <= ads_ncs_s1_unreg_firsttransfer;
    end


  //ads_ncs_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign ads_ncs_s1_beginbursttransfer_internal = ads_ncs_s1_begins_xfer;

  //~ads_ncs_s1_write_n assignment, which is an e_mux
  assign ads_ncs_s1_write_n = ~(pipeline_bridge_0_m1_granted_ads_ncs_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect));

  assign shifted_address_to_ads_ncs_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //ads_ncs_s1_address mux, which is an e_mux
  assign ads_ncs_s1_address = shifted_address_to_ads_ncs_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_ads_ncs_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_ads_ncs_s1_end_xfer <= 1;
      else 
        d1_ads_ncs_s1_end_xfer <= ads_ncs_s1_end_xfer;
    end


  //ads_ncs_s1_waits_for_read in a cycle, which is an e_mux
  assign ads_ncs_s1_waits_for_read = ads_ncs_s1_in_a_read_cycle & ads_ncs_s1_begins_xfer;

  //ads_ncs_s1_in_a_read_cycle assignment, which is an e_assign
  assign ads_ncs_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_ads_ncs_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ads_ncs_s1_in_a_read_cycle;

  //ads_ncs_s1_waits_for_write in a cycle, which is an e_mux
  assign ads_ncs_s1_waits_for_write = ads_ncs_s1_in_a_write_cycle & 0;

  //ads_ncs_s1_in_a_write_cycle assignment, which is an e_assign
  assign ads_ncs_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_ads_ncs_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ads_ncs_s1_in_a_write_cycle;

  assign wait_for_ads_ncs_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //ads_ncs/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_ads_ncs_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave ads_ncs/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ads_nirq_s1_arbitrator (
                                // inputs:
                                 ads_nirq_s1_irq,
                                 ads_nirq_s1_readdata,
                                 clk,
                                 pipeline_bridge_0_m1_address_to_slave,
                                 pipeline_bridge_0_m1_burstcount,
                                 pipeline_bridge_0_m1_chipselect,
                                 pipeline_bridge_0_m1_latency_counter,
                                 pipeline_bridge_0_m1_read,
                                 pipeline_bridge_0_m1_write,
                                 pipeline_bridge_0_m1_writedata,
                                 reset_n,

                                // outputs:
                                 ads_nirq_s1_address,
                                 ads_nirq_s1_chipselect,
                                 ads_nirq_s1_irq_from_sa,
                                 ads_nirq_s1_readdata_from_sa,
                                 ads_nirq_s1_reset_n,
                                 ads_nirq_s1_write_n,
                                 ads_nirq_s1_writedata,
                                 d1_ads_nirq_s1_end_xfer,
                                 pipeline_bridge_0_m1_granted_ads_nirq_s1,
                                 pipeline_bridge_0_m1_qualified_request_ads_nirq_s1,
                                 pipeline_bridge_0_m1_read_data_valid_ads_nirq_s1,
                                 pipeline_bridge_0_m1_requests_ads_nirq_s1
                              )
;

  output  [  1: 0] ads_nirq_s1_address;
  output           ads_nirq_s1_chipselect;
  output           ads_nirq_s1_irq_from_sa;
  output  [ 31: 0] ads_nirq_s1_readdata_from_sa;
  output           ads_nirq_s1_reset_n;
  output           ads_nirq_s1_write_n;
  output  [ 31: 0] ads_nirq_s1_writedata;
  output           d1_ads_nirq_s1_end_xfer;
  output           pipeline_bridge_0_m1_granted_ads_nirq_s1;
  output           pipeline_bridge_0_m1_qualified_request_ads_nirq_s1;
  output           pipeline_bridge_0_m1_read_data_valid_ads_nirq_s1;
  output           pipeline_bridge_0_m1_requests_ads_nirq_s1;
  input            ads_nirq_s1_irq;
  input   [ 31: 0] ads_nirq_s1_readdata;
  input            clk;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input   [ 31: 0] pipeline_bridge_0_m1_writedata;
  input            reset_n;

  wire    [  1: 0] ads_nirq_s1_address;
  wire             ads_nirq_s1_allgrants;
  wire             ads_nirq_s1_allow_new_arb_cycle;
  wire             ads_nirq_s1_any_bursting_master_saved_grant;
  wire             ads_nirq_s1_any_continuerequest;
  wire             ads_nirq_s1_arb_counter_enable;
  reg              ads_nirq_s1_arb_share_counter;
  wire             ads_nirq_s1_arb_share_counter_next_value;
  wire             ads_nirq_s1_arb_share_set_values;
  wire             ads_nirq_s1_beginbursttransfer_internal;
  wire             ads_nirq_s1_begins_xfer;
  wire             ads_nirq_s1_chipselect;
  wire             ads_nirq_s1_end_xfer;
  wire             ads_nirq_s1_firsttransfer;
  wire             ads_nirq_s1_grant_vector;
  wire             ads_nirq_s1_in_a_read_cycle;
  wire             ads_nirq_s1_in_a_write_cycle;
  wire             ads_nirq_s1_irq_from_sa;
  wire             ads_nirq_s1_master_qreq_vector;
  wire             ads_nirq_s1_non_bursting_master_requests;
  wire    [ 31: 0] ads_nirq_s1_readdata_from_sa;
  reg              ads_nirq_s1_reg_firsttransfer;
  wire             ads_nirq_s1_reset_n;
  reg              ads_nirq_s1_slavearbiterlockenable;
  wire             ads_nirq_s1_slavearbiterlockenable2;
  wire             ads_nirq_s1_unreg_firsttransfer;
  wire             ads_nirq_s1_waits_for_read;
  wire             ads_nirq_s1_waits_for_write;
  wire             ads_nirq_s1_write_n;
  wire    [ 31: 0] ads_nirq_s1_writedata;
  reg              d1_ads_nirq_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_ads_nirq_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_ads_nirq_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ads_nirq_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ads_nirq_s1;
  wire             pipeline_bridge_0_m1_requests_ads_nirq_s1;
  wire             pipeline_bridge_0_m1_saved_grant_ads_nirq_s1;
  wire    [  8: 0] shifted_address_to_ads_nirq_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_ads_nirq_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~ads_nirq_s1_end_xfer;
    end


  assign ads_nirq_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_ads_nirq_s1));
  //assign ads_nirq_s1_readdata_from_sa = ads_nirq_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ads_nirq_s1_readdata_from_sa = ads_nirq_s1_readdata;

  assign pipeline_bridge_0_m1_requests_ads_nirq_s1 = ({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'hb0) & pipeline_bridge_0_m1_chipselect;
  //ads_nirq_s1_arb_share_counter set values, which is an e_mux
  assign ads_nirq_s1_arb_share_set_values = 1;

  //ads_nirq_s1_non_bursting_master_requests mux, which is an e_mux
  assign ads_nirq_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_ads_nirq_s1;

  //ads_nirq_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign ads_nirq_s1_any_bursting_master_saved_grant = 0;

  //ads_nirq_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign ads_nirq_s1_arb_share_counter_next_value = ads_nirq_s1_firsttransfer ? (ads_nirq_s1_arb_share_set_values - 1) : |ads_nirq_s1_arb_share_counter ? (ads_nirq_s1_arb_share_counter - 1) : 0;

  //ads_nirq_s1_allgrants all slave grants, which is an e_mux
  assign ads_nirq_s1_allgrants = |ads_nirq_s1_grant_vector;

  //ads_nirq_s1_end_xfer assignment, which is an e_assign
  assign ads_nirq_s1_end_xfer = ~(ads_nirq_s1_waits_for_read | ads_nirq_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_ads_nirq_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_ads_nirq_s1 = ads_nirq_s1_end_xfer & (~ads_nirq_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //ads_nirq_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign ads_nirq_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_ads_nirq_s1 & ads_nirq_s1_allgrants) | (end_xfer_arb_share_counter_term_ads_nirq_s1 & ~ads_nirq_s1_non_bursting_master_requests);

  //ads_nirq_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_nirq_s1_arb_share_counter <= 0;
      else if (ads_nirq_s1_arb_counter_enable)
          ads_nirq_s1_arb_share_counter <= ads_nirq_s1_arb_share_counter_next_value;
    end


  //ads_nirq_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_nirq_s1_slavearbiterlockenable <= 0;
      else if ((|ads_nirq_s1_master_qreq_vector & end_xfer_arb_share_counter_term_ads_nirq_s1) | (end_xfer_arb_share_counter_term_ads_nirq_s1 & ~ads_nirq_s1_non_bursting_master_requests))
          ads_nirq_s1_slavearbiterlockenable <= |ads_nirq_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 ads_nirq/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = ads_nirq_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //ads_nirq_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign ads_nirq_s1_slavearbiterlockenable2 = |ads_nirq_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 ads_nirq/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = ads_nirq_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //ads_nirq_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign ads_nirq_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_ads_nirq_s1 = pipeline_bridge_0_m1_requests_ads_nirq_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_ads_nirq_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_ads_nirq_s1 = pipeline_bridge_0_m1_granted_ads_nirq_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~ads_nirq_s1_waits_for_read;

  //ads_nirq_s1_writedata mux, which is an e_mux
  assign ads_nirq_s1_writedata = pipeline_bridge_0_m1_writedata;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_ads_nirq_s1 = pipeline_bridge_0_m1_qualified_request_ads_nirq_s1;

  //pipeline_bridge_0/m1 saved-grant ads_nirq/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_ads_nirq_s1 = pipeline_bridge_0_m1_requests_ads_nirq_s1;

  //allow new arb cycle for ads_nirq/s1, which is an e_assign
  assign ads_nirq_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign ads_nirq_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign ads_nirq_s1_master_qreq_vector = 1;

  //ads_nirq_s1_reset_n assignment, which is an e_assign
  assign ads_nirq_s1_reset_n = reset_n;

  assign ads_nirq_s1_chipselect = pipeline_bridge_0_m1_granted_ads_nirq_s1;
  //ads_nirq_s1_firsttransfer first transaction, which is an e_assign
  assign ads_nirq_s1_firsttransfer = ads_nirq_s1_begins_xfer ? ads_nirq_s1_unreg_firsttransfer : ads_nirq_s1_reg_firsttransfer;

  //ads_nirq_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign ads_nirq_s1_unreg_firsttransfer = ~(ads_nirq_s1_slavearbiterlockenable & ads_nirq_s1_any_continuerequest);

  //ads_nirq_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ads_nirq_s1_reg_firsttransfer <= 1'b1;
      else if (ads_nirq_s1_begins_xfer)
          ads_nirq_s1_reg_firsttransfer <= ads_nirq_s1_unreg_firsttransfer;
    end


  //ads_nirq_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign ads_nirq_s1_beginbursttransfer_internal = ads_nirq_s1_begins_xfer;

  //~ads_nirq_s1_write_n assignment, which is an e_mux
  assign ads_nirq_s1_write_n = ~(pipeline_bridge_0_m1_granted_ads_nirq_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect));

  assign shifted_address_to_ads_nirq_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //ads_nirq_s1_address mux, which is an e_mux
  assign ads_nirq_s1_address = shifted_address_to_ads_nirq_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_ads_nirq_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_ads_nirq_s1_end_xfer <= 1;
      else 
        d1_ads_nirq_s1_end_xfer <= ads_nirq_s1_end_xfer;
    end


  //ads_nirq_s1_waits_for_read in a cycle, which is an e_mux
  assign ads_nirq_s1_waits_for_read = ads_nirq_s1_in_a_read_cycle & ads_nirq_s1_begins_xfer;

  //ads_nirq_s1_in_a_read_cycle assignment, which is an e_assign
  assign ads_nirq_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_ads_nirq_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ads_nirq_s1_in_a_read_cycle;

  //ads_nirq_s1_waits_for_write in a cycle, which is an e_mux
  assign ads_nirq_s1_waits_for_write = ads_nirq_s1_in_a_write_cycle & 0;

  //ads_nirq_s1_in_a_write_cycle assignment, which is an e_assign
  assign ads_nirq_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_ads_nirq_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ads_nirq_s1_in_a_write_cycle;

  assign wait_for_ads_nirq_s1_counter = 0;
  //assign ads_nirq_s1_irq_from_sa = ads_nirq_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ads_nirq_s1_irq_from_sa = ads_nirq_s1_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //ads_nirq/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_ads_nirq_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave ads_nirq/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module epcs_epcs_control_port_arbitrator (
                                           // inputs:
                                            clk,
                                            epcs_epcs_control_port_dataavailable,
                                            epcs_epcs_control_port_endofpacket,
                                            epcs_epcs_control_port_irq,
                                            epcs_epcs_control_port_readdata,
                                            epcs_epcs_control_port_readyfordata,
                                            nios_f_data_master_address_to_slave,
                                            nios_f_data_master_read,
                                            nios_f_data_master_write,
                                            nios_f_data_master_writedata,
                                            nios_f_instruction_master_address_to_slave,
                                            nios_f_instruction_master_latency_counter,
                                            nios_f_instruction_master_read,
                                            nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register,
                                            nios_f_instruction_master_read_data_valid_sdram_s1_shift_register,
                                            reset_n,

                                           // outputs:
                                            d1_epcs_epcs_control_port_end_xfer,
                                            epcs_epcs_control_port_address,
                                            epcs_epcs_control_port_chipselect,
                                            epcs_epcs_control_port_dataavailable_from_sa,
                                            epcs_epcs_control_port_endofpacket_from_sa,
                                            epcs_epcs_control_port_irq_from_sa,
                                            epcs_epcs_control_port_read_n,
                                            epcs_epcs_control_port_readdata_from_sa,
                                            epcs_epcs_control_port_readyfordata_from_sa,
                                            epcs_epcs_control_port_reset_n,
                                            epcs_epcs_control_port_write_n,
                                            epcs_epcs_control_port_writedata,
                                            nios_f_data_master_granted_epcs_epcs_control_port,
                                            nios_f_data_master_qualified_request_epcs_epcs_control_port,
                                            nios_f_data_master_read_data_valid_epcs_epcs_control_port,
                                            nios_f_data_master_requests_epcs_epcs_control_port,
                                            nios_f_instruction_master_granted_epcs_epcs_control_port,
                                            nios_f_instruction_master_qualified_request_epcs_epcs_control_port,
                                            nios_f_instruction_master_read_data_valid_epcs_epcs_control_port,
                                            nios_f_instruction_master_requests_epcs_epcs_control_port
                                         )
;

  output           d1_epcs_epcs_control_port_end_xfer;
  output  [  8: 0] epcs_epcs_control_port_address;
  output           epcs_epcs_control_port_chipselect;
  output           epcs_epcs_control_port_dataavailable_from_sa;
  output           epcs_epcs_control_port_endofpacket_from_sa;
  output           epcs_epcs_control_port_irq_from_sa;
  output           epcs_epcs_control_port_read_n;
  output  [ 31: 0] epcs_epcs_control_port_readdata_from_sa;
  output           epcs_epcs_control_port_readyfordata_from_sa;
  output           epcs_epcs_control_port_reset_n;
  output           epcs_epcs_control_port_write_n;
  output  [ 31: 0] epcs_epcs_control_port_writedata;
  output           nios_f_data_master_granted_epcs_epcs_control_port;
  output           nios_f_data_master_qualified_request_epcs_epcs_control_port;
  output           nios_f_data_master_read_data_valid_epcs_epcs_control_port;
  output           nios_f_data_master_requests_epcs_epcs_control_port;
  output           nios_f_instruction_master_granted_epcs_epcs_control_port;
  output           nios_f_instruction_master_qualified_request_epcs_epcs_control_port;
  output           nios_f_instruction_master_read_data_valid_epcs_epcs_control_port;
  output           nios_f_instruction_master_requests_epcs_epcs_control_port;
  input            clk;
  input            epcs_epcs_control_port_dataavailable;
  input            epcs_epcs_control_port_endofpacket;
  input            epcs_epcs_control_port_irq;
  input   [ 31: 0] epcs_epcs_control_port_readdata;
  input            epcs_epcs_control_port_readyfordata;
  input   [ 25: 0] nios_f_data_master_address_to_slave;
  input            nios_f_data_master_read;
  input            nios_f_data_master_write;
  input   [ 31: 0] nios_f_data_master_writedata;
  input   [ 25: 0] nios_f_instruction_master_address_to_slave;
  input            nios_f_instruction_master_latency_counter;
  input            nios_f_instruction_master_read;
  input            nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register;
  input            nios_f_instruction_master_read_data_valid_sdram_s1_shift_register;
  input            reset_n;

  reg              d1_epcs_epcs_control_port_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_epcs_epcs_control_port;
  wire    [  8: 0] epcs_epcs_control_port_address;
  wire             epcs_epcs_control_port_allgrants;
  wire             epcs_epcs_control_port_allow_new_arb_cycle;
  wire             epcs_epcs_control_port_any_bursting_master_saved_grant;
  wire             epcs_epcs_control_port_any_continuerequest;
  reg     [  1: 0] epcs_epcs_control_port_arb_addend;
  wire             epcs_epcs_control_port_arb_counter_enable;
  reg     [  1: 0] epcs_epcs_control_port_arb_share_counter;
  wire    [  1: 0] epcs_epcs_control_port_arb_share_counter_next_value;
  wire    [  1: 0] epcs_epcs_control_port_arb_share_set_values;
  wire    [  1: 0] epcs_epcs_control_port_arb_winner;
  wire             epcs_epcs_control_port_arbitration_holdoff_internal;
  wire             epcs_epcs_control_port_beginbursttransfer_internal;
  wire             epcs_epcs_control_port_begins_xfer;
  wire             epcs_epcs_control_port_chipselect;
  wire    [  3: 0] epcs_epcs_control_port_chosen_master_double_vector;
  wire    [  1: 0] epcs_epcs_control_port_chosen_master_rot_left;
  wire             epcs_epcs_control_port_dataavailable_from_sa;
  wire             epcs_epcs_control_port_end_xfer;
  wire             epcs_epcs_control_port_endofpacket_from_sa;
  wire             epcs_epcs_control_port_firsttransfer;
  wire    [  1: 0] epcs_epcs_control_port_grant_vector;
  wire             epcs_epcs_control_port_in_a_read_cycle;
  wire             epcs_epcs_control_port_in_a_write_cycle;
  wire             epcs_epcs_control_port_irq_from_sa;
  wire    [  1: 0] epcs_epcs_control_port_master_qreq_vector;
  wire             epcs_epcs_control_port_non_bursting_master_requests;
  wire             epcs_epcs_control_port_read_n;
  wire    [ 31: 0] epcs_epcs_control_port_readdata_from_sa;
  wire             epcs_epcs_control_port_readyfordata_from_sa;
  reg              epcs_epcs_control_port_reg_firsttransfer;
  wire             epcs_epcs_control_port_reset_n;
  reg     [  1: 0] epcs_epcs_control_port_saved_chosen_master_vector;
  reg              epcs_epcs_control_port_slavearbiterlockenable;
  wire             epcs_epcs_control_port_slavearbiterlockenable2;
  wire             epcs_epcs_control_port_unreg_firsttransfer;
  wire             epcs_epcs_control_port_waits_for_read;
  wire             epcs_epcs_control_port_waits_for_write;
  wire             epcs_epcs_control_port_write_n;
  wire    [ 31: 0] epcs_epcs_control_port_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_nios_f_data_master_granted_slave_epcs_epcs_control_port;
  reg              last_cycle_nios_f_instruction_master_granted_slave_epcs_epcs_control_port;
  wire             nios_f_data_master_arbiterlock;
  wire             nios_f_data_master_arbiterlock2;
  wire             nios_f_data_master_continuerequest;
  wire             nios_f_data_master_granted_epcs_epcs_control_port;
  wire             nios_f_data_master_qualified_request_epcs_epcs_control_port;
  wire             nios_f_data_master_read_data_valid_epcs_epcs_control_port;
  wire             nios_f_data_master_requests_epcs_epcs_control_port;
  wire             nios_f_data_master_saved_grant_epcs_epcs_control_port;
  wire             nios_f_instruction_master_arbiterlock;
  wire             nios_f_instruction_master_arbiterlock2;
  wire             nios_f_instruction_master_continuerequest;
  wire             nios_f_instruction_master_granted_epcs_epcs_control_port;
  wire             nios_f_instruction_master_qualified_request_epcs_epcs_control_port;
  wire             nios_f_instruction_master_read_data_valid_epcs_epcs_control_port;
  wire             nios_f_instruction_master_requests_epcs_epcs_control_port;
  wire             nios_f_instruction_master_saved_grant_epcs_epcs_control_port;
  wire    [ 25: 0] shifted_address_to_epcs_epcs_control_port_from_nios_f_data_master;
  wire    [ 25: 0] shifted_address_to_epcs_epcs_control_port_from_nios_f_instruction_master;
  wire             wait_for_epcs_epcs_control_port_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~epcs_epcs_control_port_end_xfer;
    end


  assign epcs_epcs_control_port_begins_xfer = ~d1_reasons_to_wait & ((nios_f_data_master_qualified_request_epcs_epcs_control_port | nios_f_instruction_master_qualified_request_epcs_epcs_control_port));
  //assign epcs_epcs_control_port_readdata_from_sa = epcs_epcs_control_port_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_epcs_control_port_readdata_from_sa = epcs_epcs_control_port_readdata;

  assign nios_f_data_master_requests_epcs_epcs_control_port = ({nios_f_data_master_address_to_slave[25 : 11] , 11'b0} == 26'h3001800) & (nios_f_data_master_read | nios_f_data_master_write);
  //assign epcs_epcs_control_port_dataavailable_from_sa = epcs_epcs_control_port_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_epcs_control_port_dataavailable_from_sa = epcs_epcs_control_port_dataavailable;

  //assign epcs_epcs_control_port_readyfordata_from_sa = epcs_epcs_control_port_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_epcs_control_port_readyfordata_from_sa = epcs_epcs_control_port_readyfordata;

  //epcs_epcs_control_port_arb_share_counter set values, which is an e_mux
  assign epcs_epcs_control_port_arb_share_set_values = 1;

  //epcs_epcs_control_port_non_bursting_master_requests mux, which is an e_mux
  assign epcs_epcs_control_port_non_bursting_master_requests = nios_f_data_master_requests_epcs_epcs_control_port |
    nios_f_instruction_master_requests_epcs_epcs_control_port |
    nios_f_data_master_requests_epcs_epcs_control_port |
    nios_f_instruction_master_requests_epcs_epcs_control_port;

  //epcs_epcs_control_port_any_bursting_master_saved_grant mux, which is an e_mux
  assign epcs_epcs_control_port_any_bursting_master_saved_grant = 0;

  //epcs_epcs_control_port_arb_share_counter_next_value assignment, which is an e_assign
  assign epcs_epcs_control_port_arb_share_counter_next_value = epcs_epcs_control_port_firsttransfer ? (epcs_epcs_control_port_arb_share_set_values - 1) : |epcs_epcs_control_port_arb_share_counter ? (epcs_epcs_control_port_arb_share_counter - 1) : 0;

  //epcs_epcs_control_port_allgrants all slave grants, which is an e_mux
  assign epcs_epcs_control_port_allgrants = (|epcs_epcs_control_port_grant_vector) |
    (|epcs_epcs_control_port_grant_vector) |
    (|epcs_epcs_control_port_grant_vector) |
    (|epcs_epcs_control_port_grant_vector);

  //epcs_epcs_control_port_end_xfer assignment, which is an e_assign
  assign epcs_epcs_control_port_end_xfer = ~(epcs_epcs_control_port_waits_for_read | epcs_epcs_control_port_waits_for_write);

  //end_xfer_arb_share_counter_term_epcs_epcs_control_port arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_epcs_epcs_control_port = epcs_epcs_control_port_end_xfer & (~epcs_epcs_control_port_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //epcs_epcs_control_port_arb_share_counter arbitration counter enable, which is an e_assign
  assign epcs_epcs_control_port_arb_counter_enable = (end_xfer_arb_share_counter_term_epcs_epcs_control_port & epcs_epcs_control_port_allgrants) | (end_xfer_arb_share_counter_term_epcs_epcs_control_port & ~epcs_epcs_control_port_non_bursting_master_requests);

  //epcs_epcs_control_port_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          epcs_epcs_control_port_arb_share_counter <= 0;
      else if (epcs_epcs_control_port_arb_counter_enable)
          epcs_epcs_control_port_arb_share_counter <= epcs_epcs_control_port_arb_share_counter_next_value;
    end


  //epcs_epcs_control_port_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          epcs_epcs_control_port_slavearbiterlockenable <= 0;
      else if ((|epcs_epcs_control_port_master_qreq_vector & end_xfer_arb_share_counter_term_epcs_epcs_control_port) | (end_xfer_arb_share_counter_term_epcs_epcs_control_port & ~epcs_epcs_control_port_non_bursting_master_requests))
          epcs_epcs_control_port_slavearbiterlockenable <= |epcs_epcs_control_port_arb_share_counter_next_value;
    end


  //nios_f/data_master epcs/epcs_control_port arbiterlock, which is an e_assign
  assign nios_f_data_master_arbiterlock = epcs_epcs_control_port_slavearbiterlockenable & nios_f_data_master_continuerequest;

  //epcs_epcs_control_port_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign epcs_epcs_control_port_slavearbiterlockenable2 = |epcs_epcs_control_port_arb_share_counter_next_value;

  //nios_f/data_master epcs/epcs_control_port arbiterlock2, which is an e_assign
  assign nios_f_data_master_arbiterlock2 = epcs_epcs_control_port_slavearbiterlockenable2 & nios_f_data_master_continuerequest;

  //nios_f/instruction_master epcs/epcs_control_port arbiterlock, which is an e_assign
  assign nios_f_instruction_master_arbiterlock = epcs_epcs_control_port_slavearbiterlockenable & nios_f_instruction_master_continuerequest;

  //nios_f/instruction_master epcs/epcs_control_port arbiterlock2, which is an e_assign
  assign nios_f_instruction_master_arbiterlock2 = epcs_epcs_control_port_slavearbiterlockenable2 & nios_f_instruction_master_continuerequest;

  //nios_f/instruction_master granted epcs/epcs_control_port last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios_f_instruction_master_granted_slave_epcs_epcs_control_port <= 0;
      else 
        last_cycle_nios_f_instruction_master_granted_slave_epcs_epcs_control_port <= nios_f_instruction_master_saved_grant_epcs_epcs_control_port ? 1 : (epcs_epcs_control_port_arbitration_holdoff_internal | ~nios_f_instruction_master_requests_epcs_epcs_control_port) ? 0 : last_cycle_nios_f_instruction_master_granted_slave_epcs_epcs_control_port;
    end


  //nios_f_instruction_master_continuerequest continued request, which is an e_mux
  assign nios_f_instruction_master_continuerequest = last_cycle_nios_f_instruction_master_granted_slave_epcs_epcs_control_port & nios_f_instruction_master_requests_epcs_epcs_control_port;

  //epcs_epcs_control_port_any_continuerequest at least one master continues requesting, which is an e_mux
  assign epcs_epcs_control_port_any_continuerequest = nios_f_instruction_master_continuerequest |
    nios_f_data_master_continuerequest;

  assign nios_f_data_master_qualified_request_epcs_epcs_control_port = nios_f_data_master_requests_epcs_epcs_control_port & ~(nios_f_instruction_master_arbiterlock);
  //epcs_epcs_control_port_writedata mux, which is an e_mux
  assign epcs_epcs_control_port_writedata = nios_f_data_master_writedata;

  //assign epcs_epcs_control_port_endofpacket_from_sa = epcs_epcs_control_port_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_epcs_control_port_endofpacket_from_sa = epcs_epcs_control_port_endofpacket;

  assign nios_f_instruction_master_requests_epcs_epcs_control_port = (({nios_f_instruction_master_address_to_slave[25 : 11] , 11'b0} == 26'h3001800) & (nios_f_instruction_master_read)) & nios_f_instruction_master_read;
  //nios_f/data_master granted epcs/epcs_control_port last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios_f_data_master_granted_slave_epcs_epcs_control_port <= 0;
      else 
        last_cycle_nios_f_data_master_granted_slave_epcs_epcs_control_port <= nios_f_data_master_saved_grant_epcs_epcs_control_port ? 1 : (epcs_epcs_control_port_arbitration_holdoff_internal | ~nios_f_data_master_requests_epcs_epcs_control_port) ? 0 : last_cycle_nios_f_data_master_granted_slave_epcs_epcs_control_port;
    end


  //nios_f_data_master_continuerequest continued request, which is an e_mux
  assign nios_f_data_master_continuerequest = last_cycle_nios_f_data_master_granted_slave_epcs_epcs_control_port & nios_f_data_master_requests_epcs_epcs_control_port;

  assign nios_f_instruction_master_qualified_request_epcs_epcs_control_port = nios_f_instruction_master_requests_epcs_epcs_control_port & ~((nios_f_instruction_master_read & ((nios_f_instruction_master_latency_counter != 0) | (|nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register) | (|nios_f_instruction_master_read_data_valid_sdram_s1_shift_register))) | nios_f_data_master_arbiterlock);
  //local readdatavalid nios_f_instruction_master_read_data_valid_epcs_epcs_control_port, which is an e_mux
  assign nios_f_instruction_master_read_data_valid_epcs_epcs_control_port = nios_f_instruction_master_granted_epcs_epcs_control_port & nios_f_instruction_master_read & ~epcs_epcs_control_port_waits_for_read;

  //allow new arb cycle for epcs/epcs_control_port, which is an e_assign
  assign epcs_epcs_control_port_allow_new_arb_cycle = ~nios_f_data_master_arbiterlock & ~nios_f_instruction_master_arbiterlock;

  //nios_f/instruction_master assignment into master qualified-requests vector for epcs/epcs_control_port, which is an e_assign
  assign epcs_epcs_control_port_master_qreq_vector[0] = nios_f_instruction_master_qualified_request_epcs_epcs_control_port;

  //nios_f/instruction_master grant epcs/epcs_control_port, which is an e_assign
  assign nios_f_instruction_master_granted_epcs_epcs_control_port = epcs_epcs_control_port_grant_vector[0];

  //nios_f/instruction_master saved-grant epcs/epcs_control_port, which is an e_assign
  assign nios_f_instruction_master_saved_grant_epcs_epcs_control_port = epcs_epcs_control_port_arb_winner[0] && nios_f_instruction_master_requests_epcs_epcs_control_port;

  //nios_f/data_master assignment into master qualified-requests vector for epcs/epcs_control_port, which is an e_assign
  assign epcs_epcs_control_port_master_qreq_vector[1] = nios_f_data_master_qualified_request_epcs_epcs_control_port;

  //nios_f/data_master grant epcs/epcs_control_port, which is an e_assign
  assign nios_f_data_master_granted_epcs_epcs_control_port = epcs_epcs_control_port_grant_vector[1];

  //nios_f/data_master saved-grant epcs/epcs_control_port, which is an e_assign
  assign nios_f_data_master_saved_grant_epcs_epcs_control_port = epcs_epcs_control_port_arb_winner[1] && nios_f_data_master_requests_epcs_epcs_control_port;

  //epcs/epcs_control_port chosen-master double-vector, which is an e_assign
  assign epcs_epcs_control_port_chosen_master_double_vector = {epcs_epcs_control_port_master_qreq_vector, epcs_epcs_control_port_master_qreq_vector} & ({~epcs_epcs_control_port_master_qreq_vector, ~epcs_epcs_control_port_master_qreq_vector} + epcs_epcs_control_port_arb_addend);

  //stable onehot encoding of arb winner
  assign epcs_epcs_control_port_arb_winner = (epcs_epcs_control_port_allow_new_arb_cycle & | epcs_epcs_control_port_grant_vector) ? epcs_epcs_control_port_grant_vector : epcs_epcs_control_port_saved_chosen_master_vector;

  //saved epcs_epcs_control_port_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          epcs_epcs_control_port_saved_chosen_master_vector <= 0;
      else if (epcs_epcs_control_port_allow_new_arb_cycle)
          epcs_epcs_control_port_saved_chosen_master_vector <= |epcs_epcs_control_port_grant_vector ? epcs_epcs_control_port_grant_vector : epcs_epcs_control_port_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign epcs_epcs_control_port_grant_vector = {(epcs_epcs_control_port_chosen_master_double_vector[1] | epcs_epcs_control_port_chosen_master_double_vector[3]),
    (epcs_epcs_control_port_chosen_master_double_vector[0] | epcs_epcs_control_port_chosen_master_double_vector[2])};

  //epcs/epcs_control_port chosen master rotated left, which is an e_assign
  assign epcs_epcs_control_port_chosen_master_rot_left = (epcs_epcs_control_port_arb_winner << 1) ? (epcs_epcs_control_port_arb_winner << 1) : 1;

  //epcs/epcs_control_port's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          epcs_epcs_control_port_arb_addend <= 1;
      else if (|epcs_epcs_control_port_grant_vector)
          epcs_epcs_control_port_arb_addend <= epcs_epcs_control_port_end_xfer? epcs_epcs_control_port_chosen_master_rot_left : epcs_epcs_control_port_grant_vector;
    end


  //epcs_epcs_control_port_reset_n assignment, which is an e_assign
  assign epcs_epcs_control_port_reset_n = reset_n;

  assign epcs_epcs_control_port_chipselect = nios_f_data_master_granted_epcs_epcs_control_port | nios_f_instruction_master_granted_epcs_epcs_control_port;
  //epcs_epcs_control_port_firsttransfer first transaction, which is an e_assign
  assign epcs_epcs_control_port_firsttransfer = epcs_epcs_control_port_begins_xfer ? epcs_epcs_control_port_unreg_firsttransfer : epcs_epcs_control_port_reg_firsttransfer;

  //epcs_epcs_control_port_unreg_firsttransfer first transaction, which is an e_assign
  assign epcs_epcs_control_port_unreg_firsttransfer = ~(epcs_epcs_control_port_slavearbiterlockenable & epcs_epcs_control_port_any_continuerequest);

  //epcs_epcs_control_port_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          epcs_epcs_control_port_reg_firsttransfer <= 1'b1;
      else if (epcs_epcs_control_port_begins_xfer)
          epcs_epcs_control_port_reg_firsttransfer <= epcs_epcs_control_port_unreg_firsttransfer;
    end


  //epcs_epcs_control_port_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign epcs_epcs_control_port_beginbursttransfer_internal = epcs_epcs_control_port_begins_xfer;

  //epcs_epcs_control_port_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign epcs_epcs_control_port_arbitration_holdoff_internal = epcs_epcs_control_port_begins_xfer & epcs_epcs_control_port_firsttransfer;

  //~epcs_epcs_control_port_read_n assignment, which is an e_mux
  assign epcs_epcs_control_port_read_n = ~((nios_f_data_master_granted_epcs_epcs_control_port & nios_f_data_master_read) | (nios_f_instruction_master_granted_epcs_epcs_control_port & nios_f_instruction_master_read));

  //~epcs_epcs_control_port_write_n assignment, which is an e_mux
  assign epcs_epcs_control_port_write_n = ~(nios_f_data_master_granted_epcs_epcs_control_port & nios_f_data_master_write);

  assign shifted_address_to_epcs_epcs_control_port_from_nios_f_data_master = nios_f_data_master_address_to_slave;
  //epcs_epcs_control_port_address mux, which is an e_mux
  assign epcs_epcs_control_port_address = (nios_f_data_master_granted_epcs_epcs_control_port)? (shifted_address_to_epcs_epcs_control_port_from_nios_f_data_master >> 2) :
    (shifted_address_to_epcs_epcs_control_port_from_nios_f_instruction_master >> 2);

  assign shifted_address_to_epcs_epcs_control_port_from_nios_f_instruction_master = nios_f_instruction_master_address_to_slave;
  //d1_epcs_epcs_control_port_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_epcs_epcs_control_port_end_xfer <= 1;
      else 
        d1_epcs_epcs_control_port_end_xfer <= epcs_epcs_control_port_end_xfer;
    end


  //epcs_epcs_control_port_waits_for_read in a cycle, which is an e_mux
  assign epcs_epcs_control_port_waits_for_read = epcs_epcs_control_port_in_a_read_cycle & epcs_epcs_control_port_begins_xfer;

  //epcs_epcs_control_port_in_a_read_cycle assignment, which is an e_assign
  assign epcs_epcs_control_port_in_a_read_cycle = (nios_f_data_master_granted_epcs_epcs_control_port & nios_f_data_master_read) | (nios_f_instruction_master_granted_epcs_epcs_control_port & nios_f_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = epcs_epcs_control_port_in_a_read_cycle;

  //epcs_epcs_control_port_waits_for_write in a cycle, which is an e_mux
  assign epcs_epcs_control_port_waits_for_write = epcs_epcs_control_port_in_a_write_cycle & epcs_epcs_control_port_begins_xfer;

  //epcs_epcs_control_port_in_a_write_cycle assignment, which is an e_assign
  assign epcs_epcs_control_port_in_a_write_cycle = nios_f_data_master_granted_epcs_epcs_control_port & nios_f_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = epcs_epcs_control_port_in_a_write_cycle;

  assign wait_for_epcs_epcs_control_port_counter = 0;
  //assign epcs_epcs_control_port_irq_from_sa = epcs_epcs_control_port_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign epcs_epcs_control_port_irq_from_sa = epcs_epcs_control_port_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //epcs/epcs_control_port enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (nios_f_data_master_granted_epcs_epcs_control_port + nios_f_instruction_master_granted_epcs_epcs_control_port > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (nios_f_data_master_saved_grant_epcs_epcs_control_port + nios_f_instruction_master_saved_grant_epcs_epcs_control_port > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module high_res_timer_s1_arbitrator (
                                      // inputs:
                                       clk,
                                       high_res_timer_s1_irq,
                                       high_res_timer_s1_readdata,
                                       nios_f_data_master_address_to_slave,
                                       nios_f_data_master_read,
                                       nios_f_data_master_waitrequest,
                                       nios_f_data_master_write,
                                       nios_f_data_master_writedata,
                                       reset_n,

                                      // outputs:
                                       d1_high_res_timer_s1_end_xfer,
                                       high_res_timer_s1_address,
                                       high_res_timer_s1_chipselect,
                                       high_res_timer_s1_irq_from_sa,
                                       high_res_timer_s1_readdata_from_sa,
                                       high_res_timer_s1_reset_n,
                                       high_res_timer_s1_write_n,
                                       high_res_timer_s1_writedata,
                                       nios_f_data_master_granted_high_res_timer_s1,
                                       nios_f_data_master_qualified_request_high_res_timer_s1,
                                       nios_f_data_master_read_data_valid_high_res_timer_s1,
                                       nios_f_data_master_requests_high_res_timer_s1
                                    )
;

  output           d1_high_res_timer_s1_end_xfer;
  output  [  2: 0] high_res_timer_s1_address;
  output           high_res_timer_s1_chipselect;
  output           high_res_timer_s1_irq_from_sa;
  output  [ 15: 0] high_res_timer_s1_readdata_from_sa;
  output           high_res_timer_s1_reset_n;
  output           high_res_timer_s1_write_n;
  output  [ 15: 0] high_res_timer_s1_writedata;
  output           nios_f_data_master_granted_high_res_timer_s1;
  output           nios_f_data_master_qualified_request_high_res_timer_s1;
  output           nios_f_data_master_read_data_valid_high_res_timer_s1;
  output           nios_f_data_master_requests_high_res_timer_s1;
  input            clk;
  input            high_res_timer_s1_irq;
  input   [ 15: 0] high_res_timer_s1_readdata;
  input   [ 25: 0] nios_f_data_master_address_to_slave;
  input            nios_f_data_master_read;
  input            nios_f_data_master_waitrequest;
  input            nios_f_data_master_write;
  input   [ 31: 0] nios_f_data_master_writedata;
  input            reset_n;

  reg              d1_high_res_timer_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_high_res_timer_s1;
  wire    [  2: 0] high_res_timer_s1_address;
  wire             high_res_timer_s1_allgrants;
  wire             high_res_timer_s1_allow_new_arb_cycle;
  wire             high_res_timer_s1_any_bursting_master_saved_grant;
  wire             high_res_timer_s1_any_continuerequest;
  wire             high_res_timer_s1_arb_counter_enable;
  reg     [  1: 0] high_res_timer_s1_arb_share_counter;
  wire    [  1: 0] high_res_timer_s1_arb_share_counter_next_value;
  wire    [  1: 0] high_res_timer_s1_arb_share_set_values;
  wire             high_res_timer_s1_beginbursttransfer_internal;
  wire             high_res_timer_s1_begins_xfer;
  wire             high_res_timer_s1_chipselect;
  wire             high_res_timer_s1_end_xfer;
  wire             high_res_timer_s1_firsttransfer;
  wire             high_res_timer_s1_grant_vector;
  wire             high_res_timer_s1_in_a_read_cycle;
  wire             high_res_timer_s1_in_a_write_cycle;
  wire             high_res_timer_s1_irq_from_sa;
  wire             high_res_timer_s1_master_qreq_vector;
  wire             high_res_timer_s1_non_bursting_master_requests;
  wire    [ 15: 0] high_res_timer_s1_readdata_from_sa;
  reg              high_res_timer_s1_reg_firsttransfer;
  wire             high_res_timer_s1_reset_n;
  reg              high_res_timer_s1_slavearbiterlockenable;
  wire             high_res_timer_s1_slavearbiterlockenable2;
  wire             high_res_timer_s1_unreg_firsttransfer;
  wire             high_res_timer_s1_waits_for_read;
  wire             high_res_timer_s1_waits_for_write;
  wire             high_res_timer_s1_write_n;
  wire    [ 15: 0] high_res_timer_s1_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios_f_data_master_arbiterlock;
  wire             nios_f_data_master_arbiterlock2;
  wire             nios_f_data_master_continuerequest;
  wire             nios_f_data_master_granted_high_res_timer_s1;
  wire             nios_f_data_master_qualified_request_high_res_timer_s1;
  wire             nios_f_data_master_read_data_valid_high_res_timer_s1;
  wire             nios_f_data_master_requests_high_res_timer_s1;
  wire             nios_f_data_master_saved_grant_high_res_timer_s1;
  wire    [ 25: 0] shifted_address_to_high_res_timer_s1_from_nios_f_data_master;
  wire             wait_for_high_res_timer_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~high_res_timer_s1_end_xfer;
    end


  assign high_res_timer_s1_begins_xfer = ~d1_reasons_to_wait & ((nios_f_data_master_qualified_request_high_res_timer_s1));
  //assign high_res_timer_s1_readdata_from_sa = high_res_timer_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign high_res_timer_s1_readdata_from_sa = high_res_timer_s1_readdata;

  assign nios_f_data_master_requests_high_res_timer_s1 = ({nios_f_data_master_address_to_slave[25 : 5] , 5'b0} == 26'h3002020) & (nios_f_data_master_read | nios_f_data_master_write);
  //high_res_timer_s1_arb_share_counter set values, which is an e_mux
  assign high_res_timer_s1_arb_share_set_values = 1;

  //high_res_timer_s1_non_bursting_master_requests mux, which is an e_mux
  assign high_res_timer_s1_non_bursting_master_requests = nios_f_data_master_requests_high_res_timer_s1;

  //high_res_timer_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign high_res_timer_s1_any_bursting_master_saved_grant = 0;

  //high_res_timer_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign high_res_timer_s1_arb_share_counter_next_value = high_res_timer_s1_firsttransfer ? (high_res_timer_s1_arb_share_set_values - 1) : |high_res_timer_s1_arb_share_counter ? (high_res_timer_s1_arb_share_counter - 1) : 0;

  //high_res_timer_s1_allgrants all slave grants, which is an e_mux
  assign high_res_timer_s1_allgrants = |high_res_timer_s1_grant_vector;

  //high_res_timer_s1_end_xfer assignment, which is an e_assign
  assign high_res_timer_s1_end_xfer = ~(high_res_timer_s1_waits_for_read | high_res_timer_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_high_res_timer_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_high_res_timer_s1 = high_res_timer_s1_end_xfer & (~high_res_timer_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //high_res_timer_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign high_res_timer_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_high_res_timer_s1 & high_res_timer_s1_allgrants) | (end_xfer_arb_share_counter_term_high_res_timer_s1 & ~high_res_timer_s1_non_bursting_master_requests);

  //high_res_timer_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          high_res_timer_s1_arb_share_counter <= 0;
      else if (high_res_timer_s1_arb_counter_enable)
          high_res_timer_s1_arb_share_counter <= high_res_timer_s1_arb_share_counter_next_value;
    end


  //high_res_timer_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          high_res_timer_s1_slavearbiterlockenable <= 0;
      else if ((|high_res_timer_s1_master_qreq_vector & end_xfer_arb_share_counter_term_high_res_timer_s1) | (end_xfer_arb_share_counter_term_high_res_timer_s1 & ~high_res_timer_s1_non_bursting_master_requests))
          high_res_timer_s1_slavearbiterlockenable <= |high_res_timer_s1_arb_share_counter_next_value;
    end


  //nios_f/data_master high_res_timer/s1 arbiterlock, which is an e_assign
  assign nios_f_data_master_arbiterlock = high_res_timer_s1_slavearbiterlockenable & nios_f_data_master_continuerequest;

  //high_res_timer_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign high_res_timer_s1_slavearbiterlockenable2 = |high_res_timer_s1_arb_share_counter_next_value;

  //nios_f/data_master high_res_timer/s1 arbiterlock2, which is an e_assign
  assign nios_f_data_master_arbiterlock2 = high_res_timer_s1_slavearbiterlockenable2 & nios_f_data_master_continuerequest;

  //high_res_timer_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign high_res_timer_s1_any_continuerequest = 1;

  //nios_f_data_master_continuerequest continued request, which is an e_assign
  assign nios_f_data_master_continuerequest = 1;

  assign nios_f_data_master_qualified_request_high_res_timer_s1 = nios_f_data_master_requests_high_res_timer_s1 & ~(((~nios_f_data_master_waitrequest) & nios_f_data_master_write));
  //high_res_timer_s1_writedata mux, which is an e_mux
  assign high_res_timer_s1_writedata = nios_f_data_master_writedata;

  //master is always granted when requested
  assign nios_f_data_master_granted_high_res_timer_s1 = nios_f_data_master_qualified_request_high_res_timer_s1;

  //nios_f/data_master saved-grant high_res_timer/s1, which is an e_assign
  assign nios_f_data_master_saved_grant_high_res_timer_s1 = nios_f_data_master_requests_high_res_timer_s1;

  //allow new arb cycle for high_res_timer/s1, which is an e_assign
  assign high_res_timer_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign high_res_timer_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign high_res_timer_s1_master_qreq_vector = 1;

  //high_res_timer_s1_reset_n assignment, which is an e_assign
  assign high_res_timer_s1_reset_n = reset_n;

  assign high_res_timer_s1_chipselect = nios_f_data_master_granted_high_res_timer_s1;
  //high_res_timer_s1_firsttransfer first transaction, which is an e_assign
  assign high_res_timer_s1_firsttransfer = high_res_timer_s1_begins_xfer ? high_res_timer_s1_unreg_firsttransfer : high_res_timer_s1_reg_firsttransfer;

  //high_res_timer_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign high_res_timer_s1_unreg_firsttransfer = ~(high_res_timer_s1_slavearbiterlockenable & high_res_timer_s1_any_continuerequest);

  //high_res_timer_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          high_res_timer_s1_reg_firsttransfer <= 1'b1;
      else if (high_res_timer_s1_begins_xfer)
          high_res_timer_s1_reg_firsttransfer <= high_res_timer_s1_unreg_firsttransfer;
    end


  //high_res_timer_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign high_res_timer_s1_beginbursttransfer_internal = high_res_timer_s1_begins_xfer;

  //~high_res_timer_s1_write_n assignment, which is an e_mux
  assign high_res_timer_s1_write_n = ~(nios_f_data_master_granted_high_res_timer_s1 & nios_f_data_master_write);

  assign shifted_address_to_high_res_timer_s1_from_nios_f_data_master = nios_f_data_master_address_to_slave;
  //high_res_timer_s1_address mux, which is an e_mux
  assign high_res_timer_s1_address = shifted_address_to_high_res_timer_s1_from_nios_f_data_master >> 2;

  //d1_high_res_timer_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_high_res_timer_s1_end_xfer <= 1;
      else 
        d1_high_res_timer_s1_end_xfer <= high_res_timer_s1_end_xfer;
    end


  //high_res_timer_s1_waits_for_read in a cycle, which is an e_mux
  assign high_res_timer_s1_waits_for_read = high_res_timer_s1_in_a_read_cycle & high_res_timer_s1_begins_xfer;

  //high_res_timer_s1_in_a_read_cycle assignment, which is an e_assign
  assign high_res_timer_s1_in_a_read_cycle = nios_f_data_master_granted_high_res_timer_s1 & nios_f_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = high_res_timer_s1_in_a_read_cycle;

  //high_res_timer_s1_waits_for_write in a cycle, which is an e_mux
  assign high_res_timer_s1_waits_for_write = high_res_timer_s1_in_a_write_cycle & 0;

  //high_res_timer_s1_in_a_write_cycle assignment, which is an e_assign
  assign high_res_timer_s1_in_a_write_cycle = nios_f_data_master_granted_high_res_timer_s1 & nios_f_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = high_res_timer_s1_in_a_write_cycle;

  assign wait_for_high_res_timer_s1_counter = 0;
  //assign high_res_timer_s1_irq_from_sa = high_res_timer_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign high_res_timer_s1_irq_from_sa = high_res_timer_s1_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //high_res_timer/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ili_db_s1_arbitrator (
                              // inputs:
                               clk,
                               ili_db_s1_readdata,
                               pipeline_bridge_0_m1_address_to_slave,
                               pipeline_bridge_0_m1_burstcount,
                               pipeline_bridge_0_m1_chipselect,
                               pipeline_bridge_0_m1_latency_counter,
                               pipeline_bridge_0_m1_read,
                               pipeline_bridge_0_m1_write,
                               pipeline_bridge_0_m1_writedata,
                               reset_n,

                              // outputs:
                               d1_ili_db_s1_end_xfer,
                               ili_db_s1_address,
                               ili_db_s1_chipselect,
                               ili_db_s1_readdata_from_sa,
                               ili_db_s1_reset_n,
                               ili_db_s1_write_n,
                               ili_db_s1_writedata,
                               pipeline_bridge_0_m1_granted_ili_db_s1,
                               pipeline_bridge_0_m1_qualified_request_ili_db_s1,
                               pipeline_bridge_0_m1_read_data_valid_ili_db_s1,
                               pipeline_bridge_0_m1_requests_ili_db_s1
                            )
;

  output           d1_ili_db_s1_end_xfer;
  output  [  1: 0] ili_db_s1_address;
  output           ili_db_s1_chipselect;
  output  [ 31: 0] ili_db_s1_readdata_from_sa;
  output           ili_db_s1_reset_n;
  output           ili_db_s1_write_n;
  output  [ 31: 0] ili_db_s1_writedata;
  output           pipeline_bridge_0_m1_granted_ili_db_s1;
  output           pipeline_bridge_0_m1_qualified_request_ili_db_s1;
  output           pipeline_bridge_0_m1_read_data_valid_ili_db_s1;
  output           pipeline_bridge_0_m1_requests_ili_db_s1;
  input            clk;
  input   [ 31: 0] ili_db_s1_readdata;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input   [ 31: 0] pipeline_bridge_0_m1_writedata;
  input            reset_n;

  reg              d1_ili_db_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_ili_db_s1;
  wire    [  1: 0] ili_db_s1_address;
  wire             ili_db_s1_allgrants;
  wire             ili_db_s1_allow_new_arb_cycle;
  wire             ili_db_s1_any_bursting_master_saved_grant;
  wire             ili_db_s1_any_continuerequest;
  wire             ili_db_s1_arb_counter_enable;
  reg              ili_db_s1_arb_share_counter;
  wire             ili_db_s1_arb_share_counter_next_value;
  wire             ili_db_s1_arb_share_set_values;
  wire             ili_db_s1_beginbursttransfer_internal;
  wire             ili_db_s1_begins_xfer;
  wire             ili_db_s1_chipselect;
  wire             ili_db_s1_end_xfer;
  wire             ili_db_s1_firsttransfer;
  wire             ili_db_s1_grant_vector;
  wire             ili_db_s1_in_a_read_cycle;
  wire             ili_db_s1_in_a_write_cycle;
  wire             ili_db_s1_master_qreq_vector;
  wire             ili_db_s1_non_bursting_master_requests;
  wire    [ 31: 0] ili_db_s1_readdata_from_sa;
  reg              ili_db_s1_reg_firsttransfer;
  wire             ili_db_s1_reset_n;
  reg              ili_db_s1_slavearbiterlockenable;
  wire             ili_db_s1_slavearbiterlockenable2;
  wire             ili_db_s1_unreg_firsttransfer;
  wire             ili_db_s1_waits_for_read;
  wire             ili_db_s1_waits_for_write;
  wire             ili_db_s1_write_n;
  wire    [ 31: 0] ili_db_s1_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_ili_db_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ili_db_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ili_db_s1;
  wire             pipeline_bridge_0_m1_requests_ili_db_s1;
  wire             pipeline_bridge_0_m1_saved_grant_ili_db_s1;
  wire    [  8: 0] shifted_address_to_ili_db_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_ili_db_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~ili_db_s1_end_xfer;
    end


  assign ili_db_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_ili_db_s1));
  //assign ili_db_s1_readdata_from_sa = ili_db_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ili_db_s1_readdata_from_sa = ili_db_s1_readdata;

  assign pipeline_bridge_0_m1_requests_ili_db_s1 = ({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'h0) & pipeline_bridge_0_m1_chipselect;
  //ili_db_s1_arb_share_counter set values, which is an e_mux
  assign ili_db_s1_arb_share_set_values = 1;

  //ili_db_s1_non_bursting_master_requests mux, which is an e_mux
  assign ili_db_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_ili_db_s1;

  //ili_db_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign ili_db_s1_any_bursting_master_saved_grant = 0;

  //ili_db_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign ili_db_s1_arb_share_counter_next_value = ili_db_s1_firsttransfer ? (ili_db_s1_arb_share_set_values - 1) : |ili_db_s1_arb_share_counter ? (ili_db_s1_arb_share_counter - 1) : 0;

  //ili_db_s1_allgrants all slave grants, which is an e_mux
  assign ili_db_s1_allgrants = |ili_db_s1_grant_vector;

  //ili_db_s1_end_xfer assignment, which is an e_assign
  assign ili_db_s1_end_xfer = ~(ili_db_s1_waits_for_read | ili_db_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_ili_db_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_ili_db_s1 = ili_db_s1_end_xfer & (~ili_db_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //ili_db_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign ili_db_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_ili_db_s1 & ili_db_s1_allgrants) | (end_xfer_arb_share_counter_term_ili_db_s1 & ~ili_db_s1_non_bursting_master_requests);

  //ili_db_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_db_s1_arb_share_counter <= 0;
      else if (ili_db_s1_arb_counter_enable)
          ili_db_s1_arb_share_counter <= ili_db_s1_arb_share_counter_next_value;
    end


  //ili_db_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_db_s1_slavearbiterlockenable <= 0;
      else if ((|ili_db_s1_master_qreq_vector & end_xfer_arb_share_counter_term_ili_db_s1) | (end_xfer_arb_share_counter_term_ili_db_s1 & ~ili_db_s1_non_bursting_master_requests))
          ili_db_s1_slavearbiterlockenable <= |ili_db_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 ili_db/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = ili_db_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //ili_db_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign ili_db_s1_slavearbiterlockenable2 = |ili_db_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 ili_db/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = ili_db_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //ili_db_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign ili_db_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_ili_db_s1 = pipeline_bridge_0_m1_requests_ili_db_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_ili_db_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_ili_db_s1 = pipeline_bridge_0_m1_granted_ili_db_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~ili_db_s1_waits_for_read;

  //ili_db_s1_writedata mux, which is an e_mux
  assign ili_db_s1_writedata = pipeline_bridge_0_m1_writedata;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_ili_db_s1 = pipeline_bridge_0_m1_qualified_request_ili_db_s1;

  //pipeline_bridge_0/m1 saved-grant ili_db/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_ili_db_s1 = pipeline_bridge_0_m1_requests_ili_db_s1;

  //allow new arb cycle for ili_db/s1, which is an e_assign
  assign ili_db_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign ili_db_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign ili_db_s1_master_qreq_vector = 1;

  //ili_db_s1_reset_n assignment, which is an e_assign
  assign ili_db_s1_reset_n = reset_n;

  assign ili_db_s1_chipselect = pipeline_bridge_0_m1_granted_ili_db_s1;
  //ili_db_s1_firsttransfer first transaction, which is an e_assign
  assign ili_db_s1_firsttransfer = ili_db_s1_begins_xfer ? ili_db_s1_unreg_firsttransfer : ili_db_s1_reg_firsttransfer;

  //ili_db_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign ili_db_s1_unreg_firsttransfer = ~(ili_db_s1_slavearbiterlockenable & ili_db_s1_any_continuerequest);

  //ili_db_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_db_s1_reg_firsttransfer <= 1'b1;
      else if (ili_db_s1_begins_xfer)
          ili_db_s1_reg_firsttransfer <= ili_db_s1_unreg_firsttransfer;
    end


  //ili_db_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign ili_db_s1_beginbursttransfer_internal = ili_db_s1_begins_xfer;

  //~ili_db_s1_write_n assignment, which is an e_mux
  assign ili_db_s1_write_n = ~(pipeline_bridge_0_m1_granted_ili_db_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect));

  assign shifted_address_to_ili_db_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //ili_db_s1_address mux, which is an e_mux
  assign ili_db_s1_address = shifted_address_to_ili_db_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_ili_db_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_ili_db_s1_end_xfer <= 1;
      else 
        d1_ili_db_s1_end_xfer <= ili_db_s1_end_xfer;
    end


  //ili_db_s1_waits_for_read in a cycle, which is an e_mux
  assign ili_db_s1_waits_for_read = ili_db_s1_in_a_read_cycle & ili_db_s1_begins_xfer;

  //ili_db_s1_in_a_read_cycle assignment, which is an e_assign
  assign ili_db_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_ili_db_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ili_db_s1_in_a_read_cycle;

  //ili_db_s1_waits_for_write in a cycle, which is an e_mux
  assign ili_db_s1_waits_for_write = ili_db_s1_in_a_write_cycle & 0;

  //ili_db_s1_in_a_write_cycle assignment, which is an e_assign
  assign ili_db_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_ili_db_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ili_db_s1_in_a_write_cycle;

  assign wait_for_ili_db_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //ili_db/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_ili_db_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave ili_db/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ili_ncs_s1_arbitrator (
                               // inputs:
                                clk,
                                ili_ncs_s1_readdata,
                                pipeline_bridge_0_m1_address_to_slave,
                                pipeline_bridge_0_m1_burstcount,
                                pipeline_bridge_0_m1_chipselect,
                                pipeline_bridge_0_m1_latency_counter,
                                pipeline_bridge_0_m1_read,
                                pipeline_bridge_0_m1_write,
                                pipeline_bridge_0_m1_writedata,
                                reset_n,

                               // outputs:
                                d1_ili_ncs_s1_end_xfer,
                                ili_ncs_s1_address,
                                ili_ncs_s1_chipselect,
                                ili_ncs_s1_readdata_from_sa,
                                ili_ncs_s1_reset_n,
                                ili_ncs_s1_write_n,
                                ili_ncs_s1_writedata,
                                pipeline_bridge_0_m1_granted_ili_ncs_s1,
                                pipeline_bridge_0_m1_qualified_request_ili_ncs_s1,
                                pipeline_bridge_0_m1_read_data_valid_ili_ncs_s1,
                                pipeline_bridge_0_m1_requests_ili_ncs_s1
                             )
;

  output           d1_ili_ncs_s1_end_xfer;
  output  [  1: 0] ili_ncs_s1_address;
  output           ili_ncs_s1_chipselect;
  output  [ 31: 0] ili_ncs_s1_readdata_from_sa;
  output           ili_ncs_s1_reset_n;
  output           ili_ncs_s1_write_n;
  output  [ 31: 0] ili_ncs_s1_writedata;
  output           pipeline_bridge_0_m1_granted_ili_ncs_s1;
  output           pipeline_bridge_0_m1_qualified_request_ili_ncs_s1;
  output           pipeline_bridge_0_m1_read_data_valid_ili_ncs_s1;
  output           pipeline_bridge_0_m1_requests_ili_ncs_s1;
  input            clk;
  input   [ 31: 0] ili_ncs_s1_readdata;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input   [ 31: 0] pipeline_bridge_0_m1_writedata;
  input            reset_n;

  reg              d1_ili_ncs_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_ili_ncs_s1;
  wire    [  1: 0] ili_ncs_s1_address;
  wire             ili_ncs_s1_allgrants;
  wire             ili_ncs_s1_allow_new_arb_cycle;
  wire             ili_ncs_s1_any_bursting_master_saved_grant;
  wire             ili_ncs_s1_any_continuerequest;
  wire             ili_ncs_s1_arb_counter_enable;
  reg              ili_ncs_s1_arb_share_counter;
  wire             ili_ncs_s1_arb_share_counter_next_value;
  wire             ili_ncs_s1_arb_share_set_values;
  wire             ili_ncs_s1_beginbursttransfer_internal;
  wire             ili_ncs_s1_begins_xfer;
  wire             ili_ncs_s1_chipselect;
  wire             ili_ncs_s1_end_xfer;
  wire             ili_ncs_s1_firsttransfer;
  wire             ili_ncs_s1_grant_vector;
  wire             ili_ncs_s1_in_a_read_cycle;
  wire             ili_ncs_s1_in_a_write_cycle;
  wire             ili_ncs_s1_master_qreq_vector;
  wire             ili_ncs_s1_non_bursting_master_requests;
  wire    [ 31: 0] ili_ncs_s1_readdata_from_sa;
  reg              ili_ncs_s1_reg_firsttransfer;
  wire             ili_ncs_s1_reset_n;
  reg              ili_ncs_s1_slavearbiterlockenable;
  wire             ili_ncs_s1_slavearbiterlockenable2;
  wire             ili_ncs_s1_unreg_firsttransfer;
  wire             ili_ncs_s1_waits_for_read;
  wire             ili_ncs_s1_waits_for_write;
  wire             ili_ncs_s1_write_n;
  wire    [ 31: 0] ili_ncs_s1_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_ili_ncs_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ili_ncs_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ili_ncs_s1;
  wire             pipeline_bridge_0_m1_requests_ili_ncs_s1;
  wire             pipeline_bridge_0_m1_saved_grant_ili_ncs_s1;
  wire    [  8: 0] shifted_address_to_ili_ncs_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_ili_ncs_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~ili_ncs_s1_end_xfer;
    end


  assign ili_ncs_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_ili_ncs_s1));
  //assign ili_ncs_s1_readdata_from_sa = ili_ncs_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ili_ncs_s1_readdata_from_sa = ili_ncs_s1_readdata;

  assign pipeline_bridge_0_m1_requests_ili_ncs_s1 = ({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'h20) & pipeline_bridge_0_m1_chipselect;
  //ili_ncs_s1_arb_share_counter set values, which is an e_mux
  assign ili_ncs_s1_arb_share_set_values = 1;

  //ili_ncs_s1_non_bursting_master_requests mux, which is an e_mux
  assign ili_ncs_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_ili_ncs_s1;

  //ili_ncs_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign ili_ncs_s1_any_bursting_master_saved_grant = 0;

  //ili_ncs_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign ili_ncs_s1_arb_share_counter_next_value = ili_ncs_s1_firsttransfer ? (ili_ncs_s1_arb_share_set_values - 1) : |ili_ncs_s1_arb_share_counter ? (ili_ncs_s1_arb_share_counter - 1) : 0;

  //ili_ncs_s1_allgrants all slave grants, which is an e_mux
  assign ili_ncs_s1_allgrants = |ili_ncs_s1_grant_vector;

  //ili_ncs_s1_end_xfer assignment, which is an e_assign
  assign ili_ncs_s1_end_xfer = ~(ili_ncs_s1_waits_for_read | ili_ncs_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_ili_ncs_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_ili_ncs_s1 = ili_ncs_s1_end_xfer & (~ili_ncs_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //ili_ncs_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign ili_ncs_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_ili_ncs_s1 & ili_ncs_s1_allgrants) | (end_xfer_arb_share_counter_term_ili_ncs_s1 & ~ili_ncs_s1_non_bursting_master_requests);

  //ili_ncs_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_ncs_s1_arb_share_counter <= 0;
      else if (ili_ncs_s1_arb_counter_enable)
          ili_ncs_s1_arb_share_counter <= ili_ncs_s1_arb_share_counter_next_value;
    end


  //ili_ncs_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_ncs_s1_slavearbiterlockenable <= 0;
      else if ((|ili_ncs_s1_master_qreq_vector & end_xfer_arb_share_counter_term_ili_ncs_s1) | (end_xfer_arb_share_counter_term_ili_ncs_s1 & ~ili_ncs_s1_non_bursting_master_requests))
          ili_ncs_s1_slavearbiterlockenable <= |ili_ncs_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 ili_ncs/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = ili_ncs_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //ili_ncs_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign ili_ncs_s1_slavearbiterlockenable2 = |ili_ncs_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 ili_ncs/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = ili_ncs_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //ili_ncs_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign ili_ncs_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_ili_ncs_s1 = pipeline_bridge_0_m1_requests_ili_ncs_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_ili_ncs_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_ili_ncs_s1 = pipeline_bridge_0_m1_granted_ili_ncs_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~ili_ncs_s1_waits_for_read;

  //ili_ncs_s1_writedata mux, which is an e_mux
  assign ili_ncs_s1_writedata = pipeline_bridge_0_m1_writedata;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_ili_ncs_s1 = pipeline_bridge_0_m1_qualified_request_ili_ncs_s1;

  //pipeline_bridge_0/m1 saved-grant ili_ncs/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_ili_ncs_s1 = pipeline_bridge_0_m1_requests_ili_ncs_s1;

  //allow new arb cycle for ili_ncs/s1, which is an e_assign
  assign ili_ncs_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign ili_ncs_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign ili_ncs_s1_master_qreq_vector = 1;

  //ili_ncs_s1_reset_n assignment, which is an e_assign
  assign ili_ncs_s1_reset_n = reset_n;

  assign ili_ncs_s1_chipselect = pipeline_bridge_0_m1_granted_ili_ncs_s1;
  //ili_ncs_s1_firsttransfer first transaction, which is an e_assign
  assign ili_ncs_s1_firsttransfer = ili_ncs_s1_begins_xfer ? ili_ncs_s1_unreg_firsttransfer : ili_ncs_s1_reg_firsttransfer;

  //ili_ncs_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign ili_ncs_s1_unreg_firsttransfer = ~(ili_ncs_s1_slavearbiterlockenable & ili_ncs_s1_any_continuerequest);

  //ili_ncs_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_ncs_s1_reg_firsttransfer <= 1'b1;
      else if (ili_ncs_s1_begins_xfer)
          ili_ncs_s1_reg_firsttransfer <= ili_ncs_s1_unreg_firsttransfer;
    end


  //ili_ncs_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign ili_ncs_s1_beginbursttransfer_internal = ili_ncs_s1_begins_xfer;

  //~ili_ncs_s1_write_n assignment, which is an e_mux
  assign ili_ncs_s1_write_n = ~(pipeline_bridge_0_m1_granted_ili_ncs_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect));

  assign shifted_address_to_ili_ncs_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //ili_ncs_s1_address mux, which is an e_mux
  assign ili_ncs_s1_address = shifted_address_to_ili_ncs_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_ili_ncs_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_ili_ncs_s1_end_xfer <= 1;
      else 
        d1_ili_ncs_s1_end_xfer <= ili_ncs_s1_end_xfer;
    end


  //ili_ncs_s1_waits_for_read in a cycle, which is an e_mux
  assign ili_ncs_s1_waits_for_read = ili_ncs_s1_in_a_read_cycle & ili_ncs_s1_begins_xfer;

  //ili_ncs_s1_in_a_read_cycle assignment, which is an e_assign
  assign ili_ncs_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_ili_ncs_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ili_ncs_s1_in_a_read_cycle;

  //ili_ncs_s1_waits_for_write in a cycle, which is an e_mux
  assign ili_ncs_s1_waits_for_write = ili_ncs_s1_in_a_write_cycle & 0;

  //ili_ncs_s1_in_a_write_cycle assignment, which is an e_assign
  assign ili_ncs_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_ili_ncs_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ili_ncs_s1_in_a_write_cycle;

  assign wait_for_ili_ncs_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //ili_ncs/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_ili_ncs_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave ili_ncs/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ili_nrd_s1_arbitrator (
                               // inputs:
                                clk,
                                ili_nrd_s1_readdata,
                                pipeline_bridge_0_m1_address_to_slave,
                                pipeline_bridge_0_m1_burstcount,
                                pipeline_bridge_0_m1_chipselect,
                                pipeline_bridge_0_m1_latency_counter,
                                pipeline_bridge_0_m1_read,
                                pipeline_bridge_0_m1_write,
                                pipeline_bridge_0_m1_writedata,
                                reset_n,

                               // outputs:
                                d1_ili_nrd_s1_end_xfer,
                                ili_nrd_s1_address,
                                ili_nrd_s1_chipselect,
                                ili_nrd_s1_readdata_from_sa,
                                ili_nrd_s1_reset_n,
                                ili_nrd_s1_write_n,
                                ili_nrd_s1_writedata,
                                pipeline_bridge_0_m1_granted_ili_nrd_s1,
                                pipeline_bridge_0_m1_qualified_request_ili_nrd_s1,
                                pipeline_bridge_0_m1_read_data_valid_ili_nrd_s1,
                                pipeline_bridge_0_m1_requests_ili_nrd_s1
                             )
;

  output           d1_ili_nrd_s1_end_xfer;
  output  [  1: 0] ili_nrd_s1_address;
  output           ili_nrd_s1_chipselect;
  output  [ 31: 0] ili_nrd_s1_readdata_from_sa;
  output           ili_nrd_s1_reset_n;
  output           ili_nrd_s1_write_n;
  output  [ 31: 0] ili_nrd_s1_writedata;
  output           pipeline_bridge_0_m1_granted_ili_nrd_s1;
  output           pipeline_bridge_0_m1_qualified_request_ili_nrd_s1;
  output           pipeline_bridge_0_m1_read_data_valid_ili_nrd_s1;
  output           pipeline_bridge_0_m1_requests_ili_nrd_s1;
  input            clk;
  input   [ 31: 0] ili_nrd_s1_readdata;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input   [ 31: 0] pipeline_bridge_0_m1_writedata;
  input            reset_n;

  reg              d1_ili_nrd_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_ili_nrd_s1;
  wire    [  1: 0] ili_nrd_s1_address;
  wire             ili_nrd_s1_allgrants;
  wire             ili_nrd_s1_allow_new_arb_cycle;
  wire             ili_nrd_s1_any_bursting_master_saved_grant;
  wire             ili_nrd_s1_any_continuerequest;
  wire             ili_nrd_s1_arb_counter_enable;
  reg              ili_nrd_s1_arb_share_counter;
  wire             ili_nrd_s1_arb_share_counter_next_value;
  wire             ili_nrd_s1_arb_share_set_values;
  wire             ili_nrd_s1_beginbursttransfer_internal;
  wire             ili_nrd_s1_begins_xfer;
  wire             ili_nrd_s1_chipselect;
  wire             ili_nrd_s1_end_xfer;
  wire             ili_nrd_s1_firsttransfer;
  wire             ili_nrd_s1_grant_vector;
  wire             ili_nrd_s1_in_a_read_cycle;
  wire             ili_nrd_s1_in_a_write_cycle;
  wire             ili_nrd_s1_master_qreq_vector;
  wire             ili_nrd_s1_non_bursting_master_requests;
  wire    [ 31: 0] ili_nrd_s1_readdata_from_sa;
  reg              ili_nrd_s1_reg_firsttransfer;
  wire             ili_nrd_s1_reset_n;
  reg              ili_nrd_s1_slavearbiterlockenable;
  wire             ili_nrd_s1_slavearbiterlockenable2;
  wire             ili_nrd_s1_unreg_firsttransfer;
  wire             ili_nrd_s1_waits_for_read;
  wire             ili_nrd_s1_waits_for_write;
  wire             ili_nrd_s1_write_n;
  wire    [ 31: 0] ili_nrd_s1_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_ili_nrd_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ili_nrd_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ili_nrd_s1;
  wire             pipeline_bridge_0_m1_requests_ili_nrd_s1;
  wire             pipeline_bridge_0_m1_saved_grant_ili_nrd_s1;
  wire    [  8: 0] shifted_address_to_ili_nrd_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_ili_nrd_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~ili_nrd_s1_end_xfer;
    end


  assign ili_nrd_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_ili_nrd_s1));
  //assign ili_nrd_s1_readdata_from_sa = ili_nrd_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ili_nrd_s1_readdata_from_sa = ili_nrd_s1_readdata;

  assign pipeline_bridge_0_m1_requests_ili_nrd_s1 = ({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'h40) & pipeline_bridge_0_m1_chipselect;
  //ili_nrd_s1_arb_share_counter set values, which is an e_mux
  assign ili_nrd_s1_arb_share_set_values = 1;

  //ili_nrd_s1_non_bursting_master_requests mux, which is an e_mux
  assign ili_nrd_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_ili_nrd_s1;

  //ili_nrd_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign ili_nrd_s1_any_bursting_master_saved_grant = 0;

  //ili_nrd_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign ili_nrd_s1_arb_share_counter_next_value = ili_nrd_s1_firsttransfer ? (ili_nrd_s1_arb_share_set_values - 1) : |ili_nrd_s1_arb_share_counter ? (ili_nrd_s1_arb_share_counter - 1) : 0;

  //ili_nrd_s1_allgrants all slave grants, which is an e_mux
  assign ili_nrd_s1_allgrants = |ili_nrd_s1_grant_vector;

  //ili_nrd_s1_end_xfer assignment, which is an e_assign
  assign ili_nrd_s1_end_xfer = ~(ili_nrd_s1_waits_for_read | ili_nrd_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_ili_nrd_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_ili_nrd_s1 = ili_nrd_s1_end_xfer & (~ili_nrd_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //ili_nrd_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign ili_nrd_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_ili_nrd_s1 & ili_nrd_s1_allgrants) | (end_xfer_arb_share_counter_term_ili_nrd_s1 & ~ili_nrd_s1_non_bursting_master_requests);

  //ili_nrd_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_nrd_s1_arb_share_counter <= 0;
      else if (ili_nrd_s1_arb_counter_enable)
          ili_nrd_s1_arb_share_counter <= ili_nrd_s1_arb_share_counter_next_value;
    end


  //ili_nrd_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_nrd_s1_slavearbiterlockenable <= 0;
      else if ((|ili_nrd_s1_master_qreq_vector & end_xfer_arb_share_counter_term_ili_nrd_s1) | (end_xfer_arb_share_counter_term_ili_nrd_s1 & ~ili_nrd_s1_non_bursting_master_requests))
          ili_nrd_s1_slavearbiterlockenable <= |ili_nrd_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 ili_nrd/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = ili_nrd_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //ili_nrd_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign ili_nrd_s1_slavearbiterlockenable2 = |ili_nrd_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 ili_nrd/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = ili_nrd_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //ili_nrd_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign ili_nrd_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_ili_nrd_s1 = pipeline_bridge_0_m1_requests_ili_nrd_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_ili_nrd_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_ili_nrd_s1 = pipeline_bridge_0_m1_granted_ili_nrd_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~ili_nrd_s1_waits_for_read;

  //ili_nrd_s1_writedata mux, which is an e_mux
  assign ili_nrd_s1_writedata = pipeline_bridge_0_m1_writedata;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_ili_nrd_s1 = pipeline_bridge_0_m1_qualified_request_ili_nrd_s1;

  //pipeline_bridge_0/m1 saved-grant ili_nrd/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_ili_nrd_s1 = pipeline_bridge_0_m1_requests_ili_nrd_s1;

  //allow new arb cycle for ili_nrd/s1, which is an e_assign
  assign ili_nrd_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign ili_nrd_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign ili_nrd_s1_master_qreq_vector = 1;

  //ili_nrd_s1_reset_n assignment, which is an e_assign
  assign ili_nrd_s1_reset_n = reset_n;

  assign ili_nrd_s1_chipselect = pipeline_bridge_0_m1_granted_ili_nrd_s1;
  //ili_nrd_s1_firsttransfer first transaction, which is an e_assign
  assign ili_nrd_s1_firsttransfer = ili_nrd_s1_begins_xfer ? ili_nrd_s1_unreg_firsttransfer : ili_nrd_s1_reg_firsttransfer;

  //ili_nrd_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign ili_nrd_s1_unreg_firsttransfer = ~(ili_nrd_s1_slavearbiterlockenable & ili_nrd_s1_any_continuerequest);

  //ili_nrd_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_nrd_s1_reg_firsttransfer <= 1'b1;
      else if (ili_nrd_s1_begins_xfer)
          ili_nrd_s1_reg_firsttransfer <= ili_nrd_s1_unreg_firsttransfer;
    end


  //ili_nrd_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign ili_nrd_s1_beginbursttransfer_internal = ili_nrd_s1_begins_xfer;

  //~ili_nrd_s1_write_n assignment, which is an e_mux
  assign ili_nrd_s1_write_n = ~(pipeline_bridge_0_m1_granted_ili_nrd_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect));

  assign shifted_address_to_ili_nrd_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //ili_nrd_s1_address mux, which is an e_mux
  assign ili_nrd_s1_address = shifted_address_to_ili_nrd_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_ili_nrd_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_ili_nrd_s1_end_xfer <= 1;
      else 
        d1_ili_nrd_s1_end_xfer <= ili_nrd_s1_end_xfer;
    end


  //ili_nrd_s1_waits_for_read in a cycle, which is an e_mux
  assign ili_nrd_s1_waits_for_read = ili_nrd_s1_in_a_read_cycle & ili_nrd_s1_begins_xfer;

  //ili_nrd_s1_in_a_read_cycle assignment, which is an e_assign
  assign ili_nrd_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_ili_nrd_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ili_nrd_s1_in_a_read_cycle;

  //ili_nrd_s1_waits_for_write in a cycle, which is an e_mux
  assign ili_nrd_s1_waits_for_write = ili_nrd_s1_in_a_write_cycle & 0;

  //ili_nrd_s1_in_a_write_cycle assignment, which is an e_assign
  assign ili_nrd_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_ili_nrd_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ili_nrd_s1_in_a_write_cycle;

  assign wait_for_ili_nrd_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //ili_nrd/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_ili_nrd_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave ili_nrd/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ili_nrst_s1_arbitrator (
                                // inputs:
                                 clk,
                                 ili_nrst_s1_readdata,
                                 pipeline_bridge_0_m1_address_to_slave,
                                 pipeline_bridge_0_m1_burstcount,
                                 pipeline_bridge_0_m1_chipselect,
                                 pipeline_bridge_0_m1_latency_counter,
                                 pipeline_bridge_0_m1_read,
                                 pipeline_bridge_0_m1_write,
                                 pipeline_bridge_0_m1_writedata,
                                 reset_n,

                                // outputs:
                                 d1_ili_nrst_s1_end_xfer,
                                 ili_nrst_s1_address,
                                 ili_nrst_s1_chipselect,
                                 ili_nrst_s1_readdata_from_sa,
                                 ili_nrst_s1_reset_n,
                                 ili_nrst_s1_write_n,
                                 ili_nrst_s1_writedata,
                                 pipeline_bridge_0_m1_granted_ili_nrst_s1,
                                 pipeline_bridge_0_m1_qualified_request_ili_nrst_s1,
                                 pipeline_bridge_0_m1_read_data_valid_ili_nrst_s1,
                                 pipeline_bridge_0_m1_requests_ili_nrst_s1
                              )
;

  output           d1_ili_nrst_s1_end_xfer;
  output  [  1: 0] ili_nrst_s1_address;
  output           ili_nrst_s1_chipselect;
  output  [ 31: 0] ili_nrst_s1_readdata_from_sa;
  output           ili_nrst_s1_reset_n;
  output           ili_nrst_s1_write_n;
  output  [ 31: 0] ili_nrst_s1_writedata;
  output           pipeline_bridge_0_m1_granted_ili_nrst_s1;
  output           pipeline_bridge_0_m1_qualified_request_ili_nrst_s1;
  output           pipeline_bridge_0_m1_read_data_valid_ili_nrst_s1;
  output           pipeline_bridge_0_m1_requests_ili_nrst_s1;
  input            clk;
  input   [ 31: 0] ili_nrst_s1_readdata;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input   [ 31: 0] pipeline_bridge_0_m1_writedata;
  input            reset_n;

  reg              d1_ili_nrst_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_ili_nrst_s1;
  wire    [  1: 0] ili_nrst_s1_address;
  wire             ili_nrst_s1_allgrants;
  wire             ili_nrst_s1_allow_new_arb_cycle;
  wire             ili_nrst_s1_any_bursting_master_saved_grant;
  wire             ili_nrst_s1_any_continuerequest;
  wire             ili_nrst_s1_arb_counter_enable;
  reg              ili_nrst_s1_arb_share_counter;
  wire             ili_nrst_s1_arb_share_counter_next_value;
  wire             ili_nrst_s1_arb_share_set_values;
  wire             ili_nrst_s1_beginbursttransfer_internal;
  wire             ili_nrst_s1_begins_xfer;
  wire             ili_nrst_s1_chipselect;
  wire             ili_nrst_s1_end_xfer;
  wire             ili_nrst_s1_firsttransfer;
  wire             ili_nrst_s1_grant_vector;
  wire             ili_nrst_s1_in_a_read_cycle;
  wire             ili_nrst_s1_in_a_write_cycle;
  wire             ili_nrst_s1_master_qreq_vector;
  wire             ili_nrst_s1_non_bursting_master_requests;
  wire    [ 31: 0] ili_nrst_s1_readdata_from_sa;
  reg              ili_nrst_s1_reg_firsttransfer;
  wire             ili_nrst_s1_reset_n;
  reg              ili_nrst_s1_slavearbiterlockenable;
  wire             ili_nrst_s1_slavearbiterlockenable2;
  wire             ili_nrst_s1_unreg_firsttransfer;
  wire             ili_nrst_s1_waits_for_read;
  wire             ili_nrst_s1_waits_for_write;
  wire             ili_nrst_s1_write_n;
  wire    [ 31: 0] ili_nrst_s1_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_ili_nrst_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ili_nrst_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ili_nrst_s1;
  wire             pipeline_bridge_0_m1_requests_ili_nrst_s1;
  wire             pipeline_bridge_0_m1_saved_grant_ili_nrst_s1;
  wire    [  8: 0] shifted_address_to_ili_nrst_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_ili_nrst_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~ili_nrst_s1_end_xfer;
    end


  assign ili_nrst_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_ili_nrst_s1));
  //assign ili_nrst_s1_readdata_from_sa = ili_nrst_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ili_nrst_s1_readdata_from_sa = ili_nrst_s1_readdata;

  assign pipeline_bridge_0_m1_requests_ili_nrst_s1 = ({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'h10) & pipeline_bridge_0_m1_chipselect;
  //ili_nrst_s1_arb_share_counter set values, which is an e_mux
  assign ili_nrst_s1_arb_share_set_values = 1;

  //ili_nrst_s1_non_bursting_master_requests mux, which is an e_mux
  assign ili_nrst_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_ili_nrst_s1;

  //ili_nrst_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign ili_nrst_s1_any_bursting_master_saved_grant = 0;

  //ili_nrst_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign ili_nrst_s1_arb_share_counter_next_value = ili_nrst_s1_firsttransfer ? (ili_nrst_s1_arb_share_set_values - 1) : |ili_nrst_s1_arb_share_counter ? (ili_nrst_s1_arb_share_counter - 1) : 0;

  //ili_nrst_s1_allgrants all slave grants, which is an e_mux
  assign ili_nrst_s1_allgrants = |ili_nrst_s1_grant_vector;

  //ili_nrst_s1_end_xfer assignment, which is an e_assign
  assign ili_nrst_s1_end_xfer = ~(ili_nrst_s1_waits_for_read | ili_nrst_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_ili_nrst_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_ili_nrst_s1 = ili_nrst_s1_end_xfer & (~ili_nrst_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //ili_nrst_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign ili_nrst_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_ili_nrst_s1 & ili_nrst_s1_allgrants) | (end_xfer_arb_share_counter_term_ili_nrst_s1 & ~ili_nrst_s1_non_bursting_master_requests);

  //ili_nrst_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_nrst_s1_arb_share_counter <= 0;
      else if (ili_nrst_s1_arb_counter_enable)
          ili_nrst_s1_arb_share_counter <= ili_nrst_s1_arb_share_counter_next_value;
    end


  //ili_nrst_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_nrst_s1_slavearbiterlockenable <= 0;
      else if ((|ili_nrst_s1_master_qreq_vector & end_xfer_arb_share_counter_term_ili_nrst_s1) | (end_xfer_arb_share_counter_term_ili_nrst_s1 & ~ili_nrst_s1_non_bursting_master_requests))
          ili_nrst_s1_slavearbiterlockenable <= |ili_nrst_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 ili_nrst/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = ili_nrst_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //ili_nrst_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign ili_nrst_s1_slavearbiterlockenable2 = |ili_nrst_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 ili_nrst/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = ili_nrst_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //ili_nrst_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign ili_nrst_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_ili_nrst_s1 = pipeline_bridge_0_m1_requests_ili_nrst_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_ili_nrst_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_ili_nrst_s1 = pipeline_bridge_0_m1_granted_ili_nrst_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~ili_nrst_s1_waits_for_read;

  //ili_nrst_s1_writedata mux, which is an e_mux
  assign ili_nrst_s1_writedata = pipeline_bridge_0_m1_writedata;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_ili_nrst_s1 = pipeline_bridge_0_m1_qualified_request_ili_nrst_s1;

  //pipeline_bridge_0/m1 saved-grant ili_nrst/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_ili_nrst_s1 = pipeline_bridge_0_m1_requests_ili_nrst_s1;

  //allow new arb cycle for ili_nrst/s1, which is an e_assign
  assign ili_nrst_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign ili_nrst_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign ili_nrst_s1_master_qreq_vector = 1;

  //ili_nrst_s1_reset_n assignment, which is an e_assign
  assign ili_nrst_s1_reset_n = reset_n;

  assign ili_nrst_s1_chipselect = pipeline_bridge_0_m1_granted_ili_nrst_s1;
  //ili_nrst_s1_firsttransfer first transaction, which is an e_assign
  assign ili_nrst_s1_firsttransfer = ili_nrst_s1_begins_xfer ? ili_nrst_s1_unreg_firsttransfer : ili_nrst_s1_reg_firsttransfer;

  //ili_nrst_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign ili_nrst_s1_unreg_firsttransfer = ~(ili_nrst_s1_slavearbiterlockenable & ili_nrst_s1_any_continuerequest);

  //ili_nrst_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_nrst_s1_reg_firsttransfer <= 1'b1;
      else if (ili_nrst_s1_begins_xfer)
          ili_nrst_s1_reg_firsttransfer <= ili_nrst_s1_unreg_firsttransfer;
    end


  //ili_nrst_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign ili_nrst_s1_beginbursttransfer_internal = ili_nrst_s1_begins_xfer;

  //~ili_nrst_s1_write_n assignment, which is an e_mux
  assign ili_nrst_s1_write_n = ~(pipeline_bridge_0_m1_granted_ili_nrst_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect));

  assign shifted_address_to_ili_nrst_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //ili_nrst_s1_address mux, which is an e_mux
  assign ili_nrst_s1_address = shifted_address_to_ili_nrst_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_ili_nrst_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_ili_nrst_s1_end_xfer <= 1;
      else 
        d1_ili_nrst_s1_end_xfer <= ili_nrst_s1_end_xfer;
    end


  //ili_nrst_s1_waits_for_read in a cycle, which is an e_mux
  assign ili_nrst_s1_waits_for_read = ili_nrst_s1_in_a_read_cycle & ili_nrst_s1_begins_xfer;

  //ili_nrst_s1_in_a_read_cycle assignment, which is an e_assign
  assign ili_nrst_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_ili_nrst_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ili_nrst_s1_in_a_read_cycle;

  //ili_nrst_s1_waits_for_write in a cycle, which is an e_mux
  assign ili_nrst_s1_waits_for_write = ili_nrst_s1_in_a_write_cycle & 0;

  //ili_nrst_s1_in_a_write_cycle assignment, which is an e_assign
  assign ili_nrst_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_ili_nrst_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ili_nrst_s1_in_a_write_cycle;

  assign wait_for_ili_nrst_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //ili_nrst/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_ili_nrst_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave ili_nrst/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ili_nwr_s1_arbitrator (
                               // inputs:
                                clk,
                                ili_nwr_s1_readdata,
                                pipeline_bridge_0_m1_address_to_slave,
                                pipeline_bridge_0_m1_burstcount,
                                pipeline_bridge_0_m1_chipselect,
                                pipeline_bridge_0_m1_latency_counter,
                                pipeline_bridge_0_m1_read,
                                pipeline_bridge_0_m1_write,
                                pipeline_bridge_0_m1_writedata,
                                reset_n,

                               // outputs:
                                d1_ili_nwr_s1_end_xfer,
                                ili_nwr_s1_address,
                                ili_nwr_s1_chipselect,
                                ili_nwr_s1_readdata_from_sa,
                                ili_nwr_s1_reset_n,
                                ili_nwr_s1_write_n,
                                ili_nwr_s1_writedata,
                                pipeline_bridge_0_m1_granted_ili_nwr_s1,
                                pipeline_bridge_0_m1_qualified_request_ili_nwr_s1,
                                pipeline_bridge_0_m1_read_data_valid_ili_nwr_s1,
                                pipeline_bridge_0_m1_requests_ili_nwr_s1
                             )
;

  output           d1_ili_nwr_s1_end_xfer;
  output  [  1: 0] ili_nwr_s1_address;
  output           ili_nwr_s1_chipselect;
  output  [ 31: 0] ili_nwr_s1_readdata_from_sa;
  output           ili_nwr_s1_reset_n;
  output           ili_nwr_s1_write_n;
  output  [ 31: 0] ili_nwr_s1_writedata;
  output           pipeline_bridge_0_m1_granted_ili_nwr_s1;
  output           pipeline_bridge_0_m1_qualified_request_ili_nwr_s1;
  output           pipeline_bridge_0_m1_read_data_valid_ili_nwr_s1;
  output           pipeline_bridge_0_m1_requests_ili_nwr_s1;
  input            clk;
  input   [ 31: 0] ili_nwr_s1_readdata;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input   [ 31: 0] pipeline_bridge_0_m1_writedata;
  input            reset_n;

  reg              d1_ili_nwr_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_ili_nwr_s1;
  wire    [  1: 0] ili_nwr_s1_address;
  wire             ili_nwr_s1_allgrants;
  wire             ili_nwr_s1_allow_new_arb_cycle;
  wire             ili_nwr_s1_any_bursting_master_saved_grant;
  wire             ili_nwr_s1_any_continuerequest;
  wire             ili_nwr_s1_arb_counter_enable;
  reg              ili_nwr_s1_arb_share_counter;
  wire             ili_nwr_s1_arb_share_counter_next_value;
  wire             ili_nwr_s1_arb_share_set_values;
  wire             ili_nwr_s1_beginbursttransfer_internal;
  wire             ili_nwr_s1_begins_xfer;
  wire             ili_nwr_s1_chipselect;
  wire             ili_nwr_s1_end_xfer;
  wire             ili_nwr_s1_firsttransfer;
  wire             ili_nwr_s1_grant_vector;
  wire             ili_nwr_s1_in_a_read_cycle;
  wire             ili_nwr_s1_in_a_write_cycle;
  wire             ili_nwr_s1_master_qreq_vector;
  wire             ili_nwr_s1_non_bursting_master_requests;
  wire    [ 31: 0] ili_nwr_s1_readdata_from_sa;
  reg              ili_nwr_s1_reg_firsttransfer;
  wire             ili_nwr_s1_reset_n;
  reg              ili_nwr_s1_slavearbiterlockenable;
  wire             ili_nwr_s1_slavearbiterlockenable2;
  wire             ili_nwr_s1_unreg_firsttransfer;
  wire             ili_nwr_s1_waits_for_read;
  wire             ili_nwr_s1_waits_for_write;
  wire             ili_nwr_s1_write_n;
  wire    [ 31: 0] ili_nwr_s1_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_ili_nwr_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ili_nwr_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ili_nwr_s1;
  wire             pipeline_bridge_0_m1_requests_ili_nwr_s1;
  wire             pipeline_bridge_0_m1_saved_grant_ili_nwr_s1;
  wire    [  8: 0] shifted_address_to_ili_nwr_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_ili_nwr_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~ili_nwr_s1_end_xfer;
    end


  assign ili_nwr_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_ili_nwr_s1));
  //assign ili_nwr_s1_readdata_from_sa = ili_nwr_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ili_nwr_s1_readdata_from_sa = ili_nwr_s1_readdata;

  assign pipeline_bridge_0_m1_requests_ili_nwr_s1 = ({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'h30) & pipeline_bridge_0_m1_chipselect;
  //ili_nwr_s1_arb_share_counter set values, which is an e_mux
  assign ili_nwr_s1_arb_share_set_values = 1;

  //ili_nwr_s1_non_bursting_master_requests mux, which is an e_mux
  assign ili_nwr_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_ili_nwr_s1;

  //ili_nwr_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign ili_nwr_s1_any_bursting_master_saved_grant = 0;

  //ili_nwr_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign ili_nwr_s1_arb_share_counter_next_value = ili_nwr_s1_firsttransfer ? (ili_nwr_s1_arb_share_set_values - 1) : |ili_nwr_s1_arb_share_counter ? (ili_nwr_s1_arb_share_counter - 1) : 0;

  //ili_nwr_s1_allgrants all slave grants, which is an e_mux
  assign ili_nwr_s1_allgrants = |ili_nwr_s1_grant_vector;

  //ili_nwr_s1_end_xfer assignment, which is an e_assign
  assign ili_nwr_s1_end_xfer = ~(ili_nwr_s1_waits_for_read | ili_nwr_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_ili_nwr_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_ili_nwr_s1 = ili_nwr_s1_end_xfer & (~ili_nwr_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //ili_nwr_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign ili_nwr_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_ili_nwr_s1 & ili_nwr_s1_allgrants) | (end_xfer_arb_share_counter_term_ili_nwr_s1 & ~ili_nwr_s1_non_bursting_master_requests);

  //ili_nwr_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_nwr_s1_arb_share_counter <= 0;
      else if (ili_nwr_s1_arb_counter_enable)
          ili_nwr_s1_arb_share_counter <= ili_nwr_s1_arb_share_counter_next_value;
    end


  //ili_nwr_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_nwr_s1_slavearbiterlockenable <= 0;
      else if ((|ili_nwr_s1_master_qreq_vector & end_xfer_arb_share_counter_term_ili_nwr_s1) | (end_xfer_arb_share_counter_term_ili_nwr_s1 & ~ili_nwr_s1_non_bursting_master_requests))
          ili_nwr_s1_slavearbiterlockenable <= |ili_nwr_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 ili_nwr/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = ili_nwr_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //ili_nwr_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign ili_nwr_s1_slavearbiterlockenable2 = |ili_nwr_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 ili_nwr/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = ili_nwr_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //ili_nwr_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign ili_nwr_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_ili_nwr_s1 = pipeline_bridge_0_m1_requests_ili_nwr_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_ili_nwr_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_ili_nwr_s1 = pipeline_bridge_0_m1_granted_ili_nwr_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~ili_nwr_s1_waits_for_read;

  //ili_nwr_s1_writedata mux, which is an e_mux
  assign ili_nwr_s1_writedata = pipeline_bridge_0_m1_writedata;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_ili_nwr_s1 = pipeline_bridge_0_m1_qualified_request_ili_nwr_s1;

  //pipeline_bridge_0/m1 saved-grant ili_nwr/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_ili_nwr_s1 = pipeline_bridge_0_m1_requests_ili_nwr_s1;

  //allow new arb cycle for ili_nwr/s1, which is an e_assign
  assign ili_nwr_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign ili_nwr_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign ili_nwr_s1_master_qreq_vector = 1;

  //ili_nwr_s1_reset_n assignment, which is an e_assign
  assign ili_nwr_s1_reset_n = reset_n;

  assign ili_nwr_s1_chipselect = pipeline_bridge_0_m1_granted_ili_nwr_s1;
  //ili_nwr_s1_firsttransfer first transaction, which is an e_assign
  assign ili_nwr_s1_firsttransfer = ili_nwr_s1_begins_xfer ? ili_nwr_s1_unreg_firsttransfer : ili_nwr_s1_reg_firsttransfer;

  //ili_nwr_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign ili_nwr_s1_unreg_firsttransfer = ~(ili_nwr_s1_slavearbiterlockenable & ili_nwr_s1_any_continuerequest);

  //ili_nwr_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_nwr_s1_reg_firsttransfer <= 1'b1;
      else if (ili_nwr_s1_begins_xfer)
          ili_nwr_s1_reg_firsttransfer <= ili_nwr_s1_unreg_firsttransfer;
    end


  //ili_nwr_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign ili_nwr_s1_beginbursttransfer_internal = ili_nwr_s1_begins_xfer;

  //~ili_nwr_s1_write_n assignment, which is an e_mux
  assign ili_nwr_s1_write_n = ~(pipeline_bridge_0_m1_granted_ili_nwr_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect));

  assign shifted_address_to_ili_nwr_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //ili_nwr_s1_address mux, which is an e_mux
  assign ili_nwr_s1_address = shifted_address_to_ili_nwr_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_ili_nwr_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_ili_nwr_s1_end_xfer <= 1;
      else 
        d1_ili_nwr_s1_end_xfer <= ili_nwr_s1_end_xfer;
    end


  //ili_nwr_s1_waits_for_read in a cycle, which is an e_mux
  assign ili_nwr_s1_waits_for_read = ili_nwr_s1_in_a_read_cycle & ili_nwr_s1_begins_xfer;

  //ili_nwr_s1_in_a_read_cycle assignment, which is an e_assign
  assign ili_nwr_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_ili_nwr_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ili_nwr_s1_in_a_read_cycle;

  //ili_nwr_s1_waits_for_write in a cycle, which is an e_mux
  assign ili_nwr_s1_waits_for_write = ili_nwr_s1_in_a_write_cycle & 0;

  //ili_nwr_s1_in_a_write_cycle assignment, which is an e_assign
  assign ili_nwr_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_ili_nwr_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ili_nwr_s1_in_a_write_cycle;

  assign wait_for_ili_nwr_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //ili_nwr/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_ili_nwr_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave ili_nwr/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module ili_rs_s1_arbitrator (
                              // inputs:
                               clk,
                               ili_rs_s1_readdata,
                               pipeline_bridge_0_m1_address_to_slave,
                               pipeline_bridge_0_m1_burstcount,
                               pipeline_bridge_0_m1_chipselect,
                               pipeline_bridge_0_m1_latency_counter,
                               pipeline_bridge_0_m1_read,
                               pipeline_bridge_0_m1_write,
                               pipeline_bridge_0_m1_writedata,
                               reset_n,

                              // outputs:
                               d1_ili_rs_s1_end_xfer,
                               ili_rs_s1_address,
                               ili_rs_s1_chipselect,
                               ili_rs_s1_readdata_from_sa,
                               ili_rs_s1_reset_n,
                               ili_rs_s1_write_n,
                               ili_rs_s1_writedata,
                               pipeline_bridge_0_m1_granted_ili_rs_s1,
                               pipeline_bridge_0_m1_qualified_request_ili_rs_s1,
                               pipeline_bridge_0_m1_read_data_valid_ili_rs_s1,
                               pipeline_bridge_0_m1_requests_ili_rs_s1
                            )
;

  output           d1_ili_rs_s1_end_xfer;
  output  [  1: 0] ili_rs_s1_address;
  output           ili_rs_s1_chipselect;
  output  [ 31: 0] ili_rs_s1_readdata_from_sa;
  output           ili_rs_s1_reset_n;
  output           ili_rs_s1_write_n;
  output  [ 31: 0] ili_rs_s1_writedata;
  output           pipeline_bridge_0_m1_granted_ili_rs_s1;
  output           pipeline_bridge_0_m1_qualified_request_ili_rs_s1;
  output           pipeline_bridge_0_m1_read_data_valid_ili_rs_s1;
  output           pipeline_bridge_0_m1_requests_ili_rs_s1;
  input            clk;
  input   [ 31: 0] ili_rs_s1_readdata;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input   [ 31: 0] pipeline_bridge_0_m1_writedata;
  input            reset_n;

  reg              d1_ili_rs_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_ili_rs_s1;
  wire    [  1: 0] ili_rs_s1_address;
  wire             ili_rs_s1_allgrants;
  wire             ili_rs_s1_allow_new_arb_cycle;
  wire             ili_rs_s1_any_bursting_master_saved_grant;
  wire             ili_rs_s1_any_continuerequest;
  wire             ili_rs_s1_arb_counter_enable;
  reg              ili_rs_s1_arb_share_counter;
  wire             ili_rs_s1_arb_share_counter_next_value;
  wire             ili_rs_s1_arb_share_set_values;
  wire             ili_rs_s1_beginbursttransfer_internal;
  wire             ili_rs_s1_begins_xfer;
  wire             ili_rs_s1_chipselect;
  wire             ili_rs_s1_end_xfer;
  wire             ili_rs_s1_firsttransfer;
  wire             ili_rs_s1_grant_vector;
  wire             ili_rs_s1_in_a_read_cycle;
  wire             ili_rs_s1_in_a_write_cycle;
  wire             ili_rs_s1_master_qreq_vector;
  wire             ili_rs_s1_non_bursting_master_requests;
  wire    [ 31: 0] ili_rs_s1_readdata_from_sa;
  reg              ili_rs_s1_reg_firsttransfer;
  wire             ili_rs_s1_reset_n;
  reg              ili_rs_s1_slavearbiterlockenable;
  wire             ili_rs_s1_slavearbiterlockenable2;
  wire             ili_rs_s1_unreg_firsttransfer;
  wire             ili_rs_s1_waits_for_read;
  wire             ili_rs_s1_waits_for_write;
  wire             ili_rs_s1_write_n;
  wire    [ 31: 0] ili_rs_s1_writedata;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_ili_rs_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ili_rs_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ili_rs_s1;
  wire             pipeline_bridge_0_m1_requests_ili_rs_s1;
  wire             pipeline_bridge_0_m1_saved_grant_ili_rs_s1;
  wire    [  8: 0] shifted_address_to_ili_rs_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_ili_rs_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~ili_rs_s1_end_xfer;
    end


  assign ili_rs_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_ili_rs_s1));
  //assign ili_rs_s1_readdata_from_sa = ili_rs_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign ili_rs_s1_readdata_from_sa = ili_rs_s1_readdata;

  assign pipeline_bridge_0_m1_requests_ili_rs_s1 = ({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'h50) & pipeline_bridge_0_m1_chipselect;
  //ili_rs_s1_arb_share_counter set values, which is an e_mux
  assign ili_rs_s1_arb_share_set_values = 1;

  //ili_rs_s1_non_bursting_master_requests mux, which is an e_mux
  assign ili_rs_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_ili_rs_s1;

  //ili_rs_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign ili_rs_s1_any_bursting_master_saved_grant = 0;

  //ili_rs_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign ili_rs_s1_arb_share_counter_next_value = ili_rs_s1_firsttransfer ? (ili_rs_s1_arb_share_set_values - 1) : |ili_rs_s1_arb_share_counter ? (ili_rs_s1_arb_share_counter - 1) : 0;

  //ili_rs_s1_allgrants all slave grants, which is an e_mux
  assign ili_rs_s1_allgrants = |ili_rs_s1_grant_vector;

  //ili_rs_s1_end_xfer assignment, which is an e_assign
  assign ili_rs_s1_end_xfer = ~(ili_rs_s1_waits_for_read | ili_rs_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_ili_rs_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_ili_rs_s1 = ili_rs_s1_end_xfer & (~ili_rs_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //ili_rs_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign ili_rs_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_ili_rs_s1 & ili_rs_s1_allgrants) | (end_xfer_arb_share_counter_term_ili_rs_s1 & ~ili_rs_s1_non_bursting_master_requests);

  //ili_rs_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_rs_s1_arb_share_counter <= 0;
      else if (ili_rs_s1_arb_counter_enable)
          ili_rs_s1_arb_share_counter <= ili_rs_s1_arb_share_counter_next_value;
    end


  //ili_rs_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_rs_s1_slavearbiterlockenable <= 0;
      else if ((|ili_rs_s1_master_qreq_vector & end_xfer_arb_share_counter_term_ili_rs_s1) | (end_xfer_arb_share_counter_term_ili_rs_s1 & ~ili_rs_s1_non_bursting_master_requests))
          ili_rs_s1_slavearbiterlockenable <= |ili_rs_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 ili_rs/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = ili_rs_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //ili_rs_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign ili_rs_s1_slavearbiterlockenable2 = |ili_rs_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 ili_rs/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = ili_rs_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //ili_rs_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign ili_rs_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_ili_rs_s1 = pipeline_bridge_0_m1_requests_ili_rs_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_ili_rs_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_ili_rs_s1 = pipeline_bridge_0_m1_granted_ili_rs_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~ili_rs_s1_waits_for_read;

  //ili_rs_s1_writedata mux, which is an e_mux
  assign ili_rs_s1_writedata = pipeline_bridge_0_m1_writedata;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_ili_rs_s1 = pipeline_bridge_0_m1_qualified_request_ili_rs_s1;

  //pipeline_bridge_0/m1 saved-grant ili_rs/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_ili_rs_s1 = pipeline_bridge_0_m1_requests_ili_rs_s1;

  //allow new arb cycle for ili_rs/s1, which is an e_assign
  assign ili_rs_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign ili_rs_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign ili_rs_s1_master_qreq_vector = 1;

  //ili_rs_s1_reset_n assignment, which is an e_assign
  assign ili_rs_s1_reset_n = reset_n;

  assign ili_rs_s1_chipselect = pipeline_bridge_0_m1_granted_ili_rs_s1;
  //ili_rs_s1_firsttransfer first transaction, which is an e_assign
  assign ili_rs_s1_firsttransfer = ili_rs_s1_begins_xfer ? ili_rs_s1_unreg_firsttransfer : ili_rs_s1_reg_firsttransfer;

  //ili_rs_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign ili_rs_s1_unreg_firsttransfer = ~(ili_rs_s1_slavearbiterlockenable & ili_rs_s1_any_continuerequest);

  //ili_rs_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          ili_rs_s1_reg_firsttransfer <= 1'b1;
      else if (ili_rs_s1_begins_xfer)
          ili_rs_s1_reg_firsttransfer <= ili_rs_s1_unreg_firsttransfer;
    end


  //ili_rs_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign ili_rs_s1_beginbursttransfer_internal = ili_rs_s1_begins_xfer;

  //~ili_rs_s1_write_n assignment, which is an e_mux
  assign ili_rs_s1_write_n = ~(pipeline_bridge_0_m1_granted_ili_rs_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect));

  assign shifted_address_to_ili_rs_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //ili_rs_s1_address mux, which is an e_mux
  assign ili_rs_s1_address = shifted_address_to_ili_rs_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_ili_rs_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_ili_rs_s1_end_xfer <= 1;
      else 
        d1_ili_rs_s1_end_xfer <= ili_rs_s1_end_xfer;
    end


  //ili_rs_s1_waits_for_read in a cycle, which is an e_mux
  assign ili_rs_s1_waits_for_read = ili_rs_s1_in_a_read_cycle & ili_rs_s1_begins_xfer;

  //ili_rs_s1_in_a_read_cycle assignment, which is an e_assign
  assign ili_rs_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_ili_rs_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = ili_rs_s1_in_a_read_cycle;

  //ili_rs_s1_waits_for_write in a cycle, which is an e_mux
  assign ili_rs_s1_waits_for_write = ili_rs_s1_in_a_write_cycle & 0;

  //ili_rs_s1_in_a_write_cycle assignment, which is an e_assign
  assign ili_rs_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_ili_rs_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = ili_rs_s1_in_a_write_cycle;

  assign wait_for_ili_rs_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //ili_rs/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_ili_rs_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave ili_rs/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module jtag_uart_avalon_jtag_slave_arbitrator (
                                                // inputs:
                                                 clk,
                                                 jtag_uart_avalon_jtag_slave_dataavailable,
                                                 jtag_uart_avalon_jtag_slave_irq,
                                                 jtag_uart_avalon_jtag_slave_readdata,
                                                 jtag_uart_avalon_jtag_slave_readyfordata,
                                                 jtag_uart_avalon_jtag_slave_waitrequest,
                                                 nios_f_data_master_address_to_slave,
                                                 nios_f_data_master_read,
                                                 nios_f_data_master_waitrequest,
                                                 nios_f_data_master_write,
                                                 nios_f_data_master_writedata,
                                                 reset_n,

                                                // outputs:
                                                 d1_jtag_uart_avalon_jtag_slave_end_xfer,
                                                 jtag_uart_avalon_jtag_slave_address,
                                                 jtag_uart_avalon_jtag_slave_chipselect,
                                                 jtag_uart_avalon_jtag_slave_dataavailable_from_sa,
                                                 jtag_uart_avalon_jtag_slave_irq_from_sa,
                                                 jtag_uart_avalon_jtag_slave_read_n,
                                                 jtag_uart_avalon_jtag_slave_readdata_from_sa,
                                                 jtag_uart_avalon_jtag_slave_readyfordata_from_sa,
                                                 jtag_uart_avalon_jtag_slave_reset_n,
                                                 jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
                                                 jtag_uart_avalon_jtag_slave_write_n,
                                                 jtag_uart_avalon_jtag_slave_writedata,
                                                 nios_f_data_master_granted_jtag_uart_avalon_jtag_slave,
                                                 nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
                                                 nios_f_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
                                                 nios_f_data_master_requests_jtag_uart_avalon_jtag_slave
                                              )
;

  output           d1_jtag_uart_avalon_jtag_slave_end_xfer;
  output           jtag_uart_avalon_jtag_slave_address;
  output           jtag_uart_avalon_jtag_slave_chipselect;
  output           jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  output           jtag_uart_avalon_jtag_slave_irq_from_sa;
  output           jtag_uart_avalon_jtag_slave_read_n;
  output  [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  output           jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  output           jtag_uart_avalon_jtag_slave_reset_n;
  output           jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  output           jtag_uart_avalon_jtag_slave_write_n;
  output  [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  output           nios_f_data_master_granted_jtag_uart_avalon_jtag_slave;
  output           nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  output           nios_f_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  output           nios_f_data_master_requests_jtag_uart_avalon_jtag_slave;
  input            clk;
  input            jtag_uart_avalon_jtag_slave_dataavailable;
  input            jtag_uart_avalon_jtag_slave_irq;
  input   [ 31: 0] jtag_uart_avalon_jtag_slave_readdata;
  input            jtag_uart_avalon_jtag_slave_readyfordata;
  input            jtag_uart_avalon_jtag_slave_waitrequest;
  input   [ 25: 0] nios_f_data_master_address_to_slave;
  input            nios_f_data_master_read;
  input            nios_f_data_master_waitrequest;
  input            nios_f_data_master_write;
  input   [ 31: 0] nios_f_data_master_writedata;
  input            reset_n;

  reg              d1_jtag_uart_avalon_jtag_slave_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             jtag_uart_avalon_jtag_slave_address;
  wire             jtag_uart_avalon_jtag_slave_allgrants;
  wire             jtag_uart_avalon_jtag_slave_allow_new_arb_cycle;
  wire             jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant;
  wire             jtag_uart_avalon_jtag_slave_any_continuerequest;
  wire             jtag_uart_avalon_jtag_slave_arb_counter_enable;
  reg     [  1: 0] jtag_uart_avalon_jtag_slave_arb_share_counter;
  wire    [  1: 0] jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
  wire    [  1: 0] jtag_uart_avalon_jtag_slave_arb_share_set_values;
  wire             jtag_uart_avalon_jtag_slave_beginbursttransfer_internal;
  wire             jtag_uart_avalon_jtag_slave_begins_xfer;
  wire             jtag_uart_avalon_jtag_slave_chipselect;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_end_xfer;
  wire             jtag_uart_avalon_jtag_slave_firsttransfer;
  wire             jtag_uart_avalon_jtag_slave_grant_vector;
  wire             jtag_uart_avalon_jtag_slave_in_a_read_cycle;
  wire             jtag_uart_avalon_jtag_slave_in_a_write_cycle;
  wire             jtag_uart_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_avalon_jtag_slave_master_qreq_vector;
  wire             jtag_uart_avalon_jtag_slave_non_bursting_master_requests;
  wire             jtag_uart_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  reg              jtag_uart_avalon_jtag_slave_reg_firsttransfer;
  wire             jtag_uart_avalon_jtag_slave_reset_n;
  reg              jtag_uart_avalon_jtag_slave_slavearbiterlockenable;
  wire             jtag_uart_avalon_jtag_slave_slavearbiterlockenable2;
  wire             jtag_uart_avalon_jtag_slave_unreg_firsttransfer;
  wire             jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_avalon_jtag_slave_waits_for_read;
  wire             jtag_uart_avalon_jtag_slave_waits_for_write;
  wire             jtag_uart_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  wire             nios_f_data_master_arbiterlock;
  wire             nios_f_data_master_arbiterlock2;
  wire             nios_f_data_master_continuerequest;
  wire             nios_f_data_master_granted_jtag_uart_avalon_jtag_slave;
  wire             nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  wire             nios_f_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  wire             nios_f_data_master_requests_jtag_uart_avalon_jtag_slave;
  wire             nios_f_data_master_saved_grant_jtag_uart_avalon_jtag_slave;
  wire    [ 25: 0] shifted_address_to_jtag_uart_avalon_jtag_slave_from_nios_f_data_master;
  wire             wait_for_jtag_uart_avalon_jtag_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~jtag_uart_avalon_jtag_slave_end_xfer;
    end


  assign jtag_uart_avalon_jtag_slave_begins_xfer = ~d1_reasons_to_wait & ((nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave));
  //assign jtag_uart_avalon_jtag_slave_readdata_from_sa = jtag_uart_avalon_jtag_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_readdata_from_sa = jtag_uart_avalon_jtag_slave_readdata;

  assign nios_f_data_master_requests_jtag_uart_avalon_jtag_slave = ({nios_f_data_master_address_to_slave[25 : 3] , 3'b0} == 26'h3002060) & (nios_f_data_master_read | nios_f_data_master_write);
  //assign jtag_uart_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_avalon_jtag_slave_dataavailable so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_dataavailable_from_sa = jtag_uart_avalon_jtag_slave_dataavailable;

  //assign jtag_uart_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_avalon_jtag_slave_readyfordata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_readyfordata_from_sa = jtag_uart_avalon_jtag_slave_readyfordata;

  //assign jtag_uart_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_avalon_jtag_slave_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_waitrequest_from_sa = jtag_uart_avalon_jtag_slave_waitrequest;

  //jtag_uart_avalon_jtag_slave_arb_share_counter set values, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_arb_share_set_values = 1;

  //jtag_uart_avalon_jtag_slave_non_bursting_master_requests mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_non_bursting_master_requests = nios_f_data_master_requests_jtag_uart_avalon_jtag_slave;

  //jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant = 0;

  //jtag_uart_avalon_jtag_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_arb_share_counter_next_value = jtag_uart_avalon_jtag_slave_firsttransfer ? (jtag_uart_avalon_jtag_slave_arb_share_set_values - 1) : |jtag_uart_avalon_jtag_slave_arb_share_counter ? (jtag_uart_avalon_jtag_slave_arb_share_counter - 1) : 0;

  //jtag_uart_avalon_jtag_slave_allgrants all slave grants, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_allgrants = |jtag_uart_avalon_jtag_slave_grant_vector;

  //jtag_uart_avalon_jtag_slave_end_xfer assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_end_xfer = ~(jtag_uart_avalon_jtag_slave_waits_for_read | jtag_uart_avalon_jtag_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave = jtag_uart_avalon_jtag_slave_end_xfer & (~jtag_uart_avalon_jtag_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //jtag_uart_avalon_jtag_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & jtag_uart_avalon_jtag_slave_allgrants) | (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & ~jtag_uart_avalon_jtag_slave_non_bursting_master_requests);

  //jtag_uart_avalon_jtag_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_avalon_jtag_slave_arb_share_counter <= 0;
      else if (jtag_uart_avalon_jtag_slave_arb_counter_enable)
          jtag_uart_avalon_jtag_slave_arb_share_counter <= jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //jtag_uart_avalon_jtag_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= 0;
      else if ((|jtag_uart_avalon_jtag_slave_master_qreq_vector & end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave) | (end_xfer_arb_share_counter_term_jtag_uart_avalon_jtag_slave & ~jtag_uart_avalon_jtag_slave_non_bursting_master_requests))
          jtag_uart_avalon_jtag_slave_slavearbiterlockenable <= |jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;
    end


  //nios_f/data_master jtag_uart/avalon_jtag_slave arbiterlock, which is an e_assign
  assign nios_f_data_master_arbiterlock = jtag_uart_avalon_jtag_slave_slavearbiterlockenable & nios_f_data_master_continuerequest;

  //jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 = |jtag_uart_avalon_jtag_slave_arb_share_counter_next_value;

  //nios_f/data_master jtag_uart/avalon_jtag_slave arbiterlock2, which is an e_assign
  assign nios_f_data_master_arbiterlock2 = jtag_uart_avalon_jtag_slave_slavearbiterlockenable2 & nios_f_data_master_continuerequest;

  //jtag_uart_avalon_jtag_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_any_continuerequest = 1;

  //nios_f_data_master_continuerequest continued request, which is an e_assign
  assign nios_f_data_master_continuerequest = 1;

  assign nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave = nios_f_data_master_requests_jtag_uart_avalon_jtag_slave & ~((nios_f_data_master_read & (~nios_f_data_master_waitrequest)) | ((~nios_f_data_master_waitrequest) & nios_f_data_master_write));
  //jtag_uart_avalon_jtag_slave_writedata mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_writedata = nios_f_data_master_writedata;

  //master is always granted when requested
  assign nios_f_data_master_granted_jtag_uart_avalon_jtag_slave = nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave;

  //nios_f/data_master saved-grant jtag_uart/avalon_jtag_slave, which is an e_assign
  assign nios_f_data_master_saved_grant_jtag_uart_avalon_jtag_slave = nios_f_data_master_requests_jtag_uart_avalon_jtag_slave;

  //allow new arb cycle for jtag_uart/avalon_jtag_slave, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign jtag_uart_avalon_jtag_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign jtag_uart_avalon_jtag_slave_master_qreq_vector = 1;

  //jtag_uart_avalon_jtag_slave_reset_n assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_reset_n = reset_n;

  assign jtag_uart_avalon_jtag_slave_chipselect = nios_f_data_master_granted_jtag_uart_avalon_jtag_slave;
  //jtag_uart_avalon_jtag_slave_firsttransfer first transaction, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_firsttransfer = jtag_uart_avalon_jtag_slave_begins_xfer ? jtag_uart_avalon_jtag_slave_unreg_firsttransfer : jtag_uart_avalon_jtag_slave_reg_firsttransfer;

  //jtag_uart_avalon_jtag_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_unreg_firsttransfer = ~(jtag_uart_avalon_jtag_slave_slavearbiterlockenable & jtag_uart_avalon_jtag_slave_any_continuerequest);

  //jtag_uart_avalon_jtag_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          jtag_uart_avalon_jtag_slave_reg_firsttransfer <= 1'b1;
      else if (jtag_uart_avalon_jtag_slave_begins_xfer)
          jtag_uart_avalon_jtag_slave_reg_firsttransfer <= jtag_uart_avalon_jtag_slave_unreg_firsttransfer;
    end


  //jtag_uart_avalon_jtag_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_beginbursttransfer_internal = jtag_uart_avalon_jtag_slave_begins_xfer;

  //~jtag_uart_avalon_jtag_slave_read_n assignment, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_read_n = ~(nios_f_data_master_granted_jtag_uart_avalon_jtag_slave & nios_f_data_master_read);

  //~jtag_uart_avalon_jtag_slave_write_n assignment, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_write_n = ~(nios_f_data_master_granted_jtag_uart_avalon_jtag_slave & nios_f_data_master_write);

  assign shifted_address_to_jtag_uart_avalon_jtag_slave_from_nios_f_data_master = nios_f_data_master_address_to_slave;
  //jtag_uart_avalon_jtag_slave_address mux, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_address = shifted_address_to_jtag_uart_avalon_jtag_slave_from_nios_f_data_master >> 2;

  //d1_jtag_uart_avalon_jtag_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_jtag_uart_avalon_jtag_slave_end_xfer <= 1;
      else 
        d1_jtag_uart_avalon_jtag_slave_end_xfer <= jtag_uart_avalon_jtag_slave_end_xfer;
    end


  //jtag_uart_avalon_jtag_slave_waits_for_read in a cycle, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_waits_for_read = jtag_uart_avalon_jtag_slave_in_a_read_cycle & jtag_uart_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_avalon_jtag_slave_in_a_read_cycle assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_in_a_read_cycle = nios_f_data_master_granted_jtag_uart_avalon_jtag_slave & nios_f_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = jtag_uart_avalon_jtag_slave_in_a_read_cycle;

  //jtag_uart_avalon_jtag_slave_waits_for_write in a cycle, which is an e_mux
  assign jtag_uart_avalon_jtag_slave_waits_for_write = jtag_uart_avalon_jtag_slave_in_a_write_cycle & jtag_uart_avalon_jtag_slave_waitrequest_from_sa;

  //jtag_uart_avalon_jtag_slave_in_a_write_cycle assignment, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_in_a_write_cycle = nios_f_data_master_granted_jtag_uart_avalon_jtag_slave & nios_f_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = jtag_uart_avalon_jtag_slave_in_a_write_cycle;

  assign wait_for_jtag_uart_avalon_jtag_slave_counter = 0;
  //assign jtag_uart_avalon_jtag_slave_irq_from_sa = jtag_uart_avalon_jtag_slave_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign jtag_uart_avalon_jtag_slave_irq_from_sa = jtag_uart_avalon_jtag_slave_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //jtag_uart/avalon_jtag_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module nios_f_jtag_debug_module_arbitrator (
                                             // inputs:
                                              clk,
                                              nios_f_data_master_address_to_slave,
                                              nios_f_data_master_byteenable,
                                              nios_f_data_master_debugaccess,
                                              nios_f_data_master_read,
                                              nios_f_data_master_waitrequest,
                                              nios_f_data_master_write,
                                              nios_f_data_master_writedata,
                                              nios_f_instruction_master_address_to_slave,
                                              nios_f_instruction_master_latency_counter,
                                              nios_f_instruction_master_read,
                                              nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register,
                                              nios_f_instruction_master_read_data_valid_sdram_s1_shift_register,
                                              nios_f_jtag_debug_module_readdata,
                                              nios_f_jtag_debug_module_resetrequest,
                                              reset_n,

                                             // outputs:
                                              d1_nios_f_jtag_debug_module_end_xfer,
                                              nios_f_data_master_granted_nios_f_jtag_debug_module,
                                              nios_f_data_master_qualified_request_nios_f_jtag_debug_module,
                                              nios_f_data_master_read_data_valid_nios_f_jtag_debug_module,
                                              nios_f_data_master_requests_nios_f_jtag_debug_module,
                                              nios_f_instruction_master_granted_nios_f_jtag_debug_module,
                                              nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module,
                                              nios_f_instruction_master_read_data_valid_nios_f_jtag_debug_module,
                                              nios_f_instruction_master_requests_nios_f_jtag_debug_module,
                                              nios_f_jtag_debug_module_address,
                                              nios_f_jtag_debug_module_begintransfer,
                                              nios_f_jtag_debug_module_byteenable,
                                              nios_f_jtag_debug_module_chipselect,
                                              nios_f_jtag_debug_module_debugaccess,
                                              nios_f_jtag_debug_module_readdata_from_sa,
                                              nios_f_jtag_debug_module_reset_n,
                                              nios_f_jtag_debug_module_resetrequest_from_sa,
                                              nios_f_jtag_debug_module_write,
                                              nios_f_jtag_debug_module_writedata
                                           )
;

  output           d1_nios_f_jtag_debug_module_end_xfer;
  output           nios_f_data_master_granted_nios_f_jtag_debug_module;
  output           nios_f_data_master_qualified_request_nios_f_jtag_debug_module;
  output           nios_f_data_master_read_data_valid_nios_f_jtag_debug_module;
  output           nios_f_data_master_requests_nios_f_jtag_debug_module;
  output           nios_f_instruction_master_granted_nios_f_jtag_debug_module;
  output           nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module;
  output           nios_f_instruction_master_read_data_valid_nios_f_jtag_debug_module;
  output           nios_f_instruction_master_requests_nios_f_jtag_debug_module;
  output  [  8: 0] nios_f_jtag_debug_module_address;
  output           nios_f_jtag_debug_module_begintransfer;
  output  [  3: 0] nios_f_jtag_debug_module_byteenable;
  output           nios_f_jtag_debug_module_chipselect;
  output           nios_f_jtag_debug_module_debugaccess;
  output  [ 31: 0] nios_f_jtag_debug_module_readdata_from_sa;
  output           nios_f_jtag_debug_module_reset_n;
  output           nios_f_jtag_debug_module_resetrequest_from_sa;
  output           nios_f_jtag_debug_module_write;
  output  [ 31: 0] nios_f_jtag_debug_module_writedata;
  input            clk;
  input   [ 25: 0] nios_f_data_master_address_to_slave;
  input   [  3: 0] nios_f_data_master_byteenable;
  input            nios_f_data_master_debugaccess;
  input            nios_f_data_master_read;
  input            nios_f_data_master_waitrequest;
  input            nios_f_data_master_write;
  input   [ 31: 0] nios_f_data_master_writedata;
  input   [ 25: 0] nios_f_instruction_master_address_to_slave;
  input            nios_f_instruction_master_latency_counter;
  input            nios_f_instruction_master_read;
  input            nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register;
  input            nios_f_instruction_master_read_data_valid_sdram_s1_shift_register;
  input   [ 31: 0] nios_f_jtag_debug_module_readdata;
  input            nios_f_jtag_debug_module_resetrequest;
  input            reset_n;

  reg              d1_nios_f_jtag_debug_module_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_nios_f_jtag_debug_module;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_nios_f_data_master_granted_slave_nios_f_jtag_debug_module;
  reg              last_cycle_nios_f_instruction_master_granted_slave_nios_f_jtag_debug_module;
  wire             nios_f_data_master_arbiterlock;
  wire             nios_f_data_master_arbiterlock2;
  wire             nios_f_data_master_continuerequest;
  wire             nios_f_data_master_granted_nios_f_jtag_debug_module;
  wire             nios_f_data_master_qualified_request_nios_f_jtag_debug_module;
  wire             nios_f_data_master_read_data_valid_nios_f_jtag_debug_module;
  wire             nios_f_data_master_requests_nios_f_jtag_debug_module;
  wire             nios_f_data_master_saved_grant_nios_f_jtag_debug_module;
  wire             nios_f_instruction_master_arbiterlock;
  wire             nios_f_instruction_master_arbiterlock2;
  wire             nios_f_instruction_master_continuerequest;
  wire             nios_f_instruction_master_granted_nios_f_jtag_debug_module;
  wire             nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module;
  wire             nios_f_instruction_master_read_data_valid_nios_f_jtag_debug_module;
  wire             nios_f_instruction_master_requests_nios_f_jtag_debug_module;
  wire             nios_f_instruction_master_saved_grant_nios_f_jtag_debug_module;
  wire    [  8: 0] nios_f_jtag_debug_module_address;
  wire             nios_f_jtag_debug_module_allgrants;
  wire             nios_f_jtag_debug_module_allow_new_arb_cycle;
  wire             nios_f_jtag_debug_module_any_bursting_master_saved_grant;
  wire             nios_f_jtag_debug_module_any_continuerequest;
  reg     [  1: 0] nios_f_jtag_debug_module_arb_addend;
  wire             nios_f_jtag_debug_module_arb_counter_enable;
  reg     [  1: 0] nios_f_jtag_debug_module_arb_share_counter;
  wire    [  1: 0] nios_f_jtag_debug_module_arb_share_counter_next_value;
  wire    [  1: 0] nios_f_jtag_debug_module_arb_share_set_values;
  wire    [  1: 0] nios_f_jtag_debug_module_arb_winner;
  wire             nios_f_jtag_debug_module_arbitration_holdoff_internal;
  wire             nios_f_jtag_debug_module_beginbursttransfer_internal;
  wire             nios_f_jtag_debug_module_begins_xfer;
  wire             nios_f_jtag_debug_module_begintransfer;
  wire    [  3: 0] nios_f_jtag_debug_module_byteenable;
  wire             nios_f_jtag_debug_module_chipselect;
  wire    [  3: 0] nios_f_jtag_debug_module_chosen_master_double_vector;
  wire    [  1: 0] nios_f_jtag_debug_module_chosen_master_rot_left;
  wire             nios_f_jtag_debug_module_debugaccess;
  wire             nios_f_jtag_debug_module_end_xfer;
  wire             nios_f_jtag_debug_module_firsttransfer;
  wire    [  1: 0] nios_f_jtag_debug_module_grant_vector;
  wire             nios_f_jtag_debug_module_in_a_read_cycle;
  wire             nios_f_jtag_debug_module_in_a_write_cycle;
  wire    [  1: 0] nios_f_jtag_debug_module_master_qreq_vector;
  wire             nios_f_jtag_debug_module_non_bursting_master_requests;
  wire    [ 31: 0] nios_f_jtag_debug_module_readdata_from_sa;
  reg              nios_f_jtag_debug_module_reg_firsttransfer;
  wire             nios_f_jtag_debug_module_reset_n;
  wire             nios_f_jtag_debug_module_resetrequest_from_sa;
  reg     [  1: 0] nios_f_jtag_debug_module_saved_chosen_master_vector;
  reg              nios_f_jtag_debug_module_slavearbiterlockenable;
  wire             nios_f_jtag_debug_module_slavearbiterlockenable2;
  wire             nios_f_jtag_debug_module_unreg_firsttransfer;
  wire             nios_f_jtag_debug_module_waits_for_read;
  wire             nios_f_jtag_debug_module_waits_for_write;
  wire             nios_f_jtag_debug_module_write;
  wire    [ 31: 0] nios_f_jtag_debug_module_writedata;
  wire    [ 25: 0] shifted_address_to_nios_f_jtag_debug_module_from_nios_f_data_master;
  wire    [ 25: 0] shifted_address_to_nios_f_jtag_debug_module_from_nios_f_instruction_master;
  wire             wait_for_nios_f_jtag_debug_module_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~nios_f_jtag_debug_module_end_xfer;
    end


  assign nios_f_jtag_debug_module_begins_xfer = ~d1_reasons_to_wait & ((nios_f_data_master_qualified_request_nios_f_jtag_debug_module | nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module));
  //assign nios_f_jtag_debug_module_readdata_from_sa = nios_f_jtag_debug_module_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign nios_f_jtag_debug_module_readdata_from_sa = nios_f_jtag_debug_module_readdata;

  assign nios_f_data_master_requests_nios_f_jtag_debug_module = ({nios_f_data_master_address_to_slave[25 : 11] , 11'b0} == 26'h3001000) & (nios_f_data_master_read | nios_f_data_master_write);
  //nios_f_jtag_debug_module_arb_share_counter set values, which is an e_mux
  assign nios_f_jtag_debug_module_arb_share_set_values = 1;

  //nios_f_jtag_debug_module_non_bursting_master_requests mux, which is an e_mux
  assign nios_f_jtag_debug_module_non_bursting_master_requests = nios_f_data_master_requests_nios_f_jtag_debug_module |
    nios_f_instruction_master_requests_nios_f_jtag_debug_module |
    nios_f_data_master_requests_nios_f_jtag_debug_module |
    nios_f_instruction_master_requests_nios_f_jtag_debug_module;

  //nios_f_jtag_debug_module_any_bursting_master_saved_grant mux, which is an e_mux
  assign nios_f_jtag_debug_module_any_bursting_master_saved_grant = 0;

  //nios_f_jtag_debug_module_arb_share_counter_next_value assignment, which is an e_assign
  assign nios_f_jtag_debug_module_arb_share_counter_next_value = nios_f_jtag_debug_module_firsttransfer ? (nios_f_jtag_debug_module_arb_share_set_values - 1) : |nios_f_jtag_debug_module_arb_share_counter ? (nios_f_jtag_debug_module_arb_share_counter - 1) : 0;

  //nios_f_jtag_debug_module_allgrants all slave grants, which is an e_mux
  assign nios_f_jtag_debug_module_allgrants = (|nios_f_jtag_debug_module_grant_vector) |
    (|nios_f_jtag_debug_module_grant_vector) |
    (|nios_f_jtag_debug_module_grant_vector) |
    (|nios_f_jtag_debug_module_grant_vector);

  //nios_f_jtag_debug_module_end_xfer assignment, which is an e_assign
  assign nios_f_jtag_debug_module_end_xfer = ~(nios_f_jtag_debug_module_waits_for_read | nios_f_jtag_debug_module_waits_for_write);

  //end_xfer_arb_share_counter_term_nios_f_jtag_debug_module arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_nios_f_jtag_debug_module = nios_f_jtag_debug_module_end_xfer & (~nios_f_jtag_debug_module_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //nios_f_jtag_debug_module_arb_share_counter arbitration counter enable, which is an e_assign
  assign nios_f_jtag_debug_module_arb_counter_enable = (end_xfer_arb_share_counter_term_nios_f_jtag_debug_module & nios_f_jtag_debug_module_allgrants) | (end_xfer_arb_share_counter_term_nios_f_jtag_debug_module & ~nios_f_jtag_debug_module_non_bursting_master_requests);

  //nios_f_jtag_debug_module_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios_f_jtag_debug_module_arb_share_counter <= 0;
      else if (nios_f_jtag_debug_module_arb_counter_enable)
          nios_f_jtag_debug_module_arb_share_counter <= nios_f_jtag_debug_module_arb_share_counter_next_value;
    end


  //nios_f_jtag_debug_module_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios_f_jtag_debug_module_slavearbiterlockenable <= 0;
      else if ((|nios_f_jtag_debug_module_master_qreq_vector & end_xfer_arb_share_counter_term_nios_f_jtag_debug_module) | (end_xfer_arb_share_counter_term_nios_f_jtag_debug_module & ~nios_f_jtag_debug_module_non_bursting_master_requests))
          nios_f_jtag_debug_module_slavearbiterlockenable <= |nios_f_jtag_debug_module_arb_share_counter_next_value;
    end


  //nios_f/data_master nios_f/jtag_debug_module arbiterlock, which is an e_assign
  assign nios_f_data_master_arbiterlock = nios_f_jtag_debug_module_slavearbiterlockenable & nios_f_data_master_continuerequest;

  //nios_f_jtag_debug_module_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign nios_f_jtag_debug_module_slavearbiterlockenable2 = |nios_f_jtag_debug_module_arb_share_counter_next_value;

  //nios_f/data_master nios_f/jtag_debug_module arbiterlock2, which is an e_assign
  assign nios_f_data_master_arbiterlock2 = nios_f_jtag_debug_module_slavearbiterlockenable2 & nios_f_data_master_continuerequest;

  //nios_f/instruction_master nios_f/jtag_debug_module arbiterlock, which is an e_assign
  assign nios_f_instruction_master_arbiterlock = nios_f_jtag_debug_module_slavearbiterlockenable & nios_f_instruction_master_continuerequest;

  //nios_f/instruction_master nios_f/jtag_debug_module arbiterlock2, which is an e_assign
  assign nios_f_instruction_master_arbiterlock2 = nios_f_jtag_debug_module_slavearbiterlockenable2 & nios_f_instruction_master_continuerequest;

  //nios_f/instruction_master granted nios_f/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios_f_instruction_master_granted_slave_nios_f_jtag_debug_module <= 0;
      else 
        last_cycle_nios_f_instruction_master_granted_slave_nios_f_jtag_debug_module <= nios_f_instruction_master_saved_grant_nios_f_jtag_debug_module ? 1 : (nios_f_jtag_debug_module_arbitration_holdoff_internal | ~nios_f_instruction_master_requests_nios_f_jtag_debug_module) ? 0 : last_cycle_nios_f_instruction_master_granted_slave_nios_f_jtag_debug_module;
    end


  //nios_f_instruction_master_continuerequest continued request, which is an e_mux
  assign nios_f_instruction_master_continuerequest = last_cycle_nios_f_instruction_master_granted_slave_nios_f_jtag_debug_module & nios_f_instruction_master_requests_nios_f_jtag_debug_module;

  //nios_f_jtag_debug_module_any_continuerequest at least one master continues requesting, which is an e_mux
  assign nios_f_jtag_debug_module_any_continuerequest = nios_f_instruction_master_continuerequest |
    nios_f_data_master_continuerequest;

  assign nios_f_data_master_qualified_request_nios_f_jtag_debug_module = nios_f_data_master_requests_nios_f_jtag_debug_module & ~(((~nios_f_data_master_waitrequest) & nios_f_data_master_write) | nios_f_instruction_master_arbiterlock);
  //nios_f_jtag_debug_module_writedata mux, which is an e_mux
  assign nios_f_jtag_debug_module_writedata = nios_f_data_master_writedata;

  assign nios_f_instruction_master_requests_nios_f_jtag_debug_module = (({nios_f_instruction_master_address_to_slave[25 : 11] , 11'b0} == 26'h3001000) & (nios_f_instruction_master_read)) & nios_f_instruction_master_read;
  //nios_f/data_master granted nios_f/jtag_debug_module last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios_f_data_master_granted_slave_nios_f_jtag_debug_module <= 0;
      else 
        last_cycle_nios_f_data_master_granted_slave_nios_f_jtag_debug_module <= nios_f_data_master_saved_grant_nios_f_jtag_debug_module ? 1 : (nios_f_jtag_debug_module_arbitration_holdoff_internal | ~nios_f_data_master_requests_nios_f_jtag_debug_module) ? 0 : last_cycle_nios_f_data_master_granted_slave_nios_f_jtag_debug_module;
    end


  //nios_f_data_master_continuerequest continued request, which is an e_mux
  assign nios_f_data_master_continuerequest = last_cycle_nios_f_data_master_granted_slave_nios_f_jtag_debug_module & nios_f_data_master_requests_nios_f_jtag_debug_module;

  assign nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module = nios_f_instruction_master_requests_nios_f_jtag_debug_module & ~((nios_f_instruction_master_read & ((nios_f_instruction_master_latency_counter != 0) | (|nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register) | (|nios_f_instruction_master_read_data_valid_sdram_s1_shift_register))) | nios_f_data_master_arbiterlock);
  //local readdatavalid nios_f_instruction_master_read_data_valid_nios_f_jtag_debug_module, which is an e_mux
  assign nios_f_instruction_master_read_data_valid_nios_f_jtag_debug_module = nios_f_instruction_master_granted_nios_f_jtag_debug_module & nios_f_instruction_master_read & ~nios_f_jtag_debug_module_waits_for_read;

  //allow new arb cycle for nios_f/jtag_debug_module, which is an e_assign
  assign nios_f_jtag_debug_module_allow_new_arb_cycle = ~nios_f_data_master_arbiterlock & ~nios_f_instruction_master_arbiterlock;

  //nios_f/instruction_master assignment into master qualified-requests vector for nios_f/jtag_debug_module, which is an e_assign
  assign nios_f_jtag_debug_module_master_qreq_vector[0] = nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module;

  //nios_f/instruction_master grant nios_f/jtag_debug_module, which is an e_assign
  assign nios_f_instruction_master_granted_nios_f_jtag_debug_module = nios_f_jtag_debug_module_grant_vector[0];

  //nios_f/instruction_master saved-grant nios_f/jtag_debug_module, which is an e_assign
  assign nios_f_instruction_master_saved_grant_nios_f_jtag_debug_module = nios_f_jtag_debug_module_arb_winner[0] && nios_f_instruction_master_requests_nios_f_jtag_debug_module;

  //nios_f/data_master assignment into master qualified-requests vector for nios_f/jtag_debug_module, which is an e_assign
  assign nios_f_jtag_debug_module_master_qreq_vector[1] = nios_f_data_master_qualified_request_nios_f_jtag_debug_module;

  //nios_f/data_master grant nios_f/jtag_debug_module, which is an e_assign
  assign nios_f_data_master_granted_nios_f_jtag_debug_module = nios_f_jtag_debug_module_grant_vector[1];

  //nios_f/data_master saved-grant nios_f/jtag_debug_module, which is an e_assign
  assign nios_f_data_master_saved_grant_nios_f_jtag_debug_module = nios_f_jtag_debug_module_arb_winner[1] && nios_f_data_master_requests_nios_f_jtag_debug_module;

  //nios_f/jtag_debug_module chosen-master double-vector, which is an e_assign
  assign nios_f_jtag_debug_module_chosen_master_double_vector = {nios_f_jtag_debug_module_master_qreq_vector, nios_f_jtag_debug_module_master_qreq_vector} & ({~nios_f_jtag_debug_module_master_qreq_vector, ~nios_f_jtag_debug_module_master_qreq_vector} + nios_f_jtag_debug_module_arb_addend);

  //stable onehot encoding of arb winner
  assign nios_f_jtag_debug_module_arb_winner = (nios_f_jtag_debug_module_allow_new_arb_cycle & | nios_f_jtag_debug_module_grant_vector) ? nios_f_jtag_debug_module_grant_vector : nios_f_jtag_debug_module_saved_chosen_master_vector;

  //saved nios_f_jtag_debug_module_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios_f_jtag_debug_module_saved_chosen_master_vector <= 0;
      else if (nios_f_jtag_debug_module_allow_new_arb_cycle)
          nios_f_jtag_debug_module_saved_chosen_master_vector <= |nios_f_jtag_debug_module_grant_vector ? nios_f_jtag_debug_module_grant_vector : nios_f_jtag_debug_module_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign nios_f_jtag_debug_module_grant_vector = {(nios_f_jtag_debug_module_chosen_master_double_vector[1] | nios_f_jtag_debug_module_chosen_master_double_vector[3]),
    (nios_f_jtag_debug_module_chosen_master_double_vector[0] | nios_f_jtag_debug_module_chosen_master_double_vector[2])};

  //nios_f/jtag_debug_module chosen master rotated left, which is an e_assign
  assign nios_f_jtag_debug_module_chosen_master_rot_left = (nios_f_jtag_debug_module_arb_winner << 1) ? (nios_f_jtag_debug_module_arb_winner << 1) : 1;

  //nios_f/jtag_debug_module's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios_f_jtag_debug_module_arb_addend <= 1;
      else if (|nios_f_jtag_debug_module_grant_vector)
          nios_f_jtag_debug_module_arb_addend <= nios_f_jtag_debug_module_end_xfer? nios_f_jtag_debug_module_chosen_master_rot_left : nios_f_jtag_debug_module_grant_vector;
    end


  assign nios_f_jtag_debug_module_begintransfer = nios_f_jtag_debug_module_begins_xfer;
  //nios_f_jtag_debug_module_reset_n assignment, which is an e_assign
  assign nios_f_jtag_debug_module_reset_n = reset_n;

  //assign nios_f_jtag_debug_module_resetrequest_from_sa = nios_f_jtag_debug_module_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign nios_f_jtag_debug_module_resetrequest_from_sa = nios_f_jtag_debug_module_resetrequest;

  assign nios_f_jtag_debug_module_chipselect = nios_f_data_master_granted_nios_f_jtag_debug_module | nios_f_instruction_master_granted_nios_f_jtag_debug_module;
  //nios_f_jtag_debug_module_firsttransfer first transaction, which is an e_assign
  assign nios_f_jtag_debug_module_firsttransfer = nios_f_jtag_debug_module_begins_xfer ? nios_f_jtag_debug_module_unreg_firsttransfer : nios_f_jtag_debug_module_reg_firsttransfer;

  //nios_f_jtag_debug_module_unreg_firsttransfer first transaction, which is an e_assign
  assign nios_f_jtag_debug_module_unreg_firsttransfer = ~(nios_f_jtag_debug_module_slavearbiterlockenable & nios_f_jtag_debug_module_any_continuerequest);

  //nios_f_jtag_debug_module_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios_f_jtag_debug_module_reg_firsttransfer <= 1'b1;
      else if (nios_f_jtag_debug_module_begins_xfer)
          nios_f_jtag_debug_module_reg_firsttransfer <= nios_f_jtag_debug_module_unreg_firsttransfer;
    end


  //nios_f_jtag_debug_module_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign nios_f_jtag_debug_module_beginbursttransfer_internal = nios_f_jtag_debug_module_begins_xfer;

  //nios_f_jtag_debug_module_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign nios_f_jtag_debug_module_arbitration_holdoff_internal = nios_f_jtag_debug_module_begins_xfer & nios_f_jtag_debug_module_firsttransfer;

  //nios_f_jtag_debug_module_write assignment, which is an e_mux
  assign nios_f_jtag_debug_module_write = nios_f_data_master_granted_nios_f_jtag_debug_module & nios_f_data_master_write;

  assign shifted_address_to_nios_f_jtag_debug_module_from_nios_f_data_master = nios_f_data_master_address_to_slave;
  //nios_f_jtag_debug_module_address mux, which is an e_mux
  assign nios_f_jtag_debug_module_address = (nios_f_data_master_granted_nios_f_jtag_debug_module)? (shifted_address_to_nios_f_jtag_debug_module_from_nios_f_data_master >> 2) :
    (shifted_address_to_nios_f_jtag_debug_module_from_nios_f_instruction_master >> 2);

  assign shifted_address_to_nios_f_jtag_debug_module_from_nios_f_instruction_master = nios_f_instruction_master_address_to_slave;
  //d1_nios_f_jtag_debug_module_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_nios_f_jtag_debug_module_end_xfer <= 1;
      else 
        d1_nios_f_jtag_debug_module_end_xfer <= nios_f_jtag_debug_module_end_xfer;
    end


  //nios_f_jtag_debug_module_waits_for_read in a cycle, which is an e_mux
  assign nios_f_jtag_debug_module_waits_for_read = nios_f_jtag_debug_module_in_a_read_cycle & nios_f_jtag_debug_module_begins_xfer;

  //nios_f_jtag_debug_module_in_a_read_cycle assignment, which is an e_assign
  assign nios_f_jtag_debug_module_in_a_read_cycle = (nios_f_data_master_granted_nios_f_jtag_debug_module & nios_f_data_master_read) | (nios_f_instruction_master_granted_nios_f_jtag_debug_module & nios_f_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = nios_f_jtag_debug_module_in_a_read_cycle;

  //nios_f_jtag_debug_module_waits_for_write in a cycle, which is an e_mux
  assign nios_f_jtag_debug_module_waits_for_write = nios_f_jtag_debug_module_in_a_write_cycle & 0;

  //nios_f_jtag_debug_module_in_a_write_cycle assignment, which is an e_assign
  assign nios_f_jtag_debug_module_in_a_write_cycle = nios_f_data_master_granted_nios_f_jtag_debug_module & nios_f_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = nios_f_jtag_debug_module_in_a_write_cycle;

  assign wait_for_nios_f_jtag_debug_module_counter = 0;
  //nios_f_jtag_debug_module_byteenable byte enable port mux, which is an e_mux
  assign nios_f_jtag_debug_module_byteenable = (nios_f_data_master_granted_nios_f_jtag_debug_module)? nios_f_data_master_byteenable :
    -1;

  //debugaccess mux, which is an e_mux
  assign nios_f_jtag_debug_module_debugaccess = (nios_f_data_master_granted_nios_f_jtag_debug_module)? nios_f_data_master_debugaccess :
    0;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //nios_f/jtag_debug_module enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (nios_f_data_master_granted_nios_f_jtag_debug_module + nios_f_instruction_master_granted_nios_f_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (nios_f_data_master_saved_grant_nios_f_jtag_debug_module + nios_f_instruction_master_saved_grant_nios_f_jtag_debug_module > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module nios_f_data_master_arbitrator (
                                       // inputs:
                                        ads_nirq_s1_irq_from_sa,
                                        clk,
                                        d1_epcs_epcs_control_port_end_xfer,
                                        d1_high_res_timer_s1_end_xfer,
                                        d1_jtag_uart_avalon_jtag_slave_end_xfer,
                                        d1_nios_f_jtag_debug_module_end_xfer,
                                        d1_pipeline_bridge_0_s1_end_xfer,
                                        d1_sdram_s1_end_xfer,
                                        d1_sys_clk_timer_s1_end_xfer,
                                        d1_sysid_control_slave_end_xfer,
                                        d1_watchdog_timer_s1_end_xfer,
                                        epcs_epcs_control_port_irq_from_sa,
                                        epcs_epcs_control_port_readdata_from_sa,
                                        high_res_timer_s1_irq_from_sa,
                                        high_res_timer_s1_readdata_from_sa,
                                        jtag_uart_avalon_jtag_slave_irq_from_sa,
                                        jtag_uart_avalon_jtag_slave_readdata_from_sa,
                                        jtag_uart_avalon_jtag_slave_waitrequest_from_sa,
                                        nios_f_data_master_address,
                                        nios_f_data_master_byteenable_sdram_s1,
                                        nios_f_data_master_granted_epcs_epcs_control_port,
                                        nios_f_data_master_granted_high_res_timer_s1,
                                        nios_f_data_master_granted_jtag_uart_avalon_jtag_slave,
                                        nios_f_data_master_granted_nios_f_jtag_debug_module,
                                        nios_f_data_master_granted_pipeline_bridge_0_s1,
                                        nios_f_data_master_granted_sdram_s1,
                                        nios_f_data_master_granted_sys_clk_timer_s1,
                                        nios_f_data_master_granted_sysid_control_slave,
                                        nios_f_data_master_granted_watchdog_timer_s1,
                                        nios_f_data_master_qualified_request_epcs_epcs_control_port,
                                        nios_f_data_master_qualified_request_high_res_timer_s1,
                                        nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave,
                                        nios_f_data_master_qualified_request_nios_f_jtag_debug_module,
                                        nios_f_data_master_qualified_request_pipeline_bridge_0_s1,
                                        nios_f_data_master_qualified_request_sdram_s1,
                                        nios_f_data_master_qualified_request_sys_clk_timer_s1,
                                        nios_f_data_master_qualified_request_sysid_control_slave,
                                        nios_f_data_master_qualified_request_watchdog_timer_s1,
                                        nios_f_data_master_read,
                                        nios_f_data_master_read_data_valid_epcs_epcs_control_port,
                                        nios_f_data_master_read_data_valid_high_res_timer_s1,
                                        nios_f_data_master_read_data_valid_jtag_uart_avalon_jtag_slave,
                                        nios_f_data_master_read_data_valid_nios_f_jtag_debug_module,
                                        nios_f_data_master_read_data_valid_pipeline_bridge_0_s1,
                                        nios_f_data_master_read_data_valid_pipeline_bridge_0_s1_shift_register,
                                        nios_f_data_master_read_data_valid_sdram_s1,
                                        nios_f_data_master_read_data_valid_sdram_s1_shift_register,
                                        nios_f_data_master_read_data_valid_sys_clk_timer_s1,
                                        nios_f_data_master_read_data_valid_sysid_control_slave,
                                        nios_f_data_master_read_data_valid_watchdog_timer_s1,
                                        nios_f_data_master_requests_epcs_epcs_control_port,
                                        nios_f_data_master_requests_high_res_timer_s1,
                                        nios_f_data_master_requests_jtag_uart_avalon_jtag_slave,
                                        nios_f_data_master_requests_nios_f_jtag_debug_module,
                                        nios_f_data_master_requests_pipeline_bridge_0_s1,
                                        nios_f_data_master_requests_sdram_s1,
                                        nios_f_data_master_requests_sys_clk_timer_s1,
                                        nios_f_data_master_requests_sysid_control_slave,
                                        nios_f_data_master_requests_watchdog_timer_s1,
                                        nios_f_data_master_write,
                                        nios_f_data_master_writedata,
                                        nios_f_jtag_debug_module_readdata_from_sa,
                                        pipeline_bridge_0_s1_readdata_from_sa,
                                        pipeline_bridge_0_s1_waitrequest_from_sa,
                                        reset_n,
                                        sdram_s1_readdata_from_sa,
                                        sdram_s1_waitrequest_from_sa,
                                        sys_clk_timer_s1_irq_from_sa,
                                        sys_clk_timer_s1_readdata_from_sa,
                                        sysid_control_slave_readdata_from_sa,
                                        watchdog_timer_s1_irq_from_sa,
                                        watchdog_timer_s1_readdata_from_sa,

                                       // outputs:
                                        nios_f_data_master_address_to_slave,
                                        nios_f_data_master_dbs_address,
                                        nios_f_data_master_dbs_write_16,
                                        nios_f_data_master_irq,
                                        nios_f_data_master_no_byte_enables_and_last_term,
                                        nios_f_data_master_readdata,
                                        nios_f_data_master_waitrequest
                                     )
;

  output  [ 25: 0] nios_f_data_master_address_to_slave;
  output  [  1: 0] nios_f_data_master_dbs_address;
  output  [ 15: 0] nios_f_data_master_dbs_write_16;
  output  [ 31: 0] nios_f_data_master_irq;
  output           nios_f_data_master_no_byte_enables_and_last_term;
  output  [ 31: 0] nios_f_data_master_readdata;
  output           nios_f_data_master_waitrequest;
  input            ads_nirq_s1_irq_from_sa;
  input            clk;
  input            d1_epcs_epcs_control_port_end_xfer;
  input            d1_high_res_timer_s1_end_xfer;
  input            d1_jtag_uart_avalon_jtag_slave_end_xfer;
  input            d1_nios_f_jtag_debug_module_end_xfer;
  input            d1_pipeline_bridge_0_s1_end_xfer;
  input            d1_sdram_s1_end_xfer;
  input            d1_sys_clk_timer_s1_end_xfer;
  input            d1_sysid_control_slave_end_xfer;
  input            d1_watchdog_timer_s1_end_xfer;
  input            epcs_epcs_control_port_irq_from_sa;
  input   [ 31: 0] epcs_epcs_control_port_readdata_from_sa;
  input            high_res_timer_s1_irq_from_sa;
  input   [ 15: 0] high_res_timer_s1_readdata_from_sa;
  input            jtag_uart_avalon_jtag_slave_irq_from_sa;
  input   [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  input            jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  input   [ 25: 0] nios_f_data_master_address;
  input   [  1: 0] nios_f_data_master_byteenable_sdram_s1;
  input            nios_f_data_master_granted_epcs_epcs_control_port;
  input            nios_f_data_master_granted_high_res_timer_s1;
  input            nios_f_data_master_granted_jtag_uart_avalon_jtag_slave;
  input            nios_f_data_master_granted_nios_f_jtag_debug_module;
  input            nios_f_data_master_granted_pipeline_bridge_0_s1;
  input            nios_f_data_master_granted_sdram_s1;
  input            nios_f_data_master_granted_sys_clk_timer_s1;
  input            nios_f_data_master_granted_sysid_control_slave;
  input            nios_f_data_master_granted_watchdog_timer_s1;
  input            nios_f_data_master_qualified_request_epcs_epcs_control_port;
  input            nios_f_data_master_qualified_request_high_res_timer_s1;
  input            nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  input            nios_f_data_master_qualified_request_nios_f_jtag_debug_module;
  input            nios_f_data_master_qualified_request_pipeline_bridge_0_s1;
  input            nios_f_data_master_qualified_request_sdram_s1;
  input            nios_f_data_master_qualified_request_sys_clk_timer_s1;
  input            nios_f_data_master_qualified_request_sysid_control_slave;
  input            nios_f_data_master_qualified_request_watchdog_timer_s1;
  input            nios_f_data_master_read;
  input            nios_f_data_master_read_data_valid_epcs_epcs_control_port;
  input            nios_f_data_master_read_data_valid_high_res_timer_s1;
  input            nios_f_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  input            nios_f_data_master_read_data_valid_nios_f_jtag_debug_module;
  input            nios_f_data_master_read_data_valid_pipeline_bridge_0_s1;
  input            nios_f_data_master_read_data_valid_pipeline_bridge_0_s1_shift_register;
  input            nios_f_data_master_read_data_valid_sdram_s1;
  input            nios_f_data_master_read_data_valid_sdram_s1_shift_register;
  input            nios_f_data_master_read_data_valid_sys_clk_timer_s1;
  input            nios_f_data_master_read_data_valid_sysid_control_slave;
  input            nios_f_data_master_read_data_valid_watchdog_timer_s1;
  input            nios_f_data_master_requests_epcs_epcs_control_port;
  input            nios_f_data_master_requests_high_res_timer_s1;
  input            nios_f_data_master_requests_jtag_uart_avalon_jtag_slave;
  input            nios_f_data_master_requests_nios_f_jtag_debug_module;
  input            nios_f_data_master_requests_pipeline_bridge_0_s1;
  input            nios_f_data_master_requests_sdram_s1;
  input            nios_f_data_master_requests_sys_clk_timer_s1;
  input            nios_f_data_master_requests_sysid_control_slave;
  input            nios_f_data_master_requests_watchdog_timer_s1;
  input            nios_f_data_master_write;
  input   [ 31: 0] nios_f_data_master_writedata;
  input   [ 31: 0] nios_f_jtag_debug_module_readdata_from_sa;
  input   [ 31: 0] pipeline_bridge_0_s1_readdata_from_sa;
  input            pipeline_bridge_0_s1_waitrequest_from_sa;
  input            reset_n;
  input   [ 15: 0] sdram_s1_readdata_from_sa;
  input            sdram_s1_waitrequest_from_sa;
  input            sys_clk_timer_s1_irq_from_sa;
  input   [ 15: 0] sys_clk_timer_s1_readdata_from_sa;
  input   [ 31: 0] sysid_control_slave_readdata_from_sa;
  input            watchdog_timer_s1_irq_from_sa;
  input   [ 15: 0] watchdog_timer_s1_readdata_from_sa;

  reg     [ 15: 0] dbs_16_reg_segment_0;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  wire             last_dbs_term_and_run;
  wire    [  1: 0] next_dbs_address;
  wire    [ 25: 0] nios_f_data_master_address_to_slave;
  reg     [  1: 0] nios_f_data_master_dbs_address;
  wire    [  1: 0] nios_f_data_master_dbs_increment;
  wire    [ 15: 0] nios_f_data_master_dbs_write_16;
  wire    [ 31: 0] nios_f_data_master_irq;
  reg              nios_f_data_master_no_byte_enables_and_last_term;
  wire    [ 31: 0] nios_f_data_master_readdata;
  wire             nios_f_data_master_run;
  reg              nios_f_data_master_waitrequest;
  wire    [ 15: 0] p1_dbs_16_reg_segment_0;
  wire    [ 31: 0] p1_registered_nios_f_data_master_readdata;
  wire             pre_dbs_count_enable;
  wire             r_1;
  wire             r_2;
  wire             r_3;
  reg     [ 31: 0] registered_nios_f_data_master_readdata;
  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (nios_f_data_master_qualified_request_epcs_epcs_control_port | ~nios_f_data_master_requests_epcs_epcs_control_port) & (nios_f_data_master_granted_epcs_epcs_control_port | ~nios_f_data_master_qualified_request_epcs_epcs_control_port) & ((~nios_f_data_master_qualified_request_epcs_epcs_control_port | ~(nios_f_data_master_read | nios_f_data_master_write) | (1 & 1 & (nios_f_data_master_read | nios_f_data_master_write)))) & ((~nios_f_data_master_qualified_request_epcs_epcs_control_port | ~(nios_f_data_master_read | nios_f_data_master_write) | (1 & 1 & (nios_f_data_master_read | nios_f_data_master_write)))) & 1 & (nios_f_data_master_qualified_request_high_res_timer_s1 | ~nios_f_data_master_requests_high_res_timer_s1) & ((~nios_f_data_master_qualified_request_high_res_timer_s1 | ~nios_f_data_master_read | (1 & 1 & nios_f_data_master_read))) & ((~nios_f_data_master_qualified_request_high_res_timer_s1 | ~nios_f_data_master_write | (1 & nios_f_data_master_write)));

  //cascaded wait assignment, which is an e_assign
  assign nios_f_data_master_run = r_1 & r_2 & r_3;

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = 1 & (nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~nios_f_data_master_requests_jtag_uart_avalon_jtag_slave) & ((~nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~(nios_f_data_master_read | nios_f_data_master_write) | (1 & ~jtag_uart_avalon_jtag_slave_waitrequest_from_sa & (nios_f_data_master_read | nios_f_data_master_write)))) & ((~nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave | ~(nios_f_data_master_read | nios_f_data_master_write) | (1 & ~jtag_uart_avalon_jtag_slave_waitrequest_from_sa & (nios_f_data_master_read | nios_f_data_master_write)))) & 1 & (nios_f_data_master_qualified_request_nios_f_jtag_debug_module | ~nios_f_data_master_requests_nios_f_jtag_debug_module) & (nios_f_data_master_granted_nios_f_jtag_debug_module | ~nios_f_data_master_qualified_request_nios_f_jtag_debug_module) & ((~nios_f_data_master_qualified_request_nios_f_jtag_debug_module | ~nios_f_data_master_read | (1 & 1 & nios_f_data_master_read))) & ((~nios_f_data_master_qualified_request_nios_f_jtag_debug_module | ~nios_f_data_master_write | (1 & nios_f_data_master_write))) & 1 & (nios_f_data_master_qualified_request_pipeline_bridge_0_s1 | nios_f_data_master_read_data_valid_pipeline_bridge_0_s1 | ~nios_f_data_master_requests_pipeline_bridge_0_s1) & (nios_f_data_master_granted_pipeline_bridge_0_s1 | ~nios_f_data_master_qualified_request_pipeline_bridge_0_s1) & ((~nios_f_data_master_qualified_request_pipeline_bridge_0_s1 | ~nios_f_data_master_read | (nios_f_data_master_read_data_valid_pipeline_bridge_0_s1 & nios_f_data_master_read))) & ((~nios_f_data_master_qualified_request_pipeline_bridge_0_s1 | ~(nios_f_data_master_read | nios_f_data_master_write) | (1 & ~pipeline_bridge_0_s1_waitrequest_from_sa & (nios_f_data_master_read | nios_f_data_master_write))));

  //r_3 master_run cascaded wait assignment, which is an e_assign
  assign r_3 = 1 & (nios_f_data_master_qualified_request_sdram_s1 | (nios_f_data_master_read_data_valid_sdram_s1 & nios_f_data_master_dbs_address[1]) | (nios_f_data_master_write & !nios_f_data_master_byteenable_sdram_s1 & nios_f_data_master_dbs_address[1]) | ~nios_f_data_master_requests_sdram_s1) & (nios_f_data_master_granted_sdram_s1 | ~nios_f_data_master_qualified_request_sdram_s1) & ((~nios_f_data_master_qualified_request_sdram_s1 | ~nios_f_data_master_read | (nios_f_data_master_read_data_valid_sdram_s1 & (nios_f_data_master_dbs_address[1]) & nios_f_data_master_read))) & ((~nios_f_data_master_qualified_request_sdram_s1 | ~nios_f_data_master_write | (1 & ~sdram_s1_waitrequest_from_sa & (nios_f_data_master_dbs_address[1]) & nios_f_data_master_write))) & 1 & (nios_f_data_master_qualified_request_sys_clk_timer_s1 | ~nios_f_data_master_requests_sys_clk_timer_s1) & ((~nios_f_data_master_qualified_request_sys_clk_timer_s1 | ~nios_f_data_master_read | (1 & 1 & nios_f_data_master_read))) & ((~nios_f_data_master_qualified_request_sys_clk_timer_s1 | ~nios_f_data_master_write | (1 & nios_f_data_master_write))) & 1 & ((~nios_f_data_master_qualified_request_sysid_control_slave | ~nios_f_data_master_read | (1 & 1 & nios_f_data_master_read))) & ((~nios_f_data_master_qualified_request_sysid_control_slave | ~nios_f_data_master_write | (1 & nios_f_data_master_write))) & 1 & (nios_f_data_master_qualified_request_watchdog_timer_s1 | ~nios_f_data_master_requests_watchdog_timer_s1) & ((~nios_f_data_master_qualified_request_watchdog_timer_s1 | ~nios_f_data_master_read | (1 & 1 & nios_f_data_master_read))) & ((~nios_f_data_master_qualified_request_watchdog_timer_s1 | ~nios_f_data_master_write | (1 & nios_f_data_master_write)));

  //irq assign, which is an e_assign
  assign nios_f_data_master_irq = {1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    1'b0,
    ads_nirq_s1_irq_from_sa,
    watchdog_timer_s1_irq_from_sa,
    high_res_timer_s1_irq_from_sa,
    sys_clk_timer_s1_irq_from_sa,
    jtag_uart_avalon_jtag_slave_irq_from_sa,
    epcs_epcs_control_port_irq_from_sa};

  //optimize select-logic by passing only those address bits which matter.
  assign nios_f_data_master_address_to_slave = nios_f_data_master_address[25 : 0];

  //nios_f/data_master readdata mux, which is an e_mux
  assign nios_f_data_master_readdata = ({32 {~nios_f_data_master_requests_epcs_epcs_control_port}} | epcs_epcs_control_port_readdata_from_sa) &
    ({32 {~nios_f_data_master_requests_high_res_timer_s1}} | high_res_timer_s1_readdata_from_sa) &
    ({32 {~nios_f_data_master_requests_jtag_uart_avalon_jtag_slave}} | registered_nios_f_data_master_readdata) &
    ({32 {~nios_f_data_master_requests_nios_f_jtag_debug_module}} | nios_f_jtag_debug_module_readdata_from_sa) &
    ({32 {~nios_f_data_master_requests_pipeline_bridge_0_s1}} | registered_nios_f_data_master_readdata) &
    ({32 {~nios_f_data_master_requests_sdram_s1}} | registered_nios_f_data_master_readdata) &
    ({32 {~nios_f_data_master_requests_sys_clk_timer_s1}} | sys_clk_timer_s1_readdata_from_sa) &
    ({32 {~nios_f_data_master_requests_sysid_control_slave}} | sysid_control_slave_readdata_from_sa) &
    ({32 {~nios_f_data_master_requests_watchdog_timer_s1}} | watchdog_timer_s1_readdata_from_sa);

  //actual waitrequest port, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios_f_data_master_waitrequest <= ~0;
      else 
        nios_f_data_master_waitrequest <= ~((~(nios_f_data_master_read | nios_f_data_master_write))? 0: (nios_f_data_master_run & nios_f_data_master_waitrequest));
    end


  //unpredictable registered wait state incoming data, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          registered_nios_f_data_master_readdata <= 0;
      else 
        registered_nios_f_data_master_readdata <= p1_registered_nios_f_data_master_readdata;
    end


  //registered readdata mux, which is an e_mux
  assign p1_registered_nios_f_data_master_readdata = ({32 {~nios_f_data_master_requests_jtag_uart_avalon_jtag_slave}} | jtag_uart_avalon_jtag_slave_readdata_from_sa) &
    ({32 {~nios_f_data_master_requests_pipeline_bridge_0_s1}} | pipeline_bridge_0_s1_readdata_from_sa) &
    ({32 {~nios_f_data_master_requests_sdram_s1}} | {sdram_s1_readdata_from_sa[15 : 0],
    dbs_16_reg_segment_0});

  //no_byte_enables_and_last_term, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios_f_data_master_no_byte_enables_and_last_term <= 0;
      else 
        nios_f_data_master_no_byte_enables_and_last_term <= last_dbs_term_and_run;
    end


  //compute the last dbs term, which is an e_mux
  assign last_dbs_term_and_run = (nios_f_data_master_dbs_address == 2'b10) & nios_f_data_master_write & !nios_f_data_master_byteenable_sdram_s1;

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = (((~nios_f_data_master_no_byte_enables_and_last_term) & nios_f_data_master_requests_sdram_s1 & nios_f_data_master_write & !nios_f_data_master_byteenable_sdram_s1)) |
    nios_f_data_master_read_data_valid_sdram_s1 |
    (nios_f_data_master_granted_sdram_s1 & nios_f_data_master_write & 1 & 1 & ~sdram_s1_waitrequest_from_sa);

  //input to dbs-16 stored 0, which is an e_mux
  assign p1_dbs_16_reg_segment_0 = sdram_s1_readdata_from_sa;

  //dbs register for dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_16_reg_segment_0 <= 0;
      else if (dbs_count_enable & ((nios_f_data_master_dbs_address[1]) == 0))
          dbs_16_reg_segment_0 <= p1_dbs_16_reg_segment_0;
    end


  //mux write dbs 1, which is an e_mux
  assign nios_f_data_master_dbs_write_16 = (nios_f_data_master_dbs_address[1])? nios_f_data_master_writedata[31 : 16] :
    nios_f_data_master_writedata[15 : 0];

  //dbs count increment, which is an e_mux
  assign nios_f_data_master_dbs_increment = (nios_f_data_master_requests_sdram_s1)? 2 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = nios_f_data_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = nios_f_data_master_dbs_address + nios_f_data_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable &
    (~(nios_f_data_master_requests_sdram_s1 & ~nios_f_data_master_waitrequest));

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios_f_data_master_dbs_address <= 0;
      else if (dbs_count_enable)
          nios_f_data_master_dbs_address <= next_dbs_address;
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module nios_f_instruction_master_arbitrator (
                                              // inputs:
                                               clk,
                                               d1_epcs_epcs_control_port_end_xfer,
                                               d1_nios_f_jtag_debug_module_end_xfer,
                                               d1_pipeline_bridge_0_s1_end_xfer,
                                               d1_sdram_s1_end_xfer,
                                               epcs_epcs_control_port_readdata_from_sa,
                                               nios_f_instruction_master_address,
                                               nios_f_instruction_master_granted_epcs_epcs_control_port,
                                               nios_f_instruction_master_granted_nios_f_jtag_debug_module,
                                               nios_f_instruction_master_granted_pipeline_bridge_0_s1,
                                               nios_f_instruction_master_granted_sdram_s1,
                                               nios_f_instruction_master_qualified_request_epcs_epcs_control_port,
                                               nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module,
                                               nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1,
                                               nios_f_instruction_master_qualified_request_sdram_s1,
                                               nios_f_instruction_master_read,
                                               nios_f_instruction_master_read_data_valid_epcs_epcs_control_port,
                                               nios_f_instruction_master_read_data_valid_nios_f_jtag_debug_module,
                                               nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1,
                                               nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register,
                                               nios_f_instruction_master_read_data_valid_sdram_s1,
                                               nios_f_instruction_master_read_data_valid_sdram_s1_shift_register,
                                               nios_f_instruction_master_requests_epcs_epcs_control_port,
                                               nios_f_instruction_master_requests_nios_f_jtag_debug_module,
                                               nios_f_instruction_master_requests_pipeline_bridge_0_s1,
                                               nios_f_instruction_master_requests_sdram_s1,
                                               nios_f_jtag_debug_module_readdata_from_sa,
                                               pipeline_bridge_0_s1_readdata_from_sa,
                                               pipeline_bridge_0_s1_waitrequest_from_sa,
                                               reset_n,
                                               sdram_s1_readdata_from_sa,
                                               sdram_s1_waitrequest_from_sa,

                                              // outputs:
                                               nios_f_instruction_master_address_to_slave,
                                               nios_f_instruction_master_dbs_address,
                                               nios_f_instruction_master_latency_counter,
                                               nios_f_instruction_master_readdata,
                                               nios_f_instruction_master_readdatavalid,
                                               nios_f_instruction_master_waitrequest
                                            )
;

  output  [ 25: 0] nios_f_instruction_master_address_to_slave;
  output  [  1: 0] nios_f_instruction_master_dbs_address;
  output           nios_f_instruction_master_latency_counter;
  output  [ 31: 0] nios_f_instruction_master_readdata;
  output           nios_f_instruction_master_readdatavalid;
  output           nios_f_instruction_master_waitrequest;
  input            clk;
  input            d1_epcs_epcs_control_port_end_xfer;
  input            d1_nios_f_jtag_debug_module_end_xfer;
  input            d1_pipeline_bridge_0_s1_end_xfer;
  input            d1_sdram_s1_end_xfer;
  input   [ 31: 0] epcs_epcs_control_port_readdata_from_sa;
  input   [ 25: 0] nios_f_instruction_master_address;
  input            nios_f_instruction_master_granted_epcs_epcs_control_port;
  input            nios_f_instruction_master_granted_nios_f_jtag_debug_module;
  input            nios_f_instruction_master_granted_pipeline_bridge_0_s1;
  input            nios_f_instruction_master_granted_sdram_s1;
  input            nios_f_instruction_master_qualified_request_epcs_epcs_control_port;
  input            nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module;
  input            nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1;
  input            nios_f_instruction_master_qualified_request_sdram_s1;
  input            nios_f_instruction_master_read;
  input            nios_f_instruction_master_read_data_valid_epcs_epcs_control_port;
  input            nios_f_instruction_master_read_data_valid_nios_f_jtag_debug_module;
  input            nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1;
  input            nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register;
  input            nios_f_instruction_master_read_data_valid_sdram_s1;
  input            nios_f_instruction_master_read_data_valid_sdram_s1_shift_register;
  input            nios_f_instruction_master_requests_epcs_epcs_control_port;
  input            nios_f_instruction_master_requests_nios_f_jtag_debug_module;
  input            nios_f_instruction_master_requests_pipeline_bridge_0_s1;
  input            nios_f_instruction_master_requests_sdram_s1;
  input   [ 31: 0] nios_f_jtag_debug_module_readdata_from_sa;
  input   [ 31: 0] pipeline_bridge_0_s1_readdata_from_sa;
  input            pipeline_bridge_0_s1_waitrequest_from_sa;
  input            reset_n;
  input   [ 15: 0] sdram_s1_readdata_from_sa;
  input            sdram_s1_waitrequest_from_sa;

  reg              active_and_waiting_last_time;
  wire             dbs_count_enable;
  wire             dbs_counter_overflow;
  reg     [ 15: 0] dbs_latent_16_reg_segment_0;
  wire             dbs_rdv_count_enable;
  wire             dbs_rdv_counter_overflow;
  wire             latency_load_value;
  wire    [  1: 0] next_dbs_address;
  reg     [ 25: 0] nios_f_instruction_master_address_last_time;
  wire    [ 25: 0] nios_f_instruction_master_address_to_slave;
  reg     [  1: 0] nios_f_instruction_master_dbs_address;
  wire    [  1: 0] nios_f_instruction_master_dbs_increment;
  reg     [  1: 0] nios_f_instruction_master_dbs_rdv_counter;
  wire    [  1: 0] nios_f_instruction_master_dbs_rdv_counter_inc;
  wire             nios_f_instruction_master_is_granted_some_slave;
  reg              nios_f_instruction_master_latency_counter;
  wire    [  1: 0] nios_f_instruction_master_next_dbs_rdv_counter;
  reg              nios_f_instruction_master_read_but_no_slave_selected;
  reg              nios_f_instruction_master_read_last_time;
  wire    [ 31: 0] nios_f_instruction_master_readdata;
  wire             nios_f_instruction_master_readdatavalid;
  wire             nios_f_instruction_master_run;
  wire             nios_f_instruction_master_waitrequest;
  wire    [ 15: 0] p1_dbs_latent_16_reg_segment_0;
  wire             p1_nios_f_instruction_master_latency_counter;
  wire             pre_dbs_count_enable;
  wire             pre_flush_nios_f_instruction_master_readdatavalid;
  wire             r_1;
  wire             r_2;
  wire             r_3;
  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (nios_f_instruction_master_qualified_request_epcs_epcs_control_port | ~nios_f_instruction_master_requests_epcs_epcs_control_port) & (nios_f_instruction_master_granted_epcs_epcs_control_port | ~nios_f_instruction_master_qualified_request_epcs_epcs_control_port) & ((~nios_f_instruction_master_qualified_request_epcs_epcs_control_port | ~(nios_f_instruction_master_read) | (1 & ~d1_epcs_epcs_control_port_end_xfer & (nios_f_instruction_master_read))));

  //cascaded wait assignment, which is an e_assign
  assign nios_f_instruction_master_run = r_1 & r_2 & r_3;

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = 1 & (nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module | ~nios_f_instruction_master_requests_nios_f_jtag_debug_module) & (nios_f_instruction_master_granted_nios_f_jtag_debug_module | ~nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module) & ((~nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module | ~nios_f_instruction_master_read | (1 & ~d1_nios_f_jtag_debug_module_end_xfer & nios_f_instruction_master_read))) & 1 & (nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1 | ~nios_f_instruction_master_requests_pipeline_bridge_0_s1) & (nios_f_instruction_master_granted_pipeline_bridge_0_s1 | ~nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1) & ((~nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1 | ~nios_f_instruction_master_read | (1 & ~pipeline_bridge_0_s1_waitrequest_from_sa & nios_f_instruction_master_read)));

  //r_3 master_run cascaded wait assignment, which is an e_assign
  assign r_3 = 1 & (nios_f_instruction_master_qualified_request_sdram_s1 | ~nios_f_instruction_master_requests_sdram_s1) & (nios_f_instruction_master_granted_sdram_s1 | ~nios_f_instruction_master_qualified_request_sdram_s1) & ((~nios_f_instruction_master_qualified_request_sdram_s1 | ~nios_f_instruction_master_read | (1 & ~sdram_s1_waitrequest_from_sa & (nios_f_instruction_master_dbs_address[1]) & nios_f_instruction_master_read)));

  //optimize select-logic by passing only those address bits which matter.
  assign nios_f_instruction_master_address_to_slave = nios_f_instruction_master_address[25 : 0];

  //nios_f_instruction_master_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios_f_instruction_master_read_but_no_slave_selected <= 0;
      else 
        nios_f_instruction_master_read_but_no_slave_selected <= nios_f_instruction_master_read & nios_f_instruction_master_run & ~nios_f_instruction_master_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign nios_f_instruction_master_is_granted_some_slave = nios_f_instruction_master_granted_epcs_epcs_control_port |
    nios_f_instruction_master_granted_nios_f_jtag_debug_module |
    nios_f_instruction_master_granted_pipeline_bridge_0_s1 |
    nios_f_instruction_master_granted_sdram_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_nios_f_instruction_master_readdatavalid = nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1 |
    (nios_f_instruction_master_read_data_valid_sdram_s1 & dbs_rdv_counter_overflow);

  //latent slave read data valid which is not flushed, which is an e_mux
  assign nios_f_instruction_master_readdatavalid = nios_f_instruction_master_read_but_no_slave_selected |
    pre_flush_nios_f_instruction_master_readdatavalid |
    nios_f_instruction_master_read_data_valid_epcs_epcs_control_port |
    nios_f_instruction_master_read_but_no_slave_selected |
    pre_flush_nios_f_instruction_master_readdatavalid |
    nios_f_instruction_master_read_data_valid_nios_f_jtag_debug_module |
    nios_f_instruction_master_read_but_no_slave_selected |
    pre_flush_nios_f_instruction_master_readdatavalid |
    nios_f_instruction_master_read_but_no_slave_selected |
    pre_flush_nios_f_instruction_master_readdatavalid;

  //nios_f/instruction_master readdata mux, which is an e_mux
  assign nios_f_instruction_master_readdata = ({32 {~(nios_f_instruction_master_qualified_request_epcs_epcs_control_port & nios_f_instruction_master_read)}} | epcs_epcs_control_port_readdata_from_sa) &
    ({32 {~(nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module & nios_f_instruction_master_read)}} | nios_f_jtag_debug_module_readdata_from_sa) &
    ({32 {~nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1}} | pipeline_bridge_0_s1_readdata_from_sa) &
    ({32 {~nios_f_instruction_master_read_data_valid_sdram_s1}} | {sdram_s1_readdata_from_sa[15 : 0],
    dbs_latent_16_reg_segment_0});

  //actual waitrequest port, which is an e_assign
  assign nios_f_instruction_master_waitrequest = ~nios_f_instruction_master_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios_f_instruction_master_latency_counter <= 0;
      else 
        nios_f_instruction_master_latency_counter <= p1_nios_f_instruction_master_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_nios_f_instruction_master_latency_counter = ((nios_f_instruction_master_run & nios_f_instruction_master_read))? latency_load_value :
    (nios_f_instruction_master_latency_counter)? nios_f_instruction_master_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = 0;

  //input to latent dbs-16 stored 0, which is an e_mux
  assign p1_dbs_latent_16_reg_segment_0 = sdram_s1_readdata_from_sa;

  //dbs register for latent dbs-16 segment 0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          dbs_latent_16_reg_segment_0 <= 0;
      else if (dbs_rdv_count_enable & ((nios_f_instruction_master_dbs_rdv_counter[1]) == 0))
          dbs_latent_16_reg_segment_0 <= p1_dbs_latent_16_reg_segment_0;
    end


  //dbs count increment, which is an e_mux
  assign nios_f_instruction_master_dbs_increment = (nios_f_instruction_master_requests_sdram_s1)? 2 :
    0;

  //dbs counter overflow, which is an e_assign
  assign dbs_counter_overflow = nios_f_instruction_master_dbs_address[1] & !(next_dbs_address[1]);

  //next master address, which is an e_assign
  assign next_dbs_address = nios_f_instruction_master_dbs_address + nios_f_instruction_master_dbs_increment;

  //dbs count enable, which is an e_mux
  assign dbs_count_enable = pre_dbs_count_enable;

  //dbs counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios_f_instruction_master_dbs_address <= 0;
      else if (dbs_count_enable)
          nios_f_instruction_master_dbs_address <= next_dbs_address;
    end


  //p1 dbs rdv counter, which is an e_assign
  assign nios_f_instruction_master_next_dbs_rdv_counter = nios_f_instruction_master_dbs_rdv_counter + nios_f_instruction_master_dbs_rdv_counter_inc;

  //nios_f_instruction_master_rdv_inc_mux, which is an e_mux
  assign nios_f_instruction_master_dbs_rdv_counter_inc = 2;

  //master any slave rdv, which is an e_mux
  assign dbs_rdv_count_enable = nios_f_instruction_master_read_data_valid_sdram_s1;

  //dbs rdv counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios_f_instruction_master_dbs_rdv_counter <= 0;
      else if (dbs_rdv_count_enable)
          nios_f_instruction_master_dbs_rdv_counter <= nios_f_instruction_master_next_dbs_rdv_counter;
    end


  //dbs rdv counter overflow, which is an e_assign
  assign dbs_rdv_counter_overflow = nios_f_instruction_master_dbs_rdv_counter[1] & ~nios_f_instruction_master_next_dbs_rdv_counter[1];

  //pre dbs count enable, which is an e_mux
  assign pre_dbs_count_enable = nios_f_instruction_master_granted_sdram_s1 & nios_f_instruction_master_read & 1 & 1 & ~sdram_s1_waitrequest_from_sa;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //nios_f_instruction_master_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios_f_instruction_master_address_last_time <= 0;
      else 
        nios_f_instruction_master_address_last_time <= nios_f_instruction_master_address;
    end


  //nios_f/instruction_master waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= nios_f_instruction_master_waitrequest & (nios_f_instruction_master_read);
    end


  //nios_f_instruction_master_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios_f_instruction_master_address != nios_f_instruction_master_address_last_time))
        begin
          $write("%0d ns: nios_f_instruction_master_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //nios_f_instruction_master_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          nios_f_instruction_master_read_last_time <= 0;
      else 
        nios_f_instruction_master_read_last_time <= nios_f_instruction_master_read;
    end


  //nios_f_instruction_master_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (nios_f_instruction_master_read != nios_f_instruction_master_read_last_time))
        begin
          $write("%0d ns: nios_f_instruction_master_read did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_nios_f_data_master_to_pipeline_bridge_0_s1_module (
                                                                        // inputs:
                                                                         clear_fifo,
                                                                         clk,
                                                                         data_in,
                                                                         read,
                                                                         reset_n,
                                                                         sync_reset,
                                                                         write,

                                                                        // outputs:
                                                                         data_out,
                                                                         empty,
                                                                         fifo_contains_ones_n,
                                                                         full
                                                                      )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  wire             full_3;
  reg     [  2: 0] how_many_ones;
  wire    [  2: 0] one_count_minus_one;
  wire    [  2: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  wire    [  2: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_2;
  assign empty = !full_0;
  assign full_3 = 0;
  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    0;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_nios_f_instruction_master_to_pipeline_bridge_0_s1_module (
                                                                               // inputs:
                                                                                clear_fifo,
                                                                                clk,
                                                                                data_in,
                                                                                read,
                                                                                reset_n,
                                                                                sync_reset,
                                                                                write,

                                                                               // outputs:
                                                                                data_out,
                                                                                empty,
                                                                                fifo_contains_ones_n,
                                                                                full
                                                                             )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  wire             full_3;
  reg     [  2: 0] how_many_ones;
  wire    [  2: 0] one_count_minus_one;
  wire    [  2: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  wire    [  2: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_2;
  assign empty = !full_0;
  assign full_3 = 0;
  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    0;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module pipeline_bridge_0_s1_arbitrator (
                                         // inputs:
                                          clk,
                                          nios_f_data_master_address_to_slave,
                                          nios_f_data_master_byteenable,
                                          nios_f_data_master_debugaccess,
                                          nios_f_data_master_read,
                                          nios_f_data_master_waitrequest,
                                          nios_f_data_master_write,
                                          nios_f_data_master_writedata,
                                          nios_f_instruction_master_address_to_slave,
                                          nios_f_instruction_master_latency_counter,
                                          nios_f_instruction_master_read,
                                          nios_f_instruction_master_read_data_valid_sdram_s1_shift_register,
                                          pipeline_bridge_0_s1_endofpacket,
                                          pipeline_bridge_0_s1_readdata,
                                          pipeline_bridge_0_s1_readdatavalid,
                                          pipeline_bridge_0_s1_waitrequest,
                                          reset_n,

                                         // outputs:
                                          d1_pipeline_bridge_0_s1_end_xfer,
                                          nios_f_data_master_granted_pipeline_bridge_0_s1,
                                          nios_f_data_master_qualified_request_pipeline_bridge_0_s1,
                                          nios_f_data_master_read_data_valid_pipeline_bridge_0_s1,
                                          nios_f_data_master_read_data_valid_pipeline_bridge_0_s1_shift_register,
                                          nios_f_data_master_requests_pipeline_bridge_0_s1,
                                          nios_f_instruction_master_granted_pipeline_bridge_0_s1,
                                          nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1,
                                          nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1,
                                          nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register,
                                          nios_f_instruction_master_requests_pipeline_bridge_0_s1,
                                          pipeline_bridge_0_s1_address,
                                          pipeline_bridge_0_s1_arbiterlock,
                                          pipeline_bridge_0_s1_arbiterlock2,
                                          pipeline_bridge_0_s1_burstcount,
                                          pipeline_bridge_0_s1_byteenable,
                                          pipeline_bridge_0_s1_chipselect,
                                          pipeline_bridge_0_s1_debugaccess,
                                          pipeline_bridge_0_s1_endofpacket_from_sa,
                                          pipeline_bridge_0_s1_nativeaddress,
                                          pipeline_bridge_0_s1_read,
                                          pipeline_bridge_0_s1_readdata_from_sa,
                                          pipeline_bridge_0_s1_reset_n,
                                          pipeline_bridge_0_s1_waitrequest_from_sa,
                                          pipeline_bridge_0_s1_write,
                                          pipeline_bridge_0_s1_writedata
                                       )
;

  output           d1_pipeline_bridge_0_s1_end_xfer;
  output           nios_f_data_master_granted_pipeline_bridge_0_s1;
  output           nios_f_data_master_qualified_request_pipeline_bridge_0_s1;
  output           nios_f_data_master_read_data_valid_pipeline_bridge_0_s1;
  output           nios_f_data_master_read_data_valid_pipeline_bridge_0_s1_shift_register;
  output           nios_f_data_master_requests_pipeline_bridge_0_s1;
  output           nios_f_instruction_master_granted_pipeline_bridge_0_s1;
  output           nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1;
  output           nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1;
  output           nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register;
  output           nios_f_instruction_master_requests_pipeline_bridge_0_s1;
  output  [  6: 0] pipeline_bridge_0_s1_address;
  output           pipeline_bridge_0_s1_arbiterlock;
  output           pipeline_bridge_0_s1_arbiterlock2;
  output           pipeline_bridge_0_s1_burstcount;
  output  [  3: 0] pipeline_bridge_0_s1_byteenable;
  output           pipeline_bridge_0_s1_chipselect;
  output           pipeline_bridge_0_s1_debugaccess;
  output           pipeline_bridge_0_s1_endofpacket_from_sa;
  output  [  6: 0] pipeline_bridge_0_s1_nativeaddress;
  output           pipeline_bridge_0_s1_read;
  output  [ 31: 0] pipeline_bridge_0_s1_readdata_from_sa;
  output           pipeline_bridge_0_s1_reset_n;
  output           pipeline_bridge_0_s1_waitrequest_from_sa;
  output           pipeline_bridge_0_s1_write;
  output  [ 31: 0] pipeline_bridge_0_s1_writedata;
  input            clk;
  input   [ 25: 0] nios_f_data_master_address_to_slave;
  input   [  3: 0] nios_f_data_master_byteenable;
  input            nios_f_data_master_debugaccess;
  input            nios_f_data_master_read;
  input            nios_f_data_master_waitrequest;
  input            nios_f_data_master_write;
  input   [ 31: 0] nios_f_data_master_writedata;
  input   [ 25: 0] nios_f_instruction_master_address_to_slave;
  input            nios_f_instruction_master_latency_counter;
  input            nios_f_instruction_master_read;
  input            nios_f_instruction_master_read_data_valid_sdram_s1_shift_register;
  input            pipeline_bridge_0_s1_endofpacket;
  input   [ 31: 0] pipeline_bridge_0_s1_readdata;
  input            pipeline_bridge_0_s1_readdatavalid;
  input            pipeline_bridge_0_s1_waitrequest;
  input            reset_n;

  reg              d1_pipeline_bridge_0_s1_end_xfer;
  reg              d1_reasons_to_wait;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_pipeline_bridge_0_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_nios_f_data_master_granted_slave_pipeline_bridge_0_s1;
  reg              last_cycle_nios_f_instruction_master_granted_slave_pipeline_bridge_0_s1;
  wire             nios_f_data_master_arbiterlock;
  wire             nios_f_data_master_arbiterlock2;
  wire             nios_f_data_master_continuerequest;
  wire             nios_f_data_master_granted_pipeline_bridge_0_s1;
  wire             nios_f_data_master_qualified_request_pipeline_bridge_0_s1;
  wire             nios_f_data_master_rdv_fifo_empty_pipeline_bridge_0_s1;
  wire             nios_f_data_master_rdv_fifo_output_from_pipeline_bridge_0_s1;
  wire             nios_f_data_master_read_data_valid_pipeline_bridge_0_s1;
  wire             nios_f_data_master_read_data_valid_pipeline_bridge_0_s1_shift_register;
  wire             nios_f_data_master_requests_pipeline_bridge_0_s1;
  wire             nios_f_data_master_saved_grant_pipeline_bridge_0_s1;
  wire             nios_f_instruction_master_arbiterlock;
  wire             nios_f_instruction_master_arbiterlock2;
  wire             nios_f_instruction_master_continuerequest;
  wire             nios_f_instruction_master_granted_pipeline_bridge_0_s1;
  wire             nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1;
  wire             nios_f_instruction_master_rdv_fifo_empty_pipeline_bridge_0_s1;
  wire             nios_f_instruction_master_rdv_fifo_output_from_pipeline_bridge_0_s1;
  wire             nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1;
  wire             nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register;
  wire             nios_f_instruction_master_requests_pipeline_bridge_0_s1;
  wire             nios_f_instruction_master_saved_grant_pipeline_bridge_0_s1;
  wire    [  6: 0] pipeline_bridge_0_s1_address;
  wire             pipeline_bridge_0_s1_allgrants;
  wire             pipeline_bridge_0_s1_allow_new_arb_cycle;
  wire             pipeline_bridge_0_s1_any_bursting_master_saved_grant;
  wire             pipeline_bridge_0_s1_any_continuerequest;
  reg     [  1: 0] pipeline_bridge_0_s1_arb_addend;
  wire             pipeline_bridge_0_s1_arb_counter_enable;
  reg     [  1: 0] pipeline_bridge_0_s1_arb_share_counter;
  wire    [  1: 0] pipeline_bridge_0_s1_arb_share_counter_next_value;
  wire    [  1: 0] pipeline_bridge_0_s1_arb_share_set_values;
  wire    [  1: 0] pipeline_bridge_0_s1_arb_winner;
  wire             pipeline_bridge_0_s1_arbiterlock;
  wire             pipeline_bridge_0_s1_arbiterlock2;
  wire             pipeline_bridge_0_s1_arbitration_holdoff_internal;
  wire             pipeline_bridge_0_s1_beginbursttransfer_internal;
  wire             pipeline_bridge_0_s1_begins_xfer;
  wire             pipeline_bridge_0_s1_burstcount;
  wire    [  3: 0] pipeline_bridge_0_s1_byteenable;
  wire             pipeline_bridge_0_s1_chipselect;
  wire    [  3: 0] pipeline_bridge_0_s1_chosen_master_double_vector;
  wire    [  1: 0] pipeline_bridge_0_s1_chosen_master_rot_left;
  wire             pipeline_bridge_0_s1_debugaccess;
  wire             pipeline_bridge_0_s1_end_xfer;
  wire             pipeline_bridge_0_s1_endofpacket_from_sa;
  wire             pipeline_bridge_0_s1_firsttransfer;
  wire    [  1: 0] pipeline_bridge_0_s1_grant_vector;
  wire             pipeline_bridge_0_s1_in_a_read_cycle;
  wire             pipeline_bridge_0_s1_in_a_write_cycle;
  wire    [  1: 0] pipeline_bridge_0_s1_master_qreq_vector;
  wire             pipeline_bridge_0_s1_move_on_to_next_transaction;
  wire    [  6: 0] pipeline_bridge_0_s1_nativeaddress;
  wire             pipeline_bridge_0_s1_non_bursting_master_requests;
  wire             pipeline_bridge_0_s1_read;
  wire    [ 31: 0] pipeline_bridge_0_s1_readdata_from_sa;
  wire             pipeline_bridge_0_s1_readdatavalid_from_sa;
  reg              pipeline_bridge_0_s1_reg_firsttransfer;
  wire             pipeline_bridge_0_s1_reset_n;
  reg     [  1: 0] pipeline_bridge_0_s1_saved_chosen_master_vector;
  reg              pipeline_bridge_0_s1_slavearbiterlockenable;
  wire             pipeline_bridge_0_s1_slavearbiterlockenable2;
  wire             pipeline_bridge_0_s1_unreg_firsttransfer;
  wire             pipeline_bridge_0_s1_waitrequest_from_sa;
  wire             pipeline_bridge_0_s1_waits_for_read;
  wire             pipeline_bridge_0_s1_waits_for_write;
  wire             pipeline_bridge_0_s1_write;
  wire    [ 31: 0] pipeline_bridge_0_s1_writedata;
  wire    [ 25: 0] shifted_address_to_pipeline_bridge_0_s1_from_nios_f_data_master;
  wire    [ 25: 0] shifted_address_to_pipeline_bridge_0_s1_from_nios_f_instruction_master;
  wire             wait_for_pipeline_bridge_0_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~pipeline_bridge_0_s1_end_xfer;
    end


  assign pipeline_bridge_0_s1_begins_xfer = ~d1_reasons_to_wait & ((nios_f_data_master_qualified_request_pipeline_bridge_0_s1 | nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1));
  //assign pipeline_bridge_0_s1_readdatavalid_from_sa = pipeline_bridge_0_s1_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pipeline_bridge_0_s1_readdatavalid_from_sa = pipeline_bridge_0_s1_readdatavalid;

  //assign pipeline_bridge_0_s1_readdata_from_sa = pipeline_bridge_0_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pipeline_bridge_0_s1_readdata_from_sa = pipeline_bridge_0_s1_readdata;

  assign nios_f_data_master_requests_pipeline_bridge_0_s1 = ({nios_f_data_master_address_to_slave[25 : 9] , 9'b0} == 26'h1000000) & (nios_f_data_master_read | nios_f_data_master_write);
  //assign pipeline_bridge_0_s1_waitrequest_from_sa = pipeline_bridge_0_s1_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pipeline_bridge_0_s1_waitrequest_from_sa = pipeline_bridge_0_s1_waitrequest;

  //pipeline_bridge_0_s1_arb_share_counter set values, which is an e_mux
  assign pipeline_bridge_0_s1_arb_share_set_values = 1;

  //pipeline_bridge_0_s1_non_bursting_master_requests mux, which is an e_mux
  assign pipeline_bridge_0_s1_non_bursting_master_requests = nios_f_data_master_requests_pipeline_bridge_0_s1 |
    nios_f_instruction_master_requests_pipeline_bridge_0_s1 |
    nios_f_data_master_requests_pipeline_bridge_0_s1 |
    nios_f_instruction_master_requests_pipeline_bridge_0_s1 |
    nios_f_data_master_requests_pipeline_bridge_0_s1 |
    nios_f_instruction_master_requests_pipeline_bridge_0_s1;

  //pipeline_bridge_0_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign pipeline_bridge_0_s1_any_bursting_master_saved_grant = 0;

  //pipeline_bridge_0_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign pipeline_bridge_0_s1_arb_share_counter_next_value = pipeline_bridge_0_s1_firsttransfer ? (pipeline_bridge_0_s1_arb_share_set_values - 1) : |pipeline_bridge_0_s1_arb_share_counter ? (pipeline_bridge_0_s1_arb_share_counter - 1) : 0;

  //pipeline_bridge_0_s1_allgrants all slave grants, which is an e_mux
  assign pipeline_bridge_0_s1_allgrants = (|pipeline_bridge_0_s1_grant_vector) |
    (|pipeline_bridge_0_s1_grant_vector) |
    (|pipeline_bridge_0_s1_grant_vector) |
    (|pipeline_bridge_0_s1_grant_vector) |
    (|pipeline_bridge_0_s1_grant_vector) |
    (|pipeline_bridge_0_s1_grant_vector);

  //pipeline_bridge_0_s1_end_xfer assignment, which is an e_assign
  assign pipeline_bridge_0_s1_end_xfer = ~(pipeline_bridge_0_s1_waits_for_read | pipeline_bridge_0_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_pipeline_bridge_0_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_pipeline_bridge_0_s1 = pipeline_bridge_0_s1_end_xfer & (~pipeline_bridge_0_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //pipeline_bridge_0_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign pipeline_bridge_0_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_pipeline_bridge_0_s1 & pipeline_bridge_0_s1_allgrants) | (end_xfer_arb_share_counter_term_pipeline_bridge_0_s1 & ~pipeline_bridge_0_s1_non_bursting_master_requests);

  //pipeline_bridge_0_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pipeline_bridge_0_s1_arb_share_counter <= 0;
      else if (pipeline_bridge_0_s1_arb_counter_enable)
          pipeline_bridge_0_s1_arb_share_counter <= pipeline_bridge_0_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pipeline_bridge_0_s1_slavearbiterlockenable <= 0;
      else if ((|pipeline_bridge_0_s1_master_qreq_vector & end_xfer_arb_share_counter_term_pipeline_bridge_0_s1) | (end_xfer_arb_share_counter_term_pipeline_bridge_0_s1 & ~pipeline_bridge_0_s1_non_bursting_master_requests))
          pipeline_bridge_0_s1_slavearbiterlockenable <= |pipeline_bridge_0_s1_arb_share_counter_next_value;
    end


  //nios_f/data_master pipeline_bridge_0/s1 arbiterlock, which is an e_assign
  assign nios_f_data_master_arbiterlock = pipeline_bridge_0_s1_slavearbiterlockenable & nios_f_data_master_continuerequest;

  //pipeline_bridge_0_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_s1_slavearbiterlockenable2 = |pipeline_bridge_0_s1_arb_share_counter_next_value;

  //nios_f/data_master pipeline_bridge_0/s1 arbiterlock2, which is an e_assign
  assign nios_f_data_master_arbiterlock2 = pipeline_bridge_0_s1_slavearbiterlockenable2 & nios_f_data_master_continuerequest;

  //nios_f/instruction_master pipeline_bridge_0/s1 arbiterlock, which is an e_assign
  assign nios_f_instruction_master_arbiterlock = pipeline_bridge_0_s1_slavearbiterlockenable & nios_f_instruction_master_continuerequest;

  //nios_f/instruction_master pipeline_bridge_0/s1 arbiterlock2, which is an e_assign
  assign nios_f_instruction_master_arbiterlock2 = pipeline_bridge_0_s1_slavearbiterlockenable2 & nios_f_instruction_master_continuerequest;

  //nios_f/instruction_master granted pipeline_bridge_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios_f_instruction_master_granted_slave_pipeline_bridge_0_s1 <= 0;
      else 
        last_cycle_nios_f_instruction_master_granted_slave_pipeline_bridge_0_s1 <= nios_f_instruction_master_saved_grant_pipeline_bridge_0_s1 ? 1 : (pipeline_bridge_0_s1_arbitration_holdoff_internal | ~nios_f_instruction_master_requests_pipeline_bridge_0_s1) ? 0 : last_cycle_nios_f_instruction_master_granted_slave_pipeline_bridge_0_s1;
    end


  //nios_f_instruction_master_continuerequest continued request, which is an e_mux
  assign nios_f_instruction_master_continuerequest = last_cycle_nios_f_instruction_master_granted_slave_pipeline_bridge_0_s1 & nios_f_instruction_master_requests_pipeline_bridge_0_s1;

  //pipeline_bridge_0_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  assign pipeline_bridge_0_s1_any_continuerequest = nios_f_instruction_master_continuerequest |
    nios_f_data_master_continuerequest;

  assign nios_f_data_master_qualified_request_pipeline_bridge_0_s1 = nios_f_data_master_requests_pipeline_bridge_0_s1 & ~((nios_f_data_master_read & (~nios_f_data_master_waitrequest | (|nios_f_data_master_read_data_valid_pipeline_bridge_0_s1_shift_register))) | ((~nios_f_data_master_waitrequest) & nios_f_data_master_write) | nios_f_instruction_master_arbiterlock);
  //unique name for pipeline_bridge_0_s1_move_on_to_next_transaction, which is an e_assign
  assign pipeline_bridge_0_s1_move_on_to_next_transaction = pipeline_bridge_0_s1_readdatavalid_from_sa;

  //rdv_fifo_for_nios_f_data_master_to_pipeline_bridge_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_nios_f_data_master_to_pipeline_bridge_0_s1_module rdv_fifo_for_nios_f_data_master_to_pipeline_bridge_0_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (nios_f_data_master_granted_pipeline_bridge_0_s1),
      .data_out             (nios_f_data_master_rdv_fifo_output_from_pipeline_bridge_0_s1),
      .empty                (),
      .fifo_contains_ones_n (nios_f_data_master_rdv_fifo_empty_pipeline_bridge_0_s1),
      .full                 (),
      .read                 (pipeline_bridge_0_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~pipeline_bridge_0_s1_waits_for_read)
    );

  assign nios_f_data_master_read_data_valid_pipeline_bridge_0_s1_shift_register = ~nios_f_data_master_rdv_fifo_empty_pipeline_bridge_0_s1;
  //local readdatavalid nios_f_data_master_read_data_valid_pipeline_bridge_0_s1, which is an e_mux
  assign nios_f_data_master_read_data_valid_pipeline_bridge_0_s1 = (pipeline_bridge_0_s1_readdatavalid_from_sa & nios_f_data_master_rdv_fifo_output_from_pipeline_bridge_0_s1) & ~ nios_f_data_master_rdv_fifo_empty_pipeline_bridge_0_s1;

  //pipeline_bridge_0_s1_writedata mux, which is an e_mux
  assign pipeline_bridge_0_s1_writedata = nios_f_data_master_writedata;

  //assign pipeline_bridge_0_s1_endofpacket_from_sa = pipeline_bridge_0_s1_endofpacket so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign pipeline_bridge_0_s1_endofpacket_from_sa = pipeline_bridge_0_s1_endofpacket;

  assign nios_f_instruction_master_requests_pipeline_bridge_0_s1 = (({nios_f_instruction_master_address_to_slave[25 : 9] , 9'b0} == 26'h1000000) & (nios_f_instruction_master_read)) & nios_f_instruction_master_read;
  //nios_f/data_master granted pipeline_bridge_0/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios_f_data_master_granted_slave_pipeline_bridge_0_s1 <= 0;
      else 
        last_cycle_nios_f_data_master_granted_slave_pipeline_bridge_0_s1 <= nios_f_data_master_saved_grant_pipeline_bridge_0_s1 ? 1 : (pipeline_bridge_0_s1_arbitration_holdoff_internal | ~nios_f_data_master_requests_pipeline_bridge_0_s1) ? 0 : last_cycle_nios_f_data_master_granted_slave_pipeline_bridge_0_s1;
    end


  //nios_f_data_master_continuerequest continued request, which is an e_mux
  assign nios_f_data_master_continuerequest = last_cycle_nios_f_data_master_granted_slave_pipeline_bridge_0_s1 & nios_f_data_master_requests_pipeline_bridge_0_s1;

  assign nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1 = nios_f_instruction_master_requests_pipeline_bridge_0_s1 & ~((nios_f_instruction_master_read & ((nios_f_instruction_master_latency_counter != 0) | (1 < nios_f_instruction_master_latency_counter) | (|nios_f_instruction_master_read_data_valid_sdram_s1_shift_register))) | nios_f_data_master_arbiterlock);
  //rdv_fifo_for_nios_f_instruction_master_to_pipeline_bridge_0_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_nios_f_instruction_master_to_pipeline_bridge_0_s1_module rdv_fifo_for_nios_f_instruction_master_to_pipeline_bridge_0_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (nios_f_instruction_master_granted_pipeline_bridge_0_s1),
      .data_out             (nios_f_instruction_master_rdv_fifo_output_from_pipeline_bridge_0_s1),
      .empty                (),
      .fifo_contains_ones_n (nios_f_instruction_master_rdv_fifo_empty_pipeline_bridge_0_s1),
      .full                 (),
      .read                 (pipeline_bridge_0_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~pipeline_bridge_0_s1_waits_for_read)
    );

  assign nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register = ~nios_f_instruction_master_rdv_fifo_empty_pipeline_bridge_0_s1;
  //local readdatavalid nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1, which is an e_mux
  assign nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1 = (pipeline_bridge_0_s1_readdatavalid_from_sa & nios_f_instruction_master_rdv_fifo_output_from_pipeline_bridge_0_s1) & ~ nios_f_instruction_master_rdv_fifo_empty_pipeline_bridge_0_s1;

  //allow new arb cycle for pipeline_bridge_0/s1, which is an e_assign
  assign pipeline_bridge_0_s1_allow_new_arb_cycle = ~nios_f_data_master_arbiterlock & ~nios_f_instruction_master_arbiterlock;

  //nios_f/instruction_master assignment into master qualified-requests vector for pipeline_bridge_0/s1, which is an e_assign
  assign pipeline_bridge_0_s1_master_qreq_vector[0] = nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1;

  //nios_f/instruction_master grant pipeline_bridge_0/s1, which is an e_assign
  assign nios_f_instruction_master_granted_pipeline_bridge_0_s1 = pipeline_bridge_0_s1_grant_vector[0];

  //nios_f/instruction_master saved-grant pipeline_bridge_0/s1, which is an e_assign
  assign nios_f_instruction_master_saved_grant_pipeline_bridge_0_s1 = pipeline_bridge_0_s1_arb_winner[0] && nios_f_instruction_master_requests_pipeline_bridge_0_s1;

  //nios_f/data_master assignment into master qualified-requests vector for pipeline_bridge_0/s1, which is an e_assign
  assign pipeline_bridge_0_s1_master_qreq_vector[1] = nios_f_data_master_qualified_request_pipeline_bridge_0_s1;

  //nios_f/data_master grant pipeline_bridge_0/s1, which is an e_assign
  assign nios_f_data_master_granted_pipeline_bridge_0_s1 = pipeline_bridge_0_s1_grant_vector[1];

  //nios_f/data_master saved-grant pipeline_bridge_0/s1, which is an e_assign
  assign nios_f_data_master_saved_grant_pipeline_bridge_0_s1 = pipeline_bridge_0_s1_arb_winner[1] && nios_f_data_master_requests_pipeline_bridge_0_s1;

  //pipeline_bridge_0/s1 chosen-master double-vector, which is an e_assign
  assign pipeline_bridge_0_s1_chosen_master_double_vector = {pipeline_bridge_0_s1_master_qreq_vector, pipeline_bridge_0_s1_master_qreq_vector} & ({~pipeline_bridge_0_s1_master_qreq_vector, ~pipeline_bridge_0_s1_master_qreq_vector} + pipeline_bridge_0_s1_arb_addend);

  //stable onehot encoding of arb winner
  assign pipeline_bridge_0_s1_arb_winner = (pipeline_bridge_0_s1_allow_new_arb_cycle & | pipeline_bridge_0_s1_grant_vector) ? pipeline_bridge_0_s1_grant_vector : pipeline_bridge_0_s1_saved_chosen_master_vector;

  //saved pipeline_bridge_0_s1_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pipeline_bridge_0_s1_saved_chosen_master_vector <= 0;
      else if (pipeline_bridge_0_s1_allow_new_arb_cycle)
          pipeline_bridge_0_s1_saved_chosen_master_vector <= |pipeline_bridge_0_s1_grant_vector ? pipeline_bridge_0_s1_grant_vector : pipeline_bridge_0_s1_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign pipeline_bridge_0_s1_grant_vector = {(pipeline_bridge_0_s1_chosen_master_double_vector[1] | pipeline_bridge_0_s1_chosen_master_double_vector[3]),
    (pipeline_bridge_0_s1_chosen_master_double_vector[0] | pipeline_bridge_0_s1_chosen_master_double_vector[2])};

  //pipeline_bridge_0/s1 chosen master rotated left, which is an e_assign
  assign pipeline_bridge_0_s1_chosen_master_rot_left = (pipeline_bridge_0_s1_arb_winner << 1) ? (pipeline_bridge_0_s1_arb_winner << 1) : 1;

  //pipeline_bridge_0/s1's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pipeline_bridge_0_s1_arb_addend <= 1;
      else if (|pipeline_bridge_0_s1_grant_vector)
          pipeline_bridge_0_s1_arb_addend <= pipeline_bridge_0_s1_end_xfer? pipeline_bridge_0_s1_chosen_master_rot_left : pipeline_bridge_0_s1_grant_vector;
    end


  //pipeline_bridge_0_s1_reset_n assignment, which is an e_assign
  assign pipeline_bridge_0_s1_reset_n = reset_n;

  assign pipeline_bridge_0_s1_chipselect = nios_f_data_master_granted_pipeline_bridge_0_s1 | nios_f_instruction_master_granted_pipeline_bridge_0_s1;
  //pipeline_bridge_0_s1_firsttransfer first transaction, which is an e_assign
  assign pipeline_bridge_0_s1_firsttransfer = pipeline_bridge_0_s1_begins_xfer ? pipeline_bridge_0_s1_unreg_firsttransfer : pipeline_bridge_0_s1_reg_firsttransfer;

  //pipeline_bridge_0_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign pipeline_bridge_0_s1_unreg_firsttransfer = ~(pipeline_bridge_0_s1_slavearbiterlockenable & pipeline_bridge_0_s1_any_continuerequest);

  //pipeline_bridge_0_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pipeline_bridge_0_s1_reg_firsttransfer <= 1'b1;
      else if (pipeline_bridge_0_s1_begins_xfer)
          pipeline_bridge_0_s1_reg_firsttransfer <= pipeline_bridge_0_s1_unreg_firsttransfer;
    end


  //pipeline_bridge_0_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign pipeline_bridge_0_s1_beginbursttransfer_internal = pipeline_bridge_0_s1_begins_xfer;

  //pipeline_bridge_0_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign pipeline_bridge_0_s1_arbitration_holdoff_internal = pipeline_bridge_0_s1_begins_xfer & pipeline_bridge_0_s1_firsttransfer;

  //pipeline_bridge_0_s1_read assignment, which is an e_mux
  assign pipeline_bridge_0_s1_read = (nios_f_data_master_granted_pipeline_bridge_0_s1 & nios_f_data_master_read) | (nios_f_instruction_master_granted_pipeline_bridge_0_s1 & nios_f_instruction_master_read);

  //pipeline_bridge_0_s1_write assignment, which is an e_mux
  assign pipeline_bridge_0_s1_write = nios_f_data_master_granted_pipeline_bridge_0_s1 & nios_f_data_master_write;

  assign shifted_address_to_pipeline_bridge_0_s1_from_nios_f_data_master = nios_f_data_master_address_to_slave;
  //pipeline_bridge_0_s1_address mux, which is an e_mux
  assign pipeline_bridge_0_s1_address = (nios_f_data_master_granted_pipeline_bridge_0_s1)? (shifted_address_to_pipeline_bridge_0_s1_from_nios_f_data_master >> 2) :
    (shifted_address_to_pipeline_bridge_0_s1_from_nios_f_instruction_master >> 2);

  assign shifted_address_to_pipeline_bridge_0_s1_from_nios_f_instruction_master = nios_f_instruction_master_address_to_slave;
  //slaveid pipeline_bridge_0_s1_nativeaddress nativeaddress mux, which is an e_mux
  assign pipeline_bridge_0_s1_nativeaddress = (nios_f_data_master_granted_pipeline_bridge_0_s1)? (nios_f_data_master_address_to_slave >> 2) :
    (nios_f_instruction_master_address_to_slave >> 2);

  //d1_pipeline_bridge_0_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_pipeline_bridge_0_s1_end_xfer <= 1;
      else 
        d1_pipeline_bridge_0_s1_end_xfer <= pipeline_bridge_0_s1_end_xfer;
    end


  //pipeline_bridge_0_s1_waits_for_read in a cycle, which is an e_mux
  assign pipeline_bridge_0_s1_waits_for_read = pipeline_bridge_0_s1_in_a_read_cycle & pipeline_bridge_0_s1_waitrequest_from_sa;

  //pipeline_bridge_0_s1_in_a_read_cycle assignment, which is an e_assign
  assign pipeline_bridge_0_s1_in_a_read_cycle = (nios_f_data_master_granted_pipeline_bridge_0_s1 & nios_f_data_master_read) | (nios_f_instruction_master_granted_pipeline_bridge_0_s1 & nios_f_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = pipeline_bridge_0_s1_in_a_read_cycle;

  //pipeline_bridge_0_s1_waits_for_write in a cycle, which is an e_mux
  assign pipeline_bridge_0_s1_waits_for_write = pipeline_bridge_0_s1_in_a_write_cycle & pipeline_bridge_0_s1_waitrequest_from_sa;

  //pipeline_bridge_0_s1_in_a_write_cycle assignment, which is an e_assign
  assign pipeline_bridge_0_s1_in_a_write_cycle = nios_f_data_master_granted_pipeline_bridge_0_s1 & nios_f_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = pipeline_bridge_0_s1_in_a_write_cycle;

  assign wait_for_pipeline_bridge_0_s1_counter = 0;
  //pipeline_bridge_0_s1_byteenable byte enable port mux, which is an e_mux
  assign pipeline_bridge_0_s1_byteenable = (nios_f_data_master_granted_pipeline_bridge_0_s1)? nios_f_data_master_byteenable :
    -1;

  //burstcount mux, which is an e_mux
  assign pipeline_bridge_0_s1_burstcount = 1;

  //pipeline_bridge_0/s1 arbiterlock assigned from _handle_arbiterlock, which is an e_mux
  assign pipeline_bridge_0_s1_arbiterlock = (nios_f_data_master_arbiterlock)? nios_f_data_master_arbiterlock :
    nios_f_instruction_master_arbiterlock;

  //pipeline_bridge_0/s1 arbiterlock2 assigned from _handle_arbiterlock2, which is an e_mux
  assign pipeline_bridge_0_s1_arbiterlock2 = (nios_f_data_master_arbiterlock2)? nios_f_data_master_arbiterlock2 :
    nios_f_instruction_master_arbiterlock2;

  //debugaccess mux, which is an e_mux
  assign pipeline_bridge_0_s1_debugaccess = (nios_f_data_master_granted_pipeline_bridge_0_s1)? nios_f_data_master_debugaccess :
    0;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pipeline_bridge_0/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (nios_f_data_master_granted_pipeline_bridge_0_s1 + nios_f_instruction_master_granted_pipeline_bridge_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (nios_f_data_master_saved_grant_pipeline_bridge_0_s1 + nios_f_instruction_master_saved_grant_pipeline_bridge_0_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module pipeline_bridge_0_m1_arbitrator (
                                         // inputs:
                                          ads_busy_s1_readdata_from_sa,
                                          ads_clk_s1_readdata_from_sa,
                                          ads_din_s1_readdata_from_sa,
                                          ads_dout_s1_readdata_from_sa,
                                          ads_ncs_s1_readdata_from_sa,
                                          ads_nirq_s1_readdata_from_sa,
                                          clk,
                                          d1_ads_busy_s1_end_xfer,
                                          d1_ads_clk_s1_end_xfer,
                                          d1_ads_din_s1_end_xfer,
                                          d1_ads_dout_s1_end_xfer,
                                          d1_ads_ncs_s1_end_xfer,
                                          d1_ads_nirq_s1_end_xfer,
                                          d1_ili_db_s1_end_xfer,
                                          d1_ili_ncs_s1_end_xfer,
                                          d1_ili_nrd_s1_end_xfer,
                                          d1_ili_nrst_s1_end_xfer,
                                          d1_ili_nwr_s1_end_xfer,
                                          d1_ili_rs_s1_end_xfer,
                                          d1_sd_clk_s1_end_xfer,
                                          d1_sd_din_s1_end_xfer,
                                          d1_sd_dout_s1_end_xfer,
                                          d1_sd_ncs_s1_end_xfer,
                                          ili_db_s1_readdata_from_sa,
                                          ili_ncs_s1_readdata_from_sa,
                                          ili_nrd_s1_readdata_from_sa,
                                          ili_nrst_s1_readdata_from_sa,
                                          ili_nwr_s1_readdata_from_sa,
                                          ili_rs_s1_readdata_from_sa,
                                          pipeline_bridge_0_m1_address,
                                          pipeline_bridge_0_m1_burstcount,
                                          pipeline_bridge_0_m1_byteenable,
                                          pipeline_bridge_0_m1_chipselect,
                                          pipeline_bridge_0_m1_granted_ads_busy_s1,
                                          pipeline_bridge_0_m1_granted_ads_clk_s1,
                                          pipeline_bridge_0_m1_granted_ads_din_s1,
                                          pipeline_bridge_0_m1_granted_ads_dout_s1,
                                          pipeline_bridge_0_m1_granted_ads_ncs_s1,
                                          pipeline_bridge_0_m1_granted_ads_nirq_s1,
                                          pipeline_bridge_0_m1_granted_ili_db_s1,
                                          pipeline_bridge_0_m1_granted_ili_ncs_s1,
                                          pipeline_bridge_0_m1_granted_ili_nrd_s1,
                                          pipeline_bridge_0_m1_granted_ili_nrst_s1,
                                          pipeline_bridge_0_m1_granted_ili_nwr_s1,
                                          pipeline_bridge_0_m1_granted_ili_rs_s1,
                                          pipeline_bridge_0_m1_granted_sd_clk_s1,
                                          pipeline_bridge_0_m1_granted_sd_din_s1,
                                          pipeline_bridge_0_m1_granted_sd_dout_s1,
                                          pipeline_bridge_0_m1_granted_sd_ncs_s1,
                                          pipeline_bridge_0_m1_qualified_request_ads_busy_s1,
                                          pipeline_bridge_0_m1_qualified_request_ads_clk_s1,
                                          pipeline_bridge_0_m1_qualified_request_ads_din_s1,
                                          pipeline_bridge_0_m1_qualified_request_ads_dout_s1,
                                          pipeline_bridge_0_m1_qualified_request_ads_ncs_s1,
                                          pipeline_bridge_0_m1_qualified_request_ads_nirq_s1,
                                          pipeline_bridge_0_m1_qualified_request_ili_db_s1,
                                          pipeline_bridge_0_m1_qualified_request_ili_ncs_s1,
                                          pipeline_bridge_0_m1_qualified_request_ili_nrd_s1,
                                          pipeline_bridge_0_m1_qualified_request_ili_nrst_s1,
                                          pipeline_bridge_0_m1_qualified_request_ili_nwr_s1,
                                          pipeline_bridge_0_m1_qualified_request_ili_rs_s1,
                                          pipeline_bridge_0_m1_qualified_request_sd_clk_s1,
                                          pipeline_bridge_0_m1_qualified_request_sd_din_s1,
                                          pipeline_bridge_0_m1_qualified_request_sd_dout_s1,
                                          pipeline_bridge_0_m1_qualified_request_sd_ncs_s1,
                                          pipeline_bridge_0_m1_read,
                                          pipeline_bridge_0_m1_read_data_valid_ads_busy_s1,
                                          pipeline_bridge_0_m1_read_data_valid_ads_clk_s1,
                                          pipeline_bridge_0_m1_read_data_valid_ads_din_s1,
                                          pipeline_bridge_0_m1_read_data_valid_ads_dout_s1,
                                          pipeline_bridge_0_m1_read_data_valid_ads_ncs_s1,
                                          pipeline_bridge_0_m1_read_data_valid_ads_nirq_s1,
                                          pipeline_bridge_0_m1_read_data_valid_ili_db_s1,
                                          pipeline_bridge_0_m1_read_data_valid_ili_ncs_s1,
                                          pipeline_bridge_0_m1_read_data_valid_ili_nrd_s1,
                                          pipeline_bridge_0_m1_read_data_valid_ili_nrst_s1,
                                          pipeline_bridge_0_m1_read_data_valid_ili_nwr_s1,
                                          pipeline_bridge_0_m1_read_data_valid_ili_rs_s1,
                                          pipeline_bridge_0_m1_read_data_valid_sd_clk_s1,
                                          pipeline_bridge_0_m1_read_data_valid_sd_din_s1,
                                          pipeline_bridge_0_m1_read_data_valid_sd_dout_s1,
                                          pipeline_bridge_0_m1_read_data_valid_sd_ncs_s1,
                                          pipeline_bridge_0_m1_requests_ads_busy_s1,
                                          pipeline_bridge_0_m1_requests_ads_clk_s1,
                                          pipeline_bridge_0_m1_requests_ads_din_s1,
                                          pipeline_bridge_0_m1_requests_ads_dout_s1,
                                          pipeline_bridge_0_m1_requests_ads_ncs_s1,
                                          pipeline_bridge_0_m1_requests_ads_nirq_s1,
                                          pipeline_bridge_0_m1_requests_ili_db_s1,
                                          pipeline_bridge_0_m1_requests_ili_ncs_s1,
                                          pipeline_bridge_0_m1_requests_ili_nrd_s1,
                                          pipeline_bridge_0_m1_requests_ili_nrst_s1,
                                          pipeline_bridge_0_m1_requests_ili_nwr_s1,
                                          pipeline_bridge_0_m1_requests_ili_rs_s1,
                                          pipeline_bridge_0_m1_requests_sd_clk_s1,
                                          pipeline_bridge_0_m1_requests_sd_din_s1,
                                          pipeline_bridge_0_m1_requests_sd_dout_s1,
                                          pipeline_bridge_0_m1_requests_sd_ncs_s1,
                                          pipeline_bridge_0_m1_write,
                                          pipeline_bridge_0_m1_writedata,
                                          reset_n,
                                          sd_clk_s1_readdata_from_sa,
                                          sd_din_s1_readdata_from_sa,
                                          sd_dout_s1_readdata_from_sa,
                                          sd_ncs_s1_readdata_from_sa,

                                         // outputs:
                                          pipeline_bridge_0_m1_address_to_slave,
                                          pipeline_bridge_0_m1_latency_counter,
                                          pipeline_bridge_0_m1_readdata,
                                          pipeline_bridge_0_m1_readdatavalid,
                                          pipeline_bridge_0_m1_waitrequest
                                       )
;

  output  [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  output           pipeline_bridge_0_m1_latency_counter;
  output  [ 31: 0] pipeline_bridge_0_m1_readdata;
  output           pipeline_bridge_0_m1_readdatavalid;
  output           pipeline_bridge_0_m1_waitrequest;
  input   [ 31: 0] ads_busy_s1_readdata_from_sa;
  input   [ 31: 0] ads_clk_s1_readdata_from_sa;
  input   [ 31: 0] ads_din_s1_readdata_from_sa;
  input   [ 31: 0] ads_dout_s1_readdata_from_sa;
  input   [ 31: 0] ads_ncs_s1_readdata_from_sa;
  input   [ 31: 0] ads_nirq_s1_readdata_from_sa;
  input            clk;
  input            d1_ads_busy_s1_end_xfer;
  input            d1_ads_clk_s1_end_xfer;
  input            d1_ads_din_s1_end_xfer;
  input            d1_ads_dout_s1_end_xfer;
  input            d1_ads_ncs_s1_end_xfer;
  input            d1_ads_nirq_s1_end_xfer;
  input            d1_ili_db_s1_end_xfer;
  input            d1_ili_ncs_s1_end_xfer;
  input            d1_ili_nrd_s1_end_xfer;
  input            d1_ili_nrst_s1_end_xfer;
  input            d1_ili_nwr_s1_end_xfer;
  input            d1_ili_rs_s1_end_xfer;
  input            d1_sd_clk_s1_end_xfer;
  input            d1_sd_din_s1_end_xfer;
  input            d1_sd_dout_s1_end_xfer;
  input            d1_sd_ncs_s1_end_xfer;
  input   [ 31: 0] ili_db_s1_readdata_from_sa;
  input   [ 31: 0] ili_ncs_s1_readdata_from_sa;
  input   [ 31: 0] ili_nrd_s1_readdata_from_sa;
  input   [ 31: 0] ili_nrst_s1_readdata_from_sa;
  input   [ 31: 0] ili_nwr_s1_readdata_from_sa;
  input   [ 31: 0] ili_rs_s1_readdata_from_sa;
  input   [  8: 0] pipeline_bridge_0_m1_address;
  input            pipeline_bridge_0_m1_burstcount;
  input   [  3: 0] pipeline_bridge_0_m1_byteenable;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_granted_ads_busy_s1;
  input            pipeline_bridge_0_m1_granted_ads_clk_s1;
  input            pipeline_bridge_0_m1_granted_ads_din_s1;
  input            pipeline_bridge_0_m1_granted_ads_dout_s1;
  input            pipeline_bridge_0_m1_granted_ads_ncs_s1;
  input            pipeline_bridge_0_m1_granted_ads_nirq_s1;
  input            pipeline_bridge_0_m1_granted_ili_db_s1;
  input            pipeline_bridge_0_m1_granted_ili_ncs_s1;
  input            pipeline_bridge_0_m1_granted_ili_nrd_s1;
  input            pipeline_bridge_0_m1_granted_ili_nrst_s1;
  input            pipeline_bridge_0_m1_granted_ili_nwr_s1;
  input            pipeline_bridge_0_m1_granted_ili_rs_s1;
  input            pipeline_bridge_0_m1_granted_sd_clk_s1;
  input            pipeline_bridge_0_m1_granted_sd_din_s1;
  input            pipeline_bridge_0_m1_granted_sd_dout_s1;
  input            pipeline_bridge_0_m1_granted_sd_ncs_s1;
  input            pipeline_bridge_0_m1_qualified_request_ads_busy_s1;
  input            pipeline_bridge_0_m1_qualified_request_ads_clk_s1;
  input            pipeline_bridge_0_m1_qualified_request_ads_din_s1;
  input            pipeline_bridge_0_m1_qualified_request_ads_dout_s1;
  input            pipeline_bridge_0_m1_qualified_request_ads_ncs_s1;
  input            pipeline_bridge_0_m1_qualified_request_ads_nirq_s1;
  input            pipeline_bridge_0_m1_qualified_request_ili_db_s1;
  input            pipeline_bridge_0_m1_qualified_request_ili_ncs_s1;
  input            pipeline_bridge_0_m1_qualified_request_ili_nrd_s1;
  input            pipeline_bridge_0_m1_qualified_request_ili_nrst_s1;
  input            pipeline_bridge_0_m1_qualified_request_ili_nwr_s1;
  input            pipeline_bridge_0_m1_qualified_request_ili_rs_s1;
  input            pipeline_bridge_0_m1_qualified_request_sd_clk_s1;
  input            pipeline_bridge_0_m1_qualified_request_sd_din_s1;
  input            pipeline_bridge_0_m1_qualified_request_sd_dout_s1;
  input            pipeline_bridge_0_m1_qualified_request_sd_ncs_s1;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_read_data_valid_ads_busy_s1;
  input            pipeline_bridge_0_m1_read_data_valid_ads_clk_s1;
  input            pipeline_bridge_0_m1_read_data_valid_ads_din_s1;
  input            pipeline_bridge_0_m1_read_data_valid_ads_dout_s1;
  input            pipeline_bridge_0_m1_read_data_valid_ads_ncs_s1;
  input            pipeline_bridge_0_m1_read_data_valid_ads_nirq_s1;
  input            pipeline_bridge_0_m1_read_data_valid_ili_db_s1;
  input            pipeline_bridge_0_m1_read_data_valid_ili_ncs_s1;
  input            pipeline_bridge_0_m1_read_data_valid_ili_nrd_s1;
  input            pipeline_bridge_0_m1_read_data_valid_ili_nrst_s1;
  input            pipeline_bridge_0_m1_read_data_valid_ili_nwr_s1;
  input            pipeline_bridge_0_m1_read_data_valid_ili_rs_s1;
  input            pipeline_bridge_0_m1_read_data_valid_sd_clk_s1;
  input            pipeline_bridge_0_m1_read_data_valid_sd_din_s1;
  input            pipeline_bridge_0_m1_read_data_valid_sd_dout_s1;
  input            pipeline_bridge_0_m1_read_data_valid_sd_ncs_s1;
  input            pipeline_bridge_0_m1_requests_ads_busy_s1;
  input            pipeline_bridge_0_m1_requests_ads_clk_s1;
  input            pipeline_bridge_0_m1_requests_ads_din_s1;
  input            pipeline_bridge_0_m1_requests_ads_dout_s1;
  input            pipeline_bridge_0_m1_requests_ads_ncs_s1;
  input            pipeline_bridge_0_m1_requests_ads_nirq_s1;
  input            pipeline_bridge_0_m1_requests_ili_db_s1;
  input            pipeline_bridge_0_m1_requests_ili_ncs_s1;
  input            pipeline_bridge_0_m1_requests_ili_nrd_s1;
  input            pipeline_bridge_0_m1_requests_ili_nrst_s1;
  input            pipeline_bridge_0_m1_requests_ili_nwr_s1;
  input            pipeline_bridge_0_m1_requests_ili_rs_s1;
  input            pipeline_bridge_0_m1_requests_sd_clk_s1;
  input            pipeline_bridge_0_m1_requests_sd_din_s1;
  input            pipeline_bridge_0_m1_requests_sd_dout_s1;
  input            pipeline_bridge_0_m1_requests_sd_ncs_s1;
  input            pipeline_bridge_0_m1_write;
  input   [ 31: 0] pipeline_bridge_0_m1_writedata;
  input            reset_n;
  input   [ 31: 0] sd_clk_s1_readdata_from_sa;
  input   [ 31: 0] sd_din_s1_readdata_from_sa;
  input   [ 31: 0] sd_dout_s1_readdata_from_sa;
  input   [ 31: 0] sd_ncs_s1_readdata_from_sa;

  reg              active_and_waiting_last_time;
  wire             latency_load_value;
  wire             p1_pipeline_bridge_0_m1_latency_counter;
  reg     [  8: 0] pipeline_bridge_0_m1_address_last_time;
  wire    [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  reg              pipeline_bridge_0_m1_burstcount_last_time;
  reg     [  3: 0] pipeline_bridge_0_m1_byteenable_last_time;
  reg              pipeline_bridge_0_m1_chipselect_last_time;
  wire             pipeline_bridge_0_m1_is_granted_some_slave;
  reg              pipeline_bridge_0_m1_latency_counter;
  reg              pipeline_bridge_0_m1_read_but_no_slave_selected;
  reg              pipeline_bridge_0_m1_read_last_time;
  wire    [ 31: 0] pipeline_bridge_0_m1_readdata;
  wire             pipeline_bridge_0_m1_readdatavalid;
  wire             pipeline_bridge_0_m1_run;
  wire             pipeline_bridge_0_m1_waitrequest;
  reg              pipeline_bridge_0_m1_write_last_time;
  reg     [ 31: 0] pipeline_bridge_0_m1_writedata_last_time;
  wire             pre_flush_pipeline_bridge_0_m1_readdatavalid;
  wire             r_0;
  wire             r_1;
  wire             r_2;
  wire             r_3;
  //r_0 master_run cascaded wait assignment, which is an e_assign
  assign r_0 = 1 & (pipeline_bridge_0_m1_qualified_request_ads_busy_s1 | ~pipeline_bridge_0_m1_requests_ads_busy_s1) & ((~pipeline_bridge_0_m1_qualified_request_ads_busy_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_ads_busy_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_ads_busy_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect)))) & 1 & (pipeline_bridge_0_m1_qualified_request_ads_clk_s1 | ~pipeline_bridge_0_m1_requests_ads_clk_s1) & ((~pipeline_bridge_0_m1_qualified_request_ads_clk_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_ads_clk_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_ads_clk_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect)))) & 1 & (pipeline_bridge_0_m1_qualified_request_ads_din_s1 | ~pipeline_bridge_0_m1_requests_ads_din_s1) & ((~pipeline_bridge_0_m1_qualified_request_ads_din_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_ads_din_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_ads_din_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect)))) & 1 & (pipeline_bridge_0_m1_qualified_request_ads_dout_s1 | ~pipeline_bridge_0_m1_requests_ads_dout_s1) & ((~pipeline_bridge_0_m1_qualified_request_ads_dout_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_ads_dout_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_ads_dout_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect)))) & 1 & (pipeline_bridge_0_m1_qualified_request_ads_ncs_s1 | ~pipeline_bridge_0_m1_requests_ads_ncs_s1) & ((~pipeline_bridge_0_m1_qualified_request_ads_ncs_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_ads_ncs_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_ads_ncs_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect))));

  //cascaded wait assignment, which is an e_assign
  assign pipeline_bridge_0_m1_run = r_0 & r_1 & r_2 & r_3;

  //r_1 master_run cascaded wait assignment, which is an e_assign
  assign r_1 = 1 & (pipeline_bridge_0_m1_qualified_request_ads_nirq_s1 | ~pipeline_bridge_0_m1_requests_ads_nirq_s1) & ((~pipeline_bridge_0_m1_qualified_request_ads_nirq_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_ads_nirq_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_ads_nirq_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect)))) & 1 & (pipeline_bridge_0_m1_qualified_request_ili_db_s1 | ~pipeline_bridge_0_m1_requests_ili_db_s1) & ((~pipeline_bridge_0_m1_qualified_request_ili_db_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_ili_db_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_ili_db_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect)))) & 1 & (pipeline_bridge_0_m1_qualified_request_ili_ncs_s1 | ~pipeline_bridge_0_m1_requests_ili_ncs_s1) & ((~pipeline_bridge_0_m1_qualified_request_ili_ncs_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_ili_ncs_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_ili_ncs_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect)))) & 1 & (pipeline_bridge_0_m1_qualified_request_ili_nrd_s1 | ~pipeline_bridge_0_m1_requests_ili_nrd_s1) & ((~pipeline_bridge_0_m1_qualified_request_ili_nrd_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_ili_nrd_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_ili_nrd_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect)))) & 1 & (pipeline_bridge_0_m1_qualified_request_ili_nrst_s1 | ~pipeline_bridge_0_m1_requests_ili_nrst_s1) & ((~pipeline_bridge_0_m1_qualified_request_ili_nrst_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_ili_nrst_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_ili_nrst_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect))));

  //r_2 master_run cascaded wait assignment, which is an e_assign
  assign r_2 = 1 & (pipeline_bridge_0_m1_qualified_request_ili_nwr_s1 | ~pipeline_bridge_0_m1_requests_ili_nwr_s1) & ((~pipeline_bridge_0_m1_qualified_request_ili_nwr_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_ili_nwr_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_ili_nwr_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect)))) & 1 & (pipeline_bridge_0_m1_qualified_request_ili_rs_s1 | ~pipeline_bridge_0_m1_requests_ili_rs_s1) & ((~pipeline_bridge_0_m1_qualified_request_ili_rs_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_ili_rs_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_ili_rs_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect)))) & 1 & (pipeline_bridge_0_m1_qualified_request_sd_clk_s1 | ~pipeline_bridge_0_m1_requests_sd_clk_s1) & ((~pipeline_bridge_0_m1_qualified_request_sd_clk_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_sd_clk_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_sd_clk_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect)))) & 1 & (pipeline_bridge_0_m1_qualified_request_sd_din_s1 | ~pipeline_bridge_0_m1_requests_sd_din_s1) & ((~pipeline_bridge_0_m1_qualified_request_sd_din_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_sd_din_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_sd_din_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect)))) & 1 & (pipeline_bridge_0_m1_qualified_request_sd_dout_s1 | ~pipeline_bridge_0_m1_requests_sd_dout_s1) & ((~pipeline_bridge_0_m1_qualified_request_sd_dout_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_sd_dout_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_sd_dout_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect))));

  //r_3 master_run cascaded wait assignment, which is an e_assign
  assign r_3 = 1 & (pipeline_bridge_0_m1_qualified_request_sd_ncs_s1 | ~pipeline_bridge_0_m1_requests_sd_ncs_s1) & ((~pipeline_bridge_0_m1_qualified_request_sd_ncs_s1 | ~(pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) | (1 & ~d1_sd_ncs_s1_end_xfer & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))) & ((~pipeline_bridge_0_m1_qualified_request_sd_ncs_s1 | ~(pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect) | (1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect))));

  //optimize select-logic by passing only those address bits which matter.
  assign pipeline_bridge_0_m1_address_to_slave = pipeline_bridge_0_m1_address[8 : 0];

  //pipeline_bridge_0_m1_read_but_no_slave_selected assignment, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pipeline_bridge_0_m1_read_but_no_slave_selected <= 0;
      else 
        pipeline_bridge_0_m1_read_but_no_slave_selected <= (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & pipeline_bridge_0_m1_run & ~pipeline_bridge_0_m1_is_granted_some_slave;
    end


  //some slave is getting selected, which is an e_mux
  assign pipeline_bridge_0_m1_is_granted_some_slave = pipeline_bridge_0_m1_granted_ads_busy_s1 |
    pipeline_bridge_0_m1_granted_ads_clk_s1 |
    pipeline_bridge_0_m1_granted_ads_din_s1 |
    pipeline_bridge_0_m1_granted_ads_dout_s1 |
    pipeline_bridge_0_m1_granted_ads_ncs_s1 |
    pipeline_bridge_0_m1_granted_ads_nirq_s1 |
    pipeline_bridge_0_m1_granted_ili_db_s1 |
    pipeline_bridge_0_m1_granted_ili_ncs_s1 |
    pipeline_bridge_0_m1_granted_ili_nrd_s1 |
    pipeline_bridge_0_m1_granted_ili_nrst_s1 |
    pipeline_bridge_0_m1_granted_ili_nwr_s1 |
    pipeline_bridge_0_m1_granted_ili_rs_s1 |
    pipeline_bridge_0_m1_granted_sd_clk_s1 |
    pipeline_bridge_0_m1_granted_sd_din_s1 |
    pipeline_bridge_0_m1_granted_sd_dout_s1 |
    pipeline_bridge_0_m1_granted_sd_ncs_s1;

  //latent slave read data valids which may be flushed, which is an e_mux
  assign pre_flush_pipeline_bridge_0_m1_readdatavalid = 0;

  //latent slave read data valid which is not flushed, which is an e_mux
  assign pipeline_bridge_0_m1_readdatavalid = pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_ads_busy_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_ads_clk_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_ads_din_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_ads_dout_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_ads_ncs_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_ads_nirq_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_ili_db_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_ili_ncs_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_ili_nrd_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_ili_nrst_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_ili_nwr_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_ili_rs_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_sd_clk_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_sd_din_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_sd_dout_s1 |
    pipeline_bridge_0_m1_read_but_no_slave_selected |
    pre_flush_pipeline_bridge_0_m1_readdatavalid |
    pipeline_bridge_0_m1_read_data_valid_sd_ncs_s1;

  //pipeline_bridge_0/m1 readdata mux, which is an e_mux
  assign pipeline_bridge_0_m1_readdata = ({32 {~((pipeline_bridge_0_m1_qualified_request_ads_busy_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | ads_busy_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_ads_clk_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | ads_clk_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_ads_din_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | ads_din_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_ads_dout_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | ads_dout_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_ads_ncs_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | ads_ncs_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_ads_nirq_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | ads_nirq_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_ili_db_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | ili_db_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_ili_ncs_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | ili_ncs_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_ili_nrd_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | ili_nrd_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_ili_nrst_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | ili_nrst_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_ili_nwr_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | ili_nwr_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_ili_rs_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | ili_rs_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_sd_clk_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | sd_clk_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_sd_din_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | sd_din_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_sd_dout_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | sd_dout_s1_readdata_from_sa) &
    ({32 {~((pipeline_bridge_0_m1_qualified_request_sd_ncs_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))}} | sd_ncs_s1_readdata_from_sa);

  //actual waitrequest port, which is an e_assign
  assign pipeline_bridge_0_m1_waitrequest = ~pipeline_bridge_0_m1_run;

  //latent max counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pipeline_bridge_0_m1_latency_counter <= 0;
      else 
        pipeline_bridge_0_m1_latency_counter <= p1_pipeline_bridge_0_m1_latency_counter;
    end


  //latency counter load mux, which is an e_mux
  assign p1_pipeline_bridge_0_m1_latency_counter = ((pipeline_bridge_0_m1_run & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect)))? latency_load_value :
    (pipeline_bridge_0_m1_latency_counter)? pipeline_bridge_0_m1_latency_counter - 1 :
    0;

  //read latency load values, which is an e_mux
  assign latency_load_value = 0;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //pipeline_bridge_0_m1_address check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pipeline_bridge_0_m1_address_last_time <= 0;
      else 
        pipeline_bridge_0_m1_address_last_time <= pipeline_bridge_0_m1_address;
    end


  //pipeline_bridge_0/m1 waited last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          active_and_waiting_last_time <= 0;
      else 
        active_and_waiting_last_time <= pipeline_bridge_0_m1_waitrequest & pipeline_bridge_0_m1_chipselect;
    end


  //pipeline_bridge_0_m1_address matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pipeline_bridge_0_m1_address != pipeline_bridge_0_m1_address_last_time))
        begin
          $write("%0d ns: pipeline_bridge_0_m1_address did not heed wait!!!", $time);
          $stop;
        end
    end


  //pipeline_bridge_0_m1_chipselect check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pipeline_bridge_0_m1_chipselect_last_time <= 0;
      else 
        pipeline_bridge_0_m1_chipselect_last_time <= pipeline_bridge_0_m1_chipselect;
    end


  //pipeline_bridge_0_m1_chipselect matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pipeline_bridge_0_m1_chipselect != pipeline_bridge_0_m1_chipselect_last_time))
        begin
          $write("%0d ns: pipeline_bridge_0_m1_chipselect did not heed wait!!!", $time);
          $stop;
        end
    end


  //pipeline_bridge_0_m1_burstcount check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pipeline_bridge_0_m1_burstcount_last_time <= 0;
      else 
        pipeline_bridge_0_m1_burstcount_last_time <= pipeline_bridge_0_m1_burstcount;
    end


  //pipeline_bridge_0_m1_burstcount matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pipeline_bridge_0_m1_burstcount != pipeline_bridge_0_m1_burstcount_last_time))
        begin
          $write("%0d ns: pipeline_bridge_0_m1_burstcount did not heed wait!!!", $time);
          $stop;
        end
    end


  //pipeline_bridge_0_m1_byteenable check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pipeline_bridge_0_m1_byteenable_last_time <= 0;
      else 
        pipeline_bridge_0_m1_byteenable_last_time <= pipeline_bridge_0_m1_byteenable;
    end


  //pipeline_bridge_0_m1_byteenable matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pipeline_bridge_0_m1_byteenable != pipeline_bridge_0_m1_byteenable_last_time))
        begin
          $write("%0d ns: pipeline_bridge_0_m1_byteenable did not heed wait!!!", $time);
          $stop;
        end
    end


  //pipeline_bridge_0_m1_read check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pipeline_bridge_0_m1_read_last_time <= 0;
      else 
        pipeline_bridge_0_m1_read_last_time <= pipeline_bridge_0_m1_read;
    end


  //pipeline_bridge_0_m1_read matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pipeline_bridge_0_m1_read != pipeline_bridge_0_m1_read_last_time))
        begin
          $write("%0d ns: pipeline_bridge_0_m1_read did not heed wait!!!", $time);
          $stop;
        end
    end


  //pipeline_bridge_0_m1_write check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pipeline_bridge_0_m1_write_last_time <= 0;
      else 
        pipeline_bridge_0_m1_write_last_time <= pipeline_bridge_0_m1_write;
    end


  //pipeline_bridge_0_m1_write matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pipeline_bridge_0_m1_write != pipeline_bridge_0_m1_write_last_time))
        begin
          $write("%0d ns: pipeline_bridge_0_m1_write did not heed wait!!!", $time);
          $stop;
        end
    end


  //pipeline_bridge_0_m1_writedata check against wait, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          pipeline_bridge_0_m1_writedata_last_time <= 0;
      else 
        pipeline_bridge_0_m1_writedata_last_time <= pipeline_bridge_0_m1_writedata;
    end


  //pipeline_bridge_0_m1_writedata matches last port_name, which is an e_process
  always @(posedge clk)
    begin
      if (active_and_waiting_last_time & (pipeline_bridge_0_m1_writedata != pipeline_bridge_0_m1_writedata_last_time) & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect))
        begin
          $write("%0d ns: pipeline_bridge_0_m1_writedata did not heed wait!!!", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module pipeline_bridge_0_bridge_arbitrator 
;



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sd_clk_s1_arbitrator (
                              // inputs:
                               clk,
                               pipeline_bridge_0_m1_address_to_slave,
                               pipeline_bridge_0_m1_burstcount,
                               pipeline_bridge_0_m1_chipselect,
                               pipeline_bridge_0_m1_latency_counter,
                               pipeline_bridge_0_m1_read,
                               pipeline_bridge_0_m1_write,
                               pipeline_bridge_0_m1_writedata,
                               reset_n,
                               sd_clk_s1_readdata,

                              // outputs:
                               d1_sd_clk_s1_end_xfer,
                               pipeline_bridge_0_m1_granted_sd_clk_s1,
                               pipeline_bridge_0_m1_qualified_request_sd_clk_s1,
                               pipeline_bridge_0_m1_read_data_valid_sd_clk_s1,
                               pipeline_bridge_0_m1_requests_sd_clk_s1,
                               sd_clk_s1_address,
                               sd_clk_s1_chipselect,
                               sd_clk_s1_readdata_from_sa,
                               sd_clk_s1_reset_n,
                               sd_clk_s1_write_n,
                               sd_clk_s1_writedata
                            )
;

  output           d1_sd_clk_s1_end_xfer;
  output           pipeline_bridge_0_m1_granted_sd_clk_s1;
  output           pipeline_bridge_0_m1_qualified_request_sd_clk_s1;
  output           pipeline_bridge_0_m1_read_data_valid_sd_clk_s1;
  output           pipeline_bridge_0_m1_requests_sd_clk_s1;
  output  [  1: 0] sd_clk_s1_address;
  output           sd_clk_s1_chipselect;
  output  [ 31: 0] sd_clk_s1_readdata_from_sa;
  output           sd_clk_s1_reset_n;
  output           sd_clk_s1_write_n;
  output  [ 31: 0] sd_clk_s1_writedata;
  input            clk;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input   [ 31: 0] pipeline_bridge_0_m1_writedata;
  input            reset_n;
  input   [ 31: 0] sd_clk_s1_readdata;

  reg              d1_reasons_to_wait;
  reg              d1_sd_clk_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sd_clk_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_sd_clk_s1;
  wire             pipeline_bridge_0_m1_qualified_request_sd_clk_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_sd_clk_s1;
  wire             pipeline_bridge_0_m1_requests_sd_clk_s1;
  wire             pipeline_bridge_0_m1_saved_grant_sd_clk_s1;
  wire    [  1: 0] sd_clk_s1_address;
  wire             sd_clk_s1_allgrants;
  wire             sd_clk_s1_allow_new_arb_cycle;
  wire             sd_clk_s1_any_bursting_master_saved_grant;
  wire             sd_clk_s1_any_continuerequest;
  wire             sd_clk_s1_arb_counter_enable;
  reg              sd_clk_s1_arb_share_counter;
  wire             sd_clk_s1_arb_share_counter_next_value;
  wire             sd_clk_s1_arb_share_set_values;
  wire             sd_clk_s1_beginbursttransfer_internal;
  wire             sd_clk_s1_begins_xfer;
  wire             sd_clk_s1_chipselect;
  wire             sd_clk_s1_end_xfer;
  wire             sd_clk_s1_firsttransfer;
  wire             sd_clk_s1_grant_vector;
  wire             sd_clk_s1_in_a_read_cycle;
  wire             sd_clk_s1_in_a_write_cycle;
  wire             sd_clk_s1_master_qreq_vector;
  wire             sd_clk_s1_non_bursting_master_requests;
  wire    [ 31: 0] sd_clk_s1_readdata_from_sa;
  reg              sd_clk_s1_reg_firsttransfer;
  wire             sd_clk_s1_reset_n;
  reg              sd_clk_s1_slavearbiterlockenable;
  wire             sd_clk_s1_slavearbiterlockenable2;
  wire             sd_clk_s1_unreg_firsttransfer;
  wire             sd_clk_s1_waits_for_read;
  wire             sd_clk_s1_waits_for_write;
  wire             sd_clk_s1_write_n;
  wire    [ 31: 0] sd_clk_s1_writedata;
  wire    [  8: 0] shifted_address_to_sd_clk_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_sd_clk_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sd_clk_s1_end_xfer;
    end


  assign sd_clk_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_sd_clk_s1));
  //assign sd_clk_s1_readdata_from_sa = sd_clk_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sd_clk_s1_readdata_from_sa = sd_clk_s1_readdata;

  assign pipeline_bridge_0_m1_requests_sd_clk_s1 = ({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'he0) & pipeline_bridge_0_m1_chipselect;
  //sd_clk_s1_arb_share_counter set values, which is an e_mux
  assign sd_clk_s1_arb_share_set_values = 1;

  //sd_clk_s1_non_bursting_master_requests mux, which is an e_mux
  assign sd_clk_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_sd_clk_s1;

  //sd_clk_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign sd_clk_s1_any_bursting_master_saved_grant = 0;

  //sd_clk_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sd_clk_s1_arb_share_counter_next_value = sd_clk_s1_firsttransfer ? (sd_clk_s1_arb_share_set_values - 1) : |sd_clk_s1_arb_share_counter ? (sd_clk_s1_arb_share_counter - 1) : 0;

  //sd_clk_s1_allgrants all slave grants, which is an e_mux
  assign sd_clk_s1_allgrants = |sd_clk_s1_grant_vector;

  //sd_clk_s1_end_xfer assignment, which is an e_assign
  assign sd_clk_s1_end_xfer = ~(sd_clk_s1_waits_for_read | sd_clk_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_sd_clk_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sd_clk_s1 = sd_clk_s1_end_xfer & (~sd_clk_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sd_clk_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sd_clk_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_sd_clk_s1 & sd_clk_s1_allgrants) | (end_xfer_arb_share_counter_term_sd_clk_s1 & ~sd_clk_s1_non_bursting_master_requests);

  //sd_clk_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_clk_s1_arb_share_counter <= 0;
      else if (sd_clk_s1_arb_counter_enable)
          sd_clk_s1_arb_share_counter <= sd_clk_s1_arb_share_counter_next_value;
    end


  //sd_clk_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_clk_s1_slavearbiterlockenable <= 0;
      else if ((|sd_clk_s1_master_qreq_vector & end_xfer_arb_share_counter_term_sd_clk_s1) | (end_xfer_arb_share_counter_term_sd_clk_s1 & ~sd_clk_s1_non_bursting_master_requests))
          sd_clk_s1_slavearbiterlockenable <= |sd_clk_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 sd_clk/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = sd_clk_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //sd_clk_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sd_clk_s1_slavearbiterlockenable2 = |sd_clk_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 sd_clk/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = sd_clk_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //sd_clk_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sd_clk_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_sd_clk_s1 = pipeline_bridge_0_m1_requests_sd_clk_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_sd_clk_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_sd_clk_s1 = pipeline_bridge_0_m1_granted_sd_clk_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~sd_clk_s1_waits_for_read;

  //sd_clk_s1_writedata mux, which is an e_mux
  assign sd_clk_s1_writedata = pipeline_bridge_0_m1_writedata;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_sd_clk_s1 = pipeline_bridge_0_m1_qualified_request_sd_clk_s1;

  //pipeline_bridge_0/m1 saved-grant sd_clk/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_sd_clk_s1 = pipeline_bridge_0_m1_requests_sd_clk_s1;

  //allow new arb cycle for sd_clk/s1, which is an e_assign
  assign sd_clk_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sd_clk_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sd_clk_s1_master_qreq_vector = 1;

  //sd_clk_s1_reset_n assignment, which is an e_assign
  assign sd_clk_s1_reset_n = reset_n;

  assign sd_clk_s1_chipselect = pipeline_bridge_0_m1_granted_sd_clk_s1;
  //sd_clk_s1_firsttransfer first transaction, which is an e_assign
  assign sd_clk_s1_firsttransfer = sd_clk_s1_begins_xfer ? sd_clk_s1_unreg_firsttransfer : sd_clk_s1_reg_firsttransfer;

  //sd_clk_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign sd_clk_s1_unreg_firsttransfer = ~(sd_clk_s1_slavearbiterlockenable & sd_clk_s1_any_continuerequest);

  //sd_clk_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_clk_s1_reg_firsttransfer <= 1'b1;
      else if (sd_clk_s1_begins_xfer)
          sd_clk_s1_reg_firsttransfer <= sd_clk_s1_unreg_firsttransfer;
    end


  //sd_clk_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sd_clk_s1_beginbursttransfer_internal = sd_clk_s1_begins_xfer;

  //~sd_clk_s1_write_n assignment, which is an e_mux
  assign sd_clk_s1_write_n = ~(pipeline_bridge_0_m1_granted_sd_clk_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect));

  assign shifted_address_to_sd_clk_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //sd_clk_s1_address mux, which is an e_mux
  assign sd_clk_s1_address = shifted_address_to_sd_clk_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_sd_clk_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sd_clk_s1_end_xfer <= 1;
      else 
        d1_sd_clk_s1_end_xfer <= sd_clk_s1_end_xfer;
    end


  //sd_clk_s1_waits_for_read in a cycle, which is an e_mux
  assign sd_clk_s1_waits_for_read = sd_clk_s1_in_a_read_cycle & sd_clk_s1_begins_xfer;

  //sd_clk_s1_in_a_read_cycle assignment, which is an e_assign
  assign sd_clk_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_sd_clk_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sd_clk_s1_in_a_read_cycle;

  //sd_clk_s1_waits_for_write in a cycle, which is an e_mux
  assign sd_clk_s1_waits_for_write = sd_clk_s1_in_a_write_cycle & 0;

  //sd_clk_s1_in_a_write_cycle assignment, which is an e_assign
  assign sd_clk_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_sd_clk_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sd_clk_s1_in_a_write_cycle;

  assign wait_for_sd_clk_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sd_clk/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_sd_clk_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave sd_clk/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sd_din_s1_arbitrator (
                              // inputs:
                               clk,
                               pipeline_bridge_0_m1_address_to_slave,
                               pipeline_bridge_0_m1_burstcount,
                               pipeline_bridge_0_m1_chipselect,
                               pipeline_bridge_0_m1_latency_counter,
                               pipeline_bridge_0_m1_read,
                               pipeline_bridge_0_m1_write,
                               pipeline_bridge_0_m1_writedata,
                               reset_n,
                               sd_din_s1_readdata,

                              // outputs:
                               d1_sd_din_s1_end_xfer,
                               pipeline_bridge_0_m1_granted_sd_din_s1,
                               pipeline_bridge_0_m1_qualified_request_sd_din_s1,
                               pipeline_bridge_0_m1_read_data_valid_sd_din_s1,
                               pipeline_bridge_0_m1_requests_sd_din_s1,
                               sd_din_s1_address,
                               sd_din_s1_chipselect,
                               sd_din_s1_readdata_from_sa,
                               sd_din_s1_reset_n,
                               sd_din_s1_write_n,
                               sd_din_s1_writedata
                            )
;

  output           d1_sd_din_s1_end_xfer;
  output           pipeline_bridge_0_m1_granted_sd_din_s1;
  output           pipeline_bridge_0_m1_qualified_request_sd_din_s1;
  output           pipeline_bridge_0_m1_read_data_valid_sd_din_s1;
  output           pipeline_bridge_0_m1_requests_sd_din_s1;
  output  [  1: 0] sd_din_s1_address;
  output           sd_din_s1_chipselect;
  output  [ 31: 0] sd_din_s1_readdata_from_sa;
  output           sd_din_s1_reset_n;
  output           sd_din_s1_write_n;
  output  [ 31: 0] sd_din_s1_writedata;
  input            clk;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input   [ 31: 0] pipeline_bridge_0_m1_writedata;
  input            reset_n;
  input   [ 31: 0] sd_din_s1_readdata;

  reg              d1_reasons_to_wait;
  reg              d1_sd_din_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sd_din_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_sd_din_s1;
  wire             pipeline_bridge_0_m1_qualified_request_sd_din_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_sd_din_s1;
  wire             pipeline_bridge_0_m1_requests_sd_din_s1;
  wire             pipeline_bridge_0_m1_saved_grant_sd_din_s1;
  wire    [  1: 0] sd_din_s1_address;
  wire             sd_din_s1_allgrants;
  wire             sd_din_s1_allow_new_arb_cycle;
  wire             sd_din_s1_any_bursting_master_saved_grant;
  wire             sd_din_s1_any_continuerequest;
  wire             sd_din_s1_arb_counter_enable;
  reg              sd_din_s1_arb_share_counter;
  wire             sd_din_s1_arb_share_counter_next_value;
  wire             sd_din_s1_arb_share_set_values;
  wire             sd_din_s1_beginbursttransfer_internal;
  wire             sd_din_s1_begins_xfer;
  wire             sd_din_s1_chipselect;
  wire             sd_din_s1_end_xfer;
  wire             sd_din_s1_firsttransfer;
  wire             sd_din_s1_grant_vector;
  wire             sd_din_s1_in_a_read_cycle;
  wire             sd_din_s1_in_a_write_cycle;
  wire             sd_din_s1_master_qreq_vector;
  wire             sd_din_s1_non_bursting_master_requests;
  wire    [ 31: 0] sd_din_s1_readdata_from_sa;
  reg              sd_din_s1_reg_firsttransfer;
  wire             sd_din_s1_reset_n;
  reg              sd_din_s1_slavearbiterlockenable;
  wire             sd_din_s1_slavearbiterlockenable2;
  wire             sd_din_s1_unreg_firsttransfer;
  wire             sd_din_s1_waits_for_read;
  wire             sd_din_s1_waits_for_write;
  wire             sd_din_s1_write_n;
  wire    [ 31: 0] sd_din_s1_writedata;
  wire    [  8: 0] shifted_address_to_sd_din_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_sd_din_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sd_din_s1_end_xfer;
    end


  assign sd_din_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_sd_din_s1));
  //assign sd_din_s1_readdata_from_sa = sd_din_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sd_din_s1_readdata_from_sa = sd_din_s1_readdata;

  assign pipeline_bridge_0_m1_requests_sd_din_s1 = ({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'hf0) & pipeline_bridge_0_m1_chipselect;
  //sd_din_s1_arb_share_counter set values, which is an e_mux
  assign sd_din_s1_arb_share_set_values = 1;

  //sd_din_s1_non_bursting_master_requests mux, which is an e_mux
  assign sd_din_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_sd_din_s1;

  //sd_din_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign sd_din_s1_any_bursting_master_saved_grant = 0;

  //sd_din_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sd_din_s1_arb_share_counter_next_value = sd_din_s1_firsttransfer ? (sd_din_s1_arb_share_set_values - 1) : |sd_din_s1_arb_share_counter ? (sd_din_s1_arb_share_counter - 1) : 0;

  //sd_din_s1_allgrants all slave grants, which is an e_mux
  assign sd_din_s1_allgrants = |sd_din_s1_grant_vector;

  //sd_din_s1_end_xfer assignment, which is an e_assign
  assign sd_din_s1_end_xfer = ~(sd_din_s1_waits_for_read | sd_din_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_sd_din_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sd_din_s1 = sd_din_s1_end_xfer & (~sd_din_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sd_din_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sd_din_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_sd_din_s1 & sd_din_s1_allgrants) | (end_xfer_arb_share_counter_term_sd_din_s1 & ~sd_din_s1_non_bursting_master_requests);

  //sd_din_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_din_s1_arb_share_counter <= 0;
      else if (sd_din_s1_arb_counter_enable)
          sd_din_s1_arb_share_counter <= sd_din_s1_arb_share_counter_next_value;
    end


  //sd_din_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_din_s1_slavearbiterlockenable <= 0;
      else if ((|sd_din_s1_master_qreq_vector & end_xfer_arb_share_counter_term_sd_din_s1) | (end_xfer_arb_share_counter_term_sd_din_s1 & ~sd_din_s1_non_bursting_master_requests))
          sd_din_s1_slavearbiterlockenable <= |sd_din_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 sd_din/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = sd_din_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //sd_din_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sd_din_s1_slavearbiterlockenable2 = |sd_din_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 sd_din/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = sd_din_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //sd_din_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sd_din_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_sd_din_s1 = pipeline_bridge_0_m1_requests_sd_din_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_sd_din_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_sd_din_s1 = pipeline_bridge_0_m1_granted_sd_din_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~sd_din_s1_waits_for_read;

  //sd_din_s1_writedata mux, which is an e_mux
  assign sd_din_s1_writedata = pipeline_bridge_0_m1_writedata;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_sd_din_s1 = pipeline_bridge_0_m1_qualified_request_sd_din_s1;

  //pipeline_bridge_0/m1 saved-grant sd_din/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_sd_din_s1 = pipeline_bridge_0_m1_requests_sd_din_s1;

  //allow new arb cycle for sd_din/s1, which is an e_assign
  assign sd_din_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sd_din_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sd_din_s1_master_qreq_vector = 1;

  //sd_din_s1_reset_n assignment, which is an e_assign
  assign sd_din_s1_reset_n = reset_n;

  assign sd_din_s1_chipselect = pipeline_bridge_0_m1_granted_sd_din_s1;
  //sd_din_s1_firsttransfer first transaction, which is an e_assign
  assign sd_din_s1_firsttransfer = sd_din_s1_begins_xfer ? sd_din_s1_unreg_firsttransfer : sd_din_s1_reg_firsttransfer;

  //sd_din_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign sd_din_s1_unreg_firsttransfer = ~(sd_din_s1_slavearbiterlockenable & sd_din_s1_any_continuerequest);

  //sd_din_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_din_s1_reg_firsttransfer <= 1'b1;
      else if (sd_din_s1_begins_xfer)
          sd_din_s1_reg_firsttransfer <= sd_din_s1_unreg_firsttransfer;
    end


  //sd_din_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sd_din_s1_beginbursttransfer_internal = sd_din_s1_begins_xfer;

  //~sd_din_s1_write_n assignment, which is an e_mux
  assign sd_din_s1_write_n = ~(pipeline_bridge_0_m1_granted_sd_din_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect));

  assign shifted_address_to_sd_din_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //sd_din_s1_address mux, which is an e_mux
  assign sd_din_s1_address = shifted_address_to_sd_din_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_sd_din_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sd_din_s1_end_xfer <= 1;
      else 
        d1_sd_din_s1_end_xfer <= sd_din_s1_end_xfer;
    end


  //sd_din_s1_waits_for_read in a cycle, which is an e_mux
  assign sd_din_s1_waits_for_read = sd_din_s1_in_a_read_cycle & sd_din_s1_begins_xfer;

  //sd_din_s1_in_a_read_cycle assignment, which is an e_assign
  assign sd_din_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_sd_din_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sd_din_s1_in_a_read_cycle;

  //sd_din_s1_waits_for_write in a cycle, which is an e_mux
  assign sd_din_s1_waits_for_write = sd_din_s1_in_a_write_cycle & 0;

  //sd_din_s1_in_a_write_cycle assignment, which is an e_assign
  assign sd_din_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_sd_din_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sd_din_s1_in_a_write_cycle;

  assign wait_for_sd_din_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sd_din/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_sd_din_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave sd_din/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sd_dout_s1_arbitrator (
                               // inputs:
                                clk,
                                pipeline_bridge_0_m1_address_to_slave,
                                pipeline_bridge_0_m1_burstcount,
                                pipeline_bridge_0_m1_chipselect,
                                pipeline_bridge_0_m1_latency_counter,
                                pipeline_bridge_0_m1_read,
                                pipeline_bridge_0_m1_write,
                                reset_n,
                                sd_dout_s1_readdata,

                               // outputs:
                                d1_sd_dout_s1_end_xfer,
                                pipeline_bridge_0_m1_granted_sd_dout_s1,
                                pipeline_bridge_0_m1_qualified_request_sd_dout_s1,
                                pipeline_bridge_0_m1_read_data_valid_sd_dout_s1,
                                pipeline_bridge_0_m1_requests_sd_dout_s1,
                                sd_dout_s1_address,
                                sd_dout_s1_readdata_from_sa,
                                sd_dout_s1_reset_n
                             )
;

  output           d1_sd_dout_s1_end_xfer;
  output           pipeline_bridge_0_m1_granted_sd_dout_s1;
  output           pipeline_bridge_0_m1_qualified_request_sd_dout_s1;
  output           pipeline_bridge_0_m1_read_data_valid_sd_dout_s1;
  output           pipeline_bridge_0_m1_requests_sd_dout_s1;
  output  [  1: 0] sd_dout_s1_address;
  output  [ 31: 0] sd_dout_s1_readdata_from_sa;
  output           sd_dout_s1_reset_n;
  input            clk;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input            reset_n;
  input   [ 31: 0] sd_dout_s1_readdata;

  reg              d1_reasons_to_wait;
  reg              d1_sd_dout_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sd_dout_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_sd_dout_s1;
  wire             pipeline_bridge_0_m1_qualified_request_sd_dout_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_sd_dout_s1;
  wire             pipeline_bridge_0_m1_requests_sd_dout_s1;
  wire             pipeline_bridge_0_m1_saved_grant_sd_dout_s1;
  wire    [  1: 0] sd_dout_s1_address;
  wire             sd_dout_s1_allgrants;
  wire             sd_dout_s1_allow_new_arb_cycle;
  wire             sd_dout_s1_any_bursting_master_saved_grant;
  wire             sd_dout_s1_any_continuerequest;
  wire             sd_dout_s1_arb_counter_enable;
  reg              sd_dout_s1_arb_share_counter;
  wire             sd_dout_s1_arb_share_counter_next_value;
  wire             sd_dout_s1_arb_share_set_values;
  wire             sd_dout_s1_beginbursttransfer_internal;
  wire             sd_dout_s1_begins_xfer;
  wire             sd_dout_s1_end_xfer;
  wire             sd_dout_s1_firsttransfer;
  wire             sd_dout_s1_grant_vector;
  wire             sd_dout_s1_in_a_read_cycle;
  wire             sd_dout_s1_in_a_write_cycle;
  wire             sd_dout_s1_master_qreq_vector;
  wire             sd_dout_s1_non_bursting_master_requests;
  wire    [ 31: 0] sd_dout_s1_readdata_from_sa;
  reg              sd_dout_s1_reg_firsttransfer;
  wire             sd_dout_s1_reset_n;
  reg              sd_dout_s1_slavearbiterlockenable;
  wire             sd_dout_s1_slavearbiterlockenable2;
  wire             sd_dout_s1_unreg_firsttransfer;
  wire             sd_dout_s1_waits_for_read;
  wire             sd_dout_s1_waits_for_write;
  wire    [  8: 0] shifted_address_to_sd_dout_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_sd_dout_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sd_dout_s1_end_xfer;
    end


  assign sd_dout_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_sd_dout_s1));
  //assign sd_dout_s1_readdata_from_sa = sd_dout_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sd_dout_s1_readdata_from_sa = sd_dout_s1_readdata;

  assign pipeline_bridge_0_m1_requests_sd_dout_s1 = (({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'h100) & pipeline_bridge_0_m1_chipselect) & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);
  //sd_dout_s1_arb_share_counter set values, which is an e_mux
  assign sd_dout_s1_arb_share_set_values = 1;

  //sd_dout_s1_non_bursting_master_requests mux, which is an e_mux
  assign sd_dout_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_sd_dout_s1;

  //sd_dout_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign sd_dout_s1_any_bursting_master_saved_grant = 0;

  //sd_dout_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sd_dout_s1_arb_share_counter_next_value = sd_dout_s1_firsttransfer ? (sd_dout_s1_arb_share_set_values - 1) : |sd_dout_s1_arb_share_counter ? (sd_dout_s1_arb_share_counter - 1) : 0;

  //sd_dout_s1_allgrants all slave grants, which is an e_mux
  assign sd_dout_s1_allgrants = |sd_dout_s1_grant_vector;

  //sd_dout_s1_end_xfer assignment, which is an e_assign
  assign sd_dout_s1_end_xfer = ~(sd_dout_s1_waits_for_read | sd_dout_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_sd_dout_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sd_dout_s1 = sd_dout_s1_end_xfer & (~sd_dout_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sd_dout_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sd_dout_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_sd_dout_s1 & sd_dout_s1_allgrants) | (end_xfer_arb_share_counter_term_sd_dout_s1 & ~sd_dout_s1_non_bursting_master_requests);

  //sd_dout_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_dout_s1_arb_share_counter <= 0;
      else if (sd_dout_s1_arb_counter_enable)
          sd_dout_s1_arb_share_counter <= sd_dout_s1_arb_share_counter_next_value;
    end


  //sd_dout_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_dout_s1_slavearbiterlockenable <= 0;
      else if ((|sd_dout_s1_master_qreq_vector & end_xfer_arb_share_counter_term_sd_dout_s1) | (end_xfer_arb_share_counter_term_sd_dout_s1 & ~sd_dout_s1_non_bursting_master_requests))
          sd_dout_s1_slavearbiterlockenable <= |sd_dout_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 sd_dout/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = sd_dout_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //sd_dout_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sd_dout_s1_slavearbiterlockenable2 = |sd_dout_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 sd_dout/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = sd_dout_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //sd_dout_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sd_dout_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_sd_dout_s1 = pipeline_bridge_0_m1_requests_sd_dout_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_sd_dout_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_sd_dout_s1 = pipeline_bridge_0_m1_granted_sd_dout_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~sd_dout_s1_waits_for_read;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_sd_dout_s1 = pipeline_bridge_0_m1_qualified_request_sd_dout_s1;

  //pipeline_bridge_0/m1 saved-grant sd_dout/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_sd_dout_s1 = pipeline_bridge_0_m1_requests_sd_dout_s1;

  //allow new arb cycle for sd_dout/s1, which is an e_assign
  assign sd_dout_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sd_dout_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sd_dout_s1_master_qreq_vector = 1;

  //sd_dout_s1_reset_n assignment, which is an e_assign
  assign sd_dout_s1_reset_n = reset_n;

  //sd_dout_s1_firsttransfer first transaction, which is an e_assign
  assign sd_dout_s1_firsttransfer = sd_dout_s1_begins_xfer ? sd_dout_s1_unreg_firsttransfer : sd_dout_s1_reg_firsttransfer;

  //sd_dout_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign sd_dout_s1_unreg_firsttransfer = ~(sd_dout_s1_slavearbiterlockenable & sd_dout_s1_any_continuerequest);

  //sd_dout_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_dout_s1_reg_firsttransfer <= 1'b1;
      else if (sd_dout_s1_begins_xfer)
          sd_dout_s1_reg_firsttransfer <= sd_dout_s1_unreg_firsttransfer;
    end


  //sd_dout_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sd_dout_s1_beginbursttransfer_internal = sd_dout_s1_begins_xfer;

  assign shifted_address_to_sd_dout_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //sd_dout_s1_address mux, which is an e_mux
  assign sd_dout_s1_address = shifted_address_to_sd_dout_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_sd_dout_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sd_dout_s1_end_xfer <= 1;
      else 
        d1_sd_dout_s1_end_xfer <= sd_dout_s1_end_xfer;
    end


  //sd_dout_s1_waits_for_read in a cycle, which is an e_mux
  assign sd_dout_s1_waits_for_read = sd_dout_s1_in_a_read_cycle & sd_dout_s1_begins_xfer;

  //sd_dout_s1_in_a_read_cycle assignment, which is an e_assign
  assign sd_dout_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_sd_dout_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sd_dout_s1_in_a_read_cycle;

  //sd_dout_s1_waits_for_write in a cycle, which is an e_mux
  assign sd_dout_s1_waits_for_write = sd_dout_s1_in_a_write_cycle & 0;

  //sd_dout_s1_in_a_write_cycle assignment, which is an e_assign
  assign sd_dout_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_sd_dout_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sd_dout_s1_in_a_write_cycle;

  assign wait_for_sd_dout_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sd_dout/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_sd_dout_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave sd_dout/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sd_ncs_s1_arbitrator (
                              // inputs:
                               clk,
                               pipeline_bridge_0_m1_address_to_slave,
                               pipeline_bridge_0_m1_burstcount,
                               pipeline_bridge_0_m1_chipselect,
                               pipeline_bridge_0_m1_latency_counter,
                               pipeline_bridge_0_m1_read,
                               pipeline_bridge_0_m1_write,
                               pipeline_bridge_0_m1_writedata,
                               reset_n,
                               sd_ncs_s1_readdata,

                              // outputs:
                               d1_sd_ncs_s1_end_xfer,
                               pipeline_bridge_0_m1_granted_sd_ncs_s1,
                               pipeline_bridge_0_m1_qualified_request_sd_ncs_s1,
                               pipeline_bridge_0_m1_read_data_valid_sd_ncs_s1,
                               pipeline_bridge_0_m1_requests_sd_ncs_s1,
                               sd_ncs_s1_address,
                               sd_ncs_s1_chipselect,
                               sd_ncs_s1_readdata_from_sa,
                               sd_ncs_s1_reset_n,
                               sd_ncs_s1_write_n,
                               sd_ncs_s1_writedata
                            )
;

  output           d1_sd_ncs_s1_end_xfer;
  output           pipeline_bridge_0_m1_granted_sd_ncs_s1;
  output           pipeline_bridge_0_m1_qualified_request_sd_ncs_s1;
  output           pipeline_bridge_0_m1_read_data_valid_sd_ncs_s1;
  output           pipeline_bridge_0_m1_requests_sd_ncs_s1;
  output  [  1: 0] sd_ncs_s1_address;
  output           sd_ncs_s1_chipselect;
  output  [ 31: 0] sd_ncs_s1_readdata_from_sa;
  output           sd_ncs_s1_reset_n;
  output           sd_ncs_s1_write_n;
  output  [ 31: 0] sd_ncs_s1_writedata;
  input            clk;
  input   [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  input            pipeline_bridge_0_m1_burstcount;
  input            pipeline_bridge_0_m1_chipselect;
  input            pipeline_bridge_0_m1_latency_counter;
  input            pipeline_bridge_0_m1_read;
  input            pipeline_bridge_0_m1_write;
  input   [ 31: 0] pipeline_bridge_0_m1_writedata;
  input            reset_n;
  input   [ 31: 0] sd_ncs_s1_readdata;

  reg              d1_reasons_to_wait;
  reg              d1_sd_ncs_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sd_ncs_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             pipeline_bridge_0_m1_arbiterlock;
  wire             pipeline_bridge_0_m1_arbiterlock2;
  wire             pipeline_bridge_0_m1_continuerequest;
  wire             pipeline_bridge_0_m1_granted_sd_ncs_s1;
  wire             pipeline_bridge_0_m1_qualified_request_sd_ncs_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_sd_ncs_s1;
  wire             pipeline_bridge_0_m1_requests_sd_ncs_s1;
  wire             pipeline_bridge_0_m1_saved_grant_sd_ncs_s1;
  wire    [  1: 0] sd_ncs_s1_address;
  wire             sd_ncs_s1_allgrants;
  wire             sd_ncs_s1_allow_new_arb_cycle;
  wire             sd_ncs_s1_any_bursting_master_saved_grant;
  wire             sd_ncs_s1_any_continuerequest;
  wire             sd_ncs_s1_arb_counter_enable;
  reg              sd_ncs_s1_arb_share_counter;
  wire             sd_ncs_s1_arb_share_counter_next_value;
  wire             sd_ncs_s1_arb_share_set_values;
  wire             sd_ncs_s1_beginbursttransfer_internal;
  wire             sd_ncs_s1_begins_xfer;
  wire             sd_ncs_s1_chipselect;
  wire             sd_ncs_s1_end_xfer;
  wire             sd_ncs_s1_firsttransfer;
  wire             sd_ncs_s1_grant_vector;
  wire             sd_ncs_s1_in_a_read_cycle;
  wire             sd_ncs_s1_in_a_write_cycle;
  wire             sd_ncs_s1_master_qreq_vector;
  wire             sd_ncs_s1_non_bursting_master_requests;
  wire    [ 31: 0] sd_ncs_s1_readdata_from_sa;
  reg              sd_ncs_s1_reg_firsttransfer;
  wire             sd_ncs_s1_reset_n;
  reg              sd_ncs_s1_slavearbiterlockenable;
  wire             sd_ncs_s1_slavearbiterlockenable2;
  wire             sd_ncs_s1_unreg_firsttransfer;
  wire             sd_ncs_s1_waits_for_read;
  wire             sd_ncs_s1_waits_for_write;
  wire             sd_ncs_s1_write_n;
  wire    [ 31: 0] sd_ncs_s1_writedata;
  wire    [  8: 0] shifted_address_to_sd_ncs_s1_from_pipeline_bridge_0_m1;
  wire             wait_for_sd_ncs_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sd_ncs_s1_end_xfer;
    end


  assign sd_ncs_s1_begins_xfer = ~d1_reasons_to_wait & ((pipeline_bridge_0_m1_qualified_request_sd_ncs_s1));
  //assign sd_ncs_s1_readdata_from_sa = sd_ncs_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sd_ncs_s1_readdata_from_sa = sd_ncs_s1_readdata;

  assign pipeline_bridge_0_m1_requests_sd_ncs_s1 = ({pipeline_bridge_0_m1_address_to_slave[8 : 4] , 4'b0} == 9'hd0) & pipeline_bridge_0_m1_chipselect;
  //sd_ncs_s1_arb_share_counter set values, which is an e_mux
  assign sd_ncs_s1_arb_share_set_values = 1;

  //sd_ncs_s1_non_bursting_master_requests mux, which is an e_mux
  assign sd_ncs_s1_non_bursting_master_requests = pipeline_bridge_0_m1_requests_sd_ncs_s1;

  //sd_ncs_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign sd_ncs_s1_any_bursting_master_saved_grant = 0;

  //sd_ncs_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sd_ncs_s1_arb_share_counter_next_value = sd_ncs_s1_firsttransfer ? (sd_ncs_s1_arb_share_set_values - 1) : |sd_ncs_s1_arb_share_counter ? (sd_ncs_s1_arb_share_counter - 1) : 0;

  //sd_ncs_s1_allgrants all slave grants, which is an e_mux
  assign sd_ncs_s1_allgrants = |sd_ncs_s1_grant_vector;

  //sd_ncs_s1_end_xfer assignment, which is an e_assign
  assign sd_ncs_s1_end_xfer = ~(sd_ncs_s1_waits_for_read | sd_ncs_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_sd_ncs_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sd_ncs_s1 = sd_ncs_s1_end_xfer & (~sd_ncs_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sd_ncs_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sd_ncs_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_sd_ncs_s1 & sd_ncs_s1_allgrants) | (end_xfer_arb_share_counter_term_sd_ncs_s1 & ~sd_ncs_s1_non_bursting_master_requests);

  //sd_ncs_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_ncs_s1_arb_share_counter <= 0;
      else if (sd_ncs_s1_arb_counter_enable)
          sd_ncs_s1_arb_share_counter <= sd_ncs_s1_arb_share_counter_next_value;
    end


  //sd_ncs_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_ncs_s1_slavearbiterlockenable <= 0;
      else if ((|sd_ncs_s1_master_qreq_vector & end_xfer_arb_share_counter_term_sd_ncs_s1) | (end_xfer_arb_share_counter_term_sd_ncs_s1 & ~sd_ncs_s1_non_bursting_master_requests))
          sd_ncs_s1_slavearbiterlockenable <= |sd_ncs_s1_arb_share_counter_next_value;
    end


  //pipeline_bridge_0/m1 sd_ncs/s1 arbiterlock, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock = sd_ncs_s1_slavearbiterlockenable & pipeline_bridge_0_m1_continuerequest;

  //sd_ncs_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sd_ncs_s1_slavearbiterlockenable2 = |sd_ncs_s1_arb_share_counter_next_value;

  //pipeline_bridge_0/m1 sd_ncs/s1 arbiterlock2, which is an e_assign
  assign pipeline_bridge_0_m1_arbiterlock2 = sd_ncs_s1_slavearbiterlockenable2 & pipeline_bridge_0_m1_continuerequest;

  //sd_ncs_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sd_ncs_s1_any_continuerequest = 1;

  //pipeline_bridge_0_m1_continuerequest continued request, which is an e_assign
  assign pipeline_bridge_0_m1_continuerequest = 1;

  assign pipeline_bridge_0_m1_qualified_request_sd_ncs_s1 = pipeline_bridge_0_m1_requests_sd_ncs_s1 & ~(((pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ((pipeline_bridge_0_m1_latency_counter != 0))));
  //local readdatavalid pipeline_bridge_0_m1_read_data_valid_sd_ncs_s1, which is an e_mux
  assign pipeline_bridge_0_m1_read_data_valid_sd_ncs_s1 = pipeline_bridge_0_m1_granted_sd_ncs_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect) & ~sd_ncs_s1_waits_for_read;

  //sd_ncs_s1_writedata mux, which is an e_mux
  assign sd_ncs_s1_writedata = pipeline_bridge_0_m1_writedata;

  //master is always granted when requested
  assign pipeline_bridge_0_m1_granted_sd_ncs_s1 = pipeline_bridge_0_m1_qualified_request_sd_ncs_s1;

  //pipeline_bridge_0/m1 saved-grant sd_ncs/s1, which is an e_assign
  assign pipeline_bridge_0_m1_saved_grant_sd_ncs_s1 = pipeline_bridge_0_m1_requests_sd_ncs_s1;

  //allow new arb cycle for sd_ncs/s1, which is an e_assign
  assign sd_ncs_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sd_ncs_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sd_ncs_s1_master_qreq_vector = 1;

  //sd_ncs_s1_reset_n assignment, which is an e_assign
  assign sd_ncs_s1_reset_n = reset_n;

  assign sd_ncs_s1_chipselect = pipeline_bridge_0_m1_granted_sd_ncs_s1;
  //sd_ncs_s1_firsttransfer first transaction, which is an e_assign
  assign sd_ncs_s1_firsttransfer = sd_ncs_s1_begins_xfer ? sd_ncs_s1_unreg_firsttransfer : sd_ncs_s1_reg_firsttransfer;

  //sd_ncs_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign sd_ncs_s1_unreg_firsttransfer = ~(sd_ncs_s1_slavearbiterlockenable & sd_ncs_s1_any_continuerequest);

  //sd_ncs_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sd_ncs_s1_reg_firsttransfer <= 1'b1;
      else if (sd_ncs_s1_begins_xfer)
          sd_ncs_s1_reg_firsttransfer <= sd_ncs_s1_unreg_firsttransfer;
    end


  //sd_ncs_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sd_ncs_s1_beginbursttransfer_internal = sd_ncs_s1_begins_xfer;

  //~sd_ncs_s1_write_n assignment, which is an e_mux
  assign sd_ncs_s1_write_n = ~(pipeline_bridge_0_m1_granted_sd_ncs_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect));

  assign shifted_address_to_sd_ncs_s1_from_pipeline_bridge_0_m1 = pipeline_bridge_0_m1_address_to_slave;
  //sd_ncs_s1_address mux, which is an e_mux
  assign sd_ncs_s1_address = shifted_address_to_sd_ncs_s1_from_pipeline_bridge_0_m1 >> 2;

  //d1_sd_ncs_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sd_ncs_s1_end_xfer <= 1;
      else 
        d1_sd_ncs_s1_end_xfer <= sd_ncs_s1_end_xfer;
    end


  //sd_ncs_s1_waits_for_read in a cycle, which is an e_mux
  assign sd_ncs_s1_waits_for_read = sd_ncs_s1_in_a_read_cycle & sd_ncs_s1_begins_xfer;

  //sd_ncs_s1_in_a_read_cycle assignment, which is an e_assign
  assign sd_ncs_s1_in_a_read_cycle = pipeline_bridge_0_m1_granted_sd_ncs_s1 & (pipeline_bridge_0_m1_read & pipeline_bridge_0_m1_chipselect);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sd_ncs_s1_in_a_read_cycle;

  //sd_ncs_s1_waits_for_write in a cycle, which is an e_mux
  assign sd_ncs_s1_waits_for_write = sd_ncs_s1_in_a_write_cycle & 0;

  //sd_ncs_s1_in_a_write_cycle assignment, which is an e_assign
  assign sd_ncs_s1_in_a_write_cycle = pipeline_bridge_0_m1_granted_sd_ncs_s1 & (pipeline_bridge_0_m1_write & pipeline_bridge_0_m1_chipselect);

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sd_ncs_s1_in_a_write_cycle;

  assign wait_for_sd_ncs_s1_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sd_ncs/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //pipeline_bridge_0/m1 non-zero burstcount assertion, which is an e_process
  always @(posedge clk)
    begin
      if (pipeline_bridge_0_m1_requests_sd_ncs_s1 && (pipeline_bridge_0_m1_burstcount == 0) && enable_nonzero_assertions)
        begin
          $write("%0d ns: pipeline_bridge_0/m1 drove 0 on its 'burstcount' port while accessing slave sd_ncs/s1", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_nios_f_data_master_to_sdram_s1_module (
                                                            // inputs:
                                                             clear_fifo,
                                                             clk,
                                                             data_in,
                                                             read,
                                                             reset_n,
                                                             sync_reset,
                                                             write,

                                                            // outputs:
                                                             data_out,
                                                             empty,
                                                             fifo_contains_ones_n,
                                                             full
                                                          )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  wire             full_6;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_5;
  assign empty = !full_0;
  assign full_6 = 0;
  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    0;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module rdv_fifo_for_nios_f_instruction_master_to_sdram_s1_module (
                                                                   // inputs:
                                                                    clear_fifo,
                                                                    clk,
                                                                    data_in,
                                                                    read,
                                                                    reset_n,
                                                                    sync_reset,
                                                                    write,

                                                                   // outputs:
                                                                    data_out,
                                                                    empty,
                                                                    fifo_contains_ones_n,
                                                                    full
                                                                 )
;

  output           data_out;
  output           empty;
  output           fifo_contains_ones_n;
  output           full;
  input            clear_fifo;
  input            clk;
  input            data_in;
  input            read;
  input            reset_n;
  input            sync_reset;
  input            write;

  wire             data_out;
  wire             empty;
  reg              fifo_contains_ones_n;
  wire             full;
  reg              full_0;
  reg              full_1;
  reg              full_2;
  reg              full_3;
  reg              full_4;
  reg              full_5;
  wire             full_6;
  reg     [  3: 0] how_many_ones;
  wire    [  3: 0] one_count_minus_one;
  wire    [  3: 0] one_count_plus_one;
  wire             p0_full_0;
  wire             p0_stage_0;
  wire             p1_full_1;
  wire             p1_stage_1;
  wire             p2_full_2;
  wire             p2_stage_2;
  wire             p3_full_3;
  wire             p3_stage_3;
  wire             p4_full_4;
  wire             p4_stage_4;
  wire             p5_full_5;
  wire             p5_stage_5;
  reg              stage_0;
  reg              stage_1;
  reg              stage_2;
  reg              stage_3;
  reg              stage_4;
  reg              stage_5;
  wire    [  3: 0] updated_one_count;
  assign data_out = stage_0;
  assign full = full_5;
  assign empty = !full_0;
  assign full_6 = 0;
  //data_5, which is an e_mux
  assign p5_stage_5 = ((full_6 & ~clear_fifo) == 0)? data_in :
    data_in;

  //data_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_5 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_5))
          if (sync_reset & full_5 & !((full_6 == 0) & read & write))
              stage_5 <= 0;
          else 
            stage_5 <= p5_stage_5;
    end


  //control_5, which is an e_mux
  assign p5_full_5 = ((read & !write) == 0)? full_4 :
    0;

  //control_reg_5, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_5 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_5 <= 0;
          else 
            full_5 <= p5_full_5;
    end


  //data_4, which is an e_mux
  assign p4_stage_4 = ((full_5 & ~clear_fifo) == 0)? data_in :
    stage_5;

  //data_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_4 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_4))
          if (sync_reset & full_4 & !((full_5 == 0) & read & write))
              stage_4 <= 0;
          else 
            stage_4 <= p4_stage_4;
    end


  //control_4, which is an e_mux
  assign p4_full_4 = ((read & !write) == 0)? full_3 :
    full_5;

  //control_reg_4, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_4 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_4 <= 0;
          else 
            full_4 <= p4_full_4;
    end


  //data_3, which is an e_mux
  assign p3_stage_3 = ((full_4 & ~clear_fifo) == 0)? data_in :
    stage_4;

  //data_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_3 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_3))
          if (sync_reset & full_3 & !((full_4 == 0) & read & write))
              stage_3 <= 0;
          else 
            stage_3 <= p3_stage_3;
    end


  //control_3, which is an e_mux
  assign p3_full_3 = ((read & !write) == 0)? full_2 :
    full_4;

  //control_reg_3, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_3 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_3 <= 0;
          else 
            full_3 <= p3_full_3;
    end


  //data_2, which is an e_mux
  assign p2_stage_2 = ((full_3 & ~clear_fifo) == 0)? data_in :
    stage_3;

  //data_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_2 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_2))
          if (sync_reset & full_2 & !((full_3 == 0) & read & write))
              stage_2 <= 0;
          else 
            stage_2 <= p2_stage_2;
    end


  //control_2, which is an e_mux
  assign p2_full_2 = ((read & !write) == 0)? full_1 :
    full_3;

  //control_reg_2, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_2 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_2 <= 0;
          else 
            full_2 <= p2_full_2;
    end


  //data_1, which is an e_mux
  assign p1_stage_1 = ((full_2 & ~clear_fifo) == 0)? data_in :
    stage_2;

  //data_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_1 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_1))
          if (sync_reset & full_1 & !((full_2 == 0) & read & write))
              stage_1 <= 0;
          else 
            stage_1 <= p1_stage_1;
    end


  //control_1, which is an e_mux
  assign p1_full_1 = ((read & !write) == 0)? full_0 :
    full_2;

  //control_reg_1, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_1 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo)
              full_1 <= 0;
          else 
            full_1 <= p1_full_1;
    end


  //data_0, which is an e_mux
  assign p0_stage_0 = ((full_1 & ~clear_fifo) == 0)? data_in :
    stage_1;

  //data_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          stage_0 <= 0;
      else if (clear_fifo | sync_reset | read | (write & !full_0))
          if (sync_reset & full_0 & !((full_1 == 0) & read & write))
              stage_0 <= 0;
          else 
            stage_0 <= p0_stage_0;
    end


  //control_0, which is an e_mux
  assign p0_full_0 = ((read & !write) == 0)? 1 :
    full_1;

  //control_reg_0, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          full_0 <= 0;
      else if (clear_fifo | (read ^ write) | (write & !full_0))
          if (clear_fifo & ~write)
              full_0 <= 0;
          else 
            full_0 <= p0_full_0;
    end


  assign one_count_plus_one = how_many_ones + 1;
  assign one_count_minus_one = how_many_ones - 1;
  //updated_one_count, which is an e_mux
  assign updated_one_count = ((((clear_fifo | sync_reset) & !write)))? 0 :
    ((((clear_fifo | sync_reset) & write)))? |data_in :
    ((read & (|data_in) & write & (|stage_0)))? how_many_ones :
    ((write & (|data_in)))? one_count_plus_one :
    ((read & (|stage_0)))? one_count_minus_one :
    how_many_ones;

  //counts how many ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          how_many_ones <= 0;
      else if (clear_fifo | sync_reset | read | write)
          how_many_ones <= updated_one_count;
    end


  //this fifo contains ones in the data pipeline, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          fifo_contains_ones_n <= 1;
      else if (clear_fifo | sync_reset | read | write)
          fifo_contains_ones_n <= ~(|updated_one_count);
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sdram_s1_arbitrator (
                             // inputs:
                              clk,
                              nios_f_data_master_address_to_slave,
                              nios_f_data_master_byteenable,
                              nios_f_data_master_dbs_address,
                              nios_f_data_master_dbs_write_16,
                              nios_f_data_master_no_byte_enables_and_last_term,
                              nios_f_data_master_read,
                              nios_f_data_master_waitrequest,
                              nios_f_data_master_write,
                              nios_f_instruction_master_address_to_slave,
                              nios_f_instruction_master_dbs_address,
                              nios_f_instruction_master_latency_counter,
                              nios_f_instruction_master_read,
                              nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register,
                              reset_n,
                              sdram_s1_readdata,
                              sdram_s1_readdatavalid,
                              sdram_s1_waitrequest,

                             // outputs:
                              d1_sdram_s1_end_xfer,
                              nios_f_data_master_byteenable_sdram_s1,
                              nios_f_data_master_granted_sdram_s1,
                              nios_f_data_master_qualified_request_sdram_s1,
                              nios_f_data_master_read_data_valid_sdram_s1,
                              nios_f_data_master_read_data_valid_sdram_s1_shift_register,
                              nios_f_data_master_requests_sdram_s1,
                              nios_f_instruction_master_granted_sdram_s1,
                              nios_f_instruction_master_qualified_request_sdram_s1,
                              nios_f_instruction_master_read_data_valid_sdram_s1,
                              nios_f_instruction_master_read_data_valid_sdram_s1_shift_register,
                              nios_f_instruction_master_requests_sdram_s1,
                              sdram_s1_address,
                              sdram_s1_byteenable_n,
                              sdram_s1_chipselect,
                              sdram_s1_read_n,
                              sdram_s1_readdata_from_sa,
                              sdram_s1_reset_n,
                              sdram_s1_waitrequest_from_sa,
                              sdram_s1_write_n,
                              sdram_s1_writedata
                           )
;

  output           d1_sdram_s1_end_xfer;
  output  [  1: 0] nios_f_data_master_byteenable_sdram_s1;
  output           nios_f_data_master_granted_sdram_s1;
  output           nios_f_data_master_qualified_request_sdram_s1;
  output           nios_f_data_master_read_data_valid_sdram_s1;
  output           nios_f_data_master_read_data_valid_sdram_s1_shift_register;
  output           nios_f_data_master_requests_sdram_s1;
  output           nios_f_instruction_master_granted_sdram_s1;
  output           nios_f_instruction_master_qualified_request_sdram_s1;
  output           nios_f_instruction_master_read_data_valid_sdram_s1;
  output           nios_f_instruction_master_read_data_valid_sdram_s1_shift_register;
  output           nios_f_instruction_master_requests_sdram_s1;
  output  [ 21: 0] sdram_s1_address;
  output  [  1: 0] sdram_s1_byteenable_n;
  output           sdram_s1_chipselect;
  output           sdram_s1_read_n;
  output  [ 15: 0] sdram_s1_readdata_from_sa;
  output           sdram_s1_reset_n;
  output           sdram_s1_waitrequest_from_sa;
  output           sdram_s1_write_n;
  output  [ 15: 0] sdram_s1_writedata;
  input            clk;
  input   [ 25: 0] nios_f_data_master_address_to_slave;
  input   [  3: 0] nios_f_data_master_byteenable;
  input   [  1: 0] nios_f_data_master_dbs_address;
  input   [ 15: 0] nios_f_data_master_dbs_write_16;
  input            nios_f_data_master_no_byte_enables_and_last_term;
  input            nios_f_data_master_read;
  input            nios_f_data_master_waitrequest;
  input            nios_f_data_master_write;
  input   [ 25: 0] nios_f_instruction_master_address_to_slave;
  input   [  1: 0] nios_f_instruction_master_dbs_address;
  input            nios_f_instruction_master_latency_counter;
  input            nios_f_instruction_master_read;
  input            nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register;
  input            reset_n;
  input   [ 15: 0] sdram_s1_readdata;
  input            sdram_s1_readdatavalid;
  input            sdram_s1_waitrequest;

  reg              d1_reasons_to_wait;
  reg              d1_sdram_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sdram_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  reg              last_cycle_nios_f_data_master_granted_slave_sdram_s1;
  reg              last_cycle_nios_f_instruction_master_granted_slave_sdram_s1;
  wire             nios_f_data_master_arbiterlock;
  wire             nios_f_data_master_arbiterlock2;
  wire    [  1: 0] nios_f_data_master_byteenable_sdram_s1;
  wire    [  1: 0] nios_f_data_master_byteenable_sdram_s1_segment_0;
  wire    [  1: 0] nios_f_data_master_byteenable_sdram_s1_segment_1;
  wire             nios_f_data_master_continuerequest;
  wire             nios_f_data_master_granted_sdram_s1;
  wire             nios_f_data_master_qualified_request_sdram_s1;
  wire             nios_f_data_master_rdv_fifo_empty_sdram_s1;
  wire             nios_f_data_master_rdv_fifo_output_from_sdram_s1;
  wire             nios_f_data_master_read_data_valid_sdram_s1;
  wire             nios_f_data_master_read_data_valid_sdram_s1_shift_register;
  wire             nios_f_data_master_requests_sdram_s1;
  wire             nios_f_data_master_saved_grant_sdram_s1;
  wire             nios_f_instruction_master_arbiterlock;
  wire             nios_f_instruction_master_arbiterlock2;
  wire             nios_f_instruction_master_continuerequest;
  wire             nios_f_instruction_master_granted_sdram_s1;
  wire             nios_f_instruction_master_qualified_request_sdram_s1;
  wire             nios_f_instruction_master_rdv_fifo_empty_sdram_s1;
  wire             nios_f_instruction_master_rdv_fifo_output_from_sdram_s1;
  wire             nios_f_instruction_master_read_data_valid_sdram_s1;
  wire             nios_f_instruction_master_read_data_valid_sdram_s1_shift_register;
  wire             nios_f_instruction_master_requests_sdram_s1;
  wire             nios_f_instruction_master_saved_grant_sdram_s1;
  wire    [ 21: 0] sdram_s1_address;
  wire             sdram_s1_allgrants;
  wire             sdram_s1_allow_new_arb_cycle;
  wire             sdram_s1_any_bursting_master_saved_grant;
  wire             sdram_s1_any_continuerequest;
  reg     [  1: 0] sdram_s1_arb_addend;
  wire             sdram_s1_arb_counter_enable;
  reg     [  1: 0] sdram_s1_arb_share_counter;
  wire    [  1: 0] sdram_s1_arb_share_counter_next_value;
  wire    [  1: 0] sdram_s1_arb_share_set_values;
  wire    [  1: 0] sdram_s1_arb_winner;
  wire             sdram_s1_arbitration_holdoff_internal;
  wire             sdram_s1_beginbursttransfer_internal;
  wire             sdram_s1_begins_xfer;
  wire    [  1: 0] sdram_s1_byteenable_n;
  wire             sdram_s1_chipselect;
  wire    [  3: 0] sdram_s1_chosen_master_double_vector;
  wire    [  1: 0] sdram_s1_chosen_master_rot_left;
  wire             sdram_s1_end_xfer;
  wire             sdram_s1_firsttransfer;
  wire    [  1: 0] sdram_s1_grant_vector;
  wire             sdram_s1_in_a_read_cycle;
  wire             sdram_s1_in_a_write_cycle;
  wire    [  1: 0] sdram_s1_master_qreq_vector;
  wire             sdram_s1_move_on_to_next_transaction;
  wire             sdram_s1_non_bursting_master_requests;
  wire             sdram_s1_read_n;
  wire    [ 15: 0] sdram_s1_readdata_from_sa;
  wire             sdram_s1_readdatavalid_from_sa;
  reg              sdram_s1_reg_firsttransfer;
  wire             sdram_s1_reset_n;
  reg     [  1: 0] sdram_s1_saved_chosen_master_vector;
  reg              sdram_s1_slavearbiterlockenable;
  wire             sdram_s1_slavearbiterlockenable2;
  wire             sdram_s1_unreg_firsttransfer;
  wire             sdram_s1_waitrequest_from_sa;
  wire             sdram_s1_waits_for_read;
  wire             sdram_s1_waits_for_write;
  wire             sdram_s1_write_n;
  wire    [ 15: 0] sdram_s1_writedata;
  wire    [ 25: 0] shifted_address_to_sdram_s1_from_nios_f_data_master;
  wire    [ 25: 0] shifted_address_to_sdram_s1_from_nios_f_instruction_master;
  wire             wait_for_sdram_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sdram_s1_end_xfer;
    end


  assign sdram_s1_begins_xfer = ~d1_reasons_to_wait & ((nios_f_data_master_qualified_request_sdram_s1 | nios_f_instruction_master_qualified_request_sdram_s1));
  //assign sdram_s1_readdatavalid_from_sa = sdram_s1_readdatavalid so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_s1_readdatavalid_from_sa = sdram_s1_readdatavalid;

  //assign sdram_s1_readdata_from_sa = sdram_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_s1_readdata_from_sa = sdram_s1_readdata;

  assign nios_f_data_master_requests_sdram_s1 = ({nios_f_data_master_address_to_slave[25 : 23] , 23'b0} == 26'h2800000) & (nios_f_data_master_read | nios_f_data_master_write);
  //assign sdram_s1_waitrequest_from_sa = sdram_s1_waitrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sdram_s1_waitrequest_from_sa = sdram_s1_waitrequest;

  //sdram_s1_arb_share_counter set values, which is an e_mux
  assign sdram_s1_arb_share_set_values = (nios_f_data_master_granted_sdram_s1)? 2 :
    (nios_f_instruction_master_granted_sdram_s1)? 2 :
    (nios_f_data_master_granted_sdram_s1)? 2 :
    (nios_f_instruction_master_granted_sdram_s1)? 2 :
    1;

  //sdram_s1_non_bursting_master_requests mux, which is an e_mux
  assign sdram_s1_non_bursting_master_requests = nios_f_data_master_requests_sdram_s1 |
    nios_f_instruction_master_requests_sdram_s1 |
    nios_f_data_master_requests_sdram_s1 |
    nios_f_instruction_master_requests_sdram_s1;

  //sdram_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign sdram_s1_any_bursting_master_saved_grant = 0;

  //sdram_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sdram_s1_arb_share_counter_next_value = sdram_s1_firsttransfer ? (sdram_s1_arb_share_set_values - 1) : |sdram_s1_arb_share_counter ? (sdram_s1_arb_share_counter - 1) : 0;

  //sdram_s1_allgrants all slave grants, which is an e_mux
  assign sdram_s1_allgrants = (|sdram_s1_grant_vector) |
    (|sdram_s1_grant_vector) |
    (|sdram_s1_grant_vector) |
    (|sdram_s1_grant_vector);

  //sdram_s1_end_xfer assignment, which is an e_assign
  assign sdram_s1_end_xfer = ~(sdram_s1_waits_for_read | sdram_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_sdram_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sdram_s1 = sdram_s1_end_xfer & (~sdram_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sdram_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sdram_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_sdram_s1 & sdram_s1_allgrants) | (end_xfer_arb_share_counter_term_sdram_s1 & ~sdram_s1_non_bursting_master_requests);

  //sdram_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_s1_arb_share_counter <= 0;
      else if (sdram_s1_arb_counter_enable)
          sdram_s1_arb_share_counter <= sdram_s1_arb_share_counter_next_value;
    end


  //sdram_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_s1_slavearbiterlockenable <= 0;
      else if ((|sdram_s1_master_qreq_vector & end_xfer_arb_share_counter_term_sdram_s1) | (end_xfer_arb_share_counter_term_sdram_s1 & ~sdram_s1_non_bursting_master_requests))
          sdram_s1_slavearbiterlockenable <= |sdram_s1_arb_share_counter_next_value;
    end


  //nios_f/data_master sdram/s1 arbiterlock, which is an e_assign
  assign nios_f_data_master_arbiterlock = sdram_s1_slavearbiterlockenable & nios_f_data_master_continuerequest;

  //sdram_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sdram_s1_slavearbiterlockenable2 = |sdram_s1_arb_share_counter_next_value;

  //nios_f/data_master sdram/s1 arbiterlock2, which is an e_assign
  assign nios_f_data_master_arbiterlock2 = sdram_s1_slavearbiterlockenable2 & nios_f_data_master_continuerequest;

  //nios_f/instruction_master sdram/s1 arbiterlock, which is an e_assign
  assign nios_f_instruction_master_arbiterlock = sdram_s1_slavearbiterlockenable & nios_f_instruction_master_continuerequest;

  //nios_f/instruction_master sdram/s1 arbiterlock2, which is an e_assign
  assign nios_f_instruction_master_arbiterlock2 = sdram_s1_slavearbiterlockenable2 & nios_f_instruction_master_continuerequest;

  //nios_f/instruction_master granted sdram/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios_f_instruction_master_granted_slave_sdram_s1 <= 0;
      else 
        last_cycle_nios_f_instruction_master_granted_slave_sdram_s1 <= nios_f_instruction_master_saved_grant_sdram_s1 ? 1 : (sdram_s1_arbitration_holdoff_internal | ~nios_f_instruction_master_requests_sdram_s1) ? 0 : last_cycle_nios_f_instruction_master_granted_slave_sdram_s1;
    end


  //nios_f_instruction_master_continuerequest continued request, which is an e_mux
  assign nios_f_instruction_master_continuerequest = last_cycle_nios_f_instruction_master_granted_slave_sdram_s1 & nios_f_instruction_master_requests_sdram_s1;

  //sdram_s1_any_continuerequest at least one master continues requesting, which is an e_mux
  assign sdram_s1_any_continuerequest = nios_f_instruction_master_continuerequest |
    nios_f_data_master_continuerequest;

  assign nios_f_data_master_qualified_request_sdram_s1 = nios_f_data_master_requests_sdram_s1 & ~((nios_f_data_master_read & (~nios_f_data_master_waitrequest | (|nios_f_data_master_read_data_valid_sdram_s1_shift_register))) | ((~nios_f_data_master_waitrequest | nios_f_data_master_no_byte_enables_and_last_term | !nios_f_data_master_byteenable_sdram_s1) & nios_f_data_master_write) | nios_f_instruction_master_arbiterlock);
  //unique name for sdram_s1_move_on_to_next_transaction, which is an e_assign
  assign sdram_s1_move_on_to_next_transaction = sdram_s1_readdatavalid_from_sa;

  //rdv_fifo_for_nios_f_data_master_to_sdram_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_nios_f_data_master_to_sdram_s1_module rdv_fifo_for_nios_f_data_master_to_sdram_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (nios_f_data_master_granted_sdram_s1),
      .data_out             (nios_f_data_master_rdv_fifo_output_from_sdram_s1),
      .empty                (),
      .fifo_contains_ones_n (nios_f_data_master_rdv_fifo_empty_sdram_s1),
      .full                 (),
      .read                 (sdram_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_s1_waits_for_read)
    );

  assign nios_f_data_master_read_data_valid_sdram_s1_shift_register = ~nios_f_data_master_rdv_fifo_empty_sdram_s1;
  //local readdatavalid nios_f_data_master_read_data_valid_sdram_s1, which is an e_mux
  assign nios_f_data_master_read_data_valid_sdram_s1 = (sdram_s1_readdatavalid_from_sa & nios_f_data_master_rdv_fifo_output_from_sdram_s1) & ~ nios_f_data_master_rdv_fifo_empty_sdram_s1;

  //sdram_s1_writedata mux, which is an e_mux
  assign sdram_s1_writedata = nios_f_data_master_dbs_write_16;

  assign nios_f_instruction_master_requests_sdram_s1 = (({nios_f_instruction_master_address_to_slave[25 : 23] , 23'b0} == 26'h2800000) & (nios_f_instruction_master_read)) & nios_f_instruction_master_read;
  //nios_f/data_master granted sdram/s1 last time, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          last_cycle_nios_f_data_master_granted_slave_sdram_s1 <= 0;
      else 
        last_cycle_nios_f_data_master_granted_slave_sdram_s1 <= nios_f_data_master_saved_grant_sdram_s1 ? 1 : (sdram_s1_arbitration_holdoff_internal | ~nios_f_data_master_requests_sdram_s1) ? 0 : last_cycle_nios_f_data_master_granted_slave_sdram_s1;
    end


  //nios_f_data_master_continuerequest continued request, which is an e_mux
  assign nios_f_data_master_continuerequest = last_cycle_nios_f_data_master_granted_slave_sdram_s1 & nios_f_data_master_requests_sdram_s1;

  assign nios_f_instruction_master_qualified_request_sdram_s1 = nios_f_instruction_master_requests_sdram_s1 & ~((nios_f_instruction_master_read & ((nios_f_instruction_master_latency_counter != 0) | (1 < nios_f_instruction_master_latency_counter) | (|nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register))) | nios_f_data_master_arbiterlock);
  //rdv_fifo_for_nios_f_instruction_master_to_sdram_s1, which is an e_fifo_with_registered_outputs
  rdv_fifo_for_nios_f_instruction_master_to_sdram_s1_module rdv_fifo_for_nios_f_instruction_master_to_sdram_s1
    (
      .clear_fifo           (1'b0),
      .clk                  (clk),
      .data_in              (nios_f_instruction_master_granted_sdram_s1),
      .data_out             (nios_f_instruction_master_rdv_fifo_output_from_sdram_s1),
      .empty                (),
      .fifo_contains_ones_n (nios_f_instruction_master_rdv_fifo_empty_sdram_s1),
      .full                 (),
      .read                 (sdram_s1_move_on_to_next_transaction),
      .reset_n              (reset_n),
      .sync_reset           (1'b0),
      .write                (in_a_read_cycle & ~sdram_s1_waits_for_read)
    );

  assign nios_f_instruction_master_read_data_valid_sdram_s1_shift_register = ~nios_f_instruction_master_rdv_fifo_empty_sdram_s1;
  //local readdatavalid nios_f_instruction_master_read_data_valid_sdram_s1, which is an e_mux
  assign nios_f_instruction_master_read_data_valid_sdram_s1 = (sdram_s1_readdatavalid_from_sa & nios_f_instruction_master_rdv_fifo_output_from_sdram_s1) & ~ nios_f_instruction_master_rdv_fifo_empty_sdram_s1;

  //allow new arb cycle for sdram/s1, which is an e_assign
  assign sdram_s1_allow_new_arb_cycle = ~nios_f_data_master_arbiterlock & ~nios_f_instruction_master_arbiterlock;

  //nios_f/instruction_master assignment into master qualified-requests vector for sdram/s1, which is an e_assign
  assign sdram_s1_master_qreq_vector[0] = nios_f_instruction_master_qualified_request_sdram_s1;

  //nios_f/instruction_master grant sdram/s1, which is an e_assign
  assign nios_f_instruction_master_granted_sdram_s1 = sdram_s1_grant_vector[0];

  //nios_f/instruction_master saved-grant sdram/s1, which is an e_assign
  assign nios_f_instruction_master_saved_grant_sdram_s1 = sdram_s1_arb_winner[0] && nios_f_instruction_master_requests_sdram_s1;

  //nios_f/data_master assignment into master qualified-requests vector for sdram/s1, which is an e_assign
  assign sdram_s1_master_qreq_vector[1] = nios_f_data_master_qualified_request_sdram_s1;

  //nios_f/data_master grant sdram/s1, which is an e_assign
  assign nios_f_data_master_granted_sdram_s1 = sdram_s1_grant_vector[1];

  //nios_f/data_master saved-grant sdram/s1, which is an e_assign
  assign nios_f_data_master_saved_grant_sdram_s1 = sdram_s1_arb_winner[1] && nios_f_data_master_requests_sdram_s1;

  //sdram/s1 chosen-master double-vector, which is an e_assign
  assign sdram_s1_chosen_master_double_vector = {sdram_s1_master_qreq_vector, sdram_s1_master_qreq_vector} & ({~sdram_s1_master_qreq_vector, ~sdram_s1_master_qreq_vector} + sdram_s1_arb_addend);

  //stable onehot encoding of arb winner
  assign sdram_s1_arb_winner = (sdram_s1_allow_new_arb_cycle & | sdram_s1_grant_vector) ? sdram_s1_grant_vector : sdram_s1_saved_chosen_master_vector;

  //saved sdram_s1_grant_vector, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_s1_saved_chosen_master_vector <= 0;
      else if (sdram_s1_allow_new_arb_cycle)
          sdram_s1_saved_chosen_master_vector <= |sdram_s1_grant_vector ? sdram_s1_grant_vector : sdram_s1_saved_chosen_master_vector;
    end


  //onehot encoding of chosen master
  assign sdram_s1_grant_vector = {(sdram_s1_chosen_master_double_vector[1] | sdram_s1_chosen_master_double_vector[3]),
    (sdram_s1_chosen_master_double_vector[0] | sdram_s1_chosen_master_double_vector[2])};

  //sdram/s1 chosen master rotated left, which is an e_assign
  assign sdram_s1_chosen_master_rot_left = (sdram_s1_arb_winner << 1) ? (sdram_s1_arb_winner << 1) : 1;

  //sdram/s1's addend for next-master-grant
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_s1_arb_addend <= 1;
      else if (|sdram_s1_grant_vector)
          sdram_s1_arb_addend <= sdram_s1_end_xfer? sdram_s1_chosen_master_rot_left : sdram_s1_grant_vector;
    end


  //sdram_s1_reset_n assignment, which is an e_assign
  assign sdram_s1_reset_n = reset_n;

  assign sdram_s1_chipselect = nios_f_data_master_granted_sdram_s1 | nios_f_instruction_master_granted_sdram_s1;
  //sdram_s1_firsttransfer first transaction, which is an e_assign
  assign sdram_s1_firsttransfer = sdram_s1_begins_xfer ? sdram_s1_unreg_firsttransfer : sdram_s1_reg_firsttransfer;

  //sdram_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign sdram_s1_unreg_firsttransfer = ~(sdram_s1_slavearbiterlockenable & sdram_s1_any_continuerequest);

  //sdram_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sdram_s1_reg_firsttransfer <= 1'b1;
      else if (sdram_s1_begins_xfer)
          sdram_s1_reg_firsttransfer <= sdram_s1_unreg_firsttransfer;
    end


  //sdram_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sdram_s1_beginbursttransfer_internal = sdram_s1_begins_xfer;

  //sdram_s1_arbitration_holdoff_internal arbitration_holdoff, which is an e_assign
  assign sdram_s1_arbitration_holdoff_internal = sdram_s1_begins_xfer & sdram_s1_firsttransfer;

  //~sdram_s1_read_n assignment, which is an e_mux
  assign sdram_s1_read_n = ~((nios_f_data_master_granted_sdram_s1 & nios_f_data_master_read) | (nios_f_instruction_master_granted_sdram_s1 & nios_f_instruction_master_read));

  //~sdram_s1_write_n assignment, which is an e_mux
  assign sdram_s1_write_n = ~(nios_f_data_master_granted_sdram_s1 & nios_f_data_master_write);

  assign shifted_address_to_sdram_s1_from_nios_f_data_master = {nios_f_data_master_address_to_slave >> 2,
    nios_f_data_master_dbs_address[1],
    {1 {1'b0}}};

  //sdram_s1_address mux, which is an e_mux
  assign sdram_s1_address = (nios_f_data_master_granted_sdram_s1)? (shifted_address_to_sdram_s1_from_nios_f_data_master >> 1) :
    (shifted_address_to_sdram_s1_from_nios_f_instruction_master >> 1);

  assign shifted_address_to_sdram_s1_from_nios_f_instruction_master = {nios_f_instruction_master_address_to_slave >> 2,
    nios_f_instruction_master_dbs_address[1],
    {1 {1'b0}}};

  //d1_sdram_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sdram_s1_end_xfer <= 1;
      else 
        d1_sdram_s1_end_xfer <= sdram_s1_end_xfer;
    end


  //sdram_s1_waits_for_read in a cycle, which is an e_mux
  assign sdram_s1_waits_for_read = sdram_s1_in_a_read_cycle & sdram_s1_waitrequest_from_sa;

  //sdram_s1_in_a_read_cycle assignment, which is an e_assign
  assign sdram_s1_in_a_read_cycle = (nios_f_data_master_granted_sdram_s1 & nios_f_data_master_read) | (nios_f_instruction_master_granted_sdram_s1 & nios_f_instruction_master_read);

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sdram_s1_in_a_read_cycle;

  //sdram_s1_waits_for_write in a cycle, which is an e_mux
  assign sdram_s1_waits_for_write = sdram_s1_in_a_write_cycle & sdram_s1_waitrequest_from_sa;

  //sdram_s1_in_a_write_cycle assignment, which is an e_assign
  assign sdram_s1_in_a_write_cycle = nios_f_data_master_granted_sdram_s1 & nios_f_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sdram_s1_in_a_write_cycle;

  assign wait_for_sdram_s1_counter = 0;
  //~sdram_s1_byteenable_n byte enable port mux, which is an e_mux
  assign sdram_s1_byteenable_n = ~((nios_f_data_master_granted_sdram_s1)? nios_f_data_master_byteenable_sdram_s1 :
    -1);

  assign {nios_f_data_master_byteenable_sdram_s1_segment_1,
nios_f_data_master_byteenable_sdram_s1_segment_0} = nios_f_data_master_byteenable;
  assign nios_f_data_master_byteenable_sdram_s1 = ((nios_f_data_master_dbs_address[1] == 0))? nios_f_data_master_byteenable_sdram_s1_segment_0 :
    nios_f_data_master_byteenable_sdram_s1_segment_1;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sdram/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end


  //grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (nios_f_data_master_granted_sdram_s1 + nios_f_instruction_master_granted_sdram_s1 > 1)
        begin
          $write("%0d ns: > 1 of grant signals are active simultaneously", $time);
          $stop;
        end
    end


  //saved_grant signals are active simultaneously, which is an e_process
  always @(posedge clk)
    begin
      if (nios_f_data_master_saved_grant_sdram_s1 + nios_f_instruction_master_saved_grant_sdram_s1 > 1)
        begin
          $write("%0d ns: > 1 of saved_grant signals are active simultaneously", $time);
          $stop;
        end
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sys_clk_timer_s1_arbitrator (
                                     // inputs:
                                      clk,
                                      nios_f_data_master_address_to_slave,
                                      nios_f_data_master_read,
                                      nios_f_data_master_waitrequest,
                                      nios_f_data_master_write,
                                      nios_f_data_master_writedata,
                                      reset_n,
                                      sys_clk_timer_s1_irq,
                                      sys_clk_timer_s1_readdata,

                                     // outputs:
                                      d1_sys_clk_timer_s1_end_xfer,
                                      nios_f_data_master_granted_sys_clk_timer_s1,
                                      nios_f_data_master_qualified_request_sys_clk_timer_s1,
                                      nios_f_data_master_read_data_valid_sys_clk_timer_s1,
                                      nios_f_data_master_requests_sys_clk_timer_s1,
                                      sys_clk_timer_s1_address,
                                      sys_clk_timer_s1_chipselect,
                                      sys_clk_timer_s1_irq_from_sa,
                                      sys_clk_timer_s1_readdata_from_sa,
                                      sys_clk_timer_s1_reset_n,
                                      sys_clk_timer_s1_write_n,
                                      sys_clk_timer_s1_writedata
                                   )
;

  output           d1_sys_clk_timer_s1_end_xfer;
  output           nios_f_data_master_granted_sys_clk_timer_s1;
  output           nios_f_data_master_qualified_request_sys_clk_timer_s1;
  output           nios_f_data_master_read_data_valid_sys_clk_timer_s1;
  output           nios_f_data_master_requests_sys_clk_timer_s1;
  output  [  2: 0] sys_clk_timer_s1_address;
  output           sys_clk_timer_s1_chipselect;
  output           sys_clk_timer_s1_irq_from_sa;
  output  [ 15: 0] sys_clk_timer_s1_readdata_from_sa;
  output           sys_clk_timer_s1_reset_n;
  output           sys_clk_timer_s1_write_n;
  output  [ 15: 0] sys_clk_timer_s1_writedata;
  input            clk;
  input   [ 25: 0] nios_f_data_master_address_to_slave;
  input            nios_f_data_master_read;
  input            nios_f_data_master_waitrequest;
  input            nios_f_data_master_write;
  input   [ 31: 0] nios_f_data_master_writedata;
  input            reset_n;
  input            sys_clk_timer_s1_irq;
  input   [ 15: 0] sys_clk_timer_s1_readdata;

  reg              d1_reasons_to_wait;
  reg              d1_sys_clk_timer_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sys_clk_timer_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios_f_data_master_arbiterlock;
  wire             nios_f_data_master_arbiterlock2;
  wire             nios_f_data_master_continuerequest;
  wire             nios_f_data_master_granted_sys_clk_timer_s1;
  wire             nios_f_data_master_qualified_request_sys_clk_timer_s1;
  wire             nios_f_data_master_read_data_valid_sys_clk_timer_s1;
  wire             nios_f_data_master_requests_sys_clk_timer_s1;
  wire             nios_f_data_master_saved_grant_sys_clk_timer_s1;
  wire    [ 25: 0] shifted_address_to_sys_clk_timer_s1_from_nios_f_data_master;
  wire    [  2: 0] sys_clk_timer_s1_address;
  wire             sys_clk_timer_s1_allgrants;
  wire             sys_clk_timer_s1_allow_new_arb_cycle;
  wire             sys_clk_timer_s1_any_bursting_master_saved_grant;
  wire             sys_clk_timer_s1_any_continuerequest;
  wire             sys_clk_timer_s1_arb_counter_enable;
  reg     [  1: 0] sys_clk_timer_s1_arb_share_counter;
  wire    [  1: 0] sys_clk_timer_s1_arb_share_counter_next_value;
  wire    [  1: 0] sys_clk_timer_s1_arb_share_set_values;
  wire             sys_clk_timer_s1_beginbursttransfer_internal;
  wire             sys_clk_timer_s1_begins_xfer;
  wire             sys_clk_timer_s1_chipselect;
  wire             sys_clk_timer_s1_end_xfer;
  wire             sys_clk_timer_s1_firsttransfer;
  wire             sys_clk_timer_s1_grant_vector;
  wire             sys_clk_timer_s1_in_a_read_cycle;
  wire             sys_clk_timer_s1_in_a_write_cycle;
  wire             sys_clk_timer_s1_irq_from_sa;
  wire             sys_clk_timer_s1_master_qreq_vector;
  wire             sys_clk_timer_s1_non_bursting_master_requests;
  wire    [ 15: 0] sys_clk_timer_s1_readdata_from_sa;
  reg              sys_clk_timer_s1_reg_firsttransfer;
  wire             sys_clk_timer_s1_reset_n;
  reg              sys_clk_timer_s1_slavearbiterlockenable;
  wire             sys_clk_timer_s1_slavearbiterlockenable2;
  wire             sys_clk_timer_s1_unreg_firsttransfer;
  wire             sys_clk_timer_s1_waits_for_read;
  wire             sys_clk_timer_s1_waits_for_write;
  wire             sys_clk_timer_s1_write_n;
  wire    [ 15: 0] sys_clk_timer_s1_writedata;
  wire             wait_for_sys_clk_timer_s1_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sys_clk_timer_s1_end_xfer;
    end


  assign sys_clk_timer_s1_begins_xfer = ~d1_reasons_to_wait & ((nios_f_data_master_qualified_request_sys_clk_timer_s1));
  //assign sys_clk_timer_s1_readdata_from_sa = sys_clk_timer_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sys_clk_timer_s1_readdata_from_sa = sys_clk_timer_s1_readdata;

  assign nios_f_data_master_requests_sys_clk_timer_s1 = ({nios_f_data_master_address_to_slave[25 : 5] , 5'b0} == 26'h3002000) & (nios_f_data_master_read | nios_f_data_master_write);
  //sys_clk_timer_s1_arb_share_counter set values, which is an e_mux
  assign sys_clk_timer_s1_arb_share_set_values = 1;

  //sys_clk_timer_s1_non_bursting_master_requests mux, which is an e_mux
  assign sys_clk_timer_s1_non_bursting_master_requests = nios_f_data_master_requests_sys_clk_timer_s1;

  //sys_clk_timer_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign sys_clk_timer_s1_any_bursting_master_saved_grant = 0;

  //sys_clk_timer_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign sys_clk_timer_s1_arb_share_counter_next_value = sys_clk_timer_s1_firsttransfer ? (sys_clk_timer_s1_arb_share_set_values - 1) : |sys_clk_timer_s1_arb_share_counter ? (sys_clk_timer_s1_arb_share_counter - 1) : 0;

  //sys_clk_timer_s1_allgrants all slave grants, which is an e_mux
  assign sys_clk_timer_s1_allgrants = |sys_clk_timer_s1_grant_vector;

  //sys_clk_timer_s1_end_xfer assignment, which is an e_assign
  assign sys_clk_timer_s1_end_xfer = ~(sys_clk_timer_s1_waits_for_read | sys_clk_timer_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_sys_clk_timer_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sys_clk_timer_s1 = sys_clk_timer_s1_end_xfer & (~sys_clk_timer_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sys_clk_timer_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign sys_clk_timer_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_sys_clk_timer_s1 & sys_clk_timer_s1_allgrants) | (end_xfer_arb_share_counter_term_sys_clk_timer_s1 & ~sys_clk_timer_s1_non_bursting_master_requests);

  //sys_clk_timer_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sys_clk_timer_s1_arb_share_counter <= 0;
      else if (sys_clk_timer_s1_arb_counter_enable)
          sys_clk_timer_s1_arb_share_counter <= sys_clk_timer_s1_arb_share_counter_next_value;
    end


  //sys_clk_timer_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sys_clk_timer_s1_slavearbiterlockenable <= 0;
      else if ((|sys_clk_timer_s1_master_qreq_vector & end_xfer_arb_share_counter_term_sys_clk_timer_s1) | (end_xfer_arb_share_counter_term_sys_clk_timer_s1 & ~sys_clk_timer_s1_non_bursting_master_requests))
          sys_clk_timer_s1_slavearbiterlockenable <= |sys_clk_timer_s1_arb_share_counter_next_value;
    end


  //nios_f/data_master sys_clk_timer/s1 arbiterlock, which is an e_assign
  assign nios_f_data_master_arbiterlock = sys_clk_timer_s1_slavearbiterlockenable & nios_f_data_master_continuerequest;

  //sys_clk_timer_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sys_clk_timer_s1_slavearbiterlockenable2 = |sys_clk_timer_s1_arb_share_counter_next_value;

  //nios_f/data_master sys_clk_timer/s1 arbiterlock2, which is an e_assign
  assign nios_f_data_master_arbiterlock2 = sys_clk_timer_s1_slavearbiterlockenable2 & nios_f_data_master_continuerequest;

  //sys_clk_timer_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sys_clk_timer_s1_any_continuerequest = 1;

  //nios_f_data_master_continuerequest continued request, which is an e_assign
  assign nios_f_data_master_continuerequest = 1;

  assign nios_f_data_master_qualified_request_sys_clk_timer_s1 = nios_f_data_master_requests_sys_clk_timer_s1 & ~(((~nios_f_data_master_waitrequest) & nios_f_data_master_write));
  //sys_clk_timer_s1_writedata mux, which is an e_mux
  assign sys_clk_timer_s1_writedata = nios_f_data_master_writedata;

  //master is always granted when requested
  assign nios_f_data_master_granted_sys_clk_timer_s1 = nios_f_data_master_qualified_request_sys_clk_timer_s1;

  //nios_f/data_master saved-grant sys_clk_timer/s1, which is an e_assign
  assign nios_f_data_master_saved_grant_sys_clk_timer_s1 = nios_f_data_master_requests_sys_clk_timer_s1;

  //allow new arb cycle for sys_clk_timer/s1, which is an e_assign
  assign sys_clk_timer_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sys_clk_timer_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sys_clk_timer_s1_master_qreq_vector = 1;

  //sys_clk_timer_s1_reset_n assignment, which is an e_assign
  assign sys_clk_timer_s1_reset_n = reset_n;

  assign sys_clk_timer_s1_chipselect = nios_f_data_master_granted_sys_clk_timer_s1;
  //sys_clk_timer_s1_firsttransfer first transaction, which is an e_assign
  assign sys_clk_timer_s1_firsttransfer = sys_clk_timer_s1_begins_xfer ? sys_clk_timer_s1_unreg_firsttransfer : sys_clk_timer_s1_reg_firsttransfer;

  //sys_clk_timer_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign sys_clk_timer_s1_unreg_firsttransfer = ~(sys_clk_timer_s1_slavearbiterlockenable & sys_clk_timer_s1_any_continuerequest);

  //sys_clk_timer_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sys_clk_timer_s1_reg_firsttransfer <= 1'b1;
      else if (sys_clk_timer_s1_begins_xfer)
          sys_clk_timer_s1_reg_firsttransfer <= sys_clk_timer_s1_unreg_firsttransfer;
    end


  //sys_clk_timer_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sys_clk_timer_s1_beginbursttransfer_internal = sys_clk_timer_s1_begins_xfer;

  //~sys_clk_timer_s1_write_n assignment, which is an e_mux
  assign sys_clk_timer_s1_write_n = ~(nios_f_data_master_granted_sys_clk_timer_s1 & nios_f_data_master_write);

  assign shifted_address_to_sys_clk_timer_s1_from_nios_f_data_master = nios_f_data_master_address_to_slave;
  //sys_clk_timer_s1_address mux, which is an e_mux
  assign sys_clk_timer_s1_address = shifted_address_to_sys_clk_timer_s1_from_nios_f_data_master >> 2;

  //d1_sys_clk_timer_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sys_clk_timer_s1_end_xfer <= 1;
      else 
        d1_sys_clk_timer_s1_end_xfer <= sys_clk_timer_s1_end_xfer;
    end


  //sys_clk_timer_s1_waits_for_read in a cycle, which is an e_mux
  assign sys_clk_timer_s1_waits_for_read = sys_clk_timer_s1_in_a_read_cycle & sys_clk_timer_s1_begins_xfer;

  //sys_clk_timer_s1_in_a_read_cycle assignment, which is an e_assign
  assign sys_clk_timer_s1_in_a_read_cycle = nios_f_data_master_granted_sys_clk_timer_s1 & nios_f_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sys_clk_timer_s1_in_a_read_cycle;

  //sys_clk_timer_s1_waits_for_write in a cycle, which is an e_mux
  assign sys_clk_timer_s1_waits_for_write = sys_clk_timer_s1_in_a_write_cycle & 0;

  //sys_clk_timer_s1_in_a_write_cycle assignment, which is an e_assign
  assign sys_clk_timer_s1_in_a_write_cycle = nios_f_data_master_granted_sys_clk_timer_s1 & nios_f_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sys_clk_timer_s1_in_a_write_cycle;

  assign wait_for_sys_clk_timer_s1_counter = 0;
  //assign sys_clk_timer_s1_irq_from_sa = sys_clk_timer_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sys_clk_timer_s1_irq_from_sa = sys_clk_timer_s1_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sys_clk_timer/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sysid_control_slave_arbitrator (
                                        // inputs:
                                         clk,
                                         nios_f_data_master_address_to_slave,
                                         nios_f_data_master_read,
                                         nios_f_data_master_write,
                                         reset_n,
                                         sysid_control_slave_readdata,

                                        // outputs:
                                         d1_sysid_control_slave_end_xfer,
                                         nios_f_data_master_granted_sysid_control_slave,
                                         nios_f_data_master_qualified_request_sysid_control_slave,
                                         nios_f_data_master_read_data_valid_sysid_control_slave,
                                         nios_f_data_master_requests_sysid_control_slave,
                                         sysid_control_slave_address,
                                         sysid_control_slave_readdata_from_sa,
                                         sysid_control_slave_reset_n
                                      )
;

  output           d1_sysid_control_slave_end_xfer;
  output           nios_f_data_master_granted_sysid_control_slave;
  output           nios_f_data_master_qualified_request_sysid_control_slave;
  output           nios_f_data_master_read_data_valid_sysid_control_slave;
  output           nios_f_data_master_requests_sysid_control_slave;
  output           sysid_control_slave_address;
  output  [ 31: 0] sysid_control_slave_readdata_from_sa;
  output           sysid_control_slave_reset_n;
  input            clk;
  input   [ 25: 0] nios_f_data_master_address_to_slave;
  input            nios_f_data_master_read;
  input            nios_f_data_master_write;
  input            reset_n;
  input   [ 31: 0] sysid_control_slave_readdata;

  reg              d1_reasons_to_wait;
  reg              d1_sysid_control_slave_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_sysid_control_slave;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios_f_data_master_arbiterlock;
  wire             nios_f_data_master_arbiterlock2;
  wire             nios_f_data_master_continuerequest;
  wire             nios_f_data_master_granted_sysid_control_slave;
  wire             nios_f_data_master_qualified_request_sysid_control_slave;
  wire             nios_f_data_master_read_data_valid_sysid_control_slave;
  wire             nios_f_data_master_requests_sysid_control_slave;
  wire             nios_f_data_master_saved_grant_sysid_control_slave;
  wire    [ 25: 0] shifted_address_to_sysid_control_slave_from_nios_f_data_master;
  wire             sysid_control_slave_address;
  wire             sysid_control_slave_allgrants;
  wire             sysid_control_slave_allow_new_arb_cycle;
  wire             sysid_control_slave_any_bursting_master_saved_grant;
  wire             sysid_control_slave_any_continuerequest;
  wire             sysid_control_slave_arb_counter_enable;
  reg     [  1: 0] sysid_control_slave_arb_share_counter;
  wire    [  1: 0] sysid_control_slave_arb_share_counter_next_value;
  wire    [  1: 0] sysid_control_slave_arb_share_set_values;
  wire             sysid_control_slave_beginbursttransfer_internal;
  wire             sysid_control_slave_begins_xfer;
  wire             sysid_control_slave_end_xfer;
  wire             sysid_control_slave_firsttransfer;
  wire             sysid_control_slave_grant_vector;
  wire             sysid_control_slave_in_a_read_cycle;
  wire             sysid_control_slave_in_a_write_cycle;
  wire             sysid_control_slave_master_qreq_vector;
  wire             sysid_control_slave_non_bursting_master_requests;
  wire    [ 31: 0] sysid_control_slave_readdata_from_sa;
  reg              sysid_control_slave_reg_firsttransfer;
  wire             sysid_control_slave_reset_n;
  reg              sysid_control_slave_slavearbiterlockenable;
  wire             sysid_control_slave_slavearbiterlockenable2;
  wire             sysid_control_slave_unreg_firsttransfer;
  wire             sysid_control_slave_waits_for_read;
  wire             sysid_control_slave_waits_for_write;
  wire             wait_for_sysid_control_slave_counter;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~sysid_control_slave_end_xfer;
    end


  assign sysid_control_slave_begins_xfer = ~d1_reasons_to_wait & ((nios_f_data_master_qualified_request_sysid_control_slave));
  //assign sysid_control_slave_readdata_from_sa = sysid_control_slave_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign sysid_control_slave_readdata_from_sa = sysid_control_slave_readdata;

  assign nios_f_data_master_requests_sysid_control_slave = (({nios_f_data_master_address_to_slave[25 : 3] , 3'b0} == 26'h3002068) & (nios_f_data_master_read | nios_f_data_master_write)) & nios_f_data_master_read;
  //sysid_control_slave_arb_share_counter set values, which is an e_mux
  assign sysid_control_slave_arb_share_set_values = 1;

  //sysid_control_slave_non_bursting_master_requests mux, which is an e_mux
  assign sysid_control_slave_non_bursting_master_requests = nios_f_data_master_requests_sysid_control_slave;

  //sysid_control_slave_any_bursting_master_saved_grant mux, which is an e_mux
  assign sysid_control_slave_any_bursting_master_saved_grant = 0;

  //sysid_control_slave_arb_share_counter_next_value assignment, which is an e_assign
  assign sysid_control_slave_arb_share_counter_next_value = sysid_control_slave_firsttransfer ? (sysid_control_slave_arb_share_set_values - 1) : |sysid_control_slave_arb_share_counter ? (sysid_control_slave_arb_share_counter - 1) : 0;

  //sysid_control_slave_allgrants all slave grants, which is an e_mux
  assign sysid_control_slave_allgrants = |sysid_control_slave_grant_vector;

  //sysid_control_slave_end_xfer assignment, which is an e_assign
  assign sysid_control_slave_end_xfer = ~(sysid_control_slave_waits_for_read | sysid_control_slave_waits_for_write);

  //end_xfer_arb_share_counter_term_sysid_control_slave arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_sysid_control_slave = sysid_control_slave_end_xfer & (~sysid_control_slave_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //sysid_control_slave_arb_share_counter arbitration counter enable, which is an e_assign
  assign sysid_control_slave_arb_counter_enable = (end_xfer_arb_share_counter_term_sysid_control_slave & sysid_control_slave_allgrants) | (end_xfer_arb_share_counter_term_sysid_control_slave & ~sysid_control_slave_non_bursting_master_requests);

  //sysid_control_slave_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_arb_share_counter <= 0;
      else if (sysid_control_slave_arb_counter_enable)
          sysid_control_slave_arb_share_counter <= sysid_control_slave_arb_share_counter_next_value;
    end


  //sysid_control_slave_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_slavearbiterlockenable <= 0;
      else if ((|sysid_control_slave_master_qreq_vector & end_xfer_arb_share_counter_term_sysid_control_slave) | (end_xfer_arb_share_counter_term_sysid_control_slave & ~sysid_control_slave_non_bursting_master_requests))
          sysid_control_slave_slavearbiterlockenable <= |sysid_control_slave_arb_share_counter_next_value;
    end


  //nios_f/data_master sysid/control_slave arbiterlock, which is an e_assign
  assign nios_f_data_master_arbiterlock = sysid_control_slave_slavearbiterlockenable & nios_f_data_master_continuerequest;

  //sysid_control_slave_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign sysid_control_slave_slavearbiterlockenable2 = |sysid_control_slave_arb_share_counter_next_value;

  //nios_f/data_master sysid/control_slave arbiterlock2, which is an e_assign
  assign nios_f_data_master_arbiterlock2 = sysid_control_slave_slavearbiterlockenable2 & nios_f_data_master_continuerequest;

  //sysid_control_slave_any_continuerequest at least one master continues requesting, which is an e_assign
  assign sysid_control_slave_any_continuerequest = 1;

  //nios_f_data_master_continuerequest continued request, which is an e_assign
  assign nios_f_data_master_continuerequest = 1;

  assign nios_f_data_master_qualified_request_sysid_control_slave = nios_f_data_master_requests_sysid_control_slave;
  //master is always granted when requested
  assign nios_f_data_master_granted_sysid_control_slave = nios_f_data_master_qualified_request_sysid_control_slave;

  //nios_f/data_master saved-grant sysid/control_slave, which is an e_assign
  assign nios_f_data_master_saved_grant_sysid_control_slave = nios_f_data_master_requests_sysid_control_slave;

  //allow new arb cycle for sysid/control_slave, which is an e_assign
  assign sysid_control_slave_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign sysid_control_slave_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign sysid_control_slave_master_qreq_vector = 1;

  //sysid_control_slave_reset_n assignment, which is an e_assign
  assign sysid_control_slave_reset_n = reset_n;

  //sysid_control_slave_firsttransfer first transaction, which is an e_assign
  assign sysid_control_slave_firsttransfer = sysid_control_slave_begins_xfer ? sysid_control_slave_unreg_firsttransfer : sysid_control_slave_reg_firsttransfer;

  //sysid_control_slave_unreg_firsttransfer first transaction, which is an e_assign
  assign sysid_control_slave_unreg_firsttransfer = ~(sysid_control_slave_slavearbiterlockenable & sysid_control_slave_any_continuerequest);

  //sysid_control_slave_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          sysid_control_slave_reg_firsttransfer <= 1'b1;
      else if (sysid_control_slave_begins_xfer)
          sysid_control_slave_reg_firsttransfer <= sysid_control_slave_unreg_firsttransfer;
    end


  //sysid_control_slave_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign sysid_control_slave_beginbursttransfer_internal = sysid_control_slave_begins_xfer;

  assign shifted_address_to_sysid_control_slave_from_nios_f_data_master = nios_f_data_master_address_to_slave;
  //sysid_control_slave_address mux, which is an e_mux
  assign sysid_control_slave_address = shifted_address_to_sysid_control_slave_from_nios_f_data_master >> 2;

  //d1_sysid_control_slave_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_sysid_control_slave_end_xfer <= 1;
      else 
        d1_sysid_control_slave_end_xfer <= sysid_control_slave_end_xfer;
    end


  //sysid_control_slave_waits_for_read in a cycle, which is an e_mux
  assign sysid_control_slave_waits_for_read = sysid_control_slave_in_a_read_cycle & sysid_control_slave_begins_xfer;

  //sysid_control_slave_in_a_read_cycle assignment, which is an e_assign
  assign sysid_control_slave_in_a_read_cycle = nios_f_data_master_granted_sysid_control_slave & nios_f_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = sysid_control_slave_in_a_read_cycle;

  //sysid_control_slave_waits_for_write in a cycle, which is an e_mux
  assign sysid_control_slave_waits_for_write = sysid_control_slave_in_a_write_cycle & 0;

  //sysid_control_slave_in_a_write_cycle assignment, which is an e_assign
  assign sysid_control_slave_in_a_write_cycle = nios_f_data_master_granted_sysid_control_slave & nios_f_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = sysid_control_slave_in_a_write_cycle;

  assign wait_for_sysid_control_slave_counter = 0;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //sysid/control_slave enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module watchdog_timer_s1_arbitrator (
                                      // inputs:
                                       clk,
                                       nios_f_data_master_address_to_slave,
                                       nios_f_data_master_read,
                                       nios_f_data_master_waitrequest,
                                       nios_f_data_master_write,
                                       nios_f_data_master_writedata,
                                       reset_n,
                                       watchdog_timer_s1_irq,
                                       watchdog_timer_s1_readdata,
                                       watchdog_timer_s1_resetrequest,

                                      // outputs:
                                       d1_watchdog_timer_s1_end_xfer,
                                       nios_f_data_master_granted_watchdog_timer_s1,
                                       nios_f_data_master_qualified_request_watchdog_timer_s1,
                                       nios_f_data_master_read_data_valid_watchdog_timer_s1,
                                       nios_f_data_master_requests_watchdog_timer_s1,
                                       watchdog_timer_s1_address,
                                       watchdog_timer_s1_chipselect,
                                       watchdog_timer_s1_irq_from_sa,
                                       watchdog_timer_s1_readdata_from_sa,
                                       watchdog_timer_s1_reset_n,
                                       watchdog_timer_s1_resetrequest_from_sa,
                                       watchdog_timer_s1_write_n,
                                       watchdog_timer_s1_writedata
                                    )
;

  output           d1_watchdog_timer_s1_end_xfer;
  output           nios_f_data_master_granted_watchdog_timer_s1;
  output           nios_f_data_master_qualified_request_watchdog_timer_s1;
  output           nios_f_data_master_read_data_valid_watchdog_timer_s1;
  output           nios_f_data_master_requests_watchdog_timer_s1;
  output  [  2: 0] watchdog_timer_s1_address;
  output           watchdog_timer_s1_chipselect;
  output           watchdog_timer_s1_irq_from_sa;
  output  [ 15: 0] watchdog_timer_s1_readdata_from_sa;
  output           watchdog_timer_s1_reset_n;
  output           watchdog_timer_s1_resetrequest_from_sa;
  output           watchdog_timer_s1_write_n;
  output  [ 15: 0] watchdog_timer_s1_writedata;
  input            clk;
  input   [ 25: 0] nios_f_data_master_address_to_slave;
  input            nios_f_data_master_read;
  input            nios_f_data_master_waitrequest;
  input            nios_f_data_master_write;
  input   [ 31: 0] nios_f_data_master_writedata;
  input            reset_n;
  input            watchdog_timer_s1_irq;
  input   [ 15: 0] watchdog_timer_s1_readdata;
  input            watchdog_timer_s1_resetrequest;

  reg              d1_reasons_to_wait;
  reg              d1_watchdog_timer_s1_end_xfer;
  reg              enable_nonzero_assertions;
  wire             end_xfer_arb_share_counter_term_watchdog_timer_s1;
  wire             in_a_read_cycle;
  wire             in_a_write_cycle;
  wire             nios_f_data_master_arbiterlock;
  wire             nios_f_data_master_arbiterlock2;
  wire             nios_f_data_master_continuerequest;
  wire             nios_f_data_master_granted_watchdog_timer_s1;
  wire             nios_f_data_master_qualified_request_watchdog_timer_s1;
  wire             nios_f_data_master_read_data_valid_watchdog_timer_s1;
  wire             nios_f_data_master_requests_watchdog_timer_s1;
  wire             nios_f_data_master_saved_grant_watchdog_timer_s1;
  wire    [ 25: 0] shifted_address_to_watchdog_timer_s1_from_nios_f_data_master;
  wire             wait_for_watchdog_timer_s1_counter;
  wire    [  2: 0] watchdog_timer_s1_address;
  wire             watchdog_timer_s1_allgrants;
  wire             watchdog_timer_s1_allow_new_arb_cycle;
  wire             watchdog_timer_s1_any_bursting_master_saved_grant;
  wire             watchdog_timer_s1_any_continuerequest;
  wire             watchdog_timer_s1_arb_counter_enable;
  reg     [  1: 0] watchdog_timer_s1_arb_share_counter;
  wire    [  1: 0] watchdog_timer_s1_arb_share_counter_next_value;
  wire    [  1: 0] watchdog_timer_s1_arb_share_set_values;
  wire             watchdog_timer_s1_beginbursttransfer_internal;
  wire             watchdog_timer_s1_begins_xfer;
  wire             watchdog_timer_s1_chipselect;
  wire             watchdog_timer_s1_end_xfer;
  wire             watchdog_timer_s1_firsttransfer;
  wire             watchdog_timer_s1_grant_vector;
  wire             watchdog_timer_s1_in_a_read_cycle;
  wire             watchdog_timer_s1_in_a_write_cycle;
  wire             watchdog_timer_s1_irq_from_sa;
  wire             watchdog_timer_s1_master_qreq_vector;
  wire             watchdog_timer_s1_non_bursting_master_requests;
  wire    [ 15: 0] watchdog_timer_s1_readdata_from_sa;
  reg              watchdog_timer_s1_reg_firsttransfer;
  wire             watchdog_timer_s1_reset_n;
  wire             watchdog_timer_s1_resetrequest_from_sa;
  reg              watchdog_timer_s1_slavearbiterlockenable;
  wire             watchdog_timer_s1_slavearbiterlockenable2;
  wire             watchdog_timer_s1_unreg_firsttransfer;
  wire             watchdog_timer_s1_waits_for_read;
  wire             watchdog_timer_s1_waits_for_write;
  wire             watchdog_timer_s1_write_n;
  wire    [ 15: 0] watchdog_timer_s1_writedata;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_reasons_to_wait <= 0;
      else 
        d1_reasons_to_wait <= ~watchdog_timer_s1_end_xfer;
    end


  assign watchdog_timer_s1_begins_xfer = ~d1_reasons_to_wait & ((nios_f_data_master_qualified_request_watchdog_timer_s1));
  //assign watchdog_timer_s1_readdata_from_sa = watchdog_timer_s1_readdata so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign watchdog_timer_s1_readdata_from_sa = watchdog_timer_s1_readdata;

  assign nios_f_data_master_requests_watchdog_timer_s1 = ({nios_f_data_master_address_to_slave[25 : 5] , 5'b0} == 26'h3002040) & (nios_f_data_master_read | nios_f_data_master_write);
  //watchdog_timer_s1_arb_share_counter set values, which is an e_mux
  assign watchdog_timer_s1_arb_share_set_values = 1;

  //watchdog_timer_s1_non_bursting_master_requests mux, which is an e_mux
  assign watchdog_timer_s1_non_bursting_master_requests = nios_f_data_master_requests_watchdog_timer_s1;

  //watchdog_timer_s1_any_bursting_master_saved_grant mux, which is an e_mux
  assign watchdog_timer_s1_any_bursting_master_saved_grant = 0;

  //watchdog_timer_s1_arb_share_counter_next_value assignment, which is an e_assign
  assign watchdog_timer_s1_arb_share_counter_next_value = watchdog_timer_s1_firsttransfer ? (watchdog_timer_s1_arb_share_set_values - 1) : |watchdog_timer_s1_arb_share_counter ? (watchdog_timer_s1_arb_share_counter - 1) : 0;

  //watchdog_timer_s1_allgrants all slave grants, which is an e_mux
  assign watchdog_timer_s1_allgrants = |watchdog_timer_s1_grant_vector;

  //watchdog_timer_s1_end_xfer assignment, which is an e_assign
  assign watchdog_timer_s1_end_xfer = ~(watchdog_timer_s1_waits_for_read | watchdog_timer_s1_waits_for_write);

  //end_xfer_arb_share_counter_term_watchdog_timer_s1 arb share counter enable term, which is an e_assign
  assign end_xfer_arb_share_counter_term_watchdog_timer_s1 = watchdog_timer_s1_end_xfer & (~watchdog_timer_s1_any_bursting_master_saved_grant | in_a_read_cycle | in_a_write_cycle);

  //watchdog_timer_s1_arb_share_counter arbitration counter enable, which is an e_assign
  assign watchdog_timer_s1_arb_counter_enable = (end_xfer_arb_share_counter_term_watchdog_timer_s1 & watchdog_timer_s1_allgrants) | (end_xfer_arb_share_counter_term_watchdog_timer_s1 & ~watchdog_timer_s1_non_bursting_master_requests);

  //watchdog_timer_s1_arb_share_counter counter, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          watchdog_timer_s1_arb_share_counter <= 0;
      else if (watchdog_timer_s1_arb_counter_enable)
          watchdog_timer_s1_arb_share_counter <= watchdog_timer_s1_arb_share_counter_next_value;
    end


  //watchdog_timer_s1_slavearbiterlockenable slave enables arbiterlock, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          watchdog_timer_s1_slavearbiterlockenable <= 0;
      else if ((|watchdog_timer_s1_master_qreq_vector & end_xfer_arb_share_counter_term_watchdog_timer_s1) | (end_xfer_arb_share_counter_term_watchdog_timer_s1 & ~watchdog_timer_s1_non_bursting_master_requests))
          watchdog_timer_s1_slavearbiterlockenable <= |watchdog_timer_s1_arb_share_counter_next_value;
    end


  //nios_f/data_master watchdog_timer/s1 arbiterlock, which is an e_assign
  assign nios_f_data_master_arbiterlock = watchdog_timer_s1_slavearbiterlockenable & nios_f_data_master_continuerequest;

  //watchdog_timer_s1_slavearbiterlockenable2 slave enables arbiterlock2, which is an e_assign
  assign watchdog_timer_s1_slavearbiterlockenable2 = |watchdog_timer_s1_arb_share_counter_next_value;

  //nios_f/data_master watchdog_timer/s1 arbiterlock2, which is an e_assign
  assign nios_f_data_master_arbiterlock2 = watchdog_timer_s1_slavearbiterlockenable2 & nios_f_data_master_continuerequest;

  //watchdog_timer_s1_any_continuerequest at least one master continues requesting, which is an e_assign
  assign watchdog_timer_s1_any_continuerequest = 1;

  //nios_f_data_master_continuerequest continued request, which is an e_assign
  assign nios_f_data_master_continuerequest = 1;

  assign nios_f_data_master_qualified_request_watchdog_timer_s1 = nios_f_data_master_requests_watchdog_timer_s1 & ~(((~nios_f_data_master_waitrequest) & nios_f_data_master_write));
  //watchdog_timer_s1_writedata mux, which is an e_mux
  assign watchdog_timer_s1_writedata = nios_f_data_master_writedata;

  //master is always granted when requested
  assign nios_f_data_master_granted_watchdog_timer_s1 = nios_f_data_master_qualified_request_watchdog_timer_s1;

  //nios_f/data_master saved-grant watchdog_timer/s1, which is an e_assign
  assign nios_f_data_master_saved_grant_watchdog_timer_s1 = nios_f_data_master_requests_watchdog_timer_s1;

  //allow new arb cycle for watchdog_timer/s1, which is an e_assign
  assign watchdog_timer_s1_allow_new_arb_cycle = 1;

  //placeholder chosen master
  assign watchdog_timer_s1_grant_vector = 1;

  //placeholder vector of master qualified-requests
  assign watchdog_timer_s1_master_qreq_vector = 1;

  //watchdog_timer_s1_reset_n assignment, which is an e_assign
  assign watchdog_timer_s1_reset_n = reset_n;

  //assign watchdog_timer_s1_resetrequest_from_sa = watchdog_timer_s1_resetrequest so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign watchdog_timer_s1_resetrequest_from_sa = watchdog_timer_s1_resetrequest;

  assign watchdog_timer_s1_chipselect = nios_f_data_master_granted_watchdog_timer_s1;
  //watchdog_timer_s1_firsttransfer first transaction, which is an e_assign
  assign watchdog_timer_s1_firsttransfer = watchdog_timer_s1_begins_xfer ? watchdog_timer_s1_unreg_firsttransfer : watchdog_timer_s1_reg_firsttransfer;

  //watchdog_timer_s1_unreg_firsttransfer first transaction, which is an e_assign
  assign watchdog_timer_s1_unreg_firsttransfer = ~(watchdog_timer_s1_slavearbiterlockenable & watchdog_timer_s1_any_continuerequest);

  //watchdog_timer_s1_reg_firsttransfer first transaction, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          watchdog_timer_s1_reg_firsttransfer <= 1'b1;
      else if (watchdog_timer_s1_begins_xfer)
          watchdog_timer_s1_reg_firsttransfer <= watchdog_timer_s1_unreg_firsttransfer;
    end


  //watchdog_timer_s1_beginbursttransfer_internal begin burst transfer, which is an e_assign
  assign watchdog_timer_s1_beginbursttransfer_internal = watchdog_timer_s1_begins_xfer;

  //~watchdog_timer_s1_write_n assignment, which is an e_mux
  assign watchdog_timer_s1_write_n = ~(nios_f_data_master_granted_watchdog_timer_s1 & nios_f_data_master_write);

  assign shifted_address_to_watchdog_timer_s1_from_nios_f_data_master = nios_f_data_master_address_to_slave;
  //watchdog_timer_s1_address mux, which is an e_mux
  assign watchdog_timer_s1_address = shifted_address_to_watchdog_timer_s1_from_nios_f_data_master >> 2;

  //d1_watchdog_timer_s1_end_xfer register, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          d1_watchdog_timer_s1_end_xfer <= 1;
      else 
        d1_watchdog_timer_s1_end_xfer <= watchdog_timer_s1_end_xfer;
    end


  //watchdog_timer_s1_waits_for_read in a cycle, which is an e_mux
  assign watchdog_timer_s1_waits_for_read = watchdog_timer_s1_in_a_read_cycle & watchdog_timer_s1_begins_xfer;

  //watchdog_timer_s1_in_a_read_cycle assignment, which is an e_assign
  assign watchdog_timer_s1_in_a_read_cycle = nios_f_data_master_granted_watchdog_timer_s1 & nios_f_data_master_read;

  //in_a_read_cycle assignment, which is an e_mux
  assign in_a_read_cycle = watchdog_timer_s1_in_a_read_cycle;

  //watchdog_timer_s1_waits_for_write in a cycle, which is an e_mux
  assign watchdog_timer_s1_waits_for_write = watchdog_timer_s1_in_a_write_cycle & 0;

  //watchdog_timer_s1_in_a_write_cycle assignment, which is an e_assign
  assign watchdog_timer_s1_in_a_write_cycle = nios_f_data_master_granted_watchdog_timer_s1 & nios_f_data_master_write;

  //in_a_write_cycle assignment, which is an e_mux
  assign in_a_write_cycle = watchdog_timer_s1_in_a_write_cycle;

  assign wait_for_watchdog_timer_s1_counter = 0;
  //assign watchdog_timer_s1_irq_from_sa = watchdog_timer_s1_irq so that symbol knows where to group signals which may go to master only, which is an e_assign
  assign watchdog_timer_s1_irq_from_sa = watchdog_timer_s1_irq;


//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  //watchdog_timer/s1 enable non-zero assertions, which is an e_register
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          enable_nonzero_assertions <= 0;
      else 
        enable_nonzero_assertions <= 1'b1;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module nios_ii_sys_reset_clk_100_domain_synch_module (
                                                       // inputs:
                                                        clk,
                                                        data_in,
                                                        reset_n,

                                                       // outputs:
                                                        data_out
                                                     )
;

  output           data_out;
  input            clk;
  input            data_in;
  input            reset_n;

  reg              data_in_d1 /* synthesis ALTERA_ATTRIBUTE = "{-from \"*\"} CUT=ON ; PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  reg              data_out /* synthesis ALTERA_ATTRIBUTE = "PRESERVE_REGISTER=ON ; SUPPRESS_DA_RULE_INTERNAL=R101"  */;
  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_in_d1 <= 0;
      else 
        data_in_d1 <= data_in;
    end


  always @(posedge clk or negedge reset_n)
    begin
      if (reset_n == 0)
          data_out <= 0;
      else 
        data_out <= data_in_d1;
    end



endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module nios_ii_sys (
                     // 1) global signals:
                      clk_100,
                      reset_n,

                     // the_ads_busy
                      in_port_to_the_ads_busy,

                     // the_ads_clk
                      out_port_from_the_ads_clk,

                     // the_ads_din
                      out_port_from_the_ads_din,

                     // the_ads_dout
                      in_port_to_the_ads_dout,

                     // the_ads_ncs
                      out_port_from_the_ads_ncs,

                     // the_ads_nirq
                      in_port_to_the_ads_nirq,

                     // the_epcs
                      data0_to_the_epcs,
                      dclk_from_the_epcs,
                      sce_from_the_epcs,
                      sdo_from_the_epcs,

                     // the_ili_db
                      bidir_port_to_and_from_the_ili_db,

                     // the_ili_ncs
                      out_port_from_the_ili_ncs,

                     // the_ili_nrd
                      out_port_from_the_ili_nrd,

                     // the_ili_nrst
                      out_port_from_the_ili_nrst,

                     // the_ili_nwr
                      out_port_from_the_ili_nwr,

                     // the_ili_rs
                      out_port_from_the_ili_rs,

                     // the_sd_clk
                      out_port_from_the_sd_clk,

                     // the_sd_din
                      out_port_from_the_sd_din,

                     // the_sd_dout
                      in_port_to_the_sd_dout,

                     // the_sd_ncs
                      out_port_from_the_sd_ncs,

                     // the_sdram
                      zs_addr_from_the_sdram,
                      zs_ba_from_the_sdram,
                      zs_cas_n_from_the_sdram,
                      zs_cke_from_the_sdram,
                      zs_cs_n_from_the_sdram,
                      zs_dq_to_and_from_the_sdram,
                      zs_dqm_from_the_sdram,
                      zs_ras_n_from_the_sdram,
                      zs_we_n_from_the_sdram
                   )
;

  inout   [  7: 0] bidir_port_to_and_from_the_ili_db;
  output           dclk_from_the_epcs;
  output           out_port_from_the_ads_clk;
  output           out_port_from_the_ads_din;
  output           out_port_from_the_ads_ncs;
  output           out_port_from_the_ili_ncs;
  output           out_port_from_the_ili_nrd;
  output           out_port_from_the_ili_nrst;
  output           out_port_from_the_ili_nwr;
  output           out_port_from_the_ili_rs;
  output           out_port_from_the_sd_clk;
  output           out_port_from_the_sd_din;
  output           out_port_from_the_sd_ncs;
  output           sce_from_the_epcs;
  output           sdo_from_the_epcs;
  output  [ 11: 0] zs_addr_from_the_sdram;
  output  [  1: 0] zs_ba_from_the_sdram;
  output           zs_cas_n_from_the_sdram;
  output           zs_cke_from_the_sdram;
  output           zs_cs_n_from_the_sdram;
  inout   [ 15: 0] zs_dq_to_and_from_the_sdram;
  output  [  1: 0] zs_dqm_from_the_sdram;
  output           zs_ras_n_from_the_sdram;
  output           zs_we_n_from_the_sdram;
  input            clk_100;
  input            data0_to_the_epcs;
  input            in_port_to_the_ads_busy;
  input            in_port_to_the_ads_dout;
  input            in_port_to_the_ads_nirq;
  input            in_port_to_the_sd_dout;
  input            reset_n;

  wire    [  1: 0] ads_busy_s1_address;
  wire    [ 31: 0] ads_busy_s1_readdata;
  wire    [ 31: 0] ads_busy_s1_readdata_from_sa;
  wire             ads_busy_s1_reset_n;
  wire    [  1: 0] ads_clk_s1_address;
  wire             ads_clk_s1_chipselect;
  wire    [ 31: 0] ads_clk_s1_readdata;
  wire    [ 31: 0] ads_clk_s1_readdata_from_sa;
  wire             ads_clk_s1_reset_n;
  wire             ads_clk_s1_write_n;
  wire    [ 31: 0] ads_clk_s1_writedata;
  wire    [  1: 0] ads_din_s1_address;
  wire             ads_din_s1_chipselect;
  wire    [ 31: 0] ads_din_s1_readdata;
  wire    [ 31: 0] ads_din_s1_readdata_from_sa;
  wire             ads_din_s1_reset_n;
  wire             ads_din_s1_write_n;
  wire    [ 31: 0] ads_din_s1_writedata;
  wire    [  1: 0] ads_dout_s1_address;
  wire    [ 31: 0] ads_dout_s1_readdata;
  wire    [ 31: 0] ads_dout_s1_readdata_from_sa;
  wire             ads_dout_s1_reset_n;
  wire    [  1: 0] ads_ncs_s1_address;
  wire             ads_ncs_s1_chipselect;
  wire    [ 31: 0] ads_ncs_s1_readdata;
  wire    [ 31: 0] ads_ncs_s1_readdata_from_sa;
  wire             ads_ncs_s1_reset_n;
  wire             ads_ncs_s1_write_n;
  wire    [ 31: 0] ads_ncs_s1_writedata;
  wire    [  1: 0] ads_nirq_s1_address;
  wire             ads_nirq_s1_chipselect;
  wire             ads_nirq_s1_irq;
  wire             ads_nirq_s1_irq_from_sa;
  wire    [ 31: 0] ads_nirq_s1_readdata;
  wire    [ 31: 0] ads_nirq_s1_readdata_from_sa;
  wire             ads_nirq_s1_reset_n;
  wire             ads_nirq_s1_write_n;
  wire    [ 31: 0] ads_nirq_s1_writedata;
  wire    [  7: 0] bidir_port_to_and_from_the_ili_db;
  wire             clk_100_reset_n;
  wire             d1_ads_busy_s1_end_xfer;
  wire             d1_ads_clk_s1_end_xfer;
  wire             d1_ads_din_s1_end_xfer;
  wire             d1_ads_dout_s1_end_xfer;
  wire             d1_ads_ncs_s1_end_xfer;
  wire             d1_ads_nirq_s1_end_xfer;
  wire             d1_epcs_epcs_control_port_end_xfer;
  wire             d1_high_res_timer_s1_end_xfer;
  wire             d1_ili_db_s1_end_xfer;
  wire             d1_ili_ncs_s1_end_xfer;
  wire             d1_ili_nrd_s1_end_xfer;
  wire             d1_ili_nrst_s1_end_xfer;
  wire             d1_ili_nwr_s1_end_xfer;
  wire             d1_ili_rs_s1_end_xfer;
  wire             d1_jtag_uart_avalon_jtag_slave_end_xfer;
  wire             d1_nios_f_jtag_debug_module_end_xfer;
  wire             d1_pipeline_bridge_0_s1_end_xfer;
  wire             d1_sd_clk_s1_end_xfer;
  wire             d1_sd_din_s1_end_xfer;
  wire             d1_sd_dout_s1_end_xfer;
  wire             d1_sd_ncs_s1_end_xfer;
  wire             d1_sdram_s1_end_xfer;
  wire             d1_sys_clk_timer_s1_end_xfer;
  wire             d1_sysid_control_slave_end_xfer;
  wire             d1_watchdog_timer_s1_end_xfer;
  wire             dclk_from_the_epcs;
  wire    [  8: 0] epcs_epcs_control_port_address;
  wire             epcs_epcs_control_port_chipselect;
  wire             epcs_epcs_control_port_dataavailable;
  wire             epcs_epcs_control_port_dataavailable_from_sa;
  wire             epcs_epcs_control_port_endofpacket;
  wire             epcs_epcs_control_port_endofpacket_from_sa;
  wire             epcs_epcs_control_port_irq;
  wire             epcs_epcs_control_port_irq_from_sa;
  wire             epcs_epcs_control_port_read_n;
  wire    [ 31: 0] epcs_epcs_control_port_readdata;
  wire    [ 31: 0] epcs_epcs_control_port_readdata_from_sa;
  wire             epcs_epcs_control_port_readyfordata;
  wire             epcs_epcs_control_port_readyfordata_from_sa;
  wire             epcs_epcs_control_port_reset_n;
  wire             epcs_epcs_control_port_write_n;
  wire    [ 31: 0] epcs_epcs_control_port_writedata;
  wire    [  2: 0] high_res_timer_s1_address;
  wire             high_res_timer_s1_chipselect;
  wire             high_res_timer_s1_irq;
  wire             high_res_timer_s1_irq_from_sa;
  wire    [ 15: 0] high_res_timer_s1_readdata;
  wire    [ 15: 0] high_res_timer_s1_readdata_from_sa;
  wire             high_res_timer_s1_reset_n;
  wire             high_res_timer_s1_write_n;
  wire    [ 15: 0] high_res_timer_s1_writedata;
  wire    [  1: 0] ili_db_s1_address;
  wire             ili_db_s1_chipselect;
  wire    [ 31: 0] ili_db_s1_readdata;
  wire    [ 31: 0] ili_db_s1_readdata_from_sa;
  wire             ili_db_s1_reset_n;
  wire             ili_db_s1_write_n;
  wire    [ 31: 0] ili_db_s1_writedata;
  wire    [  1: 0] ili_ncs_s1_address;
  wire             ili_ncs_s1_chipselect;
  wire    [ 31: 0] ili_ncs_s1_readdata;
  wire    [ 31: 0] ili_ncs_s1_readdata_from_sa;
  wire             ili_ncs_s1_reset_n;
  wire             ili_ncs_s1_write_n;
  wire    [ 31: 0] ili_ncs_s1_writedata;
  wire    [  1: 0] ili_nrd_s1_address;
  wire             ili_nrd_s1_chipselect;
  wire    [ 31: 0] ili_nrd_s1_readdata;
  wire    [ 31: 0] ili_nrd_s1_readdata_from_sa;
  wire             ili_nrd_s1_reset_n;
  wire             ili_nrd_s1_write_n;
  wire    [ 31: 0] ili_nrd_s1_writedata;
  wire    [  1: 0] ili_nrst_s1_address;
  wire             ili_nrst_s1_chipselect;
  wire    [ 31: 0] ili_nrst_s1_readdata;
  wire    [ 31: 0] ili_nrst_s1_readdata_from_sa;
  wire             ili_nrst_s1_reset_n;
  wire             ili_nrst_s1_write_n;
  wire    [ 31: 0] ili_nrst_s1_writedata;
  wire    [  1: 0] ili_nwr_s1_address;
  wire             ili_nwr_s1_chipselect;
  wire    [ 31: 0] ili_nwr_s1_readdata;
  wire    [ 31: 0] ili_nwr_s1_readdata_from_sa;
  wire             ili_nwr_s1_reset_n;
  wire             ili_nwr_s1_write_n;
  wire    [ 31: 0] ili_nwr_s1_writedata;
  wire    [  1: 0] ili_rs_s1_address;
  wire             ili_rs_s1_chipselect;
  wire    [ 31: 0] ili_rs_s1_readdata;
  wire    [ 31: 0] ili_rs_s1_readdata_from_sa;
  wire             ili_rs_s1_reset_n;
  wire             ili_rs_s1_write_n;
  wire    [ 31: 0] ili_rs_s1_writedata;
  wire             jtag_uart_avalon_jtag_slave_address;
  wire             jtag_uart_avalon_jtag_slave_chipselect;
  wire             jtag_uart_avalon_jtag_slave_dataavailable;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_irq;
  wire             jtag_uart_avalon_jtag_slave_irq_from_sa;
  wire             jtag_uart_avalon_jtag_slave_read_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_readdata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  wire             jtag_uart_avalon_jtag_slave_reset_n;
  wire             jtag_uart_avalon_jtag_slave_waitrequest;
  wire             jtag_uart_avalon_jtag_slave_waitrequest_from_sa;
  wire             jtag_uart_avalon_jtag_slave_write_n;
  wire    [ 31: 0] jtag_uart_avalon_jtag_slave_writedata;
  wire    [ 25: 0] nios_f_data_master_address;
  wire    [ 25: 0] nios_f_data_master_address_to_slave;
  wire    [  3: 0] nios_f_data_master_byteenable;
  wire    [  1: 0] nios_f_data_master_byteenable_sdram_s1;
  wire    [  1: 0] nios_f_data_master_dbs_address;
  wire    [ 15: 0] nios_f_data_master_dbs_write_16;
  wire             nios_f_data_master_debugaccess;
  wire             nios_f_data_master_granted_epcs_epcs_control_port;
  wire             nios_f_data_master_granted_high_res_timer_s1;
  wire             nios_f_data_master_granted_jtag_uart_avalon_jtag_slave;
  wire             nios_f_data_master_granted_nios_f_jtag_debug_module;
  wire             nios_f_data_master_granted_pipeline_bridge_0_s1;
  wire             nios_f_data_master_granted_sdram_s1;
  wire             nios_f_data_master_granted_sys_clk_timer_s1;
  wire             nios_f_data_master_granted_sysid_control_slave;
  wire             nios_f_data_master_granted_watchdog_timer_s1;
  wire    [ 31: 0] nios_f_data_master_irq;
  wire             nios_f_data_master_no_byte_enables_and_last_term;
  wire             nios_f_data_master_qualified_request_epcs_epcs_control_port;
  wire             nios_f_data_master_qualified_request_high_res_timer_s1;
  wire             nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave;
  wire             nios_f_data_master_qualified_request_nios_f_jtag_debug_module;
  wire             nios_f_data_master_qualified_request_pipeline_bridge_0_s1;
  wire             nios_f_data_master_qualified_request_sdram_s1;
  wire             nios_f_data_master_qualified_request_sys_clk_timer_s1;
  wire             nios_f_data_master_qualified_request_sysid_control_slave;
  wire             nios_f_data_master_qualified_request_watchdog_timer_s1;
  wire             nios_f_data_master_read;
  wire             nios_f_data_master_read_data_valid_epcs_epcs_control_port;
  wire             nios_f_data_master_read_data_valid_high_res_timer_s1;
  wire             nios_f_data_master_read_data_valid_jtag_uart_avalon_jtag_slave;
  wire             nios_f_data_master_read_data_valid_nios_f_jtag_debug_module;
  wire             nios_f_data_master_read_data_valid_pipeline_bridge_0_s1;
  wire             nios_f_data_master_read_data_valid_pipeline_bridge_0_s1_shift_register;
  wire             nios_f_data_master_read_data_valid_sdram_s1;
  wire             nios_f_data_master_read_data_valid_sdram_s1_shift_register;
  wire             nios_f_data_master_read_data_valid_sys_clk_timer_s1;
  wire             nios_f_data_master_read_data_valid_sysid_control_slave;
  wire             nios_f_data_master_read_data_valid_watchdog_timer_s1;
  wire    [ 31: 0] nios_f_data_master_readdata;
  wire             nios_f_data_master_requests_epcs_epcs_control_port;
  wire             nios_f_data_master_requests_high_res_timer_s1;
  wire             nios_f_data_master_requests_jtag_uart_avalon_jtag_slave;
  wire             nios_f_data_master_requests_nios_f_jtag_debug_module;
  wire             nios_f_data_master_requests_pipeline_bridge_0_s1;
  wire             nios_f_data_master_requests_sdram_s1;
  wire             nios_f_data_master_requests_sys_clk_timer_s1;
  wire             nios_f_data_master_requests_sysid_control_slave;
  wire             nios_f_data_master_requests_watchdog_timer_s1;
  wire             nios_f_data_master_waitrequest;
  wire             nios_f_data_master_write;
  wire    [ 31: 0] nios_f_data_master_writedata;
  wire    [ 25: 0] nios_f_instruction_master_address;
  wire    [ 25: 0] nios_f_instruction_master_address_to_slave;
  wire    [  1: 0] nios_f_instruction_master_dbs_address;
  wire             nios_f_instruction_master_granted_epcs_epcs_control_port;
  wire             nios_f_instruction_master_granted_nios_f_jtag_debug_module;
  wire             nios_f_instruction_master_granted_pipeline_bridge_0_s1;
  wire             nios_f_instruction_master_granted_sdram_s1;
  wire             nios_f_instruction_master_latency_counter;
  wire             nios_f_instruction_master_qualified_request_epcs_epcs_control_port;
  wire             nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module;
  wire             nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1;
  wire             nios_f_instruction_master_qualified_request_sdram_s1;
  wire             nios_f_instruction_master_read;
  wire             nios_f_instruction_master_read_data_valid_epcs_epcs_control_port;
  wire             nios_f_instruction_master_read_data_valid_nios_f_jtag_debug_module;
  wire             nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1;
  wire             nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register;
  wire             nios_f_instruction_master_read_data_valid_sdram_s1;
  wire             nios_f_instruction_master_read_data_valid_sdram_s1_shift_register;
  wire    [ 31: 0] nios_f_instruction_master_readdata;
  wire             nios_f_instruction_master_readdatavalid;
  wire             nios_f_instruction_master_requests_epcs_epcs_control_port;
  wire             nios_f_instruction_master_requests_nios_f_jtag_debug_module;
  wire             nios_f_instruction_master_requests_pipeline_bridge_0_s1;
  wire             nios_f_instruction_master_requests_sdram_s1;
  wire             nios_f_instruction_master_waitrequest;
  wire    [  8: 0] nios_f_jtag_debug_module_address;
  wire             nios_f_jtag_debug_module_begintransfer;
  wire    [  3: 0] nios_f_jtag_debug_module_byteenable;
  wire             nios_f_jtag_debug_module_chipselect;
  wire             nios_f_jtag_debug_module_debugaccess;
  wire    [ 31: 0] nios_f_jtag_debug_module_readdata;
  wire    [ 31: 0] nios_f_jtag_debug_module_readdata_from_sa;
  wire             nios_f_jtag_debug_module_reset_n;
  wire             nios_f_jtag_debug_module_resetrequest;
  wire             nios_f_jtag_debug_module_resetrequest_from_sa;
  wire             nios_f_jtag_debug_module_write;
  wire    [ 31: 0] nios_f_jtag_debug_module_writedata;
  wire             out_port_from_the_ads_clk;
  wire             out_port_from_the_ads_din;
  wire             out_port_from_the_ads_ncs;
  wire             out_port_from_the_ili_ncs;
  wire             out_port_from_the_ili_nrd;
  wire             out_port_from_the_ili_nrst;
  wire             out_port_from_the_ili_nwr;
  wire             out_port_from_the_ili_rs;
  wire             out_port_from_the_sd_clk;
  wire             out_port_from_the_sd_din;
  wire             out_port_from_the_sd_ncs;
  wire    [  8: 0] pipeline_bridge_0_m1_address;
  wire    [  8: 0] pipeline_bridge_0_m1_address_to_slave;
  wire             pipeline_bridge_0_m1_burstcount;
  wire    [  3: 0] pipeline_bridge_0_m1_byteenable;
  wire             pipeline_bridge_0_m1_chipselect;
  wire             pipeline_bridge_0_m1_debugaccess;
  wire             pipeline_bridge_0_m1_endofpacket;
  wire             pipeline_bridge_0_m1_granted_ads_busy_s1;
  wire             pipeline_bridge_0_m1_granted_ads_clk_s1;
  wire             pipeline_bridge_0_m1_granted_ads_din_s1;
  wire             pipeline_bridge_0_m1_granted_ads_dout_s1;
  wire             pipeline_bridge_0_m1_granted_ads_ncs_s1;
  wire             pipeline_bridge_0_m1_granted_ads_nirq_s1;
  wire             pipeline_bridge_0_m1_granted_ili_db_s1;
  wire             pipeline_bridge_0_m1_granted_ili_ncs_s1;
  wire             pipeline_bridge_0_m1_granted_ili_nrd_s1;
  wire             pipeline_bridge_0_m1_granted_ili_nrst_s1;
  wire             pipeline_bridge_0_m1_granted_ili_nwr_s1;
  wire             pipeline_bridge_0_m1_granted_ili_rs_s1;
  wire             pipeline_bridge_0_m1_granted_sd_clk_s1;
  wire             pipeline_bridge_0_m1_granted_sd_din_s1;
  wire             pipeline_bridge_0_m1_granted_sd_dout_s1;
  wire             pipeline_bridge_0_m1_granted_sd_ncs_s1;
  wire             pipeline_bridge_0_m1_latency_counter;
  wire             pipeline_bridge_0_m1_qualified_request_ads_busy_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ads_clk_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ads_din_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ads_dout_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ads_ncs_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ads_nirq_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ili_db_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ili_ncs_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ili_nrd_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ili_nrst_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ili_nwr_s1;
  wire             pipeline_bridge_0_m1_qualified_request_ili_rs_s1;
  wire             pipeline_bridge_0_m1_qualified_request_sd_clk_s1;
  wire             pipeline_bridge_0_m1_qualified_request_sd_din_s1;
  wire             pipeline_bridge_0_m1_qualified_request_sd_dout_s1;
  wire             pipeline_bridge_0_m1_qualified_request_sd_ncs_s1;
  wire             pipeline_bridge_0_m1_read;
  wire             pipeline_bridge_0_m1_read_data_valid_ads_busy_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ads_clk_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ads_din_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ads_dout_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ads_ncs_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ads_nirq_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ili_db_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ili_ncs_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ili_nrd_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ili_nrst_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ili_nwr_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_ili_rs_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_sd_clk_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_sd_din_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_sd_dout_s1;
  wire             pipeline_bridge_0_m1_read_data_valid_sd_ncs_s1;
  wire    [ 31: 0] pipeline_bridge_0_m1_readdata;
  wire             pipeline_bridge_0_m1_readdatavalid;
  wire             pipeline_bridge_0_m1_requests_ads_busy_s1;
  wire             pipeline_bridge_0_m1_requests_ads_clk_s1;
  wire             pipeline_bridge_0_m1_requests_ads_din_s1;
  wire             pipeline_bridge_0_m1_requests_ads_dout_s1;
  wire             pipeline_bridge_0_m1_requests_ads_ncs_s1;
  wire             pipeline_bridge_0_m1_requests_ads_nirq_s1;
  wire             pipeline_bridge_0_m1_requests_ili_db_s1;
  wire             pipeline_bridge_0_m1_requests_ili_ncs_s1;
  wire             pipeline_bridge_0_m1_requests_ili_nrd_s1;
  wire             pipeline_bridge_0_m1_requests_ili_nrst_s1;
  wire             pipeline_bridge_0_m1_requests_ili_nwr_s1;
  wire             pipeline_bridge_0_m1_requests_ili_rs_s1;
  wire             pipeline_bridge_0_m1_requests_sd_clk_s1;
  wire             pipeline_bridge_0_m1_requests_sd_din_s1;
  wire             pipeline_bridge_0_m1_requests_sd_dout_s1;
  wire             pipeline_bridge_0_m1_requests_sd_ncs_s1;
  wire             pipeline_bridge_0_m1_waitrequest;
  wire             pipeline_bridge_0_m1_write;
  wire    [ 31: 0] pipeline_bridge_0_m1_writedata;
  wire    [  6: 0] pipeline_bridge_0_s1_address;
  wire             pipeline_bridge_0_s1_arbiterlock;
  wire             pipeline_bridge_0_s1_arbiterlock2;
  wire             pipeline_bridge_0_s1_burstcount;
  wire    [  3: 0] pipeline_bridge_0_s1_byteenable;
  wire             pipeline_bridge_0_s1_chipselect;
  wire             pipeline_bridge_0_s1_debugaccess;
  wire             pipeline_bridge_0_s1_endofpacket;
  wire             pipeline_bridge_0_s1_endofpacket_from_sa;
  wire    [  6: 0] pipeline_bridge_0_s1_nativeaddress;
  wire             pipeline_bridge_0_s1_read;
  wire    [ 31: 0] pipeline_bridge_0_s1_readdata;
  wire    [ 31: 0] pipeline_bridge_0_s1_readdata_from_sa;
  wire             pipeline_bridge_0_s1_readdatavalid;
  wire             pipeline_bridge_0_s1_reset_n;
  wire             pipeline_bridge_0_s1_waitrequest;
  wire             pipeline_bridge_0_s1_waitrequest_from_sa;
  wire             pipeline_bridge_0_s1_write;
  wire    [ 31: 0] pipeline_bridge_0_s1_writedata;
  wire             reset_n_sources;
  wire             sce_from_the_epcs;
  wire    [  1: 0] sd_clk_s1_address;
  wire             sd_clk_s1_chipselect;
  wire    [ 31: 0] sd_clk_s1_readdata;
  wire    [ 31: 0] sd_clk_s1_readdata_from_sa;
  wire             sd_clk_s1_reset_n;
  wire             sd_clk_s1_write_n;
  wire    [ 31: 0] sd_clk_s1_writedata;
  wire    [  1: 0] sd_din_s1_address;
  wire             sd_din_s1_chipselect;
  wire    [ 31: 0] sd_din_s1_readdata;
  wire    [ 31: 0] sd_din_s1_readdata_from_sa;
  wire             sd_din_s1_reset_n;
  wire             sd_din_s1_write_n;
  wire    [ 31: 0] sd_din_s1_writedata;
  wire    [  1: 0] sd_dout_s1_address;
  wire    [ 31: 0] sd_dout_s1_readdata;
  wire    [ 31: 0] sd_dout_s1_readdata_from_sa;
  wire             sd_dout_s1_reset_n;
  wire    [  1: 0] sd_ncs_s1_address;
  wire             sd_ncs_s1_chipselect;
  wire    [ 31: 0] sd_ncs_s1_readdata;
  wire    [ 31: 0] sd_ncs_s1_readdata_from_sa;
  wire             sd_ncs_s1_reset_n;
  wire             sd_ncs_s1_write_n;
  wire    [ 31: 0] sd_ncs_s1_writedata;
  wire             sdo_from_the_epcs;
  wire    [ 21: 0] sdram_s1_address;
  wire    [  1: 0] sdram_s1_byteenable_n;
  wire             sdram_s1_chipselect;
  wire             sdram_s1_read_n;
  wire    [ 15: 0] sdram_s1_readdata;
  wire    [ 15: 0] sdram_s1_readdata_from_sa;
  wire             sdram_s1_readdatavalid;
  wire             sdram_s1_reset_n;
  wire             sdram_s1_waitrequest;
  wire             sdram_s1_waitrequest_from_sa;
  wire             sdram_s1_write_n;
  wire    [ 15: 0] sdram_s1_writedata;
  wire    [  2: 0] sys_clk_timer_s1_address;
  wire             sys_clk_timer_s1_chipselect;
  wire             sys_clk_timer_s1_irq;
  wire             sys_clk_timer_s1_irq_from_sa;
  wire    [ 15: 0] sys_clk_timer_s1_readdata;
  wire    [ 15: 0] sys_clk_timer_s1_readdata_from_sa;
  wire             sys_clk_timer_s1_reset_n;
  wire             sys_clk_timer_s1_write_n;
  wire    [ 15: 0] sys_clk_timer_s1_writedata;
  wire             sysid_control_slave_address;
  wire             sysid_control_slave_clock;
  wire    [ 31: 0] sysid_control_slave_readdata;
  wire    [ 31: 0] sysid_control_slave_readdata_from_sa;
  wire             sysid_control_slave_reset_n;
  wire    [  2: 0] watchdog_timer_s1_address;
  wire             watchdog_timer_s1_chipselect;
  wire             watchdog_timer_s1_irq;
  wire             watchdog_timer_s1_irq_from_sa;
  wire    [ 15: 0] watchdog_timer_s1_readdata;
  wire    [ 15: 0] watchdog_timer_s1_readdata_from_sa;
  wire             watchdog_timer_s1_reset_n;
  wire             watchdog_timer_s1_resetrequest;
  wire             watchdog_timer_s1_resetrequest_from_sa;
  wire             watchdog_timer_s1_write_n;
  wire    [ 15: 0] watchdog_timer_s1_writedata;
  wire    [ 11: 0] zs_addr_from_the_sdram;
  wire    [  1: 0] zs_ba_from_the_sdram;
  wire             zs_cas_n_from_the_sdram;
  wire             zs_cke_from_the_sdram;
  wire             zs_cs_n_from_the_sdram;
  wire    [ 15: 0] zs_dq_to_and_from_the_sdram;
  wire    [  1: 0] zs_dqm_from_the_sdram;
  wire             zs_ras_n_from_the_sdram;
  wire             zs_we_n_from_the_sdram;
  ads_busy_s1_arbitrator the_ads_busy_s1
    (
      .ads_busy_s1_address                                (ads_busy_s1_address),
      .ads_busy_s1_readdata                               (ads_busy_s1_readdata),
      .ads_busy_s1_readdata_from_sa                       (ads_busy_s1_readdata_from_sa),
      .ads_busy_s1_reset_n                                (ads_busy_s1_reset_n),
      .clk                                                (clk_100),
      .d1_ads_busy_s1_end_xfer                            (d1_ads_busy_s1_end_xfer),
      .pipeline_bridge_0_m1_address_to_slave              (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                    (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                    (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_ads_busy_s1           (pipeline_bridge_0_m1_granted_ads_busy_s1),
      .pipeline_bridge_0_m1_latency_counter               (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_ads_busy_s1 (pipeline_bridge_0_m1_qualified_request_ads_busy_s1),
      .pipeline_bridge_0_m1_read                          (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_ads_busy_s1   (pipeline_bridge_0_m1_read_data_valid_ads_busy_s1),
      .pipeline_bridge_0_m1_requests_ads_busy_s1          (pipeline_bridge_0_m1_requests_ads_busy_s1),
      .pipeline_bridge_0_m1_write                         (pipeline_bridge_0_m1_write),
      .reset_n                                            (clk_100_reset_n)
    );

  ads_busy the_ads_busy
    (
      .address  (ads_busy_s1_address),
      .clk      (clk_100),
      .in_port  (in_port_to_the_ads_busy),
      .readdata (ads_busy_s1_readdata),
      .reset_n  (ads_busy_s1_reset_n)
    );

  ads_clk_s1_arbitrator the_ads_clk_s1
    (
      .ads_clk_s1_address                                (ads_clk_s1_address),
      .ads_clk_s1_chipselect                             (ads_clk_s1_chipselect),
      .ads_clk_s1_readdata                               (ads_clk_s1_readdata),
      .ads_clk_s1_readdata_from_sa                       (ads_clk_s1_readdata_from_sa),
      .ads_clk_s1_reset_n                                (ads_clk_s1_reset_n),
      .ads_clk_s1_write_n                                (ads_clk_s1_write_n),
      .ads_clk_s1_writedata                              (ads_clk_s1_writedata),
      .clk                                               (clk_100),
      .d1_ads_clk_s1_end_xfer                            (d1_ads_clk_s1_end_xfer),
      .pipeline_bridge_0_m1_address_to_slave             (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                   (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                   (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_ads_clk_s1           (pipeline_bridge_0_m1_granted_ads_clk_s1),
      .pipeline_bridge_0_m1_latency_counter              (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_ads_clk_s1 (pipeline_bridge_0_m1_qualified_request_ads_clk_s1),
      .pipeline_bridge_0_m1_read                         (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_ads_clk_s1   (pipeline_bridge_0_m1_read_data_valid_ads_clk_s1),
      .pipeline_bridge_0_m1_requests_ads_clk_s1          (pipeline_bridge_0_m1_requests_ads_clk_s1),
      .pipeline_bridge_0_m1_write                        (pipeline_bridge_0_m1_write),
      .pipeline_bridge_0_m1_writedata                    (pipeline_bridge_0_m1_writedata),
      .reset_n                                           (clk_100_reset_n)
    );

  ads_clk the_ads_clk
    (
      .address    (ads_clk_s1_address),
      .chipselect (ads_clk_s1_chipselect),
      .clk        (clk_100),
      .out_port   (out_port_from_the_ads_clk),
      .readdata   (ads_clk_s1_readdata),
      .reset_n    (ads_clk_s1_reset_n),
      .write_n    (ads_clk_s1_write_n),
      .writedata  (ads_clk_s1_writedata)
    );

  ads_din_s1_arbitrator the_ads_din_s1
    (
      .ads_din_s1_address                                (ads_din_s1_address),
      .ads_din_s1_chipselect                             (ads_din_s1_chipselect),
      .ads_din_s1_readdata                               (ads_din_s1_readdata),
      .ads_din_s1_readdata_from_sa                       (ads_din_s1_readdata_from_sa),
      .ads_din_s1_reset_n                                (ads_din_s1_reset_n),
      .ads_din_s1_write_n                                (ads_din_s1_write_n),
      .ads_din_s1_writedata                              (ads_din_s1_writedata),
      .clk                                               (clk_100),
      .d1_ads_din_s1_end_xfer                            (d1_ads_din_s1_end_xfer),
      .pipeline_bridge_0_m1_address_to_slave             (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                   (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                   (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_ads_din_s1           (pipeline_bridge_0_m1_granted_ads_din_s1),
      .pipeline_bridge_0_m1_latency_counter              (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_ads_din_s1 (pipeline_bridge_0_m1_qualified_request_ads_din_s1),
      .pipeline_bridge_0_m1_read                         (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_ads_din_s1   (pipeline_bridge_0_m1_read_data_valid_ads_din_s1),
      .pipeline_bridge_0_m1_requests_ads_din_s1          (pipeline_bridge_0_m1_requests_ads_din_s1),
      .pipeline_bridge_0_m1_write                        (pipeline_bridge_0_m1_write),
      .pipeline_bridge_0_m1_writedata                    (pipeline_bridge_0_m1_writedata),
      .reset_n                                           (clk_100_reset_n)
    );

  ads_din the_ads_din
    (
      .address    (ads_din_s1_address),
      .chipselect (ads_din_s1_chipselect),
      .clk        (clk_100),
      .out_port   (out_port_from_the_ads_din),
      .readdata   (ads_din_s1_readdata),
      .reset_n    (ads_din_s1_reset_n),
      .write_n    (ads_din_s1_write_n),
      .writedata  (ads_din_s1_writedata)
    );

  ads_dout_s1_arbitrator the_ads_dout_s1
    (
      .ads_dout_s1_address                                (ads_dout_s1_address),
      .ads_dout_s1_readdata                               (ads_dout_s1_readdata),
      .ads_dout_s1_readdata_from_sa                       (ads_dout_s1_readdata_from_sa),
      .ads_dout_s1_reset_n                                (ads_dout_s1_reset_n),
      .clk                                                (clk_100),
      .d1_ads_dout_s1_end_xfer                            (d1_ads_dout_s1_end_xfer),
      .pipeline_bridge_0_m1_address_to_slave              (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                    (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                    (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_ads_dout_s1           (pipeline_bridge_0_m1_granted_ads_dout_s1),
      .pipeline_bridge_0_m1_latency_counter               (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_ads_dout_s1 (pipeline_bridge_0_m1_qualified_request_ads_dout_s1),
      .pipeline_bridge_0_m1_read                          (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_ads_dout_s1   (pipeline_bridge_0_m1_read_data_valid_ads_dout_s1),
      .pipeline_bridge_0_m1_requests_ads_dout_s1          (pipeline_bridge_0_m1_requests_ads_dout_s1),
      .pipeline_bridge_0_m1_write                         (pipeline_bridge_0_m1_write),
      .reset_n                                            (clk_100_reset_n)
    );

  ads_dout the_ads_dout
    (
      .address  (ads_dout_s1_address),
      .clk      (clk_100),
      .in_port  (in_port_to_the_ads_dout),
      .readdata (ads_dout_s1_readdata),
      .reset_n  (ads_dout_s1_reset_n)
    );

  ads_ncs_s1_arbitrator the_ads_ncs_s1
    (
      .ads_ncs_s1_address                                (ads_ncs_s1_address),
      .ads_ncs_s1_chipselect                             (ads_ncs_s1_chipselect),
      .ads_ncs_s1_readdata                               (ads_ncs_s1_readdata),
      .ads_ncs_s1_readdata_from_sa                       (ads_ncs_s1_readdata_from_sa),
      .ads_ncs_s1_reset_n                                (ads_ncs_s1_reset_n),
      .ads_ncs_s1_write_n                                (ads_ncs_s1_write_n),
      .ads_ncs_s1_writedata                              (ads_ncs_s1_writedata),
      .clk                                               (clk_100),
      .d1_ads_ncs_s1_end_xfer                            (d1_ads_ncs_s1_end_xfer),
      .pipeline_bridge_0_m1_address_to_slave             (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                   (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                   (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_ads_ncs_s1           (pipeline_bridge_0_m1_granted_ads_ncs_s1),
      .pipeline_bridge_0_m1_latency_counter              (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_ads_ncs_s1 (pipeline_bridge_0_m1_qualified_request_ads_ncs_s1),
      .pipeline_bridge_0_m1_read                         (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_ads_ncs_s1   (pipeline_bridge_0_m1_read_data_valid_ads_ncs_s1),
      .pipeline_bridge_0_m1_requests_ads_ncs_s1          (pipeline_bridge_0_m1_requests_ads_ncs_s1),
      .pipeline_bridge_0_m1_write                        (pipeline_bridge_0_m1_write),
      .pipeline_bridge_0_m1_writedata                    (pipeline_bridge_0_m1_writedata),
      .reset_n                                           (clk_100_reset_n)
    );

  ads_ncs the_ads_ncs
    (
      .address    (ads_ncs_s1_address),
      .chipselect (ads_ncs_s1_chipselect),
      .clk        (clk_100),
      .out_port   (out_port_from_the_ads_ncs),
      .readdata   (ads_ncs_s1_readdata),
      .reset_n    (ads_ncs_s1_reset_n),
      .write_n    (ads_ncs_s1_write_n),
      .writedata  (ads_ncs_s1_writedata)
    );

  ads_nirq_s1_arbitrator the_ads_nirq_s1
    (
      .ads_nirq_s1_address                                (ads_nirq_s1_address),
      .ads_nirq_s1_chipselect                             (ads_nirq_s1_chipselect),
      .ads_nirq_s1_irq                                    (ads_nirq_s1_irq),
      .ads_nirq_s1_irq_from_sa                            (ads_nirq_s1_irq_from_sa),
      .ads_nirq_s1_readdata                               (ads_nirq_s1_readdata),
      .ads_nirq_s1_readdata_from_sa                       (ads_nirq_s1_readdata_from_sa),
      .ads_nirq_s1_reset_n                                (ads_nirq_s1_reset_n),
      .ads_nirq_s1_write_n                                (ads_nirq_s1_write_n),
      .ads_nirq_s1_writedata                              (ads_nirq_s1_writedata),
      .clk                                                (clk_100),
      .d1_ads_nirq_s1_end_xfer                            (d1_ads_nirq_s1_end_xfer),
      .pipeline_bridge_0_m1_address_to_slave              (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                    (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                    (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_ads_nirq_s1           (pipeline_bridge_0_m1_granted_ads_nirq_s1),
      .pipeline_bridge_0_m1_latency_counter               (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_ads_nirq_s1 (pipeline_bridge_0_m1_qualified_request_ads_nirq_s1),
      .pipeline_bridge_0_m1_read                          (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_ads_nirq_s1   (pipeline_bridge_0_m1_read_data_valid_ads_nirq_s1),
      .pipeline_bridge_0_m1_requests_ads_nirq_s1          (pipeline_bridge_0_m1_requests_ads_nirq_s1),
      .pipeline_bridge_0_m1_write                         (pipeline_bridge_0_m1_write),
      .pipeline_bridge_0_m1_writedata                     (pipeline_bridge_0_m1_writedata),
      .reset_n                                            (clk_100_reset_n)
    );

  ads_nirq the_ads_nirq
    (
      .address    (ads_nirq_s1_address),
      .chipselect (ads_nirq_s1_chipselect),
      .clk        (clk_100),
      .in_port    (in_port_to_the_ads_nirq),
      .irq        (ads_nirq_s1_irq),
      .readdata   (ads_nirq_s1_readdata),
      .reset_n    (ads_nirq_s1_reset_n),
      .write_n    (ads_nirq_s1_write_n),
      .writedata  (ads_nirq_s1_writedata)
    );

  epcs_epcs_control_port_arbitrator the_epcs_epcs_control_port
    (
      .clk                                                                           (clk_100),
      .d1_epcs_epcs_control_port_end_xfer                                            (d1_epcs_epcs_control_port_end_xfer),
      .epcs_epcs_control_port_address                                                (epcs_epcs_control_port_address),
      .epcs_epcs_control_port_chipselect                                             (epcs_epcs_control_port_chipselect),
      .epcs_epcs_control_port_dataavailable                                          (epcs_epcs_control_port_dataavailable),
      .epcs_epcs_control_port_dataavailable_from_sa                                  (epcs_epcs_control_port_dataavailable_from_sa),
      .epcs_epcs_control_port_endofpacket                                            (epcs_epcs_control_port_endofpacket),
      .epcs_epcs_control_port_endofpacket_from_sa                                    (epcs_epcs_control_port_endofpacket_from_sa),
      .epcs_epcs_control_port_irq                                                    (epcs_epcs_control_port_irq),
      .epcs_epcs_control_port_irq_from_sa                                            (epcs_epcs_control_port_irq_from_sa),
      .epcs_epcs_control_port_read_n                                                 (epcs_epcs_control_port_read_n),
      .epcs_epcs_control_port_readdata                                               (epcs_epcs_control_port_readdata),
      .epcs_epcs_control_port_readdata_from_sa                                       (epcs_epcs_control_port_readdata_from_sa),
      .epcs_epcs_control_port_readyfordata                                           (epcs_epcs_control_port_readyfordata),
      .epcs_epcs_control_port_readyfordata_from_sa                                   (epcs_epcs_control_port_readyfordata_from_sa),
      .epcs_epcs_control_port_reset_n                                                (epcs_epcs_control_port_reset_n),
      .epcs_epcs_control_port_write_n                                                (epcs_epcs_control_port_write_n),
      .epcs_epcs_control_port_writedata                                              (epcs_epcs_control_port_writedata),
      .nios_f_data_master_address_to_slave                                           (nios_f_data_master_address_to_slave),
      .nios_f_data_master_granted_epcs_epcs_control_port                             (nios_f_data_master_granted_epcs_epcs_control_port),
      .nios_f_data_master_qualified_request_epcs_epcs_control_port                   (nios_f_data_master_qualified_request_epcs_epcs_control_port),
      .nios_f_data_master_read                                                       (nios_f_data_master_read),
      .nios_f_data_master_read_data_valid_epcs_epcs_control_port                     (nios_f_data_master_read_data_valid_epcs_epcs_control_port),
      .nios_f_data_master_requests_epcs_epcs_control_port                            (nios_f_data_master_requests_epcs_epcs_control_port),
      .nios_f_data_master_write                                                      (nios_f_data_master_write),
      .nios_f_data_master_writedata                                                  (nios_f_data_master_writedata),
      .nios_f_instruction_master_address_to_slave                                    (nios_f_instruction_master_address_to_slave),
      .nios_f_instruction_master_granted_epcs_epcs_control_port                      (nios_f_instruction_master_granted_epcs_epcs_control_port),
      .nios_f_instruction_master_latency_counter                                     (nios_f_instruction_master_latency_counter),
      .nios_f_instruction_master_qualified_request_epcs_epcs_control_port            (nios_f_instruction_master_qualified_request_epcs_epcs_control_port),
      .nios_f_instruction_master_read                                                (nios_f_instruction_master_read),
      .nios_f_instruction_master_read_data_valid_epcs_epcs_control_port              (nios_f_instruction_master_read_data_valid_epcs_epcs_control_port),
      .nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register (nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register),
      .nios_f_instruction_master_read_data_valid_sdram_s1_shift_register             (nios_f_instruction_master_read_data_valid_sdram_s1_shift_register),
      .nios_f_instruction_master_requests_epcs_epcs_control_port                     (nios_f_instruction_master_requests_epcs_epcs_control_port),
      .reset_n                                                                       (clk_100_reset_n)
    );

  epcs the_epcs
    (
      .address       (epcs_epcs_control_port_address),
      .chipselect    (epcs_epcs_control_port_chipselect),
      .clk           (clk_100),
      .data0         (data0_to_the_epcs),
      .dataavailable (epcs_epcs_control_port_dataavailable),
      .dclk          (dclk_from_the_epcs),
      .endofpacket   (epcs_epcs_control_port_endofpacket),
      .irq           (epcs_epcs_control_port_irq),
      .read_n        (epcs_epcs_control_port_read_n),
      .readdata      (epcs_epcs_control_port_readdata),
      .readyfordata  (epcs_epcs_control_port_readyfordata),
      .reset_n       (epcs_epcs_control_port_reset_n),
      .sce           (sce_from_the_epcs),
      .sdo           (sdo_from_the_epcs),
      .write_n       (epcs_epcs_control_port_write_n),
      .writedata     (epcs_epcs_control_port_writedata)
    );

  high_res_timer_s1_arbitrator the_high_res_timer_s1
    (
      .clk                                                    (clk_100),
      .d1_high_res_timer_s1_end_xfer                          (d1_high_res_timer_s1_end_xfer),
      .high_res_timer_s1_address                              (high_res_timer_s1_address),
      .high_res_timer_s1_chipselect                           (high_res_timer_s1_chipselect),
      .high_res_timer_s1_irq                                  (high_res_timer_s1_irq),
      .high_res_timer_s1_irq_from_sa                          (high_res_timer_s1_irq_from_sa),
      .high_res_timer_s1_readdata                             (high_res_timer_s1_readdata),
      .high_res_timer_s1_readdata_from_sa                     (high_res_timer_s1_readdata_from_sa),
      .high_res_timer_s1_reset_n                              (high_res_timer_s1_reset_n),
      .high_res_timer_s1_write_n                              (high_res_timer_s1_write_n),
      .high_res_timer_s1_writedata                            (high_res_timer_s1_writedata),
      .nios_f_data_master_address_to_slave                    (nios_f_data_master_address_to_slave),
      .nios_f_data_master_granted_high_res_timer_s1           (nios_f_data_master_granted_high_res_timer_s1),
      .nios_f_data_master_qualified_request_high_res_timer_s1 (nios_f_data_master_qualified_request_high_res_timer_s1),
      .nios_f_data_master_read                                (nios_f_data_master_read),
      .nios_f_data_master_read_data_valid_high_res_timer_s1   (nios_f_data_master_read_data_valid_high_res_timer_s1),
      .nios_f_data_master_requests_high_res_timer_s1          (nios_f_data_master_requests_high_res_timer_s1),
      .nios_f_data_master_waitrequest                         (nios_f_data_master_waitrequest),
      .nios_f_data_master_write                               (nios_f_data_master_write),
      .nios_f_data_master_writedata                           (nios_f_data_master_writedata),
      .reset_n                                                (clk_100_reset_n)
    );

  high_res_timer the_high_res_timer
    (
      .address    (high_res_timer_s1_address),
      .chipselect (high_res_timer_s1_chipselect),
      .clk        (clk_100),
      .irq        (high_res_timer_s1_irq),
      .readdata   (high_res_timer_s1_readdata),
      .reset_n    (high_res_timer_s1_reset_n),
      .write_n    (high_res_timer_s1_write_n),
      .writedata  (high_res_timer_s1_writedata)
    );

  ili_db_s1_arbitrator the_ili_db_s1
    (
      .clk                                              (clk_100),
      .d1_ili_db_s1_end_xfer                            (d1_ili_db_s1_end_xfer),
      .ili_db_s1_address                                (ili_db_s1_address),
      .ili_db_s1_chipselect                             (ili_db_s1_chipselect),
      .ili_db_s1_readdata                               (ili_db_s1_readdata),
      .ili_db_s1_readdata_from_sa                       (ili_db_s1_readdata_from_sa),
      .ili_db_s1_reset_n                                (ili_db_s1_reset_n),
      .ili_db_s1_write_n                                (ili_db_s1_write_n),
      .ili_db_s1_writedata                              (ili_db_s1_writedata),
      .pipeline_bridge_0_m1_address_to_slave            (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                  (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                  (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_ili_db_s1           (pipeline_bridge_0_m1_granted_ili_db_s1),
      .pipeline_bridge_0_m1_latency_counter             (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_ili_db_s1 (pipeline_bridge_0_m1_qualified_request_ili_db_s1),
      .pipeline_bridge_0_m1_read                        (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_ili_db_s1   (pipeline_bridge_0_m1_read_data_valid_ili_db_s1),
      .pipeline_bridge_0_m1_requests_ili_db_s1          (pipeline_bridge_0_m1_requests_ili_db_s1),
      .pipeline_bridge_0_m1_write                       (pipeline_bridge_0_m1_write),
      .pipeline_bridge_0_m1_writedata                   (pipeline_bridge_0_m1_writedata),
      .reset_n                                          (clk_100_reset_n)
    );

  ili_db the_ili_db
    (
      .address    (ili_db_s1_address),
      .bidir_port (bidir_port_to_and_from_the_ili_db),
      .chipselect (ili_db_s1_chipselect),
      .clk        (clk_100),
      .readdata   (ili_db_s1_readdata),
      .reset_n    (ili_db_s1_reset_n),
      .write_n    (ili_db_s1_write_n),
      .writedata  (ili_db_s1_writedata)
    );

  ili_ncs_s1_arbitrator the_ili_ncs_s1
    (
      .clk                                               (clk_100),
      .d1_ili_ncs_s1_end_xfer                            (d1_ili_ncs_s1_end_xfer),
      .ili_ncs_s1_address                                (ili_ncs_s1_address),
      .ili_ncs_s1_chipselect                             (ili_ncs_s1_chipselect),
      .ili_ncs_s1_readdata                               (ili_ncs_s1_readdata),
      .ili_ncs_s1_readdata_from_sa                       (ili_ncs_s1_readdata_from_sa),
      .ili_ncs_s1_reset_n                                (ili_ncs_s1_reset_n),
      .ili_ncs_s1_write_n                                (ili_ncs_s1_write_n),
      .ili_ncs_s1_writedata                              (ili_ncs_s1_writedata),
      .pipeline_bridge_0_m1_address_to_slave             (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                   (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                   (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_ili_ncs_s1           (pipeline_bridge_0_m1_granted_ili_ncs_s1),
      .pipeline_bridge_0_m1_latency_counter              (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_ili_ncs_s1 (pipeline_bridge_0_m1_qualified_request_ili_ncs_s1),
      .pipeline_bridge_0_m1_read                         (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_ili_ncs_s1   (pipeline_bridge_0_m1_read_data_valid_ili_ncs_s1),
      .pipeline_bridge_0_m1_requests_ili_ncs_s1          (pipeline_bridge_0_m1_requests_ili_ncs_s1),
      .pipeline_bridge_0_m1_write                        (pipeline_bridge_0_m1_write),
      .pipeline_bridge_0_m1_writedata                    (pipeline_bridge_0_m1_writedata),
      .reset_n                                           (clk_100_reset_n)
    );

  ili_ncs the_ili_ncs
    (
      .address    (ili_ncs_s1_address),
      .chipselect (ili_ncs_s1_chipselect),
      .clk        (clk_100),
      .out_port   (out_port_from_the_ili_ncs),
      .readdata   (ili_ncs_s1_readdata),
      .reset_n    (ili_ncs_s1_reset_n),
      .write_n    (ili_ncs_s1_write_n),
      .writedata  (ili_ncs_s1_writedata)
    );

  ili_nrd_s1_arbitrator the_ili_nrd_s1
    (
      .clk                                               (clk_100),
      .d1_ili_nrd_s1_end_xfer                            (d1_ili_nrd_s1_end_xfer),
      .ili_nrd_s1_address                                (ili_nrd_s1_address),
      .ili_nrd_s1_chipselect                             (ili_nrd_s1_chipselect),
      .ili_nrd_s1_readdata                               (ili_nrd_s1_readdata),
      .ili_nrd_s1_readdata_from_sa                       (ili_nrd_s1_readdata_from_sa),
      .ili_nrd_s1_reset_n                                (ili_nrd_s1_reset_n),
      .ili_nrd_s1_write_n                                (ili_nrd_s1_write_n),
      .ili_nrd_s1_writedata                              (ili_nrd_s1_writedata),
      .pipeline_bridge_0_m1_address_to_slave             (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                   (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                   (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_ili_nrd_s1           (pipeline_bridge_0_m1_granted_ili_nrd_s1),
      .pipeline_bridge_0_m1_latency_counter              (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_ili_nrd_s1 (pipeline_bridge_0_m1_qualified_request_ili_nrd_s1),
      .pipeline_bridge_0_m1_read                         (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_ili_nrd_s1   (pipeline_bridge_0_m1_read_data_valid_ili_nrd_s1),
      .pipeline_bridge_0_m1_requests_ili_nrd_s1          (pipeline_bridge_0_m1_requests_ili_nrd_s1),
      .pipeline_bridge_0_m1_write                        (pipeline_bridge_0_m1_write),
      .pipeline_bridge_0_m1_writedata                    (pipeline_bridge_0_m1_writedata),
      .reset_n                                           (clk_100_reset_n)
    );

  ili_nrd the_ili_nrd
    (
      .address    (ili_nrd_s1_address),
      .chipselect (ili_nrd_s1_chipselect),
      .clk        (clk_100),
      .out_port   (out_port_from_the_ili_nrd),
      .readdata   (ili_nrd_s1_readdata),
      .reset_n    (ili_nrd_s1_reset_n),
      .write_n    (ili_nrd_s1_write_n),
      .writedata  (ili_nrd_s1_writedata)
    );

  ili_nrst_s1_arbitrator the_ili_nrst_s1
    (
      .clk                                                (clk_100),
      .d1_ili_nrst_s1_end_xfer                            (d1_ili_nrst_s1_end_xfer),
      .ili_nrst_s1_address                                (ili_nrst_s1_address),
      .ili_nrst_s1_chipselect                             (ili_nrst_s1_chipselect),
      .ili_nrst_s1_readdata                               (ili_nrst_s1_readdata),
      .ili_nrst_s1_readdata_from_sa                       (ili_nrst_s1_readdata_from_sa),
      .ili_nrst_s1_reset_n                                (ili_nrst_s1_reset_n),
      .ili_nrst_s1_write_n                                (ili_nrst_s1_write_n),
      .ili_nrst_s1_writedata                              (ili_nrst_s1_writedata),
      .pipeline_bridge_0_m1_address_to_slave              (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                    (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                    (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_ili_nrst_s1           (pipeline_bridge_0_m1_granted_ili_nrst_s1),
      .pipeline_bridge_0_m1_latency_counter               (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_ili_nrst_s1 (pipeline_bridge_0_m1_qualified_request_ili_nrst_s1),
      .pipeline_bridge_0_m1_read                          (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_ili_nrst_s1   (pipeline_bridge_0_m1_read_data_valid_ili_nrst_s1),
      .pipeline_bridge_0_m1_requests_ili_nrst_s1          (pipeline_bridge_0_m1_requests_ili_nrst_s1),
      .pipeline_bridge_0_m1_write                         (pipeline_bridge_0_m1_write),
      .pipeline_bridge_0_m1_writedata                     (pipeline_bridge_0_m1_writedata),
      .reset_n                                            (clk_100_reset_n)
    );

  ili_nrst the_ili_nrst
    (
      .address    (ili_nrst_s1_address),
      .chipselect (ili_nrst_s1_chipselect),
      .clk        (clk_100),
      .out_port   (out_port_from_the_ili_nrst),
      .readdata   (ili_nrst_s1_readdata),
      .reset_n    (ili_nrst_s1_reset_n),
      .write_n    (ili_nrst_s1_write_n),
      .writedata  (ili_nrst_s1_writedata)
    );

  ili_nwr_s1_arbitrator the_ili_nwr_s1
    (
      .clk                                               (clk_100),
      .d1_ili_nwr_s1_end_xfer                            (d1_ili_nwr_s1_end_xfer),
      .ili_nwr_s1_address                                (ili_nwr_s1_address),
      .ili_nwr_s1_chipselect                             (ili_nwr_s1_chipselect),
      .ili_nwr_s1_readdata                               (ili_nwr_s1_readdata),
      .ili_nwr_s1_readdata_from_sa                       (ili_nwr_s1_readdata_from_sa),
      .ili_nwr_s1_reset_n                                (ili_nwr_s1_reset_n),
      .ili_nwr_s1_write_n                                (ili_nwr_s1_write_n),
      .ili_nwr_s1_writedata                              (ili_nwr_s1_writedata),
      .pipeline_bridge_0_m1_address_to_slave             (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                   (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                   (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_ili_nwr_s1           (pipeline_bridge_0_m1_granted_ili_nwr_s1),
      .pipeline_bridge_0_m1_latency_counter              (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_ili_nwr_s1 (pipeline_bridge_0_m1_qualified_request_ili_nwr_s1),
      .pipeline_bridge_0_m1_read                         (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_ili_nwr_s1   (pipeline_bridge_0_m1_read_data_valid_ili_nwr_s1),
      .pipeline_bridge_0_m1_requests_ili_nwr_s1          (pipeline_bridge_0_m1_requests_ili_nwr_s1),
      .pipeline_bridge_0_m1_write                        (pipeline_bridge_0_m1_write),
      .pipeline_bridge_0_m1_writedata                    (pipeline_bridge_0_m1_writedata),
      .reset_n                                           (clk_100_reset_n)
    );

  ili_nwr the_ili_nwr
    (
      .address    (ili_nwr_s1_address),
      .chipselect (ili_nwr_s1_chipselect),
      .clk        (clk_100),
      .out_port   (out_port_from_the_ili_nwr),
      .readdata   (ili_nwr_s1_readdata),
      .reset_n    (ili_nwr_s1_reset_n),
      .write_n    (ili_nwr_s1_write_n),
      .writedata  (ili_nwr_s1_writedata)
    );

  ili_rs_s1_arbitrator the_ili_rs_s1
    (
      .clk                                              (clk_100),
      .d1_ili_rs_s1_end_xfer                            (d1_ili_rs_s1_end_xfer),
      .ili_rs_s1_address                                (ili_rs_s1_address),
      .ili_rs_s1_chipselect                             (ili_rs_s1_chipselect),
      .ili_rs_s1_readdata                               (ili_rs_s1_readdata),
      .ili_rs_s1_readdata_from_sa                       (ili_rs_s1_readdata_from_sa),
      .ili_rs_s1_reset_n                                (ili_rs_s1_reset_n),
      .ili_rs_s1_write_n                                (ili_rs_s1_write_n),
      .ili_rs_s1_writedata                              (ili_rs_s1_writedata),
      .pipeline_bridge_0_m1_address_to_slave            (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                  (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                  (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_ili_rs_s1           (pipeline_bridge_0_m1_granted_ili_rs_s1),
      .pipeline_bridge_0_m1_latency_counter             (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_ili_rs_s1 (pipeline_bridge_0_m1_qualified_request_ili_rs_s1),
      .pipeline_bridge_0_m1_read                        (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_ili_rs_s1   (pipeline_bridge_0_m1_read_data_valid_ili_rs_s1),
      .pipeline_bridge_0_m1_requests_ili_rs_s1          (pipeline_bridge_0_m1_requests_ili_rs_s1),
      .pipeline_bridge_0_m1_write                       (pipeline_bridge_0_m1_write),
      .pipeline_bridge_0_m1_writedata                   (pipeline_bridge_0_m1_writedata),
      .reset_n                                          (clk_100_reset_n)
    );

  ili_rs the_ili_rs
    (
      .address    (ili_rs_s1_address),
      .chipselect (ili_rs_s1_chipselect),
      .clk        (clk_100),
      .out_port   (out_port_from_the_ili_rs),
      .readdata   (ili_rs_s1_readdata),
      .reset_n    (ili_rs_s1_reset_n),
      .write_n    (ili_rs_s1_write_n),
      .writedata  (ili_rs_s1_writedata)
    );

  jtag_uart_avalon_jtag_slave_arbitrator the_jtag_uart_avalon_jtag_slave
    (
      .clk                                                              (clk_100),
      .d1_jtag_uart_avalon_jtag_slave_end_xfer                          (d1_jtag_uart_avalon_jtag_slave_end_xfer),
      .jtag_uart_avalon_jtag_slave_address                              (jtag_uart_avalon_jtag_slave_address),
      .jtag_uart_avalon_jtag_slave_chipselect                           (jtag_uart_avalon_jtag_slave_chipselect),
      .jtag_uart_avalon_jtag_slave_dataavailable                        (jtag_uart_avalon_jtag_slave_dataavailable),
      .jtag_uart_avalon_jtag_slave_dataavailable_from_sa                (jtag_uart_avalon_jtag_slave_dataavailable_from_sa),
      .jtag_uart_avalon_jtag_slave_irq                                  (jtag_uart_avalon_jtag_slave_irq),
      .jtag_uart_avalon_jtag_slave_irq_from_sa                          (jtag_uart_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_avalon_jtag_slave_read_n                               (jtag_uart_avalon_jtag_slave_read_n),
      .jtag_uart_avalon_jtag_slave_readdata                             (jtag_uart_avalon_jtag_slave_readdata),
      .jtag_uart_avalon_jtag_slave_readdata_from_sa                     (jtag_uart_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_avalon_jtag_slave_readyfordata                         (jtag_uart_avalon_jtag_slave_readyfordata),
      .jtag_uart_avalon_jtag_slave_readyfordata_from_sa                 (jtag_uart_avalon_jtag_slave_readyfordata_from_sa),
      .jtag_uart_avalon_jtag_slave_reset_n                              (jtag_uart_avalon_jtag_slave_reset_n),
      .jtag_uart_avalon_jtag_slave_waitrequest                          (jtag_uart_avalon_jtag_slave_waitrequest),
      .jtag_uart_avalon_jtag_slave_waitrequest_from_sa                  (jtag_uart_avalon_jtag_slave_waitrequest_from_sa),
      .jtag_uart_avalon_jtag_slave_write_n                              (jtag_uart_avalon_jtag_slave_write_n),
      .jtag_uart_avalon_jtag_slave_writedata                            (jtag_uart_avalon_jtag_slave_writedata),
      .nios_f_data_master_address_to_slave                              (nios_f_data_master_address_to_slave),
      .nios_f_data_master_granted_jtag_uart_avalon_jtag_slave           (nios_f_data_master_granted_jtag_uart_avalon_jtag_slave),
      .nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave (nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave),
      .nios_f_data_master_read                                          (nios_f_data_master_read),
      .nios_f_data_master_read_data_valid_jtag_uart_avalon_jtag_slave   (nios_f_data_master_read_data_valid_jtag_uart_avalon_jtag_slave),
      .nios_f_data_master_requests_jtag_uart_avalon_jtag_slave          (nios_f_data_master_requests_jtag_uart_avalon_jtag_slave),
      .nios_f_data_master_waitrequest                                   (nios_f_data_master_waitrequest),
      .nios_f_data_master_write                                         (nios_f_data_master_write),
      .nios_f_data_master_writedata                                     (nios_f_data_master_writedata),
      .reset_n                                                          (clk_100_reset_n)
    );

  jtag_uart the_jtag_uart
    (
      .av_address     (jtag_uart_avalon_jtag_slave_address),
      .av_chipselect  (jtag_uart_avalon_jtag_slave_chipselect),
      .av_irq         (jtag_uart_avalon_jtag_slave_irq),
      .av_read_n      (jtag_uart_avalon_jtag_slave_read_n),
      .av_readdata    (jtag_uart_avalon_jtag_slave_readdata),
      .av_waitrequest (jtag_uart_avalon_jtag_slave_waitrequest),
      .av_write_n     (jtag_uart_avalon_jtag_slave_write_n),
      .av_writedata   (jtag_uart_avalon_jtag_slave_writedata),
      .clk            (clk_100),
      .dataavailable  (jtag_uart_avalon_jtag_slave_dataavailable),
      .readyfordata   (jtag_uart_avalon_jtag_slave_readyfordata),
      .rst_n          (jtag_uart_avalon_jtag_slave_reset_n)
    );

  nios_f_jtag_debug_module_arbitrator the_nios_f_jtag_debug_module
    (
      .clk                                                                           (clk_100),
      .d1_nios_f_jtag_debug_module_end_xfer                                          (d1_nios_f_jtag_debug_module_end_xfer),
      .nios_f_data_master_address_to_slave                                           (nios_f_data_master_address_to_slave),
      .nios_f_data_master_byteenable                                                 (nios_f_data_master_byteenable),
      .nios_f_data_master_debugaccess                                                (nios_f_data_master_debugaccess),
      .nios_f_data_master_granted_nios_f_jtag_debug_module                           (nios_f_data_master_granted_nios_f_jtag_debug_module),
      .nios_f_data_master_qualified_request_nios_f_jtag_debug_module                 (nios_f_data_master_qualified_request_nios_f_jtag_debug_module),
      .nios_f_data_master_read                                                       (nios_f_data_master_read),
      .nios_f_data_master_read_data_valid_nios_f_jtag_debug_module                   (nios_f_data_master_read_data_valid_nios_f_jtag_debug_module),
      .nios_f_data_master_requests_nios_f_jtag_debug_module                          (nios_f_data_master_requests_nios_f_jtag_debug_module),
      .nios_f_data_master_waitrequest                                                (nios_f_data_master_waitrequest),
      .nios_f_data_master_write                                                      (nios_f_data_master_write),
      .nios_f_data_master_writedata                                                  (nios_f_data_master_writedata),
      .nios_f_instruction_master_address_to_slave                                    (nios_f_instruction_master_address_to_slave),
      .nios_f_instruction_master_granted_nios_f_jtag_debug_module                    (nios_f_instruction_master_granted_nios_f_jtag_debug_module),
      .nios_f_instruction_master_latency_counter                                     (nios_f_instruction_master_latency_counter),
      .nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module          (nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module),
      .nios_f_instruction_master_read                                                (nios_f_instruction_master_read),
      .nios_f_instruction_master_read_data_valid_nios_f_jtag_debug_module            (nios_f_instruction_master_read_data_valid_nios_f_jtag_debug_module),
      .nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register (nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register),
      .nios_f_instruction_master_read_data_valid_sdram_s1_shift_register             (nios_f_instruction_master_read_data_valid_sdram_s1_shift_register),
      .nios_f_instruction_master_requests_nios_f_jtag_debug_module                   (nios_f_instruction_master_requests_nios_f_jtag_debug_module),
      .nios_f_jtag_debug_module_address                                              (nios_f_jtag_debug_module_address),
      .nios_f_jtag_debug_module_begintransfer                                        (nios_f_jtag_debug_module_begintransfer),
      .nios_f_jtag_debug_module_byteenable                                           (nios_f_jtag_debug_module_byteenable),
      .nios_f_jtag_debug_module_chipselect                                           (nios_f_jtag_debug_module_chipselect),
      .nios_f_jtag_debug_module_debugaccess                                          (nios_f_jtag_debug_module_debugaccess),
      .nios_f_jtag_debug_module_readdata                                             (nios_f_jtag_debug_module_readdata),
      .nios_f_jtag_debug_module_readdata_from_sa                                     (nios_f_jtag_debug_module_readdata_from_sa),
      .nios_f_jtag_debug_module_reset_n                                              (nios_f_jtag_debug_module_reset_n),
      .nios_f_jtag_debug_module_resetrequest                                         (nios_f_jtag_debug_module_resetrequest),
      .nios_f_jtag_debug_module_resetrequest_from_sa                                 (nios_f_jtag_debug_module_resetrequest_from_sa),
      .nios_f_jtag_debug_module_write                                                (nios_f_jtag_debug_module_write),
      .nios_f_jtag_debug_module_writedata                                            (nios_f_jtag_debug_module_writedata),
      .reset_n                                                                       (clk_100_reset_n)
    );

  nios_f_data_master_arbitrator the_nios_f_data_master
    (
      .ads_nirq_s1_irq_from_sa                                                (ads_nirq_s1_irq_from_sa),
      .clk                                                                    (clk_100),
      .d1_epcs_epcs_control_port_end_xfer                                     (d1_epcs_epcs_control_port_end_xfer),
      .d1_high_res_timer_s1_end_xfer                                          (d1_high_res_timer_s1_end_xfer),
      .d1_jtag_uart_avalon_jtag_slave_end_xfer                                (d1_jtag_uart_avalon_jtag_slave_end_xfer),
      .d1_nios_f_jtag_debug_module_end_xfer                                   (d1_nios_f_jtag_debug_module_end_xfer),
      .d1_pipeline_bridge_0_s1_end_xfer                                       (d1_pipeline_bridge_0_s1_end_xfer),
      .d1_sdram_s1_end_xfer                                                   (d1_sdram_s1_end_xfer),
      .d1_sys_clk_timer_s1_end_xfer                                           (d1_sys_clk_timer_s1_end_xfer),
      .d1_sysid_control_slave_end_xfer                                        (d1_sysid_control_slave_end_xfer),
      .d1_watchdog_timer_s1_end_xfer                                          (d1_watchdog_timer_s1_end_xfer),
      .epcs_epcs_control_port_irq_from_sa                                     (epcs_epcs_control_port_irq_from_sa),
      .epcs_epcs_control_port_readdata_from_sa                                (epcs_epcs_control_port_readdata_from_sa),
      .high_res_timer_s1_irq_from_sa                                          (high_res_timer_s1_irq_from_sa),
      .high_res_timer_s1_readdata_from_sa                                     (high_res_timer_s1_readdata_from_sa),
      .jtag_uart_avalon_jtag_slave_irq_from_sa                                (jtag_uart_avalon_jtag_slave_irq_from_sa),
      .jtag_uart_avalon_jtag_slave_readdata_from_sa                           (jtag_uart_avalon_jtag_slave_readdata_from_sa),
      .jtag_uart_avalon_jtag_slave_waitrequest_from_sa                        (jtag_uart_avalon_jtag_slave_waitrequest_from_sa),
      .nios_f_data_master_address                                             (nios_f_data_master_address),
      .nios_f_data_master_address_to_slave                                    (nios_f_data_master_address_to_slave),
      .nios_f_data_master_byteenable_sdram_s1                                 (nios_f_data_master_byteenable_sdram_s1),
      .nios_f_data_master_dbs_address                                         (nios_f_data_master_dbs_address),
      .nios_f_data_master_dbs_write_16                                        (nios_f_data_master_dbs_write_16),
      .nios_f_data_master_granted_epcs_epcs_control_port                      (nios_f_data_master_granted_epcs_epcs_control_port),
      .nios_f_data_master_granted_high_res_timer_s1                           (nios_f_data_master_granted_high_res_timer_s1),
      .nios_f_data_master_granted_jtag_uart_avalon_jtag_slave                 (nios_f_data_master_granted_jtag_uart_avalon_jtag_slave),
      .nios_f_data_master_granted_nios_f_jtag_debug_module                    (nios_f_data_master_granted_nios_f_jtag_debug_module),
      .nios_f_data_master_granted_pipeline_bridge_0_s1                        (nios_f_data_master_granted_pipeline_bridge_0_s1),
      .nios_f_data_master_granted_sdram_s1                                    (nios_f_data_master_granted_sdram_s1),
      .nios_f_data_master_granted_sys_clk_timer_s1                            (nios_f_data_master_granted_sys_clk_timer_s1),
      .nios_f_data_master_granted_sysid_control_slave                         (nios_f_data_master_granted_sysid_control_slave),
      .nios_f_data_master_granted_watchdog_timer_s1                           (nios_f_data_master_granted_watchdog_timer_s1),
      .nios_f_data_master_irq                                                 (nios_f_data_master_irq),
      .nios_f_data_master_no_byte_enables_and_last_term                       (nios_f_data_master_no_byte_enables_and_last_term),
      .nios_f_data_master_qualified_request_epcs_epcs_control_port            (nios_f_data_master_qualified_request_epcs_epcs_control_port),
      .nios_f_data_master_qualified_request_high_res_timer_s1                 (nios_f_data_master_qualified_request_high_res_timer_s1),
      .nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave       (nios_f_data_master_qualified_request_jtag_uart_avalon_jtag_slave),
      .nios_f_data_master_qualified_request_nios_f_jtag_debug_module          (nios_f_data_master_qualified_request_nios_f_jtag_debug_module),
      .nios_f_data_master_qualified_request_pipeline_bridge_0_s1              (nios_f_data_master_qualified_request_pipeline_bridge_0_s1),
      .nios_f_data_master_qualified_request_sdram_s1                          (nios_f_data_master_qualified_request_sdram_s1),
      .nios_f_data_master_qualified_request_sys_clk_timer_s1                  (nios_f_data_master_qualified_request_sys_clk_timer_s1),
      .nios_f_data_master_qualified_request_sysid_control_slave               (nios_f_data_master_qualified_request_sysid_control_slave),
      .nios_f_data_master_qualified_request_watchdog_timer_s1                 (nios_f_data_master_qualified_request_watchdog_timer_s1),
      .nios_f_data_master_read                                                (nios_f_data_master_read),
      .nios_f_data_master_read_data_valid_epcs_epcs_control_port              (nios_f_data_master_read_data_valid_epcs_epcs_control_port),
      .nios_f_data_master_read_data_valid_high_res_timer_s1                   (nios_f_data_master_read_data_valid_high_res_timer_s1),
      .nios_f_data_master_read_data_valid_jtag_uart_avalon_jtag_slave         (nios_f_data_master_read_data_valid_jtag_uart_avalon_jtag_slave),
      .nios_f_data_master_read_data_valid_nios_f_jtag_debug_module            (nios_f_data_master_read_data_valid_nios_f_jtag_debug_module),
      .nios_f_data_master_read_data_valid_pipeline_bridge_0_s1                (nios_f_data_master_read_data_valid_pipeline_bridge_0_s1),
      .nios_f_data_master_read_data_valid_pipeline_bridge_0_s1_shift_register (nios_f_data_master_read_data_valid_pipeline_bridge_0_s1_shift_register),
      .nios_f_data_master_read_data_valid_sdram_s1                            (nios_f_data_master_read_data_valid_sdram_s1),
      .nios_f_data_master_read_data_valid_sdram_s1_shift_register             (nios_f_data_master_read_data_valid_sdram_s1_shift_register),
      .nios_f_data_master_read_data_valid_sys_clk_timer_s1                    (nios_f_data_master_read_data_valid_sys_clk_timer_s1),
      .nios_f_data_master_read_data_valid_sysid_control_slave                 (nios_f_data_master_read_data_valid_sysid_control_slave),
      .nios_f_data_master_read_data_valid_watchdog_timer_s1                   (nios_f_data_master_read_data_valid_watchdog_timer_s1),
      .nios_f_data_master_readdata                                            (nios_f_data_master_readdata),
      .nios_f_data_master_requests_epcs_epcs_control_port                     (nios_f_data_master_requests_epcs_epcs_control_port),
      .nios_f_data_master_requests_high_res_timer_s1                          (nios_f_data_master_requests_high_res_timer_s1),
      .nios_f_data_master_requests_jtag_uart_avalon_jtag_slave                (nios_f_data_master_requests_jtag_uart_avalon_jtag_slave),
      .nios_f_data_master_requests_nios_f_jtag_debug_module                   (nios_f_data_master_requests_nios_f_jtag_debug_module),
      .nios_f_data_master_requests_pipeline_bridge_0_s1                       (nios_f_data_master_requests_pipeline_bridge_0_s1),
      .nios_f_data_master_requests_sdram_s1                                   (nios_f_data_master_requests_sdram_s1),
      .nios_f_data_master_requests_sys_clk_timer_s1                           (nios_f_data_master_requests_sys_clk_timer_s1),
      .nios_f_data_master_requests_sysid_control_slave                        (nios_f_data_master_requests_sysid_control_slave),
      .nios_f_data_master_requests_watchdog_timer_s1                          (nios_f_data_master_requests_watchdog_timer_s1),
      .nios_f_data_master_waitrequest                                         (nios_f_data_master_waitrequest),
      .nios_f_data_master_write                                               (nios_f_data_master_write),
      .nios_f_data_master_writedata                                           (nios_f_data_master_writedata),
      .nios_f_jtag_debug_module_readdata_from_sa                              (nios_f_jtag_debug_module_readdata_from_sa),
      .pipeline_bridge_0_s1_readdata_from_sa                                  (pipeline_bridge_0_s1_readdata_from_sa),
      .pipeline_bridge_0_s1_waitrequest_from_sa                               (pipeline_bridge_0_s1_waitrequest_from_sa),
      .reset_n                                                                (clk_100_reset_n),
      .sdram_s1_readdata_from_sa                                              (sdram_s1_readdata_from_sa),
      .sdram_s1_waitrequest_from_sa                                           (sdram_s1_waitrequest_from_sa),
      .sys_clk_timer_s1_irq_from_sa                                           (sys_clk_timer_s1_irq_from_sa),
      .sys_clk_timer_s1_readdata_from_sa                                      (sys_clk_timer_s1_readdata_from_sa),
      .sysid_control_slave_readdata_from_sa                                   (sysid_control_slave_readdata_from_sa),
      .watchdog_timer_s1_irq_from_sa                                          (watchdog_timer_s1_irq_from_sa),
      .watchdog_timer_s1_readdata_from_sa                                     (watchdog_timer_s1_readdata_from_sa)
    );

  nios_f_instruction_master_arbitrator the_nios_f_instruction_master
    (
      .clk                                                                           (clk_100),
      .d1_epcs_epcs_control_port_end_xfer                                            (d1_epcs_epcs_control_port_end_xfer),
      .d1_nios_f_jtag_debug_module_end_xfer                                          (d1_nios_f_jtag_debug_module_end_xfer),
      .d1_pipeline_bridge_0_s1_end_xfer                                              (d1_pipeline_bridge_0_s1_end_xfer),
      .d1_sdram_s1_end_xfer                                                          (d1_sdram_s1_end_xfer),
      .epcs_epcs_control_port_readdata_from_sa                                       (epcs_epcs_control_port_readdata_from_sa),
      .nios_f_instruction_master_address                                             (nios_f_instruction_master_address),
      .nios_f_instruction_master_address_to_slave                                    (nios_f_instruction_master_address_to_slave),
      .nios_f_instruction_master_dbs_address                                         (nios_f_instruction_master_dbs_address),
      .nios_f_instruction_master_granted_epcs_epcs_control_port                      (nios_f_instruction_master_granted_epcs_epcs_control_port),
      .nios_f_instruction_master_granted_nios_f_jtag_debug_module                    (nios_f_instruction_master_granted_nios_f_jtag_debug_module),
      .nios_f_instruction_master_granted_pipeline_bridge_0_s1                        (nios_f_instruction_master_granted_pipeline_bridge_0_s1),
      .nios_f_instruction_master_granted_sdram_s1                                    (nios_f_instruction_master_granted_sdram_s1),
      .nios_f_instruction_master_latency_counter                                     (nios_f_instruction_master_latency_counter),
      .nios_f_instruction_master_qualified_request_epcs_epcs_control_port            (nios_f_instruction_master_qualified_request_epcs_epcs_control_port),
      .nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module          (nios_f_instruction_master_qualified_request_nios_f_jtag_debug_module),
      .nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1              (nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1),
      .nios_f_instruction_master_qualified_request_sdram_s1                          (nios_f_instruction_master_qualified_request_sdram_s1),
      .nios_f_instruction_master_read                                                (nios_f_instruction_master_read),
      .nios_f_instruction_master_read_data_valid_epcs_epcs_control_port              (nios_f_instruction_master_read_data_valid_epcs_epcs_control_port),
      .nios_f_instruction_master_read_data_valid_nios_f_jtag_debug_module            (nios_f_instruction_master_read_data_valid_nios_f_jtag_debug_module),
      .nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1                (nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1),
      .nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register (nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register),
      .nios_f_instruction_master_read_data_valid_sdram_s1                            (nios_f_instruction_master_read_data_valid_sdram_s1),
      .nios_f_instruction_master_read_data_valid_sdram_s1_shift_register             (nios_f_instruction_master_read_data_valid_sdram_s1_shift_register),
      .nios_f_instruction_master_readdata                                            (nios_f_instruction_master_readdata),
      .nios_f_instruction_master_readdatavalid                                       (nios_f_instruction_master_readdatavalid),
      .nios_f_instruction_master_requests_epcs_epcs_control_port                     (nios_f_instruction_master_requests_epcs_epcs_control_port),
      .nios_f_instruction_master_requests_nios_f_jtag_debug_module                   (nios_f_instruction_master_requests_nios_f_jtag_debug_module),
      .nios_f_instruction_master_requests_pipeline_bridge_0_s1                       (nios_f_instruction_master_requests_pipeline_bridge_0_s1),
      .nios_f_instruction_master_requests_sdram_s1                                   (nios_f_instruction_master_requests_sdram_s1),
      .nios_f_instruction_master_waitrequest                                         (nios_f_instruction_master_waitrequest),
      .nios_f_jtag_debug_module_readdata_from_sa                                     (nios_f_jtag_debug_module_readdata_from_sa),
      .pipeline_bridge_0_s1_readdata_from_sa                                         (pipeline_bridge_0_s1_readdata_from_sa),
      .pipeline_bridge_0_s1_waitrequest_from_sa                                      (pipeline_bridge_0_s1_waitrequest_from_sa),
      .reset_n                                                                       (clk_100_reset_n),
      .sdram_s1_readdata_from_sa                                                     (sdram_s1_readdata_from_sa),
      .sdram_s1_waitrequest_from_sa                                                  (sdram_s1_waitrequest_from_sa)
    );

  nios_f the_nios_f
    (
      .clk                                   (clk_100),
      .d_address                             (nios_f_data_master_address),
      .d_byteenable                          (nios_f_data_master_byteenable),
      .d_irq                                 (nios_f_data_master_irq),
      .d_read                                (nios_f_data_master_read),
      .d_readdata                            (nios_f_data_master_readdata),
      .d_waitrequest                         (nios_f_data_master_waitrequest),
      .d_write                               (nios_f_data_master_write),
      .d_writedata                           (nios_f_data_master_writedata),
      .i_address                             (nios_f_instruction_master_address),
      .i_read                                (nios_f_instruction_master_read),
      .i_readdata                            (nios_f_instruction_master_readdata),
      .i_readdatavalid                       (nios_f_instruction_master_readdatavalid),
      .i_waitrequest                         (nios_f_instruction_master_waitrequest),
      .jtag_debug_module_address             (nios_f_jtag_debug_module_address),
      .jtag_debug_module_begintransfer       (nios_f_jtag_debug_module_begintransfer),
      .jtag_debug_module_byteenable          (nios_f_jtag_debug_module_byteenable),
      .jtag_debug_module_debugaccess         (nios_f_jtag_debug_module_debugaccess),
      .jtag_debug_module_debugaccess_to_roms (nios_f_data_master_debugaccess),
      .jtag_debug_module_readdata            (nios_f_jtag_debug_module_readdata),
      .jtag_debug_module_resetrequest        (nios_f_jtag_debug_module_resetrequest),
      .jtag_debug_module_select              (nios_f_jtag_debug_module_chipselect),
      .jtag_debug_module_write               (nios_f_jtag_debug_module_write),
      .jtag_debug_module_writedata           (nios_f_jtag_debug_module_writedata),
      .reset_n                               (nios_f_jtag_debug_module_reset_n)
    );

  pipeline_bridge_0_s1_arbitrator the_pipeline_bridge_0_s1
    (
      .clk                                                                           (clk_100),
      .d1_pipeline_bridge_0_s1_end_xfer                                              (d1_pipeline_bridge_0_s1_end_xfer),
      .nios_f_data_master_address_to_slave                                           (nios_f_data_master_address_to_slave),
      .nios_f_data_master_byteenable                                                 (nios_f_data_master_byteenable),
      .nios_f_data_master_debugaccess                                                (nios_f_data_master_debugaccess),
      .nios_f_data_master_granted_pipeline_bridge_0_s1                               (nios_f_data_master_granted_pipeline_bridge_0_s1),
      .nios_f_data_master_qualified_request_pipeline_bridge_0_s1                     (nios_f_data_master_qualified_request_pipeline_bridge_0_s1),
      .nios_f_data_master_read                                                       (nios_f_data_master_read),
      .nios_f_data_master_read_data_valid_pipeline_bridge_0_s1                       (nios_f_data_master_read_data_valid_pipeline_bridge_0_s1),
      .nios_f_data_master_read_data_valid_pipeline_bridge_0_s1_shift_register        (nios_f_data_master_read_data_valid_pipeline_bridge_0_s1_shift_register),
      .nios_f_data_master_requests_pipeline_bridge_0_s1                              (nios_f_data_master_requests_pipeline_bridge_0_s1),
      .nios_f_data_master_waitrequest                                                (nios_f_data_master_waitrequest),
      .nios_f_data_master_write                                                      (nios_f_data_master_write),
      .nios_f_data_master_writedata                                                  (nios_f_data_master_writedata),
      .nios_f_instruction_master_address_to_slave                                    (nios_f_instruction_master_address_to_slave),
      .nios_f_instruction_master_granted_pipeline_bridge_0_s1                        (nios_f_instruction_master_granted_pipeline_bridge_0_s1),
      .nios_f_instruction_master_latency_counter                                     (nios_f_instruction_master_latency_counter),
      .nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1              (nios_f_instruction_master_qualified_request_pipeline_bridge_0_s1),
      .nios_f_instruction_master_read                                                (nios_f_instruction_master_read),
      .nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1                (nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1),
      .nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register (nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register),
      .nios_f_instruction_master_read_data_valid_sdram_s1_shift_register             (nios_f_instruction_master_read_data_valid_sdram_s1_shift_register),
      .nios_f_instruction_master_requests_pipeline_bridge_0_s1                       (nios_f_instruction_master_requests_pipeline_bridge_0_s1),
      .pipeline_bridge_0_s1_address                                                  (pipeline_bridge_0_s1_address),
      .pipeline_bridge_0_s1_arbiterlock                                              (pipeline_bridge_0_s1_arbiterlock),
      .pipeline_bridge_0_s1_arbiterlock2                                             (pipeline_bridge_0_s1_arbiterlock2),
      .pipeline_bridge_0_s1_burstcount                                               (pipeline_bridge_0_s1_burstcount),
      .pipeline_bridge_0_s1_byteenable                                               (pipeline_bridge_0_s1_byteenable),
      .pipeline_bridge_0_s1_chipselect                                               (pipeline_bridge_0_s1_chipselect),
      .pipeline_bridge_0_s1_debugaccess                                              (pipeline_bridge_0_s1_debugaccess),
      .pipeline_bridge_0_s1_endofpacket                                              (pipeline_bridge_0_s1_endofpacket),
      .pipeline_bridge_0_s1_endofpacket_from_sa                                      (pipeline_bridge_0_s1_endofpacket_from_sa),
      .pipeline_bridge_0_s1_nativeaddress                                            (pipeline_bridge_0_s1_nativeaddress),
      .pipeline_bridge_0_s1_read                                                     (pipeline_bridge_0_s1_read),
      .pipeline_bridge_0_s1_readdata                                                 (pipeline_bridge_0_s1_readdata),
      .pipeline_bridge_0_s1_readdata_from_sa                                         (pipeline_bridge_0_s1_readdata_from_sa),
      .pipeline_bridge_0_s1_readdatavalid                                            (pipeline_bridge_0_s1_readdatavalid),
      .pipeline_bridge_0_s1_reset_n                                                  (pipeline_bridge_0_s1_reset_n),
      .pipeline_bridge_0_s1_waitrequest                                              (pipeline_bridge_0_s1_waitrequest),
      .pipeline_bridge_0_s1_waitrequest_from_sa                                      (pipeline_bridge_0_s1_waitrequest_from_sa),
      .pipeline_bridge_0_s1_write                                                    (pipeline_bridge_0_s1_write),
      .pipeline_bridge_0_s1_writedata                                                (pipeline_bridge_0_s1_writedata),
      .reset_n                                                                       (clk_100_reset_n)
    );

  pipeline_bridge_0_m1_arbitrator the_pipeline_bridge_0_m1
    (
      .ads_busy_s1_readdata_from_sa                       (ads_busy_s1_readdata_from_sa),
      .ads_clk_s1_readdata_from_sa                        (ads_clk_s1_readdata_from_sa),
      .ads_din_s1_readdata_from_sa                        (ads_din_s1_readdata_from_sa),
      .ads_dout_s1_readdata_from_sa                       (ads_dout_s1_readdata_from_sa),
      .ads_ncs_s1_readdata_from_sa                        (ads_ncs_s1_readdata_from_sa),
      .ads_nirq_s1_readdata_from_sa                       (ads_nirq_s1_readdata_from_sa),
      .clk                                                (clk_100),
      .d1_ads_busy_s1_end_xfer                            (d1_ads_busy_s1_end_xfer),
      .d1_ads_clk_s1_end_xfer                             (d1_ads_clk_s1_end_xfer),
      .d1_ads_din_s1_end_xfer                             (d1_ads_din_s1_end_xfer),
      .d1_ads_dout_s1_end_xfer                            (d1_ads_dout_s1_end_xfer),
      .d1_ads_ncs_s1_end_xfer                             (d1_ads_ncs_s1_end_xfer),
      .d1_ads_nirq_s1_end_xfer                            (d1_ads_nirq_s1_end_xfer),
      .d1_ili_db_s1_end_xfer                              (d1_ili_db_s1_end_xfer),
      .d1_ili_ncs_s1_end_xfer                             (d1_ili_ncs_s1_end_xfer),
      .d1_ili_nrd_s1_end_xfer                             (d1_ili_nrd_s1_end_xfer),
      .d1_ili_nrst_s1_end_xfer                            (d1_ili_nrst_s1_end_xfer),
      .d1_ili_nwr_s1_end_xfer                             (d1_ili_nwr_s1_end_xfer),
      .d1_ili_rs_s1_end_xfer                              (d1_ili_rs_s1_end_xfer),
      .d1_sd_clk_s1_end_xfer                              (d1_sd_clk_s1_end_xfer),
      .d1_sd_din_s1_end_xfer                              (d1_sd_din_s1_end_xfer),
      .d1_sd_dout_s1_end_xfer                             (d1_sd_dout_s1_end_xfer),
      .d1_sd_ncs_s1_end_xfer                              (d1_sd_ncs_s1_end_xfer),
      .ili_db_s1_readdata_from_sa                         (ili_db_s1_readdata_from_sa),
      .ili_ncs_s1_readdata_from_sa                        (ili_ncs_s1_readdata_from_sa),
      .ili_nrd_s1_readdata_from_sa                        (ili_nrd_s1_readdata_from_sa),
      .ili_nrst_s1_readdata_from_sa                       (ili_nrst_s1_readdata_from_sa),
      .ili_nwr_s1_readdata_from_sa                        (ili_nwr_s1_readdata_from_sa),
      .ili_rs_s1_readdata_from_sa                         (ili_rs_s1_readdata_from_sa),
      .pipeline_bridge_0_m1_address                       (pipeline_bridge_0_m1_address),
      .pipeline_bridge_0_m1_address_to_slave              (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                    (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_byteenable                    (pipeline_bridge_0_m1_byteenable),
      .pipeline_bridge_0_m1_chipselect                    (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_ads_busy_s1           (pipeline_bridge_0_m1_granted_ads_busy_s1),
      .pipeline_bridge_0_m1_granted_ads_clk_s1            (pipeline_bridge_0_m1_granted_ads_clk_s1),
      .pipeline_bridge_0_m1_granted_ads_din_s1            (pipeline_bridge_0_m1_granted_ads_din_s1),
      .pipeline_bridge_0_m1_granted_ads_dout_s1           (pipeline_bridge_0_m1_granted_ads_dout_s1),
      .pipeline_bridge_0_m1_granted_ads_ncs_s1            (pipeline_bridge_0_m1_granted_ads_ncs_s1),
      .pipeline_bridge_0_m1_granted_ads_nirq_s1           (pipeline_bridge_0_m1_granted_ads_nirq_s1),
      .pipeline_bridge_0_m1_granted_ili_db_s1             (pipeline_bridge_0_m1_granted_ili_db_s1),
      .pipeline_bridge_0_m1_granted_ili_ncs_s1            (pipeline_bridge_0_m1_granted_ili_ncs_s1),
      .pipeline_bridge_0_m1_granted_ili_nrd_s1            (pipeline_bridge_0_m1_granted_ili_nrd_s1),
      .pipeline_bridge_0_m1_granted_ili_nrst_s1           (pipeline_bridge_0_m1_granted_ili_nrst_s1),
      .pipeline_bridge_0_m1_granted_ili_nwr_s1            (pipeline_bridge_0_m1_granted_ili_nwr_s1),
      .pipeline_bridge_0_m1_granted_ili_rs_s1             (pipeline_bridge_0_m1_granted_ili_rs_s1),
      .pipeline_bridge_0_m1_granted_sd_clk_s1             (pipeline_bridge_0_m1_granted_sd_clk_s1),
      .pipeline_bridge_0_m1_granted_sd_din_s1             (pipeline_bridge_0_m1_granted_sd_din_s1),
      .pipeline_bridge_0_m1_granted_sd_dout_s1            (pipeline_bridge_0_m1_granted_sd_dout_s1),
      .pipeline_bridge_0_m1_granted_sd_ncs_s1             (pipeline_bridge_0_m1_granted_sd_ncs_s1),
      .pipeline_bridge_0_m1_latency_counter               (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_ads_busy_s1 (pipeline_bridge_0_m1_qualified_request_ads_busy_s1),
      .pipeline_bridge_0_m1_qualified_request_ads_clk_s1  (pipeline_bridge_0_m1_qualified_request_ads_clk_s1),
      .pipeline_bridge_0_m1_qualified_request_ads_din_s1  (pipeline_bridge_0_m1_qualified_request_ads_din_s1),
      .pipeline_bridge_0_m1_qualified_request_ads_dout_s1 (pipeline_bridge_0_m1_qualified_request_ads_dout_s1),
      .pipeline_bridge_0_m1_qualified_request_ads_ncs_s1  (pipeline_bridge_0_m1_qualified_request_ads_ncs_s1),
      .pipeline_bridge_0_m1_qualified_request_ads_nirq_s1 (pipeline_bridge_0_m1_qualified_request_ads_nirq_s1),
      .pipeline_bridge_0_m1_qualified_request_ili_db_s1   (pipeline_bridge_0_m1_qualified_request_ili_db_s1),
      .pipeline_bridge_0_m1_qualified_request_ili_ncs_s1  (pipeline_bridge_0_m1_qualified_request_ili_ncs_s1),
      .pipeline_bridge_0_m1_qualified_request_ili_nrd_s1  (pipeline_bridge_0_m1_qualified_request_ili_nrd_s1),
      .pipeline_bridge_0_m1_qualified_request_ili_nrst_s1 (pipeline_bridge_0_m1_qualified_request_ili_nrst_s1),
      .pipeline_bridge_0_m1_qualified_request_ili_nwr_s1  (pipeline_bridge_0_m1_qualified_request_ili_nwr_s1),
      .pipeline_bridge_0_m1_qualified_request_ili_rs_s1   (pipeline_bridge_0_m1_qualified_request_ili_rs_s1),
      .pipeline_bridge_0_m1_qualified_request_sd_clk_s1   (pipeline_bridge_0_m1_qualified_request_sd_clk_s1),
      .pipeline_bridge_0_m1_qualified_request_sd_din_s1   (pipeline_bridge_0_m1_qualified_request_sd_din_s1),
      .pipeline_bridge_0_m1_qualified_request_sd_dout_s1  (pipeline_bridge_0_m1_qualified_request_sd_dout_s1),
      .pipeline_bridge_0_m1_qualified_request_sd_ncs_s1   (pipeline_bridge_0_m1_qualified_request_sd_ncs_s1),
      .pipeline_bridge_0_m1_read                          (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_ads_busy_s1   (pipeline_bridge_0_m1_read_data_valid_ads_busy_s1),
      .pipeline_bridge_0_m1_read_data_valid_ads_clk_s1    (pipeline_bridge_0_m1_read_data_valid_ads_clk_s1),
      .pipeline_bridge_0_m1_read_data_valid_ads_din_s1    (pipeline_bridge_0_m1_read_data_valid_ads_din_s1),
      .pipeline_bridge_0_m1_read_data_valid_ads_dout_s1   (pipeline_bridge_0_m1_read_data_valid_ads_dout_s1),
      .pipeline_bridge_0_m1_read_data_valid_ads_ncs_s1    (pipeline_bridge_0_m1_read_data_valid_ads_ncs_s1),
      .pipeline_bridge_0_m1_read_data_valid_ads_nirq_s1   (pipeline_bridge_0_m1_read_data_valid_ads_nirq_s1),
      .pipeline_bridge_0_m1_read_data_valid_ili_db_s1     (pipeline_bridge_0_m1_read_data_valid_ili_db_s1),
      .pipeline_bridge_0_m1_read_data_valid_ili_ncs_s1    (pipeline_bridge_0_m1_read_data_valid_ili_ncs_s1),
      .pipeline_bridge_0_m1_read_data_valid_ili_nrd_s1    (pipeline_bridge_0_m1_read_data_valid_ili_nrd_s1),
      .pipeline_bridge_0_m1_read_data_valid_ili_nrst_s1   (pipeline_bridge_0_m1_read_data_valid_ili_nrst_s1),
      .pipeline_bridge_0_m1_read_data_valid_ili_nwr_s1    (pipeline_bridge_0_m1_read_data_valid_ili_nwr_s1),
      .pipeline_bridge_0_m1_read_data_valid_ili_rs_s1     (pipeline_bridge_0_m1_read_data_valid_ili_rs_s1),
      .pipeline_bridge_0_m1_read_data_valid_sd_clk_s1     (pipeline_bridge_0_m1_read_data_valid_sd_clk_s1),
      .pipeline_bridge_0_m1_read_data_valid_sd_din_s1     (pipeline_bridge_0_m1_read_data_valid_sd_din_s1),
      .pipeline_bridge_0_m1_read_data_valid_sd_dout_s1    (pipeline_bridge_0_m1_read_data_valid_sd_dout_s1),
      .pipeline_bridge_0_m1_read_data_valid_sd_ncs_s1     (pipeline_bridge_0_m1_read_data_valid_sd_ncs_s1),
      .pipeline_bridge_0_m1_readdata                      (pipeline_bridge_0_m1_readdata),
      .pipeline_bridge_0_m1_readdatavalid                 (pipeline_bridge_0_m1_readdatavalid),
      .pipeline_bridge_0_m1_requests_ads_busy_s1          (pipeline_bridge_0_m1_requests_ads_busy_s1),
      .pipeline_bridge_0_m1_requests_ads_clk_s1           (pipeline_bridge_0_m1_requests_ads_clk_s1),
      .pipeline_bridge_0_m1_requests_ads_din_s1           (pipeline_bridge_0_m1_requests_ads_din_s1),
      .pipeline_bridge_0_m1_requests_ads_dout_s1          (pipeline_bridge_0_m1_requests_ads_dout_s1),
      .pipeline_bridge_0_m1_requests_ads_ncs_s1           (pipeline_bridge_0_m1_requests_ads_ncs_s1),
      .pipeline_bridge_0_m1_requests_ads_nirq_s1          (pipeline_bridge_0_m1_requests_ads_nirq_s1),
      .pipeline_bridge_0_m1_requests_ili_db_s1            (pipeline_bridge_0_m1_requests_ili_db_s1),
      .pipeline_bridge_0_m1_requests_ili_ncs_s1           (pipeline_bridge_0_m1_requests_ili_ncs_s1),
      .pipeline_bridge_0_m1_requests_ili_nrd_s1           (pipeline_bridge_0_m1_requests_ili_nrd_s1),
      .pipeline_bridge_0_m1_requests_ili_nrst_s1          (pipeline_bridge_0_m1_requests_ili_nrst_s1),
      .pipeline_bridge_0_m1_requests_ili_nwr_s1           (pipeline_bridge_0_m1_requests_ili_nwr_s1),
      .pipeline_bridge_0_m1_requests_ili_rs_s1            (pipeline_bridge_0_m1_requests_ili_rs_s1),
      .pipeline_bridge_0_m1_requests_sd_clk_s1            (pipeline_bridge_0_m1_requests_sd_clk_s1),
      .pipeline_bridge_0_m1_requests_sd_din_s1            (pipeline_bridge_0_m1_requests_sd_din_s1),
      .pipeline_bridge_0_m1_requests_sd_dout_s1           (pipeline_bridge_0_m1_requests_sd_dout_s1),
      .pipeline_bridge_0_m1_requests_sd_ncs_s1            (pipeline_bridge_0_m1_requests_sd_ncs_s1),
      .pipeline_bridge_0_m1_waitrequest                   (pipeline_bridge_0_m1_waitrequest),
      .pipeline_bridge_0_m1_write                         (pipeline_bridge_0_m1_write),
      .pipeline_bridge_0_m1_writedata                     (pipeline_bridge_0_m1_writedata),
      .reset_n                                            (clk_100_reset_n),
      .sd_clk_s1_readdata_from_sa                         (sd_clk_s1_readdata_from_sa),
      .sd_din_s1_readdata_from_sa                         (sd_din_s1_readdata_from_sa),
      .sd_dout_s1_readdata_from_sa                        (sd_dout_s1_readdata_from_sa),
      .sd_ncs_s1_readdata_from_sa                         (sd_ncs_s1_readdata_from_sa)
    );

  pipeline_bridge_0 the_pipeline_bridge_0
    (
      .clk              (clk_100),
      .m1_address       (pipeline_bridge_0_m1_address),
      .m1_burstcount    (pipeline_bridge_0_m1_burstcount),
      .m1_byteenable    (pipeline_bridge_0_m1_byteenable),
      .m1_chipselect    (pipeline_bridge_0_m1_chipselect),
      .m1_debugaccess   (pipeline_bridge_0_m1_debugaccess),
      .m1_endofpacket   (pipeline_bridge_0_m1_endofpacket),
      .m1_read          (pipeline_bridge_0_m1_read),
      .m1_readdata      (pipeline_bridge_0_m1_readdata),
      .m1_readdatavalid (pipeline_bridge_0_m1_readdatavalid),
      .m1_waitrequest   (pipeline_bridge_0_m1_waitrequest),
      .m1_write         (pipeline_bridge_0_m1_write),
      .m1_writedata     (pipeline_bridge_0_m1_writedata),
      .reset_n          (pipeline_bridge_0_s1_reset_n),
      .s1_address       (pipeline_bridge_0_s1_address),
      .s1_arbiterlock   (pipeline_bridge_0_s1_arbiterlock),
      .s1_arbiterlock2  (pipeline_bridge_0_s1_arbiterlock2),
      .s1_burstcount    (pipeline_bridge_0_s1_burstcount),
      .s1_byteenable    (pipeline_bridge_0_s1_byteenable),
      .s1_chipselect    (pipeline_bridge_0_s1_chipselect),
      .s1_debugaccess   (pipeline_bridge_0_s1_debugaccess),
      .s1_endofpacket   (pipeline_bridge_0_s1_endofpacket),
      .s1_nativeaddress (pipeline_bridge_0_s1_nativeaddress),
      .s1_read          (pipeline_bridge_0_s1_read),
      .s1_readdata      (pipeline_bridge_0_s1_readdata),
      .s1_readdatavalid (pipeline_bridge_0_s1_readdatavalid),
      .s1_waitrequest   (pipeline_bridge_0_s1_waitrequest),
      .s1_write         (pipeline_bridge_0_s1_write),
      .s1_writedata     (pipeline_bridge_0_s1_writedata)
    );

  sd_clk_s1_arbitrator the_sd_clk_s1
    (
      .clk                                              (clk_100),
      .d1_sd_clk_s1_end_xfer                            (d1_sd_clk_s1_end_xfer),
      .pipeline_bridge_0_m1_address_to_slave            (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                  (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                  (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_sd_clk_s1           (pipeline_bridge_0_m1_granted_sd_clk_s1),
      .pipeline_bridge_0_m1_latency_counter             (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_sd_clk_s1 (pipeline_bridge_0_m1_qualified_request_sd_clk_s1),
      .pipeline_bridge_0_m1_read                        (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_sd_clk_s1   (pipeline_bridge_0_m1_read_data_valid_sd_clk_s1),
      .pipeline_bridge_0_m1_requests_sd_clk_s1          (pipeline_bridge_0_m1_requests_sd_clk_s1),
      .pipeline_bridge_0_m1_write                       (pipeline_bridge_0_m1_write),
      .pipeline_bridge_0_m1_writedata                   (pipeline_bridge_0_m1_writedata),
      .reset_n                                          (clk_100_reset_n),
      .sd_clk_s1_address                                (sd_clk_s1_address),
      .sd_clk_s1_chipselect                             (sd_clk_s1_chipselect),
      .sd_clk_s1_readdata                               (sd_clk_s1_readdata),
      .sd_clk_s1_readdata_from_sa                       (sd_clk_s1_readdata_from_sa),
      .sd_clk_s1_reset_n                                (sd_clk_s1_reset_n),
      .sd_clk_s1_write_n                                (sd_clk_s1_write_n),
      .sd_clk_s1_writedata                              (sd_clk_s1_writedata)
    );

  sd_clk the_sd_clk
    (
      .address    (sd_clk_s1_address),
      .chipselect (sd_clk_s1_chipselect),
      .clk        (clk_100),
      .out_port   (out_port_from_the_sd_clk),
      .readdata   (sd_clk_s1_readdata),
      .reset_n    (sd_clk_s1_reset_n),
      .write_n    (sd_clk_s1_write_n),
      .writedata  (sd_clk_s1_writedata)
    );

  sd_din_s1_arbitrator the_sd_din_s1
    (
      .clk                                              (clk_100),
      .d1_sd_din_s1_end_xfer                            (d1_sd_din_s1_end_xfer),
      .pipeline_bridge_0_m1_address_to_slave            (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                  (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                  (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_sd_din_s1           (pipeline_bridge_0_m1_granted_sd_din_s1),
      .pipeline_bridge_0_m1_latency_counter             (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_sd_din_s1 (pipeline_bridge_0_m1_qualified_request_sd_din_s1),
      .pipeline_bridge_0_m1_read                        (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_sd_din_s1   (pipeline_bridge_0_m1_read_data_valid_sd_din_s1),
      .pipeline_bridge_0_m1_requests_sd_din_s1          (pipeline_bridge_0_m1_requests_sd_din_s1),
      .pipeline_bridge_0_m1_write                       (pipeline_bridge_0_m1_write),
      .pipeline_bridge_0_m1_writedata                   (pipeline_bridge_0_m1_writedata),
      .reset_n                                          (clk_100_reset_n),
      .sd_din_s1_address                                (sd_din_s1_address),
      .sd_din_s1_chipselect                             (sd_din_s1_chipselect),
      .sd_din_s1_readdata                               (sd_din_s1_readdata),
      .sd_din_s1_readdata_from_sa                       (sd_din_s1_readdata_from_sa),
      .sd_din_s1_reset_n                                (sd_din_s1_reset_n),
      .sd_din_s1_write_n                                (sd_din_s1_write_n),
      .sd_din_s1_writedata                              (sd_din_s1_writedata)
    );

  sd_din the_sd_din
    (
      .address    (sd_din_s1_address),
      .chipselect (sd_din_s1_chipselect),
      .clk        (clk_100),
      .out_port   (out_port_from_the_sd_din),
      .readdata   (sd_din_s1_readdata),
      .reset_n    (sd_din_s1_reset_n),
      .write_n    (sd_din_s1_write_n),
      .writedata  (sd_din_s1_writedata)
    );

  sd_dout_s1_arbitrator the_sd_dout_s1
    (
      .clk                                               (clk_100),
      .d1_sd_dout_s1_end_xfer                            (d1_sd_dout_s1_end_xfer),
      .pipeline_bridge_0_m1_address_to_slave             (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                   (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                   (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_sd_dout_s1           (pipeline_bridge_0_m1_granted_sd_dout_s1),
      .pipeline_bridge_0_m1_latency_counter              (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_sd_dout_s1 (pipeline_bridge_0_m1_qualified_request_sd_dout_s1),
      .pipeline_bridge_0_m1_read                         (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_sd_dout_s1   (pipeline_bridge_0_m1_read_data_valid_sd_dout_s1),
      .pipeline_bridge_0_m1_requests_sd_dout_s1          (pipeline_bridge_0_m1_requests_sd_dout_s1),
      .pipeline_bridge_0_m1_write                        (pipeline_bridge_0_m1_write),
      .reset_n                                           (clk_100_reset_n),
      .sd_dout_s1_address                                (sd_dout_s1_address),
      .sd_dout_s1_readdata                               (sd_dout_s1_readdata),
      .sd_dout_s1_readdata_from_sa                       (sd_dout_s1_readdata_from_sa),
      .sd_dout_s1_reset_n                                (sd_dout_s1_reset_n)
    );

  sd_dout the_sd_dout
    (
      .address  (sd_dout_s1_address),
      .clk      (clk_100),
      .in_port  (in_port_to_the_sd_dout),
      .readdata (sd_dout_s1_readdata),
      .reset_n  (sd_dout_s1_reset_n)
    );

  sd_ncs_s1_arbitrator the_sd_ncs_s1
    (
      .clk                                              (clk_100),
      .d1_sd_ncs_s1_end_xfer                            (d1_sd_ncs_s1_end_xfer),
      .pipeline_bridge_0_m1_address_to_slave            (pipeline_bridge_0_m1_address_to_slave),
      .pipeline_bridge_0_m1_burstcount                  (pipeline_bridge_0_m1_burstcount),
      .pipeline_bridge_0_m1_chipselect                  (pipeline_bridge_0_m1_chipselect),
      .pipeline_bridge_0_m1_granted_sd_ncs_s1           (pipeline_bridge_0_m1_granted_sd_ncs_s1),
      .pipeline_bridge_0_m1_latency_counter             (pipeline_bridge_0_m1_latency_counter),
      .pipeline_bridge_0_m1_qualified_request_sd_ncs_s1 (pipeline_bridge_0_m1_qualified_request_sd_ncs_s1),
      .pipeline_bridge_0_m1_read                        (pipeline_bridge_0_m1_read),
      .pipeline_bridge_0_m1_read_data_valid_sd_ncs_s1   (pipeline_bridge_0_m1_read_data_valid_sd_ncs_s1),
      .pipeline_bridge_0_m1_requests_sd_ncs_s1          (pipeline_bridge_0_m1_requests_sd_ncs_s1),
      .pipeline_bridge_0_m1_write                       (pipeline_bridge_0_m1_write),
      .pipeline_bridge_0_m1_writedata                   (pipeline_bridge_0_m1_writedata),
      .reset_n                                          (clk_100_reset_n),
      .sd_ncs_s1_address                                (sd_ncs_s1_address),
      .sd_ncs_s1_chipselect                             (sd_ncs_s1_chipselect),
      .sd_ncs_s1_readdata                               (sd_ncs_s1_readdata),
      .sd_ncs_s1_readdata_from_sa                       (sd_ncs_s1_readdata_from_sa),
      .sd_ncs_s1_reset_n                                (sd_ncs_s1_reset_n),
      .sd_ncs_s1_write_n                                (sd_ncs_s1_write_n),
      .sd_ncs_s1_writedata                              (sd_ncs_s1_writedata)
    );

  sd_ncs the_sd_ncs
    (
      .address    (sd_ncs_s1_address),
      .chipselect (sd_ncs_s1_chipselect),
      .clk        (clk_100),
      .out_port   (out_port_from_the_sd_ncs),
      .readdata   (sd_ncs_s1_readdata),
      .reset_n    (sd_ncs_s1_reset_n),
      .write_n    (sd_ncs_s1_write_n),
      .writedata  (sd_ncs_s1_writedata)
    );

  sdram_s1_arbitrator the_sdram_s1
    (
      .clk                                                                           (clk_100),
      .d1_sdram_s1_end_xfer                                                          (d1_sdram_s1_end_xfer),
      .nios_f_data_master_address_to_slave                                           (nios_f_data_master_address_to_slave),
      .nios_f_data_master_byteenable                                                 (nios_f_data_master_byteenable),
      .nios_f_data_master_byteenable_sdram_s1                                        (nios_f_data_master_byteenable_sdram_s1),
      .nios_f_data_master_dbs_address                                                (nios_f_data_master_dbs_address),
      .nios_f_data_master_dbs_write_16                                               (nios_f_data_master_dbs_write_16),
      .nios_f_data_master_granted_sdram_s1                                           (nios_f_data_master_granted_sdram_s1),
      .nios_f_data_master_no_byte_enables_and_last_term                              (nios_f_data_master_no_byte_enables_and_last_term),
      .nios_f_data_master_qualified_request_sdram_s1                                 (nios_f_data_master_qualified_request_sdram_s1),
      .nios_f_data_master_read                                                       (nios_f_data_master_read),
      .nios_f_data_master_read_data_valid_sdram_s1                                   (nios_f_data_master_read_data_valid_sdram_s1),
      .nios_f_data_master_read_data_valid_sdram_s1_shift_register                    (nios_f_data_master_read_data_valid_sdram_s1_shift_register),
      .nios_f_data_master_requests_sdram_s1                                          (nios_f_data_master_requests_sdram_s1),
      .nios_f_data_master_waitrequest                                                (nios_f_data_master_waitrequest),
      .nios_f_data_master_write                                                      (nios_f_data_master_write),
      .nios_f_instruction_master_address_to_slave                                    (nios_f_instruction_master_address_to_slave),
      .nios_f_instruction_master_dbs_address                                         (nios_f_instruction_master_dbs_address),
      .nios_f_instruction_master_granted_sdram_s1                                    (nios_f_instruction_master_granted_sdram_s1),
      .nios_f_instruction_master_latency_counter                                     (nios_f_instruction_master_latency_counter),
      .nios_f_instruction_master_qualified_request_sdram_s1                          (nios_f_instruction_master_qualified_request_sdram_s1),
      .nios_f_instruction_master_read                                                (nios_f_instruction_master_read),
      .nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register (nios_f_instruction_master_read_data_valid_pipeline_bridge_0_s1_shift_register),
      .nios_f_instruction_master_read_data_valid_sdram_s1                            (nios_f_instruction_master_read_data_valid_sdram_s1),
      .nios_f_instruction_master_read_data_valid_sdram_s1_shift_register             (nios_f_instruction_master_read_data_valid_sdram_s1_shift_register),
      .nios_f_instruction_master_requests_sdram_s1                                   (nios_f_instruction_master_requests_sdram_s1),
      .reset_n                                                                       (clk_100_reset_n),
      .sdram_s1_address                                                              (sdram_s1_address),
      .sdram_s1_byteenable_n                                                         (sdram_s1_byteenable_n),
      .sdram_s1_chipselect                                                           (sdram_s1_chipselect),
      .sdram_s1_read_n                                                               (sdram_s1_read_n),
      .sdram_s1_readdata                                                             (sdram_s1_readdata),
      .sdram_s1_readdata_from_sa                                                     (sdram_s1_readdata_from_sa),
      .sdram_s1_readdatavalid                                                        (sdram_s1_readdatavalid),
      .sdram_s1_reset_n                                                              (sdram_s1_reset_n),
      .sdram_s1_waitrequest                                                          (sdram_s1_waitrequest),
      .sdram_s1_waitrequest_from_sa                                                  (sdram_s1_waitrequest_from_sa),
      .sdram_s1_write_n                                                              (sdram_s1_write_n),
      .sdram_s1_writedata                                                            (sdram_s1_writedata)
    );

  sdram the_sdram
    (
      .az_addr        (sdram_s1_address),
      .az_be_n        (sdram_s1_byteenable_n),
      .az_cs          (sdram_s1_chipselect),
      .az_data        (sdram_s1_writedata),
      .az_rd_n        (sdram_s1_read_n),
      .az_wr_n        (sdram_s1_write_n),
      .clk            (clk_100),
      .reset_n        (sdram_s1_reset_n),
      .za_data        (sdram_s1_readdata),
      .za_valid       (sdram_s1_readdatavalid),
      .za_waitrequest (sdram_s1_waitrequest),
      .zs_addr        (zs_addr_from_the_sdram),
      .zs_ba          (zs_ba_from_the_sdram),
      .zs_cas_n       (zs_cas_n_from_the_sdram),
      .zs_cke         (zs_cke_from_the_sdram),
      .zs_cs_n        (zs_cs_n_from_the_sdram),
      .zs_dq          (zs_dq_to_and_from_the_sdram),
      .zs_dqm         (zs_dqm_from_the_sdram),
      .zs_ras_n       (zs_ras_n_from_the_sdram),
      .zs_we_n        (zs_we_n_from_the_sdram)
    );

  sys_clk_timer_s1_arbitrator the_sys_clk_timer_s1
    (
      .clk                                                   (clk_100),
      .d1_sys_clk_timer_s1_end_xfer                          (d1_sys_clk_timer_s1_end_xfer),
      .nios_f_data_master_address_to_slave                   (nios_f_data_master_address_to_slave),
      .nios_f_data_master_granted_sys_clk_timer_s1           (nios_f_data_master_granted_sys_clk_timer_s1),
      .nios_f_data_master_qualified_request_sys_clk_timer_s1 (nios_f_data_master_qualified_request_sys_clk_timer_s1),
      .nios_f_data_master_read                               (nios_f_data_master_read),
      .nios_f_data_master_read_data_valid_sys_clk_timer_s1   (nios_f_data_master_read_data_valid_sys_clk_timer_s1),
      .nios_f_data_master_requests_sys_clk_timer_s1          (nios_f_data_master_requests_sys_clk_timer_s1),
      .nios_f_data_master_waitrequest                        (nios_f_data_master_waitrequest),
      .nios_f_data_master_write                              (nios_f_data_master_write),
      .nios_f_data_master_writedata                          (nios_f_data_master_writedata),
      .reset_n                                               (clk_100_reset_n),
      .sys_clk_timer_s1_address                              (sys_clk_timer_s1_address),
      .sys_clk_timer_s1_chipselect                           (sys_clk_timer_s1_chipselect),
      .sys_clk_timer_s1_irq                                  (sys_clk_timer_s1_irq),
      .sys_clk_timer_s1_irq_from_sa                          (sys_clk_timer_s1_irq_from_sa),
      .sys_clk_timer_s1_readdata                             (sys_clk_timer_s1_readdata),
      .sys_clk_timer_s1_readdata_from_sa                     (sys_clk_timer_s1_readdata_from_sa),
      .sys_clk_timer_s1_reset_n                              (sys_clk_timer_s1_reset_n),
      .sys_clk_timer_s1_write_n                              (sys_clk_timer_s1_write_n),
      .sys_clk_timer_s1_writedata                            (sys_clk_timer_s1_writedata)
    );

  sys_clk_timer the_sys_clk_timer
    (
      .address    (sys_clk_timer_s1_address),
      .chipselect (sys_clk_timer_s1_chipselect),
      .clk        (clk_100),
      .irq        (sys_clk_timer_s1_irq),
      .readdata   (sys_clk_timer_s1_readdata),
      .reset_n    (sys_clk_timer_s1_reset_n),
      .write_n    (sys_clk_timer_s1_write_n),
      .writedata  (sys_clk_timer_s1_writedata)
    );

  sysid_control_slave_arbitrator the_sysid_control_slave
    (
      .clk                                                      (clk_100),
      .d1_sysid_control_slave_end_xfer                          (d1_sysid_control_slave_end_xfer),
      .nios_f_data_master_address_to_slave                      (nios_f_data_master_address_to_slave),
      .nios_f_data_master_granted_sysid_control_slave           (nios_f_data_master_granted_sysid_control_slave),
      .nios_f_data_master_qualified_request_sysid_control_slave (nios_f_data_master_qualified_request_sysid_control_slave),
      .nios_f_data_master_read                                  (nios_f_data_master_read),
      .nios_f_data_master_read_data_valid_sysid_control_slave   (nios_f_data_master_read_data_valid_sysid_control_slave),
      .nios_f_data_master_requests_sysid_control_slave          (nios_f_data_master_requests_sysid_control_slave),
      .nios_f_data_master_write                                 (nios_f_data_master_write),
      .reset_n                                                  (clk_100_reset_n),
      .sysid_control_slave_address                              (sysid_control_slave_address),
      .sysid_control_slave_readdata                             (sysid_control_slave_readdata),
      .sysid_control_slave_readdata_from_sa                     (sysid_control_slave_readdata_from_sa),
      .sysid_control_slave_reset_n                              (sysid_control_slave_reset_n)
    );

  sysid the_sysid
    (
      .address  (sysid_control_slave_address),
      .clock    (sysid_control_slave_clock),
      .readdata (sysid_control_slave_readdata),
      .reset_n  (sysid_control_slave_reset_n)
    );

  watchdog_timer_s1_arbitrator the_watchdog_timer_s1
    (
      .clk                                                    (clk_100),
      .d1_watchdog_timer_s1_end_xfer                          (d1_watchdog_timer_s1_end_xfer),
      .nios_f_data_master_address_to_slave                    (nios_f_data_master_address_to_slave),
      .nios_f_data_master_granted_watchdog_timer_s1           (nios_f_data_master_granted_watchdog_timer_s1),
      .nios_f_data_master_qualified_request_watchdog_timer_s1 (nios_f_data_master_qualified_request_watchdog_timer_s1),
      .nios_f_data_master_read                                (nios_f_data_master_read),
      .nios_f_data_master_read_data_valid_watchdog_timer_s1   (nios_f_data_master_read_data_valid_watchdog_timer_s1),
      .nios_f_data_master_requests_watchdog_timer_s1          (nios_f_data_master_requests_watchdog_timer_s1),
      .nios_f_data_master_waitrequest                         (nios_f_data_master_waitrequest),
      .nios_f_data_master_write                               (nios_f_data_master_write),
      .nios_f_data_master_writedata                           (nios_f_data_master_writedata),
      .reset_n                                                (clk_100_reset_n),
      .watchdog_timer_s1_address                              (watchdog_timer_s1_address),
      .watchdog_timer_s1_chipselect                           (watchdog_timer_s1_chipselect),
      .watchdog_timer_s1_irq                                  (watchdog_timer_s1_irq),
      .watchdog_timer_s1_irq_from_sa                          (watchdog_timer_s1_irq_from_sa),
      .watchdog_timer_s1_readdata                             (watchdog_timer_s1_readdata),
      .watchdog_timer_s1_readdata_from_sa                     (watchdog_timer_s1_readdata_from_sa),
      .watchdog_timer_s1_reset_n                              (watchdog_timer_s1_reset_n),
      .watchdog_timer_s1_resetrequest                         (watchdog_timer_s1_resetrequest),
      .watchdog_timer_s1_resetrequest_from_sa                 (watchdog_timer_s1_resetrequest_from_sa),
      .watchdog_timer_s1_write_n                              (watchdog_timer_s1_write_n),
      .watchdog_timer_s1_writedata                            (watchdog_timer_s1_writedata)
    );

  watchdog_timer the_watchdog_timer
    (
      .address      (watchdog_timer_s1_address),
      .chipselect   (watchdog_timer_s1_chipselect),
      .clk          (clk_100),
      .irq          (watchdog_timer_s1_irq),
      .readdata     (watchdog_timer_s1_readdata),
      .reset_n      (watchdog_timer_s1_reset_n),
      .resetrequest (watchdog_timer_s1_resetrequest),
      .write_n      (watchdog_timer_s1_write_n),
      .writedata    (watchdog_timer_s1_writedata)
    );

  //reset is asserted asynchronously and deasserted synchronously
  nios_ii_sys_reset_clk_100_domain_synch_module nios_ii_sys_reset_clk_100_domain_synch
    (
      .clk      (clk_100),
      .data_in  (1'b1),
      .data_out (clk_100_reset_n),
      .reset_n  (reset_n_sources)
    );

  //reset sources mux, which is an e_mux
  assign reset_n_sources = ~(~reset_n |
    0 |
    nios_f_jtag_debug_module_resetrequest_from_sa |
    nios_f_jtag_debug_module_resetrequest_from_sa |
    watchdog_timer_s1_resetrequest_from_sa |
    watchdog_timer_s1_resetrequest_from_sa);

  //pipeline_bridge_0_m1_endofpacket of type endofpacket does not connect to anything so wire it to default (0)
  assign pipeline_bridge_0_m1_endofpacket = 0;

  //sysid_control_slave_clock of type clock does not connect to anything so wire it to default (0)
  assign sysid_control_slave_clock = 0;


endmodule


//synthesis translate_off



// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE

// AND HERE WILL BE PRESERVED </ALTERA_NOTE>


// If user logic components use Altsync_Ram with convert_hex2ver.dll,
// set USE_convert_hex2ver in the user comments section above

// `ifdef USE_convert_hex2ver
// `else
// `define NO_PLI 1
// `endif

`include "c:/altera/11.1sp2/quartus/eda/sim_lib/altera_mf.v"
`include "c:/altera/11.1sp2/quartus/eda/sim_lib/220model.v"
`include "c:/altera/11.1sp2/quartus/eda/sim_lib/sgate.v"
`include "sd_dout.v"
`include "sd_din.v"
`include "sysid.v"
`include "sdram.v"
`include "sdram_test_component.v"
`include "ads_clk.v"
`include "high_res_timer.v"
`include "ili_rs.v"
`include "epcs.v"
`include "ads_din.v"
`include "ads_busy.v"
`include "jtag_uart.v"
`include "sd_ncs.v"
`include "ili_db.v"
`include "sys_clk_timer.v"
`include "pipeline_bridge_0.v"
`include "ili_nrst.v"
`include "sd_clk.v"
`include "nios_f_test_bench.v"
`include "nios_f_mult_cell.v"
`include "nios_f_oci_test_bench.v"
`include "nios_f_jtag_debug_module_tck.v"
`include "nios_f_jtag_debug_module_sysclk.v"
`include "nios_f_jtag_debug_module_wrapper.v"
`include "nios_f.v"
`include "ads_ncs.v"
`include "ili_nrd.v"
`include "ads_dout.v"
`include "ads_nirq.v"
`include "ili_ncs.v"
`include "ili_nwr.v"
`include "watchdog_timer.v"

`timescale 1ns / 1ps

module test_bench 
;


  wire    [  7: 0] bidir_port_to_and_from_the_ili_db;
  wire             clk;
  reg              clk_100;
  wire             data0_to_the_epcs;
  wire             dclk_from_the_epcs;
  wire             epcs_epcs_control_port_dataavailable_from_sa;
  wire             epcs_epcs_control_port_endofpacket_from_sa;
  wire             epcs_epcs_control_port_readyfordata_from_sa;
  wire             in_port_to_the_ads_busy;
  wire             in_port_to_the_ads_dout;
  wire             in_port_to_the_ads_nirq;
  wire             in_port_to_the_sd_dout;
  wire             jtag_uart_avalon_jtag_slave_dataavailable_from_sa;
  wire             jtag_uart_avalon_jtag_slave_readyfordata_from_sa;
  wire             out_port_from_the_ads_clk;
  wire             out_port_from_the_ads_din;
  wire             out_port_from_the_ads_ncs;
  wire             out_port_from_the_ili_ncs;
  wire             out_port_from_the_ili_nrd;
  wire             out_port_from_the_ili_nrst;
  wire             out_port_from_the_ili_nwr;
  wire             out_port_from_the_ili_rs;
  wire             out_port_from_the_sd_clk;
  wire             out_port_from_the_sd_din;
  wire             out_port_from_the_sd_ncs;
  wire             pipeline_bridge_0_m1_debugaccess;
  wire             pipeline_bridge_0_m1_endofpacket;
  wire             pipeline_bridge_0_s1_endofpacket_from_sa;
  reg              reset_n;
  wire             sce_from_the_epcs;
  wire             sdo_from_the_epcs;
  wire             sysid_control_slave_clock;
  wire    [ 11: 0] zs_addr_from_the_sdram;
  wire    [  1: 0] zs_ba_from_the_sdram;
  wire             zs_cas_n_from_the_sdram;
  wire             zs_cke_from_the_sdram;
  wire             zs_cs_n_from_the_sdram;
  wire    [ 15: 0] zs_dq_to_and_from_the_sdram;
  wire    [  1: 0] zs_dqm_from_the_sdram;
  wire             zs_ras_n_from_the_sdram;
  wire             zs_we_n_from_the_sdram;


// <ALTERA_NOTE> CODE INSERTED BETWEEN HERE
//  add your signals and additional architecture here
// AND HERE WILL BE PRESERVED </ALTERA_NOTE>

  //Set us up the Dut
  nios_ii_sys DUT
    (
      .bidir_port_to_and_from_the_ili_db (bidir_port_to_and_from_the_ili_db),
      .clk_100                           (clk_100),
      .data0_to_the_epcs                 (data0_to_the_epcs),
      .dclk_from_the_epcs                (dclk_from_the_epcs),
      .in_port_to_the_ads_busy           (in_port_to_the_ads_busy),
      .in_port_to_the_ads_dout           (in_port_to_the_ads_dout),
      .in_port_to_the_ads_nirq           (in_port_to_the_ads_nirq),
      .in_port_to_the_sd_dout            (in_port_to_the_sd_dout),
      .out_port_from_the_ads_clk         (out_port_from_the_ads_clk),
      .out_port_from_the_ads_din         (out_port_from_the_ads_din),
      .out_port_from_the_ads_ncs         (out_port_from_the_ads_ncs),
      .out_port_from_the_ili_ncs         (out_port_from_the_ili_ncs),
      .out_port_from_the_ili_nrd         (out_port_from_the_ili_nrd),
      .out_port_from_the_ili_nrst        (out_port_from_the_ili_nrst),
      .out_port_from_the_ili_nwr         (out_port_from_the_ili_nwr),
      .out_port_from_the_ili_rs          (out_port_from_the_ili_rs),
      .out_port_from_the_sd_clk          (out_port_from_the_sd_clk),
      .out_port_from_the_sd_din          (out_port_from_the_sd_din),
      .out_port_from_the_sd_ncs          (out_port_from_the_sd_ncs),
      .reset_n                           (reset_n),
      .sce_from_the_epcs                 (sce_from_the_epcs),
      .sdo_from_the_epcs                 (sdo_from_the_epcs),
      .zs_addr_from_the_sdram            (zs_addr_from_the_sdram),
      .zs_ba_from_the_sdram              (zs_ba_from_the_sdram),
      .zs_cas_n_from_the_sdram           (zs_cas_n_from_the_sdram),
      .zs_cke_from_the_sdram             (zs_cke_from_the_sdram),
      .zs_cs_n_from_the_sdram            (zs_cs_n_from_the_sdram),
      .zs_dq_to_and_from_the_sdram       (zs_dq_to_and_from_the_sdram),
      .zs_dqm_from_the_sdram             (zs_dqm_from_the_sdram),
      .zs_ras_n_from_the_sdram           (zs_ras_n_from_the_sdram),
      .zs_we_n_from_the_sdram            (zs_we_n_from_the_sdram)
    );

  sdram_test_component the_sdram_test_component
    (
      .clk      (clk_100),
      .zs_addr  (zs_addr_from_the_sdram),
      .zs_ba    (zs_ba_from_the_sdram),
      .zs_cas_n (zs_cas_n_from_the_sdram),
      .zs_cke   (zs_cke_from_the_sdram),
      .zs_cs_n  (zs_cs_n_from_the_sdram),
      .zs_dq    (zs_dq_to_and_from_the_sdram),
      .zs_dqm   (zs_dqm_from_the_sdram),
      .zs_ras_n (zs_ras_n_from_the_sdram),
      .zs_we_n  (zs_we_n_from_the_sdram)
    );

  initial
    clk_100 = 1'b0;
  always
    #5 clk_100 <= ~clk_100;
  
  initial 
    begin
      reset_n <= 0;
      #100 reset_n <= 1;
    end

endmodule


//synthesis translate_on