module CNT6_EN(en, clk, Q);

input en, clk;
output reg [2:0]Q;

always@(posedge clk )begin

  if(en == 0 && Q < 3'b110)
	  Q <= Q + 1'b1; 
	  
  else if(en == 0)
     Q <= 3'b001;
  
  else if(en==1)
     Q <= Q;
  
  
  
	  
end

initial begin
Q = 3'b001;end


endmodule



