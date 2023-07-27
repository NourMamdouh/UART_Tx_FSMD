module UART_Tx_top #(parameter parity_on=1, parameter data_size=8, parameter sampling_cntr_width=4,parameter even_parity=1,
parameter no_of_clks=16,parameter BAUD_RATE=1000/*in kbits/s*/,parameter SYS_CLK_FREQ=BAUD_RATE*no_of_clks )(input clk,
input rst, //global ASYNCH rst
input Tx_on,
input [data_size-1 : 0] Tx_input,
output Tx_s,
output busy,
output data_seen // to indicate whether the data at the input port coild be seen by the uart or not
    );
	 
	 wire cntr_rst,data_bits_incr,data_w_en;
	 wire [1:0] select;
	 wire [sampling_cntr_width-1:0] sampling_end_val, sampling_cntr_out;
	 wire [2:0] bits_cntr_out;
	 
	 data_path #(.parity_on(parity_on),.data_size(data_size),.sampling_cntr_width(sampling_cntr_width),.even_parity(even_parity))Tx_data_path (
    .clk(clk), 
    .rst(rst), 
    .cntr_rst(cntr_rst), 
    .sampling_end_val(sampling_end_val), 
    .data_bits_incr(data_bits_incr), 
    .data_w_en(data_w_en), 
    .select(select), 
    .Tx_input(Tx_input), 
    .sampling_cntr_out(sampling_cntr_out), 
    .bits_cntr_out(bits_cntr_out), 
    .Tx_s(Tx_s)
    );
	 
	 controller_fsm #(.parity_on(parity_on),.data_size(data_size),.sampling_cntr_width(sampling_cntr_width),.no_of_clks(no_of_clks))Tx_controller (
    .clk(clk), 
    .rst(rst), 
    .Tx_on(Tx_on), 
    .sampling_cntr_out(sampling_cntr_out), 
    .bits_cntr_out(bits_cntr_out), 
    .cntr_rst(cntr_rst), 
    .sampling_end_val(sampling_end_val), 
    .data_bits_incr(data_bits_incr), 
    .data_w_en(data_w_en), 
    .select(select), 
    .busy(busy), 
    .data_seen(data_seen)
    );

endmodule