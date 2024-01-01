module shift
  #(parameter depth_p = 5
   ,parameter [depth_p-1:0] reset_val_p = 0)
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] data_i
   ,output reg [depth_p-1:0] data_o);

   // Implement a parameterized, 1-bit shift register. You must use behavioral verilog.
   //
   // A shift register is an array of registers, connected
   // in series. On each cycle, the shift register ingests a new value (data_i),
   // and moves the previous values forward by 1 index.
   //
   // Example:
   //
   //   Positive Edge Cycle 0 (i.e. the first cycle reset_i is set to 0):
   //     data_i = 1'b1, data_o = 5'b00000
   // 
   //   Positive Edge Cycle 1: 
   //     data_i = 1'b0, data_o = 5'b00001
   // 
   //   Positive Edge Cycle 2: 
   //     data_i = 1'b1, data_o = 5'b00010
   //   Positive Edge Cycle 3: 
   //     data_i = 1'b0, data_o = 5'b00101
   //
   //   And so on... 
   //
   // Your shift register should reset to reset_val_p when reset_i is high.
   // 
   // Your code here:
   
   wire [0:0] clk_w, reset_w;
   reg [depth_p:0] data_w;
   assign clk_w = clk_i;
   assign reset_w = reset_i;
   assign data_w[0] = data_i;
   
   genvar i;
   generate
   	for (i = 0; i < depth_p; i++)
   	begin : make_ff //uses behavioral verilog with the provided dff module
   		dff #(.reset_val_p(reset_val_p[i])) dff_inst(
   		.clk_i(clk_w),
   		.reset_i(reset_w),
   		.d_i(data_w[i]),
   		.q_o(data_w[i+1]));
   
   	end
   endgenerate
   
   always_comb begin
   data_o = data_w[depth_p:1];
   end
   
   
endmodule
