module counter
  #(parameter width_p = 4)
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,input [0:0] down_i
   ,output [width_p-1:0] count_o);

   // Implement a parameterized up/down counter
   //
   // *** You may use any previously created module from this lab. (Hint: adder) ***
   // 
   // For full credit you must use the following modules provided:
   // 
   // 
   // D-Type Flip Flop
   // 
   // module dff
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
   // count_o must reset to '0 at the positive edge of clk_i when reset_i is 1
   //
   // count_o must have the following behavior at the positive edge of clk_i when reset_i is 0:
   // 
   // * Maintain the same value when up_i and down_i are both 1 or both 0.
   // 
   // * Increment by 1 when up_i is 1 and down_i is 0
   //
   // * Decrement by 1 when down_i is 1 and up_i is 0 
   //
   // * Use two's complement: -1 == '1 (Remember: decrementing by 1 is the same as adding negative 1)
   //
   // If the counter value overflows, return to 0. If the counter value underflows, return to the maximum value.
   //
   // (In other words you don't need to handle over/underflow conditions).
   // schematic - dff register to save current state
   // register connected to adder alongside incoming data
   // adder computes and moves the state to the register
   // repeat
   // Your code here:
   
   
   wire[width_p:0] datain_w;
   wire[width_p-1:0] dataout_w;
   wire[0:0] clk_w, reset_w;
   assign clk_w = clk_i;
   assign reset_w = reset_i;
   genvar i;
   generate
   	for (i = 0; i < width_p; i++)
   	begin : make_ff
   	
   		dff #(.reset_val_p(1'b0))dff_inst(
   		.clk_i(clk_w),
   		.reset_i(reset_w),
   		.d_i(datain_w[i]),
   		.q_o(dataout_w[i]));
   	end
   endgenerate
   //ff register
   
   wire[0:0] up_w, down_w;

   assign up_w = up_i;
   assign down_w = down_i;
  
   wire[0:0] mux0_w;
   wire[0:0] mux01_w;
   wire[width_p-1:0] muxout_w;
   mux2 zero0_inst(
   	.a_i(1'b0),
   	.b_i(1'b1),
   	.select_i(up_w),
   	.c_o(mux0_w));
   mux2 zero1_inst(
   	.a_i(1'b1),
   	.b_i(1'b0),
   	.select_i(up_w),
   	.c_o(mux01_w));
   mux2 zero2_inst(
   	.a_i(mux0_w),
   	.b_i(mux01_w),
   	.select_i(down_w),
   	.c_o(muxout_w[0]));
   	//zeroX_inst for MSB of adder logic
   	//oneX_inst for 2nd MSB of adder logic
      	   wire[width_p:0] mux1_w;
      	   wire[width_p:1] mux11_w;
   genvar j;
   generate
   	for (j = 1; j < width_p; j++)
   	begin : make_mux
	   mux2 one0_inst(
	   	.a_i(1'b0),
	   	.b_i(1'b0),
	   	.select_i(up_i),
	   	.c_o(mux1_w[j]));
	   mux2 one1_inst(
	   	.a_i(1'b1),
	   	.b_i(1'b0),
	   	.select_i(up_i),
	   	.c_o(mux11_w[j]));
	   mux2 one2_inst(
	   	.a_i(mux1_w[j]),
	   	.b_i(mux11_w[j]),
	   	.select_i(down_w),
	   	.c_o(muxout_w[j]));
   	end
   endgenerate
   
   adder #(.width_p(width_p)) add_inst(
   	.a_i(dataout_w),
   	.b_i(muxout_w),
   	.sum_o(datain_w));
   assign count_o = dataout_w;
   //adder-input statement
   
   
  
       
endmodule
