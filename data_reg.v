module data_reg #(parameter width=8)(input clk,
input rst,
input w_en,
input [width-1 : 0] data_in,
output reg [width-1 : 0] data_out
    );
	 
	always @(posedge clk, posedge rst)begin
		if(rst) begin
			data_out <= 0;
		end 
		else begin
			if(w_en)begin
				data_out <= data_in;
			end
			else begin
				data_out <= data_out;
			end	
		end
	end


endmodule