`timescale 1ns/1ps
module testbench();
   localparam width_lp = 8;
   logic [width_lp-1:0] a_i;
   logic [width_lp-1:0] b_i;
   logic [(width_lp * 2) - 1:0] prod_o;
   wire [(width_lp * 2) - 1:0] correct_prod_o;
   logic [0:0] error;
   assign correct_prod_o = a_i * b_i;
   assign error = (correct_prod_o != prod_o);
   logic [width_lp:0] itervar_a;
   logic [width_lp:0] itervar_b;   
   // Your testbench should PASS with the good DUT, and FAIL with the
   // "bad" DUT. Use `define GOOD to switch between the two.
   //
   // Write your assertions inside of the DUT modules themselves.

`ifdef GOOD
   multiplier
     #(.width_p(8))
   dut_good
     (.a_i(a_i)
     ,.b_i(b_i)
     ,.prod_o(prod_o));
`else 
   multiplier_synth
     #(.width_p(8))
   dut_bad
     (.a_i(a_i)
     ,.b_i(b_i)
     ,.prod_o(prod_o));
`endif

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
		    if(error) begin
		       assert (a_i * b_i == prod_o) else $error("prod_o: %b != correct_prod_o: %b", prod_o, correct_prod_o);//must pass in good testbench
		       $finish();
	    end
	 end
      end
  
      $finish();
   end

   final begin
      $display("Simulation time is %t", $time);
      if(error) begin
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
