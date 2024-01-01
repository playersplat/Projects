// Do not modify this file!
`timescale 1ns/1ps
module testbench();

   logic [0:0] a_i;
   logic [0:0] b_i;
   logic [0:0] carry_i;
   logic [0:0] sum_o;
   logic [0:0] carry_o;

   wire [1:0] s;
   wire [0:0] error_carry_o;
   wire [0:0] error_sum_o;
   wire [0:0] correct_carry_o;
   wire [0:0] correct_sum_o;
   logic [3:0] itervar;
   
   assign s = (a_i + b_i + carry_i);

   assign correct_carry_o = s[1];
   assign correct_sum_o = s[0];

   assign error_carry_o = (carry_o !== correct_carry_o);
   assign error_sum_o = (sum_o !== correct_sum_o);

   full_add dut
     (.a_i(a_i)
     ,.b_i(b_i)
     ,.carry_i(carry_i)
     ,.sum_o(sum_o)
     ,.carry_o(carry_o));

   initial begin
`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      $display();
      $display("  ______          __  __                    __       ____      ____              __    __");
      $display(" /_  __/__  _____/ /_/ /_  ___  ____  _____/ /_     / __/_  __/ / /   ____ _____/ /___/ /");
      $display("  / / / _ \\/ ___/ __/ __ \\/ _ \\/ __ \\/ ___/ __ \\   / /_/ / / / / /   / __ `/ __  / __  / ");
      $display(" / / /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /  / __/ /_/ / / /   / /_/ / /_/ / /_/ /  ");
      $display("/_/  \\___/____/\\__/_.___/\\___/_/ /_/\\___/_/ /_/  /_/  \\__,_/_/_/____\\__,_/\\__,_/\\__,_/   ");
      $display("                                                              /_____/                          ");
      
      #10;
      $display("Begin Test:");

      $display();

      // This is C-like verilog. You should only use it when writing
      // testbenches.
      for(itervar = '0; itervar < 4'b1000; itervar++) begin

	 {a_i, b_i, carry_i} = itervar[2:0];

	 $display("  a_i = %b, b_i = %b, carry_i = %b", a_i, b_i, carry_i);
	 #10;
	 if(error_carry_o) begin
	    $error("\033[0;31mError!\033[0m: carry_o should be %b, got %b (a_i is %b, b_i is %b, carry_i is %b)",
		   correct_carry_o, carry_o, a_i, b_i, carry_i);
	    $finish();
	 end

	 if(error_sum_o) begin
	    $error("\033[0;31mError!\033[0m: sum_o should be %b, got %b (a_i is %b, b_i is %b, carry_i is %b)",
		   correct_sum_o, sum_o, a_i, b_i, carry_i);
	    $finish();
	 end
      end
   end

   final begin
      $display("Simulation time is %t", $time);
      if(error_carry_o | error_sum_o) begin
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
