import ovm_pkg::*;
import bdb_tb_transactions_pkg::*;

module bdb_tb_predictor (
  ref tlm_fifo #(bdb_operation) operation_fifo,
  ref tlm_fifo #(bdb_result) predicted_result_fifo
);
	
	parameter minimum_effective_hold = 4;
	
	string        module_name;
	string        message;
	bdb_operation operation;	
  bdb_result    predicted_result;
  
	task run;
	  
	 begin
	   
	   $sformat(module_name, "%m");
	   	  
	   forever begin
	   
	     operation_fifo.get(operation);
	   
	     if (operation.op == press_op && operation.hold >= minimum_effective_hold)
	       begin
	         predicted_result = new;
	         $sformat(message, "Predicting button press");
	         ovm_top.ovm_report_info(module_name, message, 300);
	         predicted_result_fifo.put(predicted_result.clone);
	       end
	     
	    end
	   
	  end  
	 
	endtask
	 
endmodule

