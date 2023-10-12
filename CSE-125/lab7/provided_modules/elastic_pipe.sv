module elastic_pipe
 #(parameter [31:0] width_p = 10
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

   logic [0:0] valid_r;
   logic [width_p-1:0] data_r;
   wire                enable_w;

   assign valid_o = valid_r;
   assign ready_o = ~valid_r | ready_i;
   assign enable_w = ready_o & valid_i;
   assign data_o = data_r;

   always_ff @(posedge clk_i) begin
      if(reset_i) begin
         data_r <= '0;
      end else if (enable_w) begin
         data_r <= data_i;
      end
   end

   always_ff @(posedge clk_i) begin
      if (reset_i) begin
         valid_r <= '0;
      end else if (ready_o) begin
         valid_r <= (valid_i & ready_o);
      end
   end
   
   
endmodule

