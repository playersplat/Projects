// Do not modify this file!
`timescale 1ns/1ps
module testbench();
   localparam iterations_lp = 64;
   logic [0:0] reset_done = 1'b0;

   wire [0:0]  clk_i;
   wire [0:0]  reset_i;
   logic [0:0] reset_button;
   logic [0:0] up_i;
   logic [0:0] down_i;
   logic [0:0] left_i;
   logic [0:0] right_i;
   logic [0:0] b_i;
   logic [0:0] a_i;
   logic [0:0] start_i;
   logic [0:0] no_input;
   wire [0:0]  unlock_o;

   wire [0:0]  error_unlock_o;
   logic [0:0] correct_unlock_o;
   logic [0:0] correct_unlock_n;

   int         itervar;
   logic [9:0] test_symbols [65];

   initial begin
      // {Up,Down,Left,Right,B,A,Start,Reset,Unlock,No Input}
      test_symbols[ 0] = 10'b00_0000_0001;
      test_symbols[ 1] = 10'b10_0000_0000;
      test_symbols[ 2] = 10'b10_0000_0000;
      test_symbols[ 3] = 10'b01_0000_0000;
      test_symbols[ 4] = 10'b01_0000_0000;
      test_symbols[ 5] = 10'b00_1000_0000;
      test_symbols[ 6] = 10'b00_0100_0000;
      test_symbols[ 7] = 10'b00_1100_0000;
      test_symbols[ 8] = 10'b00_0010_0000;
      test_symbols[ 9] = 10'b00_0001_0000;
      test_symbols[10] = 10'b00_0000_1000;
      test_symbols[11] = 10'b10_0000_0000;
      test_symbols[12] = 10'b01_0000_0000;
      test_symbols[13] = 10'b00_1000_0000;
      test_symbols[14] = 10'b00_0100_0000;
      test_symbols[15] = 10'b00_0010_0000;
      test_symbols[16] = 10'b00_0001_0000;
      test_symbols[17] = 10'b00_0000_1000;
      test_symbols[18] = 10'b10_0000_0000;
      test_symbols[19] = 10'b10_0000_0000;
      test_symbols[20] = 10'b01_0000_0000;
      test_symbols[21] = 10'b01_0000_0000;
      test_symbols[22] = 10'b00_1000_0000;
      test_symbols[23] = 10'b00_0100_0000;
      test_symbols[24] = 10'b00_1000_0000;
      test_symbols[25] = 10'b00_0100_0000;
      test_symbols[26] = 10'b00_0010_0000;
      test_symbols[27] = 10'b00_0001_0000;
      test_symbols[28] = 10'b00_0000_0001;
      test_symbols[29] = 10'b00_0000_0100;
      test_symbols[30] = 10'b00_0000_1000;
      test_symbols[31] = 10'b11_0000_0000;
      test_symbols[32] = 10'b11_0000_0000;
      test_symbols[33] = 10'b00_1100_0000;
      test_symbols[34] = 10'b00_1100_0000;
      test_symbols[35] = 10'b00_0011_0000;
      test_symbols[36] = 10'b00_0000_1000;
      test_symbols[37] = 10'b00_0010_0000;
      test_symbols[38] = 10'b00_1000_0000;
      test_symbols[39] = 10'b10_0000_0000;
      test_symbols[40] = 10'b10_0000_0000;
      test_symbols[41] = 10'b10_0000_0000;
      test_symbols[42] = 10'b10_0000_0000;
      test_symbols[43] = 10'b01_0000_0000;
      test_symbols[44] = 10'b01_0000_0000;
      test_symbols[45] = 10'b00_1000_0000;
      test_symbols[46] = 10'b00_0100_0000;
      test_symbols[47] = 10'b00_1000_0000;
      test_symbols[48] = 10'b00_0100_0000;
      test_symbols[49] = 10'b00_0010_0000;
      test_symbols[50] = 10'b00_0001_0000;
      test_symbols[51] = 10'b00_0000_1000;
      test_symbols[52] = 10'b10_0000_0010;
      test_symbols[53] = 10'b10_0000_0000;
      test_symbols[54] = 10'b01_0000_0000;
      test_symbols[55] = 10'b01_0000_0000;
      test_symbols[56] = 10'b00_1000_0000;
      test_symbols[57] = 10'b00_0100_0000;
      test_symbols[58] = 10'b00_1000_0000;
      test_symbols[59] = 10'b00_0100_0000;
      test_symbols[60] = 10'b00_0010_0000;
      test_symbols[61] = 10'b00_0001_0000;
      test_symbols[62] = 10'b00_0000_1000;
      test_symbols[63] = 10'b00_0000_0010;
      test_symbols[64] = 10'b00_0000_0000;
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

   konami
     #()
   dut
     (.clk_i(clk_i)
     ,.reset_i(reset_i | reset_button)
     ,.up_i(up_i)
     ,.down_i(down_i)
     ,.left_i(left_i)
     ,.right_i(right_i)
     ,.a_i(a_i)
     ,.b_i(b_i)
     ,.start_i(start_i)
     ,.cheat_code_unlocked_o(unlock_o));

   initial begin
      reset_button = 0;      
`ifdef VERILATOR
      $dumpfile("verilator.fst");
