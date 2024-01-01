// Do not modify this file!
`timescale 1ns/1ps
`ifndef WIDTH
`define WIDTH 5
`endif
module testbench();
   localparam width_lp = `WIDTH;
   localparam iterations_lp = 64;

   logic [0:0] reset_done = 1'b0;
   logic [0:0] up_i;
   logic [0:0] down_i;
   wire [0:0]  clk_i;
   wire [0:0]  reset_i;
   wire [0:0]  error_count_o;
   wire [width_lp - 1:0]  count_o;
   logic [width_lp - 1:0] correct_count_o;

   int			  itervar;
   logic [1:0]		  test_vector [0:iterations_lp-1];

   initial begin
      test_vector[6'h00] = 2'b00;
      test_vector[6'h01] = 2'b01;
      test_vector[6'h02] = 2'b01;
      test_vector[6'h03] = 2'b10;
      
      test_vector[6'h04] = 2'b01;
      test_vector[6'h05] = 2'b01;
      test_vector[6'h06] = 2'b01;
      test_vector[6'h07] = 2'b10;
      
      test_vector[6'h08] = 2'b11;
      test_vector[6'h09] = 2'b00;
      test_vector[6'h0a] = 2'b01;
      test_vector[6'h0b] = 2'b01;
      
      test_vector[6'h0c] = 2'b10;
      test_vector[6'h0d] = 2'b01;
      test_vector[6'h0e] = 2'b10;
      test_vector[6'h0f] = 2'b00;
      
      test_vector[6'h10] = 2'b00;
      test_vector[6'h11] = 2'b01;
      test_vector[6'h12] = 2'b01;
      test_vector[6'h13] = 2'b10;
      
      test_vector[6'h14] = 2'b01;
      test_vector[6'h15] = 2'b01;
      test_vector[6'h16] = 2'b01;
      test_vector[6'h17] = 2'b10;
      
      test_vector[6'h18] = 2'b11;
      test_vector[6'h19] = 2'b00;
      test_vector[6'h1a] = 2'b01;
      test_vector[6'h1b] = 2'b01;
      
      test_vector[6'h1c] = 2'b10;
      test_vector[6'h1d] = 2'b01;
      test_vector[6'h1e] = 2'b10;
      test_vector[6'h1f] = 2'b00;
      
      test_vector[6'h20] = 2'b00;
      test_vector[6'h21] = 2'b01;
      test_vector[6'h22] = 2'b01;
      test_vector[6'h23] = 2'b10;
      
      test_vector[6'h24] = 2'b11;
      test_vector[6'h25] = 2'b00;
      test_vector[6'h26] = 2'b01;
      test_vector[6'h27] = 2'b01;
      
      test_vector[6'h28] = 2'b10;
      test_vector[6'h29] = 2'b01;
      test_vector[6'h2a] = 2'b10;
      test_vector[6'h2b] = 2'b00;
      
      test_vector[6'h2c] = 2'b00;
      test_vector[6'h2d] = 2'b01;
      test_vector[6'h2e] = 2'b01;
      test_vector[6'h2f] = 2'b10;
      
      test_vector[6'h30] = 2'b01;
      test_vector[6'h31] = 2'b01;
      test_vector[6'h32] = 2'b01;
      test_vector[6'h33] = 2'b10;
      
      test_vector[6'h34] = 2'b01;
      test_vector[6'h35] = 2'b01;
      test_vector[6'h36] = 2'b01;
      test_vector[6'h37] = 2'b10;
      
      test_vector[6'h38] = 2'b11;
      test_vector[6'h39] = 2'b00;
      test_vector[6'h3a] = 2'b01;
      test_vector[6'h3b] = 2'b01;
      
      test_vector[6'h3c] = 2'b10;
      test_vector[6'h3d] = 2'b01;
      test_vector[6'h3e] = 2'b10;
      test_vector[6'h3f] = 2'b00;
   end

   assign error_count_o = (count_o !== correct_count_o);

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

   counter
     #(.width_p(width_lp))
   dut
     (.clk_i(clk_i)
     ,.reset_i(reset_i)
     ,.up_i(up_i)
     ,.down_i(down_i)
     ,.count_o(count_o));

   initial begin
`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      $display();


      $display("  ______          __  __                    __                              __           ");
      $display(" /_  __/__  _____/ /_/ /_  ___  ____  _____/ /_     _________  __  ______  / /____  _____");
      $display("  / / / _ \\/ ___/ __/ __ \\/ _ \\/ __ \\/ ___/ __ \\   / ___/ __ \\/ / / / __ \\/ __/ _ \\/ ___/");
      $display(" / / /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /  / /__/ /_/ / /_/ / / / / /_/  __/ /    ");
      $display("/_/  \\___/____/\\__/_.___/\\___/_/ /_/\\___/_/ /_/   \\___/\\____/\\__,_/_/ /_/\\__/\\___/_/     ");
                                                                                         
      $display();
      $display("Begin Test:");

      itervar = 0;
      correct_count_o = '0;

      @(negedge reset_i);

      reset_done = 1;

      for(itervar = 0; itervar < iterations_lp ; itervar ++) begin
	 @(posedge clk_i);
	 if( (up_i == down_i) ) begin
	    // Do nothing
	 end else if( up_i == 1'b1) begin
	    correct_count_o = correct_count_o + 1;
	 end else if( down_i == 1'b1) begin
	    correct_count_o = correct_count_o - 1;
	 end
	 $display("At Posedge %d: up_i = %b, down_i = %b, correct_count_o = %b, reset_i = %b ",
		  itervar, up_i, down_i, correct_count_o, reset_i);
      end
      $finish();
   end


   always @(negedge clk_i) begin
      // $display("At Negedge %d: data_i = %b, count_o = %b, reset_i = %b ", itervar, data_i, count_o, reset_i);
      down_i = test_vector[itervar][0];
      up_i = test_vector[itervar][1];
      if(reset_done & !reset_i & error_count_o) begin
	    $error("\033[0;31mError!\033[0m: count_o should be %b, got %b", correct_count_o, count_o);
	    $finish();
      end else if (reset_i & error_count_o) begin
	    $error("\033[0;31mError!\033[0m: count_o should be %b during reset, got %b", correct_count_o, count_o);
	    $finish();	 
      end
   end

   final begin
      $display("Simulation time is %t", $time);
      if(error_count_o) begin
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
