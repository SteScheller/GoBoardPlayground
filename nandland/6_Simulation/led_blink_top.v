module LED_Blink_Top
 (input  i_Clk,
  output o_LED_1,
  output o_LED_2,
  output o_LED_3,
  output o_LED_4);
 
  // Input clock is 25 MHz
  // Generics represent count values to which internals count
  // before toggling their LEDs
  LED_Blink #(.g_COUNT_10HZ(1250000), 
              .g_COUNT_5HZ(2500000), 
              .g_COUNT_2HZ(6250000),
              .g_COUNT_1HZ(12500000)) LED_Blink_Inst
    (.i_Clk(i_Clk),
     .o_LED_1(o_LED_1),
     .o_LED_2(o_LED_2),
     .o_LED_3(o_LED_3),
     .o_LED_4(o_LED_4));
 
endmodule

