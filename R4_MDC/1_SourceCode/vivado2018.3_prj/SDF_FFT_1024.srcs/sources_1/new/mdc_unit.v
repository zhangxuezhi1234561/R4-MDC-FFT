`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/13 15:28:50
// Design Name:
// Module Name: sdf_unit
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


module mdc_unit#(
    parameter   integer     DATA_NUM            = 1024,        //number of fft data
    parameter   integer     STAGE_ID            = 1,        //stage id of this BF2
    parameter   integer     DATA_WIDTH          = 64,       //input data width, half real half image
    parameter   integer     TWIDDLE_WIDTH       = 64,       //twiddle width, half real half image
    parameter   integer     TWIDDLE_SCALE_SHIFT = 16        //left shift tiddle to scale
)(
    input   wire                                    clk,
    input   wire                                    rstn,
    input   wire                                    data_i_en,
    input   wire    signed  [DATA_WIDTH-1 : 0]      data_i_0,//四个输入通道
	input   wire    signed  [DATA_WIDTH-1 : 0]      data_i_1,
	input   wire    signed  [DATA_WIDTH-1 : 0]      data_i_2,
	input   wire    signed  [DATA_WIDTH-1 : 0]      data_i_3,
    output  wire                                    mul_o_en,
    output  wire    signed  [DATA_WIDTH-1 : 0]      mul_o_0,
	output  wire    signed  [DATA_WIDTH-1 : 0]      mul_o_1,
	output  wire    signed  [DATA_WIDTH-1 : 0]      mul_o_2,
	output  wire    signed  [DATA_WIDTH-1 : 0]      mul_o_3
);

    //-----------------------local parameter-----------------------//
    localparam  STAGE_ALL = ($clog2(DATA_NUM))/2;               //number of all pipeline stage
	localparam	Addr_Circle_Num	= DATA_NUM>>(2*(STAGE_ID));

    //-----------------------wire define-----------------------//
    wire    signed  [DATA_WIDTH-1 : 0]      bf_data_o_0;
	wire    signed  [DATA_WIDTH-1 : 0]      bf_data_o_1;
	wire    signed  [DATA_WIDTH-1 : 0]      bf_data_o_2;
	wire    signed  [DATA_WIDTH-1 : 0]      bf_data_o_3;
    wire    signed  [TWIDDLE_WIDTH-1 : 0]   twiddle_0;
	wire    signed  [TWIDDLE_WIDTH-1 : 0]   twiddle_1;
	wire    signed  [TWIDDLE_WIDTH-1 : 0]   twiddle_2;
	wire    signed  [TWIDDLE_WIDTH-1 : 0]   twiddle_3;
 //   wire                                    data_sel;
	//-----------------Before_Convert处理之后�?---------------------//
	wire    signed  [DATA_WIDTH-1 : 0]      Before_data_o_0;
	wire    signed  [DATA_WIDTH-1 : 0]      Before_data_o_1;
	wire    signed  [DATA_WIDTH-1 : 0]      Before_data_o_2;
	wire    signed  [DATA_WIDTH-1 : 0]      Before_data_o_3;
	wire									Before_o_en;

	//-----------------Data_Convert处理之后�?----------------------//
	wire    signed  [DATA_WIDTH-1 : 0]      Convert_data_o_0;
	wire    signed  [DATA_WIDTH-1 : 0]      Convert_data_o_1;
	wire    signed  [DATA_WIDTH-1 : 0]      Convert_data_o_2;
	wire    signed  [DATA_WIDTH-1 : 0]      Convert_data_o_3;
	wire									Convert_o_en;
	
	//-----------------After_Convert处理之后�?---------------------//
	wire    signed  [DATA_WIDTH-1 : 0]      After_data_o_0;
	wire    signed  [DATA_WIDTH-1 : 0]      After_data_o_1;
	wire    signed  [DATA_WIDTH-1 : 0]      After_data_o_2;
	wire    signed  [DATA_WIDTH-1 : 0]      After_data_o_3;
	wire									After_o_en;
    //-----------------------reg define-----------------------//
    reg             [2*STAGE_ALL-1 : 0]       twiddle_addr_0;
	reg             [2*STAGE_ALL-1 : 0]       twiddle_addr_1;
	reg             [2*STAGE_ALL-1 : 0]       twiddle_addr_2;
	reg             [2*STAGE_ALL-1 : 0]       twiddle_addr_3;
	

    //--------------------bf_data_o/mul_o_en 1 beat------------------//
    reg signed  [DATA_WIDTH-1 : 0]    bf_data_o_reg_0;
	reg signed  [DATA_WIDTH-1 : 0]    bf_data_o_reg_1;
	reg signed  [DATA_WIDTH-1 : 0]    bf_data_o_reg_2;
	reg signed  [DATA_WIDTH-1 : 0]    bf_data_o_reg_3;
    wire mul_o_en_temp1;
    reg mul_o_en_temp2;

    always @(posedge clk) begin
        bf_data_o_reg_0 <= bf_data_o_0;
		bf_data_o_reg_1 <= bf_data_o_1;
		bf_data_o_reg_2 <= bf_data_o_2;
		bf_data_o_reg_3 <= bf_data_o_3;
        mul_o_en_temp2 <= mul_o_en_temp1;
    end

    assign mul_o_en = mul_o_en_temp2;		
    //-----------------------calculate twiddle addr logic-----------------------//
    always @(posedge clk or negedge rstn)begin
        if(!rstn)begin
            twiddle_addr_0	<= 'd0;
        end
        else if(mul_o_en_temp1)begin
			twiddle_addr_0	<= 'd0;
        end
        else begin
            twiddle_addr_0	<= 'd0;
        end
        
        if(!rstn)begin
			twiddle_addr_1	<= 'd0;
        end
        else if(mul_o_en_temp1 && twiddle_addr_1 < 4**(STAGE_ID-1) * (Addr_Circle_Num-1))begin
			twiddle_addr_1	<= twiddle_addr_1 + 1*4**(STAGE_ID-1);
        end
        else begin
			twiddle_addr_1	<= 'd0;
        end
        
        if(!rstn)begin
            twiddle_addr_2  <= 'd0;
        end
        else if(mul_o_en_temp1 && twiddle_addr_2 < 2*4**(STAGE_ID-1)*(Addr_Circle_Num-1))begin
			twiddle_addr_2	<= twiddle_addr_2 + 2*4**(STAGE_ID-1);
        end
        else begin
			twiddle_addr_2	<= 'd0;
        end	
        
        if(!rstn)begin
            twiddle_addr_3  <= 'd0;
        end
        else if(mul_o_en_temp1 && twiddle_addr_3 < 3*4**(STAGE_ID-1)*(Addr_Circle_Num-1))begin
			twiddle_addr_3	<= twiddle_addr_3 + 3*4**(STAGE_ID-1);
        end
        else begin
			twiddle_addr_3	<= 'd0;
        end	
    end

    //---------instance-----------//
generate
	if(STAGE_ID==1)begin
		butterfly #(
			.DATA_NUM(DATA_NUM),
			.STAGE_ID(STAGE_ID),
			.DATA_WIDTH(DATA_WIDTH)	
		) inst_butterfly (
			.clk			(clk),
			.rstn			(rstn),
			.data_i_en		(data_i_en),
			.data_i_0		(data_i_0),
			.data_i_1		(data_i_1),
			.data_i_2		(data_i_2),
			.data_i_3		(data_i_3),
			.data_o_en		(mul_o_en_temp1),
			.data_o_0		(bf_data_o_0),
			.data_o_1		(bf_data_o_1),
			.data_o_2		(bf_data_o_2),
			.data_o_3		(bf_data_o_3)
		//	.data_sel		(data_sel)
		);
	end
	else begin
		Before_Convert #(
			.DATA_NUM(DATA_NUM),
			.STAGE_ID(STAGE_ID),
			.DATA_WIDTH(DATA_WIDTH)
		) inst_Before_Convert (
			.clk			(clk),
			.rstn			(rstn),
			.data_i_en		(data_i_en),
			.data_i_0		(data_i_0),
			.data_i_1		(data_i_1),
			.data_i_2		(data_i_2),
			.data_i_3		(data_i_3),
			.data_o_en		(Before_o_en),
			.data_o_0		(Before_data_o_0),
			.data_o_1		(Before_data_o_1),
			.data_o_2		(Before_data_o_2),
			.data_o_3		(Before_data_o_3)
			//.data_sel		(data_sel)
		);
		Data_Convert #(
			.DATA_NUM(DATA_NUM),
			.STAGE_ID(STAGE_ID),
			.DATA_WIDTH(DATA_WIDTH)
		) inst_Data_Convert (
			.clk			(clk),
			.rstn			(rstn),
			.data_i_en		(Before_o_en),
			.data_i_0		(Before_data_o_0),
			.data_i_1		(Before_data_o_1),
			.data_i_2		(Before_data_o_2),
			.data_i_3		(Before_data_o_3),
			.data_o_en		(Convert_o_en),
			.data_o_0		(Convert_data_o_0),
			.data_o_1		(Convert_data_o_1),
			.data_o_2		(Convert_data_o_2),
			.data_o_3		(Convert_data_o_3)
			//.data_sel		(data_sel)
		);
		After_Convert #(
			.DATA_NUM(DATA_NUM),
			.STAGE_ID(STAGE_ID),
			.DATA_WIDTH(DATA_WIDTH)
		) inst_After_Convert (
			.clk			(clk),
			.rstn			(rstn),
			.data_i_en		(Convert_o_en),
			.data_i_0		(Convert_data_o_0),
			.data_i_1		(Convert_data_o_1),
			.data_i_2		(Convert_data_o_2),
			.data_i_3		(Convert_data_o_3),
			.data_o_en		(After_o_en),
			.data_o_0		(After_data_o_0),
			.data_o_1		(After_data_o_1),
			.data_o_2		(After_data_o_2),
			.data_o_3		(After_data_o_3)
			//.data_sel		(data_sel)
		);
		butterfly #(
			.DATA_NUM(DATA_NUM),
			.STAGE_ID(STAGE_ID),
			.DATA_WIDTH(DATA_WIDTH)	
		) inst_butterfly (
			.clk			(clk),
			.rstn			(rstn),
			.data_i_en		(After_o_en),
			.data_i_0		(After_data_o_0),
			.data_i_1		(After_data_o_1),
			.data_i_2		(After_data_o_2),
			.data_i_3		(After_data_o_3),
			.data_o_en		(mul_o_en_temp1),
			.data_o_0		(bf_data_o_0),
			.data_o_1		(bf_data_o_1),
			.data_o_2		(bf_data_o_2),
			.data_o_3		(bf_data_o_3)
		//	.data_sel		(data_sel)
		);
	end
endgenerate
    // twiddle_1024 #(
    //     .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
    //     .ADDR_WIDTH(STAGE_ALL-2)
    // ) inst_twiddle_1024(
    //     .addr(twiddle_addr),
    //     .twiddle(twiddle)
    // );

    /*add twiddle_rom_1024*/
    twiddle_rom_1024 #(
        .TWIDDLE_WIDTH    ( TWIDDLE_WIDTH    ),
        .ADDR_WIDTH       ( 2*STAGE_ALL-1      ))
    u_twiddle_0_rom_1024 (
        .clk              ( clk             ),
        .en               ( 1'b1               ),
        .addr             ( twiddle_addr_0    ),
        .twiddle          ( twiddle_0         )
    );
    twiddle_rom_1024 #(
        .TWIDDLE_WIDTH    ( TWIDDLE_WIDTH    ),
        .ADDR_WIDTH       ( 2*STAGE_ALL-1      ))
    u_twiddle_1_rom_1024 (
        .clk              ( clk             ),
        .en               ( 1'b1               ),
        .addr             ( twiddle_addr_1    ),
        .twiddle          ( twiddle_1         )
    );    
    twiddle_rom_1024 #(
        .TWIDDLE_WIDTH    ( TWIDDLE_WIDTH    ),
        .ADDR_WIDTH       ( 2*STAGE_ALL-1       ))
    u_twiddle_2_rom_1024 (
        .clk              ( clk             ),
        .en               ( 1'b1               ),
        .addr             ( twiddle_addr_2    ),
        .twiddle          ( twiddle_2         )
    );    
    twiddle_rom_1024 #(
        .TWIDDLE_WIDTH    ( TWIDDLE_WIDTH    ),
        .ADDR_WIDTH       ( 2*STAGE_ALL-1       ))
    u_twiddle_3_rom_1024 (
        .clk              ( clk             ),
        .en               ( 1'b1               ),
        .addr             ( twiddle_addr_3    ),
        .twiddle          ( twiddle_3         )
    );
	
    complex_mul #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) inst_complex_mul_0 (
        .data_i    (bf_data_o_reg_0), /*change bf_data_o_reg*/
        .twiddle_i (twiddle_0),
        .mul_o     (mul_o_0)
    );

    complex_mul #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) inst_complex_mul_1 (
        .data_i    (bf_data_o_reg_1), /*change bf_data_o_reg*/
        .twiddle_i (twiddle_1),
        .mul_o     (mul_o_1)
    );
    complex_mul #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) inst_complex_mul_2 (
        .data_i    (bf_data_o_reg_2), /*change bf_data_o_reg*/
        .twiddle_i (twiddle_2),
        .mul_o     (mul_o_2)
    );
    complex_mul #(
        .DATA_WIDTH(DATA_WIDTH),
        .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
        .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
    ) inst_complex_mul_3 (
        .data_i    (bf_data_o_reg_3), /*change bf_data_o_reg*/
        .twiddle_i (twiddle_3),
        .mul_o     (mul_o_3)
    );	
endmodule
