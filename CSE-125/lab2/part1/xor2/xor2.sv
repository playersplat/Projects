module xor2
  (input [0:0] a_i
  ,input [0:0] b_i
  ,output reg [0:0] c_o);

   // Implement a Two-Input Exclusive OR Module (xor2). You must use behavioral verilog.
   // 
   // Your code here:
   always_comb begin
   c_o = a_i ^ b_i;
   end
endmodule
