%% 采样参数
Fs=1e3;
T=1/Fs;        
length = 1024;
t=(0:length-1)*T;

M = zeros(length,1);
M_dec = zeros(length,1);
%% 生成测试信号
f1 = 200;
f2 = 300;
s1 = cos(2*pi*f1*t);    
s2 = cos(2*pi*f2*t);
signalN = s1 + s2 ;
data_before_fft = fix(1000*signalN);  %系数放大1000倍
%% 生成输入数据txt，让fpga调用
fp = fopen('..\..\1_SourceCode\vivado2018.3_prj\SDF_FFT_1024.sim\sim_1\behav\xsim\data_before_fft.txt','w');
for i = 1:length
   if(data_before_fft(i)>=0)
       temp= dec2bin(data_before_fft(i),32);
   else
       temp= dec2bin(data_before_fft(i)+2^32, 32);
   end
    for j=1:32
        fprintf(fp,'%s',temp(j));
    end
    fprintf(fp,'00000000000000000000000000000000'); %虚部补0
    fprintf(fp,'\r\n');
end
fclose(fp);
%% 把测试信号fft
data_after_fft1 = DIF_FFT_2(data_before_fft, 1024);
data_after_fft = data_after_fft1.';
data_real = fix(real(data_after_fft));
data_imag = fix(imag(data_after_fft));
%% 生成测试结果txt
fp_real = fopen('..\..\1_SourceCode\vivado2018.3_prj\SDF_FFT_1024.sim\sim_1\behav\xsim\out_real.txt','w');
for i = 1:length
   if(data_real(i)>=0)
       temp_real= dec2bin(data_real(i),32);
   else
       temp_real= dec2bin(data_real(i)+2^32, 32);
   end
    for j=1:32
        fprintf(fp_real,'%s',temp_real(j));
    end
    fprintf(fp_real,'\r\n');
end
fp_imag = fopen('..\..\1_SourceCode\vivado2018.3_prj\SDF_FFT_1024.sim\sim_1\behav\xsim\out_imag.txt','w');
for i = 1:length
   if(data_imag(i)>=0)
       temp_imag= dec2bin(data_imag(i),32);
   else
       temp_imag= dec2bin(data_imag(i)+2^32, 32);
   end
    for j=1:32
        fprintf(fp_imag,'%s',temp_imag(j));
    end
    fprintf(fp_imag,'\r\n');
end
%% 画理想fft频谱图
n = 0:(length-1);
N = bitrevorder(n);

%M = str2num(trdec(12,4));


for i = 1:length
    data_after_fft2(i)=data_after_fft1(N(i)+1);
end
P2 = abs(data_after_fft2/length);
P1 = P2(1:length/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(length/2))/length;
subplot(2,1,1)
plot(f,P1)
xlabel('f/(hz)');
ylabel('Am/(mV)');
title('matlab fft 频谱图');
%% 画流水线fft频谱图
data_real_1 = load('..\..\1_SourceCode\vivado2018.3_prj\SDF_FFT_1024.sim\sim_1\behav\xsim\test_real_out.txt');
data_imag_1 = load('..\..\1_SourceCode\vivado2018.3_prj\SDF_FFT_1024.sim\sim_1\behav\xsim\test_imag_out.txt');
data_after_fft3 = complex(data_real_1, data_imag_1);
for i = 2 : length
    Mstr = (trdec(i-1,4));
    X = str2num(Mstr);
    XX = num2str(X,'%05d');
    M(i,1) = str2num(XX);
    M_Flip = flip(XX);    
    M_dec(i,1) = base2dec(M_Flip,4);
end
M_dec(1,1) = 0;
for i = 1:length

    
    %data_after_fft4(i)=data_after_fft3(N(i)+1);
    data_after_fft4(i)=data_after_fft3(M_dec(i,1)+1);
end

%data_after_fft4(1)=data_after_fft3(1);
P4 = abs(data_after_fft4/length);
P3 = P4(1:length/2+1);
P3(2:end-1) = 2*P3(2:end-1);
f1 = Fs*(0:(length/2))/length;
subplot(2,1,2) 
plot(f1,P3)
xlabel('f/(hz)');
ylabel('Am/(mV)');
title('流水线 fft 频谱图');
%% 计算信噪比
snr = SNR_singlech(P2, P4);
%% 基2 DIF FFT函数
function [Xk]=DIF_FFT_2(xn,N);
M=log2(N);
for m=0:M-1
    Num_of_Group=2^m;
    Interval_of_Group=N/2^m;
    Interval_of_Unit=N/2^(m+1);
    Cycle_Count=N/2^(m+1)-1;
    Wn=exp(-j*2*pi/Interval_of_Group);
    for g=1:Num_of_Group 
        Interval_1=(g-1)*Interval_of_Group;
        Interval_2=(g-1)*Interval_of_Group+Interval_of_Unit;
        for r=0:Cycle_Count;
            k=r+1;
            xn(k+Interval_1)=xn(k+Interval_1)+xn(k+Interval_2);
            xn(k+Interval_2)=[xn(k+Interval_1)-xn(k+Interval_2)-xn(k+Interval_2)]*Wn^r;
        end
    end
end
Xk = xn;
end
%% 信噪比计算函数
function snr=SNR_singlech(I,In)
    % 计算信噪比函数
    % I :original signal
    % In:noisy signal(ie. original signal + noise signal)
    snr=0;
    Ps=sum(sum((I-mean(mean(I))).^2));%signal power
    Pn=sum(sum((I-In).^2)); %noise power
    snr=10*log10(Ps/Pn);
end
