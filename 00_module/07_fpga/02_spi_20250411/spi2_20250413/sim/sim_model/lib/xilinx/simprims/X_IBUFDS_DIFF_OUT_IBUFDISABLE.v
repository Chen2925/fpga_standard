///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2010 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 13.1
//  \   \         Description : Xilinx Timing Simulation Library Component
//  /   /                  Differential Signaling Input Buffer with Differential Outputs
// /___/   /\     Filename : X_IBUFDS_DIFF_OUT_IBUFDISABLE.v
// \   \  /  \    Timestamp : Wed Dec  8 17:04:24 PST 2010
//  \___\/\___\
//
// Revision:
//    12/08/10 - Initial version.
//    04/04/11 - CR 604808 fix
// End Revision

`timescale  1 ps / 1 ps


module X_IBUFDS_DIFF_OUT_IBUFDISABLE (O, OB, I, IB, IBUFDISABLE);

    parameter DIFF_TERM = "FALSE";
    parameter IBUF_LOW_PWR = "TRUE";
    parameter IOSTANDARD = "DEFAULT";
    parameter LOC = "UNPLACED";

    output O; 
    output OB;

    input I;
    input IB;
    input IBUFDISABLE;

    reg  o_out;

    initial begin
        case (DIFF_TERM)

            "TRUE", "FALSE" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute DIFF_TERM on X_IBUFDS_DIFF_OUT_IBUFDISABLE instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", DIFF_TERM);
                          $finish;
                      end

        endcase // case(DIFF_TERM)

        case (IBUF_LOW_PWR)

            "FALSE", "TRUE" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute IBUF_LOW_PWR on X_IBUFDS_DIFF_OUT_IBUFDISABLE instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", IBUF_LOW_PWR);
                          $finish;
                      end

        endcase

    end


    always @(I or IB) begin
	if (I == 1'b1 && IB == 1'b0)
	    o_out <= I;
	else if (I == 1'b0 && IB == 1'b1)
	    o_out <= I;
        else if (I == 1'bx || IB == 1'bx)
            o_out <= 1'bx;
    end

    assign O  = (IBUFDISABLE == 0)? o_out  : (IBUFDISABLE == 1)? 1'b0  : 1'bx;
    assign OB = (IBUFDISABLE == 0)? ~o_out : (IBUFDISABLE == 1)? 1'b0  : 1'bx;


    specify
        (I => O)                = (0:0:0,  0:0:0);
        (I => OB)               = (0:0:0,  0:0:0);
        (IB => O)               = (0:0:0,  0:0:0);
        (IB => OB)              = (0:0:0,  0:0:0);
        (IBUFDISABLE => O)      = (0:0:0,  0:0:0);
        (IBUFDISABLE => OB)     = (0:0:0,  0:0:0);
        specparam PATHPULSE$ = 0;
    endspecify


endmodule
