`timescale 1ns/1ps

module tb_cordic;

  // DUT inputs
  reg clk, reset, start;
  reg signed [15:0] angle_radian;

  // DUT outputs
  wire done;
  wire [15:0] cos, sin;

  // Instantiate DUT
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

    // ========================
    // Test 1: 0 degrees (0 rad)
    angle_radian = 16'sd0;
    #10; start = 1; #10; start = 0;
    wait(done == 1);
    $display("Angle: 0 deg, COS: %d, SIN: %d", cos, sin);
    #20;

    // ========================
    // Test 2: 30 degrees (pi/6 ≈ 0.5236 rad)
    // 0.5236 * 16384 ≈ 8576
    angle_radian = 16'sd8576;
    #10; start = 1; #10; start = 0;
    wait(done == 1);
    $display("Angle: 30 deg, COS: %d, SIN: %d", cos, sin);
    #20;

    // ========================
    // Test 3: 45 degrees (pi/4 ≈ 0.7854 rad)
    // 0.7854 * 16384 ≈ 12867
    angle_radian = 16'sd12867;
    #10; start = 1; #10; start = 0;
    wait(done == 1);
    $display("Angle: 45 deg, COS: %d, SIN: %d", cos, sin);
    #20;

    // ========================
    // Test 4: 60 degrees (pi/3 ≈ 1.0472 rad)
    // 1.0472 * 16384 ≈ 17152
    angle_radian = 16'sd17152;
    #10; start = 1; #10; start = 0;
    wait(done == 1);
    $display("Angle: 60 deg, COS: %d, SIN: %d", cos, sin);
    #20;

    // ========================
    // Test 5: 90 degrees (pi/2 ≈ 1.5708 rad)
    // 1.5708 * 16384 ≈ 25735
    angle_radian = 16'sd25735;
    #10; start = 1; #10; start = 0;
    wait(done == 1);
    $display("Angle: 90 deg, COS: %d, SIN: %d", cos, sin);
    #20;

    $display("All tests done!");
    $stop;
  end

endmodule
