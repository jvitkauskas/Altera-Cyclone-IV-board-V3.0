  --Example instantiation for system 'nios32'
  nios32_inst : nios32
    port map(
      bidir_port_to_and_from_the_ili_db => bidir_port_to_and_from_the_ili_db,
      dclk_from_the_epcs_flash_controller => dclk_from_the_epcs_flash_controller,
      out_port_from_the_ads_clk => out_port_from_the_ads_clk,
      out_port_from_the_ads_din => out_port_from_the_ads_din,
      out_port_from_the_ads_ncs => out_port_from_the_ads_ncs,
      out_port_from_the_ili_ncs => out_port_from_the_ili_ncs,
      out_port_from_the_ili_nrd => out_port_from_the_ili_nrd,
      out_port_from_the_ili_nrst => out_port_from_the_ili_nrst,
      out_port_from_the_ili_nwr => out_port_from_the_ili_nwr,
      out_port_from_the_ili_rs => out_port_from_the_ili_rs,
      out_port_from_the_sd_clk => out_port_from_the_sd_clk,
      out_port_from_the_sd_din => out_port_from_the_sd_din,
      out_port_from_the_sd_ncs => out_port_from_the_sd_ncs,
      sce_from_the_epcs_flash_controller => sce_from_the_epcs_flash_controller,
      sdo_from_the_epcs_flash_controller => sdo_from_the_epcs_flash_controller,
      zs_addr_from_the_sdram => zs_addr_from_the_sdram,
      zs_ba_from_the_sdram => zs_ba_from_the_sdram,
      zs_cas_n_from_the_sdram => zs_cas_n_from_the_sdram,
      zs_cke_from_the_sdram => zs_cke_from_the_sdram,
      zs_cs_n_from_the_sdram => zs_cs_n_from_the_sdram,
      zs_dq_to_and_from_the_sdram => zs_dq_to_and_from_the_sdram,
      zs_dqm_from_the_sdram => zs_dqm_from_the_sdram,
      zs_ras_n_from_the_sdram => zs_ras_n_from_the_sdram,
      zs_we_n_from_the_sdram => zs_we_n_from_the_sdram,
      clk => clk,
      data0_to_the_epcs_flash_controller => data0_to_the_epcs_flash_controller,
      in_port_to_the_ads_busy => in_port_to_the_ads_busy,
      in_port_to_the_ads_dout => in_port_to_the_ads_dout,
      in_port_to_the_ads_nirq => in_port_to_the_ads_nirq,
      in_port_to_the_sd_dout => in_port_to_the_sd_dout,
      reset_n => reset_n
    );


