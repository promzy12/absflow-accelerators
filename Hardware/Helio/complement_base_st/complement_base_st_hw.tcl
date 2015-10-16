# TCL File Generated by Component Editor 13.1
# Fri Jan 17 14:13:24 PST 2014
# DO NOT MODIFY


# 
# complement_base_st "complement_base_st" v1.0
#  2014.01.17.14:13:24
# 
# 

# 
# request TCL package from ACDS 13.1
# 
package require -exact qsys 13.1


# 
# module complement_base_st
# 
set_module_property DESCRIPTION ""
set_module_property NAME complement_base_st
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME complement_base_st
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property ANALYZE_HDL AUTO
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL complement_base_st
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file complement_base_st.v VERILOG PATH complement_base_st.v TOP_LEVEL_FILE
add_fileset_file complement_base.v VERILOG PATH complement_base.v

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL complement_base_st
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
add_fileset_file complement_base_st.v VERILOG PATH complement_base_st.v
add_fileset_file complement_base.v VERILOG PATH complement_base.v


# 
# parameters
# 


# 
# display items
# 


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
# connection point src
# 
add_interface src avalon_streaming start
set_interface_property src associatedClock clock
set_interface_property src associatedReset reset
set_interface_property src dataBitsPerSymbol 8
set_interface_property src errorDescriptor ""
set_interface_property src firstSymbolInHighOrderBits true
set_interface_property src maxChannel 0
set_interface_property src readyLatency 0
set_interface_property src ENABLED true
set_interface_property src EXPORT_OF ""
set_interface_property src PORT_NAME_MAP ""
set_interface_property src CMSIS_SVD_VARIABLES ""
set_interface_property src SVD_ADDRESS_GROUP ""

add_interface_port src out_valid valid Output 1
add_interface_port src out_data data Output 8
add_interface_port src out_ready ready Input 1


# 
# connection point sink
# 
add_interface sink avalon_streaming end
set_interface_property sink associatedClock clock
set_interface_property sink associatedReset reset
set_interface_property sink dataBitsPerSymbol 8
set_interface_property sink errorDescriptor ""
set_interface_property sink firstSymbolInHighOrderBits true
set_interface_property sink maxChannel 0
set_interface_property sink readyLatency 0
set_interface_property sink ENABLED true
set_interface_property sink EXPORT_OF ""
set_interface_property sink PORT_NAME_MAP ""
set_interface_property sink CMSIS_SVD_VARIABLES ""
set_interface_property sink SVD_ADDRESS_GROUP ""

add_interface_port sink in_ready ready Output 1
add_interface_port sink in_valid valid Input 1
add_interface_port sink in_data data Input 8

