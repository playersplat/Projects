module half_add
  (input [0:0] a_i
  ,input [0:0] b_i
  ,output [0:0] carry_o
  ,output [0:0] sum_o);

   // Implement a Half-Adder Module (half_add). You must use the LUT6_2 module.
   // 
   // Your code here:
   LUT6_2 #(.INIT(64'h0000_0008_0000_0006)) half_inst(
   	.O5(sum_o),
   	.O6(carry_o),
   	.I0(b_i),
   	.I1(a_i),
   	.I2(1'b0),
   	.I3(1'b0),
   	.I4(1'b0),
   	.I5(1'b1));

endmodule
