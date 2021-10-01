`default_nettype none

module Power_On_Reset
(
      input i_clk,    
      input i_asyncReset,
      output o_syncReset
);
    reg q0 = 1'b0;
    reg q1 = 1'b0;
    reg q2 = 1'b0;
 
    always @(posedge i_clk, negedge i_asyncReset)
    begin
        if (i_asyncReset == 1'b0)
        begin
            q0 <= 1'b0;
            q1 <= 1'b0;
            q2 <= 1'b0;
        end    
        else if (i_clk == 1'b1)
        begin
            q0 <= i_asyncReset;
            q1 <= q0;
            q2 <= q1;
        end    
    end

    assign o_syncReset = !(q0 & q1 & q2);

endmodule
