`timescale 1ns / 1ps

module	After_Convert #(
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
    output  wire    signed  [DATA_WIDTH-1 : 0]      data_o_0,//四个输出通道
	output  wire    signed  [DATA_WIDTH-1 : 0]      data_o_1,
	output  wire    signed  [DATA_WIDTH-1 : 0]      data_o_2,
	output  wire    signed  [DATA_WIDTH-1 : 0]      data_o_3
  //  output  wire                                    data_sel

);
	//---------------local parameter----------------//
	localparam  STAGE_ALL = ($clog2(DATA_NUM))/2;               //number of all pipeline stage �?4，级数少�?�?
    localparam  DELAY_N0 = 3 * 4**(STAGE_ALL-STAGE_ID);          //delay depth  
	localparam  DELAY_N1 = 2 * 4**(STAGE_ALL-STAGE_ID);          //delay depth	
	localparam  DELAY_N2 = 1 * 4**(STAGE_ALL-STAGE_ID);          //delay depth	
	
	//-----------------------wire define-------------------------//
	wire						data_o_en_0;
	wire						data_o_en_1;
	wire						data_o_en_2;
	
	assign	data_o_en = data_i_en & data_o_en_0 & data_o_en_1 & data_o_en_2;
	assign	data_o_3 = data_i_3;
	
	//通道0数据延迟
	delay_buffer #(
        .DEPTH(DELAY_N0),
        .DATA_WIDTH(DATA_WIDTH)
    ) inst_data_i_0_buffer(
        .clk(clk),
        .data_i(data_i_0),
        .data_o(data_o_0)
    );
	//通道0使能延迟
	delay_buffer #(
        .DEPTH(DELAY_N0),
        .DATA_WIDTH(1)
    ) inst_data_o_en_0_buffer(
        .clk(clk),
        .data_i(data_i_en),
        .data_o(data_o_en_0)
    );	
	
	delay_buffer #(
        .DEPTH(DELAY_N1),
        .DATA_WIDTH(DATA_WIDTH)
    ) inst_data_i_1_buffer(
        .clk(clk),
        .data_i(data_i_1),
        .data_o(data_o_1)
    );
	delay_buffer #(
        .DEPTH(DELAY_N1),
        .DATA_WIDTH(1)
    ) inst_data_o_en_1_buffer(
        .clk(clk),
        .data_i(data_i_en),
        .data_o(data_o_en_1)
    );	
	
	delay_buffer #(
        .DEPTH(DELAY_N2),
        .DATA_WIDTH(DATA_WIDTH)
    ) inst_data_i_2_buffer(
        .clk(clk),
        .data_i(data_i_2),
        .data_o(data_o_2)
    );
	delay_buffer #(
        .DEPTH(DELAY_N2),
        .DATA_WIDTH(1)
    ) inst_data_o_en_2_buffer(
        .clk(clk),
        .data_i(data_i_en),
        .data_o(data_o_en_2)
    );		
endmodule
	