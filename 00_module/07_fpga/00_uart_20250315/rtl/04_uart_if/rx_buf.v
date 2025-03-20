// =================================================================================================
// File Name      : rx_buf.v
// Module         : RX_BUF
// Function       : RX_BUF
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

module RX_BUF (
    input                               USER_CLK                                ,//(i)[   1]
    input                               USER_RST                                ,//(i)[   1]

    input                               UART_RX_ERR                             ,//(i)[   1]
    input                               UART_RX_VLD                             ,//(i)[   1]
    input       [   7:0]                UART_RX_DAT                             ,//(i)[   8]
    //
    output                              FRAME_TIMEOUT                           ,//(o)[   1]
    output                              FRAME_DVLD                              ,//(o)[   1]
    output      [   7:0]                FRAME_DATA                               //(o)[   8]
    );


// =============================================================================
// Internal Parameter Declare
// =============================================================================

    parameter                           p_ASCII_LF          = 8'h0A             ;
    parameter                           p_ASCII_DEL         = 8'h7F             ;
    parameter                           P_WR            = 48'h5245475F5752      ;//REG_WR
    parameter                           P_RD            = 48'h5245475F5244      ;//REG_RD

// =============================================================================
// Internal signals declaration
// =============================================================================

    reg         [ 175:0]       r_FRAME_BUF                             ;//(r)[  1]
    wire                                s_UART_END_FLAG                         ;//(s)[  1]
    wire                                s_UART_WR_FLAG                          ;//(s)[  1]
    wire                                s_UART_RD_FLAG                          ;//(s)[  1]
    reg         [   5:0]                r_CNT_SHIFT                             ;//(r)[  6]
    reg                                 r_UART_CONV_FLAG                        ;//(r)[  1]
    reg                                 r_UART_WR_FLAG                          ;//(r)[  1]
    reg                                 r_UART_RD_FLAG                          ;//(r)[  1]
    wire                                s_FRAME_DVLD                            ;//(s)[  1]
    wire        [   7:0]                s_FRAME_DATA                            ;//(s)[  8]

// =================================================================================================
// RTL Body
// =================================================================================================

/*==============================================================================+/
||                                                                              ||
||                                Output Ports                                  ||
||                                                                              ||
/+==============================================================================*/

    assign FRAME_TIMEOUT                = 1'b0                                  ;
    assign FRAME_DATA                   = s_FRAME_DATA                          ;
    assign FRAME_DVLD                   = s_FRAME_DVLD                          ;

/*==============================================================================+/
||                                                                              ||
||                               Data Buffer Ctrl                               ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_FRAME_BUF                 <= 'd0              ;
        end else begin
            if( UART_RX_VLD & (UART_RX_DAT == p_ASCII_DEL)) begin
                r_FRAME_BUF             <= {8'h00,r_FRAME_BUF[175:8]};
            end else if( UART_RX_VLD ) begin
                r_FRAME_BUF             <= {r_FRAME_BUF[176-9:0],UART_RX_DAT};
            end else if( r_UART_CONV_FLAG & r_CNT_SHIFT[5] ) begin
                r_FRAME_BUF             <= {r_FRAME_BUF[176-9:0],8'h00};
            end else if(UART_RX_ERR ) begin
                r_FRAME_BUF             <= 'd0              ;
            end
        end
    end

    assign s_UART_END_FLAG              = UART_RX_VLD & (UART_RX_DAT == p_ASCII_LF) ;
    assign s_UART_WR_FLAG               = r_FRAME_BUF[175:128] == P_WR ;
    assign s_UART_RD_FLAG               = r_FRAME_BUF[103:56] == P_RD ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_CNT_SHIFT                 <= 6'b00_0001 ;
        end else begin
            r_CNT_SHIFT                 <= {r_CNT_SHIFT[4:0],r_CNT_SHIFT[5]} ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_UART_CONV_FLAG            <= 1'b0 ;
        end else if(s_UART_END_FLAG) begin
            r_UART_CONV_FLAG            <= 1'b1 ;
        end else if(s_FRAME_DVLD & (s_FRAME_DATA == 8'h0A)) begin
            r_UART_CONV_FLAG            <= 1'b0 ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_UART_WR_FLAG              <= 1'b0 ;
            r_UART_RD_FLAG              <= 1'b0 ;
        end else if(s_UART_WR_FLAG) begin
            r_UART_WR_FLAG              <= 1'b1 ;
        end else if(s_UART_RD_FLAG) begin
            r_UART_RD_FLAG              <= 1'b1 ;
        end else if(s_FRAME_DVLD & (s_FRAME_DATA == 8'h0A)) begin
            r_UART_WR_FLAG              <= 1'b0 ;
            r_UART_RD_FLAG              <= 1'b0 ;
        end
    end

    assign s_FRAME_DVLD                 = r_UART_CONV_FLAG & r_CNT_SHIFT[4]  ;
    assign s_FRAME_DATA = (r_UART_CONV_FLAG & r_CNT_SHIFT[4])? (r_UART_WR_FLAG ? r_FRAME_BUF[175:168] :
                                                              r_UART_RD_FLAG ? r_FRAME_BUF[103:96] : 'b0 ): 'b0;

endmodule
