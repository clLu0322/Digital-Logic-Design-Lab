module btn_cnt(btn,clk,btn_out);
input clk,btn;
output reg btn_out;
reg state=0;
reg [2:0]btncnt;

localparam
  s0 = 0,
  s1 = 1;
always@(posedge clk)
  case(state)
    s0: begin
	  btncnt <= 0; btn_out <= 0;
	  if(btn == 0) state <= s1;
	  end
	 s1: if(btn==0)
	      if(btncnt>=6)begin
			
			state <= s0; btn_out <=1;
			
			end
			else btncnt <= btncnt + 1;
		  else btncnt<=0;
	 endcase
endmodule