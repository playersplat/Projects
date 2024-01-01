module eq2
  (input [0:0] a_i
  ,input [0:0] b_i
  ,output [0:0] c_o);

   // Implement a Two-Input Equality Module (eq2). For full credit you
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
   // The Truth Table of the eq2 module is as follows:
   // 
   // For simplicity, A = a_i, B = b_i,, C = c_o
   //
   // A | B | C
   // 0 | 0 | 1
   // 0 | 1 | 0
   // 1 | 0 | 0
   // 1 | 1 | 1
   // 
   // schematic (!A && !B) || (A && B)
   // Your code here:
   
   wire [0:0] na_w;
   assign na_w = a_i;
   wire [0:0] naa_w;
   
   inv a_inst(
   .a_i(na_w),
   .b_o(naa_w));
   //inverter for A
   
   wire [0:0] nb_w;
   assign nb_w = b_i;
   wire [0:0] nbb_w;
   
   inv b_inst(
   .a_i(nb_w),
   .b_o(nbb_w));
   //inverter for B
   
   wire [0:0] a_w;
   wire [0:0] b_w;
   assign a_w = a_i;
   assign b_w = b_i;
   wire [0:0] a_b_w;
   
   and2 ab_inst(
   .a_i(a_w),
   .b_i(b_w),
   .c_o(a_b_w));
   //and for A & B
   
   wire [0:0] na_nb_w;
   
   and2 nanb_inst(
   .a_i(naa_w),
   .b_i(nbb_w),
   .c_o(na_nb_w));
   //and for !A & !B
   
   or2 or_inst(
   .a_i(a_b_w),
   .b_i(na_nb_w),
   .c_o(c_o));
   //or for two ands

endmodule
