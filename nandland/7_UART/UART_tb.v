//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////

// This testbench will exercise the UART RX.
// It sends out byte 0x37, and ensures the RX receives it correctly.
`timescale 1ns/10ps

module UART_Rx_TB();

  // Testbench uses a 25 MHz clock (same as Go Board)
  // Want to interface to 115200 baud UART
  // 25000000 / 115200 = 217 Clocks Per Bit.
  parameter c_CLOCK_PERIOD_NS = 40;
  parameter c_CLKS_PER_BIT    = 217;
  parameter c_BIT_PERIOD      = 8600;

  reg r_Clock = 0;
  reg r_RX_Serial = 1;
  wire [7:0] w_RX_Byte;


  // Takes in input byte and serializes it
  task UART_WRITE_BYTE;
    input [7:0] i_Data;
    integer     ii;
    begin

      // Send Start Bit
      r_RX_Serial <= 1'b0;
      #(c_BIT_PERIOD);
      #1000;

      // Send Data Byte
      for (ii=0; ii<8; ii=ii+1)
        begin
          r_RX_Serial <= i_Data[ii];
          #(c_BIT_PERIOD);
        end

      // Send Stop Bit
      r_RX_Serial <= 1'b1;
      #(c_BIT_PERIOD);
     end
  endtask // UART_WRITE_BYTE


  UART_Rx #(
      .CLKS_PER_BIT(c_CLKS_PER_BIT),
      .NUM_DATA_BITS(8)
  ) UART_Rx_INST
    (.i_clk(r_Clock),
     .i_reset(1'b0),
     .i_rx(r_RX_Serial),
     .o_rxStrobe(),
     .o_errorFlag(),
     .o_rxByte(w_RX_Byte)
     );

  always
    #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;


  // Main Testing:
  initial
    begin
      // Send a command to the UART (exercise Rx)
      @(posedge r_Clock);
      UART_WRITE_BYTE(8'h37);
      @(posedge r_Clock);

      // Check that the correct command was received
      if (w_RX_Byte == 8'h37)
        $display("Rx Test Passed");
      else
        $display("Rx Test Failed");
    $finish();
    end

endmodule


module UART_Tx_TB ();

  // Testbench uses a 25 MHz clock
  // Want to interface to 115200 baud UART
  // 25000000 / 115200 = 217 Clocks Per Bit.
  parameter c_CLOCK_PERIOD_NS = 40;
  parameter c_CLKS_PER_BIT    = 217;
  parameter c_BIT_PERIOD      = 8600;

  reg r_Clock = 0;
  reg r_TX_DV = 0;
  wire w_TX_Active, w_UART_Line;
  wire w_TX_Serial;
  wire w_RX_DV;
  reg [7:0] r_TX_Byte = 0;
  wire [7:0] w_RX_Byte;

  UART_Rx #(
      .CLKS_PER_BIT(c_CLKS_PER_BIT),
      .NUM_DATA_BITS(8)
  ) UART_RX_INST
    (.i_clk(r_Clock),
     .i_reset(1'b0),
     .i_rx(w_UART_Line),
     .o_rxStrobe(w_RX_DV),
     .o_errorFlag(),
     .o_rxByte(w_RX_Byte)
     );

  UART_Tx #(.CLKS_PER_BIT(c_CLKS_PER_BIT)) UART_TX_Inst
    (.i_clk(r_Clock),
     .i_txStart(r_TX_DV),
     .i_txByte(r_TX_Byte),
     .i_reset(1'b0),
     .o_tx(w_TX_Serial),
     .o_txActive(w_TX_Active),
     .o_txDoneStrobe(),
     .o_errorFlag()
     );

  // Keeps the UART Receive input high (default) when
  // UART transmitter is not active
  assign w_UART_Line = w_TX_Active ? w_TX_Serial : 1'b1;

  always
    #(c_CLOCK_PERIOD_NS/2) r_Clock <= !r_Clock;

  // Main Testing:
  initial
    begin
      // Tell UART to send a command (exercise TX)
      @(posedge r_Clock);
      @(posedge r_Clock);
      r_TX_DV   <= 1'b1;
      r_TX_Byte <= 8'h3F;
      @(posedge r_Clock);
      r_TX_DV <= 1'b0;

      // Check that the correct command was received
      @(posedge w_RX_DV);
      if (w_RX_Byte == 8'h3F)
        $display("Tx Test Passed");
      else
        $display("Tx Test Failed");
      $finish();
    end

endmodule




module UART_tb
(
);

UART_Rx_TB uartRxTbInst ();
UART_Tx_TB uartTxTbInst ();

initial
begin
    // Required to dump signals to EPWave
    $dumpfile("dump.vcd");
    $dumpvars(0);
end

endmodule

