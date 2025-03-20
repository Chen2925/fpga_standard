// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Thu Feb  6 16:06:02 2025
// Host        : DESKTOP-OBM7L7C running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ sram_i64o64_d256_sim_netlist.v
// Design      : sram_i64o64_d256
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7k325tffg676-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "sram_i64o64_d256,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
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
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_blk_mem_gen_v8_4_4 U0
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 36560)
`pragma protect data_block
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
h9jNYcL45nsZdQxONPd5EbMDOKKcr8Y=
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
