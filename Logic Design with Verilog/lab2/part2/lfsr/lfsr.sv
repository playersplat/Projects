module lfsr
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,output reg [4:0] data_o);

   // Implement a 5-bit Many-to-One Linear Feedback Shift Register
   //
   // *** You may use any previously created module from this lab ***
   //
   // Your solution must include behavioral verilog written in this file.
   // 
   // Your LFSR should reset to 5'b00001 at the positive edge of clk_i when reset_i is high
   // 
   // Your code here:
   
   wire [0:0] rando_w;
   reg [4:0] data_r, data_n;
   assign rando_w = (data_o[4] ^ data_o[1]);
   always_ff @(posedge clk_i, posedge reset_i)
   begin 
   	if (reset_i)
   	data_r <= 5'b00001;
   	else
   	data_r <= data_n;
   end
   
   always_ff @(rando_w, data_r)
   begin
   data_n = {data_r[3:0], rando_w};
   end
   assign data_o = data_r;
endmodule
