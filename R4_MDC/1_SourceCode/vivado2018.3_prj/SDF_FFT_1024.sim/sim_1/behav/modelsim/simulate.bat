@echo off
REM ****************************************************************************
REM Vivado (TM) v2020.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Mentor Graphics ModelSim Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Thu Jul 13 17:16:07 +0800 2023
REM SW Build 3064766 on Wed Nov 18 09:12:45 MST 2020
REM
REM Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
set bin_path=E:\Modelsim\install\win64
call %bin_path%/vsim   -do "do {tb_mdc_fft_1024_top_simulate.do}" -l simulate.log
if "%errorlevel%"=="1" goto END
if "%errorlevel%"=="0" goto SUCCESS
:END
exit 1
:SUCCESS
exit 0
