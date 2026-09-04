`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/01 20:04:22
// Design Name: 
// Module Name: fir_filter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fir_filter(
    input logic clk,
    input logic rstn,
    input logic signed [N2-1:0] input_Data,
    input logic enable,
    output logic signed [N3-1:0] output_Data,
    output logic signed sample_T 
    );
    
    //fir filter coefficient word width
    localparam N1 = 8;
    //input data word width
    localparam N2 = 16;
    // output data word width
    localparam N3 = 32;
    
    // this array is used to store the coefficient
    logic signed [N1-1:0] b [7:0];
    
    // this array is used to save input data and to shift them
    logic signed [N2-1:0] sample [6:0];
    
    genvar i;
    generate
    for (i = 0; i < 8; i++) begin
        assign b[i] = 8'b00010000;
    end
    endgenerate
    
    always_ff @(posedge clk, negedge rstn) begin
        if(~rstn) begin
            output_Data <= 32'b0;
            for (int i = 0; i < 7 ; i++) begin
                sample[i] <= 16'b0;
            end
            
        end
        else if(enable) begin
            output_Data <= b[0] * input_Data 
            + b[1] * sample[0]
            + b[2] * sample[1]
            + b[3] * sample[2]
            + b[4] * sample[3]
            + b[5] * sample[4]
            + b[6] * sample[5]
            + b[7] * sample[6];
            
            sample[0] <= input_Data;
            sample[1] <= sample[0];
            sample[2] <= sample[1];
            sample[3] <= sample[2];
            sample[4] <= sample[3];
            sample[5] <= sample[4];
            sample[6] <= sample[5];
            
        end
    end
    
    assign sample_T = sample[0];
    
endmodule
