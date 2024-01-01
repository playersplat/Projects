module mul2x2
  (input [1:0] a_i
  ,input [1:0] b_i
  ,output [3:0] c_o);

   // Implement a 2-bit by 2-bit multiplier (2x2) using the LUT6_2 module.
   // 
   // Your code here:
   LUT6_2 #(.INIT(64'h0000_A0A0_0000_6AC0)) mul0_inst(
   	.O5(c_o[1]),
   	.O6(c_o[0]),
   	.I0(b_i[0]),
   	.I1(b_i[1]),
   	.I2(a_i[0]),
   	.I3(a_i[1]),
   	.I4(1'b0),
   	.I5(1'b1));
   LUT6_2 #(.INIT(64'h0000_4C00_0000_8000)) mul1_inst(
   	.O5(c_o[3]),
   	.O6(c_o[2]),
   	.I0(b_i[0]),
   	.I1(b_i[1]),
   	.I2(a_i[0]),
   	.I3(a_i[1]),
   	.I4(1'b0),
   	.I5(1'b1));

endmodule
