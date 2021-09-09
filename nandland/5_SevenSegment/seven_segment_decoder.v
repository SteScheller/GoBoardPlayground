module Seven_Segment_Decoder
(
    input [3:0] i_value,
    input i_clk,
    output o_segA,
    output o_segB,
    output o_segC,
    output o_segD,
    output o_segE,
    output o_segF,
    output o_segG
);

    reg [6:0] r_segments = 7'b0000000;

    always @(posedge i_clk)
    begin
        case (i_value)
            4'h0 : r_segments <= 7'b011_1111;
            4'h1 : r_segments <= 7'b000_0110;
            4'h2 : r_segments <= 7'b101_1011;
            4'h3 : r_segments <= 7'b100_1111;
            4'h4 : r_segments <= 7'b110_0110;
            4'h5 : r_segments <= 7'b110_1101;
            4'h6 : r_segments <= 7'b111_1101;
            4'h7 : r_segments <= 7'b000_0111;
            4'h8 : r_segments <= 7'b111_1111;
            4'h9 : r_segments <= 7'b110_1111;
            4'hA : r_segments <= 7'b111_0111;
            4'hB : r_segments <= 7'b111_1100;
            4'hC : r_segments <= 7'b011_1001;
            4'hD : r_segments <= 7'b101_1110;
            4'hE : r_segments <= 7'b111_1001;
            4'hF : r_segments <= 7'b111_0001;
        endcase
    end

    assign o_segA = r_segments[0];
    assign o_segB = r_segments[1];
    assign o_segC = r_segments[2];
    assign o_segD = r_segments[3];
    assign o_segE = r_segments[4];
    assign o_segF = r_segments[5];
    assign o_segG = r_segments[6];

endmodule
