module eq2
  (input [0:0] a_i
  ,input [0:0] b_i
  ,output [0:0] c_o);

   // Implement a Two-Input Equality Module (eq2). You must use the LUT6 module.
   // 
   // Your code here:
   LUT6 #(.INIT(64'h0000_0000_0000_0009)) eq_inst(
   	.O(c_o),
   	.I0(a_i),
   	.I1(b_i),
   	.I2(1'b0),
   	.I3(1'b0),
   	.I4(1'b0),
   	.I5(1'b0));

endmodule
