module shift
  #(parameter depth_p = 24
  ,parameter [depth_p-1:0] reset_val_p = 0)
  (input [0:0] clk_i
  ,input [0:0] enable_i
  ,input [0:0] reset_i
  ,input [depth_p-1:0] data_i
  ,output reg [depth_p-1:0] data_o);
  
  wire [0:0] clk_w, reset_w;
  reg [depth_p - 1:0] data_w [depth_p - 1:0];
  assign clk_w = clk_i;
  assign reset_w = reset_i;
  assign data_w[0] = data_i;
  genvar i;
  generate
  	for (i = 0; i < 7; i++)
  	begin : make_ff
  		dff #(.width_p(depth_p), .reset_val_p(24'b0)) dff_inst(
  		.clk_i(clk_w),
  		.enable_i(enable_i),
  		.reset_i(reset_w),
  		.d_i(data_w[i]),
  		.q_o(data_w[i+1]));
  	end
  endgenerate
 always_comb begin
 data_o = data_w[1]/8 + data_w[2]/4 + data_w[3]/2 + data_w[4] * 2 + data_w[5]/2 + data_w[6]/4 + data_w[7]/8;
 end
endmodule
