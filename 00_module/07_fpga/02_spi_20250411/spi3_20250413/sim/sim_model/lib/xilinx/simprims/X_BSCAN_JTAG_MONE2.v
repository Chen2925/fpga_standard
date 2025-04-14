///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2010 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 13.1
//  \   \         Description : Xilinx Timing Simulation Library Component
//  /   /                  Boundary Scan Logic Control Circuit for VIRTEX7
// /___/   /\     Filename : X_BSCAN_JTAG_MONE2.v
// \   \  /  \    Timestamp : Mon Sep 20 10:04:30 PDT 2010
//  \___\/\___\
//
// Revision:
//    09/20/10 - Initial version.
// End Revision


`timescale 1 ps / 1 ps 

module X_BSCAN_JTAG_MONE2 (
  TCK,
  TDI,
  TMS
);

  parameter LOC = "UNPLACED";

  output TCK;
  output TDI;
  output TMS;


//--####################################################################
//--#####                            Output                          ###
//--####################################################################

  assign TCK     = glbl.JTAG_TCK_GLBL;
  assign TDI     = glbl.JTAG_TDI_GLBL;
  assign TMS     = glbl.JTAG_TMS_GLBL;

  specify
    specparam PATHPULSE$ = 0;
  endspecify

endmodule
