module Seven_Segment_Project_Top
(
    input i_clk,
    input i_sw1,
    input i_sw3,
    input i_sw4,
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

    reg r_sw1 = 1'b0;
    reg r_sw3 = 1'b0;
    reg r_sw4 = 1'b0;
    reg [7:0] r_count = 8'h0;
    wire w_sw1;
    wire w_sw3;
    wire w_sw4;
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

    // instantiate debounce modules
    Debounce_Switch debounce_sw1
    (
        .i_clk(i_clk),
        .i_sw(i_sw1),
        .o_sw(w_sw1)
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

    // instantiate seven segment display decoders
    Seven_Segment_Decoder seg1
    (
        .i_value(r_count[7:4]),
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
        .i_value(r_count[3:0]),
        .i_clk(i_clk),
        .o_segA(w_seg2a),
        .o_segB(w_seg2b),
        .o_segC(w_seg2c),
        .o_segD(w_seg2d),
        .o_segE(w_seg2e),
        .o_segF(w_seg2f),
        .o_segG(w_seg2g)
    );

    // increment, decrement or reset switch
    always @(posedge i_clk)
    begin
        r_sw1 <= w_sw1;
        r_sw3 <= w_sw3;
        r_sw4 <= w_sw4;
        if (w_sw1 == 1'b0 && r_sw1 == 1'b1) r_count = 8'h0;
        else if (w_sw3 == 1'b0 && r_sw3 == 1'b1) r_count = r_count + 1;
        else if (w_sw4 == 1'b0 && r_sw4 == 1'b1) r_count = r_count - 1;
    end

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

