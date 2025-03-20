// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Thu Feb  6 15:57:19 2025
// Host        : DESKTOP-OBM7L7C running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               g:/00_module/07_fpga/sim_demo20200320/rtl/00_xilinx_ip/1_afifo/afifo_i90o90_d512/afifo_i90o90_d512_stub.v
// Design      : afifo_i90o90_d512
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2021.1" *)
module afifo_i90o90_d512(rst, wr_clk, rd_clk, din, wr_en, rd_en, dout, full, 
  almost_full, empty, almost_empty, rd_data_count, wr_data_count)
/* synthesis syn_black_box black_box_pad_pin="rst,wr_clk,rd_clk,din[89:0],wr_en,rd_en,dout[89:0],full,almost_full,empty,almost_empty,rd_data_count[8:0],wr_data_count[8:0]" */;
  input rst;
  input wr_clk;
  input rd_clk;
  input [89:0]din;
  input wr_en;
  input rd_en;
  output [89:0]dout;
  output full;
  output almost_full;
  output empty;
  output almost_empty;
  output [8:0]rd_data_count;
  output [8:0]wr_data_count;
endmodule
