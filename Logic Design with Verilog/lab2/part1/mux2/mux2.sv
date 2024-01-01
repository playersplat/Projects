module mux2
  (input [0:0] a_i
  ,input [0:0] b_i
  ,input [0:0] select_i
  ,output reg [0:0] c_o);

   // Implement a Two-Input Multiplexer (mux2). You must use behavioral verilog.
   // 
   // Your code here:
   always_comb begin
   logic [0:0] a_w, b_w, s_w;
   a_w = a_i;
   b_w = b_i;
   s_w = select_i;
   c_o = (a_w && !s_w) || (b_w && s_w);
   end
   
endmodule
