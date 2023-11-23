module CNT_dn(en, clk, out);

input en, clk;
output reg [3:0]out;

always@(posedge clk)begin

  if(en == 1)begin //enable = 1
  
     if(out > 4'b0)
	  
       begin out = out - 1;end
		 
	  else
	  
	    begin out = 9; end
		 
  end else 
  
     begin out = out;end
	  
end

initial begin

 out = 4'b1001; 
 
 end
endmodule