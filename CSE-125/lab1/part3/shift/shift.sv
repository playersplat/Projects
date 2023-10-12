module shift
  #(parameter depth_p = 5
   ,parameter [depth_p-1:0] reset_val_p = 0)
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] data_i
   ,output [depth_p-1:0] data_o);

   // Implement a parameterized, 1-bit shift register. 
   //
   // 
   // For full credit you must use the following modules provided:
   // 
   // 
   // D-Type Flip Flop
   // 
   // module dff
   //  #(parameter [0:0] reset_val_p = 1'b0)
   //   (input [0:0] clk_i
   //    ,input [0:0] reset_i // positive-polarity, synchronous reset
   //    ,input [0:0] d_i
   //    ,output [0:0] q_o);
   // 
   //
   // For more information see the the provided_modules directory.
   //
   // Using any behavioral verilog operators will yield zero points
   // for code correctness (but not affect your demonstration grade).
   // You may use assign, instantiate modules, and declare wires.
   //
   //
   // A shift register is an array of registers, connected
   // in series. On eachle, the shift register ingests a new value (data_i),
   // and moves the previous values forward by 1 index.
   //
   // Example:
   //
   //   Positive Edge Cycle 0 (i.e. the first cycle reset_i is set to 0):
   //     data_i = 1'b1, data_o = 5'b00000
   // 
   //   Positive Edge Cycle 1: 
   //     data_i = 1'b0, data_o = 5'b00001
   // 
   //   Positive Edge Cycle 2: 
   //     data_i = 1'b1, data_o = 5'b00010
   //   Positive Edge Cycle 3: 
   //     data_i = 1'b0, data_o = 5'b00101
   //
   //   And so on... 
   //
   // Your shift register should reset to reset_val_p when reset_i is high.
   // 
   // Your code here:
   //schema: flip flops that hold a bit connected in series
   /*
   wire [0:0] reset_w;
   assign reset_w = reset_i;
   wire [0:0] data_w;
   assign data_w = data_i;
   wire [0:0] clk_w;
   assign clk_w = clk_i;
   wire [0:0] data1_w;
   wire [0:0] data2_w;
   wire [0:0] data3_w;
   wire [0:0] data4_w;
   wire [0:0] data5_w;
     dff #(.reset_val_p(reset_val_p[0]))dff1_inst(
   	.clk_i(clk_w),
   	.reset_i(reset_w),
   	.d_i(data_w),
   	.q_o(data1_w));
     dff #(.reset_val_p(reset_val_p[1]))dff2_inst(
   	.clk_i(clk_w),
   	.reset_i(reset_w),
   	.d_i(data1_w),
   	.q_o(data2_w));
      dff #(.reset_val_p(reset_val_p[2]))dff3_inst(
   	.clk_i(clk_w),
   	.reset_i(reset_w),
   	.d_i(data2_w),
   	.q_o(data3_w));
      dff #(.reset_val_p(reset_val_p[3]))dff4_inst(
   	.clk_i(clk_w),
   	.reset_i(reset_w),
   	.d_i(data3_w),
   	.q_o(data4_w));
      dff #(.reset_val_p(reset_val_p[4]))dff5_inst(
   	.clk_i(clk_w),
   	.reset_i(reset_w),
   	.d_i(data4_w),
   	.q_o(data5_w));
   assign data_o[0] = data1_w;
   assign data_o[1] = data2_w;
   assign data_o[2] = data3_w;
   assign data_o[3] = data4_w;
   assign data_o[4] = data5_w;
   */
   	
   wire [0:0] reset_w;
   wire [0:0] clk_w;
   wire [depth_p:0] data_w;
   assign clk_w = clk_i;
   assign data_w[0] = data_i;
   assign reset_w = reset_i;
   genvar i;
   generate
   	for (i = 0; i < depth_p; i++)
   	begin : make_ff
   	
   		dff #(.reset_val_p(reset_val_p[i]))dff_inst(
   		.clk_i(clk_w),
   		.reset_i(reset_w),
   		.d_i(data_w[i]),
   		.q_o(data_w[i+1]));
   	end
   endgenerate
   assign data_o[depth_p-1] = data_w[5];
   assign data_o[depth_p-2] = data_w[4];
   assign data_o[depth_p-3] = data_w[3];
   assign data_o[depth_p-4] = data_w[2];
   assign data_o[depth_p-5] = data_w[1];
   

endmodule
