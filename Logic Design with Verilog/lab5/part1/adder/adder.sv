module adder
  #(parameter width_p = 4)
  (input [width_p - 1:0] a_i
  ,input [width_p - 1:0] b_i
  ,input [width_p - 1:0] c_i
  ,output [width_p   :0] sum_o);

  assign sum_o = (a_i + b_i + c_i);

  // Write your immediate and concurrent assertions here

  // The synthesized code below does not implement the correct
  // behavior (but the error is simple).
  // 
  // You must write two concurrent assertions, one demonstrating your understanding
  //
  //  - One must fail (Demonstrating your understanding of how to
  //  write a concurrent assertion that checks for correct behavior.)
  //
  //  - One must pass (Demonstrating your understanding of the bug)
  //

  // Use `ifdef FORMAL to hide your concurrent assertion from iverilog
`ifdef FORMAL
 assert property (sum_o == a_i + b_i + c_i);
 assert property (sum_o == a_i - b_i + c_i); //adder wired to a_i - b_i + c_i
  
`endif


endmodule

module adder_synth	
  #(parameter width_p = 4)
  (input [width_p - 1:0] a_i
  ,input [width_p - 1:0] b_i
  ,input [width_p - 1:0] c_i
  ,output [width_p   :0] sum_o);

  // Write your immediate and concurrent assertions here

  // The synthesized code below does not implement the correct
  // behavior (but the error is simple).
  // 
  // You must write two concurrent assertions, one demonstrating your understanding
  //
  //  - One must fail (Demonstrating your understanding of how to
  //  write a concurrent assertion that checks for correct behavior.)
  //
  //  - One must pass (Demonstrating your understanding of the bug)
  //

  // Use `ifdef FORMAL to hide your concurrent assertion from iverilog
`ifdef FORMAL
 assert property (sum_o == a_i + b_i + c_i);
 assert property (sum_o == a_i - b_i + c_i); //adder wired to a_i - b_i + c_i

`endif

  yosys_adder
    #()
  adder_synth_i
    (.a_i(a_i)
    ,.b_i(b_i)
    ,.c_i(c_i)
    ,.sum_o(sum_o));

endmodule

(* hdlname = "\\adder" *)
(* dynports =  1  *)
(* top =  1  *)
(* src = "adder.sv:1.1-28.10" *)
module yosys_adder(a_i, b_i, c_i, sum_o);
  wire _00_;
  wire _01_;
  wire _02_;
  wire _03_;
  wire _04_;
  wire _05_;
  wire _06_;
  wire _07_;
  wire _08_;
  wire _09_;
  wire _10_;
  wire _11_;
  wire _12_;
  wire _13_;
  wire _14_;
  wire _15_;
  wire _16_;
  wire _17_;
  wire _18_;
  wire _19_;
  wire _20_;
  wire _21_;
  wire _22_;
  wire _23_;
  wire _24_;
  wire _25_;
  wire _26_;
  wire _27_;
  wire _28_;
  wire _29_;
  wire _30_;
  wire _31_;
  wire _32_;
  wire _33_;
  wire _34_;
  wire _35_;
  wire _36_;
  (* src = "adder.sv:3.26-3.29" *)
  input [3:0] a_i;
  wire [3:0] a_i;
  (* src = "adder.sv:4.26-4.29" *)
  input [3:0] b_i;
  wire [3:0] b_i;
  (* src = "adder.sv:5.26-5.29" *)
  input [3:0] c_i;
  wire [3:0] c_i;
  (* src = "adder.sv:6.26-6.31" *)
  output [4:0] sum_o;
  wire [4:0] sum_o;
  assign _00_ = ~b_i[1];
  assign _01_ = ~(c_i[1] ^ a_i[1]);
  assign _02_ = _01_ ^ _00_;
  assign _03_ = b_i[0] & ~(a_i[0]);
  assign _04_ = _03_ ^ _02_;
  assign _05_ = ~c_i[0];
  assign _06_ = ~(b_i[0] ^ a_i[0]);
  assign _07_ = _06_ | _05_;
  assign sum_o[1] = ~(_07_ ^ _04_);
  assign _08_ = ~b_i[2];
  assign _09_ = ~(c_i[2] ^ a_i[2]);
  assign _10_ = _09_ ^ _08_;
  assign _11_ = ~(c_i[1] & a_i[1]);
  assign _12_ = _00_ & ~(_01_);
  assign _13_ = _11_ & ~(_12_);
  assign _14_ = ~(_13_ ^ _10_);
  assign _15_ = _03_ | _02_;
  assign _16_ = _04_ & ~(_07_);
  assign _17_ = _16_ | ~(_15_);
  assign sum_o[2] = ~(_17_ ^ _14_);
  assign _18_ = ~b_i[3];
  assign _19_ = ~(c_i[3] ^ a_i[3]);
  assign _20_ = _19_ ^ _18_;
  assign _21_ = ~(c_i[2] & a_i[2]);
  assign _22_ = _08_ & ~(_09_);
  assign _23_ = _21_ & ~(_22_);
  assign _24_ = ~(_23_ ^ _20_);
  assign _25_ = _13_ | _10_;
  assign _26_ = _17_ & ~(_14_);
  assign _27_ = _25_ & ~(_26_);
  assign sum_o[3] = _27_ ^ _24_;
  assign _28_ = c_i[3] & a_i[3];
  assign _29_ = _18_ & ~(_19_);
  assign _30_ = _29_ | _28_;
  assign _31_ = _23_ | _20_;
  assign _32_ = ~(_25_ | _24_);
  assign _33_ = _31_ & ~(_32_);
  assign _34_ = _24_ | _14_;
  assign _35_ = _17_ & ~(_34_);
  assign _36_ = _33_ & ~(_35_);
  assign sum_o[4] = _36_ ^ _30_;
  assign sum_o[0] = _06_ ^ _05_;
endmodule
