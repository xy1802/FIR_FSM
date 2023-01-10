// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Tue Jan 10 16:59:53 2023
// Host        : DESKTOP-1CFBCAB running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/vivado_files/lizhibin/FIR_Simple/FIR_Simple.gen/sources_1/ip/fir250_45/fir250_45_stub.v
// Design      : fir250_45
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fir_compiler_v7_2_18,Vivado 2022.1" *)
module fir250_45(aclk, s_axis_data_tvalid, s_axis_data_tready, 
  s_axis_data_tlast, s_axis_data_tuser, s_axis_data_tdata, m_axis_data_tvalid, 
  m_axis_data_tready, m_axis_data_tlast, m_axis_data_tuser, m_axis_data_tdata, 
  event_s_data_chanid_incorrect)
/* synthesis syn_black_box black_box_pad_pin="aclk,s_axis_data_tvalid,s_axis_data_tready,s_axis_data_tlast,s_axis_data_tuser[2:0],s_axis_data_tdata[23:0],m_axis_data_tvalid,m_axis_data_tready,m_axis_data_tlast,m_axis_data_tuser[2:0],m_axis_data_tdata[39:0],event_s_data_chanid_incorrect" */;
  input aclk;
  input s_axis_data_tvalid;
  output s_axis_data_tready;
  input s_axis_data_tlast;
  input [2:0]s_axis_data_tuser;
  input [23:0]s_axis_data_tdata;
  output m_axis_data_tvalid;
  input m_axis_data_tready;
  output m_axis_data_tlast;
  output [2:0]m_axis_data_tuser;
  output [39:0]m_axis_data_tdata;
  output event_s_data_chanid_incorrect;
endmodule
