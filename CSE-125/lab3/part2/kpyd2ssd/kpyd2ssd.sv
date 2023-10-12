module kpyd2ssd
  (input [7:0] kpyd_i
  ,output [7:0] ssd_o);

   // Your code here
   /*
   ram_1w1r_async
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
   logic [8-1:0] mem [0:256-1];
   initial begin
      $readmemh("memory_init_file.hex", mem);
   end
   assign ssd_o = mem[kpyd_i];
   
   initial begin
   $display("kypd_i: %d, mem: %d", kpyd_i, mem[kpyd_i]);
   end

endmodule
