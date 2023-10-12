// Do not modify this file!
`timescale 1ns/1ps
`ifndef WIDTH
`define WIDTH 8
`endif
module testbench();
   parameter [31:0]  width_p = `WIDTH;
   parameter [31:0]  num_tests_p = 100;
   logic [0:0] reset_done = 1'b0;

   wire [0:0]  clk_i;
   wire [0:0]  reset_i;
   logic [0:0] reset_button;
   
   logic  test_reset_i;
   logic [width_p-1:0] test_data_i;
   logic               test_valid_i;
   logic               test_ready_o;

   logic               test_ready_i;
   logic               test_valid_o;

   logic [width_p-1:0] test_data_o;
   logic               test_data_check;
 
   logic               error;
   logic               yumi_n;
   logic               yumi_i;

   int   test_data_rd_ptr;
   int   test_data_wr_ptr;
   int   rand_rw_val;
   int   cycle;

   logic [width_p-1:0] test_data [num_tests_p-1:0];
   
   nonsynth_clock_gen
     #(.cycle_time_p(10))
   cg
     (.clk_o(clk_i));

   nonsynth_reset_gen
     #(.num_clocks_p(1)
       ,.reset_cycles_lo_p(1)
       ,.reset_cycles_hi_p(10))
   rg
     (.clk_i(clk_i)
      ,.async_reset_o(reset_i));

   elastic_pipe
    #(.width_p(width_p))
   dut
     (.clk_i(clk_i)
     ,.reset_i(test_reset_i)
     ,.data_i(test_data_i)
     ,.valid_i(test_valid_i)
     ,.ready_o(test_ready_o)
     ,.valid_o(test_valid_o)
     ,.data_o(test_data_o)
     ,.yumi_i(yumi_i)
     );

   initial begin
      error = 0;
      reset_button = 0;      
      test_data_rd_ptr = 0;
      test_data_wr_ptr = 0;
      test_reset_i = 1;
      yumi_n = 0;

`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      $display();
      $display("  ______          __  __                    __            __           __  _                  _          ");
      $display(" /_  __/__  _____/ /_/ /_  ___  ____  _____/ /_     ___  / /___ ______/ /_(_)____      ____  (_)___  ___ ");
      $display("  / / / _ \\/ ___/ __/ __ \\/ _ \\/ __ \\/ ___/ __ \\   / _ \\/ / __ `/ ___/ __/ / ___/     / __ \\/ / __ \\/ _ \\");
      $display(" / / /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /  /  __/ / /_/ (__  ) /_/ / /__      / /_/ / / /_/ /  __/");
      $display("/_/  \\___/____/\\__/_.___/\\___/_/ /_/\\___/_/ /_/   \\___/_/\\__,_/____/\\__/_/\\___/_____/ .___/_/ .___/\\___/ ");
      $display("                                                                             /_____/_/     /_/           ");

      cycle = 0;
      test_valid_i = 0;
      test_ready_i = 0;

      /* verilator lint_off WIDTH */
      // Fill out test data
      for(logic [31:0] i = 0; i < num_tests_p; i++) begin
         test_data[i] = {'0, $random()};
      end
      /* verilator lint_on WIDTH */

      @(negedge reset_i);
      repeat(2)   @(negedge clk_i);
      test_reset_i = 0;

      $display();
      $display("Begin Test:");

      // Test Full
      // 4:1 write ratio
      while((test_ready_o === 1) && (cycle < 1000)) begin
         cycle ++;
         rand_rw_val = $random();
         test_valid_i = ((rand_rw_val % 2) == 0);
         test_ready_i = ((rand_rw_val % 8) == 0);
         yumi_n = test_ready_i & test_valid_o & ~yumi_i;
         $display("On Cycle %d (RV: %x) -- valid_i: %d, yumi_n: %d", cycle, rand_rw_val, test_valid_i, yumi_n);
         test_data_i = test_valid_i ? test_data[test_data_wr_ptr] : '0;

         @(negedge clk_i);
      end

      // Clear to make sure we don't kill the FIFO protocol.
      test_valid_i = 0;
      test_ready_i = 0;
      @(negedge clk_i);
      
      // Do some R/W to drain back to empty
      // 1:2 read:write ratio
      while((test_valid_o === 1) && (cycle < 1000)) begin
         cycle ++;
         rand_rw_val = $random();
         test_valid_i = ((rand_rw_val % 8) == 0);
         test_ready_i = ((rand_rw_val % 4) == 0);
         yumi_n = test_ready_i & test_valid_o & ~yumi_i;
         $display("On Cycle %d (RV: %x) -- valid_i: %d, yumi_n: %d", cycle, rand_rw_val, test_valid_i, yumi_n);
         test_data_i = test_valid_i ? test_data[test_data_wr_ptr] : '0;

         @(negedge clk_i);
      end

      // Make sure we actually emptied
      while((test_valid_o === 1) && (cycle < 1000)) begin
         cycle ++;
         rand_rw_val = $random();
         test_valid_i = '0;
         test_ready_i = 1;
         yumi_n = test_ready_i & test_valid_o & ~yumi_i;
         $display("On Cycle %d (RV: %x) -- valid_i: %d, yumi_n: %d", cycle, rand_rw_val, test_valid_i, yumi_n);
         test_data_i = test_valid_i ? test_data[test_data_wr_ptr] : '0;

         @(negedge clk_i);
      end

      // Do some R/W around empty
      // 1:1 read:write ratio
      while((cycle < 300)) begin
         cycle ++;
         rand_rw_val = $random();
         test_valid_i = ((rand_rw_val % 2) == 0);
         test_ready_i = ((rand_rw_val % 2) == 0);
         yumi_n = test_ready_i & test_valid_o & ~yumi_i;
         $display("On Cycle %d (RV: %x) -- valid_i: %d, yumi_n: %d", cycle, rand_rw_val, test_valid_i, yumi_n);
         test_data_i = test_valid_i ? test_data[test_data_wr_ptr] : '0;

         @(negedge clk_i);
      end

      // Do some R/W to drain back to empty
      // 1:2 read:write ratio
      while((test_valid_o === 1) && (cycle < 1000)) begin
         cycle ++;
         rand_rw_val = $random();
         test_valid_i = ((rand_rw_val % 8) == 0);
         test_ready_i = ((rand_rw_val % 4) == 0);
         yumi_n = test_ready_i & test_valid_o & ~yumi_i;
         $display("On Cycle %d (RV: %x) -- valid_i: %d, yumi_n: %d", cycle, rand_rw_val, test_valid_i, yumi_n);
         test_data_i = test_valid_i ? test_data[test_data_wr_ptr] : '0;

         @(negedge clk_i);
      end

      // Test Full
      // 4:1 write ratio
      while((test_ready_o === 1) && (cycle < 1000)) begin
         cycle ++;
         rand_rw_val = $random();
         test_valid_i = ((rand_rw_val % 2) == 0);
         test_ready_i = ((rand_rw_val % 8) == 0);
         yumi_n = test_ready_i & test_valid_o & ~yumi_i;
         $display("On Cycle %d (RV: %x) -- valid_i: %d, yumi_n: %d", cycle, rand_rw_val, test_valid_i, yumi_n);
         test_data_i = test_valid_i ? test_data[test_data_wr_ptr] : '0;

         @(negedge clk_i);
      end

      // Do some R/W to drain back to empty
      // 1:2 read:write ratio
      while((test_valid_o === 1) && (cycle < 1000)) begin
         cycle ++;
         rand_rw_val = $random();
         test_valid_i = ((rand_rw_val % 8) == 0);
         test_ready_i = ((rand_rw_val % 4) == 0);
         yumi_n = test_ready_i & test_valid_o & ~yumi_i;
         $display("On Cycle %d (RV: %x) -- valid_i: %d, yumi_n: %d", cycle, rand_rw_val, test_valid_i, yumi_n);
         test_data_i = test_valid_i ? test_data[test_data_wr_ptr] : '0;

         @(negedge clk_i);
      end

      // Make sure we actually emptied
      while((test_valid_o === 1) && (cycle < 1000)) begin
         cycle ++;
         rand_rw_val = $random();
         test_valid_i = '0;
         test_ready_i = 1;
         yumi_n = test_ready_i & test_valid_o & ~yumi_i;
         $display("On Cycle %d (RV: %x) -- valid_i: %d, yumi_n: %d", cycle, rand_rw_val, test_valid_i, yumi_n);
         test_data_i = test_valid_i ? test_data[test_data_wr_ptr] : '0;

         @(negedge clk_i);
      end
      
      $finish; 
   end

   always_ff @(posedge clk_i) begin
      yumi_i <= yumi_n;
      if(!test_reset_i && (test_valid_i & test_ready_o)) begin
         test_data_wr_ptr ++;
      end
   end

   always_ff @(negedge clk_i) begin
      if(!test_reset_i && (yumi_i)) begin
         if(test_data_o !== test_data[test_data_rd_ptr]) begin
  	    $error("\033[0;31mError!\033[0m: On output iteration %d -- data_o should be %h, got %h\n", test_data_rd_ptr, test_data[test_data_rd_ptr], test_data_o);
            error = 1;
            $finish();
         end
         test_data_rd_ptr <= test_data_rd_ptr + 1;
      end
   end

   final begin
      $display("Simulation time is %t", $time);
      if(error || (test_data_rd_ptr == 0)) begin
         if(test_data_rd_ptr == 0) begin
            $display("\033[0;31m No data transmitted!         \033[0m");
         end
         $display("\033[0;31m    ______                    \033[0m");
         $display("\033[0;31m   / ____/_____________  _____\033[0m");
         $display("\033[0;31m  / __/ / ___/ ___/ __ \\/ ___/\033[0m");
         $display("\033[0;31m / /___/ /  / /  / /_/ / /    \033[0m");
         $display("\033[0;31m/_____/_/  /_/   \\____/_/     \033[0m");
         $display();
         $display("Simulation Failed");
      end else begin
            $display("%d data transmitted", test_data_rd_ptr);
         $display("\033[0;32m    ____  ___   __________\033[0m");
         $display("\033[0;32m   / __ \\/   | / ___/ ___/\033[0m");
         $display("\033[0;32m  / /_/ / /| | \\__ \\\__ \ \033[0m");
         $display("\033[0;32m / ____/ ___ |___/ /__/ / \033[0m");
         $display("\033[0;32m/_/   /_/  |_/____/____/  \033[0m");
         $display();
         $display("Simulation Succeeded!");
      end 
   end

endmodule
