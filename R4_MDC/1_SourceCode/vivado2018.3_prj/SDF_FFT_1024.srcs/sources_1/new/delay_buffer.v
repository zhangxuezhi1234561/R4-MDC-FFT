`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/12 22:41:34
// Design Name:
// Module Name: delay_buffer
// Project Name: SDF_FFT_1024
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

module delay_buffer #(
    parameter   DEPTH = 32,
    parameter   DATA_WIDTH = 16
)(
    input   wire                            clk,        //  Master Clock
    input   wire    [DATA_WIDTH-1:0]        data_i,     //  Data Input
    output  wire    [DATA_WIDTH-1:0]        data_o      //  Data Output
);

    reg [DATA_WIDTH-1:0] buffer[0:DEPTH-1];
    integer n;

    always @(posedge clk) begin
        for (n = DEPTH-1; n > 0; n = n - 1) begin
            buffer[n] <= buffer[n-1];
        end
        buffer[0] <= data_i;
    end

    assign  data_o = buffer[DEPTH-1];

endmodule
