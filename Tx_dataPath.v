module data_path #(parameter parity_on=1, parameter data_size=8, sampling_cntr_width=4,parameter even_parity=1)(input clk,
input rst, //global ASYNCH rst (hard rst)
////// control signals from fsm ////////
input cntr_rst, //soft SYNCH rst
input [sampling_cntr_width-1 :0] sampling_end_val, // counter value at which a bit should be transmitted
input data_bits_incr, //to enable counter increment after each sample of data is taken 
input data_w_en, // to enable storing data to be transmitted 
input [1:0]select, 
input [data_size-1 : 0] Tx_input,
/////// fsm inputs //////////
output [sampling_cntr_width-1:0] sampling_cntr_out,
output [2: 0] bits_cntr_out,
output reg Tx_s
    );
	 
	 // to count till a specific number of clock cycles is reached to transmit a bit
	 counter #(.width(sampling_cntr_width)) sampling_cntr (
    .clk(clk), 
    .soft_rst(cntr_rst),
	.hard_rst(rst), 
    .end_val(sampling_end_val), 
    .cnt_out(sampling_cntr_out)
    );
	 
	 
	 // to keep track of data bits to be stored
	 manual_cntr #(.width(3)) data_bits_cntr (
    .clk(clk), 
    .soft_rst(cntr_rst),
	.hard_rst(rst), 
    .incr(data_bits_incr), 
    .cnt_out(bits_cntr_out)
    );
	 
	 // to store recieved data
	 wire [data_size-1 :0] Tx_out;
	 data_reg #(.width(data_size)) Tx_reg (
    .clk(clk), 
    .rst(rst), 
    .w_en(data_w_en), 
    .data_in(Tx_input), 
    .data_out(Tx_out)
    );

	//////////////////////////////////
	parameter [1:0] select_0='d0, select_1='d1, select_parity='d3,select_data='d2;
	wire parity; 
	
	always @(*)begin
		case(select)
			select_0:begin
				Tx_s='d0;
			end
			select_1:begin
				Tx_s='d1;
			end
			select_parity:begin
				Tx_s=parity;
			end
			select_data:begin
				Tx_s=Tx_out[bits_cntr_out];
			end
			default:begin
				Tx_s='d1;
			end
		endcase
	end

	////////////////////////////
	 generate 
	 if(parity_on) begin
		assign parity = even_parity? ^Tx_out : !(^Tx_out) ;
	 end
	 endgenerate
	 //////////////////////////

endmodule