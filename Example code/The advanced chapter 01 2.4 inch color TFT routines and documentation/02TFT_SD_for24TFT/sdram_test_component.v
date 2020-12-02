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

module sdram_test_component_ram_module (
                                         // inputs:
                                          data,
                                          rdaddress,
                                          rdclken,
                                          wraddress,
                                          wrclock,
                                          wren,

                                         // outputs:
                                          q
                                       )
;

  output  [ 15: 0] q;
  input   [ 15: 0] data;
  input   [ 21: 0] rdaddress;
  input            rdclken;
  input   [ 21: 0] wraddress;
  input            wrclock;
  input            wren;

  reg     [ 15: 0] mem_array [4194303: 0];
  wire    [ 15: 0] q;
  reg     [ 21: 0] read_address;

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  always @(rdaddress)
    begin
      read_address = rdaddress;
    end


  // Data read is asynchronous.
  assign q = mem_array[read_address];

initial
    $readmemh("sdram.dat", mem_array);
  always @(posedge wrclock)
    begin
      // Write data
      if (wren)
          mem_array[wraddress] <= data;
    end



//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on
//synthesis read_comments_as_HDL on
//  always @(rdaddress)
//    begin
//      read_address = rdaddress;
//    end
//
//
//  lpm_ram_dp lpm_ram_dp_component
//    (
//      .data (data),
//      .q (q),
//      .rdaddress (read_address),
//      .rdclken (rdclken),
//      .wraddress (wraddress),
//      .wrclock (wrclock),
//      .wren (wren)
//    );
//
//  defparam lpm_ram_dp_component.lpm_file = "UNUSED",
//           lpm_ram_dp_component.lpm_hint = "USE_EAB=ON",
//           lpm_ram_dp_component.lpm_indata = "REGISTERED",
//           lpm_ram_dp_component.lpm_outdata = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_rdaddress_control = "UNREGISTERED",
//           lpm_ram_dp_component.lpm_width = 16,
//           lpm_ram_dp_component.lpm_widthad = 22,
//           lpm_ram_dp_component.lpm_wraddress_control = "REGISTERED",
//           lpm_ram_dp_component.suppress_memory_conversion_warnings = "ON";
//
//synthesis read_comments_as_HDL off

endmodule


