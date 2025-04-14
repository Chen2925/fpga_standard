///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2011 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  3-State Diffential Signaling I/O Buffer
// /___/   /\     Filename : IOBUFDS_DIFF_OUT_INTERMDISABLE.v
// \   \  /  \    Timestamp : Wed Apr 20 17:49:56 PDT 2011
//  \___\/\___\
//
// Revision:
//    04/20/11 - Initial version.
// End Revision

`timescale  1 ps / 1 ps


module IOBUFDS_DIFF_OUT_INTERMDISABLE (O, OB, IO, IOB, I, IBUFDISABLE, INTERMDISABLE, TM, TS);

    parameter DIFF_TERM = "FALSE";
    parameter IBUF_LOW_PWR = "TRUE";
    parameter IOSTANDARD = "DEFAULT";

    output O;
    output OB;
    inout  IO;
    inout  IOB;
    input  I;
    input  IBUFDISABLE;
    input  INTERMDISABLE;
    input  TM;
    input  TS;

    wire t1, t2;

    tri0 GTS = glbl.GTS;

    or O1 (t1, GTS, TM);
    bufif0 B1 (IO, I, t1);

    or O2 (t2, GTS, TS);
    notif0 N2 (IOB, I, t2);

    reg O_int, OB_int;

    initial begin
	
        case (DIFF_TERM)

            "TRUE", "FALSE" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute DIFF_TERM on IOBUFDS_DIFF_OUT_INTERMDISABLE instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", DIFF_TERM);
                          $finish;
                      end

        endcase // case(DIFF_TERM)
        case (IBUF_LOW_PWR)

            "FALSE", "TRUE" : ;
            default : begin
                          $display("Attribute Syntax Error : The attribute IBUF_LOW_PWR on IOBUFDS_DIFF_OUT_INTERMDISABLE instance %m is set to %s.  Legal values for this attribute are TRUE or FALSE.", IBUF_LOW_PWR);
                          $finish;
                      end

        endcase

    end


    always @(IO or IOB) begin
        if (IO == 1'b1 && IOB == 1'b0) begin
            O_int  = IO;
            OB_int = ~IO;
        end
        else if (IO == 1'b0 && IOB == 1'b1) begin
            O_int  = IO;
            OB_int = ~IO;
        end
        else begin
            O_int  = 1'bx;
            OB_int = 1'bx;
        end
    end

    assign O  = (IBUFDISABLE == 1'b1) ? 1'b0 : (IBUFDISABLE == 1'b0) ? O_int  : 1'bx;
    assign OB = (IBUFDISABLE == 1'b1) ? 1'b0 : (IBUFDISABLE == 1'b0) ? OB_int : 1'bx;

endmodule
