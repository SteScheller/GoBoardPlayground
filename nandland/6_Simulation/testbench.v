// Testbench for LED Blinker
module LED_Blink_TB ();

  reg r_Clock = 1'b0;

  always #1 r_Clock <= ~r_Clock;
  
  // Need to set up parameters appropriately
  // These will blink much faster than on hardware.
  // This allows simulation to run quickly.
  LED_Blink #(.g_COUNT_10HZ(5),
              .g_COUNT_5HZ(10), 
              .g_COUNT_2HZ(25),
              .g_COUNT_1HZ(50)) UUT
    (.i_Clk(r_Clock),
     .o_LED_1(),
     .o_LED_2(),
     .o_LED_3(),
     .o_LED_4());

  initial 
    begin
      $display("Starting Testbench...");
      #200;
      $finish();
    end
  
  initial 
  begin
    // Required to dump signals to EPWave
    $dumpfile("dump.vcd");
    $dumpvars(0);
  end

endmodule

