module mux2
  (input [0:0] a_i
  ,input [0:0] b_i
  ,input [0:0] select_i
  ,output [0:0] c_o);

   // Implement a Two-Input Multiplexer (mux2). For full credit you
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
   // The Truth Table of the mux is as follows:
   // 
   // For simplicity, A = a_i, B = b_i, S = select_i, C = c_o
   //
   // A | B | S | C
   // 0 | 0 | 0 | 0
   // 0 | 0 | 1 | 0
   // 0 | 1 | 0 | 0
   // 0 | 1 | 1 | 1
   // 1 | 0 | 0 | 1
   // 1 | 0 | 1 | 0
   // 1 | 0 | 0 | 1
   // 1 | 1 | 1 | 1
   // 
   //schema: (!S && A)||(S && B)
   // Your code here:
   
   wire [0:0] ns_w;
   wire [0:0] nss_w;
   assign ns_w = select_i;
   inv selector_inst(
   .a_i(ns_w),
   .b_o(nss_w));
   //S inverter
   
   wire [0:0] a_w;
   wire [0:0] nsa_w;
   assign a_w = a_i;
   and2 ns_a_inst(
   .a_i(a_w),
   .b_i(nss_w),
   .c_o(nsa_w));
   //AND GATE for !S && A
   
   wire [0:0] s_w;
   wire [0:0] b_w;
   wire [0:0] sb_w;
   assign s_w = select_i;
   assign b_w = b_i;
   and2 s_b_inst(
   .a_i(s_w),
   .b_i(b_w),
   .c_o(sb_w));
   //AND GATE for S && B
   
   or2 or_inst(
   .a_i(nsa_w),
   .b_i(sb_w),
   .c_o(c_o));
   //OR GATE for the two AND GATES

endmodule
