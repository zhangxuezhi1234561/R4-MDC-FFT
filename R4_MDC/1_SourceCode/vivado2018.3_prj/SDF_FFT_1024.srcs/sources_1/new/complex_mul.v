`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/13 12:27:56
// Design Name:
// Module Name: complex_mul
// Project Name: SDF_FFT_1024
// Target Devices:
// Tool Versions:
// Description: Complex Multiplier
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module complex_mul #(
    parameter   integer     DATA_WIDTH          = 64,
    parameter   integer     TWIDDLE_WIDTH       = 64,
    parameter   integer     TWIDDLE_SCALE_SHIFT = 16
)(
    input   wire    signed  [DATA_WIDTH-1 : 0]      data_i,
    input   wire    signed  [TWIDDLE_WIDTH-1 : 0]   twiddle_i,
    output  wire    signed  [DATA_WIDTH-1 : 0]      mul_o
);

    //-----------------------wire define-----------------------//
    wire    signed  [DATA_WIDTH/2-1 : 0]                  data_real;
    wire    signed  [DATA_WIDTH/2-1 : 0]                  data_imag;
    wire    signed  [TWIDDLE_WIDTH/2-1 : 0]               twiddle_real;
    wire    signed  [TWIDDLE_WIDTH/2-1 : 0]               twiddle_imag;

    wire    signed  [DATA_WIDTH/2+TWIDDLE_WIDTH/2-1 : 0]      drtr;             //data real * twiddle real
    wire    signed  [DATA_WIDTH/2+TWIDDLE_WIDTH/2-1 : 0]      drti;             //data real * twiddle image
    wire    signed  [DATA_WIDTH/2+TWIDDLE_WIDTH/2-1 : 0]      ditr;             //data image * twiddle real
    wire    signed  [DATA_WIDTH/2+TWIDDLE_WIDTH/2-1 : 0]      diti;             //data image * twiddle image

    wire    signed  [DATA_WIDTH/2+TWIDDLE_WIDTH/2-1 : 0]      sc_drtr;          //drtr after scaling
    wire    signed  [DATA_WIDTH/2+TWIDDLE_WIDTH/2-1 : 0]      sc_drti;          //drti after scaling
    wire    signed  [DATA_WIDTH/2+TWIDDLE_WIDTH/2-1 : 0]      sc_ditr;          //ditr after scaling
    wire    signed  [DATA_WIDTH/2+TWIDDLE_WIDTH/2-1 : 0]      sc_diti;          //diti after scaling

    wire    signed  [DATA_WIDTH/2-1 : 0]                  cut_drtr;         //sc_drtr after cut
    wire    signed  [DATA_WIDTH/2-1 : 0]                  cut_drti;         //sc_drti after cut
    wire    signed  [DATA_WIDTH/2-1 : 0]                  cut_ditr;         //sc_ditr after cut
    wire    signed  [DATA_WIDTH/2-1 : 0]                  cut_diti;         //sc_diti after cut

    wire    signed  [DATA_WIDTH/2-1 : 0]                  result_real;      //result real
    wire    signed  [DATA_WIDTH/2-1 : 0]                  result_imag;      //result image

    assign data_real    = data_i[(DATA_WIDTH-1) -: (DATA_WIDTH/2)];
    assign data_imag    = data_i[0 +: (DATA_WIDTH/2)];
    assign twiddle_real = twiddle_i[(TWIDDLE_WIDTH-1) -: (TWIDDLE_WIDTH/2)];
    assign twiddle_imag = twiddle_i[0 +: (TWIDDLE_WIDTH/2)];

    //-----------------------signed mul logic-----------------------//
    assign drtr = data_real * twiddle_real;
    assign drti = data_real * twiddle_imag;
    assign ditr = data_imag * twiddle_real;
    assign diti = data_imag * twiddle_imag;

    //-----------------------scale logic-----------------------//
    assign sc_drtr = drtr >>> TWIDDLE_SCALE_SHIFT;
    assign sc_drti = drti >>> TWIDDLE_SCALE_SHIFT;
    assign sc_ditr = ditr >>> TWIDDLE_SCALE_SHIFT;
    assign sc_diti = diti >>> TWIDDLE_SCALE_SHIFT;

    //-----------------------cut bit logic-----------------------//
    assign cut_drtr = {sc_drtr[DATA_WIDTH/2+TWIDDLE_WIDTH/2-1], sc_drtr[DATA_WIDTH/2-2 : 0]};
    assign cut_drti = {sc_drti[DATA_WIDTH/2+TWIDDLE_WIDTH/2-1], sc_drti[DATA_WIDTH/2-2 : 0]};
    assign cut_ditr = {sc_ditr[DATA_WIDTH/2+TWIDDLE_WIDTH/2-1], sc_ditr[DATA_WIDTH/2-2 : 0]};
    assign cut_diti = {sc_diti[DATA_WIDTH/2+TWIDDLE_WIDTH/2-1], sc_diti[DATA_WIDTH/2-2 : 0]};

    //-----------------------add&sub logic-----------------------//
    //  These sub/add may overflow if unnormalized data is input.
    assign result_real = cut_drtr - cut_diti;
    assign result_imag = cut_drti + cut_ditr;

    //-----------------------mul_o logic-----------------------//
    assign mul_o = {result_real, result_imag};

endmodule
