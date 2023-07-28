module counter #(parameter width=4)(input clk,
input soft_rst,
input hard_rst,
input [width-1 : 0] end_val,
output reg [width-1 : 0] cnt_out
    );
	 
	 always @(posedge clk, posedge hard_rst) begin
		if(hard_rst) begin
			cnt_out <= 'd0;
		end
		else if(soft_rst)begin
			cnt_out <= 'd0;
		end
		else begin
			if(cnt_out == end_val) begin
				cnt_out <= 'd0;
			end
			else begin
				cnt_out <= cnt_out + 'd1 ;
			end
		end
		
	 end

endmodule