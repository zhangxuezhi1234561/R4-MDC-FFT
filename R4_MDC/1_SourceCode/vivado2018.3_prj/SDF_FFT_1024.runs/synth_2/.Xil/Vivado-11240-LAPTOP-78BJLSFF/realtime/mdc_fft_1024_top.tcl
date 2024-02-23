# 
# Synthesis run script generated by Vivado
# 

namespace eval rt {
    variable rc
}
set rt::rc [catch {
  uplevel #0 {
    set ::env(BUILTIN_SYNTH) true
    source $::env(HRT_TCL_PATH)/rtSynthPrep.tcl
    rt::HARTNDb_resetJobStats
    rt::HARTNDb_resetSystemStats
    rt::HARTNDb_startSystemStats
    rt::HARTNDb_startJobStats
    set rt::cmdEcho 0
    rt::set_parameter writeXmsg true
    rt::set_parameter enableParallelHelperSpawn true
    set ::env(RT_TMP) "E:/postgraduate/contest/LongX/A7/��Ʒ�ύ�ĵ�/90013835Դ��/R4_MDC/1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.runs/synth_2/.Xil/Vivado-11240-LAPTOP-78BJLSFF/realtime/tmp"
    if { [ info exists ::env(RT_TMP) ] } {
      file delete -force $::env(RT_TMP)
      file mkdir $::env(RT_TMP)
    }

    rt::delete_design

    rt::set_parameter datapathDensePacking false
    set rt::partid xcvu095-ffva2104-2-i
    source $::env(HRT_TCL_PATH)/rtSynthParallelPrep.tcl
     file delete -force synth_hints.os

    set rt::multiChipSynthesisFlow false
    source $::env(SYNTH_COMMON)/common.tcl
    set rt::defaultWorkLibName xil_defaultlib

    set rt::useElabCache false
    if {$rt::useElabCache == false} {
      rt::read_verilog {
      E:/postgraduate/contest/LongX/A7/��Ʒ�ύ�ĵ�/90013835Դ��/R4_MDC/1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.srcs/sources_1/new/butterfly.v
      E:/postgraduate/contest/LongX/A7/��Ʒ�ύ�ĵ�/90013835Դ��/R4_MDC/1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.srcs/sources_1/new/complex_mul.v
      E:/postgraduate/contest/LongX/A7/��Ʒ�ύ�ĵ�/90013835Դ��/R4_MDC/1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.srcs/sources_1/new/mdc_unit.v
      E:/postgraduate/contest/LongX/A7/��Ʒ�ύ�ĵ�/90013835Դ��/R4_MDC/1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.srcs/sources_1/new/twiddle_rom_1024.v
      E:/postgraduate/contest/LongX/A7/��Ʒ�ύ�ĵ�/90013835Դ��/R4_MDC/1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.srcs/sources_1/new/mdc_fft_1024_top.v
      E:/postgraduate/contest/LongX/A7/��Ʒ�ύ�ĵ�/90013835Դ��/R4_MDC/1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.srcs/sources_1/new/After_Convert.v
      E:/postgraduate/contest/LongX/A7/��Ʒ�ύ�ĵ�/90013835Դ��/R4_MDC/1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.srcs/sources_1/new/delay_buffer.v
      E:/postgraduate/contest/LongX/A7/��Ʒ�ύ�ĵ�/90013835Դ��/R4_MDC/1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.srcs/sources_1/new/Before_Convert.v
      E:/postgraduate/contest/LongX/A7/��Ʒ�ύ�ĵ�/90013835Դ��/R4_MDC/1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.srcs/sources_1/new/Data_Convert.v
    }
      rt::filesetChecksum
    }
    rt::set_parameter usePostFindUniquification false
    set rt::top mdc_fft_1024_top
    rt::set_parameter enableIncremental true
    rt::set_parameter markDebugPreservationLevel "enable"
    set rt::reportTiming false
    rt::set_parameter elaborateOnly false
    rt::set_parameter elaborateRtl false
    rt::set_parameter eliminateRedundantBitOperator true
    rt::set_parameter elaborateRtlOnlyFlow false
    rt::set_parameter writeBlackboxInterface true
    rt::set_parameter ramStyle auto
    rt::set_parameter merge_flipflops true
# MODE: 
    rt::set_parameter webTalkPath {E:/postgraduate/contest/LongX/A7/��Ʒ�ύ�ĵ�/90013835Դ��/R4_MDC/1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.cache/wt}
    rt::set_parameter synthDebugLog false
    rt::set_parameter printModuleName false
    rt::set_parameter enableSplitFlowPath "E:/postgraduate/contest/LongX/A7/��Ʒ�ύ�ĵ�/90013835Դ��/R4_MDC/1_SourceCode/vivado2018.3_prj/SDF_FFT_1024.runs/synth_2/.Xil/Vivado-11240-LAPTOP-78BJLSFF/"
    set ok_to_delete_rt_tmp true 
    if { [rt::get_parameter parallelDebug] } { 
       set ok_to_delete_rt_tmp false 
    } 
    if {$rt::useElabCache == false} {
        set oldMIITMVal [rt::get_parameter maxInputIncreaseToMerge]; rt::set_parameter maxInputIncreaseToMerge 1000
        set oldCDPCRL [rt::get_parameter createDfgPartConstrRecurLimit]; rt::set_parameter createDfgPartConstrRecurLimit 1
        $rt::db readXRFFile
      rt::run_synthesis -module $rt::top
        rt::set_parameter maxInputIncreaseToMerge $oldMIITMVal
        rt::set_parameter createDfgPartConstrRecurLimit $oldCDPCRL
    }

    set rt::flowresult [ source $::env(SYNTH_COMMON)/flow.tcl ]
    rt::HARTNDb_stopJobStats
    rt::HARTNDb_reportJobStats "Synthesis Optimization Runtime"
    rt::HARTNDb_stopSystemStats
    if { $rt::flowresult == 1 } { return -code error }


  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  rt::set_parameter helper_shm_key "" 
    if { [ info exists ::env(RT_TMP) ] } {
      if { [info exists ok_to_delete_rt_tmp] && $ok_to_delete_rt_tmp } { 
        file delete -force $::env(RT_TMP)
      }
    }

    source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  } ; #end uplevel
} rt::result]

if { $rt::rc } {
  $rt::db resetHdlParse
  set hsKey [rt::get_parameter helper_shm_key] 
  if { $hsKey != "" && [info exists ::env(BUILTIN_SYNTH)] && [rt::get_parameter enableParallelHelperSpawn] } { 
     $rt::db killSynthHelper $hsKey
  } 
  source $::env(HRT_TCL_PATH)/rtSynthCleanup.tcl
  return -code "error" $rt::result
}