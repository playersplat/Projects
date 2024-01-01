module graycounter
  #(parameter width_p = 8)
   (input [0:0] clk_i
   ,input [0:0] reset_i
   ,input [0:0] up_i
   ,output [width_p-1:0] gray_o);
/*
module bintogray
  #(parameter width_p = 4)
  (input [width_p - 1:0] binary_i
  ,output [width_p -1:0] gray_o);

module graytobin
  #(parameter width_p = 4)
  (input [width_p -1:0] gray_i
  ,output [width_p - 1:0] binary_o);
*/       


reg [width_p - 1:0] binary_r1;
logic [width_p - 1:0] gray_r1;

logic [width_p - 1:0] binary_r2;
reg [width_p - 1:0] gray_r2;

bintogray #(.width_p(width_p)) bin_inst(
	.binary_i(binary_r1),
	.gray_o(gray_r1));
	
graytobin #(.width_p(width_p)) gray_inst(
	.gray_i(gray_r2),
	.binary_o(binary_r2));
	
always_ff @(posedge clk_i) begin
	if(reset_i) begin
		binary_r1 = '0;
		gray_r1 = '0;
		binary_r2 = '0;
		gray_r2 = '0;
		
	end
	else if (up_i) begin
		gray_r2 = gray_r1;
		binary_r1 = binary_r2 + 1;
		
		
	end
end
assign gray_o = gray_r1;
endmodule
