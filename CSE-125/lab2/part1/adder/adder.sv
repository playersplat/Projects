module adder
  #(parameter width_p = 1)
  (input [width_p - 1 : 0] a_i
  ,input [width_p - 1 : 0] b_i
  ,output reg [width_p : 0] sum_o); // Note, the missing -1 is not an error!

   // Implement a parameterized Adder Module (adder). You must use behavioral verilog
   // 
   // Your adder module must correctly compute the sum of A and B for any given value of width_p.
   //
   // Your adder module must correctly handle overflow (i.e. the bit at index width_p in sum_o)
   //
   // Your code here:
   always_comb begin
   sum_o = a_i + b_i;
   end
endmodule
