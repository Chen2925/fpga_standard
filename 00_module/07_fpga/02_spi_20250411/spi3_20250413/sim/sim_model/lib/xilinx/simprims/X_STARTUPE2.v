///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2010 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 12.1
//  \   \         Description : Xilinx Functional Timing Library Component
//  /   /                  User Interface to Global Clock, Reset and 3-State Controls
// /___/   /\     Filename : X_STARTUPE2.v
// \   \  /  \    Timestamp : Mon Mar  8 15:49:37 PST 2010
//  \___\/\___\
//
// Revision:
//    03/08/10 - Initial version.
//    10/26/10 - CR 573665 -- Added PREQ support.
// End Revision

`timescale 1 ps / 1 ps

module X_STARTUPE2 (
  CFGCLK,
  CFGMCLK,
  EOS,
  PREQ,

  CLK,
  GSR,
  GTS,
  KEYCLEARB,
  PACK,
  USRCCLKO,
  USRCCLKTS,
  USRDONEO,
  USRDONETS
);

  parameter LOC = "UNPLACED";
  parameter PROG_USR = "FALSE";
  parameter real SIM_CCLK_FREQ = 0.0;

  output CFGCLK;
  output CFGMCLK;
  output EOS;
  output PREQ;

  input CLK;
  input GSR;
  input GTS;
  input KEYCLEARB;
  input PACK;
  input USRCCLKO;
  input USRCCLKTS;
  input USRDONEO;
  input USRDONETS;

  reg SIM_CCLK_FREQ_BINARY;
  reg [2:0] PROG_USR_BINARY;

  time CFGMCLK_PERIOD = 20000;
  reg cfgmclk_out;

  tri0 GSR = glbl.GSR;
  reg notifier;

  wire CFGCLK_OUT;
  wire CFGMCLK_OUT;
  wire EOS_OUT;
  wire PREQ_OUT;

  wire CLK_IN;
  wire GSR_IN;
  wire GTS_IN;
  wire KEYCLEARB_IN;
  wire PACK_IN;
  wire USRCCLKO_IN;
  wire USRCCLKTS_IN;
  wire USRDONEO_IN;
  wire USRDONETS_IN;

  wire CLK_INDELAY;
  wire GSR_INDELAY;
  wire GTS_INDELAY;
  wire KEYCLEARB_INDELAY;
  wire PACK_INDELAY;
  wire USRCCLKO_INDELAY;
  wire USRCCLKTS_INDELAY;
  wire USRDONEO_INDELAY;
  wire USRDONETS_INDELAY;

  wire start_count;
  integer edge_count = 0;
  reg preq_deassert = 0;
  reg PREQ_out = 0;


  initial begin
    case (PROG_USR)
      "FALSE" : PROG_USR_BINARY = 3'b000;
      "TRUE" : PROG_USR_BINARY = 3'b111;
      default : begin
        $display("Attribute Syntax Error : The Attribute PROG_USR on X_STARTUPE2 instance %m is set to %s.  Legal values for this attribute are FALSE, or TRUE.", PROG_USR);
        $finish;
      end
    endcase

    if ((SIM_CCLK_FREQ >= 0.0) && (SIM_CCLK_FREQ <= 10.0))
      SIM_CCLK_FREQ_BINARY = SIM_CCLK_FREQ;
    else begin
      $display("Attribute Syntax Error : The Attribute SIM_CCLK_FREQ on X_STARTUPE2 instance %m is set to %d.  Legal values for this attribute are  0.0 to 10.0.", SIM_CCLK_FREQ);
      $finish;
    end

  end
//-------------------------------------------------------------------------------
//----------------- Initial -----------------------------------------------------
//-------------------------------------------------------------------------------
  initial begin
      cfgmclk_out = 0;
      forever #(CFGMCLK_PERIOD/2.0) cfgmclk_out = !cfgmclk_out;
  end


//-------------------------------------------------------------------------------
//-------------------- PREQ -----------------------------------------------------
//-------------------------------------------------------------------------------

   assign start_count = (PREQ_out && PACK)? 1'b1 : 1'b0;

   always @(posedge cfgmclk_out) begin
      if(start_count)
         edge_count = edge_count + 1;
       else
         edge_count = 0;

      if(edge_count == 35)
        preq_deassert <= 1'b1;
      else
        preq_deassert <= 1'b0;
   end

  always @(negedge glbl.PROGB_GLBL, posedge preq_deassert)
     PREQ_out <= ~glbl.PROGB_GLBL || ~preq_deassert;

//-------------------------------------------------------------------------------
//-------------------- ERROR MSG ------------------------------------------------
//-------------------------------------------------------------------------------
  always @(posedge PACK) begin
     if(PREQ_out == 1'b0)
      $display("Error : PACK received with no associate PREQ in STARTTUPE2 instance %m.");
  end

//-------------------------------------------------------------------------------
//-------------------- OUTPUT ---------------------------------------------------
//-------------------------------------------------------------------------------

  assign CFGMCLK = cfgmclk_out;
  assign PREQ    = PREQ_out;

  specify
    specparam PATHPULSE$ = 0;
  endspecify
endmodule
