`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/02 16:13:21
// Design Name: 
// Module Name: fir_filter2
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


module fir_filter2#(
    parameter N1 = 10,
    parameter N2 = 16,
    parameter N3 = 32)(
    input logic clk,
    input logic rst,
    input logic signed [N2-1 : 0] input_Data,
    output logic signed [N3-1 : 0] output_Data,
    input logic enable,
    output logic signed [N2-1 : 0]sample_T
    );
    
    logic signed [N1-1 : 0] b [31:0];
    
    logic signed [N2-1 : 0] sample [30:0];
    
    //pipeline1
    logic start1;
    logic signed [N2:0] start1_reg [15:0];
    
    //pipeline2
    logic start2;
    logic signed [N1+N2:0] start2_reg [15:0];
    
    //pipeline3
    logic start3;
    logic signed [N1+N2+1:0] start3_reg [7:0];
    
    //pipeline4
    logic start4;
    logic signed [N1+N2+2:0] start4_reg [3:0];
    
    //pipeline5
    logic start5;
    logic signed [N1+N2+3:0] start5_reg [1:0];
    
    //filter coefficient
    
    initial begin
        $readmemb("fir_coefficients.data",b);
    end
    
    
    
    //sample shift register
    always @(posedge clk) begin
        if(rst) begin
            for(int i = 0; i < 31; i++) begin
                sample[i] <= 0;
            end
        end
        else if(enable) begin
            sample[0] <= input_Data;
            for (int i = 0; i < 30; i++) begin
                sample[i+1] <= sample[i];
            end
        end
    end
    
    // pipeline control logic
    always_ff @(posedge clk) begin
        if(rst) begin
            start1 <= 0;
            start2 <= 0;
            start3 <= 0;
            start4 <= 0;
            start5 <= 0;
        end
        else begin
            start1 <= enable;
            start2 <= start1;
            start3 <= start2;
            start4 <= start3;
            start5 <= start4;
        end
    end
    
    always_ff @(posedge clk) begin
        if(rst) begin
            output_Data <= 0;
            
            for(int i = 0; i < 16; i++) start1_reg[i] <= 0;
            for(int i = 0; i < 16; i++) start2_reg[i] <= 0;
            for(int i = 0; i < 8; i++) start3_reg[i] <= 0;
            for(int i = 0; i < 4; i++) start4_reg[i] <= 0;
            for(int i = 0; i < 2; i++) start5_reg[i] <= 0;
        end
        else begin
            if(enable) begin
                start1_reg[0] <= input_Data + sample[30];
                for(int i = 1; i < 16; i++) begin
                    start1_reg[i] <= sample[i-1] + sample[30 - i];
                end
            end
            if(start1) begin
                for(int i = 0; i < 16; i++) begin
                    start2_reg[i] <= b[i] * start1_reg[i];
                end
            end
            if(start2) begin
                for(int i = 0; i < 8; i++) begin
                    start3_reg[i] <= start2_reg[i*2] + start2_reg[i*2+1];
                end
            end
            if(start3) begin
                for(int i = 0; i < 4; i++) begin
                    start4_reg[i] <= start3_reg[i*2] + start3_reg[i*2+1];
                end
            end
            if(start4) begin
                for(int i = 0; i < 2; i++) begin
                    start5_reg[i] <= start4_reg[i*2] + start4_reg[i*2+1];
                end
            end
            if(start5) begin
                output_Data <= start5_reg[0] + start5_reg[1];
            end
        end
    end
    
    assign sample_T = sample[0];
    
endmodule
