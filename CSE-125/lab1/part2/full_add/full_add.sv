module full_add
  (input [0:0] a_i
  ,input [0:0] b_i
  ,input [0:0] carry_i
  ,output [0:0] carry_o
  ,output [0:0] sum_o);

   // Implement a Full Adder Module (full_add). 
   // 
   // *** You may use any previously created module from this lab. ***
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
   // The Truth Table of the eq2 module is as follows:
   // 
   // For simplicity, A = a_i, B = b_i, Ci = carry_i, Co = carry_o, S = sum_o
   //
   // A | B | Ci | S | Co
   // 0 | 0 | 0  | 0 | 0
   // 0 | 0 | 1  | 1 | 0
   // 0 | 1 | 0  | 1 | 0
   // 0 | 1 | 1  | 0 | 1
   // 1 | 0 | 0  | 1 | 0
   // 1 | 0 | 1  | 0 | 1
   // 1 | 1 | 0  | 0 | 1
   // 1 | 1 | 1  | 1 | 1
   // schematic: S = ((A ^ B) ^ Ci) 
   // Co = (A && B) || ((A ^ B) && Ci)
   // Your code here:
   
   wire [0:0] axor_w;
   wire [0:0] bxor_w;
   wire [0:0] abxor_w;
   assign axor_w = a_i;
   assign bxor_w = b_i;
   xor2 ab_inst(
   .a_i(axor_w),
   .b_i(bxor_w),
   .c_o(abxor_w));
   //XOR AB
   
   wire [0:0] cixor_w;
   assign cixor_w = carry_i;
   xor2 abci_inst(
   .a_i(cixor_w),
   .b_i(abxor_w),
   .c_o(sum_o));
   //XOR AB w Ci
   
   wire [0:0] a_w;
   wire [0:0] b_w;
   wire [0:0] ab_w;
   assign a_w = a_i;
   assign b_w = b_i;
   and2 abnd_inst(
   .a_i(a_w),
   .b_i(b_w),
   .c_o(ab_w));
   //AND AB
   
   wire [0:0] abxorc_w;
   and2 abxorci_inst(
   .a_i(abxor_w),
   .b_i(cixor_w),
   .c_o(abxorc_w));
   //AND A^B w Ci
   
   or2 orall_inst(
   .a_i(abxorc_w),
   .b_i(ab_w),
   .c_o(carry_o));
   //OR AB w (A^B w Ci)

endmodule
