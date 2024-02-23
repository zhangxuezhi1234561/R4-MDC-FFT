`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/12 16:07:21
// Design Name:
// Module Name: butterfly
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


module butterfly #(
    parameter   integer     DATA_NUM   = 8,                 //number of fft data
    parameter   integer     STAGE_ID   = 1,                 //stage id of this BF2
    parameter   integer     DATA_WIDTH = 64                 //input data width, half real half image
)(
    input   wire                                    clk,
    input   wire                                    rstn,
    input   wire                                    data_i_en,
    input   wire    signed  [DATA_WIDTH-1 : 0]      data_i_0,//四个输入通道
	input   wire    signed  [DATA_WIDTH-1 : 0]      data_i_1,
	input   wire    signed  [DATA_WIDTH-1 : 0]      data_i_2,
	input   wire    signed  [DATA_WIDTH-1 : 0]      data_i_3,
	
    output  wire                                    data_o_en,
    output  wire    signed  [DATA_WIDTH-1  : 0]      data_o_0,//四个输出通道
	output  wire    signed  [DATA_WIDTH-1  : 0]      data_o_1,
	output  wire    signed  [DATA_WIDTH-1 : 0]      data_o_2,
	output  wire    signed  [DATA_WIDTH-1 : 0]      data_o_3
    //output  wire                                    data_sel
);
	
	//-------------------Define Function-----------------//
	function signed [DATA_WIDTH-1 : 0]	N_Imag_Mux;//与-j作用 <-> 实部取相反数，然后与虚部交换
		input signed [DATA_WIDTH-1 : 0]  operand;
		reg   signed [DATA_WIDTH/2-1 : 0]	 N_Imag_Mux_real;
		reg   signed [DATA_WIDTH/2-1 : 0]	 N_Imag_Mux_imag;
		begin
            N_Imag_Mux_real	= operand[0 +: (DATA_WIDTH/2)];
            N_Imag_Mux_imag = -1 * operand[(DATA_WIDTH-1) -: (DATA_WIDTH/2)];
            N_Imag_Mux		= {N_Imag_Mux_real,N_Imag_Mux_imag};
		end
	endfunction
	
	function signed [DATA_WIDTH-1 : 0]	P_Imag_Mux;//与j作用 <-> 虚部取相反数，然后与实部交换
		input signed [DATA_WIDTH-1 : 0]  operand;
		reg   signed [DATA_WIDTH/2-1 : 0]	 P_Imag_Mux_real;
		reg   signed [DATA_WIDTH/2-1 : 0]	 P_Imag_Mux_imag;
		begin
            P_Imag_Mux_real	= -1 * operand[0 +: (DATA_WIDTH/2)];
            P_Imag_Mux_imag = operand[(DATA_WIDTH-1) -: (DATA_WIDTH/2)];
                P_Imag_Mux		= {P_Imag_Mux_real,P_Imag_Mux_imag};
		end
	endfunction	

    //-----------------------local parameter-----------------------//
    localparam  STAGE_ALL = ($clog2(DATA_NUM))/2;               //number of all pipeline stage 
    localparam  DELAY_N = 2**(STAGE_ALL-STAGE_ID);          //delay depth

    //-----------------------inner define-----------------------//
	
	assign	data_o_en = data_i_en;
	//--------------R4 butterfly logic--------------------//
	assign data_o_0 = data_i_0 + data_i_1 + data_i_2 + data_i_3;
	assign data_o_1 = data_i_0 + N_Imag_Mux(data_i_1) - data_i_2 + P_Imag_Mux(data_i_3);
	assign data_o_2 = data_i_0 - data_i_1 + data_i_2 - data_i_3;
	assign data_o_3 = data_i_0 + P_Imag_Mux(data_i_1) - data_i_2 + N_Imag_Mux(data_i_3);

endmodule
