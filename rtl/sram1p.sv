`timescale 1ns/1ps

// Single-port synchronous SRAM.
//
// Read (i_ce && !i_we): o_rdata captures mem[i_addr] on the clock edge, so
// the data is valid in the next cycle. 
// Write (i_ce && i_we): each byte with i_wstrb[i] == 1 is updated. Bytes
// with the strobe clear keep their previous value.
//
// No reset pin. The array and the outputs power up unknown, matching an SRAM macro. 
// DEPTH must be a power of two and at least 64.

module sram1p #(
    parameter  int DEPTH      = 256,
    parameter  int DATA_WIDTH = 32,
    localparam int ADDR_WIDTH = $clog2(DEPTH),
    localparam int STRB_WIDTH = DATA_WIDTH / 8
) (
    input  logic                  i_clk  ,
    input  logic                  i_ce   ,
    input  logic                  i_we   ,
    input  logic [ADDR_WIDTH-1:0] i_addr ,
    input  logic [DATA_WIDTH-1:0] i_wdata,
    input  logic [STRB_WIDTH-1:0] i_wstrb,
    output logic [DATA_WIDTH-1:0] o_rdata
);

    ////////////////////////////////////////////////////////////////////////////////////
    // Parameter checking
    ////////////////////////////////////////////////////////////////////////////////////

`ifndef SYNTHESIS
    // DEPTH must be a power of two and >= 64
    initial begin
        if ((DEPTH < 64) || ((DEPTH & (DEPTH - 1)) != 0)) begin
            $error("sram1p: DEPTH must be a power of two and >= 64 (DEPTH=%0d)", DEPTH);
        end
    end
`endif

    ////////////////////////////////////////////////////////////////////////////////////
    // Main logic
    ////////////////////////////////////////////////////////////////////////////////////
    (* nomem2reg *)
    logic [DATA_WIDTH-1:0] mem [DEPTH];

    logic read_en;
    logic write_en;

    assign read_en  = i_ce & ~i_we;
    assign write_en = i_ce &  i_we;

    always_ff @(posedge i_clk) begin
        if (read_en) begin
            o_rdata <= mem[i_addr];
        end else begin
            o_rdata <= 'X;
        end
    end

    always_ff @(posedge i_clk) begin
        for (int bi = 0; bi < STRB_WIDTH; bi++) begin
            if (write_en & i_wstrb[bi]) begin
                mem[i_addr][8*bi +: 8] <= i_wdata[8*bi +: 8];
            end
        end
    end

endmodule
