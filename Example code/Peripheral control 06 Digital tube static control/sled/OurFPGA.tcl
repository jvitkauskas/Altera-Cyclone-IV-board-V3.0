##############################################
#      www.OurFPGA.com
##############################################


#------------------GLOBAL--------------------#
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
set_global_assignment -name ENABLE_INIT_DONE_OUTPUT OFF

set_location_assignment	PIN_23	-to	clock
set_location_assignment	PIN_131	-to	rst_n

#------------------SDRAM---------------------#
set_location_assignment	PIN_56	-to	S_DQ[0]
set_location_assignment	PIN_57	-to	S_DQ[1]
set_location_assignment	PIN_58	-to	S_DQ[2]
set_location_assignment	PIN_59	-to	S_DQ[3]
set_location_assignment	PIN_60	-to	S_DQ[4]
set_location_assignment	PIN_61	-to	S_DQ[5]
set_location_assignment	PIN_63	-to	S_DQ[6]
set_location_assignment	PIN_64	-to	S_DQ[7]
set_location_assignment	PIN_80	-to	S_DQ[8]
set_location_assignment	PIN_77	-to	S_DQ[9]
set_location_assignment	PIN_76	-to	S_DQ[10]
set_location_assignment	PIN_75	-to	S_DQ[11]
set_location_assignment	PIN_74	-to	S_DQ[12]
set_location_assignment	PIN_72	-to	S_DQ[13]
set_location_assignment	PIN_70	-to	S_DQ[14]
set_location_assignment	PIN_69	-to	S_DQ[15]

set_location_assignment	PIN_103	-to	S_A[0]
set_location_assignment	PIN_104	-to	S_A[1]
set_location_assignment	PIN_106	-to	S_A[2]
set_location_assignment	PIN_105	-to	S_A[3]
set_location_assignment	PIN_94	-to	S_A[4]
set_location_assignment	PIN_92	-to	S_A[5]
set_location_assignment	PIN_90	-to	S_A[6]
set_location_assignment	PIN_89	-to	S_A[7]
set_location_assignment	PIN_88	-to	S_A[8]
set_location_assignment	PIN_87	-to	S_A[9]
set_location_assignment	PIN_102	-to	S_A[10]
set_location_assignment	PIN_86	-to	S_A[11]

set_location_assignment	PIN_82	-to	S_CLK
set_location_assignment	PIN_99	-to	S_BA[0]
set_location_assignment	PIN_101	-to	S_BA[1]
set_location_assignment	PIN_95	-to	S_nCAS
set_location_assignment	PIN_84	-to	S_CKE
set_location_assignment	PIN_96	-to	S_nRAS
set_location_assignment	PIN_68	-to	S_nWE
set_location_assignment	PIN_97	-to	S_nCS
set_location_assignment	PIN_67	-to	S_DQM[0]
set_location_assignment	PIN_81	-to	S_DQM[1]

#--------------------LED----------------------#
set_location_assignment	PIN_142	-to	led[1]
set_location_assignment	PIN_141	-to	led[2]
set_location_assignment	PIN_139	-to	led[3]
set_location_assignment	PIN_138	-to	led[4]
set_location_assignment	PIN_137	-to	led[5]
set_location_assignment	PIN_135	-to	led[6]
set_location_assignment	PIN_134	-to	led[7]
set_location_assignment	PIN_133	-to	led[8]
#--------------------KEY----------------------#
set_location_assignment	PIN_107	-to	key[0]
set_location_assignment	PIN_108	-to	key[1]
set_location_assignment	PIN_110 -to	key[2]
set_location_assignment	PIN_112	-to	key[3]
set_location_assignment	PIN_113	-to	key[4]
set_location_assignment	PIN_114	-to	key[5]
set_location_assignment	PIN_115	-to	key[6]
set_location_assignment	PIN_116	-to	key[7]

#--------------------CKEY----------------------#
set_location_assignment	PIN_128	-to	ckey[1]
set_location_assignment	PIN_127	-to	ckey[2]
set_location_assignment	PIN_118 -to	ckey[3]
set_location_assignment	PIN_117	-to	ckey[4]

#--------------------DIG----------------------#
set_location_assignment	PIN_150	-to	dig[0]
set_location_assignment	PIN_149	-to	dig[1]
set_location_assignment	PIN_152	-to     dig[2]
set_location_assignment	PIN_151	-to	dig[3]
set_location_assignment	PIN_205	-to	dig[4]
set_location_assignment	PIN_206	-to	dig[5]
set_location_assignment	PIN_207	-to	dig[6]
set_location_assignment	PIN_208	-to     dig[7]

set_location_assignment	PIN_170 -to	seg[0]
set_location_assignment	PIN_165	-to     seg[1]
set_location_assignment	PIN_169	-to	seg[2]
set_location_assignment	PIN_175	-to	seg[3]
set_location_assignment	PIN_173	-to	seg[4]
set_location_assignment	PIN_168	-to     seg[5]
set_location_assignment	PIN_164	-to     seg[6]
set_location_assignment	PIN_171	-to     seg[7]

#--------------------BEEP----------------------#
set_location_assignment	PIN_3	-to	beep

#--------------------UART----------------------#
set_location_assignment	PIN_143	-to	rxd
set_location_assignment	PIN_144	-to	txd


#--------------------LCD----------------------#
set_location_assignment	PIN_180	-to	lcd[1]
set_location_assignment	PIN_185	-to	lcd[2]
set_location_assignment	PIN_182	-to     lcd[3]
set_location_assignment	PIN_188	-to	lcd[4]
set_location_assignment	PIN_187	-to	lcd[5]
set_location_assignment	PIN_191	-to	lcd[6]
set_location_assignment	PIN_189	-to	lcd[7]
set_location_assignment	PIN_193	-to     lcd[8]

set_location_assignment	PIN_192 -to	lcd[9]
set_location_assignment	PIN_197	-to     lcd[10]
set_location_assignment	PIN_195	-to	lcd[11]


#--------------------AD----------------------#
set_location_assignment	PIN_31	-to	adc_clk
set_location_assignment	PIN_33	-to	cs_n
set_location_assignment	PIN_30	-to     sdat_in


#--------------------DA----------------------#
set_location_assignment	PIN_47	-to	dac_clk
set_location_assignment	PIN_48	-to	dac_data
set_location_assignment	PIN_46	-to     dac_ldac
set_location_assignment	PIN_45	-to	dac_load


#--------------------PS2----------------------#
set_location_assignment	PIN_145	-to	ps2_clk
set_location_assignment	PIN_146	-to	ps2_dat

#--------------------DS18B20------------------#
set_location_assignment	PIN_147	-to	ds18b20

#--------------------VGA----------------------#
set_location_assignment	PIN_5	-to	hsync
set_location_assignment	PIN_4	-to	vsync
set_location_assignment	PIN_14	-to	vga_r[0]
set_location_assignment	PIN_15	-to	vga_r[1]
set_location_assignment	PIN_12	-to	vga_r[2]
set_location_assignment	PIN_13	-to	vga_g[0]
set_location_assignment	PIN_10	-to	vga_g[1]
set_location_assignment	PIN_11	-to	vga_g[2]
set_location_assignment	PIN_6	-to	vga_b[0]
set_location_assignment	PIN_8	-to	vga_b[1]

#--------------------RTC----------------------#
set_location_assignment	PIN_40	-to	rtc_scl
set_location_assignment	PIN_41	-to	rtc_sda

#--------------------IIC----------------------#
set_location_assignment	PIN_43	-to	i2c_scl
set_location_assignment	PIN_44	-to	i2c_sda

#------------------END-----------------------#





