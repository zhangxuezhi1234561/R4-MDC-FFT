`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/04/14 15:15:25
// Design Name:
// Module Name: tb_sdf_fft_1024_top
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


module tb_mdc_fft_1024_top();

    parameter   integer     DATA_NUM            = 1024;         //number of fft data
    parameter   integer     DATA_WIDTH          = 64;           //input data width, half real half image
    parameter   integer     TWIDDLE_WIDTH       = 64;           //twiddle width, half real half image
    parameter   integer     TWIDDLE_SCALE_SHIFT = 16;           //left shift tiddle to scale

    parameter   CYC_TIME = 20.0;

    reg                                     clk;
    reg                                     rstn;
    reg                                     data_i_en;
    reg     signed  [DATA_WIDTH-1 : 0]      data_i_0;
	reg     signed  [DATA_WIDTH-1 : 0]      data_i_1;
	reg     signed  [DATA_WIDTH-1 : 0]      data_i_2;
	reg     signed  [DATA_WIDTH-1 : 0]      data_i_3;
    wire                                    data_o_en;
    wire    signed  [DATA_WIDTH-1 : 0]      data_o_0;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_1;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_2;
	wire    signed  [DATA_WIDTH-1 : 0]      data_o_3;

    integer     i, j, sub_real, sub_imag,k;
    integer     fo_real, fo_imag;

    reg     signed  [DATA_WIDTH-1 : 0]      mem_data_i  [0 : DATA_NUM-1];
    reg     signed  [DATA_WIDTH/2-1 : 0]    mem_fft_real [0 : DATA_NUM-1];
    reg     signed  [DATA_WIDTH/2-1 : 0]    mem_fft_imag [0 : DATA_NUM-1];

    reg     signed  [DATA_WIDTH/2-1 : 0]    data_o_real [0 : DATA_NUM-1];
    reg     signed  [DATA_WIDTH/2-1 : 0]    data_o_imag [0 : DATA_NUM-1];    
    reg     signed  [DATA_WIDTH/2-1 : 0]    fft_o_real;
    //reg     signed  [DATA_WIDTH/2-1 : 0]    data_o_imag;
    reg     signed  [DATA_WIDTH/2-1 : 0]    fft_o_imag;

    always #(CYC_TIME/2.0) clk = ~clk;

    //-----------------------load data-----------------------//
    initial begin
        clk = 0;
        rstn = 0;
        data_i_en = 0;
        @(posedge clk);
        rstn = 1;
        @(posedge clk);
        $readmemb("../../../../SDF_FFT_1024.sim/sim_1/behav/xsim/data_before_fft.txt", mem_data_i);
        for(i = 0; i < DATA_NUM/4; i = i + 1)begin
            @(posedge clk);
            data_i_0 = mem_data_i[i];
			data_i_1 = mem_data_i[i+256];
			data_i_2 = mem_data_i[i+512];
			data_i_3 = mem_data_i[i+768];
            data_i_en = 1;
        end
        @(posedge clk);
        data_i_en = 0;
        #21000;
        $display("Sim finished!");
        $finish();
    end

    //-----------------------compare data and generate file-----------------------//
    initial begin
        fo_real = $fopen("../../../../SDF_FFT_1024.sim/sim_1/behav/xsim/test_real_out.txt", "w"); //生成real数据输出文件给matlab进行比较
        fo_imag = $fopen("../../../../SDF_FFT_1024.sim/sim_1/behav/xsim/test_imag_out.txt", "w"); //生成imag数据输出文件给matlab进行比较
        $readmemb("../../../../SDF_FFT_1024.sim/sim_1/behav/xsim/out_real.txt", mem_fft_real);
        $readmemb("../../../../SDF_FFT_1024.sim/sim_1/behav/xsim/out_imag.txt", mem_fft_imag);
        @(posedge data_o_en);#1;
        for(j = 0; j < DATA_NUM/4; j = j + 1)begin
            //--real test
            data_o_real[j] = data_o_0[63 : 32];
            fft_o_real  = mem_fft_real[j];
            if(data_o_real[j] <= fft_o_real)begin
                sub_real = fft_o_real - data_o_real[j];
            end
            else begin
                sub_real = data_o_real[j] - fft_o_real;
            end
            if(sub_real >= 200)begin
                $display("num %.2d is warning!true_real = %.2d, mydata_real = %.2d\n", j, fft_o_real, data_o_real[j]);
            end		
            $fwrite(fo_real, "%.2d\n", data_o_real[j]);	
            data_o_real[j+1] = data_o_1[63 : 32];
            fft_o_real  = mem_fft_real[j+1];
            if(data_o_real[j+1] <= fft_o_real)begin
                sub_real = fft_o_real - data_o_real[j+1];
            end
            else begin
                sub_real = data_o_real[j+1] - fft_o_real;
            end
            if(sub_real >= 200)begin
                $display("num %.2d is warning!true_real = %.2d, mydata_real = %.2d\n", j, fft_o_real, data_o_real[j+1]);
            end	
            $fwrite(fo_real, "%.2d\n", data_o_real[j+1]);
            data_o_real[j+2] = data_o_2[63 : 32];
            fft_o_real  = mem_fft_real[j+2];
            if(data_o_real[j+2] <= fft_o_real)begin
                sub_real = fft_o_real - data_o_real[j+2];
            end
            else begin
                sub_real = data_o_real[j+2] - fft_o_real;
            end
            if(sub_real >= 200)begin
                $display("num %.2d is warning!true_real = %.2d, mydata_real = %.2d\n", j, fft_o_real, data_o_real[j+2]);
            end	
            $fwrite(fo_real, "%.2d\n", data_o_real[j+2]);
            data_o_real[j+3] = data_o_3[63 : 32];
            fft_o_real  = mem_fft_real[j+3];
            if(data_o_real[j+3] <= fft_o_real)begin
                sub_real = fft_o_real - data_o_real[j+3];
            end
            else begin
                sub_real = data_o_real[j+3] - fft_o_real;
            end			
            if(sub_real >= 200)begin
                $display("num %.2d is warning!true_real = %.2d, mydata_real = %.2d\n", j, fft_o_real, data_o_real[j+3]);
            end
            $fwrite(fo_real, "%.2d\n", data_o_real[j+3]);
            
            //--imag test
            data_o_imag[j] = data_o_0[31 : 0];
            fft_o_imag  = mem_fft_imag[j];
            if(data_o_imag[j] <= fft_o_imag)begin
                sub_imag = fft_o_imag - data_o_imag[j];
            end
            else begin
                sub_imag = data_o_imag[j] - fft_o_imag;
            end
            if(sub_imag >= 200)begin
                $display("num %.2d is warning!true_imag = %.2d, mydata_imag = %.2d\n", j, fft_o_imag, data_o_imag[j]);
            end
            $fwrite(fo_imag, "%.2d\n", data_o_imag[j]);

			
            data_o_imag[j+1] = data_o_1[31 : 0];
            fft_o_imag  = mem_fft_imag[j+1];
            if(data_o_imag[j+1] <= fft_o_imag)begin
                sub_imag = fft_o_imag - data_o_imag[j+1];
            end
            else begin
                sub_imag = data_o_imag[j+1] - fft_o_imag;
            end
            if(sub_imag >= 200)begin
                $display("num %.2d is warning!true_imag = %.2d, mydata_imag = %.2d\n", j, fft_o_imag, data_o_imag[j+1]);
            end
            $fwrite(fo_imag, "%.2d\n", data_o_imag[j+1]);

            data_o_imag[j+2] = data_o_2[31 : 0];
            fft_o_imag  = mem_fft_imag[j+2];
            if(data_o_imag[j+2] <= fft_o_imag)begin
                sub_imag = fft_o_imag - data_o_imag[j+2];
            end
            else begin
                sub_imag = data_o_imag[j+2] - fft_o_imag;
            end
            if(sub_imag >= 200)begin
                $display("num %.2d is warning!true_imag = %.2d, mydata_imag = %.2d\n", j, fft_o_imag, data_o_imag[j+2]);
            end
            $fwrite(fo_imag, "%.2d\n", data_o_imag[j+2]);

            data_o_imag[j+3] = data_o_3[31 : 0];
            fft_o_imag  = mem_fft_imag[j+3];
            if(data_o_imag[j+3] <= fft_o_imag)begin
                sub_imag = fft_o_imag - data_o_imag[j+3];
            end
            else begin
                sub_imag = data_o_imag[j+3] - fft_o_imag;
            end
            if(sub_imag >= 200)begin
                $display("num %.2d is warning!true_imag = %.2d, mydata_imag = %.2d\n", j, fft_o_imag, data_o_imag[j+3]);
            end	
            $fwrite(fo_imag, "%.2d\n", data_o_imag[j+3]);
			//@(posedge clk);#1;
            //--write file
            @(posedge clk);#1;
            
        end
    end
    /*
    initial begin
        fo_real = $fopen("../../../../SDF_FFT_1024.sim/sim_1/behav/xsim/test_real_out.txt", "w"); //生成real数据输出文件给matlab进行比较
        fo_imag = $fopen("../../../../SDF_FFT_1024.sim/sim_1/behav/xsim/test_imag_out.txt", "w"); //生成imag数据输出文件给matlab进行比较    
        for(k=0;k<DATA_NUM;k=k+1) begin
           // fo_real = $fopen("../../../../SDF_FFT_1024.sim/sim_1/behav/xsim/test_real_out.txt", "w"); //生成real数据输出文件给matlab进行比较
           // fo_imag = $fopen("../../../../SDF_FFT_1024.sim/sim_1/behav/xsim/test_imag_out.txt", "w"); //生成imag数据输出文件给matlab进行比较
            $fwrite(fo_real, "%.2d\n", data_o_real[k]);
            $fwrite(fo_imag, "%.2d\n", data_o_imag[k]);
        end
    end
*/
    mdc_fft_1024_top #(
            .DATA_NUM(DATA_NUM),
            .DATA_WIDTH(DATA_WIDTH),
            .TWIDDLE_WIDTH(TWIDDLE_WIDTH),
            .TWIDDLE_SCALE_SHIFT(TWIDDLE_SCALE_SHIFT)
        ) inst_mdc_fft_1024_top (
            .clk       (clk),
            .rstn      (rstn),
            .data_i_en (data_i_en),
			.data_i_0	(data_i_0),
			.data_i_1	(data_i_1),
			.data_i_2	(data_i_2),
			.data_i_3	(data_i_3),
			.data_o_en	(data_o_en),
			.data_o_0	(data_o_0),
			.data_o_1	(data_o_1),
			.data_o_2	(data_o_2),
			.data_o_3	(data_o_3)
        );

endmodule



