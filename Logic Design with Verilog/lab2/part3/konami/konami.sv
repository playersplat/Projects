module konami
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,input [0:0] down_i
   ,input [0:0] left_i
   ,input [0:0] right_i
   ,input [0:0] b_i
   ,input [0:0] a_i
   ,input [0:0] start_i
   ,output reg [0:0] cheat_code_unlocked_o);

   // Implement a state machine to recognize the Konami Code.
   // 
   //    https://en.wikipedia.org/wiki/Konami_Code
   //
   // The sequence is: UP UP DOWN DOWN LEFT RIGHT LEFT RIGHT B A START
   //
   // The solution must:
   // 
   //  * Use behavioral verilog, written in this file
   // 
   //  * Go to the intitial state when reset_i is one
   //
   //  * Go back to the initial state on the next input to the machine.
   //
   //  * Set cheat_code_unlocked_o to 1 when the sequence is recognized
   //
   //  * Buttons may be asserted at the same time, but in the correct
   //  sequence, only one button is pressed at a time. (I.e. don't
   //  interpet UP and DOWN at the same time as an UP and then a
   //  DOWN. It is invalid.)
   //
   //  * Recognize any string with the correct sequence, for example
   //  DOWN UP UP UP DOWN DOWN LEFT RIGHT LEFT RIGHT B A START should
   //  assert cheat_code_unlocked_o
   // 
   // Your code here:
   reg [6:0] control_reg;
   assign control_reg[6] = up_i;
   assign control_reg[5] = down_i;
   assign control_reg[4] = left_i;
   assign control_reg[3] = right_i;
   assign control_reg[2] = b_i;
   assign control_reg[1] = a_i;
   assign control_reg[0] = start_i;
   
   enum {init, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11} state_now, state_next;
   
   	
   
   always_ff @(posedge clk_i or negedge reset_i) begin : status
   	if (reset_i) begin
   	state_now <= init;
   	end else begin
   	state_now <= state_next;
        //$display("control_reg: %b || state: %b, unlock: %0d", control_reg, state_now, cheat_code_unlocked_o);
   	end
   end : status
   always_latch begin : unlock
   	if (state_now == s11) begin cheat_code_unlocked_o = 1'b1; end

   end
   
   always_latch begin : lock
   	if (state_now != s11) begin cheat_code_unlocked_o = 1'b0; end
   end

   always_comb begin : next_state
   	if (control_reg == 7'b1000000 && (state_now == init || state_now == s2 || state_now == s11)) begin state_next = s1; end
   	else if (control_reg == 7'b1000000 && state_now == s1) begin state_next = s2; end
   	else if (control_reg == 7'b0100000 && state_now == s2) begin state_next = s3; end
   	else if (control_reg == 7'b0100000 && state_now == s3) begin state_next = s4; end
   	else if (control_reg == 7'b0010000 && state_now == s4) begin state_next = s5; end
   	else if (control_reg == 7'b0001000 && state_now == s5) begin state_next = s6; end
   	else if (control_reg == 7'b0010000 && state_now == s6) begin state_next = s7; end
   	else if (control_reg == 7'b0001000 && state_now == s7) begin state_next = s8; end
   	else if (control_reg == 7'b0000100 && state_now == s8) begin state_next = s9; end
   	else if (control_reg == 7'b0000010 && state_now == s9) begin state_next = s10; end
   	else if (control_reg == 7'b0000001 && state_now == s10) begin state_next = s11; end
   	else begin state_next = init; end
   	/*
   	case (state_now) inside
   	init : if(control_reg == 7'b1000000) state_next = s1;
   	s1 :   if(control_reg == 7'b1000000) state_next = s2;
   	s2 :   if(control_reg == 7'b0100000) state_next = s3;
   	s3 :   if(control_reg == 7'b0100000) state_next = s4;
   	s4 :   if(control_reg == 7'b0010000) state_next = s5;
   	s5 :   if(control_reg == 7'b0001000) state_next = s6;
   	s6 :   if(control_reg == 7'b0010000) state_next = s7;
   	s7 :   if(control_reg == 7'b0001000) state_next = s8;
   	s8 :   if(control_reg == 7'b0000100) state_next = s9;
   	s9 :   if(control_reg == 7'b0000010) state_next = s10;
   	s10 :  if(control_reg == 7'b0000001) state_next = s11;
   	s11 :  if(control_reg == 7'b0000001) state_next = init;
	endcase
	*/
   end

endmodule

