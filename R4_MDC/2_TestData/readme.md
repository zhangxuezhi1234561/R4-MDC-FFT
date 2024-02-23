data_before_fft.txt：输入波形数据，格式为64bit位宽二进制数，由高32位的实部二进制补码和低32位虚部二进制补码拼接而成（虚部全为0），ip输出的data数据和输入数据格式相同。

out_real.txt和out_imag.txt：理想输出值（已作取整处理）

test_real_out.txt和test_imag_out.txt：流水线输出值（已作取整处理）