
########## Tcl recorder starts at 01/30/12 12:39:21 ##########

set version "1.5"
set proj_dir "C:/Users/tmcphillips/Designs/Projects/MACH64/VerilogHDL/10_CPU_5"
cd $proj_dir

# Get directory paths
set pver $version
regsub -all {\.} $pver {_} pver
set lscfile "lsc_"
append lscfile $pver ".ini"
set lsvini_dir [lindex [array get env LSC_INI_PATH] 1]
set lsvini_path [file join $lsvini_dir $lscfile]
if {[catch {set fid [open $lsvini_path]} msg]} {
	 puts "File Open Error: $lsvini_path"
	 return false
} else {set data [read $fid]; close $fid }
foreach line [split $data '\n'] { 
	set lline [string tolower $line]
	set lline [string trim $lline]
	if {[string compare $lline "\[paths\]"] == 0} { set path 1; continue}
	if {$path && [regexp {^\[} $lline]} {set path 0; break}
	if {$path && [regexp {^bin} $lline]} {set cpld_bin $line; continue}
	if {$path && [regexp {^fpgapath} $lline]} {set fpga_dir $line; continue}
	if {$path && [regexp {^fpgabinpath} $lline]} {set fpga_bin $line}}

set cpld_bin [string range $cpld_bin [expr [string first "=" $cpld_bin]+1] end]
regsub -all "\"" $cpld_bin "" cpld_bin
set cpld_bin [file join $cpld_bin]
set install_dir [string range $cpld_bin 0 [expr [string first "ispcpld" $cpld_bin]-2]]
regsub -all "\"" $install_dir "" install_dir
set install_dir [file join $install_dir]
set fpga_dir [string range $fpga_dir [expr [string first "=" $fpga_dir]+1] end]
regsub -all "\"" $fpga_dir "" fpga_dir
set fpga_dir [file join $fpga_dir]
set fpga_bin [string range $fpga_bin [expr [string first "=" $fpga_bin]+1] end]
regsub -all "\"" $fpga_bin "" fpga_bin
set fpga_bin [file join $fpga_bin]

if {[string match "*$fpga_bin;*" $env(PATH)] == 0 } {
   set env(PATH) "$fpga_bin;$env(PATH)" }

if {[string match "*$cpld_bin;*" $env(PATH)] == 0 } {
   set env(PATH) "$cpld_bin;$env(PATH)" }

lappend auto_path [file join $install_dir "ispcpld" "tcltk" "lib" "ispwidget" "runproc"]
package require runcmd

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" fourbitcpu.v -p \"$install_dir/ispcpld/generic\" -predefine mach64_verilog_project.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 12:39:21 ###########


########## Tcl recorder starts at 01/30/12 12:39:26 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open FourBitCPU.cmd w} rspFile] {
	puts stderr "Cannot create response file FourBitCPU.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: mach64_verilog_project.sty
PROJECT: FourBitCPU
WORKING_PATH: \"$proj_dir\"
MODULE: FourBitCPU
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" mach64_verilog_project.h fourbitcpu.v
OUTPUT_FILE_NAME: FourBitCPU
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e FourBitCPU -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete FourBitCPU.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf FourBitCPU.edi -out FourBitCPU.bl0 -err automake.err -log FourBitCPU.log -prj mach64_verilog_project -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" FourBitCPU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"FourBitCPU.bl1\" -o \"mach64_verilog_project.bl2\" -omod \"mach64_verilog_project\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj mach64_verilog_project -lci mach64_verilog_project.lct -log mach64_verilog_project.imp -err automake.err -tti mach64_verilog_project.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -blifopt mach64_verilog_project.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" mach64_verilog_project.bl2 -sweep -mergefb -err automake.err -o mach64_verilog_project.bl3 @mach64_verilog_project.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -diofft mach64_verilog_project.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" mach64_verilog_project.bl3 -family AMDMACH -idev van -o mach64_verilog_project.bl4 -oxrf mach64_verilog_project.xrf -err automake.err @mach64_verilog_project.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -prefit mach64_verilog_project.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp mach64_verilog_project.bl4 -out mach64_verilog_project.bl5 -err automake.err -log mach64_verilog_project.log -mod FourBitCPU @mach64_verilog_project.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open mach64_verilog_project.rs1 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs1: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -nojed -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open mach64_verilog_project.rs2 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs2: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@mach64_verilog_project.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete mach64_verilog_project.rs1
file delete mach64_verilog_project.rs2
if [runCmd "\"$cpld_bin/tda\" -i mach64_verilog_project.bl5 -o mach64_verilog_project.tda -lci mach64_verilog_project.lct -dev m4s_64_32 -family lc4k -mod FourBitCPU -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj mach64_verilog_project -if mach64_verilog_project.jed -j2s -log mach64_verilog_project.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 12:39:26 ###########


########## Tcl recorder starts at 01/30/12 12:49:54 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" fourbitcpu.v -p \"$install_dir/ispcpld/generic\" -predefine mach64_verilog_project.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 12:49:54 ###########


########## Tcl recorder starts at 01/30/12 12:51:18 ##########

# Commands to make the Process: 
# Compile EDIF File
if [catch {open FourBitCPU.cmd w} rspFile] {
	puts stderr "Cannot create response file FourBitCPU.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: mach64_verilog_project.sty
PROJECT: FourBitCPU
WORKING_PATH: \"$proj_dir\"
MODULE: FourBitCPU
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" mach64_verilog_project.h fourbitcpu.v
OUTPUT_FILE_NAME: FourBitCPU
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e FourBitCPU -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete FourBitCPU.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf FourBitCPU.edi -out FourBitCPU.bl0 -err automake.err -log FourBitCPU.log -prj mach64_verilog_project -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 12:51:18 ###########


########## Tcl recorder starts at 01/30/12 12:52:03 ##########

# Commands to make the Process: 
# Fit Design
if [runCmd "\"$cpld_bin/mblifopt\" FourBitCPU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"FourBitCPU.bl1\" -o \"mach64_verilog_project.bl2\" -omod \"mach64_verilog_project\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj mach64_verilog_project -lci mach64_verilog_project.lct -log mach64_verilog_project.imp -err automake.err -tti mach64_verilog_project.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -blifopt mach64_verilog_project.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" mach64_verilog_project.bl2 -sweep -mergefb -err automake.err -o mach64_verilog_project.bl3 @mach64_verilog_project.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -diofft mach64_verilog_project.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" mach64_verilog_project.bl3 -family AMDMACH -idev van -o mach64_verilog_project.bl4 -oxrf mach64_verilog_project.xrf -err automake.err @mach64_verilog_project.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -prefit mach64_verilog_project.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp mach64_verilog_project.bl4 -out mach64_verilog_project.bl5 -err automake.err -log mach64_verilog_project.log -mod FourBitCPU @mach64_verilog_project.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open mach64_verilog_project.rs1 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs1: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -nojed -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open mach64_verilog_project.rs2 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs2: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@mach64_verilog_project.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete mach64_verilog_project.rs1
file delete mach64_verilog_project.rs2
if [runCmd "\"$cpld_bin/tda\" -i mach64_verilog_project.bl5 -o mach64_verilog_project.tda -lci mach64_verilog_project.lct -dev m4s_64_32 -family lc4k -mod FourBitCPU -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj mach64_verilog_project -if mach64_verilog_project.jed -j2s -log mach64_verilog_project.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 12:52:03 ###########


########## Tcl recorder starts at 01/30/12 12:57:14 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" fourbitcpu.v -p \"$install_dir/ispcpld/generic\" -predefine mach64_verilog_project.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 12:57:14 ###########


########## Tcl recorder starts at 01/30/12 12:57:16 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open FourBitCPU.cmd w} rspFile] {
	puts stderr "Cannot create response file FourBitCPU.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: mach64_verilog_project.sty
PROJECT: FourBitCPU
WORKING_PATH: \"$proj_dir\"
MODULE: FourBitCPU
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" mach64_verilog_project.h fourbitcpu.v
OUTPUT_FILE_NAME: FourBitCPU
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e FourBitCPU -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete FourBitCPU.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf FourBitCPU.edi -out FourBitCPU.bl0 -err automake.err -log FourBitCPU.log -prj mach64_verilog_project -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" FourBitCPU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"FourBitCPU.bl1\" -o \"mach64_verilog_project.bl2\" -omod \"mach64_verilog_project\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj mach64_verilog_project -lci mach64_verilog_project.lct -log mach64_verilog_project.imp -err automake.err -tti mach64_verilog_project.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -blifopt mach64_verilog_project.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" mach64_verilog_project.bl2 -sweep -mergefb -err automake.err -o mach64_verilog_project.bl3 @mach64_verilog_project.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -diofft mach64_verilog_project.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" mach64_verilog_project.bl3 -family AMDMACH -idev van -o mach64_verilog_project.bl4 -oxrf mach64_verilog_project.xrf -err automake.err @mach64_verilog_project.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -prefit mach64_verilog_project.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp mach64_verilog_project.bl4 -out mach64_verilog_project.bl5 -err automake.err -log mach64_verilog_project.log -mod FourBitCPU @mach64_verilog_project.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open mach64_verilog_project.rs1 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs1: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -nojed -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open mach64_verilog_project.rs2 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs2: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@mach64_verilog_project.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete mach64_verilog_project.rs1
file delete mach64_verilog_project.rs2
if [runCmd "\"$cpld_bin/tda\" -i mach64_verilog_project.bl5 -o mach64_verilog_project.tda -lci mach64_verilog_project.lct -dev m4s_64_32 -family lc4k -mod FourBitCPU -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj mach64_verilog_project -if mach64_verilog_project.jed -j2s -log mach64_verilog_project.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 12:57:17 ###########


########## Tcl recorder starts at 01/30/12 12:59:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" fourbitcpu.v -p \"$install_dir/ispcpld/generic\" -predefine mach64_verilog_project.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 12:59:47 ###########


########## Tcl recorder starts at 01/30/12 12:59:49 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open FourBitCPU.cmd w} rspFile] {
	puts stderr "Cannot create response file FourBitCPU.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: mach64_verilog_project.sty
PROJECT: FourBitCPU
WORKING_PATH: \"$proj_dir\"
MODULE: FourBitCPU
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" mach64_verilog_project.h fourbitcpu.v
OUTPUT_FILE_NAME: FourBitCPU
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e FourBitCPU -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete FourBitCPU.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf FourBitCPU.edi -out FourBitCPU.bl0 -err automake.err -log FourBitCPU.log -prj mach64_verilog_project -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" FourBitCPU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"FourBitCPU.bl1\" -o \"mach64_verilog_project.bl2\" -omod \"mach64_verilog_project\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj mach64_verilog_project -lci mach64_verilog_project.lct -log mach64_verilog_project.imp -err automake.err -tti mach64_verilog_project.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -blifopt mach64_verilog_project.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" mach64_verilog_project.bl2 -sweep -mergefb -err automake.err -o mach64_verilog_project.bl3 @mach64_verilog_project.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -diofft mach64_verilog_project.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" mach64_verilog_project.bl3 -family AMDMACH -idev van -o mach64_verilog_project.bl4 -oxrf mach64_verilog_project.xrf -err automake.err @mach64_verilog_project.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -prefit mach64_verilog_project.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp mach64_verilog_project.bl4 -out mach64_verilog_project.bl5 -err automake.err -log mach64_verilog_project.log -mod FourBitCPU @mach64_verilog_project.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open mach64_verilog_project.rs1 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs1: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -nojed -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open mach64_verilog_project.rs2 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs2: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@mach64_verilog_project.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete mach64_verilog_project.rs1
file delete mach64_verilog_project.rs2
if [runCmd "\"$cpld_bin/tda\" -i mach64_verilog_project.bl5 -o mach64_verilog_project.tda -lci mach64_verilog_project.lct -dev m4s_64_32 -family lc4k -mod FourBitCPU -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj mach64_verilog_project -if mach64_verilog_project.jed -j2s -log mach64_verilog_project.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 12:59:49 ###########


########## Tcl recorder starts at 01/30/12 13:00:11 ##########

# Commands to make the Process: 
# Fitter Report (HTML)
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj mach64_verilog_project -if mach64_verilog_project.jed -j2s -log mach64_verilog_project.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 13:00:11 ###########


########## Tcl recorder starts at 01/30/12 13:06:33 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" fourbitcpu.v -p \"$install_dir/ispcpld/generic\" -predefine mach64_verilog_project.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 13:06:33 ###########


########## Tcl recorder starts at 01/30/12 13:06:35 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open FourBitCPU.cmd w} rspFile] {
	puts stderr "Cannot create response file FourBitCPU.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: mach64_verilog_project.sty
PROJECT: FourBitCPU
WORKING_PATH: \"$proj_dir\"
MODULE: FourBitCPU
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" mach64_verilog_project.h fourbitcpu.v
OUTPUT_FILE_NAME: FourBitCPU
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e FourBitCPU -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete FourBitCPU.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf FourBitCPU.edi -out FourBitCPU.bl0 -err automake.err -log FourBitCPU.log -prj mach64_verilog_project -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" FourBitCPU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"FourBitCPU.bl1\" -o \"mach64_verilog_project.bl2\" -omod \"mach64_verilog_project\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj mach64_verilog_project -lci mach64_verilog_project.lct -log mach64_verilog_project.imp -err automake.err -tti mach64_verilog_project.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -blifopt mach64_verilog_project.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" mach64_verilog_project.bl2 -sweep -mergefb -err automake.err -o mach64_verilog_project.bl3 @mach64_verilog_project.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -diofft mach64_verilog_project.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" mach64_verilog_project.bl3 -family AMDMACH -idev van -o mach64_verilog_project.bl4 -oxrf mach64_verilog_project.xrf -err automake.err @mach64_verilog_project.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -prefit mach64_verilog_project.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp mach64_verilog_project.bl4 -out mach64_verilog_project.bl5 -err automake.err -log mach64_verilog_project.log -mod FourBitCPU @mach64_verilog_project.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open mach64_verilog_project.rs1 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs1: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -nojed -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open mach64_verilog_project.rs2 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs2: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@mach64_verilog_project.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete mach64_verilog_project.rs1
file delete mach64_verilog_project.rs2
if [runCmd "\"$cpld_bin/tda\" -i mach64_verilog_project.bl5 -o mach64_verilog_project.tda -lci mach64_verilog_project.lct -dev m4s_64_32 -family lc4k -mod FourBitCPU -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj mach64_verilog_project -if mach64_verilog_project.jed -j2s -log mach64_verilog_project.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 13:06:35 ###########


########## Tcl recorder starts at 01/30/12 13:07:13 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" fourbitcpu.v -p \"$install_dir/ispcpld/generic\" -predefine mach64_verilog_project.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 13:07:13 ###########


########## Tcl recorder starts at 01/30/12 13:07:15 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open FourBitCPU.cmd w} rspFile] {
	puts stderr "Cannot create response file FourBitCPU.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: mach64_verilog_project.sty
PROJECT: FourBitCPU
WORKING_PATH: \"$proj_dir\"
MODULE: FourBitCPU
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" mach64_verilog_project.h fourbitcpu.v
OUTPUT_FILE_NAME: FourBitCPU
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e FourBitCPU -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete FourBitCPU.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf FourBitCPU.edi -out FourBitCPU.bl0 -err automake.err -log FourBitCPU.log -prj mach64_verilog_project -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" FourBitCPU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"FourBitCPU.bl1\" -o \"mach64_verilog_project.bl2\" -omod \"mach64_verilog_project\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj mach64_verilog_project -lci mach64_verilog_project.lct -log mach64_verilog_project.imp -err automake.err -tti mach64_verilog_project.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -blifopt mach64_verilog_project.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" mach64_verilog_project.bl2 -sweep -mergefb -err automake.err -o mach64_verilog_project.bl3 @mach64_verilog_project.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -diofft mach64_verilog_project.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" mach64_verilog_project.bl3 -family AMDMACH -idev van -o mach64_verilog_project.bl4 -oxrf mach64_verilog_project.xrf -err automake.err @mach64_verilog_project.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -prefit mach64_verilog_project.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp mach64_verilog_project.bl4 -out mach64_verilog_project.bl5 -err automake.err -log mach64_verilog_project.log -mod FourBitCPU @mach64_verilog_project.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open mach64_verilog_project.rs1 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs1: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -nojed -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open mach64_verilog_project.rs2 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs2: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@mach64_verilog_project.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete mach64_verilog_project.rs1
file delete mach64_verilog_project.rs2
if [runCmd "\"$cpld_bin/tda\" -i mach64_verilog_project.bl5 -o mach64_verilog_project.tda -lci mach64_verilog_project.lct -dev m4s_64_32 -family lc4k -mod FourBitCPU -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj mach64_verilog_project -if mach64_verilog_project.jed -j2s -log mach64_verilog_project.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 13:07:15 ###########


########## Tcl recorder starts at 01/30/12 13:14:02 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" fourbitcpu.v -p \"$install_dir/ispcpld/generic\" -predefine mach64_verilog_project.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 13:14:02 ###########


########## Tcl recorder starts at 01/30/12 13:14:03 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open FourBitCPU.cmd w} rspFile] {
	puts stderr "Cannot create response file FourBitCPU.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: mach64_verilog_project.sty
PROJECT: FourBitCPU
WORKING_PATH: \"$proj_dir\"
MODULE: FourBitCPU
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" mach64_verilog_project.h fourbitcpu.v
OUTPUT_FILE_NAME: FourBitCPU
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e FourBitCPU -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete FourBitCPU.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf FourBitCPU.edi -out FourBitCPU.bl0 -err automake.err -log FourBitCPU.log -prj mach64_verilog_project -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" FourBitCPU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"FourBitCPU.bl1\" -o \"mach64_verilog_project.bl2\" -omod \"mach64_verilog_project\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj mach64_verilog_project -lci mach64_verilog_project.lct -log mach64_verilog_project.imp -err automake.err -tti mach64_verilog_project.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -blifopt mach64_verilog_project.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" mach64_verilog_project.bl2 -sweep -mergefb -err automake.err -o mach64_verilog_project.bl3 @mach64_verilog_project.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -diofft mach64_verilog_project.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" mach64_verilog_project.bl3 -family AMDMACH -idev van -o mach64_verilog_project.bl4 -oxrf mach64_verilog_project.xrf -err automake.err @mach64_verilog_project.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -prefit mach64_verilog_project.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp mach64_verilog_project.bl4 -out mach64_verilog_project.bl5 -err automake.err -log mach64_verilog_project.log -mod FourBitCPU @mach64_verilog_project.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open mach64_verilog_project.rs1 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs1: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -nojed -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open mach64_verilog_project.rs2 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs2: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@mach64_verilog_project.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete mach64_verilog_project.rs1
file delete mach64_verilog_project.rs2
if [runCmd "\"$cpld_bin/tda\" -i mach64_verilog_project.bl5 -o mach64_verilog_project.tda -lci mach64_verilog_project.lct -dev m4s_64_32 -family lc4k -mod FourBitCPU -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj mach64_verilog_project -if mach64_verilog_project.jed -j2s -log mach64_verilog_project.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 13:14:03 ###########


########## Tcl recorder starts at 01/30/12 13:20:11 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" fourbitcpu.v -p \"$install_dir/ispcpld/generic\" -predefine mach64_verilog_project.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 13:20:11 ###########


########## Tcl recorder starts at 01/30/12 13:20:13 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open FourBitCPU.cmd w} rspFile] {
	puts stderr "Cannot create response file FourBitCPU.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: mach64_verilog_project.sty
PROJECT: FourBitCPU
WORKING_PATH: \"$proj_dir\"
MODULE: FourBitCPU
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" mach64_verilog_project.h fourbitcpu.v
OUTPUT_FILE_NAME: FourBitCPU
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e FourBitCPU -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete FourBitCPU.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf FourBitCPU.edi -out FourBitCPU.bl0 -err automake.err -log FourBitCPU.log -prj mach64_verilog_project -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" FourBitCPU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"FourBitCPU.bl1\" -o \"mach64_verilog_project.bl2\" -omod \"mach64_verilog_project\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj mach64_verilog_project -lci mach64_verilog_project.lct -log mach64_verilog_project.imp -err automake.err -tti mach64_verilog_project.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -blifopt mach64_verilog_project.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" mach64_verilog_project.bl2 -sweep -mergefb -err automake.err -o mach64_verilog_project.bl3 @mach64_verilog_project.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -diofft mach64_verilog_project.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" mach64_verilog_project.bl3 -family AMDMACH -idev van -o mach64_verilog_project.bl4 -oxrf mach64_verilog_project.xrf -err automake.err @mach64_verilog_project.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -prefit mach64_verilog_project.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp mach64_verilog_project.bl4 -out mach64_verilog_project.bl5 -err automake.err -log mach64_verilog_project.log -mod FourBitCPU @mach64_verilog_project.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open mach64_verilog_project.rs1 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs1: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -nojed -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open mach64_verilog_project.rs2 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs2: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@mach64_verilog_project.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete mach64_verilog_project.rs1
file delete mach64_verilog_project.rs2
if [runCmd "\"$cpld_bin/tda\" -i mach64_verilog_project.bl5 -o mach64_verilog_project.tda -lci mach64_verilog_project.lct -dev m4s_64_32 -family lc4k -mod FourBitCPU -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj mach64_verilog_project -if mach64_verilog_project.jed -j2s -log mach64_verilog_project.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 13:20:13 ###########


########## Tcl recorder starts at 01/30/12 13:23:45 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" fourbitcpu.v -p \"$install_dir/ispcpld/generic\" -predefine mach64_verilog_project.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 13:23:45 ###########


########## Tcl recorder starts at 01/30/12 13:23:47 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open FourBitCPU.cmd w} rspFile] {
	puts stderr "Cannot create response file FourBitCPU.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: mach64_verilog_project.sty
PROJECT: FourBitCPU
WORKING_PATH: \"$proj_dir\"
MODULE: FourBitCPU
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" mach64_verilog_project.h fourbitcpu.v
OUTPUT_FILE_NAME: FourBitCPU
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e FourBitCPU -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete FourBitCPU.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf FourBitCPU.edi -out FourBitCPU.bl0 -err automake.err -log FourBitCPU.log -prj mach64_verilog_project -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" FourBitCPU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"FourBitCPU.bl1\" -o \"mach64_verilog_project.bl2\" -omod \"mach64_verilog_project\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj mach64_verilog_project -lci mach64_verilog_project.lct -log mach64_verilog_project.imp -err automake.err -tti mach64_verilog_project.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -blifopt mach64_verilog_project.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" mach64_verilog_project.bl2 -sweep -mergefb -err automake.err -o mach64_verilog_project.bl3 @mach64_verilog_project.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -diofft mach64_verilog_project.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" mach64_verilog_project.bl3 -family AMDMACH -idev van -o mach64_verilog_project.bl4 -oxrf mach64_verilog_project.xrf -err automake.err @mach64_verilog_project.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -prefit mach64_verilog_project.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp mach64_verilog_project.bl4 -out mach64_verilog_project.bl5 -err automake.err -log mach64_verilog_project.log -mod FourBitCPU @mach64_verilog_project.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open mach64_verilog_project.rs1 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs1: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -nojed -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open mach64_verilog_project.rs2 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs2: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@mach64_verilog_project.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete mach64_verilog_project.rs1
file delete mach64_verilog_project.rs2
if [runCmd "\"$cpld_bin/tda\" -i mach64_verilog_project.bl5 -o mach64_verilog_project.tda -lci mach64_verilog_project.lct -dev m4s_64_32 -family lc4k -mod FourBitCPU -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj mach64_verilog_project -if mach64_verilog_project.jed -j2s -log mach64_verilog_project.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 13:23:47 ###########


########## Tcl recorder starts at 01/30/12 13:30:47 ##########

# Commands to make the Process: 
# Hierarchy
if [runCmd "\"$cpld_bin/vlog2jhd\" fourbitcpu.v -p \"$install_dir/ispcpld/generic\" -predefine mach64_verilog_project.h"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 13:30:47 ###########


########## Tcl recorder starts at 01/30/12 13:30:49 ##########

# Commands to make the Process: 
# Fit Design
if [catch {open FourBitCPU.cmd w} rspFile] {
	puts stderr "Cannot create response file FourBitCPU.cmd: $rspFile"
} else {
	puts $rspFile "STYFILENAME: mach64_verilog_project.sty
PROJECT: FourBitCPU
WORKING_PATH: \"$proj_dir\"
MODULE: FourBitCPU
VERILOG_FILE_LIST: \"$install_dir/ispcpld/../cae_library/synthesis/verilog/mach.v\" mach64_verilog_project.h fourbitcpu.v
OUTPUT_FILE_NAME: FourBitCPU
SUFFIX_NAME: edi
Vlog_std_v2001: true
FREQUENCY:  200
FANIN_LIMIT:  20
DISABLE_IO_INSERTION: false
MAX_TERMS_PER_MACROCELL:  16
MAP_LOGIC: false
SYMBOLIC_FSM_COMPILER: true
NUM_CRITICAL_PATHS:   3
AUTO_CONSTRAIN_IO: true
NUM_STARTEND_POINTS:   0
AREADELAY:  0
WRITE_PRF: true
RESOURCE_SHARING: true
COMPILER_COMPATIBLE: true
DUP: false
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/Synpwrap\" -rem -e FourBitCPU -target ispmach4000b -pro "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete FourBitCPU.cmd
if [runCmd "\"$cpld_bin/edif2blf\" -edf FourBitCPU.edi -out FourBitCPU.bl0 -err automake.err -log FourBitCPU.log -prj mach64_verilog_project -lib \"$install_dir/ispcpld/dat/mach.edn\" -net_Vcc VCC -net_GND GND -nbx -dse -tlw -cvt YES -xor"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" FourBitCPU.bl0 -collapse none -reduce none -err automake.err  -keepwires"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblflink\" \"FourBitCPU.bl1\" -o \"mach64_verilog_project.bl2\" -omod \"mach64_verilog_project\"  -err \"automake.err\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/impsrc\"  -prj mach64_verilog_project -lci mach64_verilog_project.lct -log mach64_verilog_project.imp -err automake.err -tti mach64_verilog_project.bl2 -dir $proj_dir"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -blifopt mach64_verilog_project.b2_"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mblifopt\" mach64_verilog_project.bl2 -sweep -mergefb -err automake.err -o mach64_verilog_project.bl3 @mach64_verilog_project.b2_ "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -diofft mach64_verilog_project.d0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/mdiofft\" mach64_verilog_project.bl3 -family AMDMACH -idev van -o mach64_verilog_project.bl4 -oxrf mach64_verilog_project.xrf -err automake.err @mach64_verilog_project.d0 "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/abelvci\" -vci mach64_verilog_project.lct -dev lc4k -prefit mach64_verilog_project.l0"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/prefit\" -blif -inp mach64_verilog_project.bl4 -out mach64_verilog_project.bl5 -err automake.err -log mach64_verilog_project.log -mod FourBitCPU @mach64_verilog_project.l0  -sc"] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [catch {open mach64_verilog_project.rs1 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs1: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -nojed -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [catch {open mach64_verilog_project.rs2 w} rspFile] {
	puts stderr "Cannot create response file mach64_verilog_project.rs2: $rspFile"
} else {
	puts $rspFile "-i mach64_verilog_project.bl5 -lci mach64_verilog_project.lct -d m4s_64_32 -lco mach64_verilog_project.lco -html_rpt -fti mach64_verilog_project.fti -fmt PLA -tto mach64_verilog_project.tt4 -eqn mach64_verilog_project.eq3 -tmv NoInput.tmv
-rpt_num 1
"
	close $rspFile
}
if [runCmd "\"$cpld_bin/lpf4k\" \"@mach64_verilog_project.rs2\""] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
file delete mach64_verilog_project.rs1
file delete mach64_verilog_project.rs2
if [runCmd "\"$cpld_bin/tda\" -i mach64_verilog_project.bl5 -o mach64_verilog_project.tda -lci mach64_verilog_project.lct -dev m4s_64_32 -family lc4k -mod FourBitCPU -ovec NoInput.tmv -err tda.err "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}
if [runCmd "\"$cpld_bin/synsvf\" -exe \"$install_dir/ispvmsystem/ispufw\" -prj mach64_verilog_project -if mach64_verilog_project.jed -j2s -log mach64_verilog_project.svl "] {
	return
} else {
	vwait done
	if [checkResult $done] {
		return
	}
}

########## Tcl recorder end at 01/30/12 13:30:49 ###########

