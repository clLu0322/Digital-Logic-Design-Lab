module seg7(
 input[3:0]x,
 output[7:0]y);
 reg[7:0]sout_t;
 always @(*)
  case(x)
   4'h0: sout_t=8'b11000000;
   4'h1: sout_t=8'b11111001;
   4'h2: sout_t=8'b10100100;
   4'h3: sout_t=8'b10110000;
   4'h4: sout_t=8'b10011001;
   4'h5: sout_t=8'b10010010;
   4'h6: sout_t=8'b10000011;
   4'h7: sout_t=8'b11111000;
	4'h8: sout_t=8'b10000000;
   4'h9: sout_t=8'b10011000;

	default: sout_t=8'b11111111;
  endcase
 assign y = sout_t;
endmodule