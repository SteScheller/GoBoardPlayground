`timescale 100ns/1ns
`default_nettype none

module VGA_HS_VS_TB ();

    // Testbench uses a 25 MHz clock (same as Go Board)
    parameter c_CLOCK_PERIOD_100NS = 0.4;
    reg r_clk = 0;
    always #(c_CLOCK_PERIOD_100NS/2) r_clk <= !r_clk;

    // instantiate vga sync generator
    wire w_hs;
    wire w_vs;
    wire w_activeArea;
    wire [9:0] w_px;
    wire [9:0] w_py;

    VGA_HS_VS vgaHsVs
    (
        .i_clk(r_clk),
        .i_reset(1'b0),
        .o_hs(w_hs),
        .o_vs(w_vs),
        .o_activeArea(w_activeArea),
        .o_px(w_px),
        .o_py(w_py)
    );

    // generate testpattern
    wire [2:0] w_red;
    wire [2:0] w_green;
    wire [2:0] w_blue;
    reg [2:0] r_red = 0;
    reg [2:0] r_green = 0;
    reg [2:0] r_blue = 0;

    VGA_PSYCHEDELIC_PATTERN vgaPattern
    (
        .i_clk(r_clk),
        .i_reset(1'b0),
        .i_px(w_px),
        .i_py(w_py),
        .o_red(w_red),
        .o_green(w_green),
        .o_blue(w_blue)
    );

    always @(posedge r_clk)
    begin
        if (w_activeArea == 1'b1)
        begin
            r_red <= w_red;
            r_green <= w_green;
            r_blue <= w_blue;
        end
        else
        begin
            r_red <= 3'b0;
            r_green <= 3'b0;
            r_blue <= 3'b0;
        end
    end

endmodule 



module VGA_TB ();

    VGA_HS_VS_TB vgaHsVsTbInst ();

    initial
    begin
        $dumpfile("dump.vcd");
        $dumpvars(0);

        #400_000;

        $display("Stopped Simulation");
        $finish();
    end

endmodule

