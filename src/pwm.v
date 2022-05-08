`default_nettype none
`timescale 1ns/1ns
module pwm (
    input wire clk,
    input wire reset,
    output wire out,
    input wire [LEVEL_WIDTH-1:0] level
    );

    parameter LEVEL_WIDTH = 8;
    parameter INVERTED_OUTPUT = 1'b0;

    reg [LEVEL_WIDTH-1:0] counter;

    always @(posedge clk)
        if (reset)
            counter <= 1'b0;
        else
            counter <= counter + 1'b1;

    generate
        if (INVERTED_OUTPUT)
            assign out = reset ? 1'b1 : counter >= level;
        else
            assign out = reset ? 1'b0 : counter < level;
    endgenerate

endmodule
