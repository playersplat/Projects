module elastic_pipe
 #(parameter [31:0] width_p = 10
  ) 
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [width_p - 1:0] data_i
  ,input [0:0] valid_i
  ,output [0:0] ready_o 

  ,output [0:0] valid_o 
  ,output [width_p - 1:0] data_o 
  ,input [0:0] yumi_i
  );
  /*
  module dff
  #(parameter [0:0] reset_val_p = 1'b0)
  (input [0:0] clk_i
  ,input [0:0] reset_i // positive-polarity, synchronous reset
  ,input [0:0] d_i
  ,output [0:0] q_o);
  */
  
  logic [width_p-1:0] temp;
  logic [0:0] valid_r;
  logic [0:0] en_i;
  logic [0:0] ready_r;
always_comb begin
	if(~valid_o || yumi_i) begin
	ready_r = ~valid_o || yumi_i;
	end else begin
	ready_r = 1'b0;
	end
end
assign ready_o = ready_r;

 dff #(.width_p(width_p), .reset_val_p(0)) dff_inst(
 	.clk_i(clk_i),
 	.reset_i(reset_i),
 	.enable_i((ready_o && valid_i)),
 	.d_i(data_i),
 	.q_o(data_o));
 dff #(.width_p(1), .reset_val_p(0)) dff2_inst(
 	.clk_i(clk_i),
 	.reset_i(reset_i),
 	.enable_i(ready_o),
 	.d_i((ready_o && valid_i)),
 	.q_o(valid_o));
 	

endmodule
