//=================================================================================================
// File Name      : tx_pak.v
// Module         : TX_PAK
// Function       : TX_PAK
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

module TX_PAK (
    input                               USER_CLK                                ,// (i) [   1]
    input                               USER_RST                                ,// (i) [   1]

    // User Register Signal
    input                               REG_WR_ACK                              ,// (i) [   1]
    input                               REG_RD_ACK                              ,// (i) [   1]
    input       [  31:0]                REG_RD_DATA                             ,// (i) [  32]

    // Frame Buffer write
    output                              UART_TX_REQ                             ,// (o) [   1]
    input                               UART_TX_ACK                             ,// (i) [   1]
    output       [   7:0]               UART_TX_DAT                              // (o) [   8]
);

// =============================================================================
// Internal Parameter Declare
// =============================================================================


// =============================================================================
// Internal signals declaration
// =============================================================================

    reg                                 r_HEX_DVLD                              ;
    wire                                s_HEX_END                               ;
    reg          [  10:0]               r_HEX_SHIFT                             ;
    reg          [  31:0]               r_HEX_DIN                               ;
    wire         [   3:0]               s_HEX_DIN                               ;
    reg          [  63:0]               r_ASCII_DOUT                            ;
    wire                                s_ASCII_END                             ;
    wire                                s_ASCII_DVLD                             ;
    wire         [   7:0]               s_ASCII_DOUT                             ;
    reg          [  63:0]               r_TX_RDAT                               ;

    reg                                 r_ASCII_END                             ;
    reg          [  79:0]               r_TX_DATA                               ;

    reg                                 r_TX_WEN                                ;
    reg                                 r_TX_REN                                ;
(*KEEP="TRUE",mark_debug="true"*)    reg                                 r_TX_EN                                 ;
    reg          [   7:0]               r_TX_CNT                                ;
    wire                                s_TX_WEND                               ;
    wire                                s_TX_REND                               ;
    wire                                s_TX_END                                ;
    reg          [  79:0]               r_UART_TX_DAT                           ;
(*KEEP="TRUE",mark_debug="true"*)    wire         [   7:0]               s_UART_TX_DAT                           ;

// =================================================================================================
// RTL Body
// =================================================================================================

/*==============================================================================+/
||                                                                              ||
||                                Output Ports                                  ||
||                                                                              ||
/+==============================================================================*/

    assign UART_TX_REQ                  = r_TX_EN                               ;
    assign UART_TX_DAT                  = s_UART_TX_DAT                         ;

