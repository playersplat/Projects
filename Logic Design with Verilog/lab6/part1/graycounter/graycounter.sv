module graycounter
  #(parameter width_p = 4)
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,output [width_p-1:0] gray_o);

logic[width_p-1:0] counter_o;
logic[width_p-1:0] gray_w;

always_ff @(posedge clk_i)
begin
	if(reset_i) begin
	counter_o <= '0;
	gray_w <= '0;
	end
	else if (up_i) begin
	counter_o <= counter_o + 1;
	gray_w <= (counter_o >> 1) ^ counter_o;
	end
end

assign gray_o = gray_w;

endmodule
