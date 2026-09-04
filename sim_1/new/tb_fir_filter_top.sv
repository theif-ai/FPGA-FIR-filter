`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/04 11:11:55
// Design Name: 
// Module Name: tb_fir_filter_top
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


module tb_fir_filter_top();

fir_filter_top UUT(
    .clk(clk),
    .rstn(rstn)
);

localparam CLK_PERIOD = 20;

logic clk;
logic rstn;

initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk;
end

initial begin
    rstn = 0;
    #(CLK_PERIOD * 3);
    @(posedge clk);
    #1;
    rstn = 1;
end

endmodule
