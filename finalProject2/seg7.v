module seg7(
 input[2:0]x,
 output[7:0]y);
 reg[7:0]sout_t;
 always @(*)
  case(x)

   3'h1: sout_t=8'b11111001;
   3'h2: sout_t=8'b10100100;
   3'h3: sout_t=8'b10110000;
   3'h4: sout_t=8'b10011001;
   3'h5: sout_t=8'b10010010;
   3'h6: sout_t=8'b10000011;
   3'h7: sout_t=8'b11111000;
	3'h8: sout_t=8'b10000000;
   3'h9: sout_t=8'b10011000;

	default: sout_t=8'b11111111;
  endcase
 assign y = sout_t;
endmodule