import ovm_pkg::*;
import dbctr_testbench_classes_pkg::*;


/*************************   D R I V E R  **************************/
module dbctr_tb_driver (
  ref tlm_fifo #(dbctr_operation) gen2drv_operation_fifo,
  ref tlm_fifo #(dbctr_operation) drv2prd_operation_fifo,
  output bit                      clock,
 	output bit                      up,
	output bit                      down,
	output bit 	                    load,
	output bit 		                   reset,
	output logic [3:0]              value
);
	
	// declare local variables
	dbctr_operation request;
	string          module_name = "";
	
	// store name of module for use in report messages
	initial $sformat(module_name, "%m");
	
	// generate clock signal
	initial begin : clockgen
	  clock = 0;
	  forever #10 clock = ~clock;
	end
	
	// initialize signals to DUT
	initial begin
	  up = 0;
    down = 0;
    load = 0;
	  reset = 0;
	end
  
  always @(negedge clock) begin : drive_transactions
          
      // get the next transaction request
      if (gen2drv_operation_fifo.try_get(request)) begin : new_transaction
      
        // print request to the log
        ovm_top.ovm_report_info(module_name,"*******************************************************", 400);
        ovm_top.ovm_report_info(module_name, request.convert2string(), 300);

        // validate request
        if (request.hold < 1) ovm_top.ovm_report_fatal(module_name, "Hold time must be greater than zero"); 

        // forward current request to predictor
        drv2prd_operation_fifo.put(request.clone);
        
        // keep signals to DUT low for requested number of clock cycles
        repeat(request.waits - 2) @(negedge clock);

        // drive the request argument on the DUT
        value = request.arg;
      
        // drive the operation-specific control signal on the DUT
        case (request.op)
          up_op:    up = 1;
          down_op:  down = 1;          
          load_op:  load = 1;
          reset_op: reset = 1;
          no_op:    ;
        endcase
        
        // hold signals on  DUT for the requested number of positive clock edges
        repeat(request.hold) @(posedge clock);
        
        // clear signals to DUT after another half clock cycle
        @(negedge clock);
        up = 0;
        down = 0;
        load = 0;
        reset = 0;

        // report transaction complete on driver side
        ovm_top.ovm_report_info(module_name, "Finished operation", 300);
      
    end

  end

endmodule // dbctr_tb_driver


/*************************   R E S P O N D E R  **************************/
module dbctr_tb_responder (
  ref tlm_fifo #(dbctr_result) rsp2prn_result_fifo,
  ref tlm_fifo #(dbctr_result) rsp2cmp_result_fifo,
  input bit                    ack,
  input bit                    clock,
	input bit 		                 reset,
	input logic [3:0]            counter      );
	
	// declare local variables
	dbctr_result result;
	string       module_name;
	string       message;
	
	// store name of module for use in report messages
	initial $sformat(module_name, "%m");
	
	always @(posedge clock) begin : handle_results
  	   
    if (ack) begin : respond
        
	    result = new(counter);
	      
	    $sformat(message, "Actual: %s", result.convert2string);
	    ovm_top.ovm_report_info(module_name, message, 300);
	      
	    assert(rsp2prn_result_fifo.try_put(result.clone));
      assert(rsp2cmp_result_fifo.try_put(result.clone));
        
      @(negedge ack);
        
	  end
	    
	end

endmodule // dbctr_tb_responder


/*************************   P R E D I C T E R  **************************/
module dbctr_tb_predictor (
  ref tlm_fifo #(dbctr_operation) drv2prd_operation_fifo,
  ref tlm_fifo #(dbctr_result)  	 prd2cmp_result_fifo
);
	
	localparam min_button_hold_time = 4;
	
	// declare module scope variables
	string    module_name;
	bit [3:0] predicted_value = 0;

	// store name of module for use in report messages
	initial $sformat(module_name, "%m");
  
	task run;
	  
	  // declare static variables local to task
	  dbctr_operation operation;
	  
	  forever begin
	   
	    drv2prd_operation_fifo.get(operation);
	   
	    case (operation.op)
	     
	      up_op:    if (operation.hold >= min_button_hold_time) begin
	       	          predicted_value = predicted_value + 1;
	                  send_result;
                  end
	      
        down_op:  if (operation.hold >= min_button_hold_time) begin
                    predicted_value = predicted_value - 1;
	                  send_result;
                  end
                    
        load_op:  if (operation.hold >= min_button_hold_time) begin
                    predicted_value = operation.arg;
	                  send_result;
                  end
                   
        reset_op: begin
                    predicted_value = 0;
                    send_result;
                  end
        
      endcase
	     
 	  end
	 
  endtask
	
  task send_result;
	  
	  // declare static variables local to task
	  string       message;
	  dbctr_result predicted_result;
	  
	  // create a new result instance from the current predicted value of the counter
	  predicted_result  = new(predicted_value);
	  
	  // print the predicted value to the log
	  $sformat(message, "Predicted: %s", predicted_result.convert2string);
	  ovm_top.ovm_report_info(module_name, message, 300);
	  
	  // send the predicted value to the comparator
	  prd2cmp_result_fifo.put(predicted_result.clone);
	  
	endtask
	 
endmodule // dbctr_tb_predictor


/*************************   C O M P A R A T O R  **************************/
module  dbctr_tb_comparator (
  ref tlm_fifo #(dbctr_result)  rsp2cmp_result_fifo,
  ref tlm_fifo #(dbctr_result)  prd2cmp_result_fifo
);

  // declare local variables	
	dbctr_result actual_result;
  dbctr_result predicted_result;
  string       module_name;
  string       message;

	task run;
	  
    // store module name for use in log messages
	  $sformat(module_name, "%m");
	  
	  // handle all incoming results
	  forever begin
	   
	    // get the actual result form the responder
	    rsp2cmp_result_fifo.get(actual_result);
	    
	    // get the predicted result from the predictor
	    prd2cmp_result_fifo.get(predicted_result);
	   
	    // create the log message dissplaying the predicted and actual results
	    $sformat(message, "Predicted: %s   Actual: %s",
	       predicted_result.convert2string, actual_result.convert2string);
	   
	    // print the message to the log as info or an error depending on whether the results are the same
      if (actual_result.comp(predicted_result))
        ovm_top.ovm_report_info(module_name, message, 300);
      else 
        begin
          assert(0); // put an assertion failure arrow on the wave if the results are different 
          ovm_top.ovm_report_error(module_name, message, 200);
	      end
	      
	   end  
	 
	endtask
	 
endmodule // dbctr_tb_comparator


/*************************   P R I N T E R  **************************/
module dbctr_tb_printer (
  ref tlm_fifo #(dbctr_result)  res2prn_result_fifo
);
	
	// declare local variables
	dbctr_result  result;
	string        module_name;
	
	// define the transaction level task
	task run;
	  
	 // store name of module for use in report messages
	 $sformat(module_name, "%m");
	 
	 // receive each result from the responder and print to log
	 forever begin
	   res2prn_result_fifo.get(result);
	   ovm_top.ovm_report_info(module_name, result.convert2string(), 400);
	 end
	 
	endtask
	 
endmodule // dbctr_tb_printer


