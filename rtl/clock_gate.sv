`timescale 1ns/1ps

// Glitch-free integrated clock gate.
// i_en and i_te are captured while i_clk is low, so a pulse on o_clk is never
// cut short or started in the middle. i_te forces the clock on for test.
module clock_gate (
    input  logic i_clk,
    input  logic i_en,
    input  logic i_te,
    output logic o_clk
);

    logic en_latched /* verilator clock_enable */;

    // Latch is required for an integrated clock gate. This is the only
    // always_latch in rtl_primitive.
    always_latch begin
        if (!i_clk) begin
            en_latched = i_en | i_te;
        end
    end

    assign o_clk = i_clk & en_latched;

endmodule
