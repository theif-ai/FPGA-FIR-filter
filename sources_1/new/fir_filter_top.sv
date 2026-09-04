`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2026/09/03 01:43:01
// Design Name: 
// Module Name: fir_filter_top
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


module fir_filter_top(
    input logic clk,
    (* mark_debug = "true" *) input logic rstn
    );
    
    localparam N1 = 10;
    localparam N2 = 16;
    localparam N3 = 32;
    
    initial begin
        $readmemb("input2.data",data);
    end
    
    fir_filter2 fir_inst(
        .clk(clk),
        .rst(~rstn),
        .input_Data(input_Data),
        .output_Data(output_Data),
        .sample_T(sample_T),
        .enable(enable)
    );
    
    (* mark_debug = "true" *)logic signed [N2-1:0]input_Data;
    (* mark_debug = "true" *)logic signed [N3-1:0]output_Data;
    
    logic signed [N2-1:0]sample_T;
    (* mark_debug = "true" *)logic enable;
    (* ram_style = "block" *) logic signed [N2-1:0] data [999:0];
    
    (* mark_debug = "true" *)logic [9:0] cnt;
    
    always_ff  @(posedge clk) begin
        if(~rstn) begin
            input_Data <= 0;
            enable <= 0;
                cnt <= 0;
        end
        else begin
        enable <= 1;
            if(cnt >= 999) begin
                input_Data <= data[cnt];
                cnt <= 0;
            end
            else begin
                input_Data <= data[cnt];
                cnt <= cnt + 1;
            end
        end
    end
    
    
endmodule
