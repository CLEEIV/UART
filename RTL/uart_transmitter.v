module uart_transmitter (
    input            clk         ,
    input            rst_n       ,
    input            receive_done,
    input      [7:0] data_receive,
    output reg       uart_txd     
);
// parameter //
parameter SYS_PERIOD      = 100_000_000;
parameter BPS             = 115_200;
parameter HALF_BIT_PERIOD = SYS_PERIOD/BPS/2;
// register defination //
reg [14:0] transmit_time_cnt;
reg        transmit_flag;
// wire defination //
wire [7:0] data_temp;
// data temp //
assign data_temp = receive_done ? data_receive : data_temp;
// transmit_time_cnt //
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        transmit_time_cnt <= 15'd0;
    else if (transmit_flag)
        transmit_time_cnt <= (transmit_time_cnt == (20*HALF_BIT_PERIOD)) ? 15'd0 : (transmit_time_cnt + 1'b1);
    else
        transmit_time_cnt <= 15'd0;
end
// transmit_flag //
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        transmit_flag <= 1'b0;
    else begin
        if (receive_done)
            transmit_flag <= 1'b1;
        else if (transmit_time_cnt == (20*HALF_BIT_PERIOD))
            transmit_flag <= 1'b0;
        else
            transmit_flag <= transmit_flag;
    end
end
// uart_txd //
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        uart_txd <= 1'b1;
    else if (transmit_flag) begin
        case (transmit_time_cnt)
            0*HALF_BIT_PERIOD  : uart_txd <= 1'b0        ;
            2*HALF_BIT_PERIOD  : uart_txd <= data_temp[0];
            4*HALF_BIT_PERIOD  : uart_txd <= data_temp[1];
            6*HALF_BIT_PERIOD  : uart_txd <= data_temp[2];
            8*HALF_BIT_PERIOD  : uart_txd <= data_temp[3];
            10*HALF_BIT_PERIOD : uart_txd <= data_temp[4];
            12*HALF_BIT_PERIOD : uart_txd <= data_temp[5];
            14*HALF_BIT_PERIOD : uart_txd <= data_temp[6];
            16*HALF_BIT_PERIOD : uart_txd <= data_temp[7];
            18*HALF_BIT_PERIOD : uart_txd <= 1'b1        ;
            default            : uart_txd <= uart_txd    ;
        endcase
    end
    else
        uart_txd <= uart_txd;
end

endmodule