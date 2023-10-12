// Do not modify this file!
`timescale 1ns/1ps
`ifndef WIDTH
`define WIDTH 5
`endif
module testbench();
   localparam width_lp = `WIDTH;
   localparam iterations_lp = 16;

   wire [0:0]  clk_i;
   wire [0:0]  reset_i;
   logic       valid_i;
   wire        ready_then_o;
   logic [width_lp - 1:0] a_i;
   logic [width_lp - 1:0] b_i;
   wire [(2 * width_lp) - 1:0] result_o;
   wire       done_o;

   logic [0:0] reset_done = 1'b0;
   wire [0:0]  error_result_o;
   logic [(2 * width_lp) - 1:0] correct_result_o;

   int			  itervar_input;
   int			  itervar_output;
   int			  wdt;
   int			  delay;
   logic                  timeout;
   logic                  newval;

   logic [width_lp-1:0]   test_a_inputs [16:0];
   logic [width_lp-1:0]   test_b_inputs [16:0];

   initial begin
      test_a_inputs[0] = 1;
      test_a_inputs[1] = 2;
      test_a_inputs[2] = 8;
      test_a_inputs[3] = '1;
      test_a_inputs[4] = 0;
      test_a_inputs[5] = 3;
      test_a_inputs[6] = 5;
      test_a_inputs[7] = 0;

      test_a_inputs[8] = 5;
      test_a_inputs[9] = 'hA;
      test_a_inputs[10] = 7;
      test_a_inputs[11] = 9;
      test_a_inputs[12] = 11;
      test_a_inputs[13] = 13;
      test_a_inputs[14] = 4;
      test_a_inputs[15] = 0;
   end

   initial begin
      test_b_inputs[0] = 5;
      test_b_inputs[1] = 'hA;
      test_b_inputs[2] = 7;
      test_b_inputs[3] = 4;
      test_b_inputs[4] = 9;
      test_b_inputs[5] = 11;
      test_b_inputs[6] = 13;
      test_b_inputs[7] = 0;
      
      test_b_inputs[8] = 1;
      test_b_inputs[9] = 2;
      test_b_inputs[10] = 8;
      test_b_inputs[11] = 0;
      test_b_inputs[12] = 3;
      test_b_inputs[13] = 5;
      test_b_inputs[14] = '1;
      test_b_inputs[15] = 17;
   end

   assign error_result_o = (result_o !== correct_result_o) && done_o;

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

   multiplier
     #(.width_p(width_lp))
   dut
     (.clk_i(clk_i)
     ,.reset_i(reset_i)
     ,.valid_i(valid_i)
     ,.ready_then_o(ready_then_o)
     ,.a_i(a_i)
     ,.b_i(b_i)
     ,.done_o(done_o)
     ,.result_o(result_o));

   initial begin
`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      $display();

      $display("  ______          __  __                    __                       ____  _       ___          ");
      $display(" /_  __/__  _____/ /_/ /_  ___  ____  _____/ /_     ____ ___  __  __/ / /_(_)___  / (_)__  _____");
      $display("  / / / _ \\/ ___/ __/ __ \\/ _ \\/ __ \\/ ___/ __ \\   / __ `__ \\/ / / / / __/ / __ \\/ / / _ \\/ ___/");
      $display(" / / /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /  / / / / / / /_/ / / /_/ / /_/ / / /  __/ /    ");
      $display("/_/  \\___/____/\\__/_.___/\\___/_/ /_/\\___/_/ /_/  /_/ /_/ /_/\\__,_/_/\\__/_/ .___/_/_/\\___/_/     ");
      $display("                                                                        /_/                     ");


      $display();
      $display("Begin Test:");

      itervar_input = 0;
      itervar_output = 0;

      @(negedge reset_i);
      reset_done = 1;

      // Todo: Check done == 0
      if(done_o === 1) begin
	    $error("\033[0;31mError!\033[0m: Done asserted before input generated!");
	    $finish();
      end

      wdt = 0;

      while(itervar_input < iterations_lp) begin
         valid_i = 0;
         a_i = 0;
         b_i = 0;

         if((ready_then_o === 1) && delay > 0) begin
            wdt = 0;
            delay = delay - 1;
         end else if (ready_then_o === 1) begin
            wdt = 0;
            valid_i = 1;
            a_i = test_a_inputs[itervar_input];
            b_i = test_b_inputs[itervar_input];
            $display("Iteration %d Starting: a_i = %b, b_i = %b", itervar_input, a_i, b_i);
            delay = 5;
            itervar_input++;
         end else begin
            wdt = wdt + 1;
         end
         timeout = (wdt > (2 << (2 * width_lp)));
         @(negedge clk_i);
      end

      valid_i = 0;
      a_i = 0;
      b_i = 0;
   end

   // Output state machine
   always @(negedge clk_i) begin
      correct_result_o = test_a_inputs[itervar_output] * test_b_inputs[itervar_output];

      if(reset_done & !reset_i & (done_o === 1)) begin
         itervar_output = itervar_output + 1;
         if(correct_result_o !== result_o) begin
	    $error("\033[0;31mError!\033[0m: Iteration %d result_o should be %b, got %b", itervar_output, correct_result_o, result_o);
	    $finish();
         end else begin
	    $display("Iteration %d, correct result computed.", itervar_output);
            if(itervar_output == iterations_lp) begin
	       $finish();
            end
         end
      end else if(timeout) begin
	 $error("\033[0;31mError!\033[0m: Result timed out. Result should be %b", correct_result_o);
	 $finish();
      end
   end // always @ (negedge clk_i)
   


   final begin
      $display("Simulation time is %t", $time);
      if(error_result_o | timeout) begin
	 $display("\033[0;31m    ______                    \033[0m");
	 $display("\033[0;31m   / ____/_____________  _____\033[0m");
	 $display("\033[0;31m  / __/ / ___/ ___/ __ \\/ ___/\033[0m");
	 $display("\033[0;31m / /___/ /  / /  / /_/ / /    \033[0m");
	 $display("\033[0;31m/_____/_/  /_/   \\____/_/     \033[0m");
	 $display();
	 $display("Simulation Failed");

     end else begin
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
