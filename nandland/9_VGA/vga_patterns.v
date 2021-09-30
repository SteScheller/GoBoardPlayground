`default_nettype none

module VGA_PSYCHEDELIC_PATTERN
#
(
    parameter CLKS_PER_MS = 25_000
)
(
    input i_clk,
    input i_reset,
    input [9:0] i_px,
    input [9:0] i_py,
    output [2:0] o_red,
    output [2:0] o_green,
    output [2:0] o_blue
);
    // local variables
    reg [15:0] r_millisec = 0;
    reg [15:0] r_cnt = 0;

    // outputs
    reg [2:0] r_red = 0;
    reg [2:0] r_green = 0;
    reg [2:0] r_blue = 0;
    

    always @(posedge i_clk, posedge i_reset)
    if (i_reset == 1'b1)
    begin
        r_millisec <= 0;
        r_cnt <= 0;

        r_red <= 0;
        r_green <= 0;
        r_blue <= 0;
    end
    else
    begin
        // generate 1 ms time base
        if (r_cnt < (CLKS_PER_MS - 1))
            r_cnt <= r_cnt + 1;
        else
        begin
            r_cnt <= 0;
            r_millisec <= r_millisec + 1;
        end

        r_green <= 3'b111;
    end

    assign o_red = r_red; 
    assign o_green = r_green; 
    assign o_blue = r_blue; 

endmodule
