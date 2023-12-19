module uart_tb ();
// parameter //
parameter CLK_PERIOD = 10;
// register defination //
reg sys_clk  ;
reg sys_rst_n;
reg uart_rxd ;
// wire defination //
wire uart_txd;
// sim //
// tx 8'h55 : 8'b01010101
initial begin
    sys_clk   <= 1'b0;
    sys_rst_n <= 1'b0;
    uart_rxd  <= 1'b1;
    #200;
    sys_rst_n <= ~sys_rst_n;
    #1000;
    uart_rxd <= 1'b0; // start
    #8680;
    uart_rxd <= 1'b1; // D0
    #8680;
    uart_rxd <= 1'b0; // D1
    #8680;
    uart_rxd <= 1'b1; // D2
    #8680;
    uart_rxd <= 1'b0; // D3
    #8680;
    uart_rxd <= 1'b1; // D4
    #8680;
    uart_rxd <= 1'b0; // D5
    #8680;
    uart_rxd <= 1'b1; // D6
    #8680;
    uart_rxd <= 1'b0; // D7
    #8680;
    uart_rxd <= 1'b1; // stop
    #8680;
    uart_rxd <= 1'b1; // unable
    #300000;
    $finish;
end
always #(CLK_PERIOD/2) sys_clk = ~sys_clk;
// module //
uart uart (
    .sys_clk   ( sys_clk   ),
    .sys_rst_n ( sys_rst_n ),
    .uart_rxd  ( uart_rxd  ),
    .uart_txd  ( uart_txd  ) 
);

endmodule
