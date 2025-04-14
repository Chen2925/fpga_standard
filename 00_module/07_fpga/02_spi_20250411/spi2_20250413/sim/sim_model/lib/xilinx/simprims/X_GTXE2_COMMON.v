///////////////////////////////////////////////////////
//  Copyright (c) 2010 Xilinx Inc.
//  All Right Reserved.
///////////////////////////////////////////////////////
//
//   ____   ___
//  /   /\/   / 
// /___/  \  /     Vendor      : Xilinx 
// \  \    \/      Version     : 13.2
//  \  \           Description : Xilinx Functional Simulation Library Component
//  /  /                      
// /__/   /\       Filename    : X_GTXE2_CHANNEL.v
// \  \  /  \ 
//  \__\/\__ \                    
//                                 
//  Revision:		1.0
//  11/10/09 - CR - Initial version
//  11/20/09 - CR - Attribute updates in YML
//  04/27/10 - CR - YML update
//  05/26/10 - CR561562 - SATA_CPLL_CFG attribute bug fixed
//  06/10/10 - CR564909 - publish complete verilog unisim wrapper
//  06/17/10 - CR564909 - YML & RTL updates
//  06/17/10 - CR564909 - YML & RTL updates
//  08/05/10 - CR569019 - GTXE2 YML and secureip update
//  09/15/10 - CR575512 - GTXE2 YML and secureip update
//  01/09/11 - CR582278,579504,588137, 591741 - GTXE2 YML/secureip update
/////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps 

