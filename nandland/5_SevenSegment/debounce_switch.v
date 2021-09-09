module Debounce_Switch
(
    input i_clk,
    input i_sw,
    output o_sw

);

    parameter c_debounceCount = 250000; // 10 ms at 25 MHz

    reg [17:0] r_count = 0;
    reg r_state = 1'b0;

    always @(posedge i_clk)
    begin
        // count when state and switch are different
        if (i_sw !== r_state && r_count < c_debounceCount)
            r_count <= r_count + 1;

        // update state, if count reached the limit
        else if (r_count == c_debounceCount) begin
            r_state <= i_sw;
            r_count <= 0;

        // reset count if switch and state are the same
        end else
            r_count <= 0;
    end

    assign o_sw = r_state;

endmodule

