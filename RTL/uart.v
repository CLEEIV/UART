module uart (
    input  clk     ,
    input  rst_n   ,
    input  uart_rxd,
    output uart_txd 
);
// parameter //
parameter SYS_PERIOD      = 100_000_000;
parameter BPS             = 115_200;
parameter HALF_BIT_PERIOD = SYS_PERIOD/BPS/2;
// wire defination //
wire       receive_done;
wire [7:0] data_receive;
// module //
uart_receiver #(
    .SYS_PERIOD      ( SYS_PERIOD      ),
    .BPS             ( BPS             ),
    .HALF_BIT_PERIOD ( HALF_BIT_PERIOD ) 
) uart_receiver (
    .clk          ( clk          ),
    .rst_n        ( rst_n        ),
    .uart_rxd     ( uart_rxd     ),
    .receive_done ( receive_done ),
    .data_receive ( data_receive ) 
);
uart_transmitter #(
    .SYS_PERIOD      ( SYS_PERIOD      ),
    .BPS             ( BPS             ),
    .HALF_BIT_PERIOD ( HALF_BIT_PERIOD ) 
) uart_transmitter (
    .clk          ( clk          ),
    .rst_n        ( rst_n        ),
    .receive_done ( receive_done ),
    .data_receive ( data_receive ),
    .uart_txd     ( uart_txd     ) 
);
endmodule
