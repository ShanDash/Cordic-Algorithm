`timescale 1ns/1ps
module cordic_sin_cos(
    input clk, reset, start,
    input signed [15:0] angle_radian,
    output reg done,
    output reg [15:0] cos, sin
);
reg busy;
reg [2:0] i;
reg signed [15:0] x,y,z; //z is for tracking the angle left

parameter signed [15:0] K = 16'sd9949; // ~0.60725 in Q1.14

reg signed [15:0] tan_table [0:7]; //stores tan inverse values 
initial begin //for high precision can take 16 values
    tan_table[0] = 16'sd12867; // tan^-1(2^-0) in Q1.14 ≈ 45°
    tan_table[1] = 16'sd7596;  // tan^-1(2^-1)
    tan_table[2] = 16'sd4014;  // tan^-1(2^-2)
    tan_table[3] = 16'sd2037;  // tan^-1(2^-3)
    tan_table[4] = 16'sd1021;  // tan^-1(2^-4)
    tan_table[5] = 16'sd511;   // tan^-1(2^-5)
    tan_table[6] = 16'sd256;   // tan^-1(2^-6)
    tan_table[7] = 16'sd128;   // tan^-1(2^-7)
    end
reg signed [15:0] x_shifted, y_shifted;
always@(posedge clk , posedge reset) //rotate once every clock cycle
begin
    if(reset) begin
        done <= 0;
        busy <= 0;
        i <= 0;
    end
    else if(start && !busy) begin //start hua he just therefore initialize the required parameters
        done <= 0;
        i <= 0;
        busy <= 1;
        x <= K; //cordic gain adjustment
        y <= 0; //initailly starting with (1,0) point on x axis in unit circle , x adjusted by K to adjust the length
        z <= angle_radian;
    end
    else if(busy) begin
        x_shifted = x >>> i; //blocking used because we need to use new values in the same always block only, so update it right now
        y_shifted = y >>> i; //arithmetic right shift
        if(z >= 0)
        begin
            x <= x - y_shifted; //x' = x - y*tan^-1(theta)]
            y <= y + x_shifted;
            z <= z - tan_table[i]; 
        end
        else
        begin
            x <= x + y_shifted;
            y <= y - x_shifted;
            z <= z + tan_table[i];
        end

        i <= i+1;
        if(i==3'b111) //total count 8 hogya, which is 0 to 7
        begin
            cos <= x;
            sin <= y;
            done <= 1;
            busy <= 0;
        end
    end
end
endmodule
