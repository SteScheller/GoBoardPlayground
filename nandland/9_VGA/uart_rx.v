`default_nettype none
module UART_Rx
#(
    parameter CLKS_PER_BIT = 217,
    parameter NUM_DATA_BITS = 8
)
(
    input i_clk,
    input i_rx,
    input i_reset,
    output o_rxStrobe,
    output o_errorFlag,
    output [NUM_DATA_BITS - 1:0] o_rxByte
);

    // states
    parameter IDLE = 3'h0;
    parameter START_BIT = 3'h1;
    parameter DATA_BITS = 3'h2;
    parameter STOP_BIT = 3'h3;
    parameter RESET = 3'h4;

    reg [NUM_DATA_BITS - 1:0] r_rxByte = 0;
    reg [2:0] r_smState = RESET;
    reg r_rxStrobe = 0;
    reg r_errorFlag = 0;
    reg [3:0] r_bitIdx = 0;
    reg [15:0] r_clkCount = 0;
    reg [15:0] r_sampleCount = CLKS_PER_BIT >> 1;

    always @(posedge i_clk, posedge i_reset)
    if (i_reset)
    begin
        r_rxStrobe <= 0;
        r_errorFlag <= 0;
        r_rxByte <= 0;
        r_smState <= RESET;
        r_bitIdx <= 0;
        r_clkCount <= 0;
    end
    else
    begin
        r_rxStrobe <= 0;
        case (r_smState)
            RESET:
            begin
                r_clkCount <= 0;
                r_bitIdx <= 0;
                r_smState <= IDLE;
            end


            IDLE:
            begin
                if (i_rx == 1'b0)
                    r_smState <= START_BIT;
            end

            START_BIT:
            begin
                if (r_clkCount < CLKS_PER_BIT - 1)
                begin
                    r_clkCount <= r_clkCount + 1;
                    // check if start bit is still low
                    if ((r_clkCount == r_sampleCount) && (i_rx != 1'b0))
                    begin
                        r_smState <= IDLE;
                        r_clkCount <= 0;
                    end
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
                    if (r_clkCount == r_sampleCount)
                        r_rxByte[r_bitIdx] <= i_rx;
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
                    // check for correct stop bit
                    if ((r_clkCount == r_sampleCount) && (i_rx != 1'b1))
                        r_errorFlag <= 1;
                end
                else
                begin
                    if (!r_errorFlag)
                        r_rxStrobe <= 1;
                    r_smState <= RESET;
                end
            end

            default:
            begin
                r_smState <= RESET;
                r_errorFlag <= 1;
            end
                

        endcase
    end

    assign o_rxStrobe = r_rxStrobe;
    assign o_errorFlag = r_errorFlag;
    assign o_rxByte = r_rxByte;

endmodule

