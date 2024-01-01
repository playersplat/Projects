`timescale 1ns/1ps
`ifndef WIDTH
`define WIDTH 4
`endif
module testbench();
   // You will need to handle multiple width_lp values during your demo
   localparam width_lp = `WIDTH;
   localparam iterations_lp = 64;
   wire [0:0]  clk_i;
   logic [0:0] error_o;
   logic [width_lp - 1:0] binary_o;
   logic [width_lp - 1:0] correct_binary_o;
   logic [width_lp - 1:0] gray_i;
   int itervar;
   generate genvar i;
	for(genvar i = 0; i < width_lp; i++) begin : conversion
	assign correct_binary_o[i] = ^gray_i[width_lp-1:i];	
	end
   endgenerate

   // Your testbench should PASS with the good DUT, and FAIL with the
   // "bad" DUT. Use `define GOOD to switch between the two.
   //
   // Write your assertions inside of the DUT modules themselves.
       nonsynth_clock_gen
     #(.cycle_time_p(10))
   cg
     (.clk_o(clk_i));

   graytobin
     #(.width_p(width_lp))
   dut
     (.binary_o(binary_o)
     ,.gray_i(gray_i));

   initial begin
      // Leave this code alone, it generates the waveforms
`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd"); //
`endif
      $dumpvars;

      // Put your testbench code here. Print all of the test cases and
      // their correctness.
	#15;

      $display("Begin Test:");
      $display();

      itervar = 0;
      gray_i = '0;
	for(itervar = '0; itervar < 2 ** width_lp; itervar++) begin

		$display("gray_i:%b, binary_o:%b, correct_o:%b", gray_i, binary_o, correct_binary_o);
		#10;
		gray_i = gray_i + 1;
	end
      
    		if(binary_o != correct_binary_o) begin
    			$error("binary_o:%b != correct_o:%b", binary_o, correct_binary_o);
    			error_o = 1'b1;
    			$finish();
    		end
      $finish();
   end

   final begin
      $display("Simulation time is %t", $time);
      if(error_o || (binary_o != correct_binary_o)) begin
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
