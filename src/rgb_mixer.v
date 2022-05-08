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

    localparam NUM_CHANNELS = 3; // should not be changed
    localparam BOUNCE_NS = 250000;
    localparam CLOCK_PERIOD_NS = 35700;
    localparam ENC_INCREMENT = 1'b1;
    localparam PWM_LEVEL_WIDTH = 8;
    localparam PWM_INVERTED_OUTPUT = 1'b0;

    wire _enc_a [NUM_CHANNELS-1:0];
    wire _enc_b [NUM_CHANNELS-1:0];
    wire _deb_a [NUM_CHANNELS-1:0];
    wire _deb_b [NUM_CHANNELS-1:0];
    wire [PWM_LEVEL_WIDTH-1:0] _enc_out [NUM_CHANNELS-1:0];
    wire [PWM_LEVEL_WIDTH-1:0] enc0;
    wire [PWM_LEVEL_WIDTH-1:0] enc1;
    wire [PWM_LEVEL_WIDTH-1:0] enc2;
    wire _pwm_out [NUM_CHANNELS-1:0];

    assign _enc_a[0] = enc0_a;
    assign _enc_a[1] = enc1_a;
    assign _enc_a[2] = enc2_a;
    assign _enc_b[0] = enc0_b;
    assign _enc_b[1] = enc1_b;
    assign _enc_b[2] = enc2_b;

    assign enc0 = _enc_out[0];
    assign enc1 = _enc_out[1];
    assign enc2 = _enc_out[2];

    assign pwm0_out = _pwm_out[0];
    assign pwm1_out = _pwm_out[1];
    assign pwm2_out = _pwm_out[2];

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : color_channel
            debounce #(.BOUNCE_NS(BOUNCE_NS), .CLOCK_PERIOD_NS(CLOCK_PERIOD_NS))
                _debouncer_a (.clk, .reset, .button(_enc_a[i]), .debounced(_deb_a[i]));
            debounce #(.BOUNCE_NS(BOUNCE_NS), .CLOCK_PERIOD_NS(CLOCK_PERIOD_NS))
                _debouncer_b (.clk, .reset, .button(_enc_b[i]), .debounced(_deb_b[i]));
            encoder #(.VALUE_WIDTH(PWM_LEVEL_WIDTH), .INCREMENT(ENC_INCREMENT))
                _encoder (.clk, .reset, .a(_deb_a[i]), .b(_deb_b[i]), .value(_enc_out[i]));
            pwm #(.LEVEL_WIDTH(PWM_LEVEL_WIDTH), .INVERTED_OUTPUT(PWM_INVERTED_OUTPUT))
                _pwm (.clk, .reset, .out(_pwm_out[i]), .level(_enc_out[i]));
        end
    endgenerate

endmodule
