module ycbcr
 #(parameter [31:0] width_p = 24 // This will not change
  ) 
  (input [0:0] clk_i
  ,input [0:0] reset_i

  ,input [width_p - 1:0] data_i
  ,input [0:0] valid_i
  ,output [0:0] ready_o 

  ,output [0:0] valid_o 
  ,output [width_p - 1:0] data_o 
  ,input [0:0] ready_i
  );
   
  // Write your code here
  logic [0:0] v, v1, r, r1;
  logic [width_p-1:0] ext1, ext2, cb, cr, y;
  logic [width_p*3-1:0] data_in, data_out;
  always_comb begin
  ext1 = {{16{1'b0}}, data_i[15:8]}; //extending Cb
  ext2 = {{16{1'b0}}, data_i[23:16]}; //extending Cr
  y = {{16{1'b0}}, data_i[7:0]};
  cb = ext1 - 128; //Cb[7:0] - 128
  cr = ext2 - 128; //Cr[7:0] - 128
  data_in = {cb, cr, y};
  end

   elastic_pipe #(.width_p(width_p*3)) pipe_inst(
  	.clk_i(clk_i),
  	.reset_i(reset_i),
  	.data_i(data_in),
  	.valid_i(valid_i),
  	.ready_o(ready_o),
  	.valid_o(v),
  	.data_o(data_out),
  	.ready_i(r));
 logic [width_p-1:0] cb_left, cb_mid, cr_mid, cr_right, y_calc;
 logic [width_p*5-1:0] data_in1, data_out1;
  always_comb begin
  cb_left = {data_out[width_p*3-1:width_p*2]}; //Cb[7:0]
  cb_mid = {data_out[width_p*3-1:width_p*2]}; //Cb[7:0]
  cr_mid = {data_out[width_p*2-1:width_p]}; //Cr[7:0]
  cr_right = {data_out[width_p*2-1:width_p]}; //Cr[7:0]
  y_calc = {data_out[width_p-1:0]}; //Y[7:0]
  
  cb_left = cb_left *   1814; //Cb[7:0] * 1814
  cb_mid = cb_mid *     -352; //Cb[7:0] * -352
  cr_mid = cr_mid *     -731; //Cr[7:0] * -731
  cr_right = cr_right * 1435; //Cr[7:0] * 1435
  y_calc = y_calc *     1024; //Y[7:0] * 1024
  
  data_in1 = {cb_left[width_p-1:0], cb_mid[width_p-1:0], cr_mid[width_p-1:0], cr_right[width_p-1:0], y_calc[width_p-1:0]};
  end
    elastic_pipe #(.width_p(width_p*5)) pipe_inst1(
  	.clk_i(clk_i),
  	.reset_i(reset_i),
  	.data_i(data_in1),
  	.valid_i(v),
  	.ready_o(r),
  	.valid_o(v1),
  	.data_o(data_out1),
  	.ready_i(r1));
  logic [width_p-1:0] left, mid, right, y_hold;
  logic [width_p*3-1:0] data_in2, data_out2;
  always_comb begin
  y_hold = data_out1[width_p-1:0]; //Y
  left = data_out1[width_p*5-1:width_p*4] + y_hold; //Cb + Y
  mid = data_out1[width_p*4-1:width_p*3] + data_out1[width_p*3-1:width_p*2] + y_hold; //Cb + Cr + Y
  right = data_out1[width_p*2-1:width_p] + y_hold; //Cr + Y
  
  data_in2 = {left, mid, right};
  
  end	
    elastic_pipe #(.width_p(width_p*3)) pipe_inst2(
  	.clk_i(clk_i),
  	.reset_i(reset_i),
  	.data_i(data_in2),
  	.valid_i(v1),
  	.ready_o(r1),
  	.valid_o(valid_o),
  	.data_o(data_out2),
  	.ready_i(ready_i));
  logic [width_p-1:0] red, green, blue;
  logic [width_p-1:0] converted;
  always_comb begin
  red = data_out2[width_p*3-1:width_p*2] >> 10;// Left Branch
  green = data_out2[width_p*2-1:width_p] >> 10; //Middle Branch
  blue = data_out2[width_p-1:0] >> 10;  //Right Branch
 

  converted = {red[7:0], green[7:0], blue[7:0]};
  end
  assign data_o = converted;
  

  	
endmodule

