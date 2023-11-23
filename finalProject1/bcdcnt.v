module bcdcnt(inc, dec, clr, clk, bcd0, bcd1);
  input inc,dec,clk,clr;
  output [3:0] bcd0,bcd1;
  reg [3:0] tmp0,tmp1;
  
  always@(posedge clk)
  begin
    if(clr == 0)begin
	   tmp0 <= 4'h0; tmp1 <= 4'h0;
		end
	 else if(inc == 1)begin
	   if(tmp0 < 9)
		  tmp0 <= tmp0 + 1;
		else if (tmp1 < 9)begin
		  tmp1 <= tmp1 +1;
		  tmp0 <= 0;
		  end
	 end
	 else if (dec == 1)begin
	   if(tmp0 > 0)
		  tmp0 <= tmp0 - 1;
		else if (tmp1 > 0)begin
		  tmp1 <= tmp1 -1;
		  tmp0 <= 9;
		  end
	 end
	 
  end
  assign bcd0 = tmp0;
  assign bcd1 = tmp1;
endmodule