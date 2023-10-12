// Do not modify this file!
`timescale 1ns/1ps
`ifndef WIDTH
`define WIDTH 4
`endif
module testbench();
   localparam width_lp = `WIDTH;
   logic [width_lp-1:0] a_i;
   logic [width_lp-1:0] b_i;
   logic [width_lp:0] sum_o;

   wire [0:0] error_sum_o;
   wire [width_lp:0] correct_sum_o;

   logic [width_lp:0] itervar_a;
   logic [width_lp:0] itervar_b;
   
   assign correct_sum_o = (a_i + b_i);

   assign error_sum_o = (sum_o !== correct_sum_o);

   adder
     #(.width_p(width_lp))
   dut
     (.a_i(a_i)
     ,.b_i(b_i)
     ,.sum_o(sum_o));

   initial begin
`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      $display();


      $display("  ______          __  __                    __                 __    __         ");
      $display(" /_  __/__  _____/ /_/ /_  ___  ____  _____/ /_     ____ _____/ /___/ /__  _____");
      $display("  / / / _ \\/ ___/ __/ __ \\/ _ \\/ __ \\/ ___/ __ \\   / __ `/ __  / __  / _ \\/ ___/");
      $display(" / / /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /  / /_/ / /_/ / /_/ /  __/ /    ");
      $display("/_/  \\___/____/\\__/_.___/\\___/_/ /_/\\___/_/ /_/   \\__,_/\\__,_/\\__,_/\\___/_/     ");
      $display();

      #10;
      $display("Begin Test:");

      $display();

      // This is C-like verilog. You should only use it when writing
      // testbenches.
      for(itervar_a = '0; itervar_a < (1 << width_lp); itervar_a++) begin
	 for(itervar_b = '0; itervar_b < (1 << width_lp); itervar_b++) begin
	    a_i = itervar_a[width_lp-1:0];
	    b_i = itervar_b[width_lp-1:0];
	    $display("  a_i = %b, b_i = %b", a_i, b_i);
	    #10;
	    if(error_sum_o) begin
	       $error("\033[0;31mError!\033[0m: sum_o should be %b, got %b (a_i is %b, b_i is %b)",
		      correct_sum_o, sum_o, a_i, b_i);
	       $finish();
	    end
	 end
      end
   end

   final begin
      $display("Simulation time is %t", $time);
      if(error_sum_o) begin
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
