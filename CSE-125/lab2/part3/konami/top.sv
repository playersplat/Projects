// Top-level design file for the icebreaker FPGA board
//
// Wi23, Lab 2
module top
  (input [0:0] clk_12mhz_i
  ,input [0:0] reset_n_async_unsafe_i
   // n: Negative Polarity (0 when pressed, 1 otherwise)
   // async: Not synchronized to clock
   // unsafe: Not De-Bounced
  ,input [3:1] button_async_unsafe_i
   // async: Not synchronized to clock
   // unsafe: Not De-Bounced
   // SPI Interface (Renamed via: https://www.oshwa.org/a-resolution-to-redefine-spi-signal-names/)
  ,output [0:0] spi_cs_o
  ,output [0:0] spi_sd_o
  ,input [0:0] spi_sd_i
  ,output [0:0] spi_sck_o
  ,output [5:1] led_o);

   // For this demonstration, instantiate your Konami Code State
   // Machine to recognize input from the PMOD JSTK.
   //
   //    https://en.wikipedia.org/wiki/Konami_Code
   //
   // The sequence is: UP UP DOWN DOWN LEFT RIGHT LEFT RIGHT B A START
   //
   // Use Button 3 (button_async_unsafe_i[2]) for Button B
   // Use Button 2 (button_async_unsafe_i[2]) for Button Start
   // Use Button 1 (button_async_unsafe_i[1]) for Button A
   // 
   // Hints:
   //
   //  - An input symbol must be both a PRESS and a RELEASE for a
   //  button, or a rotation and a return to the middle for a
   //  joystick. A correct solution does not interpret a single UP
   //  press as two inputs.
   // 
   // - The buttons are not synchronized, Use the reset example to
   // synchronize.
   //
   // - The buttons are positive polarity. The inverter is not needed.
   //
   // - The buttons, and the joystick inputs, are not "debounced"
   // (https://en.wikipedia.org/wiki/Switch#Contact_bounce). Use your
   // counter to debounce the inputs.

   wire [39:0] data_o;
   wire [39:0] data_i;
   wire [9:0]  position_x;
   wire [9:0]  position_y;

   wire [23:0] color_rgb;
   
   // These two D Flip Flops form what is known as a Synchronizer. We
   // will learn about these in Week 5, but you can see more here:
   // https://inst.eecs.berkeley.edu/~cs150/sp12/agenda/lec/lec16-synch.pdf
   wire [0:0] reset_n_sync_r;
   wire [0:0] reset_sync_r;
   wire [0:0] reset_r; // Use this as your reset_signal

   dff
     #()
   sync_a
     (.clk_i(clk_12mhz_i)
     ,.reset_i(1'b0)
     ,.d_i(reset_n_async_unsafe_i)
     ,.q_o(reset_n_sync_r));

   inv
     #()
   inv
     (.a_i(reset_n_sync_r)
     ,.b_o(reset_sync_r));

   dff
     #()
   sync_b
     (.clk_i(clk_12mhz_i)
     ,.reset_i(1'b0)
     ,.d_i(reset_sync_r)
     ,.q_o(reset_r));
       
   PmodJSTK
     #()
   jstk_i
     (.clk_12mhz_i(clk_12mhz_i)
     ,.reset_i(reset_r)
     ,.data_i(data_i)
     ,.spi_sd_i(spi_sd_i)
     ,.spi_cs_o(spi_cs_o)
     ,.spi_sck_o(spi_sck_o)
     ,.spi_sd_o(spi_sd_o)
     ,.data_o(data_o));

   // data_o is Data Recieved from the PmodJSTK
   // Byte 1: Low byte X Coordinate
   // Byte 2: High byte X Coordinate
   // Byte 3: Low byte Y Coordinate
   // Byte 4: High byte Y Coordinate
   // Byte 5: High six bytes are ignored, then trigger, joystick
   assign position_y = {data_o[25:24], data_o[39:32]};
   assign position_x = {data_o[9:8], data_o[23:16]};

   // data_i to be sent to PmodJSTK.
   // Byte 1: Control Command for RGB on PmodJSTK
   // Byte 2: Red
   // Byte 3: Green
   // Byte 4: Blue
   // Byte 5: Ignored
   assign data_i = {8'b10000100, color_rgb, 8'b00000000};

   // Example Code: The example assignment statments below will light
   // the directional LEDs 2-5 when the joystick is pushed in a
   // direction.
   //
   // The Trigger button will light the red LED.

   // Red
   assign color_rgb[23:16] = 8'hff;
   // Green
   assign color_rgb[15:8] = 8'h00;
   // Blue
   assign color_rgb[7:0] = 8'h00;

   assign led_o[4] = position_x < 384;
   assign led_o[5] = position_x > 640;
   assign led_o[3] = position_y < 384;
   assign led_o[2] = position_y > 640;

   // Trigger Button
   assign led_o[1] = data_o[1];

   // Your code goes here


endmodule
