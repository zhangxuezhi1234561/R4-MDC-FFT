`timescale 1ns / 1ps

//有使能信号时，该模块才进行工作，包括计数、数据交�?

module Data_Convert #(
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
    //output  wire                                    data_sel
);
	//-----------------------local parameter-----------------------//
	localparam  STAGE_ALL = ($clog2(DATA_NUM))/2; 
	localparam	st0 = 0, st1 = 1, st2 = 2, st3 = 3; 

	//---------------reg define---------------//
	reg		[2*(STAGE_ALL-STAGE_ID) : 0]			data_i_cnt;
	reg                                    data_o_en_reg;
	reg		[2*(STAGE_ALL-STAGE_ID) : 0]			data_i_cnt_temp;
	reg		[3 : 0]									PST;
	reg    [3 : 0]                                 next_state;
	reg    signed  [DATA_WIDTH-1 : 0]              data_o_0_reg;
	reg    signed  [DATA_WIDTH-1 : 0]              data_o_1_reg;
	reg    signed  [DATA_WIDTH-1 : 0]              data_o_2_reg;
	reg    signed  [DATA_WIDTH-1 : 0]              data_o_3_reg;
	
	//--------------wire define-------------//
	wire						data_sel;
	wire							data_sel_temp;
	always @(posedge clk or negedge rstn)begin
		if(!rstn)begin
			data_i_cnt_temp <= 'd0;
			data_i_cnt       <= 'd0;
			PST		   <= st0;
		end
		else if(data_i_en)begin
			data_i_cnt <= data_i_cnt + 1'd1;
		end
		else begin
			data_i_cnt <= data_i_cnt;
		end
	end
	
	assign data_sel = data_i_cnt[2*(STAGE_ALL-STAGE_ID)];	
	/**/
    always @(posedge clk) begin
        data_o_en_reg   <= data_i_en;
    end
	assign data_o_en = data_o_en_reg;
	always @(data_sel)begin					//状�?�机切换
	   if(data_i_en)begin
            case(PST)
                st0 : PST <= st1;
                st1 : PST <= st2;
                st2 : PST <= st3;
                st3 : PST <= st0;
                default : PST <= st0;
            endcase
         end
       else begin
            PST <= PST;
       end
	 end
	   
	
	always @(posedge clk or negedge rstn)begin
	   if(!rstn)begin
	       data_o_0_reg <= {DATA_WIDTH{1'bx}}; data_o_1_reg <= {DATA_WIDTH{1'bx}}; data_o_2_reg <= {DATA_WIDTH{1'bx}}; data_o_3_reg <= {DATA_WIDTH{1'bx}};
	   end
		else if(data_i_en)begin
			case (PST)
				st0 : begin data_o_0_reg <= data_i_0; data_o_1_reg <= data_i_3; data_o_2_reg <= data_i_2; data_o_3_reg <= data_i_1;end
				st1 : begin data_o_0_reg <= data_i_1; data_o_1_reg <= data_i_0; data_o_2_reg <= data_i_3; data_o_3_reg <= data_i_2;end
				st2 : begin data_o_0_reg <= data_i_2; data_o_1_reg <= data_i_1; data_o_2_reg <= data_i_0; data_o_3_reg <= data_i_3;end
				st3 : begin data_o_0_reg <= data_i_3; data_o_1_reg <= data_i_2; data_o_2_reg <= data_i_1; data_o_3_reg <= data_i_0;end
				default : begin data_o_0_reg <= {DATA_WIDTH{1'bx}}; data_o_1_reg <= {DATA_WIDTH{1'bx}}; data_o_2_reg <= {DATA_WIDTH{1'bx}}; data_o_3_reg <= {DATA_WIDTH{1'bx}};end
			endcase
		end
		else begin
			data_o_0_reg <= {DATA_WIDTH{1'bx}}; data_o_1_reg <= {DATA_WIDTH{1'bx}}; data_o_2_reg <= {DATA_WIDTH{1'bx}}; data_o_3_reg <= {DATA_WIDTH{1'bx}};
		end
	end	
	assign data_o_0 = data_o_0_reg;
	assign data_o_1 = data_o_1_reg;
	assign data_o_2 = data_o_2_reg;
	assign data_o_3 = data_o_3_reg;
	
endmodule