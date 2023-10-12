module palindrome
  #(parameter [31:0] depth_p = 32'd10)
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [3:0] symbol_i
   ,input [0:0] valid_i
   ,output [0:0] overflow_o // Not required, but provided for debugging
   ,output [0:0] palindrome_o);

   // Your code here:
   /*
   module ram_1w1r_async
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
   
   reg [4:0] up_count, down_count;
   reg [3:0] symbol_r;
   reg [0:0] down_flag, clone_flag;
   counter_down #(.width_p(5)) down_inst(
   		.clk_i(clk_i),
   		.reset_i(reset_i),
   		.clone_i(up_count),
   		.clone_flag(clone_flag),
   		.down_i(down_flag),
   		.counter_o(down_count));
   counter #(.width_p(5)) up_inst (
   		.clk_i(clk_i),
   		.reset_i(reset_i),
   		.up_i(valid_i),
   		.down_i(1'b0),
   		.counter_o(up_count));
   enum {s0 = 0,s1 = 1,s2 = 2,s3 = 3,s4 = 4} state_now, state_next;
   always_comb begin : state_logic
   	state_next = state_now;
   	case(state_now)
		s0 : if(valid_i) state_next = s1;
		s1 : begin
		     if(symbol_i == symbol_r && down_count != up_count) state_next = s4;
		end
		s2 : begin
		     if(up_count < 3 && down_count > 1 && symbol_i == symbol_r) state_next = s4;
		end
		s3 : begin
		     if(symbol_i == symbol_r) state_next = s4;
		end
		s4 : begin
		     if(valid_i) state_next = s2;
		end
		     
   	endcase
   end
   always_comb begin : state_case
   	case(state_now)
   		s0 : down_flag = state_now[0];
   	endcase
   end
   always_ff @(posedge clk_i or posedge reset_i) begin
   	if (reset_i) begin
   		state_now <= s0;
   	end else state_now <= state_next;
   	if (symbol_i == symbol_r) begin
   		
   	end
   end
   ram_1w1r_async #(.width_p(4), .depth_p(2*depth_p)) rom_inst(
   			.clk_i(clk_i),
   			.reset_i(reset_i),
   			.wr_valid_i(valid_i),
   			.wr_data_i(symbol_i),
   			.wr_addr_i(up_count),
   			.rd_addr_i(down_count),
   			.rd_data_o(symbol_r));
    assign palindrome_o = down_count[4];
endmodule

