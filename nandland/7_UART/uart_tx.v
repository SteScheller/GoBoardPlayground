`default_nettype none
module UART_Tx
#(
    parameter CLKS_PER_BIT = 217,
    parameter NUM_DATA_BITS = 8
)
(
    input i_clk,
    input i_txStart,
    input [NUM_DATA_BITS - 1: 0] i_txByte,
    input i_reset,
    output o_tx,
    output o_txActive,
    output o_txDoneStrobe,
    output o_errorFlag
);

    reg r_tx = 1'b1;
    reg r_txActive = 1'b1;
    reg r_txDoneStrobe = 1'b1;
    reg r_errorFlag = 1'b0;
    reg [3:0] r_bitIdx = 0;
    reg [15:0] r_clkCount = 0;

    always @(posedge i_clk, posedge i_reset)
    begin
        if (i_reset)
        begin
            
            r_errorFlag = 1'b0;
            r_txActive = 1'b0;
            r_txDoneStrobe = 1'b0;
            r_bitIdx = 0;
            r_clkCount = 0;
        end
        else
        begin
            r_txDoneStrobe <= i_txStart;
        end
    end

    assign o_tx = r_tx;
    assign o_txActive = r_txActive;
    assign o_txDoneStrobe = r_txDoneStrobe;
    assign o_errorFlag = r_errorFlag;

endmodule

