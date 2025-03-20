// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Fri Feb  7 14:40:51 2025
// Host        : DESKTOP-OBM7L7C running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ sfifo_i72o72_d512_stub.v
// Design      : sfifo_i72o72_d512
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "fifo_generator_v13_2_5,Vivado 2021.1" *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix(clk, srst, din, wr_en, rd_en, dout, full, almost_full, 
  empty, almost_empty, data_count)
/* synthesis syn_black_box black_box_pad_pin="clk,srst,din[71:0],wr_en,rd_en,dout[71:0],full,almost_full,empty,almost_empty,data_count[11:0]" */;
  input clk;
  input srst;
  input [71:0]din;
  input wr_en;
  input rd_en;
  output [71:0]dout;
  output full;
  output almost_full;
  output empty;
  output almost_empty;
  output [11:0]data_count;
endmodule
