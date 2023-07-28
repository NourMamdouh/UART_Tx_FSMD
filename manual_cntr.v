module manual_cntr #(parameter width =3)(input clk,
input hard_rst,
input soft_rst,
input incr,
output reg [width-1 :0] cnt_out
    );
	 
	 always @(posedge clk, posedge hard_rst) begin
		if(hard_rst)begin
			cnt_out <= 'd0;
		end
		else if(soft_rst)begin
			cnt_out <= 'd0;
		end
		else begin
			if(incr) begin
				cnt_out <= cnt_out +'d1 ;
			end
			else begin
				cnt_out <= cnt_out;
			end
		end
	 end

endmodule