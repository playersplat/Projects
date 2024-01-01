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
//
   // Implement a parameterized, write-priority/write-first asynchronous RAM.
   // 
   // Your code here:
   logic [width_p-1:0] mem [0:depth_p-1];
   logic [width_p-1:0] temp_mem;
   initial begin
   	$readmemh(filename_p, mem);

   end
   
   always_ff @(posedge clk_i) begin
   	if (reset_i) begin
   		$readmemh(filename_p, mem);
   	end
   end

   always_comb begin
   	if(wr_valid_i) begin
   		temp_mem = wr_data_i;
   	end else begin
   		temp_mem = mem[rd_addr_i];
   	end
   end         
   always_ff @(posedge clk_i) begin
   	if (wr_valid_i) begin
   		mem[wr_addr_i] <= wr_data_i;
   	end 
   	
   	
   end
   assign rd_data_o = temp_mem;
   
   initial begin

      // Display depth and width (You will need to match these in your init file
      $writememh(filename_p,mem);
      $display("%m: depth_p is %d, width_p is %d", depth_p, width_p);
   end
       
endmodule
