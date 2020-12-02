##############################################
#      www.OurFPGA.com
##############################################


#------------------GLOBAL--------------------#
set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
set_global_assignment -name ENABLE_INIT_DONE_OUTPUT OFF

set_location_assignment	PIN_23	-to	CLOCK_50
set_location_assignment	PIN_25	-to	Q_KEY

#------------------SDRAM---------------------#
set_location_assignment	PIN_28	-to	SDRAM_DQ[0]
set_location_assignment	PIN_30	-to	SDRAM_DQ[1]
set_location_assignment	PIN_31	-to	SDRAM_DQ[2]
set_location_assignment	PIN_32	-to	SDRAM_DQ[3]
set_location_assignment	PIN_33	-to	SDRAM_DQ[4]
set_location_assignment	PIN_34	-to	SDRAM_DQ[5]
set_location_assignment	PIN_38	-to	SDRAM_DQ[6]
set_location_assignment	PIN_39	-to	SDRAM_DQ[7]
set_location_assignment	PIN_54	-to	SDRAM_DQ[8]
set_location_assignment	PIN_53	-to	SDRAM_DQ[9]
set_location_assignment	PIN_52	-to	SDRAM_DQ[10]
set_location_assignment	PIN_51	-to	SDRAM_DQ[11]
set_location_assignment	PIN_50	-to	SDRAM_DQ[12]
set_location_assignment	PIN_49	-to	SDRAM_DQ[13]
set_location_assignment	PIN_46	-to	SDRAM_DQ[14]
set_location_assignment	PIN_44	-to	SDRAM_DQ[15]

set_location_assignment	PIN_76	-to	SDRAM_ADDR[0]
set_location_assignment	PIN_77	-to	SDRAM_ADDR[1]
set_location_assignment	PIN_80	-to	SDRAM_ADDR[2]
set_location_assignment	PIN_83	-to	SDRAM_ADDR[3]
set_location_assignment	PIN_68	-to	SDRAM_ADDR[4]
set_location_assignment	PIN_67	-to	SDRAM_ADDR[5]
set_location_assignment	PIN_66	-to	SDRAM_ADDR[6]
set_location_assignment	PIN_65	-to	SDRAM_ADDR[7]
set_location_assignment	PIN_64	-to	SDRAM_ADDR[8]
set_location_assignment	PIN_60	-to	SDRAM_ADDR[9]
set_location_assignment	PIN_75	-to	SDRAM_ADDR[10]
set_location_assignment	PIN_59	-to	SDRAM_ADDR[11]



set_location_assignment	PIN_43	-to	SDRAM_CLK
set_location_assignment	PIN_73	-to	SDRAM_BA[0]
set_location_assignment	PIN_74	-to	SDRAM_BA[1]
set_location_assignment	PIN_70	-to	SDRAM_CAS_N
set_location_assignment	PIN_58	-to	SDRAM_CKE
set_location_assignment	PIN_71	-to	SDRAM_RAS_N
set_location_assignment	PIN_69	-to	SDRAM_WE_N
set_location_assignment	PIN_72	-to	SDRAM_CS_N
set_location_assignment	PIN_42	-to	SDRAM_DQM[0]
set_location_assignment	PIN_55	-to	SDRAM_DQM[1]

#--------------------LED----------------------#
set_location_assignment	PIN_87	-to	led[1]
set_location_assignment	PIN_86	-to	led[2]


#-------------------EPCS----------------------#
set_location_assignment  PIN_13    -to    DATA0
set_location_assignment  PIN_12    -to    DCLK
set_location_assignment  PIN_8    -to    SCE
set_location_assignment  PIN_6    -to    SDO


#--------------------SD----------------------#
set_location_assignment	PIN_111	-to	SD_nCS
set_location_assignment	PIN_112	-to	SD_DIN
set_location_assignment	PIN_115	-to	SD_CLK
set_location_assignment	PIN_120	-to	SD_DOUT





#--------------------ili----------------------#
set_location_assignment	PIN_3	-to	ILI_RS
set_location_assignment	PIN_1	-to	ILI_nWR
set_location_assignment	PIN_113	-to	ILI_nRST
set_location_assignment	PIN_143	-to	ILI_nRD
set_location_assignment	PIN_114	-to	ILI_nCS

set_location_assignment	PIN_141	-to	ILI_DB[0]
set_location_assignment	PIN_137	-to	ILI_DB[1]
set_location_assignment	PIN_135	-to	ILI_DB[2]
set_location_assignment	PIN_132	-to	ILI_DB[3]
set_location_assignment	PIN_128	-to	ILI_DB[4]
set_location_assignment	PIN_125	-to	ILI_DB[5]
set_location_assignment	PIN_121	-to	ILI_DB[6]
set_location_assignment	PIN_119	-to	ILI_DB[7]

#--------------------ADS----------------------#
#set_location_assignment  PIN_129	-to	ADS_nCS
#set_location_assignment  PIN_127       -to	ADS_DIN
#set_location_assignment  PIN_133	-to	ADS_CLK
#set_location_assignment  PIN_124       -to	ADS_nIRQ

#set_location_assignment  PIN_      -to	ADS_BUSY


#set_location_assignment  PIN_126	-to	ADS_DOUT

#------------------END-----------------------#





