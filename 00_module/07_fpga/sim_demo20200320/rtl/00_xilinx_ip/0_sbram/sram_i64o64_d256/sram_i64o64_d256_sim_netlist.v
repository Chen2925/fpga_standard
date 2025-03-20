// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Thu Feb  6 16:06:03 2025
// Host        : DESKTOP-OBM7L7C running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               g:/00_module/07_fpga/sim_demo20200320/rtl/00_xilinx_ip/0_sbram/sram_i64o64_d256/sram_i64o64_d256_sim_netlist.v
// Design      : sram_i64o64_d256
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k325tffg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "sram_i64o64_d256,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
(* NotValidForBitStream *)
module sram_i64o64_d256
   (clka,
    wea,
    addra,
    dina,
    clkb,
    rstb,
    addrb,
    doutb,
    rsta_busy,
    rstb_busy);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [7:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [63:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTB, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clkb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB RST" *) input rstb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB ADDR" *) input [7:0]addrb;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTB DOUT" *) output [63:0]doutb;
  output rsta_busy;
  output rstb_busy;

  wire [7:0]addra;
  wire [7:0]addrb;
  wire clka;
  wire clkb;
  wire [63:0]dina;
  wire [63:0]doutb;
  wire rsta_busy;
  wire rstb;
  wire rstb_busy;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [63:0]NLW_U0_douta_UNCONNECTED;
  wire [7:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [7:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [63:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "8" *) 
  (* C_ADDRB_WIDTH = "8" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "1" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "1" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     6.966099 mW" *) 
  (* C_FAMILY = "kintex7" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "0" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "1" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "sram_i64o64_d256.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "1" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "256" *) 
  (* C_READ_DEPTH_B = "256" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "64" *) 
  (* C_READ_WIDTH_B = "64" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "256" *) 
  (* C_WRITE_DEPTH_B = "256" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "64" *) 
  (* C_WRITE_WIDTH_B = "64" *) 
  (* C_XDEVICEFAMILY = "kintex7" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  sram_i64o64_d256_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb(addrb),
        .clka(clka),
        .clkb(clkb),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(NLW_U0_douta_UNCONNECTED[63:0]),
        .doutb(doutb),
        .eccpipece(1'b0),
        .ena(1'b0),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[7:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(rsta_busy),
        .rstb(rstb),
        .rstb_busy(rstb_busy),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[7:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[63:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2021.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
sbNGmomEbP78s1hfxgX3P1Jo01EKJk0i0C7iGpF+Yibr9EK0s4mcIifHDN/ag4jpPwW3bPllMHvn
U8AEY3mO8hCXVVoilrcRuCaEna/98GycCzy4G7FnYMfowsJb5k9ifRdE2jnurzeTLFbupUSpDF0H
Rl3Ci3DTGeExAZZ9UQE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zZZZoIprBFYfDWmCCcduELBM7HU98/+rvP9g8+y1mYyD3r3HEDm4ZwehwZvPoYWqoGXYoFqWZh3h
utt0abIfUW9/oF2vJ9hXn7nArtcm/Eui18rPYqp3aj/AItPNVXojk9zp7uFZLPTqcyig5v3Jtenl
qPnLi1Z84ZCW7NIRw6Y0bgmw6z26E8VPbYrZHs+0YW8Sztjo6CdIrQeEL5WBDolA0aHoKHWRZyFs
l5eRDmBAolj2uF07t/3eY3J7cYJmEDaoZ0TR1qcz25VFNu0OlcrEJ19IT+QdAxTah4jqJtknGZrT
6lUMwDZ7dBQwF1EuaE6p90gGNERhGAsbHLdvaw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
KUbz0Iu2faeWqD6HFeuGLtSOAlqZmpKCCJfzym8tkcWUUNgNMn2mYvx6PTM7j4tyig8JdUG3uZYs
NfPgAsNXQtTI7b19u9CkMks9jR+oEzX1rW7QtTvSj/nHZLg2smoFwuB5Ieb7/B8IIs1NTUrIz6Rc
itLQVG+L+GMziamsrx4=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
G7XYdRx9VGclyxTEtwMG+rjJHV8bfBxEGdkcN82UL3koN3Dt0M5AWkzEvHcskt1W0hTOjyYgmvYj
/p70w1nz96tlg226+e4UubpRmBH9QXBBX6UmqIwSiHj9H+XI1yNfTIdlwBKGQvfzwCAMwBwrrrGL
/804k5Ux3RhWRvwezZB4+sj9DFm4akREVXmNpfeqjI2X02LU/MxWMUbKxvjJnD9YxikAAO6ccTd6
8DKv76V76MEFVyXc7E2FeQDToW3lqkRTa6MTpIXbYSekRihQC+qPVuhPUneA4kepvQDfgFYE8/Ir
gu5gK+s/qNfuXhJUAqyLjslrUcY4+XD9ckpSvQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YXkYRXpUPv/tETnwnThdQ46UaPmI23lN9vrxHQjIOhq3WNJCuz7TYZK9hyzSdo6k0U6QE9ihQy2L
rYZg68RGbrK8bzlcnQ41r18LZb4GYlAn9PH7IrF1B+aHm3578doOZHf8wzUE2s+d1aHQIn6VIZjL
14pCTAjErJfMO13fgX6h8sgxb4GFC3eIORmkrq2J/fB9HALyh/qdGiLi7DejMfmdsssbOcPQTZUh
6Belf7fHTkIEr9B44rFZgMyrMVx4N9p0XpXD3JPe7Xeg6a3jxdqxHATaMuLdIa4s+ZiAz1TRx0EO
FFihCnLLb7weBBITQyTIncRL817BrF/ZXZD8Yw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_01", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
g7FbNw1ywd4TBNHq8OmK/4zoKI/t7vKmyT8R8SeiyUtKywhn0/7DZ/lV0Lf4IhY8X5MYsKtOQ5l6
DIl3fxtOhxpi8NHn9Nw3Nfb8NnS38Zuy6DSpwOL0f/GSmUSf2/YdB5Ben6xibQT0Oy//oBl5/1kR
pV5fWjj8WRgI6cnmfyj3g1MxepxPu1A/UHxlm1/i9yUHHi114N/hEQ0iujjrn6GxfZSiJUVF+r6c
rnxD//eOAl/YaxhdU/KhUkfsMn+MxtA5m6hTYYE0bnze8rpmEU5UGYKyY0p8KUs+MgsdTe+m/7gV
HSf6puBqQmEa1qksRfl742aL9B9y169or7Jp9Q==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kd1A2zIphLxXB0RyfHIqLkHXfWl0n38vROERuDghYrhK0ItcWGEP0XBrri6k1VZCSPYwiSu//pM6
83BfcPKbk09/A+ksvDIa3xS8Tg7DJK2AS+0pdnzBSjVWh+QD+glA3Hjk6LG9OMbjXyqD3hnMKacA
VRMwxKktV+KT5NXj5a7fMxXjo9exc0xM+woUJiSYs8onoUSwfBeH5/xhUy+iu+w0/OOydQE2LXZ0
1y+RObiz5C22dD4GGCfuvUCGAthYpUf633ZxRYN45mmAn5PxPsH4o+l2GhH/50Gu/VPVoAWDhgXQ
e93oPri++HinkK2uvDhDl4PI9HtRkq11Ky3uXQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
gDrrFgXHVyBo+Cn0bYn+SOSOCXPg7besukY6l0JmA/nu4gap105Wxbg11c7TJZ9ctHVLc5DXAxr+
EIvFpAIepoZBREtMjTlaIdNJ8k1nUpwAv2jaQeseq1TudTjugV1jtOYYk0RKd88z/6SJ8t9urDW0
yKqsfEWU3PwGcUGHOWtTn2hfAceNznmEIFWLmFmzSQJ1hQNdsIQn3jHnfMVYu8cAz5xvPVQWYyJW
pMHXhNYk6GyAjIshh991slb1g01K1ilR2tKD1EmxH5WGrX9BEUqBjHQo6uluC/d3mvcEQ5nJ1v+P
hIlj4qzUQT1wXjpk6d/BvNx7LyWmj5iq35dzNm+cdhfGwaFGG//vgmB6D/dFfs2BYSjHsa6VlpVM
7e2OgoFenuG9p1SVPI6gAs2MuFtnDKfxW7jS3RGhvsquS3tg1iFCDH/OU7E5aWfY7twF3yyN6G10
l72RZw62DfNoCdyUMG9sA8nc4qf6dEhyrr5S6XxpJhoBDJvkeq0TCUQZ

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XR7vRF1m+9DS2Pv4r/O4uHwmvtXkChnKbsJCYczn1dvkZbcZSbBm/2UH78dXUaNorOh9XAuCvSjb
ER73y7e0anAfaIf1tJ9Y9pIb8EuNxGS/Pqdvg36cWarwGac9tsscdv/HWfb5Z+qWEk0/uFcLI7pH
CZO7fF2/ONQjA0NtUFBjW4idlx8WrySIuJgDs4jyGkMhbHR3U/ghF1YhMhwgwsbbcptfC1XLrIqQ
OecZnZu8E2hyc5eK/ccYdKcHnXoL55z1p5amI6Fuvz0wKTz2QQ/mwXodfGjEC1ZRWwTn7zCFM91M
qrA1Is49i6pSa7/VICjgn8ULMT1oKGfJLPm7hg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 36576)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