// synthesis translate_off
`timescale 1ns / 1ps
// synthesis translate_on

// turn off superfluous verilog processor warnings 
// altera message_level Level1 
// altera message_off 10034 10035 10036 10037 10230 10240 10030 

module sdram_test_component (
                              // inputs:
                               clk,
                               zs_addr,
                               zs_ba,
                               zs_cas_n,
                               zs_cke,
                               zs_cs_n,
                               zs_dqm,
                               zs_ras_n,
                               zs_we_n,

                              // outputs:
                               zs_dq
                            )
;

  inout   [ 15: 0] zs_dq;
  input            clk;
  input   [ 11: 0] zs_addr;
  input   [  1: 0] zs_ba;
  input            zs_cas_n;
  input            zs_cke;
  input            zs_cs_n;
  input   [  1: 0] zs_dqm;
  input            zs_ras_n;
  input            zs_we_n;

  wire    [ 23: 0] CODE;
  wire    [ 11: 0] a;
  wire    [  7: 0] addr_col;
  reg     [ 13: 0] addr_crb;
  wire    [  1: 0] ba;
  wire             cas_n;
  wire             cke;
  wire    [  2: 0] cmd_code;
  wire             cs_n;
  wire    [  1: 0] dqm;
  wire    [  2: 0] index;
  reg     [  2: 0] latency;
  wire    [  1: 0] mask;
  wire    [ 15: 0] mem_bytes;
  wire             ras_n;
  reg     [ 21: 0] rd_addr_pipe_0;
  reg     [ 21: 0] rd_addr_pipe_1;
  reg     [ 21: 0] rd_addr_pipe_2;
  reg     [  1: 0] rd_mask_pipe_0;
  reg     [  1: 0] rd_mask_pipe_1;
  reg     [  1: 0] rd_mask_pipe_2;
  reg     [  2: 0] rd_valid_pipe;
  wire    [ 21: 0] read_addr;
  wire    [ 15: 0] read_data;
  wire    [  1: 0] read_mask;
  wire    [ 15: 0] read_temp;
  wire             read_valid;
  wire    [ 15: 0] rmw_temp;
  wire    [ 21: 0] test_addr;
  wire    [ 23: 0] txt_code;
  wire             we_n;
  wire    [ 15: 0] zs_dq;
initial
  begin
    $write("\n");
    $write("************************************************************\n");
    $write("This testbench includes an SOPC Builder Generated Altera model:\n");
    $write("'sdram_test_component.v', to simulate accesses to SDRAM.\n");
    $write("Initial contents are loaded from the file: 'sdram.dat'.\n");
    $write("************************************************************\n");
  end
  //Synchronous write when (CODE == 24'h205752 (write))
  sdram_test_component_ram_module sdram_test_component_ram
    (
      .data      (rmw_temp),
      .q         (read_data),
      .rdaddress ((CODE == 24'h205752) ? test_addr : read_addr),
      .rdclken   (1'b1),
      .wraddress (test_addr),
      .wrclock   (clk),
      .wren      (CODE == 24'h205752)
    );

  assign cke = zs_cke;
  assign cs_n = zs_cs_n;
  assign ras_n = zs_ras_n;
  assign cas_n = zs_cas_n;
  assign we_n = zs_we_n;
  assign dqm = zs_dqm;
  assign ba = zs_ba;
  assign a = zs_addr;
  assign cmd_code = {ras_n, cas_n, we_n};
  assign CODE = (&cs_n) ? 24'h494e48 : txt_code;
  assign addr_col = a[7 : 0];
  assign test_addr = {addr_crb, addr_col};
  assign mem_bytes = read_data;
  assign rmw_temp[7 : 0] = dqm[0] ? mem_bytes[7 : 0] : zs_dq[7 : 0];
  assign rmw_temp[15 : 8] = dqm[1] ? mem_bytes[15 : 8] : zs_dq[15 : 8];
  // Handle Input.
  always @(posedge clk)
    begin
      // No Activity of Clock Disabled
      if (cke)
        begin
          // LMR: Get CAS_Latency.
          if (CODE == 24'h4c4d52)
              latency <= a[6 : 4];
          // ACT: Get Row/Bank Address.
          if (CODE == 24'h414354)
              addr_crb <= {ba[1], a, ba[0]};
          rd_valid_pipe[2] <= rd_valid_pipe[1];
          rd_valid_pipe[1] <= rd_valid_pipe[0];
          rd_valid_pipe[0] <= CODE == 24'h205244;
          rd_addr_pipe_2 <= rd_addr_pipe_1;
          rd_addr_pipe_1 <= rd_addr_pipe_0;
          rd_addr_pipe_0 <= test_addr;
          rd_mask_pipe_2 <= rd_mask_pipe_1;
          rd_mask_pipe_1 <= rd_mask_pipe_0;
          rd_mask_pipe_0 <= dqm;
        end
    end


  assign read_temp[7 : 0] = mask[0] ? 8'bz : read_data[7 : 0];
  assign read_temp[15 : 8] = mask[1] ? 8'bz : read_data[15 : 8];
  //use index to select which pipeline stage drives addr
  assign read_addr = (index == 0)? rd_addr_pipe_0 :
    (index == 1)? rd_addr_pipe_1 :
    rd_addr_pipe_2;

  //use index to select which pipeline stage drives mask
  assign read_mask = (index == 0)? rd_mask_pipe_0 :
    (index == 1)? rd_mask_pipe_1 :
    rd_mask_pipe_2;

  //use index to select which pipeline stage drives valid
  assign read_valid = (index == 0)? rd_valid_pipe[0] :
    (index == 1)? rd_valid_pipe[1] :
    rd_valid_pipe[2];

  assign index = latency - 1'b1;
  assign mask = read_mask;
  assign zs_dq = read_valid ? read_temp : {16{1'bz}};

//synthesis translate_off
//////////////// SIMULATION-ONLY CONTENTS
  assign txt_code = (cmd_code == 3'h0)? 24'h4c4d52 :
    (cmd_code == 3'h1)? 24'h415246 :
    (cmd_code == 3'h2)? 24'h505245 :
    (cmd_code == 3'h3)? 24'h414354 :
    (cmd_code == 3'h4)? 24'h205752 :
    (cmd_code == 3'h5)? 24'h205244 :
    (cmd_code == 3'h6)? 24'h425354 :
    (cmd_code == 3'h7)? 24'h4e4f50 :
    24'h424144;


//////////////// END SIMULATION-ONLY CONTENTS

//synthesis translate_on

endmodule

