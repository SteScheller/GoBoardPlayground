`default_nettype none

module Debounce_Switch
#
(
    parameter DEBOUNCE_COUNT = 250000 // 10 ms at 25 MHz
)
(
    input i_clk,
    input i_sw,
    output o_sw

);
    bit [17:0] r_count = 0;
    bit r_state = 1'b0;

    always_ff @(posedge i_clk)
    begin
        // count when state and switch are different
        if (i_sw !== r_state && r_count < DEBOUNCE_COUNT)
            r_count <= r_count + 1;

        // update state, if count reached the limit
        else if (r_count == DEBOUNCE_COUNT) begin
            r_state <= i_sw;
            r_count <= 0;

        // reset count if switch and state are the same
        end else
            r_count <= 0;
    end

    assign o_sw = r_state;

endmodule

