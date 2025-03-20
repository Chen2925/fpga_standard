// =================================================================================================
// File Name      : ascii2hex.v
// Module         : ASCII2HEX
// Function       : ASCII2HEX
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

module ASCII2HEX (
    input                               USER_CLK                                ,// (i) [   1]
    input                               USER_RST                                ,// (i) [   1]

    input                               ASCII_VLD                               ,// (i) [   1]
    input       [   7:0]                ASCII                                   ,// (i) [   8]
    output                              HEX_VLD                                 ,// (o) [   1]
    output                              HEX_ERR                                 ,// (o) [   1]
    output      [   3:0]                HEX                                      // (o) [   4]
);

// =============================================================================
// Internal Parameter Declare
// =============================================================================


// =============================================================================
// Internal signals declaration
// =============================================================================
    reg                                 r_HEX_VLD                               ;
    reg                                 r_HEX_ERR                               ;
    reg         [   3:0]                r_HEX                                   ;

// =================================================================================================
// RTL Body
// =================================================================================================


/*==============================================================================+/
||                                                                              ||
||                                Output Ports                                  ||
||                                                                              ||
/+==============================================================================*/
    assign HEX_VLD                      = r_HEX_VLD             ;
    assign HEX_ERR                      = r_HEX_ERR             ;
    assign HEX                          = r_HEX                 ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_HEX_VLD                   <= 1'b0                 ;
        end else begin
            r_HEX_VLD                   <= ASCII_VLD            ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_HEX                       <= 'd0                  ;
            r_HEX_ERR                   <= 1'b0                 ;
        end else begin
            if(ASCII[7] == 1'b0) begin
                if((ASCII[6:0] >= 7'h30) && (ASCII[6:0] < 7'h3A)) begin
                    r_HEX               <= ASCII[3:0]           ;
                    r_HEX_ERR           <= 1'b0                 ;
                end else if((ASCII[6:0] >= 7'h41) && (ASCII[6:0] < 7'h47)) begin
                    r_HEX               <= ASCII[3:0] + 4'd9    ;
                    r_HEX_ERR           <= 1'b0                 ;
                end else begin
                    r_HEX               <= 'd0                  ;
                    r_HEX_ERR           <= 1'b1                 ;
                end
            end else begin
                r_HEX                   <= 'd0                  ;
                r_HEX_ERR               <= 1'b1                 ;
            end
        end
    end

endmodule
