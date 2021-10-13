`default_nettype none

module Power_On_Reset
(
      input i_clk,    
      input i_asyncReset,
      output o_syncReset
);
    bit [2:0] r_q = '0;
 
    always_ff @(posedge i_clk, posedge i_asyncReset)
        if (i_asyncReset == 1'b1)
            r_q <= '0;
        else
            r_q <= { r_q[1:0], !i_asyncReset };

    assign o_syncReset = !(r_q == '1);

endmodule
