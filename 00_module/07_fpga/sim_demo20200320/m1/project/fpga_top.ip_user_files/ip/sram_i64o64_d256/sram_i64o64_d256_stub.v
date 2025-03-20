// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Thu Feb  6 16:06:03 2025
// Host        : DESKTOP-OBM7L7C running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               g:/00_module/07_fpga/sim_demo20200320/rtl/00_xilinx_ip/0_sbram/sram_i64o64_d256/sram_i64o64_d256_stub.v
// Design      : sram_i64o64_d256
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7k325tffg676-2
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *)
module sram_i64o64_d256(clka, wea, addra, dina, clkb, rstb, addrb, doutb, 
  rsta_busy, rstb_busy)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[7:0],dina[63:0],clkb,rstb,addrb[7:0],doutb[63:0],rsta_busy,rstb_busy" */;
  input clka;
  input [0:0]wea;
  input [7:0]addra;
  input [63:0]dina;
  input clkb;
  input rstb;
  input [7:0]addrb;
  output [63:0]doutb;
  output rsta_busy;
  output rstb_busy;
endmodule
