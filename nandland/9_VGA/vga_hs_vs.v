`default_nettype none

module VGA_HS_VS
#(
    parameter H_ACTIVE_AREA = 640,
    parameter V_ACTIVE_AREA = 480,
    parameter H_TOTAL = 800,
    parameter V_TOTAL = 525,
    parameter H_SYNC = 96,
    parameter V_SYNC = 2,
    parameter H_BACK_PORCH = 48,
    parameter H_FRONT_PORCH = 16,
    parameter V_BACK_PORCH = 33,
    parameter V_FRONT_PORCH = 10
)
(
    input i_clk,
    input i_reset,
    output o_hs,
    output o_vs,
    output o_activeArea,
    output [9:0] o_px,
    output [9:0] o_py
);

    // local variables
    reg [10:0] r_hCnt = 0;
    reg [10:0] r_vCnt = 0;
    reg r_vCntEnable = 1'b0;

    // output registers
    reg r_hs = 1'b0;
    reg r_vs = 1'b0;
    reg r_activeArea = 1'b0;
    reg r_hActive = 1'b0;
    reg r_vActive = 1'b0;
    reg [9:0] r_px = 0;
    reg [9:0] r_py = 0;

    always @(posedge i_clk, posedge i_reset)
    if (i_reset == 1'b1)
    begin
        r_hCnt <= 0;
        r_vCnt <= 0;
        r_vCntEnable <= 1'b0;

        r_hs <= 1'b0;
        r_vs <= 1'b0;
        r_activeArea <= 1'b0;
        r_hActive <= 1'b0;
        r_vActive <= 1'b0;
        r_px <= 0;
        r_py <= 0;
    end
    else
    begin
        // increment horizontal count
        if (r_hCnt < (H_TOTAL - 1))
        begin
            r_hCnt <= r_hCnt + 1;
            r_vCntEnable <= 1'b0;
        end
        else
        begin
            r_hCnt <= 0;
            r_vCntEnable <= 1'b1;
        end

        // increment vertical count
        if (r_vCntEnable == 1'b1)
        begin
            if (r_vCnt < (V_TOTAL - 1))
                r_vCnt <= r_vCnt + 1;
            else
                r_vCnt <= 0;
        end


        // infer horizontal and vertical sync pulses
        r_hs <= (r_hCnt < H_SYNC) ? 1'b0 : 1'b1;
        r_vs <= (r_vCnt < V_SYNC) ? 1'b0 : 1'b1;

        // compute pixel coordinates
        if ((r_hCnt >= (H_SYNC + H_BACK_PORCH)) && (r_hCnt < (H_TOTAL - H_FRONT_PORCH)))
        begin
            r_px <= r_hCnt - H_SYNC - H_BACK_PORCH;
            r_hActive <= 1'b1;
        end
        else
        begin
            r_px <= 0;
            r_hActive <= 1'b0;
        end

        if ((r_vCnt >= (V_SYNC + V_BACK_PORCH)) && (r_vCnt < (V_TOTAL - V_FRONT_PORCH)))
        begin
            r_py <= r_vCnt - V_SYNC - V_BACK_PORCH;
            r_vActive <= 1'b1;
        end
        else
        begin
            r_py <= 0;
            r_vActive <= 1'b0;
        end

        r_activeArea = r_hActive & r_vActive;
    end

    assign o_activeArea = r_activeArea;
    assign o_hs = r_hs;
    assign o_vs = r_vs;
    assign o_px = r_px;
    assign o_py = r_py;

endmodule

