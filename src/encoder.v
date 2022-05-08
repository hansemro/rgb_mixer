`default_nettype none
`timescale 1ns/1ns
module encoder (
    input clk,
    input reset,
    input a,
    input b,
    output reg [VALUE_WIDTH-1:0] value
);

    parameter VALUE_WIDTH = 8;
    parameter INCREMENT = 1'b1;

    reg prev_a;
    reg prev_b;

    always @(posedge clk) begin
        prev_a <= a;
        prev_b <= b;
        if (reset) begin
            value <= {VALUE_WIDTH{1'b0}};
            prev_a <= 1'b0;
            prev_b <= 1'b0;
        end
        else if ({a,prev_a,b,prev_b} == 4'b1000 || {a,prev_a,b,prev_b} == 4'b0111)
            value <= value + INCREMENT;
        else if ({a,prev_a,b,prev_b} == 4'b0010 || {a,prev_a,b,prev_b} == 4'b1101)
            value <= value - INCREMENT;
    end

endmodule
