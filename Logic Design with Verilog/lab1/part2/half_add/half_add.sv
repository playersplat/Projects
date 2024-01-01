module half_add
  (input [0:0] a_i
  ,input [0:0] b_i
  ,output [0:0] carry_o
  ,output [0:0] sum_o);

   // Implement a Half-Adder Module (half_add). For full credit you
   // must use the three following modules provided:
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
   // Using any behavioral verilog operators will yield zero points
   // for code correctness (but not affect your demonstration grade).
   // You may use assign, instantiate modules, and declare wires.
   //
   // The Truth Table of the half_add module is as follows:
   // 
   // For simplicity, A = a_i, B = b_i, C = carry_o, S = sum_o
   //
   // A | B | S | C
   // 0 | 0 | 0 | 0
   // 0 | 1 | 1 | 0
   // 1 | 0 | 1 | 0
   // 1 | 1 | 0 | 1
   // schematic: C = (A & B) S = (A ^ B)
   // Your code here:
   
   wire [0:0] a_w;
   wire [0:0] b_w;
   assign a_w = a_i;
   assign b_w = b_i;
   and2 ab_inst(
   .a_i(a_w),
   .b_i(b_w),
   .c_o(carry_o));
   //AND GATE for C
   
   xor2 abxor_inst(
   .a_i(a_w),
   .b_i(b_w),
   .c_o(sum_o));
   //XOR GATE for S

endmodule
