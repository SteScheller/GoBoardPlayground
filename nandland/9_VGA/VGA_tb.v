`timescale 100ns/1ns

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

endmodule 



module VGA_TB ();

    VGA_HS_VS_TB vgaHsVsTbInst ();

    initial
    begin
        $dumpfile("dump.vcd");
        $dumpvars(0);

        #200_000;

        $display("Stopped Simulation");
        $finish();
    end

endmodule

