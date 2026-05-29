`timescale 1ns/1ps

module UART_rx_tb;

    reg clk, rst, rx_in;
    wire [7:0] rx_data;
    wire rx_done;

    // Time duration for 1 single bit at 115,200 baud (8,680 ns)
    parameter BIT_TIME = 8680;

    UART_rx dut(
        .clk(clk),
        .rst(rst),
        .rx_in(rx_in),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // Clock generation: Changed to #10 for a 50 MHz clock frequency (20ns period)
    always #10 clk = ~clk;

    initial begin

        // Initial values
        clk   = 1;
        rst   = 1;
        rx_in = 1;   // UART idle line = HIGH

        // Reset
        #100;
        rst = 0;
        #100; // Let it settle

        // ==================================================
        // UART Frame Transmission 1: Data = 8'b01101001 (0x69)
        // ==================================================
        
        // START BIT
        rx_in = 0;
        #(BIT_TIME);

        // DATA BITS (LSB first)
        rx_in = 1; // bit0
        #(BIT_TIME);

        rx_in = 0; // bit1
        #(BIT_TIME);

        rx_in = 0; // bit2
        #(BIT_TIME);

        rx_in = 1; // bit3
        #(BIT_TIME);

        rx_in = 0; // bit4
        #(BIT_TIME);

        rx_in = 1; // bit5
        #(BIT_TIME);

        rx_in = 1; // bit6
        #(BIT_TIME);

        rx_in = 0; // bit7
        #(BIT_TIME);

        // STOP BIT
        rx_in = 1;
        #(BIT_TIME);

        // Wait between frames to let the receiver process "DONE" and go back to IDLE
        #50000;
         
        // ==================================================
        // UART Frame Transmission 2: Data = 8'b10010110 (0x96)
        // ==================================================
        
        // START BIT
        rx_in = 0;
        #(BIT_TIME);

        // DATA BITS
        rx_in = 0; // bit0
        #(BIT_TIME);

        rx_in = 1; // bit1
        #(BIT_TIME);

        rx_in = 1; // bit2
        #(BIT_TIME);

        rx_in = 0; // bit3
        #(BIT_TIME);

        rx_in = 1; // bit4
        #(BIT_TIME);

        rx_in = 0; // bit5
        #(BIT_TIME);

        rx_in = 0; // bit6
        #(BIT_TIME);

        rx_in = 1; // bit7
        #(BIT_TIME);

        // STOP BIT
        rx_in = 1;
        #(BIT_TIME);

        // Final Wait before ending simulation
        #50000;

        $stop;

    end

    // Monitor Output
    initial begin
        $monitor("TIME=%0t RX_IN=%b RX_DATA=%b RX_DONE=%b",
                  $time, rx_in, rx_data, rx_done);
    end

endmodule
