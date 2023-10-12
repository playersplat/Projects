`timescale 1ns/1ps
module testbench();
   localparam width_lp = 8;
   logic [width_lp-1:0] binary_i;
   wire  [$clog2(width_lp):0] count_o;
   logic [width_lp:0] itervar_binary_i;
   logic [0:0] error;
   logic [$clog2(width_lp):0] correct_count_o;
   assign correct_count_o = $countones(binary_i);
   assign error = (correct_count_o != count_o);
   
   
   // Your testbench should PASS with the good DUT, and FAIL with the
   // "bad" DUT. Use `define GOOD to switch between the two.
   //
   // Write your assertions inside of the DUT modules themselves.
`ifdef GOOD
   countones
     #(.width_p(width_lp))
   dut_good
     (.binary_i(binary_i)
     ,.count_o(count_o));
`else 
   countones_synth
     #(.width_p(width_lp))
   dut_bad
     (.binary_i(binary_i)
     ,.count_o(count_o));
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
      for(itervar_binary_i = '0; itervar_binary_i < (2 ** width_lp); itervar_binary_i++) begin
                binary_i = itervar_binary_i[width_lp-1:0];
                $display("binary_i: %b, count_o: %b, correct_count_o: %b", binary_i, count_o, correct_count_o);
		    #10;
		    if(error) begin
 			assert (count_o == $countones(binary_i)) else $display("count_o: %b, correct_count_o: %b", count_o, correct_count_o);

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
