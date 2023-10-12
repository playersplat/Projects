module fifo_1r1w
 #(parameter [31:0] width_p = 10
  ,parameter [31:0] depth_p = 20
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
  elastic_pipe.sv
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
  ram_1r1w_sync.sv
    #(parameter [31:0] width_p = 8
    ,parameter [31:0] depth_p = 128
    ,parameter  filename_p = "memory_init_file.hex")
   (input [0:0] clk_i
    ,input [0:0] reset_i

    ,input [0:0] wr_valid_i
    ,input [width_p-1:0] wr_data_i
    ,input [$clog2(depth_p) - 1 : 0] wr_addr_i

    ,input [$clog2(depth_p) - 1 : 0] rd_addr_i
    ,output [width_p-1:0] rd_data_o
    );
  */
  logic [0:0] full_reg, empty_reg;
  int read_ptr = 0;
  int write_ptr = 0;
  logic isvalid;
  logic [width_p-1:0] data_r, data_n, data_s;
  always_comb begin
  	full_reg = ((write_ptr + 1) % depth_p == read_ptr);
  	empty_reg = (write_ptr == read_ptr);
  end
  always_ff @(posedge clk_i) begin
  	if (reset_i) begin
  		read_ptr <= 0;
  		write_ptr <= 0;
  	end
  	
  	if(valid_i && !full_reg) begin
  		write_ptr <= (write_ptr + 1) % depth_p;
  	end
  	if(ready_o && !empty_reg) begin
  		read_ptr <= (read_ptr + 1) % depth_p;
  	end
  	isvalid <= !empty_reg;

  end
 
  elastic_pipe #(.width_p(width_p)) elastic_pipe_inst (
  	.clk_i(clk_i),
  	.reset_i(reset_i),
  	.data_i(data_i),
  	.valid_i(valid_i),
  	.ready_o(ready_o),
  	.valid_o(valid_o),
  	.data_o(data_r),
  	.yumi_i(yumi_i));
   ram_1r1w_sync #(.width_p(width_p), .depth_p(depth_p)) ram_inst (
  	.clk_i(clk_i),
  	.reset_i(reset_i),
  	.wr_valid_i(isvalid),
  	.wr_data_i(data_r),
  	.wr_addr_i(write_ptr[4:0]),
  	.rd_addr_i(read_ptr[4:0]),
  	.rd_data_o(data_n));
 
  always_ff @(posedge clk_i) begin
  	if(data_r != data_n) begin
		data_s <= data_r;
  	end else
  		data_s <= data_n;
  end
assign data_o = data_s;
 
 
endmodule

