// Do not modify this file!
`timescale 1ns/1ps
`ifndef DEPTH
`define DEPTH 5
`endif

`ifndef RESET_VAL
`define RESET_VAL `DEPTH'b01010
`endif
module testbench();
   localparam depth_lp = `DEPTH;
   localparam reset_val_lp = `RESET_VAL;

   logic [0:0] reset_done = 1'b0;
   logic [0:0] data_i;
   wire [0:0]  clk_i;
   wire [0:0]  reset_i;
   wire [0:0]  error_data_o;
   wire [depth_lp - 1:0]  data_o;
   logic [depth_lp - 1:0] correct_data_o;

   int			  itervar;
   logic [20:0] test_data = 21'b10011_0110_0101_0100_0111;


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

   shift
     #(.depth_p(depth_lp)
      ,.reset_val_p(reset_val_lp))
   dut
     (.clk_i(clk_i)
     ,.reset_i(reset_i)
     ,.data_i(data_i)
     ,.data_o(data_o));

   initial begin
`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      $display();
      $display("  ______          __  __                    __            __    _ ______ ");
      $display(" /_  __/__  _____/ /_/ /_  ___  ____  _____/ /_     _____/ /_  (_) __/ /_");
      $display("  / / / _ \\/ ___/ __/ __ \\/ _ \\/ __ \\/ ___/ __ \\   / ___/ __ \\/ / /_/ __/");
      $display(" / / /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /  (__  ) / / / / __/ /_  ");
      $display("/_/  \\___/____/\\__/_.___/\\___/_/ /_/\\___/_/ /_/  /____/_/ /_/_/_/  \\__/  ");

      $display();
      $display("Begin Test:");

      itervar = 0;
      correct_data_o = `RESET_VAL;

      @(negedge reset_i);

      reset_done = 1;

      for(itervar = 0; itervar < 20 ; itervar ++) begin
	 @(posedge clk_i);
	 correct_data_o = {correct_data_o[depth_lp-2:0], data_i};
	 $display("At Posedge %d: data_i = %b, correct_data_o = %b, reset_i = %b ", itervar, data_i, correct_data_o, reset_i);
      end
      $finish();
   end


   always @(negedge clk_i) begin
      data_i = test_data[itervar];
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
