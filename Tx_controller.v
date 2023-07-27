module controller_fsm #(parameter parity_on=1, parameter data_size=8, parameter sampling_cntr_width=4,
parameter no_of_clks=16)(
input clk,
input rst, //global rst (hard rst)
input Tx_on,
input [sampling_cntr_width-1:0] sampling_cntr_out,
input [2 : 0] bits_cntr_out,
output reg cntr_rst,
output reg [sampling_cntr_width-1 :0] sampling_end_val,
output reg data_bits_incr,
output reg data_w_en,
output reg [1:0]select, //to choose which bit to be transmitted
output reg busy, // to indicatie whether a transmission process is in progress or not
output reg data_seen // to indicate whether the data at the input port coild be seen by the uart or not
    );
	 
	 ///////////////////// state parameters ////////////////////////

	 parameter state_reg_width= parity_on?'d3:'d2;
	 
	 parameter [state_reg_width-1 : 0] idle='d0, start='d1, data_trans='d2, parity_trans='d4,stop='d3;
	 reg [state_reg_width-1 : 0] next_state, state ;
	 
	 parameter [1:0] select_0='d0, select_1='d1, select_parity='d3,select_data='d2;
	
   //////////////////////// state register /////////////////
	always @(posedge clk, posedge rst) begin
		if(rst) begin
			state <= idle;
		end
		else begin
			state <= next_state;
		end
	end
	
	///////////////////// nextt state and output logic ////////////////////
	always @(*)begin
		cntr_rst='d0;
		sampling_end_val='d0;
		data_bits_incr='d0;
		data_w_en='d1;
		select=select_1;
		busy='d0;
		data_seen='d0;
		next_state =idle;
		
		if(state==idle)begin
			cntr_rst = 'd1;
			select=select_1;
			data_w_en='d0;
			data_seen='d0;
			if(Tx_on=='d1)begin
				next_state = start;
			end
			else begin
				next_state = idle;
			end
		end
		
		if(state == start)begin
			sampling_end_val = no_of_clks-'d1;
			select=select_0;
			busy='d1;
			data_seen='d1;
			data_w_en='d1;
			if(sampling_cntr_out == sampling_end_val) begin
				next_state = data_trans;
			end
			else begin
				next_state = start;
			end		
		end
		
		if(state == data_trans) begin
			sampling_end_val =no_of_clks-'d1;
			data_w_en='d0;
			select=select_data;
			busy='d1;
			data_seen='d0;
			if(sampling_cntr_out == sampling_end_val) begin
				data_bits_incr ='d1;
				if(bits_cntr_out == data_size-'d1) begin
					if(parity_on) next_state=parity_trans; else next_state=stop;
				end
				else begin
					next_state=data_trans;
				end
			end
			else begin
				next_state=data_trans;
				data_bits_incr='d0;
			end
		end
		
		if(state == stop)begin
			sampling_end_val=no_of_clks-'d1;			
			data_w_en='d0;
			select=select_1;
			busy='d1;
			data_seen='d0;
			if(sampling_cntr_out ==sampling_end_val) begin
				if(Tx_on) next_state = start; else next_state=idle;
			end
			else begin
				next_state = stop;
			end
		end
		
		if(parity_on)begin
			if(state == parity_trans)begin
			sampling_end_val=no_of_clks-'d1;			
			data_w_en='d0;
			select=select_parity;
			data_seen='d0;
			busy='d1;
			if(sampling_cntr_out ==sampling_end_val) begin
					next_state = stop;
				end
				else begin
					next_state = parity_trans;
				end
			end	
		end
		
		
	end


endmodule