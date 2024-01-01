// Do not modify this file!
`timescale 1ns/1ps
`ifndef DEPTH
`define DEPTH 10
`endif
module testbench();
   localparam  num_symbols_lp = 128;
   logic [0:0] reset_done = 1'b0;

   wire [0:0]  clk_i;
   wire [0:0]  reset_i;
   logic [0:0] reset_button;
   logic [0:0] reset_button_n;
   logic [3:0] symbol_i;
   logic [0:0] valid_i;
   wire [0:0]  overflow_o;
   logic [0:0] dontcare;
   wire [0:0]  palindrome_o;

   wire [0:0]  error_palindrome_o;
   logic [0:0] correct_palindrome_o;
   logic [0:0] correct_palindrome_n;

   int         itervar;
   logic [7:0] test_symbols [num_symbols_lp];

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

   palindrome
     #(.depth_p(`DEPTH))
   dut
     (.clk_i(clk_i)
     ,.reset_i(reset_i | reset_button)
     ,.symbol_i(symbol_i)
     ,.valid_i(valid_i)
     ,.overflow_o(overflow_o)
     ,.palindrome_o(palindrome_o));

   initial begin
      reset_button = 0;      
`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      $display();
      $display("  ______          __  __                    __       ____        ___           __                        ");
      $display(" /_  __/__  _____/ /_/ /_  ___  ____  _____/ /_     / __ \\____ _/ (_)___  ____/ /________  ____ ___  ___ ");
      $display("  / / / _ \\/ ___/ __/ __ \\/ _ \\/ __ \\/ ___/ __ \\   / /_/ / __ `/ / / __ \\/ __  / ___/ __ \\/ __ `__ \\/ _ \\");
      $display(" / / /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /  / ____/ /_/ / / / / / / /_/ / /  / /_/ / / / / / /  __/");
      $display("/_/  \\___/____/\\__/_.___/\\___/_/ /_/\\___/_/ /_/  /_/    \\__,_/_/_/_/ /_/\\__,_/_/   \\____/_/ /_/ /_/\\___/ ");

      $display();
      $display("Begin Test:");

      itervar = 0;
      // {symbol_i[3:0], valid_i, reset_i, palindrome_o, x}
      $readmemh("palindrome.hex", test_symbols);
      {symbol_i, valid_i, reset_button, correct_palindrome_o, dontcare} = test_symbols[itervar];

      @(negedge reset_i);

      reset_done = 1'b1;

      for(itervar = 0; itervar <= num_symbols_lp; itervar ++) begin
	 @(posedge clk_i);
	 $display("At Posedge %d: symbol_i: %h valid_i: %b reset_i = %b %b ", itervar, symbol_i, valid_i, reset_i, correct_palindrome_o);
      end

      $finish();
   end

   assign error_palindrome_o = (correct_palindrome_o !== palindrome_o) && (itervar < num_symbols_lp);

   always @(negedge clk_i) begin
      // {symbol_i[4:0], valid_i, reset_i, palindrome_o, x}
      {symbol_i, valid_i, reset_button, correct_palindrome_o, dontcare} = test_symbols[itervar];
      if(!reset_i && (reset_done == 1) && (correct_palindrome_o != palindrome_o)) begin
         $display("\033[0;31mError!\033[0m: Iteration %d palindrome_o should be %b, but got %b", itervar, correct_palindrome_o, palindrome_o);
         $finish();
      end
      if (itervar >= num_symbols_lp)
        $finish();
   end

   final begin
      $display("Simulation time is %t", $time);
      if(error_palindrome_o) begin
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
      end // else: !if(error_unlock_o)
   end

endmodule
