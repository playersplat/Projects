// Do not modify this file!
`timescale 1ns/1ps
module testbench();

   logic [7:0] kpyd_i;
   logic [7:0] ssd_o;

   logic [7:0] correct_ssd;
   wire [0:0] error;
   logic [4:0] digit;
   logic [8:0] itervar;

   always_comb begin
      case(kpyd_i)
        // Row/Col
        8'b1000_1000: begin
           digit = 5'h1;
           correct_ssd = ~8'd6;
        end
        8'b1000_0100: begin
           digit = 5'h2;
           correct_ssd = ~8'd91;
        end
        8'b1000_0010: begin
           digit = 5'h3;
           correct_ssd = ~8'd79;
        end
        8'b1000_0001: begin
           digit = 5'hA;
           correct_ssd = ~8'b0111_0111;
        end
        8'b0100_1000: begin
           digit = 5'h4;
           correct_ssd = ~8'd102;
        end
        8'b0100_0100: begin
           digit = 5'h5;
           correct_ssd = ~8'd109;
        end
        8'b0100_0010: begin
           digit = 5'h6;
           correct_ssd = ~8'd125;
        end
        8'b0100_0001: begin
           digit = 5'hB;
           correct_ssd = ~8'b0111_1100;
        end
        8'b0010_1000: begin
           digit = 5'h7;
           correct_ssd = ~8'd7;
        end
        8'b0010_0100: begin
           digit = 5'h8;
           correct_ssd = ~8'd127;
        end
        8'b0010_0010: begin
           digit = 5'h9;
           correct_ssd = ~8'd111;
        end
        8'b0010_0001: begin
           digit = 5'hC;
           correct_ssd = ~8'b0011_1001;
        end
        8'b0001_1000: begin
           digit = 5'h0;
           correct_ssd = ~8'd63;
        end
        8'b0001_0100: begin
           digit = 5'hF;
           correct_ssd = ~8'b0111_0001;
        end
        8'b0001_0010: begin
           digit = 5'hE;
           correct_ssd = ~8'b0111_1001;
        end
        8'b0001_0001: begin
           digit = 5'hD;
           correct_ssd = ~8'b0101_1110;
        end
        default: begin
           digit = 5'h10;
           correct_ssd = 8'hff;
        end
      endcase // case (kpyd_i)
   end

   assign error = (ssd_o !== correct_ssd);

   kpyd2ssd dut
     (.kpyd_i(kpyd_i)
     ,.ssd_o(ssd_o));
   
   initial begin
`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      $display();
      
      $display("  ______          __  __                    __       __                   _____                 __");
      $display(" /_  __/__  _____/ /_/ /_  ___  ____  _____/ /_     / /______  __  ______/ /__ \\ ______________/ /");
      $display("  / / / _ \\/ ___/ __/ __ \\/ _ \\/ __ \\/ ___/ __ \\   / //_/ __ \\/ / / / __  /__/ // ___/ ___/ __  / ");
      $display(" / / /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /  / ,< / /_/ / /_/ / /_/ // __/(__  |__  ) /_/ /  ");
      $display("/_/  \\___/____/\\__/_.___/\\___/_/ /_/\\___/_/ /_/  /_/|_/ .___/\\__, /\\__,_//____/____/____/\\__,_/   ");
      $display("                                                     /_/    /____/                                ");

      #10;
      $display("Begin Test:");

      $display();

      // This is C-like verilog. You should only use it when writing
      // testbenches.
      for(itervar = '0; itervar < 9'b1_0000_0000; itervar++) begin

	 kpyd_i = itervar[7:0];
	 $display("  kpyd_i = %b", kpyd_i);
	 #10;
	 if(error) begin
	    $error("\033[0;31mError!\033[0m: ssd_o should be %b, got %b, kpyd_i was %b", correct_ssd, ssd_o, kpyd_i);
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
