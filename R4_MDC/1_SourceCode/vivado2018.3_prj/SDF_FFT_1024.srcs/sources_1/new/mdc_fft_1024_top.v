`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/14 12:52:47
// Design Name:
// Module Name: sdf_fft_1024_top
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


module mdc_fft_1024_top #(
    parameter   integer     DATA_NUM            = 1024,         //number of fft data
    parameter   integer     DATA_WIDTH          = 64,           //input data width, half real half image
    parameter   integer     TWIDDLE_WIDTH       = 64,           //twiddle width, half real half image
    parameter   integer     TWIDDLE_SCALE_SHIFT = 16            //left shift tiddle to scale
)(
    input   wire                                    clk,
    input   wire                                    rstn,
    input   wire                                    data_i_en,
    input   wire    signed  [DATA_WIDTH-1 : 0]      data_i_0,
	input   wire    signed  [DATA_WIDTH-1 : 0]      data_i_1,
	input   wire    signed  [DATA_WIDTH-1 : 0]      data_i_2,
	input   wire    signed  [DATA_WIDTH-1 : 0]      data_i_3,
    output  wire                                    data_o_en,
    output  wire    signed  [DATA_WIDTH-1 : 0]      data_o_0,
	output  wire    signed  [DATA_WIDTH-1 : 0]      data_o_1,
	output  wire    signed  [DATA_WIDTH-1 : 0]      data_o_2,
	output  wire    signed  [DATA_WIDTH-1 : 0]      data_o_3
);

    wire                                    en_s1;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o_0_s1;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_1_s1;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_2_s1;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_3_s1;
    wire                                    en_s2;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o_0_s2;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_1_s2;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_2_s2;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_3_s2;
    wire                                    en_s3;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o_0_s3;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_1_s3;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_2_s3;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_3_s3;
    wire                                    en_s4;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o_0_s4;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_1_s4;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_2_s4;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_3_s4;
    mdc_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(1),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s1_mdc_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (data_i_en),
		.data_i_0	(data_i_0),
		.data_i_1	(data_i_1),
		.data_i_2	(data_i_2),
		.data_i_3	(data_i_3),
        .mul_o_en  (en_s1),
        .mul_o_0	(data_o_0_s1),
		.mul_o_1	(data_o_1_s1),
		.mul_o_2	(data_o_2_s1),
		.mul_o_3	(data_o_3_s1)
    );

    mdc_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(2),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s2_mdc_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (en_s1),
		.data_i_0	(data_o_0_s1),
		.data_i_1	(data_o_1_s1),
		.data_i_2	(data_o_2_s1),
		.data_i_3	(data_o_3_s1),
        .mul_o_en  (en_s2),
        .mul_o_0	(data_o_0_s2),
		.mul_o_1	(data_o_1_s2),
		.mul_o_2	(data_o_2_s2),
		.mul_o_3	(data_o_3_s2)
    );

    mdc_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(3),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s3_mdc_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (en_s2),
		.data_i_0	(data_o_0_s2),
		.data_i_1	(data_o_1_s2),
		.data_i_2	(data_o_2_s2),
		.data_i_3	(data_o_3_s2),
        .mul_o_en  (en_s3),
        .mul_o_0	(data_o_0_s3),
		.mul_o_1	(data_o_1_s3),
		.mul_o_2	(data_o_2_s3),
		.mul_o_3	(data_o_3_s3)
    );

    mdc_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(4),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s4_mdc_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (en_s3),
		.data_i_0	(data_o_0_s3),
		.data_i_1	(data_o_1_s3),
		.data_i_2	(data_o_2_s3),
		.data_i_3	(data_o_3_s3),
        .mul_o_en  (en_s4),
        .mul_o_0	(data_o_0_s4),
		.mul_o_1	(data_o_1_s4),
		.mul_o_2	(data_o_2_s4),
		.mul_o_3	(data_o_3_s4)
    );
    
    mdc_unit #(
        .DATA_NUM(DATA_NUM),
        .STAGE_ID(5),
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) s5_mdc_unit (
        .clk       (clk),
        .rstn      (rstn),
        .data_i_en (en_s4),
		.data_i_0	(data_o_0_s4),
		.data_i_1	(data_o_1_s4),
		.data_i_2	(data_o_2_s4),
		.data_i_3	(data_o_3_s4),
        .mul_o_en  (data_o_en),
        .mul_o_0	(data_o_0),
		.mul_o_1	(data_o_1),
		.mul_o_2	(data_o_2),
		.mul_o_3	(data_o_3)
    );


endmodule