module X_GTXE2_COMMON (
  DRPDO,
  DRPRDY,
  QPLLDMONITOR,
  QPLLFBCLKLOST,
  QPLLLOCK,
  QPLLOUTCLK,
  QPLLOUTREFCLK,
  QPLLREFCLKLOST,
  REFCLKOUTMONITOR,

  BGBYPASSB,
  BGMONITORENB,
  BGPDB,
  BGRCALOVRD,
  DRPADDR,
  DRPCLK,
  DRPDI,
  DRPEN,
  DRPWE,
  GTGREFCLK,
  GTNORTHREFCLK0,
  GTNORTHREFCLK1,
  GTREFCLK0,
  GTREFCLK1,
  GTSOUTHREFCLK0,
  GTSOUTHREFCLK1,
  PMARSVD,
  QPLLLOCKDETCLK,
  QPLLLOCKEN,
  QPLLOUTRESET,
  QPLLPD,
  QPLLREFCLKSEL,
  QPLLRESET,
  QPLLRSVD1,
  QPLLRSVD2,
  RCALENB
);

  parameter LOC = "UNPLACED";
  parameter [63:0] BIAS_CFG = 64'h0000000000000000;
  parameter [31:0] COMMON_CFG = 32'h00000000;
  parameter [26:0] QPLL_CFG = 27'h0480181;
  parameter [3:0] QPLL_CLKOUT_CFG = 4'b0000;
  parameter [5:0] QPLL_COARSE_FREQ_OVRD = 6'b010000;
  parameter [0:0] QPLL_COARSE_FREQ_OVRD_EN = 1'b0;
  parameter [9:0] QPLL_CP = 10'b0000011111;
  parameter [0:0] QPLL_CP_MONITOR_EN = 1'b0;
  parameter [0:0] QPLL_DMONITOR_SEL = 1'b0;
  parameter [9:0] QPLL_FBDIV = 10'b0000000000;
  parameter [0:0] QPLL_FBDIV_MONITOR_EN = 1'b0;
  parameter [0:0] QPLL_FBDIV_RATIO = 1'b0;
  parameter [23:0] QPLL_INIT_CFG = 24'h000006;
  parameter [15:0] QPLL_LOCK_CFG = 16'h21E8;
  parameter [3:0] QPLL_LPF = 4'b1111;
  parameter integer QPLL_REFCLK_DIV = 2;
  parameter [2:0] SIM_QPLLREFCLK_SEL = 3'b001;
  parameter SIM_RESET_SPEEDUP = "TRUE";
  parameter SIM_VERSION = "1.1";
  
  localparam in_delay = 0;
  localparam out_delay = 0;
  localparam INCLK_DELAY = 0;
  localparam OUTCLK_DELAY = 0;

  output DRPRDY;
  output QPLLFBCLKLOST;
  output QPLLLOCK;
  output QPLLOUTCLK;
  output QPLLOUTREFCLK;
  output QPLLREFCLKLOST;
  output REFCLKOUTMONITOR;
  output [15:0] DRPDO;
  output [7:0] QPLLDMONITOR;

  input BGBYPASSB;
  input BGMONITORENB;
  input BGPDB;
  input DRPCLK;
  input DRPEN;
  input DRPWE;
  input GTGREFCLK;
  input GTNORTHREFCLK0;
  input GTNORTHREFCLK1;
  input GTREFCLK0;
  input GTREFCLK1;
  input GTSOUTHREFCLK0;
  input GTSOUTHREFCLK1;
  input QPLLLOCKDETCLK;
  input QPLLLOCKEN;
  input QPLLOUTRESET;
  input QPLLPD;
  input QPLLRESET;
  input RCALENB;
  input [15:0] DRPDI;
  input [15:0] QPLLRSVD1;
  input [2:0] QPLLREFCLKSEL;
  input [4:0] BGRCALOVRD;
  input [4:0] QPLLRSVD2;
  input [7:0] DRPADDR;
  input [7:0] PMARSVD;

  reg SIM_RESET_SPEEDUP_BINARY;
  reg SIM_VERSION_BINARY;
  reg [0:0] QPLL_COARSE_FREQ_OVRD_EN_BINARY;
  reg [0:0] QPLL_CP_MONITOR_EN_BINARY;
  reg [0:0] QPLL_DMONITOR_SEL_BINARY;
  reg [0:0] QPLL_FBDIV_MONITOR_EN_BINARY;
  reg [0:0] QPLL_FBDIV_RATIO_BINARY;
  reg [2:0] SIM_QPLLREFCLK_SEL_BINARY;
  reg [3:0] QPLL_CLKOUT_CFG_BINARY;
  reg [3:0] QPLL_LPF_BINARY;
  reg [4:0] QPLL_REFCLK_DIV_BINARY;
  reg [5:0] QPLL_COARSE_FREQ_OVRD_BINARY;
  reg [9:0] QPLL_CP_BINARY;
  reg [9:0] QPLL_FBDIV_BINARY;

  tri0 GSR = glbl.GSR;
  reg notifier;

  wire DRPRDY_OUT;
  wire QPLLFBCLKLOST_OUT;
  wire QPLLLOCK_OUT;
  wire QPLLOUTCLK_OUT;
  wire QPLLOUTREFCLK_OUT;
  wire QPLLREFCLKLOST_OUT;
  wire REFCLKOUTMONITOR_OUT;
  wire [15:0] DRPDO_OUT;
  wire [7:0] QPLLDMONITOR_OUT;

  wire BGBYPASSB_IN;
  wire BGMONITORENB_IN;
  wire BGPDB_IN;
  wire DRPCLK_IN;
  wire DRPEN_IN;
  wire DRPWE_IN;
  wire GTGREFCLK_IN;
  wire GTNORTHREFCLK0_IN;
  wire GTNORTHREFCLK1_IN;
  wire GTREFCLK0_IN;
  wire GTREFCLK1_IN;
  wire GTSOUTHREFCLK0_IN;
  wire GTSOUTHREFCLK1_IN;
  wire QPLLLOCKDETCLK_IN;
  wire QPLLLOCKEN_IN;
  wire QPLLOUTRESET_IN;
  wire QPLLPD_IN;
  wire QPLLRESET_IN;
  wire RCALENB_IN;
  wire [15:0] DRPDI_IN;
  wire [15:0] QPLLRSVD1_IN;
  wire [2:0] QPLLREFCLKSEL_IN;
  wire [4:0] BGRCALOVRD_IN;
  wire [4:0] QPLLRSVD2_IN;
  wire [7:0] DRPADDR_IN;
  wire [7:0] PMARSVD_IN;

  wire BGBYPASSB_INDELAY;
  wire BGMONITORENB_INDELAY;
  wire BGPDB_INDELAY;
  wire DRPCLK_INDELAY;
  wire DRPEN_INDELAY;
  wire DRPWE_INDELAY;
  wire GTGREFCLK_INDELAY;
  wire GTNORTHREFCLK0_INDELAY;
  wire GTNORTHREFCLK1_INDELAY;
  wire GTREFCLK0_INDELAY;
  wire GTREFCLK1_INDELAY;
  wire GTSOUTHREFCLK0_INDELAY;
  wire GTSOUTHREFCLK1_INDELAY;
  wire QPLLLOCKDETCLK_INDELAY;
  wire QPLLLOCKEN_INDELAY;
  wire QPLLOUTRESET_INDELAY;
  wire QPLLPD_INDELAY;
  wire QPLLRESET_INDELAY;
  wire RCALENB_INDELAY;
  wire [15:0] DRPDI_INDELAY;
  wire [15:0] QPLLRSVD1_INDELAY;
  wire [2:0] QPLLREFCLKSEL_INDELAY;
  wire [4:0] BGRCALOVRD_INDELAY;
  wire [4:0] QPLLRSVD2_INDELAY;
  wire [7:0] DRPADDR_INDELAY;
  wire [7:0] PMARSVD_INDELAY;

  initial begin
    case (QPLL_REFCLK_DIV)
      2 : QPLL_REFCLK_DIV_BINARY = 5'b00000;
      1 : QPLL_REFCLK_DIV_BINARY = 5'b10000;
      3 : QPLL_REFCLK_DIV_BINARY = 5'b00001;
      4 : QPLL_REFCLK_DIV_BINARY = 5'b00010;
      5 : QPLL_REFCLK_DIV_BINARY = 5'b00011;
      6 : QPLL_REFCLK_DIV_BINARY = 5'b00101;
      8 : QPLL_REFCLK_DIV_BINARY = 5'b00110;
      10 : QPLL_REFCLK_DIV_BINARY = 5'b00111;
      12 : QPLL_REFCLK_DIV_BINARY = 5'b01101;
      16 : QPLL_REFCLK_DIV_BINARY = 5'b01110;
      20 : QPLL_REFCLK_DIV_BINARY = 5'b01111;
      default : begin
        $display("Attribute Syntax Error : The Attribute QPLL_REFCLK_DIV on X_GTXE2_COMMON instance %m is set to %d.  Legal values for this attribute are 1 to 20.", QPLL_REFCLK_DIV, 2);
        $finish;
      end
    endcase

    case (SIM_RESET_SPEEDUP)
      "TRUE" : SIM_RESET_SPEEDUP_BINARY = 0;
      "FALSE" : SIM_RESET_SPEEDUP_BINARY = 0;
      default : begin
        $display("Attribute Syntax Error : The Attribute SIM_RESET_SPEEDUP on X_GTXE2_COMMON instance %m is set to %s.  Legal values for this attribute are TRUE, or FALSE.", SIM_RESET_SPEEDUP);
        $finish;
      end
    endcase

    case (SIM_VERSION)
      "1.1" : SIM_VERSION_BINARY = 0;
      "1.0" : SIM_VERSION_BINARY = 0;
      "2.0" : SIM_VERSION_BINARY = 0;
      default : begin
        $display("Attribute Syntax Error : The Attribute SIM_VERSION on X_GTXE2_COMMON instance %m is set to %s.  Legal values for this attribute are 1.1, 1.0, or 2.0.", SIM_VERSION);
        $finish;
      end
    endcase

    if ((QPLL_CLKOUT_CFG >= 4'b0000) && (QPLL_CLKOUT_CFG <= 4'b1111))
      QPLL_CLKOUT_CFG_BINARY = QPLL_CLKOUT_CFG;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_CLKOUT_CFG on X_GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 4'b0000 to 4'b1111.", QPLL_CLKOUT_CFG);
      $finish;
    end

    if ((QPLL_COARSE_FREQ_OVRD >= 6'b000000) && (QPLL_COARSE_FREQ_OVRD <= 6'b111111))
      QPLL_COARSE_FREQ_OVRD_BINARY = QPLL_COARSE_FREQ_OVRD;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_COARSE_FREQ_OVRD on X_GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 6'b000000 to 6'b111111.", QPLL_COARSE_FREQ_OVRD);
      $finish;
    end

    if ((QPLL_COARSE_FREQ_OVRD_EN >= 1'b0) && (QPLL_COARSE_FREQ_OVRD_EN <= 1'b1))
      QPLL_COARSE_FREQ_OVRD_EN_BINARY = QPLL_COARSE_FREQ_OVRD_EN;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_COARSE_FREQ_OVRD_EN on X_GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 1'b0 to 1'b1.", QPLL_COARSE_FREQ_OVRD_EN);
      $finish;
    end

    if ((QPLL_CP >= 10'b0000000000) && (QPLL_CP <= 10'b1111111111))
      QPLL_CP_BINARY = QPLL_CP;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_CP on X_GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 10'b0000000000 to 10'b1111111111.", QPLL_CP);
      $finish;
    end

    if ((QPLL_CP_MONITOR_EN >= 1'b0) && (QPLL_CP_MONITOR_EN <= 1'b1))
      QPLL_CP_MONITOR_EN_BINARY = QPLL_CP_MONITOR_EN;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_CP_MONITOR_EN on X_GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 1'b0 to 1'b1.", QPLL_CP_MONITOR_EN);
      $finish;
    end

    if ((QPLL_DMONITOR_SEL >= 1'b0) && (QPLL_DMONITOR_SEL <= 1'b1))
      QPLL_DMONITOR_SEL_BINARY = QPLL_DMONITOR_SEL;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_DMONITOR_SEL on X_GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 1'b0 to 1'b1.", QPLL_DMONITOR_SEL);
      $finish;
    end

    if ((QPLL_FBDIV >= 10'b0000000000) && (QPLL_FBDIV <= 10'b1111111111))
      QPLL_FBDIV_BINARY = QPLL_FBDIV;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_FBDIV on X_GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 10'b0000000000 to 10'b1111111111.", QPLL_FBDIV);
      $finish;
    end

    if ((QPLL_FBDIV_MONITOR_EN >= 1'b0) && (QPLL_FBDIV_MONITOR_EN <= 1'b1))
      QPLL_FBDIV_MONITOR_EN_BINARY = QPLL_FBDIV_MONITOR_EN;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_FBDIV_MONITOR_EN on X_GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 1'b0 to 1'b1.", QPLL_FBDIV_MONITOR_EN);
      $finish;
    end

    if ((QPLL_FBDIV_RATIO >= 1'b0) && (QPLL_FBDIV_RATIO <= 1'b1))
      QPLL_FBDIV_RATIO_BINARY = QPLL_FBDIV_RATIO;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_FBDIV_RATIO on X_GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 1'b0 to 1'b1.", QPLL_FBDIV_RATIO);
      $finish;
    end

    if ((QPLL_LPF >= 4'b0000) && (QPLL_LPF <= 4'b1111))
      QPLL_LPF_BINARY = QPLL_LPF;
    else begin
      $display("Attribute Syntax Error : The Attribute QPLL_LPF on X_GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 4'b0000 to 4'b1111.", QPLL_LPF);
      $finish;
    end

    if ((SIM_QPLLREFCLK_SEL >= 3'b0) && (SIM_QPLLREFCLK_SEL <= 3'b111))
      SIM_QPLLREFCLK_SEL_BINARY = SIM_QPLLREFCLK_SEL;
    else begin
      $display("Attribute Syntax Error : The Attribute SIM_QPLLREFCLK_SEL on X_GTXE2_COMMON instance %m is set to %b.  Legal values for this attribute are 3'b0 to 3'b111.", SIM_QPLLREFCLK_SEL);
      $finish;
    end

  end

  buf B_DRPDO0 (DRPDO[0], DRPDO_OUT[0]);
  buf B_DRPDO1 (DRPDO[1], DRPDO_OUT[1]);
  buf B_DRPDO10 (DRPDO[10], DRPDO_OUT[10]);
  buf B_DRPDO11 (DRPDO[11], DRPDO_OUT[11]);
  buf B_DRPDO12 (DRPDO[12], DRPDO_OUT[12]);
  buf B_DRPDO13 (DRPDO[13], DRPDO_OUT[13]);
  buf B_DRPDO14 (DRPDO[14], DRPDO_OUT[14]);
  buf B_DRPDO15 (DRPDO[15], DRPDO_OUT[15]);
  buf B_DRPDO2 (DRPDO[2], DRPDO_OUT[2]);
  buf B_DRPDO3 (DRPDO[3], DRPDO_OUT[3]);
  buf B_DRPDO4 (DRPDO[4], DRPDO_OUT[4]);
  buf B_DRPDO5 (DRPDO[5], DRPDO_OUT[5]);
  buf B_DRPDO6 (DRPDO[6], DRPDO_OUT[6]);
  buf B_DRPDO7 (DRPDO[7], DRPDO_OUT[7]);
  buf B_DRPDO8 (DRPDO[8], DRPDO_OUT[8]);
  buf B_DRPDO9 (DRPDO[9], DRPDO_OUT[9]);
  buf B_DRPRDY (DRPRDY, DRPRDY_OUT);
  buf B_QPLLDMONITOR0 (QPLLDMONITOR[0], QPLLDMONITOR_OUT[0]);
  buf B_QPLLDMONITOR1 (QPLLDMONITOR[1], QPLLDMONITOR_OUT[1]);
  buf B_QPLLDMONITOR2 (QPLLDMONITOR[2], QPLLDMONITOR_OUT[2]);
  buf B_QPLLDMONITOR3 (QPLLDMONITOR[3], QPLLDMONITOR_OUT[3]);
  buf B_QPLLDMONITOR4 (QPLLDMONITOR[4], QPLLDMONITOR_OUT[4]);
  buf B_QPLLDMONITOR5 (QPLLDMONITOR[5], QPLLDMONITOR_OUT[5]);
  buf B_QPLLDMONITOR6 (QPLLDMONITOR[6], QPLLDMONITOR_OUT[6]);
  buf B_QPLLDMONITOR7 (QPLLDMONITOR[7], QPLLDMONITOR_OUT[7]);
  buf B_QPLLFBCLKLOST (QPLLFBCLKLOST, QPLLFBCLKLOST_OUT);
  buf B_QPLLLOCK (QPLLLOCK, QPLLLOCK_OUT);
  buf B_QPLLOUTCLK (QPLLOUTCLK, QPLLOUTCLK_OUT);
  buf B_QPLLOUTREFCLK (QPLLOUTREFCLK, QPLLOUTREFCLK_OUT);
  buf B_QPLLREFCLKLOST (QPLLREFCLKLOST, QPLLREFCLKLOST_OUT);
  buf B_REFCLKOUTMONITOR (REFCLKOUTMONITOR, REFCLKOUTMONITOR_OUT);

  buf B_BGBYPASSB (BGBYPASSB_IN, BGBYPASSB);
  buf B_BGMONITORENB (BGMONITORENB_IN, BGMONITORENB);
  buf B_BGPDB (BGPDB_IN, BGPDB);
  buf B_BGRCALOVRD0 (BGRCALOVRD_IN[0], BGRCALOVRD[0]);
  buf B_BGRCALOVRD1 (BGRCALOVRD_IN[1], BGRCALOVRD[1]);
  buf B_BGRCALOVRD2 (BGRCALOVRD_IN[2], BGRCALOVRD[2]);
  buf B_BGRCALOVRD3 (BGRCALOVRD_IN[3], BGRCALOVRD[3]);
  buf B_BGRCALOVRD4 (BGRCALOVRD_IN[4], BGRCALOVRD[4]);
  buf B_DRPADDR0 (DRPADDR_IN[0], DRPADDR[0]);
  buf B_DRPADDR1 (DRPADDR_IN[1], DRPADDR[1]);
  buf B_DRPADDR2 (DRPADDR_IN[2], DRPADDR[2]);
  buf B_DRPADDR3 (DRPADDR_IN[3], DRPADDR[3]);
  buf B_DRPADDR4 (DRPADDR_IN[4], DRPADDR[4]);
  buf B_DRPADDR5 (DRPADDR_IN[5], DRPADDR[5]);
  buf B_DRPADDR6 (DRPADDR_IN[6], DRPADDR[6]);
  buf B_DRPADDR7 (DRPADDR_IN[7], DRPADDR[7]);
  buf B_DRPCLK (DRPCLK_IN, DRPCLK);
  buf B_DRPDI0 (DRPDI_IN[0], DRPDI[0]);
  buf B_DRPDI1 (DRPDI_IN[1], DRPDI[1]);
  buf B_DRPDI10 (DRPDI_IN[10], DRPDI[10]);
  buf B_DRPDI11 (DRPDI_IN[11], DRPDI[11]);
  buf B_DRPDI12 (DRPDI_IN[12], DRPDI[12]);
  buf B_DRPDI13 (DRPDI_IN[13], DRPDI[13]);
  buf B_DRPDI14 (DRPDI_IN[14], DRPDI[14]);
  buf B_DRPDI15 (DRPDI_IN[15], DRPDI[15]);
  buf B_DRPDI2 (DRPDI_IN[2], DRPDI[2]);
  buf B_DRPDI3 (DRPDI_IN[3], DRPDI[3]);
  buf B_DRPDI4 (DRPDI_IN[4], DRPDI[4]);
  buf B_DRPDI5 (DRPDI_IN[5], DRPDI[5]);
  buf B_DRPDI6 (DRPDI_IN[6], DRPDI[6]);
  buf B_DRPDI7 (DRPDI_IN[7], DRPDI[7]);
  buf B_DRPDI8 (DRPDI_IN[8], DRPDI[8]);
  buf B_DRPDI9 (DRPDI_IN[9], DRPDI[9]);
  buf B_DRPEN (DRPEN_IN, DRPEN);
  buf B_DRPWE (DRPWE_IN, DRPWE);
  buf B_GTGREFCLK (GTGREFCLK_IN, GTGREFCLK);
  buf B_GTNORTHREFCLK0 (GTNORTHREFCLK0_IN, GTNORTHREFCLK0);
  buf B_GTNORTHREFCLK1 (GTNORTHREFCLK1_IN, GTNORTHREFCLK1);
  buf B_GTREFCLK0 (GTREFCLK0_IN, GTREFCLK0);
  buf B_GTREFCLK1 (GTREFCLK1_IN, GTREFCLK1);
  buf B_GTSOUTHREFCLK0 (GTSOUTHREFCLK0_IN, GTSOUTHREFCLK0);
  buf B_GTSOUTHREFCLK1 (GTSOUTHREFCLK1_IN, GTSOUTHREFCLK1);
  buf B_PMARSVD0 (PMARSVD_IN[0], PMARSVD[0]);
  buf B_PMARSVD1 (PMARSVD_IN[1], PMARSVD[1]);
  buf B_PMARSVD2 (PMARSVD_IN[2], PMARSVD[2]);
  buf B_PMARSVD3 (PMARSVD_IN[3], PMARSVD[3]);
  buf B_PMARSVD4 (PMARSVD_IN[4], PMARSVD[4]);
  buf B_PMARSVD5 (PMARSVD_IN[5], PMARSVD[5]);
  buf B_PMARSVD6 (PMARSVD_IN[6], PMARSVD[6]);
  buf B_PMARSVD7 (PMARSVD_IN[7], PMARSVD[7]);
  buf B_QPLLLOCKDETCLK (QPLLLOCKDETCLK_IN, QPLLLOCKDETCLK);
  buf B_QPLLLOCKEN (QPLLLOCKEN_IN, QPLLLOCKEN);
  buf B_QPLLOUTRESET (QPLLOUTRESET_IN, QPLLOUTRESET);
  buf B_QPLLPD (QPLLPD_IN, QPLLPD);
  buf B_QPLLREFCLKSEL0 (QPLLREFCLKSEL_IN[0], QPLLREFCLKSEL[0]);
  buf B_QPLLREFCLKSEL1 (QPLLREFCLKSEL_IN[1], QPLLREFCLKSEL[1]);
  buf B_QPLLREFCLKSEL2 (QPLLREFCLKSEL_IN[2], QPLLREFCLKSEL[2]);
  buf B_QPLLRESET (QPLLRESET_IN, QPLLRESET);
  buf B_QPLLRSVD10 (QPLLRSVD1_IN[0], QPLLRSVD1[0]);
  buf B_QPLLRSVD11 (QPLLRSVD1_IN[1], QPLLRSVD1[1]);
  buf B_QPLLRSVD110 (QPLLRSVD1_IN[10], QPLLRSVD1[10]);
  buf B_QPLLRSVD111 (QPLLRSVD1_IN[11], QPLLRSVD1[11]);
  buf B_QPLLRSVD112 (QPLLRSVD1_IN[12], QPLLRSVD1[12]);
  buf B_QPLLRSVD113 (QPLLRSVD1_IN[13], QPLLRSVD1[13]);
  buf B_QPLLRSVD114 (QPLLRSVD1_IN[14], QPLLRSVD1[14]);
  buf B_QPLLRSVD115 (QPLLRSVD1_IN[15], QPLLRSVD1[15]);
  buf B_QPLLRSVD12 (QPLLRSVD1_IN[2], QPLLRSVD1[2]);
  buf B_QPLLRSVD13 (QPLLRSVD1_IN[3], QPLLRSVD1[3]);
  buf B_QPLLRSVD14 (QPLLRSVD1_IN[4], QPLLRSVD1[4]);
  buf B_QPLLRSVD15 (QPLLRSVD1_IN[5], QPLLRSVD1[5]);
  buf B_QPLLRSVD16 (QPLLRSVD1_IN[6], QPLLRSVD1[6]);
  buf B_QPLLRSVD17 (QPLLRSVD1_IN[7], QPLLRSVD1[7]);
  buf B_QPLLRSVD18 (QPLLRSVD1_IN[8], QPLLRSVD1[8]);
  buf B_QPLLRSVD19 (QPLLRSVD1_IN[9], QPLLRSVD1[9]);
  buf B_QPLLRSVD20 (QPLLRSVD2_IN[0], QPLLRSVD2[0]);
  buf B_QPLLRSVD21 (QPLLRSVD2_IN[1], QPLLRSVD2[1]);
  buf B_QPLLRSVD22 (QPLLRSVD2_IN[2], QPLLRSVD2[2]);
  buf B_QPLLRSVD23 (QPLLRSVD2_IN[3], QPLLRSVD2[3]);
  buf B_QPLLRSVD24 (QPLLRSVD2_IN[4], QPLLRSVD2[4]);
  buf B_RCALENB (RCALENB_IN, RCALENB);

  wire [15:0] delay_DRPDO;
  wire [7:0] delay_QPLLDMONITOR;
  wire delay_DRPRDY;
  wire delay_QPLLFBCLKLOST;
  wire delay_QPLLLOCK;
  wire delay_QPLLOUTCLK;
  wire delay_QPLLOUTREFCLK;
  wire delay_QPLLREFCLKLOST;
  wire delay_REFCLKOUTMONITOR;

  wire [15:0] delay_DRPDI;
  wire [15:0] delay_QPLLRSVD1;
  wire [2:0] delay_QPLLREFCLKSEL;
  wire [4:0] delay_BGRCALOVRD;
  wire [4:0] delay_QPLLRSVD2;
  wire [7:0] delay_DRPADDR;
  wire [7:0] delay_PMARSVD;
  wire delay_BGBYPASSB;
  wire delay_BGMONITORENB;
  wire delay_BGPDB;
  wire delay_DRPCLK;
  wire delay_DRPEN;
  wire delay_DRPWE;
  wire delay_GTGREFCLK;
  wire delay_GTNORTHREFCLK0;
  wire delay_GTNORTHREFCLK1;
  wire delay_GTREFCLK0;
  wire delay_GTREFCLK1;
  wire delay_GTSOUTHREFCLK0;
  wire delay_GTSOUTHREFCLK1;
  wire delay_QPLLLOCKDETCLK;
  wire delay_QPLLLOCKEN;
  wire delay_QPLLOUTRESET;
  wire delay_QPLLPD;
  wire delay_QPLLRESET;
  wire delay_RCALENB;

  assign #(OUTCLK_DELAY) QPLLOUTCLK_OUT = delay_QPLLOUTCLK;
  assign #(OUTCLK_DELAY) REFCLKOUTMONITOR_OUT = delay_REFCLKOUTMONITOR;

  assign #(out_delay) DRPDO_OUT = delay_DRPDO;
  assign #(out_delay) DRPRDY_OUT = delay_DRPRDY;
  assign #(out_delay) QPLLDMONITOR_OUT = delay_QPLLDMONITOR;
  assign #(out_delay) QPLLFBCLKLOST_OUT = delay_QPLLFBCLKLOST;
  assign #(out_delay) QPLLLOCK_OUT = delay_QPLLLOCK;
  assign #(out_delay) QPLLOUTREFCLK_OUT = delay_QPLLOUTREFCLK;
  assign #(out_delay) QPLLREFCLKLOST_OUT = delay_QPLLREFCLKLOST;

  assign #(INCLK_DELAY) DRPCLK_INDELAY = DRPCLK_IN;
  assign #(INCLK_DELAY) GTGREFCLK_INDELAY = GTGREFCLK_IN;
  assign #(INCLK_DELAY) GTNORTHREFCLK0_INDELAY = GTNORTHREFCLK0_IN;
  assign #(INCLK_DELAY) GTNORTHREFCLK1_INDELAY = GTNORTHREFCLK1_IN;
  assign #(INCLK_DELAY) GTREFCLK0_INDELAY = GTREFCLK0_IN;
  assign #(INCLK_DELAY) GTREFCLK1_INDELAY = GTREFCLK1_IN;
  assign #(INCLK_DELAY) GTSOUTHREFCLK0_INDELAY = GTSOUTHREFCLK0_IN;
  assign #(INCLK_DELAY) GTSOUTHREFCLK1_INDELAY = GTSOUTHREFCLK1_IN;
  assign #(INCLK_DELAY) QPLLLOCKDETCLK_INDELAY = QPLLLOCKDETCLK_IN;

  assign #(in_delay) BGBYPASSB_INDELAY = BGBYPASSB_IN;
  assign #(in_delay) BGMONITORENB_INDELAY = BGMONITORENB_IN;
  assign #(in_delay) BGPDB_INDELAY = BGPDB_IN;
  assign #(in_delay) BGRCALOVRD_INDELAY = BGRCALOVRD_IN;
  assign #(in_delay) DRPADDR_INDELAY = DRPADDR_IN;
  assign #(in_delay) DRPDI_INDELAY = DRPDI_IN;
  assign #(in_delay) DRPEN_INDELAY = DRPEN_IN;
  assign #(in_delay) DRPWE_INDELAY = DRPWE_IN;
  assign #(in_delay) PMARSVD_INDELAY = PMARSVD_IN;
  assign #(in_delay) QPLLLOCKEN_INDELAY = QPLLLOCKEN_IN;
  assign #(in_delay) QPLLOUTRESET_INDELAY = QPLLOUTRESET_IN;
  assign #(in_delay) QPLLPD_INDELAY = QPLLPD_IN;
  assign #(in_delay) QPLLREFCLKSEL_INDELAY = QPLLREFCLKSEL_IN;
  assign #(in_delay) QPLLRESET_INDELAY = QPLLRESET_IN;
  assign #(in_delay) QPLLRSVD1_INDELAY = QPLLRSVD1_IN;
  assign #(in_delay) QPLLRSVD2_INDELAY = QPLLRSVD2_IN;
  assign #(in_delay) RCALENB_INDELAY = RCALENB_IN;
  assign delay_BGBYPASSB = BGBYPASSB_INDELAY;
  assign delay_BGMONITORENB = BGMONITORENB_INDELAY;
  assign delay_BGPDB = BGPDB_INDELAY;
  assign delay_BGRCALOVRD = BGRCALOVRD_INDELAY;
  assign delay_GTGREFCLK = GTGREFCLK_INDELAY;
  assign delay_GTNORTHREFCLK0 = GTNORTHREFCLK0_INDELAY;
  assign delay_GTNORTHREFCLK1 = GTNORTHREFCLK1_INDELAY;
  assign delay_GTREFCLK0 = GTREFCLK0_INDELAY;
  assign delay_GTREFCLK1 = GTREFCLK1_INDELAY;
  assign delay_GTSOUTHREFCLK0 = GTSOUTHREFCLK0_INDELAY;
  assign delay_GTSOUTHREFCLK1 = GTSOUTHREFCLK1_INDELAY;
  assign delay_PMARSVD = PMARSVD_INDELAY;
  assign delay_QPLLLOCKDETCLK = QPLLLOCKDETCLK_INDELAY;
  assign delay_QPLLLOCKEN = QPLLLOCKEN_INDELAY;
  assign delay_QPLLOUTRESET = QPLLOUTRESET_INDELAY;
  assign delay_QPLLPD = QPLLPD_INDELAY;
  assign delay_QPLLREFCLKSEL = QPLLREFCLKSEL_INDELAY;
  assign delay_QPLLRESET = QPLLRESET_INDELAY;
  assign delay_QPLLRSVD1 = QPLLRSVD1_INDELAY;
  assign delay_QPLLRSVD2 = QPLLRSVD2_INDELAY;
  assign delay_RCALENB = RCALENB_INDELAY;

  B_GTXE2_COMMON #(
    .BIAS_CFG (BIAS_CFG),
    .COMMON_CFG (COMMON_CFG),
    .QPLL_CFG (QPLL_CFG),
    .QPLL_CLKOUT_CFG (QPLL_CLKOUT_CFG),
    .QPLL_COARSE_FREQ_OVRD (QPLL_COARSE_FREQ_OVRD),
    .QPLL_COARSE_FREQ_OVRD_EN (QPLL_COARSE_FREQ_OVRD_EN),
    .QPLL_CP (QPLL_CP),
    .QPLL_CP_MONITOR_EN (QPLL_CP_MONITOR_EN),
    .QPLL_DMONITOR_SEL (QPLL_DMONITOR_SEL),
    .QPLL_FBDIV (QPLL_FBDIV),
    .QPLL_FBDIV_MONITOR_EN (QPLL_FBDIV_MONITOR_EN),
    .QPLL_FBDIV_RATIO (QPLL_FBDIV_RATIO),
    .QPLL_INIT_CFG (QPLL_INIT_CFG),
    .QPLL_LOCK_CFG (QPLL_LOCK_CFG),
    .QPLL_LPF (QPLL_LPF),
    .QPLL_REFCLK_DIV (QPLL_REFCLK_DIV),
    .SIM_QPLLREFCLK_SEL (SIM_QPLLREFCLK_SEL),
    .SIM_RESET_SPEEDUP (SIM_RESET_SPEEDUP),
    .SIM_VERSION (SIM_VERSION))

    B_GTXE2_COMMON_INST (
    .DRPDO (delay_DRPDO),
    .DRPRDY (delay_DRPRDY),
    .QPLLDMONITOR (delay_QPLLDMONITOR),
    .QPLLFBCLKLOST (delay_QPLLFBCLKLOST),
    .QPLLLOCK (delay_QPLLLOCK),
    .QPLLOUTCLK (delay_QPLLOUTCLK),
    .QPLLOUTREFCLK (delay_QPLLOUTREFCLK),
    .QPLLREFCLKLOST (delay_QPLLREFCLKLOST),
    .REFCLKOUTMONITOR (delay_REFCLKOUTMONITOR),
    .BGBYPASSB (delay_BGBYPASSB),
    .BGMONITORENB (delay_BGMONITORENB),
    .BGPDB (delay_BGPDB),
    .BGRCALOVRD (delay_BGRCALOVRD),
    .DRPADDR (delay_DRPADDR),
    .DRPCLK (delay_DRPCLK),
    .DRPDI (delay_DRPDI),
    .DRPEN (delay_DRPEN),
    .DRPWE (delay_DRPWE),
    .GTGREFCLK (delay_GTGREFCLK),
    .GTNORTHREFCLK0 (delay_GTNORTHREFCLK0),
    .GTNORTHREFCLK1 (delay_GTNORTHREFCLK1),
    .GTREFCLK0 (delay_GTREFCLK0),
    .GTREFCLK1 (delay_GTREFCLK1),
    .GTSOUTHREFCLK0 (delay_GTSOUTHREFCLK0),
    .GTSOUTHREFCLK1 (delay_GTSOUTHREFCLK1),
    .PMARSVD (delay_PMARSVD),
    .QPLLLOCKDETCLK (delay_QPLLLOCKDETCLK),
    .QPLLLOCKEN (delay_QPLLLOCKEN),
    .QPLLOUTRESET (delay_QPLLOUTRESET),
    .QPLLPD (delay_QPLLPD),
    .QPLLREFCLKSEL (delay_QPLLREFCLKSEL),
    .QPLLRESET (delay_QPLLRESET),
    .QPLLRSVD1 (delay_QPLLRSVD1),
    .QPLLRSVD2 (delay_QPLLRSVD2),
    .RCALENB (delay_RCALENB),
    .GSR (GSR)	 
  );

  specify
    $period (posedge DRPCLK, 0:0:0, notifier);
    $period (posedge GTGREFCLK, 0:0:0, notifier);
    $period (posedge GTNORTHREFCLK0, 0:0:0, notifier);
    $period (posedge GTNORTHREFCLK1, 0:0:0, notifier);
    $period (posedge GTREFCLK0, 0:0:0, notifier);
    $period (posedge GTREFCLK1, 0:0:0, notifier);
    $period (posedge GTSOUTHREFCLK0, 0:0:0, notifier);
    $period (posedge GTSOUTHREFCLK1, 0:0:0, notifier);
    $period (posedge QPLLLOCKDETCLK, 0:0:0, notifier);
    $period (posedge QPLLOUTCLK, 0:0:0, notifier);
    $period (posedge REFCLKOUTMONITOR, 0:0:0, notifier);
    $setuphold (posedge DRPCLK, negedge DRPADDR, 0:0:0, 0:0:0, notifier,,, delay_DRPCLK, delay_DRPADDR);
    $setuphold (posedge DRPCLK, negedge DRPDI, 0:0:0, 0:0:0, notifier,,, delay_DRPCLK, delay_DRPDI);
    $setuphold (posedge DRPCLK, negedge DRPEN, 0:0:0, 0:0:0, notifier,,, delay_DRPCLK, delay_DRPEN);
    $setuphold (posedge DRPCLK, negedge DRPWE, 0:0:0, 0:0:0, notifier,,, delay_DRPCLK, delay_DRPWE);
    $setuphold (posedge DRPCLK, posedge DRPADDR, 0:0:0, 0:0:0, notifier,,, delay_DRPCLK, delay_DRPADDR);
    $setuphold (posedge DRPCLK, posedge DRPDI, 0:0:0, 0:0:0, notifier,,, delay_DRPCLK, delay_DRPDI);
    $setuphold (posedge DRPCLK, posedge DRPEN, 0:0:0, 0:0:0, notifier,,, delay_DRPCLK, delay_DRPEN);
    $setuphold (posedge DRPCLK, posedge DRPWE, 0:0:0, 0:0:0, notifier,,, delay_DRPCLK, delay_DRPWE);
    ( DRPCLK *> DRPDO) = (0:0:0, 0:0:0);
    ( DRPCLK *> DRPRDY) = (0:0:0, 0:0:0);
    ( GTGREFCLK *> REFCLKOUTMONITOR) = (0:0:0, 0:0:0);
    ( GTNORTHREFCLK0 *> REFCLKOUTMONITOR) = (0:0:0, 0:0:0);
    ( GTNORTHREFCLK1 *> REFCLKOUTMONITOR) = (0:0:0, 0:0:0);
    ( GTREFCLK0 *> REFCLKOUTMONITOR) = (0:0:0, 0:0:0);
    ( GTREFCLK1 *> REFCLKOUTMONITOR) = (0:0:0, 0:0:0);
    ( GTSOUTHREFCLK0 *> REFCLKOUTMONITOR) = (0:0:0, 0:0:0);
    ( GTSOUTHREFCLK1 *> REFCLKOUTMONITOR) = (0:0:0, 0:0:0);

    specparam PATHPULSE$ = 0;
  endspecify
endmodule
