///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2010 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 13.1
//  \   \         Description : Xilinx Timing Simulation Library Component
//  /   /                  Bi-Directional Buffer
// /___/   /\     Filename : X_IOBUF_DCIEN.v
// \   \  /  \    Timestamp : Wed Dec  8 17:04:24 PST 2010
//  \___\/\___\
//
// Revision:
//    12/08/10 - Initial version.
//    03/28/11 - CR 603466 fix
// End Revision

`timescale  1 ps / 1 ps


module X_IOBUF_DCIEN (O, IO, DCITERMDISABLE, I, IBUFDISABLE, T);

    parameter CAPACITANCE = "DONT_CARE";
    parameter integer DRIVE = 12;
    parameter IBUF_DELAY_VALUE = "0";
    parameter IBUF_LOW_PWR = "TRUE";
    parameter IFD_DELAY_VALUE = "AUTO";
    parameter IOSTANDARD = "DEFAULT";
    parameter LOC = "UNPLACED";
    parameter SLEW = "SLOW";

    output O;
    inout  IO;
    input  DCITERMDISABLE;
    input  I;
    input  IBUFDISABLE;
    input  T;

    wire ts;

    tri0 GTS = glbl.GTS;

    or O1 (ts, GTS, T);
    bufif0 T1 (IO, I, ts);

    and a1 (disable_out, DCITERMDISABLE, IBUFDISABLE);

//    buf B1 (O, IO);

    initial begin
	
        case (CAPACITANCE)

            "LOW", "NORMAL", "DONT_CARE" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute CAPACITANCE on X_IOBUF_DCIEN instance %m is set to %s.  Legal values for this attribute are DONT_CARE, LOW or NORMAL.", CAPACITANCE);
                          $finish;
                      end

        endcase

	case (IBUF_DELAY_VALUE)

            "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute IBUF_DELAY_VALUE on X_IOBUF_DCIEN instance %m is set to %s.  Legal values for this attribute are 0, 1, 2, ... or 16.", IBUF_DELAY_VALUE);
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
                          $display("Attribute Syntax Error : The attribute IFD_DELAY_VALUE on X_IOBUF_DCIEN instance %m is set to %s.  Legal values for this attribute are AUTO, 0, 1, 2, ... or 8.", IFD_DELAY_VALUE);
                          $finish;
                      end

	endcase
	
    end // initial begin
    
    assign O = (IBUFDISABLE == 1'b1) ? 1'b0 : (IBUFDISABLE == 1'b0) ? IO : 1'bx;

    specify

        (DCITERMDISABLE => O)   = (0:0:0,  0:0:0);
        (DCITERMDISABLE => IO)  = (0:0:0,  0:0:0);
        (I => O)                = (0:0:0,  0:0:0);
        (I => IO)               = (0:0:0,  0:0:0);
        (IO => O)               = (0:0:0,  0:0:0);
        (IBUFDISABLE => O)      = (0:0:0,  0:0:0);
        (IBUFDISABLE => IO)     = (0:0:0,  0:0:0);
        (T => O)               = (0:0:0,  0:0:0);
        (T => IO)              = (0:0:0,  0:0:0);
        specparam PATHPULSE$ = 0;
    endspecify

endmodule
