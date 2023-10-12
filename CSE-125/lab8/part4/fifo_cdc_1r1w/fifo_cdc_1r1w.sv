module fifo_cdc_1r1w
 #(parameter [31:0] width_p = 32
  ,parameter [31:0] lg_depth_p = 8
  )
  (input [0:0] p_clk_i
  ,input [0:0] p_reset_i
  ,input [width_p - 1:0] p_data_i
  ,input [0:0] p_valid_i
  ,output [0:0] p_ready_o 

  // Use reset to connect to respective producer/consumer sides, but
  // do not cross the clock boundary. It is safe to assume that is
  // handled elsewhere
  ,input [0:0] c_clk_i
  ,input [0:0] c_reset_i
  ,output [0:0] c_valid_o 
  ,output [width_p - 1:0] c_data_o 
  ,input [0:0] c_ready_i
  );
   
  // Write your code here
   
endmodule

