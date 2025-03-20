// =================================================================================================
// File Name      : crc8_para4.v
// Module         : CRC8_PARA4
// Function       : CRC8_PARA4
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level    Date         Coded by          Contents            Comp
// 0.0.1        2018/12/26   Base.L            create new          speed-clouds
// Crc8 parallel x4
// =================================================================================================
// End Revision
// =================================================================================================

`timescale 1ns/1ps

module CRC8_PARA4 (
    input                               USER_CLK                                ,// (i) [   1]
    input                               USER_RST                                ,// (i) [   1]

    input                               CALC_EN                                 ,// (i) [   1]
    input                               SRC_DVLD                                ,// (i) [   1]
    input       [   3:0]                SRC_DIN                                 ,// (i) [   4]
    output                              CRC_DVLD                                ,// (o) [   1]
    output      [   7:0]                CRC_DOUT                                 // (o) [   8]
);


// =============================================================================
// Internal Parameter Declare
// =============================================================================


// =============================================================================
// Internal signals declaration
// =============================================================================
    reg                                 r_CRC_DVLD                              ;

    wire        [   3:0]                s_DIN                                   ;
    reg         [   7:0]                r_OBUF                                  ;



// =================================================================================================
// RTL Body
// =================================================================================================


/*==============================================================================+/
||                                                                              ||
||                                Output Ports                                  ||
||                                                                              ||
/+==============================================================================*/

    assign CRC_DVLD                     = r_CRC_DVLD            ;
    assign CRC_DOUT                     = r_OBUF ^ 8'h55        ;


    assign s_DIN                        = SRC_DIN               ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_OBUF                      <= 8'h00                                                    ;
        end else begin
            if( CALC_EN ) begin
                if( SRC_DVLD ) begin
                    r_OBUF[7]           <= r_OBUF[3]                                                ;
                    r_OBUF[6]           <= r_OBUF[2]                                                ;
                    r_OBUF[5]           <= r_OBUF[7]^s_DIN[3]^r_OBUF[1]                             ;
                    r_OBUF[4]           <= r_OBUF[6]^s_DIN[2]^r_OBUF[7]^s_DIN[3]^r_OBUF[0]          ;
                    r_OBUF[3]           <= r_OBUF[5]^s_DIN[1]^r_OBUF[6]^s_DIN[2]^r_OBUF[7]^s_DIN[3] ;
                    r_OBUF[2]           <= r_OBUF[4]^s_DIN[0]^r_OBUF[5]^s_DIN[1]^r_OBUF[6]^s_DIN[2] ;
                    r_OBUF[1]           <= r_OBUF[4]^s_DIN[0]^r_OBUF[5]^s_DIN[1]                    ;
                    r_OBUF[0]           <= r_OBUF[4]^s_DIN[0]                                       ;
                end
            end else begin
                r_OBUF                  <= 8'h00                                                    ;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_CRC_DVLD                  <= 1'b0             ;
        end else begin
            if(CALC_EN) begin
                r_CRC_DVLD              <= SRC_DVLD         ;
            end else begin
                r_CRC_DVLD              <= 1'b0             ;
            end
        end
    end

endmodule


