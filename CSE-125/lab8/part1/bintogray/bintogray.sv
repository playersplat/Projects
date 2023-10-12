module bintogray
  #(parameter width_p = 4)
  (input [width_p - 1:0] binary_i
  ,output [width_p -1:0] gray_o);

  // Write your module and concurrent assertions here

  // Use `ifdef FORMAL to hide your concurrent assertion from iverilog
`ifdef FORMAL
 assert property (gray_o = (binary_i >> 1) ^ binary_i);
`endif

logic [width_p - 1:0] binary_w;

always_comb begin
	binary_w = (binary_i >> 1);
	binary_w = binary_w ^ binary_i;
end

assign gray_o = binary_w;
endmodule
