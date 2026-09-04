`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/02 22:19:03
// Design Name: 
// Module Name: tb_fir_filter2
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


module tb_fir_filter2();

localparam CLK_PERIOD = 20;

localparam N1 = 10;
localparam N2 = 16;
localparam N3 = 32;

logic clk;
logic rst;
logic signed [N2-1:0]input_Data;
logic signed [N3-1:0]output_Data;
logic signed [N2-1:0]sample_T;
logic enable;

logic signed [N2-1:0] data [999:0];

//fir filter module instantiation
fir_filter2 UUT (
    .clk(clk),
    .rst(rst),
    .input_Data(input_Data),
    .output_Data(output_Data),
    .enable(enable),
    .sample_T(sample_T)
);

//clk generation
initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk;
end

//read input file
initial begin
    $readmemb("input2.data",data);
end

// simulation sequence
initial begin
    rst = 1;
    enable = 0;
    
    #(CLK_PERIOD * 2);
    @(posedge clk);
    #1;
    
    rst = 0;
    enable = 1;
    
    for(int i = 0; i < 1000; i++) begin
        input_Data = data[i];
        @(posedge clk);
    end
    
    #(CLK_PERIOD * 6);
    $display("simulation completed");
    #(CLK_PERIOD);
    $finish;
    
end

// write output file
integer FILE1;

initial begin
    wait(rst == 0);
    #(CLK_PERIOD*4);
    
    FILE1 = $fopen("save.data","w");
    
    repeat(1000) begin
        @(posedge clk);
        $fdisplay(FILE1,"%b",output_Data);
        
    end
    $fclose(FILE1);
    
end

endmodule
