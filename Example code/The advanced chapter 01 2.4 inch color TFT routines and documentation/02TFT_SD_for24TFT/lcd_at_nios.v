module lcd_at_nios( 
  input         CLOCK_50,
  input         Q_KEY,
  // ILI9325 Interface
  output        ILI_nRST,
  output        ILI_nCS,
  output        ILI_RS,
  output        ILI_nRD,
  output        ILI_nWR,
  inout  [ 7:0] ILI_DB,
  // ADS7803 Interface
  output        ADS_CLK,
  output        ADS_nCS,
  output        ADS_DIN,
  input         ADS_DOUT,
  input         ADS_BUSY,
  input         ADS_nIRQ,
  // SD Card Interface
  output        SD_CLK,
  output        SD_nCS,
  output        SD_DIN,
  input         SD_DOUT, 
  // SDRAM Interface
  output [11:0] SDRAM_ADDR,
  output [1 :0] SDRAM_BA,
  output        SDRAM_CAS_N,
  output        SDRAM_CLK,
  output        SDRAM_CKE,
  output        SDRAM_CS_N,
  inout  [15:0] SDRAM_DQ,
  output [ 1:0] SDRAM_DQM,
  output        SDRAM_RAS_N,
  output        SDRAM_WE_N,

  output        DCLK,
  output         SCE,
  output         SDO,
  input          DATA0
  
);

wire nii_clk, pll_locked; 
pll  pll_inst (
  .areset (~Q_KEY),
  .inclk0 (CLOCK_50),
  .c0     (nii_clk),
  .c1     (SDRAM_CLK),
  .locked (pll_locked)
);

nios_ii_sys nios_ii_sys_inst
(
  //
  .clk_100                           (nii_clk),
  .reset_n                           (Q_KEY & pll_locked),
  // ADS7803 Interface                           
  .in_port_to_the_ads_busy           (ADS_BUSY),
  .in_port_to_the_ads_dout           (ADS_DOUT),
  .in_port_to_the_ads_nirq           (ADS_nIRQ),
  .out_port_from_the_ads_clk         (ADS_CLK),
  .out_port_from_the_ads_din         (ADS_DIN),
  .out_port_from_the_ads_ncs         (ADS_nCS),
  // ILI9325 Interface
  .bidir_port_to_and_from_the_ili_db (ILI_DB),  
  .out_port_from_the_ili_ncs         (ILI_nCS),
  .out_port_from_the_ili_nrd         (ILI_nRD),
  .out_port_from_the_ili_nrst        (ILI_nRST),
  .out_port_from_the_ili_rs          (ILI_RS),
  .out_port_from_the_ili_nwr         (ILI_nWR),
  // SD Card Interface
  .out_port_from_the_sd_clk          (SD_CLK),
  .out_port_from_the_sd_din          (SD_DIN),
  .out_port_from_the_sd_ncs          (SD_nCS),
  .in_port_to_the_sd_dout            (SD_DOUT),
  // SDRAM Interface                      
  .zs_addr_from_the_sdram            (SDRAM_ADDR),
  .zs_ba_from_the_sdram              (SDRAM_BA),
  .zs_cas_n_from_the_sdram           (SDRAM_CAS_N),
  .zs_cke_from_the_sdram             (SDRAM_CKE),
  .zs_cs_n_from_the_sdram            (SDRAM_CS_N),
  .zs_dq_to_and_from_the_sdram       (SDRAM_DQ),
  .zs_dqm_from_the_sdram             (SDRAM_DQM),
  .zs_ras_n_from_the_sdram           (SDRAM_RAS_N),
  .zs_we_n_from_the_sdram            (SDRAM_WE_N),
  
  //EPCS interface
  .data0_to_the_epcs                (DATA0),
  .dclk_from_the_epcs                (DCLK),
  .sce_from_the_epcs                 (SCE),
  .sdo_from_the_epcs                 (SDO)
);

endmodule
