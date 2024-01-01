module counter_down
  #(parameter width_p = 4)
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [width_p-1:0] clone_i
   ,input [0:0] clone_flag
   ,input [0:0] down_i
   ,output reg [width_p-1:0] counter_o);

   // Implement a parameterized up/down counter. You must use behavioral verilog
   //
   // counter_o must reset to '0 at the positive edge of clk_i when reset_i is 1
   //
   // counter_o must have the following behavior at the positive edge of clk_i when reset_i is 0:
   // 
   // * Maintain the same value when up_i and down_i are both 1 or both 0.
   // 
   // * Increment by 1 when up_i is 1 and down_i is 0
   //
   // * Decrement by 1 when down_i is 1 and up_i is 0 
   //
   // * Use two's complement: -1 == '1 (Remember: decrementing by 1 is the same as adding negative 1)
   //
   // If the counter value overflows, return to 0. If the counter value underflows, return to the maximum value.
   //
   // (In other words you don't need to handle over/underflow conditions).
   // 
   // Your code here:
   always_ff @(posedge clk_i)
   begin
   if (reset_i)
   counter_o <= '0;
   else if(clone_flag & !down_i)
   counter_o <= clone_i;
   else if(down_i & !clone_flag)
   counter_o <= counter_o - 1;
   end
       
endmodule
