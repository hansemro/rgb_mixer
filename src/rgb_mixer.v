`default_nettype none
`timescale 1ns/1ns
module rgb_mixer (
    input clk,
    input reset,
    input enc0_a,
    input enc0_b,
    input enc1_a,
    input enc1_b,
    input enc2_a,
    input enc2_b,
    output pwm0_out,
    output pwm1_out,
    output pwm2_out
);

    localparam BOUNCE_NS = 250000;
    localparam CLOCK_PERIOD_NS = 35700;
    localparam ENC_INCREMENT = 1'b1;
    localparam PWM_LEVEL_WIDTH = 8;
    localparam PWM_INVERTED_OUTPUT = 1'b0;

    wire deb0_a, deb0_b, deb1_a, deb1_b, deb2_a, deb2_b;
    wire [PWM_LEVEL_WIDTH-1:0] enc0;
    wire [PWM_LEVEL_WIDTH-1:0] enc1;
    wire [PWM_LEVEL_WIDTH-1:0] enc2;

    debounce #(.BOUNCE_NS(BOUNCE_NS), .CLOCK_PERIOD_NS(CLOCK_PERIOD_NS))
        debouncer_0_a (.clk, .reset, .button(enc0_a), .debounced(deb0_a));
    debounce #(.BOUNCE_NS(BOUNCE_NS), .CLOCK_PERIOD_NS(CLOCK_PERIOD_NS))
        debouncer_0_b (.clk, .reset, .button(enc0_b), .debounced(deb0_b));
    debounce #(.BOUNCE_NS(BOUNCE_NS), .CLOCK_PERIOD_NS(CLOCK_PERIOD_NS))
        debouncer_1_a (.clk, .reset, .button(enc1_a), .debounced(deb1_a));
    debounce #(.BOUNCE_NS(BOUNCE_NS), .CLOCK_PERIOD_NS(CLOCK_PERIOD_NS))
        debouncer_1_b (.clk, .reset, .button(enc1_b), .debounced(deb1_b));
    debounce #(.BOUNCE_NS(BOUNCE_NS), .CLOCK_PERIOD_NS(CLOCK_PERIOD_NS))
        debouncer_2_a (.clk, .reset, .button(enc2_a), .debounced(deb2_a));
    debounce #(.BOUNCE_NS(BOUNCE_NS), .CLOCK_PERIOD_NS(CLOCK_PERIOD_NS))
        debouncer_2_b (.clk, .reset, .button(enc2_b), .debounced(deb2_b));

    encoder #(.VALUE_WIDTH(PWM_LEVEL_WIDTH), .INCREMENT(ENC_INCREMENT))
        encoder_0 (.clk, .reset, .a(deb0_a), .b(deb0_b), .value(enc0));
    encoder #(.VALUE_WIDTH(PWM_LEVEL_WIDTH), .INCREMENT(ENC_INCREMENT))
        encoder_1 (.clk, .reset, .a(deb1_a), .b(deb1_b), .value(enc1));
    encoder #(.VALUE_WIDTH(PWM_LEVEL_WIDTH), .INCREMENT(ENC_INCREMENT))
        encoder_2 (.clk, .reset, .a(deb2_a), .b(deb2_b), .value(enc2));

    pwm #(.LEVEL_WIDTH(PWM_LEVEL_WIDTH), .INVERTED_OUTPUT(PWM_INVERTED_OUTPUT))
        pwm_0 (.clk, .reset, .out(pwm0_out), .level(enc0));
    pwm #(.LEVEL_WIDTH(PWM_LEVEL_WIDTH), .INVERTED_OUTPUT(PWM_INVERTED_OUTPUT))
        pwm_1 (.clk, .reset, .out(pwm1_out), .level(enc1));
    pwm #(.LEVEL_WIDTH(PWM_LEVEL_WIDTH), .INVERTED_OUTPUT(PWM_INVERTED_OUTPUT))
        pwm_2 (.clk, .reset, .out(pwm2_out), .level(enc2));

endmodule
