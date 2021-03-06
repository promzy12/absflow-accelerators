import ovm_pkg::*;
import bdb_tb_transactions_pkg::*;

module bdb_tb_driver (
  ref tlm_fifo #(bdb_operation) op_fifo,
  ref tlm_fifo #(bdb_operation) op2prd_fifo,
  output bit         clock,
 	output bit         button,
	output bit 		      reset );
	
	bdb_operation request;
	string m = "";
	
	initial $sformat(m, "%m");
	
	initial begin : clockgen
	  clock = 0;
	  forever #10 clock = ~clock;
	end
	
	initial begin : resetgen
	  
	  button = 0;

    reset = 1;
	  @(posedge clock);
	  @(posedge clock);
	  reset = 0;
	  
	end
    
  always @(negedge clock) begin : drive_transactions
    
    if (op_fifo.try_get(request)) begin : new_transaction
      
      ovm_top.ovm_report_info(m, request.convert2string(), 300);
      
      // forward current request to predictor
      op2prd_fifo.put(request.clone);
      
      // keep signals to DUT low for requested number of clock cycles
      repeat(request.waits - 1) @(negedge clock);
      
      // send the operation-specific control signal to the DUT
      case (request.op)
        press_op:   button = 1;
        reset_op:   reset = 1;
      endcase
        
      // hold signals to the DUT for the requested number of clock cycles
      repeat(request.hold) @(posedge clock);
        
      // clear signals to DUT after another half clock cycle
      @(negedge clock);
      button = 0;
      reset = 0;

    end

  end
  
endmodule
