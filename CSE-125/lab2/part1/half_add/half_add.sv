module half_add
  (input [0:0] a_i
  ,input [0:0] b_i
  ,output reg [0:0] carry_o
  ,output reg [0:0] sum_o);

   // Implement a Half-Adder Module (half_add). You must use behavioral verilog.
   // 
   // Your code here:
   logic [0:0] a_w, b_w;
   always_comb begin
   a_w = a_i;
   b_w = b_i;
   carry_o = (a_w && b_w);
   sum_o = (a_w ^ b_w);
   end

endmodule
