`default_nettype none
module UART_Rx
#(
    parameter CLKS_PER_BIT = 217,
    parameter NUM_DATA_BITS = 8
)
(
    input i_clk,
    input i_rx,
    output o_rxcFlag,
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
    reg r_rxcFlag = 0;
    reg r_bitIdx = 0;
    reg r_clkCount = 0;

    always @(posedge i_clk)
    begin
        case (r_smState)
            RESET:
            begin
                r_bitIdx <= 0;
                r_rxcFlag <= 0;
                r_clkCount <= 0;
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
                    r_clkCount <= r_clkCount + 1;
                else
                begin
                    if (i_rx == 1'b0)
                    begin
                        r_smState <= DATA_BITS;
                        r_clkCount <= 0;
                    end
                    else
                        r_smState <= RESET;
                end
            end

            DATA_BITS:
            begin
                if (r_clkCount < CLKS_PER_BIT - 1)
                    r_clkCount <= r_clkCount + 1;
                else
                begin
                    r_rxByte[r_bitIdx] <= i_rx;
                    r_clkCount <= 0;
                    r_bitIdx <= r_bitIdx + 1;
                    if (r_bitIdx == NUM_DATA_BITS - 1)
                        r_smState <= STOP_BIT;
                end
            end

            STOP_BIT:
            begin
                if (r_clkCount < CLKS_PER_BIT - 1)
                    r_clkCount <= r_clkCount + 1;
                else
                    if (i_rx == 1'b1)
                        r_rxcFlag <= 1;
                    r_smState <= RESET;
            end

            default:
                r_smState <= RESET;
            RESET:
            begin
                r_bitIdx <= 0;
                r_rxcFlag <= 0;
                r_clkCount <= 0;
                r_smState <= IDLE;
            end

        endcase
    end

    assign o_rxcFlag = r_rxcFlag;
    assign o_rxByte = r_rxByte;

endmodule

