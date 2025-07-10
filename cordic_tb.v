`timescale 1ns/1ps

module tb_cordic;

  // DUT inputs
  reg clk, reset, start;
  reg signed [15:0] angle_radian;

  // DUT outputs
  wire done;
  wire [15:0] cos, sin;

  // Instantiate your DUT
  cordic_sin_cos dut (
    .clk(clk),
    .reset(reset),
    .start(start),
    .angle_radian(angle_radian),
    .done(done),
    .cos(cos),
    .sin(sin)
  );

  // Clock generation
  always #5 clk = ~clk;

  initial begin
    clk = 0;
    reset = 1;
    start = 0;
    angle_radian = 16'd0;

    // Apply reset
    #20;
    reset = 0;

    // Set input angle to ~45 degrees (pi/4 radians)
    // 0.785398 * 16384 ≈ 12867
    angle_radian = 16'sd12867;

    // Pulse start for one clock
    #10;
    start = 1;
    #10;
    start = 0;

    // Wait for done
    wait (done == 1);

    // Print results
    $display("Test angle: %d", angle_radian);
    $display("COS (Q1.14): %d", cos);
    $display("SIN (Q1.14): %d", sin);

    $stop;
  end

endmodule
