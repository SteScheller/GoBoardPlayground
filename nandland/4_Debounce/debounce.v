module Debounce_Project_Top
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

    reg r_led1 = 1'b0;
    reg r_led2 = 1'b0;
    reg r_led3 = 1'b0;
    reg r_led4 = 1'b0;
    reg r_sw1 = 1'b0;
    reg r_sw2 = 1'b0;
    reg r_sw3 = 1'b0;
    reg r_sw4 = 1'b0;
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

    // toggle leds when according switch is released
    always @(posedge i_clk)
    begin
        r_sw1 <= w_sw1;
        r_sw2 <= w_sw2;
        r_sw3 <= w_sw3;
        r_sw4 <= w_sw4;

        if (w_sw1 == 1'b0 && r_sw1 == 1'b1)
        begin
            r_led1 <= ~r_led1;
        end

        if (w_sw2 == 1'b0 && r_sw2 == 1'b1)
        begin
            r_led2 <= ~r_led2;
        end

        if (w_sw3 == 1'b0 && r_sw3 == 1'b1)
        begin
            r_led3 <= ~r_led3;
        end

        if (w_sw4 == 1'b0 && r_sw4 == 1'b1)
        begin
            r_led4 <= ~r_led4;
        end
    end

    assign o_led1 = r_led1;
    assign o_led2 = r_led2;
    assign o_led3 = r_led3;
    assign o_led4 = r_led4;

    assign o_seg1a = 1'b1;
    assign o_seg1b = 1'b0;
    assign o_seg1c = 1'b0;
    assign o_seg1d = 1'b1;
    assign o_seg1e = 1'b1;
    assign o_seg1f = 1'b0;
    assign o_seg1g = 1'b0;

    assign o_seg2a = 1'b0;
    assign o_seg2b = 1'b0;
    assign o_seg2c = 1'b1;
    assign o_seg2d = 1'b0;
    assign o_seg2e = 1'b0;
    assign o_seg2f = 1'b1;
    assign o_seg2g = 1'b0;

endmodule

