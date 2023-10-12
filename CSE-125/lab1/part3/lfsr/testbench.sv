// Do not modify this file!
`timescale 1ns/1ps
module testbench();
   logic [0:0] reset_done = 1'b0;
   wire [0:0]  clk_i;
   wire [0:0]  reset_i;
   wire [0:0]  error_data_o;
   wire [4:0]  data_o;
   wire [1:0]		  taps;
   logic [4:0] correct_data_o;

   int			  itervar;
   logic [20:0] test_data = 21'b10011_0110_0101_0100_0111;

   assign taps[0] = correct_data_o[1];
   assign taps[1] = correct_data_o[4];
   assign error_data_o = (data_o !== correct_data_o);

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

   lfsr
   dut
     (.clk_i(clk_i)
     ,.reset_i(reset_i)
     ,.data_o(data_o));

   initial begin
`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      $display();
      $display("  ______          __  __                    __       __    ___________ ____ ");
      $display(" /_  __/__  _____/ /_/ /_  ___  ____  _____/ /_     / /   / ____/ ___// __ \\");
      $display("  / / / _ \\/ ___/ __/ __ \\/ _ \\/ __ \\/ ___/ __ \\   / /   / /_   \\__ \\/ /_/ /");
      $display(" / / /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /  / /___/ __/  ___/ / _, _/ ");
      $display("/_/  \\___/____/\\__/_.___/\\___/_/ /_/\\___/_/ /_/  /_____/_/    /____/_/ |_|  ");

      $display();
      $display("Begin Test:");

      itervar = 0;
      correct_data_o = 1;

      @(negedge reset_i);

      reset_done = 1;

      for(itervar = 0; itervar < 64 ; itervar ++) begin
	 @(posedge clk_i);
	 correct_data_o = {correct_data_o[3:0], taps[0] ^ taps[1]};
	 $display("At Posedge %d: correct_data_o = %b, reset_i = %b ", itervar, correct_data_o, reset_i);
      end
      $finish();
   end


   always @(negedge clk_i) begin
      // $display("At Negedge %d: data_i = %b, data_o = %b, reset_i = %b ", itervar, data_i, data_o, reset_i);
      if(reset_done & !reset_i & error_data_o) begin
	    $error("\033[0;31mError!\033[0m: data_o should be %b, got %b", correct_data_o, data_o);
	    $finish();
      end else if (reset_i & error_data_o) begin
	    $error("\033[0;31mError!\033[0m: data_o should be %b during reset, got %b", correct_data_o, data_o);
	    $finish();	 
      end
   end

   final begin
      $display("Simulation time is %t", $time);
      if(error_data_o) begin
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
