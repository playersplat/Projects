module ram_1r1w_async
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
   // Note: Writes should not have an effect when reset_i is 1. In
   // other words, the data in an address should remain the same
   // between when reset is asserted and de-asserted.

   // You should test this in your testbench.

   logic [width_p-1:0] mem [0:depth_p-1];
   reg [width_p-1:0] temp_mem;
   initial begin
      $readmemh(filename_p,mem);
      $display("%m: depth_p is %d, width_p is %d", depth_p, width_p);
`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
/*
      // I believe this will cause the memory contents to be emitted in iverilog
      for(int i =0 ; i < depth_p; i++)
        $dumpvars(1, mem[i]);
        */

   end
assign rd_data_o = temp_mem;  

always_ff @(posedge clk_i) begin
	if(reset_i) begin
		$readmemh(filename_p,mem);
	end
	if(wr_valid_i) begin

		temp_mem <= mem[wr_addr_i];
		if(!reset_i) begin
		mem[wr_addr_i] <= wr_data_i;
		end
	end else begin
		temp_mem <= mem[rd_addr_i];
	end
	
end
  
  // Use `ifdef FORMAL to hide your concurrent assertion from iverilog
`ifdef FORMAL

   // Write a concurrent assertion proving that the output is correct
`endif

endmodule
