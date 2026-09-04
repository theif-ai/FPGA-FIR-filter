`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/01 20:26:23
// Design Name: 
// Module Name: tb_fir_filter
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


module tb_fir_filter();

localparam N1 = 8;
localparam N2 = 16;
localparam N3 = 32;
localparam CLK_PERIOD = 20;

logic clk;
logic rst;
logic signed [N2-1:0] input_Data;
logic signed [N3-1:0] output_Data;
logic signed [N2-1:0] sample_T;
logic enable;


logic [N2-1:0] data [99:0];

fir_filter2 UUT (
    .clk(clk),
    .rst(rst),
    .input_Data(input_Data),
    .output_Data(output_Data),
    .enable(enable),
    .sample_T(sample_T)
);
//integer for the for loop
integer k;

//file for saving filtered data
integer FILE1;

initial begin
    //load data samples and store them in the array called data
    $readmemb("input.data", data);
    // open the file for saving the filtered data
    FILE1 = $fopen("save.data","w");
end

 initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk;
 end
 
 initial begin
 rst = 1;
 enable = 0;
 #(CLK_PERIOD * 2);
 @(posedge clk);
 #1;
 rst = 0;
 enable = 1;
 input_Data <= data[0];
 for (k = 0; k<100; k++) begin
    input_Data <= data[k];
    @(posedge clk);
 end
 
 input_Data <= 0;
 
 #(CLK_PERIOD * 4);
 
 $fclose(FILE1);
 $display("simulation completed");
 #(CLK_PERIOD * 4);
 $finish;
 
 
 end
 
 initial begin
    wait(rst == 0);
    
    #(CLK_PERIOD * 4);
    
    
    repeat(100) begin
        @(posedge clk);
        
        $fdisplay(FILE1, "%b", output_Data);
    end
 end

endmodule
