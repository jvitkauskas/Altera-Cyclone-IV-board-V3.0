##############################################
#      www.OurFPGA.com
##############################################


#------------------GLOBAL--------------------#
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
set_global_assignment -name ENABLE_INIT_DONE_OUTPUT OFF

set_location_assignment	PIN_23	-to	clk
set_location_assignment	PIN_25	-to	reset_n

#------------------SDRAM---------------------#
set_location_assignment	PIN_28	-to	sdram_data[0]
set_location_assignment	PIN_30	-to	sdram_data[1]
set_location_assignment	PIN_31	-to	sdram_data[2]
set_location_assignment	PIN_32	-to	sdram_data[3]
set_location_assignment	PIN_33	-to	sdram_data[4]
set_location_assignment	PIN_34	-to	sdram_data[5]
set_location_assignment	PIN_38	-to	sdram_data[6]
set_location_assignment	PIN_39	-to	sdram_data[7]
set_location_assignment	PIN_54	-to	sdram_data[8]
set_location_assignment	PIN_53	-to	sdram_data[9]
set_location_assignment	PIN_52	-to	sdram_data[10]
set_location_assignment	PIN_51	-to	sdram_data[11]
set_location_assignment	PIN_50	-to	sdram_data[12]
set_location_assignment	PIN_49	-to	sdram_data[13]
set_location_assignment	PIN_46	-to	sdram_data[14]
set_location_assignment	PIN_44	-to	sdram_data[15]

set_location_assignment	PIN_76	-to	sdram_addr[0]
set_location_assignment	PIN_77	-to	sdram_addr[1]
set_location_assignment	PIN_80	-to	sdram_addr[2]
set_location_assignment	PIN_83	-to	sdram_addr[3]
set_location_assignment	PIN_68	-to	sdram_addr[4]
set_location_assignment	PIN_67	-to	sdram_addr[5]
set_location_assignment	PIN_66	-to	sdram_addr[6]
set_location_assignment	PIN_65	-to	sdram_addr[7]
set_location_assignment	PIN_64	-to	sdram_addr[8]
set_location_assignment	PIN_60	-to	sdram_addr[9]
set_location_assignment	PIN_75	-to	sdram_addr[10]
set_location_assignment	PIN_59	-to	sdram_addr[11]



set_location_assignment	PIN_43	-to	sdram_clk
set_location_assignment	PIN_73	-to	sdram_ba[0]
set_location_assignment	PIN_74	-to	sdram_ba[1]
set_location_assignment	PIN_70	-to	sdram_cas_n
set_location_assignment	PIN_58	-to	sdram_cke
set_location_assignment	PIN_71	-to	sdram_ras_n
set_location_assignment	PIN_69	-to	sdram_we_n
set_location_assignment	PIN_72	-to	sdram_cs_n
set_location_assignment	PIN_42	-to	sdram_dqm[0]
set_location_assignment	PIN_55	-to	sdram_dqm[1]

#--------------------LED----------------------#
set_location_assignment	PIN_87	-to	led[1]
set_location_assignment	PIN_86	-to	led[2]


#-------------------EPCS----------------------#
set_location_assignment  PIN_13    -to    DATA0
set_location_assignment  PIN_12    -to    DCLK
set_location_assignment  PIN_8    -to    SCE
set_location_assignment  PIN_6    -to    SDO


#--------------------SD----------------------#
#set_location_assignment	PIN_111	-to	SD_nCS
#set_location_assignment	PIN_112	-to	SD_DIN
#set_location_assignment	PIN_115	-to	SD_CLK
#set_location_assignment	PIN_120	-to	SD_DOUT





#--------------------ili----------------------#
set_location_assignment	PIN_3	-to	out_port_from_the_ili_rs
set_location_assignment	PIN_1	-to	out_port_from_the_ili_nwr
set_location_assignment	PIN_113	-to	out_port_from_the_ili_nrst
set_location_assignment	PIN_143	-to	out_port_from_the_ili_nrd
set_location_assignment	PIN_114	-to	out_port_from_the_ili_ncs

set_location_assignment	PIN_141	-to	out_port_from_the_ili_db[0]
set_location_assignment	PIN_137	-to	out_port_from_the_ili_db[1]
set_location_assignment	PIN_135	-to	out_port_from_the_ili_db[2]
set_location_assignment	PIN_132	-to	out_port_from_the_ili_db[3]
set_location_assignment	PIN_128	-to	out_port_from_the_ili_db[4]
set_location_assignment	PIN_125	-to	out_port_from_the_ili_db[5]
set_location_assignment	PIN_121	-to	out_port_from_the_ili_db[6]
set_location_assignment	PIN_119	-to	out_port_from_the_ili_db[7]

#--------------------ADS----------------------#
#set_location_assignment  PIN_129	-to	ADS_nCS
#set_location_assignment  PIN_127       -to	ADS_DIN
#set_location_assignment  PIN_133	-to	ADS_CLK
#set_location_assignment  PIN_124       -to	ADS_nIRQ

#set_location_assignment  PIN_      -to	ADS_BUSY


#set_location_assignment  PIN_126	-to	ADS_DOUT

#------------------END-----------------------#





