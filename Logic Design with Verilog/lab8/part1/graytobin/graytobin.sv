module graytobin
  #(parameter width_p = 4)
  (input [width_p -1:0] gray_i
  ,output [width_p - 1:0] binary_o);

  // Write your module and concurrent assertions here

  // Use `ifdef FORMAL to hide your concurrent assertion from iverilog
`ifdef FORMAL
 assert property (binary_o[width_p-1] = gray_i[width_p-1]);
 assert property (binary_o[width_p-2] = gray_i[width_p-1] ^ gray_i[width_p-2];
`endif

logic [width_p - 1:0] gray_hold;
assign binary_o = gray_hold;
generate genvar i;
for(i = 0; i < width_p; i++) begin : conversion
	assign gray_hold[i] = ^gray_i[width_p-1:i];	
end
endgenerate
endmodule
