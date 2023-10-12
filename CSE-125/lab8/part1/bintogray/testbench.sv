`timescale 1ns/1ps
`ifndef WIDTH
`define WIDTH 4
`endif
module testbench();
   // You will need to handle multiple width_lp values during your demo
   logic [width_lp-1:0] binary_i;
   wire [width_lp-1:0] gray_o;
   localparam width_lp = `WIDTH;
   localparam iterations_lp = 64;
   logic [0:0] reset_done = 1'b0;
   wire [0:0]  clk_i;
   logic [0:0] error_o;
   logic [width_lp - 1:0] correct_gray_o;
   logic [width_lp:0] itervar_a;
   int itervar;

   wire                error;
   // Your testbench should PASS with the good DUT, and FAIL with the
   // "bad" DUT. Use `define GOOD to switch between the two.
   //
   // Write your assertions inside of the DUT modules themselves.
    nonsynth_clock_gen
     #(.cycle_time_p(10))
   cg
     (.clk_o(clk_i));


   bintogray
     #(.width_p(width_lp))
   dut
     (.binary_i(binary_i)
     ,.gray_o(gray_o));

   initial begin
      // Leave this code alone, it generates the waveforms
`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      // Put your testbench code here. Print all of the test cases and
      // their correctness.
	#15;

      $display("Begin Test:");
      $display();
      correct_gray_o = '0;
      binary_i = '0;
      itervar = 0;
      for(itervar = 0; itervar < iterations_lp; itervar++) begin
        @(posedge clk_i);
        #10;
		correct_gray_o = (binary_i >> 1) ^ binary_i;
        	binary_i = binary_i + 1'b1;
	$display("At Posedge %d: gray_o:%b correct_o: %b",itervar, gray_o, correct_gray_o);
	if((gray_o !== correct_gray_o)) begin
		error_o = 1'b1;
		$error("gray_o:%b != correct_o:%b", gray_o, correct_gray_o);
		$finish();
	end
	
      end

      $finish();
   end

   final begin
      $display("Simulation time is %t", $time);
      if(error_o ) begin
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
