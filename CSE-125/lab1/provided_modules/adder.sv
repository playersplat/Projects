module adder
  #(parameter width_p = 1)
  (input [width_p - 1 : 0] a_i
  ,input [width_p - 1 : 0] b_i
  ,output [width_p : 0] sum_o); // Note, the missing -1 is not an error!

   // Implement a parameterized Adder Module (adder). 
   // 
   // *** For maximum points you should use the full_add module from this lab **
   // 
   // You can also use the three following modules provided:
   // 
   // Two-Input And Gate:
   // 
   // module and2
   //   (input [0:0] a_i
   //   ,input [0:0] b_i
   //   ,output [0:0] c_o);
   //
   // 
   // Two-Input Or Gate:
   // 
   // module or2
   //   (input [0:0] a_i
   //   ,input [0:0] b_i
   //   ,output [0:0] c_o);
   //
   // Inverter:
   // 
   // module inv
   // (input [0:0] a_i
   // ,output [0:0] b_o);
   //
   // For more information see the the provided_modules directory.
   // 
   //
   // Using any behavioral verilog operators will yield zero points
   // for code correctness (but not affect your demonstration grade).
   // 
   // You may use assign, instantiate modules, and declare wires.
   //
   // You should use a for loop to *instantiate* modules. 
   //
   // Your adder module must correctly compute the sum of A and B for any given value of width_p.
   //
   // Your adder module must correctly handle overflow (i.e. the bit at index width_p in sum_o)
   //
   // Your code here:
   wire [width_p:0] c_w;
   wire [width_p-1:0] a_w;
   wire [width_p-1:0] b_w;
   assign c_w[0] = 1'b0;
   assign a_w = a_i;
   assign b_w = b_i;
   genvar i;
   generate
   	for (i = 0; i < width_p; i++)
   	begin : make_fulladd
   	
   		full_add test_inst(
   		.a_i(a_w[i]),
   		.b_i(b_w[i]),
   		.carry_i(c_w[i]),
   		.carry_o(c_w[i+1]),
   		.sum_o(sum_o[i]));
   	end
   endgenerate
   assign sum_o[width_p] = c_w[width_p];
   //full_add
   

endmodule
