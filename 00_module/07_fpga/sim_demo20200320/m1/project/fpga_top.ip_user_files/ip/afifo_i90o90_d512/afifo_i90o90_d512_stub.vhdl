-- Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
-- Date        : Thu Feb  6 15:57:19 2025
-- Host        : DESKTOP-OBM7L7C running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode synth_stub
--               g:/00_module/07_fpga/sim_demo20200320/rtl/00_xilinx_ip/1_afifo/afifo_i90o90_d512/afifo_i90o90_d512_stub.vhdl
-- Design      : afifo_i90o90_d512
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7k325tffg676-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity afifo_i90o90_d512 is
  Port ( 
    rst : in STD_LOGIC;
    wr_clk : in STD_LOGIC;
    rd_clk : in STD_LOGIC;
    din : in STD_LOGIC_VECTOR ( 89 downto 0 );
    wr_en : in STD_LOGIC;
    rd_en : in STD_LOGIC;
    dout : out STD_LOGIC_VECTOR ( 89 downto 0 );
    full : out STD_LOGIC;
    almost_full : out STD_LOGIC;
    empty : out STD_LOGIC;
    almost_empty : out STD_LOGIC;
    rd_data_count : out STD_LOGIC_VECTOR ( 8 downto 0 );
    wr_data_count : out STD_LOGIC_VECTOR ( 8 downto 0 )
  );

end afifo_i90o90_d512;

architecture stub of afifo_i90o90_d512 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "rst,wr_clk,rd_clk,din[89:0],wr_en,rd_en,dout[89:0],full,almost_full,empty,almost_empty,rd_data_count[8:0],wr_data_count[8:0]";
attribute x_core_info : string;
attribute x_core_info of stub : architecture is "fifo_generator_v13_2_5,Vivado 2021.1";
begin
end;
