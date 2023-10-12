// Do not modify this file!
`timescale 1ns/1ps
`ifndef WIDTH
`define WIDTH 4
`endif
module testbench();
   localparam width_lp = `WIDTH;
   localparam iterations_lp = 64;
   logic [0:0] reset_done = 1'b0;
   logic [0:0] up_i;
   wire [0:0]  clk_i;
   logic [0:0]  reset_i;
   logic [0:0] error_o;
   logic [width_lp - 1:0] binary_o;
   logic [width_lp - 1:0] correct_gray_o;
   logic [width_lp:0] itervar_a;
   logic [width_lp - 1:0] gray_o;
   assign error_o = (correct_gray_o !== gray_o);
   int itervar;
   logic [1:0] test_vector [0:iterations_lp-1];
   
   initial begin
      test_vector[6'h00] = 2'b00;
      test_vector[6'h01] = 2'b10;
      test_vector[6'h02] = 2'b10;
      test_vector[6'h03] = 2'b10;
      
      test_vector[6'h04] = 2'b10;
      test_vector[6'h05] = 2'b10;
      test_vector[6'h06] = 2'b10;
      test_vector[6'h07] = 2'b10;
      
      test_vector[6'h08] = 2'b10;
      test_vector[6'h09] = 2'b10;
      test_vector[6'h0a] = 2'b10;
      test_vector[6'h0b] = 2'b10;
      
      test_vector[6'h0c] = 2'b10;
      test_vector[6'h0d] = 2'b10;
      test_vector[6'h0e] = 2'b10;
      test_vector[6'h0f] = 2'b10;
      
      test_vector[6'h10] = 2'b10;
      test_vector[6'h11] = 2'b10;
      test_vector[6'h12] = 2'b10;
      test_vector[6'h13] = 2'b10;
      
      test_vector[6'h14] = 2'b10;
      test_vector[6'h15] = 2'b10;
      test_vector[6'h16] = 2'b10;
      test_vector[6'h17] = 2'b10;
      
      test_vector[6'h18] = 2'b10;
      test_vector[6'h19] = 2'b10;
      test_vector[6'h1a] = 2'b10;
      test_vector[6'h1b] = 2'b10;
      
      test_vector[6'h1c] = 2'b10;
      test_vector[6'h1d] = 2'b10;
      test_vector[6'h1e] = 2'b10;
      test_vector[6'h1f] = 2'b10;
      
      test_vector[6'h20] = 2'b10;
      test_vector[6'h21] = 2'b10;
      test_vector[6'h22] = 2'b10;
      test_vector[6'h23] = 2'b10;
      
      test_vector[6'h24] = 2'b10;
      test_vector[6'h25] = 2'b10;
      test_vector[6'h26] = 2'b10;
      test_vector[6'h27] = 2'b10;
      
      test_vector[6'h28] = 2'b10;
      test_vector[6'h29] = 2'b10;
      test_vector[6'h2a] = 2'b10;
      test_vector[6'h2b] = 2'b10;
      
      test_vector[6'h2c] = 2'b10;
      test_vector[6'h2d] = 2'b10;
      test_vector[6'h2e] = 2'b10;
      test_vector[6'h2f] = 2'b10;
      
      test_vector[6'h30] = 2'b10;
      test_vector[6'h31] = 2'b10;
      test_vector[6'h32] = 2'b10;
      test_vector[6'h33] = 2'b10;
      
      test_vector[6'h34] = 2'b10;
      test_vector[6'h35] = 2'b10;
      test_vector[6'h36] = 2'b10;
      test_vector[6'h37] = 2'b10;
      //
      test_vector[6'h38] = 2'b00;
      test_vector[6'h39] = 2'b00;
      test_vector[6'h3a] = 2'b00;
      test_vector[6'h3b] = 2'b00;
 
      test_vector[6'h3c] = 2'b00;
      test_vector[6'h3d] = 2'b00;
      test_vector[6'h3e] = 2'b00;
      test_vector[6'h3f] = 2'b00;
   end

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

   graycounter
     #(.width_p(width_lp))
   dut
     (.clk_i(clk_i)
     // Hint: there is a bug in one of the modules regarding reset.
     ,.reset_i(reset_i)
     ,.up_i(up_i)
     ,.gray_o(gray_o));

   initial begin
`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      // Good Luck!
      #15;

      $display("Begin Test:");
      $display();
      correct_gray_o = '0;
      binary_o = '0;
      itervar = 0;

      @(negedge reset_i);
      reset_done = 1;
      correct_gray_o = '0;
      binary_o = '0;
      itervar = 0;//
      for(itervar = 0; itervar < iterations_lp; itervar++) begin
        @(posedge clk_i);
        if (itervar == 60) begin
        	reset_i = 1'b1;
        	binary_o = '0;//
        	correct_gray_o = '0;
        end else begin
        	reset_i = 1'b0;
        end
        if (up_i == 1'b1) begin
        	binary_o = binary_o + 1'b1;
		correct_gray_o = (binary_o >> 1) ^ binary_o;
      	end 
	$display("At Posedge %d: up_i = %b, gray_o:%b correct_gray_o: %b",itervar, up_i, gray_o, correct_gray_o);
	
      end
      $finish();
   end

always @(negedge clk_i) begin//
      up_i = test_vector[itervar][1];

        if(error_o & reset_done & !reset_i) begin
      	  $display("gray_o:%b != correct_gray_o: %b", gray_o, correct_gray_o);
      	end else if (reset_i & (correct_gray_o != gray_o)) begin
      		$error("ERROR!, gray_o should be %b during reset, got %b", correct_gray_o, gray_o);
      	end
   end

   final begin
      $display("Simulation time is %t", $time);
      if(error_o) begin
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
