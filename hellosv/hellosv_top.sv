`default_nettype none

module HELLOSV_TLM
(
    input i_clk,
    input i_sw1,
    input i_sw2,
    input i_sw3,
    input i_sw4,
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
    output o_seg2g

);

    bit r_sw1 = 1'b0;
    bit r_sw2 = 1'b0;
    bit r_sw3 = 1'b0;
    bit r_sw4 = 1'b0;
    wire w_sw1;
    wire w_sw2;
    wire w_sw3;
    wire w_sw4;

    // instantiate debounce modules
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

    // reset generation
    wire w_reset;
    Power_On_Reset por
    (
      .i_clk(i_clk),    
      .i_asyncReset(w_sw4),
      .o_syncReset(w_reset)
    );

    // edge detection
    byte r_count = 0;
    always_ff @(posedge i_clk, posedge w_reset)
    begin
        if (w_reset)
            r_count = 8'h42;
        else
        begin
            r_sw1 <= w_sw1;
            r_sw2 <= w_sw2;
            if (w_sw1 == 1'b0 && r_sw1 == 1'b1) r_count <= r_count + 1'b1;
            else if (w_sw2 == 1'b0 && r_sw2 == 1'b1) r_count <= r_count - 1'b1;
        end
    end

    // output count on seven segment display
    wire w_seg1a, w_seg1b, w_seg1c, w_seg1d, w_seg1e, w_seg1f, w_seg1g;
    wire w_seg2a, w_seg2b, w_seg2c, w_seg2d, w_seg2e, w_seg2f, w_seg2g;

    Seven_Segment_Decoder seg1
    (
        .i_value(r_count[7:4]),
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
        .i_value(r_count[3:0]),
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

    // set on board leds
    assign o_led1 = w_sw1;
    assign o_led2 = w_sw2;
    assign o_led3 = w_sw3;
    assign o_led4 = w_sw4;

endmodule