/*==============================================================================+/
||                                                                              ||
||                                READ Ctrl                                     ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_HEX_DVLD                <= 'b0 ;
        end else begin
            if (REG_RD_ACK) begin
                r_HEX_DVLD              <= 1'b1 ;
            end else if (s_HEX_END) begin
                r_HEX_DVLD              <= 1'b0 ;
            end
        end
    end

    assign s_HEX_END                     = r_HEX_SHIFT[7] ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_HEX_SHIFT                 <= 'B0 ;
        end else begin
            r_HEX_SHIFT                 <= {r_HEX_SHIFT[9:0] , REG_RD_ACK} ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_HEX_DIN                   <= 'b0 ;
        end else begin
            if (REG_RD_ACK) begin
                r_HEX_DIN               <= REG_RD_DATA ;
            end else if (r_HEX_DVLD)begin
                r_HEX_DIN               <= {r_HEX_DIN[27:0] , r_HEX_DIN[31:28]} ;
            end
        end
    end

    assign s_HEX_DIN                    = r_HEX_DIN[31:28] ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_ASCII_DOUT                <= 'b0 ;
        end else begin
            if (s_ASCII_DVLD) begin
                r_ASCII_DOUT            <= {r_ASCII_DOUT[55:0] , s_ASCII_DOUT} ;
            end else begin
                r_ASCII_DOUT            <= r_ASCII_DOUT ;
            end
        end
    end

    assign s_ASCII_END                  = r_HEX_SHIFT[9] ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_TX_RDAT                   <= 'b0 ;
        end else begin
            if (s_ASCII_END) begin
                r_TX_RDAT               <= r_ASCII_DOUT ;
            end else begin
                r_TX_RDAT               <= r_TX_RDAT ;
            end
        end
    end

/*==============================================================================+/
||                                                                              ||
||                              UART DATA                                       ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_ASCII_END                 <= 'B0 ;
        end else begin
            r_ASCII_END                 <= s_ASCII_END ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_TX_DATA                   <= 'b0 ;
        end else begin
            if (REG_WR_ACK) begin
                r_TX_DATA               <= {32'h4f4b0D0A , 48'h0};
            end else if (r_ASCII_END) begin
                r_TX_DATA               <= {r_TX_RDAT,16'h0D0A} ;
            end
        end
    end

/*==============================================================================+/
||                                                                              ||
||                              UART IF                                         ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_TX_WEN                    <= 'b0 ;
        end else begin
            if (REG_WR_ACK) begin
                r_TX_WEN                 <= 1'b1 ;
            end else if (s_TX_END) begin
                r_TX_WEN                 <= 1'b0 ;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_TX_REN                    <= 'b0 ;
        end else begin
            if (r_ASCII_END) begin
                r_TX_REN                 <= 1'b1 ;
            end else if (s_TX_END) begin
                r_TX_REN                 <= 1'b0 ;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_TX_EN                     <= 'b0 ;
        end else begin
            if (REG_WR_ACK | r_ASCII_END) begin
                r_TX_EN                 <= 1'b1 ;
            end else if (s_TX_END) begin
                r_TX_EN                 <= 1'b0 ;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_TX_CNT                    <= 'b0 ;
        end else begin
            if (UART_TX_ACK) begin
                r_TX_CNT                <= r_TX_CNT + 1'b1 ;
            end else if (s_TX_END) begin
                r_TX_CNT                <= 'b0 ;
            end
        end
    end

    assign s_TX_WEND                    = (r_TX_CNT == 8'h4) ;
    assign s_TX_REND                    = (r_TX_CNT == 8'hA) ;
    assign s_TX_END                     = r_TX_WEN ? s_TX_WEND :
                                          r_TX_REN ? s_TX_REND : 1'b0 ;

//  always @(posedge USER_CLK or posedge USER_RST) begin
//      if(USER_RST) begin
//          r_UART_TX_REQ                <= 'b0 ;
//      end else begin
//          if (UART_TX_ACK) begin
//              r_UART_TX_REQ           <= 1'b0 ;
//          end else begin
//              r_UART_TX_REQ           <= r_TX_EN ;
//          end
//      end
//  end

//  always @(posedge USER_CLK or posedge USER_RST) begin
//      if(USER_RST) begin
//          r_UART_TX_DAT               <= 'b0 ;
//      end else begin
//          if (UART_TX_ACK) begin
//              r_UART_TX_DAT           <= {r_TX_DATA[71:0],r_TX_DATA[79:72]} ;
//          end else begin
//              r_UART_TX_DAT           <= r_UART_TX_DAT ;
//          end
//      end
//  end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_UART_TX_DAT               <= 'b0 ;
        end else begin
            if (r_TX_EN ) begin
                if ((r_TX_CNT == 4'b0 ) & UART_TX_ACK) begin
                    r_UART_TX_DAT       <= r_TX_DATA ;
                end else if (UART_TX_ACK) begin
                    r_UART_TX_DAT       <= {r_UART_TX_DAT[71:0],r_UART_TX_DAT[79:72]} ;
                end
            end else begin
                r_UART_TX_DAT           <= r_UART_TX_DAT ;
            end
        end
    end

    assign s_UART_TX_DAT                = r_UART_TX_DAT[79:72] ;

/*==============================================================================+/
||                                                                              ||
||                              HEX to Ascii & CRC8                             ||
||                                                                              ||
/+==============================================================================*/

    HEX2ASCII U_HEX2ASCII (
        .USER_CLK                       ( USER_CLK              ),// (i) [   1]
        .USER_RST                       ( USER_RST              ),// (i) [   1]

        .HEX_VLD                        ( r_HEX_DVLD            ),// (i) [   1]
        .HEX                            ( s_HEX_DIN             ),// (i) [   4]
        .ASCII_VLD                      ( s_ASCII_DVLD          ),// (o) [   1]
        .ASCII                          ( s_ASCII_DOUT          ) // (o) [   8]
    );

endmodule
