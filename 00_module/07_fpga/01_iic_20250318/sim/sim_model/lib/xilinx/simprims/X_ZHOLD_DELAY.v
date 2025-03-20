///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2010 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 13.0
//  \   \         Description : Xilinx TEST ONLY Library Component
//  /   /                  Delay Element.
// /___/   /\     Filename : X_ZHOLD_DELAY.v
// \   \  /  \    Timestamp : Wed Apr 14 15:49:29 PDT 2010
//  \___\/\___\
//
// Revision:
//    04/14/10 - Initial version.
//    06/10/10 - 564856 -- Removed tap delay since the delay is annotated directly
// End Revision

`timescale  1 ps / 1 ps

module X_ZHOLD_DELAY (
          DLYFABRIC,
          DLYIFF,
          DLYIN
       );

       parameter integer IDELAY_VALUE     = 0;
       parameter integer IFF_DELAY_VALUE = 0;
       parameter ZHOLD_FABRIC = "FALSE";
       parameter ZHOLD_IFF = "FALSE";

       parameter LOC = "UNPLACED";
       parameter integer SIM_DELAY_D = 0;
       localparam DELAY_D = SIM_DELAY_D;

       output DLYFABRIC;
       output DLYIFF;

       input  DLYIN;


       tri0  GSR = glbl.GSR;

//------------------- constants ------------------------------------
       localparam MAX_IFF_DELAY_COUNT = 31;
       localparam MIN_IFF_DELAY_COUNT = 0;

       localparam MAX_IDELAY_COUNT = 31;
       localparam MIN_IDELAY_COUNT = 0;

       reg notifier;


       integer idelay_count=0;
       integer iff_idelay_count=0;

       // inputs
       wire dlyin_in;


//----------------------------------------------------------------------
//-------------------------------  Output ------------------------------
//----------------------------------------------------------------------
       assign DLYFABRIC = dlyin_in;
       assign DLYIFF    = dlyin_in;

//----------------------------------------------------------------------
//-------------------------------  Input -------------------------------
//----------------------------------------------------------------------
       assign dlyin_in = DLYIN;


//------------------------------------------------------------
//---------------------   Initialization  --------------------
//------------------------------------------------------------
       initial begin

        //-------- ZHOLD_FABRIC check
           case (ZHOLD_FABRIC)
               "TRUE"  : idelay_count = IDELAY_VALUE;
               "FALSE" : idelay_count = 0;
               default : begin
                  $display("Attribute Syntax Error : The attribute ZHOLD_FABRIC on X_ZHOLD_DELAY instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.",  ZHOLD_FABRIC);
                  $finish;
               end
           endcase

        //-------- ZHOLD_IFF check
           case (ZHOLD_IFF)
               "TRUE"  : iff_idelay_count = IFF_DELAY_VALUE;
               "FALSE" : iff_idelay_count = 0;
               default : begin
                  $display("Attribute Syntax Error : The attribute ZHOLD_IFF on X_ZHOLD_DELAY instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.",  ZHOLD_IFF);
                  $finish;
               end
           endcase

        //-------- IDELAY_VALUE check
           if (IDELAY_VALUE < MIN_IDELAY_COUNT || IDELAY_VALUE > MAX_IDELAY_COUNT) begin
               $display("Attribute Syntax Error : The attribute IDELAY_VALUE on X_ZHOLD_DELAY instance %m is set to %d.  Legal values for this attribute are 0, 1, 2, 3, .... or 31", IDELAY_VALUE);
               $finish;

           end


        //-------- IFF_DELAY_VALUE check
           if (IFF_DELAY_VALUE < MIN_IFF_DELAY_COUNT || IFF_DELAY_VALUE > MAX_IFF_DELAY_COUNT) begin
               $display("Attribute Syntax Error : The attribute IFF_DELAY_VALUE on X_ZHOLD_DELAY instance %m is set to %d.  Legal values for this attribute are 0, 1, 2, 3, .... or 31", IFF_DELAY_VALUE);
               $finish;

           end

       end // initial begin



    specify

       ( DLYIN => DLYFABRIC) = (0:0:0, 0:0:0);
       ( DLYIN => DLYIFF)    = (0:0:0, 0:0:0);

       specparam PATHPULSE$ = 0;
    endspecify

endmodule // X_XHOLD_DELAY
