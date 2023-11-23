module clr_cnt(clr,clk,clr_out);
input clk,clr;
output reg clr_out;
reg state=0;
reg [2:0]clrcnt;

localparam
  s0 = 0,
  s1 = 1;
always@(posedge clk)
  case(state)
    s0: begin
	  clrcnt <= 0; clr_out <= 1;
	  if(clr == 0) state <= s1;
	  end
	 s1: if(clr==0)
	      if(clrcnt==4)begin
			state <= s0; clr_out <=0;
			end
			else clrcnt <= clrcnt + 1;
		  else clrcnt<=0;
	 endcase
endmodule