`default_nettype none

module VGA_TLM
(
    input i_clk,
    input i_sw1,
    input i_sw2,
    input i_sw3,
    input i_sw4,
    input i_uartRx,
    output o_uartTx,
    output o_led1,
    output o_led2,
    output o_led3,
    output o_led4,
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
    output o_seg2g,
    output o_vgaHSync,
    output o_vgaVSync,
    output o_vgaR0,
    output o_vgaR1,
    output o_vgaR2,
    output o_vgaG0,
    output o_vgaG1,
    output o_vgaG2,
    output o_vgaB0,
    output o_vgaB1,
    output o_vgaB2
);
    // get button inputs
    wire w_sw1, w_sw2, w_sw3, w_sw4;
    reg r_sw1 = 1'b0;
    reg r_sw2 = 1'b0;
    reg r_sw3 = 1'b0;
    reg r_sw4 = 1'b0;
    Debounce_Switch debounce_sw1
    (
        .i_clk(i_clk),
        .i_sw(i_sw1),
        .o_sw(w_sw1)
    );
    Debounce_Switch debounce_sw2
    (
        .i_clk(i_clk),
        .i_sw(i_sw2),
        .o_sw(w_sw2)
    );
    Debounce_Switch debounce_sw3
    (
        .i_clk(i_clk),
        .i_sw(i_sw3),
        .o_sw(w_sw3)
    );
    Debounce_Switch debounce_sw4
    (
        .i_clk(i_clk),
        .i_sw(i_sw4),
        .o_sw(w_sw4)
    );

    // edge detection
    reg [7:0] r_pattern = 0;
    always @(posedge i_clk)
    begin
        r_sw1 <= w_sw1;
        r_sw2 <= w_sw2;
        r_sw3 <= w_sw3;
        if (w_sw4 == 1'b1 && r_sw4 == 1'b0) r_pattern = 8'h0;
        else if (w_sw1 == 1'b0 && r_sw1 == 1'b1) r_pattern = 8'h1;
        else if (w_sw2 == 1'b0 && r_sw2 == 1'b1) r_pattern = 8'h2;
        else if (w_sw3 == 1'b0 && r_sw3 == 1'b1) r_pattern = 8'h3;
    end

    // reset generation
    wire w_por, w_reset;
    Power_On_Reset por
    (
      .i_clk(i_clk),    
      .i_asyncReset(1'b1),
      .o_syncReset(w_por)
    );

    assign w_reset = w_por | w_sw4;

    // uart loopback
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
        .i_reset(w_reset),
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
        .i_reset(w_reset),
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


    // instantiate vga sync generator
    wire w_hs, w_vs;
    wire w_activeArea;
    wire [9:0] w_px;
    wire [9:0] w_py;

    VGA_HS_VS vgaHsVs
    (
        .i_clk(i_clk),
        .i_reset(w_reset),
        .o_hs(w_hs),
        .o_vs(w_vs),
        .o_activeArea(w_activeArea),
        .o_px(w_px),
        .o_py(w_py)
    );

    assign o_vgaHSync = w_hs;
    assign o_vgaVSync = w_vs;
    
    // generate test patterns
    wire [2:0] w_redChess;
    wire [2:0] w_greenChess;
    wire [2:0] w_blueChess;
    wire [2:0] w_redRgb;
    wire [2:0] w_greenRgb;
    wire [2:0] w_blueRgb;
    wire [2:0] w_redPsych;
    wire [2:0] w_greenPsych;
    wire [2:0] w_bluePsych;
    reg [2:0] r_red = 0;
    reg [2:0] r_green = 0;
    reg [2:0] r_blue = 0;
    VGA_CHESS_PATTERN chessPattern
    (
        .i_clk(i_clk),
        .i_reset(w_reset),
        .i_px(w_px),
        .i_py(w_py),
        .o_red(w_redChess),
        .o_green(w_greenChess),
        .o_blue(w_blueChess)
    );

    VGA_RGB_PATTERN rgbPattern
    (
        .i_clk(i_clk),
        .i_reset(w_reset),
        .i_px(w_px),
        .i_py(w_py),
        .o_red(w_redRgb),
        .o_green(w_greenRgb),
        .o_blue(w_blueRgb)
    );

    VGA_PSYCHEDELIC_PATTERN psychPattern
    (
        .i_clk(i_clk),
        .i_reset(w_reset),
        .i_px(w_px),
        .i_py(w_py),
        .o_red(w_redPsych),
        .o_green(w_greenPsych),
        .o_blue(w_bluePsych)
    );

    always @(posedge i_clk)
    begin
        if (w_activeArea == 1'b1)
        begin
            case (r_pattern)
                8'h1:
                begin
                    r_red <= w_redChess;
                    r_green <= w_greenChess;
                    r_blue <= w_blueChess;
                end

                8'h2:
                begin
                    r_red <= w_redRgb;
                    r_green <= w_greenRgb;
                    r_blue <= w_blueRgb;
                end

                8'h3:
                begin
                    r_red <= w_redPsych;
                    r_green <= w_greenPsych;
                    r_blue <= w_bluePsych;
                end

                default:
                begin
                    r_red <= 3'b0;
                    r_green <= 3'b0;
                    r_blue <= 3'b0;
                end
            endcase
        end
        else
        begin
            r_red <= 3'b0;
            r_green <= 3'b0;
            r_blue <= 3'b0;
        end
    end
    
    assign o_vgaR0 = r_red[0];
    assign o_vgaR1 = r_red[1];
    assign o_vgaR2 = r_red[2];
    assign o_vgaG0 = r_green[0];
    assign o_vgaG1 = r_green[1];
    assign o_vgaG2 = r_green[2];
    assign o_vgaB0 = r_blue[0];
    assign o_vgaB1 = r_blue[1];
    assign o_vgaB2 = r_blue[2];

    // output testpattern number via seven segments and leds
    wire w_seg1a, w_seg1b, w_seg1c, w_seg1d, w_seg1e, w_seg1f, w_seg1g;
    wire w_seg2a, w_seg2b, w_seg2c, w_seg2d, w_seg2e, w_seg2f, w_seg2g;

    Seven_Segment_Decoder seg1
    (
        .i_value(r_pattern[7:4]),
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
        .i_value(r_pattern[3:0]),
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

    always @(posedge i_clk)
    begin
        o_led4 <= 1'b0;
        case (r_pattern)
            8'h1:
            begin
                o_led1 <= 1'b1;
                o_led2 <= 1'b0;
                o_led3 <= 1'b0;
            end

            8'h2:
            begin
                o_led1 <= 1'b0;
                o_led2 <= 1'b1;
                o_led3 <= 1'b0;
            end

            8'h3:
            begin
                o_led1 <= 1'b0;
                o_led2 <= 1'b0;
                o_led3 <= 1'b1;
            end

            default:
            begin
                o_led1 <= 1'b0;
                o_led2 <= 1'b0;
                o_led3 <= 1'b0;
            end
        endcase
    end

endmodule

