module full_add
  (input [0:0] a_i
  ,input [0:0] b_i
  ,input [0:0] carry_i
  ,output [0:0] carry_o
  ,output [0:0] sum_o);

   // Implement a Full Adder Module (full_add). You must use the LUT6_2 module.
   // 
   // Your code here:
   LUT6_2 #(.INIT(64'h0000_00E8_0000_0096)) full_inst(
   	.O5(sum_o),
   	.O6(carry_o),
   	.I0(carry_i),
   	.I1(b_i),
   	.I2(a_i),
   	.I3(1'b0),
   	.I4(1'b0),
   	.I5(1'b1));
endmodule
