# TCL File Generated by Component Editor 13.1
# Mon Feb 24 22:44:17 PST 2014
# DO NOT MODIFY


# 
# mm_to_st_adapter "Avalon MM to ST Adapter" v1.0
#  2014.02.24.22:44:17
# 
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module mm_to_st_adapter
# 
set_module_property DESCRIPTION ""
set_module_property NAME mm_to_st_adapter
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "Avalon MM to ST Adapter"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL mm_to_st_adapter
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file mm_to_st_adapter.sv SYSTEM_VERILOG PATH mm_to_st_adapter.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL mm_to_st_adapter
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file mm_to_st_adapter.sv SYSTEM_VERILOG PATH mm_to_st_adapter.sv


# 
# parameters
# 
add_parameter WIDTH INTEGER 8
set_parameter_property WIDTH DEFAULT_VALUE 8
set_parameter_property WIDTH DISPLAY_NAME WIDTH
set_parameter_property WIDTH TYPE INTEGER
set_parameter_property WIDTH UNITS None
set_parameter_property WIDTH ALLOWED_RANGES -2147483648:2147483647
set_parameter_property WIDTH HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock clock clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset reset reset Input 1


# 
# connection point avalon_mm_in
# 
add_interface avalon_mm_in avalon end
set_interface_property avalon_mm_in addressUnits WORDS
set_interface_property avalon_mm_in associatedClock clock
set_interface_property avalon_mm_in associatedReset reset
set_interface_property avalon_mm_in bitsPerSymbol 8
set_interface_property avalon_mm_in burstOnBurstBoundariesOnly false
set_interface_property avalon_mm_in burstcountUnits WORDS
set_interface_property avalon_mm_in explicitAddressSpan 0
set_interface_property avalon_mm_in holdTime 0
set_interface_property avalon_mm_in linewrapBursts false
set_interface_property avalon_mm_in maximumPendingReadTransactions 0
set_interface_property avalon_mm_in readLatency 0
set_interface_property avalon_mm_in readWaitTime 1
set_interface_property avalon_mm_in setupTime 0
set_interface_property avalon_mm_in timingUnits Cycles
set_interface_property avalon_mm_in writeWaitTime 0
set_interface_property avalon_mm_in ENABLED true
set_interface_property avalon_mm_in EXPORT_OF ""
set_interface_property avalon_mm_in PORT_NAME_MAP ""
set_interface_property avalon_mm_in CMSIS_SVD_VARIABLES ""
set_interface_property avalon_mm_in SVD_ADDRESS_GROUP ""

add_interface_port avalon_mm_in in_write write Input 1
add_interface_port avalon_mm_in in_writedata writedata Input WIDTH
add_interface_port avalon_mm_in in_waitrequest waitrequest Output 1
add_interface_port avalon_mm_in in_address address Input 2
set_interface_assignment avalon_mm_in embeddedsw.configuration.isFlash 0
set_interface_assignment avalon_mm_in embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment avalon_mm_in embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment avalon_mm_in embeddedsw.configuration.isPrintableDevice 0


# 
# connection point avalon_st_out
# 
add_interface avalon_st_out avalon_streaming start
set_interface_property avalon_st_out associatedClock clock
set_interface_property avalon_st_out associatedReset reset
set_interface_property avalon_st_out dataBitsPerSymbol 8
set_interface_property avalon_st_out errorDescriptor ""
set_interface_property avalon_st_out firstSymbolInHighOrderBits true
set_interface_property avalon_st_out maxChannel 0
set_interface_property avalon_st_out readyLatency 0
set_interface_property avalon_st_out ENABLED true
set_interface_property avalon_st_out EXPORT_OF ""
set_interface_property avalon_st_out PORT_NAME_MAP ""
set_interface_property avalon_st_out CMSIS_SVD_VARIABLES ""
set_interface_property avalon_st_out SVD_ADDRESS_GROUP ""

add_interface_port avalon_st_out out_valid valid Output 1
add_interface_port avalon_st_out out_data data Output WIDTH
add_interface_port avalon_st_out out_ready ready Input 1
add_interface_port avalon_st_out out_sop startofpacket Output 1
add_interface_port avalon_st_out out_eop endofpacket Output 1

