module manual_cntr #(parameter width =3)(input clk,
input rst,
input incr,
output reg [width-1 :0] cnt_out
    );
	 
	 always @(posedge clk, posedge rst) begin
		if(rst)begin
			cnt_out <= 0;
		end
		else begin
			if(incr) begin
				cnt_out <= cnt_out +1 ;
			end
			else begin
				cnt_out <= cnt_out;
			end
		end
	 end

endmodule