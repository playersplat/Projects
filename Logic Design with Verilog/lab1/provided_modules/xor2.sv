module xor2
  (input [0:0] a_i
  ,input [0:0] b_i
  ,output [0:0] c_o);
   // Implement a Two-Input Exclusive OR Module (xor2). For full credit you
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
   // The Truth Table of the xor2 module is as follows:
   // 
   // For simplicity, A = a_i, B = b_i,, C = c_o
   //
   // A | B | C
   // 0 | 0 | 0
   // 0 | 1 | 1
   // 1 | 0 | 1
   // 0 | 1 | 0
   // 
   // Your code here:
   
        wire [0:0] na_w;
        assign na_w = a_i;
	wire [0:0] naa_w;
	
	inv a_inv(
	.a_i(na_w),
	.b_o(naa_w));
	//inverter for a input
	
	wire [0:0] nb_w;
	assign nb_w = b_i;
	wire [0:0] nbb_w;
	
	inv b_inv(
	.a_i(nb_w),
	.b_o(nbb_w));
	//inverter for b input
	
	wire [0:0] a_w;
	wire [0:0] b_w;
	wire [0:0] nab_w;
	assign a_w = a_i;
	assign b_w = b_i;
	
	and2 b_naand(
	.a_i(b_w),
	.b_i(naa_w),
	.c_o(nab_w));
	//and for inverter a & b
	
	wire [0:0] anb_w;
	
	and2 a_nband(
	.a_i(a_w),
	.b_i(nbb_w),
	.c_o(anb_w));
	
	//and for inverter b & a
	
	or2 or2s(
	.a_i(nab_w),
	.b_i(anb_w),
	.c_o(c_o)); 
	//or for the previous and
	//schematic
	// (!a&b) | (!b&a) = a ^ b

   
endmodule
