`default_nettype none

module UART_TLM
(
    input i_clk,
    input i_uartRx,
    output o_uartTx,
    output o_seg1a,
    output o_seg1b,
    output o_seg1c,
    output o_seg1d,
    output o_seg1e,
    output o_seg1f,
    output o_seg1g,
    output o_seg2a,
    output o_seg2b,
    output o_seg2c,
    output o_seg2d,
    output o_seg2e,
    output o_seg2f,
    output o_seg2g

);

    wire w_seg1a;
    wire w_seg1b;
    wire w_seg1c;
    wire w_seg1d;
    wire w_seg1e;
    wire w_seg1f;
    wire w_seg1g;
    wire w_seg2a;
    wire w_seg2b;
    wire w_seg2c;
    wire w_seg2d;
    wire w_seg2e;
    wire w_seg2f;
    wire w_seg2g;

    wire w_rxStrobe;
    wire [7:0] w_rxByte;
    reg [7:0] r_rxByte = 8'h00;

    reg r_txStart = 1'b0;

    UART_Rx 
    #(
        .CLKS_PER_BIT(217),
        .NUM_DATA_BITS(8)
    ) UART_RX_INST
    (
        .i_clk(i_clk),
        .i_reset(1'b0),
        .i_rx(i_uartRx),
        .o_rxStrobe(w_rxStrobe),
        .o_errorFlag(),
        .o_rxByte(w_rxByte)
    );

    UART_Tx 
    #(
        .CLKS_PER_BIT(217),
        .NUM_DATA_BITS(8)
    ) UART_TX_INST
    (
        .i_clk(i_clk),
        .i_txStart(r_txStart),
        .i_txByte(r_rxByte),
        .i_reset(1'b0),
        .o_tx(o_uartTx),
        .o_txActive(),
        .o_txDoneStrobe(),
        .o_errorFlag()
    );

    always @(posedge i_clk)
    begin
        r_txStart <= 1'b0;
        if (w_rxStrobe == 1'b1)
        begin
            r_rxByte <= w_rxByte;
            r_txStart <= 1'b1;
        end
    end

    // instantiate seven segment display decoders
    Seven_Segment_Decoder seg1
    (
        .i_value(r_rxByte[7:4]),
        .i_clk(i_clk),
        .o_segA(w_seg1a),
        .o_segB(w_seg1b),
        .o_segC(w_seg1c),
        .o_segD(w_seg1d),
        .o_segE(w_seg1e),
        .o_segF(w_seg1f),
        .o_segG(w_seg1g)
    );
    Seven_Segment_Decoder seg2
    (
        .i_value(r_rxByte[3:0]),
        .i_clk(i_clk),
        .o_segA(w_seg2a),
        .o_segB(w_seg2b),
        .o_segC(w_seg2c),
        .o_segD(w_seg2d),
        .o_segE(w_seg2e),
        .o_segF(w_seg2f),
        .o_segG(w_seg2g)
    );

    assign o_seg1a = ~w_seg1a;
    assign o_seg1b = ~w_seg1b;
    assign o_seg1c = ~w_seg1c;
    assign o_seg1d = ~w_seg1d;
    assign o_seg1e = ~w_seg1e;
    assign o_seg1f = ~w_seg1f;
    assign o_seg1g = ~w_seg1g;

    assign o_seg2a = ~w_seg2a;
    assign o_seg2b = ~w_seg2b;
    assign o_seg2c = ~w_seg2c;
    assign o_seg2d = ~w_seg2d;
    assign o_seg2e = ~w_seg2e;
    assign o_seg2f = ~w_seg2f;
    assign o_seg2g = ~w_seg2g;

endmodule

