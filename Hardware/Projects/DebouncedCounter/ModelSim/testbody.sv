    
//    repeat(1000) begin
//      t.random(seed);
//      gen2drv_operation_fifo.put(t.clone);      
//    end

    for (int i = 6; i > 1; i--)
      repeat (2) begin
        t = new(up_op, 0, 4, i);
        gen2drv_operation_fifo.put(t.clone);
        t = new(up_op, 0, 4, i);
        gen2drv_operation_fifo.put(t.clone);
        t = new(down_op, 0, 4, i);
        gen2drv_operation_fifo.put(t.clone);
        t = new(down_op, 0, 4, i);
        gen2drv_operation_fifo.put(t.clone);
        t = new(reset_op, 0, 4, i+1);
        gen2drv_operation_fifo.put(t.clone);
        t = new(up_op, 0, 4, i);
        gen2drv_operation_fifo.put(t.clone);
        t = new(down_op, 0, 4, i);
        gen2drv_operation_fifo.put(t.clone);
      end    
    
