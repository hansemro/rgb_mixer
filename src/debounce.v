`default_nettype none
`timescale 1ns/1ns
module debounce (
    input wire clk,
    input wire reset,
    input wire button,
    output reg debounced
);

    parameter BOUNCE_NS = 250000;
    parameter CLOCK_PERIOD_NS = 35700; // 250000 / (8 - 1)
    localparam SHIFT_REG_WIDTH = (BOUNCE_NS / CLOCK_PERIOD_NS) + 1;

    reg [SHIFT_REG_WIDTH-1:0] shift_reg;
    reg prev;

    reg [SHIFT_REG_WIDTH-1:0] next_shift_reg;

    assign next_shift_reg = shift_reg == {SHIFT_REG_WIDTH{1'b1}} ? {SHIFT_REG_WIDTH{1'b0}} | 1'b1 : (shift_reg << 1) | 1'b1;

    always @(posedge clk)
        if (reset) begin
            shift_reg <= {SHIFT_REG_WIDTH{1'b0}} | 1'b1;
            debounced <= 1'b0;
            prev <= 1'b0;
        end
        else if (button ^ prev) begin
            shift_reg <= {SHIFT_REG_WIDTH{1'b0}} | 1'b1;
            prev <= button;
        end
        else begin
            shift_reg <= next_shift_reg;
            if (shift_reg == {SHIFT_REG_WIDTH{1'b1}})
                debounced <= prev;
        end

endmodule
