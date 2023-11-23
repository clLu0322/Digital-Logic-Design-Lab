module adder(A, B, C, D, S1, S0,clk);

input clk;
input [2:0]A, B, C, D;
output reg[2:0]S1, S0;
wire [4:0]S;

assign S = A + B + C + D;

always@(posedge clk)
begin
  S0 <= S % 10;
  S1 <= S / 10;

end

endmodule
