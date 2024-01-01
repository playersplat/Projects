// Do not modify this file!
`timescale 1ns/1ps
module testbench();

   logic [0:0] a_i;
   logic [0:0] b_i;
   logic [0:0] c_o;

   wire [0:0] error;
   wire [0:0] correct;
   logic [2:0] itervar;

   assign correct = (a_i == b_i);
   assign error = (c_o !== correct);

   eq2 dut
     (.a_i(a_i)
     ,.b_i(b_i)
     ,.c_o(c_o));
   
   initial begin
`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      $display();
      $display("  ______          __  __                    __                 ___ ");
      $display(" /_  __/__  _____/ /_/ /_  ___  ____  _____/ /_     ___  ____ |__ \\");
      $display("  / / / _ \\/ ___/ __/ __ \\/ _ \\/ __ \\/ ___/ __ \\   / _ \\/ __ `/_/ /");
      $display(" / / /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /  /  __/ /_/ / __/ ");
      $display("/_/  \\___/____/\\__/_.___/\\___/_/ /_/\\___/_/ /_/   \\___/\\__, /____/ ");
      $display("                                                         /_/       ");
      $display("");
      #10;
      $display("Begin Test:");

      $display();

      // This is C-like verilog. You should only use it when writing
      // testbenches.
      for(itervar = '0; itervar < 3'b100; itervar++) begin

	 {a_i, b_i} = itervar[1:0];
	 
	 $display("  a_i = %b, b_i = %b", a_i, b_i);
	 #10;
	 if(error) begin
	    $error("\033[0;31mError!\033[0m: c_o should be %b, got %b (a_i is %b, b_i is %b)", correct, c_o, a_i, b_i);
	    $finish();
	 end
      end
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
