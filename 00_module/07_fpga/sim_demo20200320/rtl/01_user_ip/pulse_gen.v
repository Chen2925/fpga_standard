// =================================================================================================
// File Name      : pulse_gen.v
// Module         : PULSE_GEN
// Function       : aschronous to synchronous
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level    Date         Coded by          Contents            Comp
// 0.0.1        2018/08/24   xxxxxx            create new          x
// =================================================================================================
// End Revision
// =================================================================================================

`timescale 1 ps/1 ps

module PULSE_GEN (
    input                               RST                                     ,
    input                               CLK_I                                   ,
    input                               CLK_O                                   ,
    input                               PULSE_I                                 ,
    output                              PULSE_O
    );

// =============================================================================
// Internal Signal Declare
// =============================================================================

    reg                                 r_PULSE_I                               ;
    reg             [3:0]               r_PULSE_O                               ;
    wire                                s_PULSE_O                               ;
    reg                                 r_PULSE_O2                              ;

// =================================================================================================
// RTL Body
// =================================================================================================

    always @( posedge CLK_I or posedge RST ) begin
        if ( RST ) begin
            r_PULSE_I                   <= 1'b0 ;
        end else begin
            if ( PULSE_I == 1'b1 ) begin
                r_PULSE_I               <= ~ r_PULSE_I ;
            end
        end
    end

    always @( posedge CLK_O or posedge RST ) begin
        if ( RST ) begin
            r_PULSE_O                   <= 4'b0000 ;
        end else begin
            r_PULSE_O                   <= { r_PULSE_O[2:0] , r_PULSE_I } ;
        end
    end

    assign s_PULSE_O                    = (r_PULSE_O[3] != r_PULSE_O[2] ) ;

    always @( posedge CLK_O or posedge RST ) begin
        if ( RST ) begin
            r_PULSE_O2                  <= 1'b0 ;
        end else begin
            r_PULSE_O2                  <= s_PULSE_O ;
        end
    end

    assign PULSE_O                      = r_PULSE_O2 ;

endmodule