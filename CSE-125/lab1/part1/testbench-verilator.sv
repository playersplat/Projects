`timescale 1ns/1ps
module part1_tb();

   initial begin
      $dumpfile("verilator.fst");
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

   // $system is unsupported in iverilog, so we'll run it in Verilator
   function string get_time();
      int    file_pointer;
      // Store time and date to file sys_time
      void'($system("date +%X--%x > sys_time"));
      // Open the file sys_time with read access
      file_pointer = $fopen("sys_time","r");
      // Assign the value from file to variable
      void'($fscanf(file_pointer,"%s",get_time));
      //close the file
      $fclose(file_pointer);
      void'($system("rm sys_time"));
   endfunction
   
   final begin
      $display("Verilator Simulation Succeeded!");
      $display();      
      $display("Current System Time is %s",get_time());
      $display();      
   end
endmodule
