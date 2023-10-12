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

  ,output [0:0] thread_o
  );

  logic [2 * width_p - 1:0] data_calc;
  logic [2 * width_p - 1:0] data_out, data_in, data_next;
  
  
   always_comb begin //combinational adder: data_i and register
 	data_in = data_next + {{(2 * width_p - width_p){1'b0}}, data_i[width_p-1:0]};
   end
   
      elastic_pipe #(.width_p(2*width_p)) pipe_inst( //pipeline
  	.clk_i(clk_i),
  	.reset_i(reset_i),
  	.data_i(data_in),
  	.valid_i(valid_i),
  	.ready_o(ready_o),
  	.valid_o(valid_o),
  	.data_o(data_out),
  	.ready_i(ready_i));
   
   always_comb begin //combinational logic for mult
   	data_calc = data_out * 27; //pipeline --> data_out * 27 = data_calc
  	data_calc = data_calc >> 5; //data_calc shifted 5
   end
   
   always_ff @(posedge clk_i) begin //register to hold data_calc
   	if (reset_i) begin
   		data_next <= '0;
   	end else if (valid_i & ready_o) begin
   		data_next <= data_calc; //data_next wired to data_in + data_i;
   	end
   end 
   assign data_o = data_out; //data_o wired to data_o of pipeline
  
   
 /*
  logic [0:0] v, r;
  logic [0:0] flag, empty;
  logic [2*width_p-1:0] data_in, data_out, data_next, data_in1,     data_out1, data_next1, data_hold, data_calc;
  always_comb begin
  	data_in = {{(16){1'b0}}, data_i[width_p-1:0]};
  	data_in = data_in + data_next1;
  end
  
  elastic_pipe #(.width_p(2*width_p)) pipe_inst1(
  	.clk_i(clk_i),
  	.reset_i(reset_i),
  	.data_i(data_in),
  	.valid_i(valid_i),
  	.ready_o(ready_o),
  	.valid_o(v),
  	.data_o(data_out),
   	.ready_i(r));
   	
   always_ff @(posedge clk_i) begin
   	if (reset_i) begin
   		data_next <= '0;
   	end else begin
   		data_next <= data_out;
   	end
   end
   
   assign data_o = data_next;
   always_comb begin
   	data_calc = data_next * 27;
   	data_calc = data_calc >> 5;
   	data_in1 = data_calc;
   end
  elastic_pipe #(.width_p(2*width_p)) pipe_inst2(
  	.clk_i(clk_i),
  	.reset_i(reset_i),
  	.data_i(data_in1),
  	.valid_i(v),
  	.ready_o(r),
  	.valid_o(valid_o),
  	.data_o(data_out1),
  	.ready_i(ready_i));
  always_ff @(posedge clk_i) begin
  	if (reset_i) begin
  		data_next1 <= '0;
  	end else begin
  		data_next1 <= data_out1;
  	end
  end
 
 */
   
endmodule
