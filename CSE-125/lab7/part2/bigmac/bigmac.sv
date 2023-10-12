module bigmac
 #(parameter [31:0] width_p = 10
  ) 
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [width_p - 1:0] data_i
  ,input [0:0] valid_i
  ,output [0:0] ready_o 

  ,output [0:0] valid_o 
  ,output [2 * width_p - 1:0] data_o 
  ,input [0:0] ready_i
  );
  logic [2 * width_p - 1:0] data_hold;
  logic [2 * width_p - 1:0] data_out, data_in, data_next;

  always_comb begin
  	data_in = {{(width_p * 2 - width_p){1'b0}}, data_i[width_p-1:0]};
  	data_in = data_in + data_hold;
  end

  

    elastic_pipe #(.width_p(2*width_p)) pipe_inst(
  	.clk_i(clk_i),
  	.reset_i(reset_i),
  	.data_i(data_in),
  	.valid_i(valid_i),
  	.ready_o(ready_o),
  	.valid_o(valid_o),
  	.data_o(data_out),
  	.ready_i(ready_i));
     always_ff @(posedge clk_i) begin
   	if (reset_i) begin
   		data_next <= '0;
   	end else begin
   		data_next <= data_out;
   	end
   end
   always_comb begin
   	data_hold = data_next * 27;
  	data_hold = data_hold >> 5;
   end
  assign data_o = data_next;
endmodule

