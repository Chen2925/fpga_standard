// =================================================================================================
// File Name      : hex2ascii.v
// Module         : HEX2ASCII
// Function       : HEX2ASCII
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level    Date         Coded by          Contents            Comp
// 0.0.1        2018/12/26   Base.L            create new          speed-clouds
// =================================================================================================
// End Revision
// =================================================================================================

`timescale 1ns/1ps

module HEX2ASCII (
    input                               USER_CLK                                ,// (i) [   1]
    input                               USER_RST                                ,// (i) [   1]

    input                               HEX_VLD                                 ,// (i) [   1]
    input       [   3:0]                HEX                                     ,// (i) [   4]
    output                              ASCII_VLD                               ,// (o) [   1]
    output      [   7:0]                ASCII                                    // (o) [   8]
);


// =============================================================================
// Internal Parameter Declare
// =============================================================================


// =============================================================================
// Internal signals declaration
// =============================================================================
    reg                                 r_ASCII_VLD                             ;
    reg         [   7:0]                r_ASCII                                 ;

// =================================================================================================
// RTL Body
// =================================================================================================


/*==============================================================================+/
||                                                                              ||
||                                Output Ports                                  ||
||                                                                              ||
/+==============================================================================*/
    assign ASCII_VLD                    = r_ASCII_VLD           ;
    assign ASCII                        = r_ASCII               ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_ASCII_VLD                 <= 1'b0                 ;
        end else begin
            r_ASCII_VLD                 <= HEX_VLD              ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_ASCII                     <= 'd0                  ;
        end else begin
            if(HEX < 'd10) begin
                r_ASCII                 <= HEX + 8'h30          ;
            end else begin
                r_ASCII                 <= HEX + 8'h37          ;
            end
        end
    end

endmodule
