`timescale 1ns/10ps

module uart_tb ();
// parameter //
parameter T               = 20;                  // a FPGA clock period
parameter SYS_PERIOD      = 100_000_000;         // system clock frequency
parameter BPS 		      = 115_200;             // uart transmition velocity
parameter HALF_BIT_PERIOD = SYS_PERIOD/BPS/2*T;
// register defination //
reg         clk     ;
reg         rst_n   ;
reg         uart_rxd;
// wire defination //
wire        uart_txd;
//  //
integer i;
// simulation //
initial begin
    for(i=0; i<=60000; i=i+1) begin
        #10 clk = ~clk;
    end
end
initial begin
    clk          = 1'b0;
    rst_n        = 1'b0;
    #(T*3) rst_n = 1'b1;
end
initial begin
    uart_rxd = 1'b1; 
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1;
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b0; //start
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1; //bit 0
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b0; //bit 1
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b0; //bit 2
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b0; //bit 3
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b0; //bit 4
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b0; //bit 5
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1; //bit 6
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b0; //bit 7
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1; //over
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1;
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1;
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1;
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1;
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1;
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1;
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b0; //start
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1; //bit 0
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1; //bit 1
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1; //bit 2
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1; //bit 3
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b0; //bit 4
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b0; //bit 5
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b0; //bit 6
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b0; //bit 7
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1; //over
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1;
    #(HALF_BIT_PERIOD*2) uart_rxd = 1'b1;
end
uart uart(
    .clk      ( clk      ),
    .rst_n    ( rst_n    ),
    .uart_rxd ( uart_rxd ),
    .uart_txd ( uart_txd ) 
);
endmodule
