module counter #(parameter width=4)(input clk,
input rst,
input [width-1 : 0] end_val,
output reg [width-1 : 0] cnt_out
    );
	 
	 always @(posedge clk, posedge rst) begin
		if(rst) begin
			cnt_out <= 0;
		end
		else begin
			if(cnt_out == end_val) begin
				cnt_out <= 0;
			end
			else begin
				cnt_out <= cnt_out + 1 ;
			end
		end
		
	 end

endmodule