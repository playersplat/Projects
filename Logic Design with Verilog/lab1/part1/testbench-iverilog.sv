`timescale 1ns/1ps
module part1_tb();

   initial begin
      $dumpfile("iverilog.vcd");
      $dumpvars;
      
      $display();
      $display("   / / / /__  / / /___     | |     / /___  _____/ /___/ /");
      $display("  / /_/ / _ \\/ / / __ \\    | | /| / / __ \\/ ___/ / __  / ");
      $display(" / __  /  __/ / / /_/ /    | |/ |/ / /_/ / /  / / /_/ /  ");
      $display("/_/ /_/\\___/_/_/\\____/     |__/|__/\\____/_/  /_/\\__,_/   ");
      
      #10;

      $display();
      $display("Simulation time is %t", $time);
      $display();
	
   end // initial begin
  
   final begin
      $display("Icarus Verilog Simulation Succeeded!");
      $display();      
   end

endmodule
