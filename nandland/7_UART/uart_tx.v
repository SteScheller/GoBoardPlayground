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
    // states
    parameter IDLE = 3'h0;
    parameter START_BIT = 3'h1;
    parameter DATA_BITS = 3'h2;
    parameter STOP_BIT = 3'h3;
    parameter RESET = 3'h4;

    reg r_tx = 1'b1;
    reg r_txActive = 1'b0;
    reg r_txDoneStrobe = 1'b0;
    reg r_errorFlag = 1'b0;
    reg [2:0] r_smState = RESET;
    reg [3:0] r_bitIdx = 0;
    reg [15:0] r_clkCount = 0;

    always @(posedge i_clk, posedge i_reset)
    if (i_reset)
    begin
        
        r_errorFlag <= 1'b0;
        r_tx <= 1'b1;
        r_txActive <= 1'b0;
        r_txDoneStrobe <= 1'b0;
        r_bitIdx <= 0;
        r_clkCount <= 0;
    end
    else
    begin
        r_txDoneStrobe <= 0;
        case (r_smState)
            RESET:
            begin
                r_clkCount <= 0;
                r_bitIdx <= 0;
                r_smState <= IDLE;
                r_txActive <= 1'b0;
            end


            IDLE:
            begin
                if (i_txStart == 1'b1)
                begin
                    r_smState <= START_BIT;
                    r_txActive <= 1'b1;
                end
            end

            START_BIT:
            begin
                if (r_clkCount < CLKS_PER_BIT - 1)
                begin
                    r_clkCount <= r_clkCount + 1;
                    r_tx <= 1'b0;
                end
                else
                begin
                    r_smState <= DATA_BITS;
                    r_clkCount <= 0;
                end
            end

            DATA_BITS:
            begin
                if (r_clkCount < CLKS_PER_BIT - 1)
                begin
                    r_clkCount <= r_clkCount + 1;
                    r_tx <= i_txByte[r_bitIdx];
                end
                else
                begin
                    r_clkCount <= 0;
                    r_bitIdx <= r_bitIdx + 1;
                    if (r_bitIdx == NUM_DATA_BITS - 1)
                        r_smState <= STOP_BIT;
                end
            end

            STOP_BIT:
            begin
                if (r_clkCount < CLKS_PER_BIT - 1)
                begin
                    r_clkCount <= r_clkCount + 1;
                    r_tx <= 1'b1;
                end
                else
                begin
                    r_txDoneStrobe <= 1'b1;
                    r_txActive <= 1'b0;
                    r_smState <= RESET;
                    r_clkCount <= 0;
                end
            end

            default:
            begin
                r_smState <= RESET;
                r_errorFlag <= 1;
            end

        endcase
    end

    assign o_tx = r_tx;
    assign o_txActive = r_txActive;
    assign o_txDoneStrobe = r_txDoneStrobe;
    assign o_errorFlag = r_errorFlag;

endmodule