`else
      $dumpfile("iverilog.vcd");
`endif
      $dumpvars;

      $display();
      $display("  ______          __  __                    __       __ __                            _ ");
      $display(" /_  __/__  _____/ /_/ /_  ___  ____  _____/ /_     / //_/___  ____  ____ _____ ___  (_)");
      $display("  / / / _ \\/ ___/ __/ __ \\/ _ \\/ __ \\/ ___/ __ \\   / ,< / __ \\/ __ \\/ __ `/ __ `__ \\/ / ");
      $display(" / / /  __(__  ) /_/ /_/ /  __/ / / / /__/ / / /  / /| / /_/ / / / / /_/ / / / / / / /  ");
      $display("/_/  \\___/____/\\__/_.___/\\___/_/ /_/\\___/_/ /_/  /_/ |_\\____/_/ /_/\\__,_/_/ /_/ /_/_/   ");
                                                                                        
      $display();
      $display("Begin Test:");

      itervar = 0;
      {up_i, down_i, left_i, right_i, b_i, a_i, start_i, reset_button, correct_unlock_o, no_input} = test_symbols[itervar];

      @(negedge reset_i);

      reset_done = 1'b1;
      correct_unlock_o = 1'b0;


      for(itervar = 0; itervar <= iterations_lp; itervar ++) begin
         correct_unlock_o = test_symbols[itervar][1];
	 @(posedge clk_i);
	 $display("At Posedge %d: U: %b D: %b, L: %b, R:%b, B:%b, A:%b, S:%b, R:%b reset_i = %b ", itervar, up_i, down_i, left_i, right_i, b_i, a_i, start_i, reset_button, reset_i);
      end
      
   end

   assign error_unlock_o = (correct_unlock_o !== unlock_o) && (itervar < iterations_lp);
   always @(negedge clk_i) begin
      // {Up,Down,Left,Right,B,A,Start,Reset,Unlock,No Input}
      {up_i, down_i, left_i, right_i, b_i, a_i, start_i, reset_button, correct_unlock_n, no_input} = test_symbols[itervar];
      if(!reset_i && (reset_done == 1) && (error_unlock_o == 1)) begin
         $display("\033[0;31mError!\033[0m: cheat_code_unlocked_o should be %b, but got %b", correct_unlock_o, unlock_o);
         $finish();
      end
      if (itervar >= iterations_lp)
        $finish();
   end

   final begin
      $display("Simulation time is %t", $time);
      if(error_unlock_o) begin
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
      end // else: !if(error_unlock_o)
   end

endmodule
