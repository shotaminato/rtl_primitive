`timescale 1ns/1ps

// Preprocessor macros must live outside any package so all translation units see them.

`define DFF(__q, __d, __en, __clk) \
    always_ff @(posedge __clk) begin \
        {__q} <= {__d}; \
    end

`define DFFR(__q, __d, __en, __clk, __rst_n) \
    always_ff @(posedge __clk or negedge __rst_n) begin \
        if (!__rst_n) begin \
            {__q} <= 0; \
        end else begin \
            if ({__en}) begin \
                {__q} <= {__d}; \
            end \
        end \
    end

`define DFFR_VAL(__q, __d, __en, __clk, __rst_n, __val) \
    always_ff @(posedge __clk or negedge __rst_n) begin \
        if (!__rst_n) begin \
            {__q} <= __val; \
        end else begin \
            if ({__en}) begin \
                {__q} <= {__d}; \
            end \
        end \
    end

package macro_pkg;
endpackage
