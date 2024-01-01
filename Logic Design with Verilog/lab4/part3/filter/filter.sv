module filter
  #(parameter width_p = 24) // Don't worry, we won't change this.
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [width_p - 1:0] data_i
  ,input [0:0] valid_i
  ,output [0:0] ready_o 

  ,output [0:0] valid_o 
  ,output [width_p - 1:0] data_o 
  ,input [0:0] ready_i
  );
  /*
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
  
  module shift
  #(parameter depth_p = 5
  ,parameter [depth_p-1:0] reset_val_p = 0)
  (input [0:0] clk_i
  ,input [0:0] enable_i
  ,input [0:0] reset_i
  ,input [0:0] data_i
  ,output reg [depth_p-1:0] data_o);
  */
  /*
  reg [width_p - 1:0] data_r [width_p - 1:0];
  assign data_r[0] = data_i;
  assign data_o = data_r[0];
  */
  logic [0:0] ready_r;
  always_comb begin
	if(~valid_o || ready_i) begin
	ready_r = ~valid_o || ready_i;
	end else begin
	ready_r = 1'b0;
	end
  end
  assign ready_o = ready_r;
  shift #(.depth_p(width_p)) shift_inst(
  	.clk_i(clk_i),
  	.enable_i(ready_o && valid_i),
  	.reset_i(reset_i),
  	.data_i(data_i),
  	.data_o(data_o));
  dff #(.width_p(1), .reset_val_p(0)) dff2_inst(
 	.clk_i(clk_i),
 	.reset_i(reset_i),
 	.enable_i(ready_o),
 	.d_i((ready_o && valid_i)),
 	.q_o(valid_o));
 	
endmodule

