module CNT6(en, clk, out);

input en, clk;
output reg [2:0]out;

always@(posedge clk)begin

  if(en == 1)begin //enable = 1
  
     if(out < 3'b110)// max = 6
	  
       begin out = out + 1;end
		 
	  else
	  
	    begin out = 0; end
		 
  end else 
  
     begin out = out;end
	  
end

initial begin

 out = 3'b001; // min = 1
 
 end
endmodule