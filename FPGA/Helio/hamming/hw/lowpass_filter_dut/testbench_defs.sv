
`timescale 1ns/1ps

`define CLK_BFM 		  	tb.clock_bfm
`define RST_BFM 		  	tb.reset_bfm
`define MM_SLAVE_BFM 	tb.cutoff_bfm
`define ST_SINK_BFM 	 	tb.in_bfm
`define ST_SOURCE_BFM 	tb.out_bfm

`define VERBOSITY 				VERBOSITY_INFO

`define DUT_DATA_W 				8

`define MM_SLAVE_ADDRESS_W 	1
`define MM_SLAVE_SYMBOL_W   	`DUT_DATA_W
`define MM_SLAVE_NUMSYMBOLS 	1
`define MM_SLAVE_DATA_W 		`DUT_DATA_W

`define ST_SINK_DATA_W 			`DUT_DATA_W
`define ST_SOURCE_DATA_W 		`DUT_DATA_W