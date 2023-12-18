module uart_receiver (
    input            clk         ,
    input            rst_n       ,
    input            uart_rxd    ,
    output           receive_done,
    output reg [7:0] data_receive 
);
// parameter //
parameter SYS_PERIOD      = 100_000_000;
parameter BPS             = 115_200;
parameter HALF_BIT_PERIOD = SYS_PERIOD/BPS/2;
// register defination //
reg [14:0] receive_time_cnt;
reg        uart_rxd_delay1;
reg        uart_rxd_delay2;
reg        start_flag;
reg        receive_flag;
// receive_done //
assign receive_done = (receive_time_cnt == 20*HALF_BIT_PERIOD);
// clk delay for 2 periods, to check the coming of uart_rxd is negedge
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        uart_rxd_delay1 <= 1'b0;
        uart_rxd_delay2 <= 1'b0;
    end
    else begin
        uart_rxd_delay1 <= uart_rxd;
        uart_rxd_delay2 <= uart_rxd_delay1;
    end
    start_flag <= (~uart_rxd) & uart_rxd_delay2;
end
// receive_time_cnt //
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        receive_time_cnt <= 15'd0;
    else if (receive_flag)
        receive_time_cnt <= (receive_time_cnt == 20*HALF_BIT_PERIOD) ? 15'd0 : (receive_time_cnt + 1'b1);
    else
        receive_time_cnt <= 15'd0;
end
// receive_flag //
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        receive_flag <= 1'b0;
    else begin
        if (start_flag)
            receive_flag <= 1'b1;
        else if ((receive_time_cnt == 20*HALF_BIT_PERIOD) && (uart_rxd == 1'b1))
            receive_flag <= 1'b0;
        else
            receive_flag <= receive_flag;
    end
end
// data_receive //
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        data_receive <= 8'd0;
    else if (receive_flag) begin
        case (receive_time_cnt)
            3*HALF_BIT_PERIOD  : data_receive[0] <= uart_rxd    ;
            5*HALF_BIT_PERIOD  : data_receive[1] <= uart_rxd    ;
            7*HALF_BIT_PERIOD  : data_receive[2] <= uart_rxd    ;
            9*HALF_BIT_PERIOD  : data_receive[3] <= uart_rxd    ;
            11*HALF_BIT_PERIOD : data_receive[4] <= uart_rxd    ;
            13*HALF_BIT_PERIOD : data_receive[5] <= uart_rxd    ;
            15*HALF_BIT_PERIOD : data_receive[6] <= uart_rxd    ;
            17*HALF_BIT_PERIOD : data_receive[7] <= uart_rxd    ;
            default            : data_receive    <= data_receive;
        endcase
    end
    else
        data_receive <= data_receive;
end

endmodule