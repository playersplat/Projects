module lfsr
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,output [4:0] data_o);

   // Implement a 5-bit Many-to-One Linear Feedback Shift Register
   //
   // https://www.eetimes.com/tutorial-linear-feedback-shift-registers-lfsrs-part-1/
   //
   // *** You may use any previously created module from this lab. (Hint: xor2) ***
   // 
   // Using any behavioral verilog operators will yield zero points
   // for code correctness (but not affect your demonstration grade).
   // You may use assign, instantiate modules, and declare wires.
   //
   //
   // A linear feedback shift register (LFSR)  is an array of registers, connected
   // in series. On each cycle, the LFSR bits represent a new pseudorandom value.
   // 
   // The values repeat after 2^bits - 1 cycles, because zero is never shown.
   //
   // Your LFSR should reset to 5'b00001 at the positive edge of clk_i when reset_i is high
   // 
   // Your code here:
   wire [0:0] reset_w;
   assign reset_w = reset_i;
   wire [0:0] clk_w;
   assign clk_w = clk_i;
   wire [0:0] data0_w;
   wire [0:0] data1_w;
   wire [0:0] data2_w;
   wire [0:0] data3_w;
   wire [0:0] data4_w;
   
   wire [0:0] xordata_w;
   
   xor2 randomize(
   	.a_i(data1_w),
   	.b_i(data4_w),
   	.c_o(xordata_w));
   	
   
     dff #(.reset_val_p(1'b1))dff1_inst(
   	.clk_i(clk_w),
   	.reset_i(reset_w),
   	.d_i(xordata_w),
   	.q_o(data0_w));
     dff #(.reset_val_p(1'b0))dff2_inst(
   	.clk_i(clk_w),
   	.reset_i(reset_w),
   	.d_i(data0_w),
   	.q_o(data1_w));
      dff #(.reset_val_p(1'b0))dff3_inst(
   	.clk_i(clk_w),
   	.reset_i(reset_w),
   	.d_i(data1_w),
   	.q_o(data2_w));
      dff #(.reset_val_p(1'b0))dff4_inst(
   	.clk_i(clk_w),
   	.reset_i(reset_w),
   	.d_i(data2_w),
   	.q_o(data3_w));
      dff #(.reset_val_p(1'b0))dff5_inst(
   	.clk_i(clk_w),
   	.reset_i(reset_w),
   	.d_i(data3_w),
   	.q_o(data4_w));
   assign data_o[0] = data0_w;
   assign data_o[1] = data1_w;
   assign data_o[2] = data2_w;
   assign data_o[3] = data3_w;
   assign data_o[4] = data4_w;

endmodule
