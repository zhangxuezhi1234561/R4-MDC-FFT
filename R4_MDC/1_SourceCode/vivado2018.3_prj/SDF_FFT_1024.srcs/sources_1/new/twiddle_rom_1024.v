`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/13 15:28:50
// Design Name:
// Module Name: twiddle_rom_1024
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

module twiddle_rom_1024 #(
    parameter   TWIDDLE_WIDTH = 64,
    parameter   ADDR_WIDTH = 8,
    parameter   TW_REAL_ARY_PATH = "../../../../../twiddle_rom/pro_tw_real_ary.txt",          //modify to correct path
    parameter   TW_IMAG_ARY_PATH = "../../../../../twiddle_rom/pro_tw_imag_ary.txt"           //modify to correct path
)(
    input wire clk,
    input wire en,
    input wire [ADDR_WIDTH:0] addr,
    output wire [TWIDDLE_WIDTH-1:0] twiddle
);

reg [TWIDDLE_WIDTH/2-1:0]   tw_real_ary [0:1023];
reg [TWIDDLE_WIDTH/2-1:0]   tw_imag_ary [0:1023];

initial begin
    $readmemh(TW_REAL_ARY_PATH, tw_real_ary);
    $readmemh(TW_IMAG_ARY_PATH, tw_imag_ary);
end

reg [TWIDDLE_WIDTH/2-1:0]dout_real;
reg [TWIDDLE_WIDTH/2-1:0]dout_imag;

always @(posedge clk) begin
    if(en)begin
        dout_real <= tw_real_ary[addr];
        dout_imag <= tw_imag_ary[addr];
    end
end

//---------output------------//
assign twiddle = {dout_real,dout_imag};

endmodule