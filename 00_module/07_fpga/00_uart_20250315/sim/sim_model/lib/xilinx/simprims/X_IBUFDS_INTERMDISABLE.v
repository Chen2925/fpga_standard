///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2011 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 13.1
//  \   \         Description : Xilinx Timing Simulation Library Component
//  /   /                  Differential Signaling Input Buffer
// /___/   /\     Filename : X_IBUFDS_INTERMDISABLE.v
// \   \  /  \    Timestamp : Wed Apr 20 17:49:56 PDT 2011
//  \___\/\___\
//
// Revision:
//    04/20/11 - Initial version.
// End Revision

`timescale  1 ps / 1 ps


module X_IBUFDS_INTERMDISABLE (O, I, IB, IBUFDISABLE, INTERMDISABLE);

    parameter CAPACITANCE = "DONT_CARE";
    parameter DIFF_TERM = "FALSE";
    parameter IBUF_DELAY_VALUE = "0";
    parameter IBUF_LOW_PWR = "TRUE";
    parameter IFD_DELAY_VALUE = "AUTO";
    parameter IOSTANDARD = "DEFAULT";
    parameter LOC = "UNPLACED";

    output O;

    input  I;
    input  IB;
    input  IBUFDISABLE;
    input  INTERMDISABLE;

    reg o_out;

    initial begin
	
        case (CAPACITANCE)

            "LOW", "NORMAL", "DONT_CARE" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute CAPACITANCE on X_IBUFDS_INTERMDISABLE instance %m is set to %s.  Legal values for this attribute are DONT_CARE, LOW or NORMAL.", CAPACITANCE);
                          $finish;
                      end

        endcase

	case (DIFF_TERM)

            "TRUE", "FALSE" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute DIFF_TERM on X_IBUFDS_INTERMDISABLE instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", DIFF_TERM);
                          $finish;
                      end

	endcase // case(DIFF_TERM)


	case (IBUF_DELAY_VALUE)

            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute IBUF_DELAY_VALUE on X_IBUFDS_INTERMDISABLE instance %m is set to %s.  Legal values for this attribute are 0, 1, 2, ... or 16.", IBUF_DELAY_VALUE);
                          $finish;
                      end

        endcase

        case (IBUF_LOW_PWR)

            "FALSE", "TRUE" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute IBUF_LOW_PWR on IBUF instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", IBUF_LOW_PWR);
                          $finish;
                      end

        endcase

	case (IFD_DELAY_VALUE)

            "AUTO", "0", "1", "2", "3", "4", "5", "6", "7", "8" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute IFD_DELAY_VALUE on X_IBUFDS_INTERMDISABLE instance %m is set to %s.  Legal values for this attribute are AUTO, 0, 1, 2, ... or 8.", IFD_DELAY_VALUE);
                          $finish;
                      end

	endcase

    end

    always @(I or IB) 
	if (I == 1'b1 && IB == 1'b0)
	    o_out = I;
	else if (I == 1'b0 && IB == 1'b1)
	    o_out = I;
        else if (I == 1'bx || I == 1'bz || IB == 1'bx || IB == 1'bz)
            o_out = 1'bx;

    assign O = (IBUFDISABLE == 0)? o_out : (IBUFDISABLE == 1)? 1'b0  : 1'bx;

    specify
        (I => O)                = (0:0:0,  0:0:0);
        (IB => O)               = (0:0:0,  0:0:0);
        (IBUFDISABLE => O)      = (0:0:0,  0:0:0);
        (INTERMDISABLE => O)    = (0:0:0,  0:0:0);
        specparam PATHPULSE$ = 0;
    endspecify
    

endmodule
