// =================================================================================================
// File Name      : bps_gen.v
// Module         : BPS_GEN
// Function       : BPS_GEN
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

module BPS_GEN #(
    parameter                           p_UART_BAUD         = 115200            ,// (p)
    parameter       real                p_CLK_FREQ          = 156.25e6           // (p) 156.25MHz
    )(
    input                               USER_CLK                                ,// (i) [   1]
    input                               USER_RST                                ,// (i) [   1]

    output                              BPS_RX_TRIG                             ,// (o) [   1]
    output                              BPS_TX_TRIG                              // (o) [   1]
);


// =============================================================================
// Internal Parameter Declare
// =============================================================================
    parameter   [  11:0]                p_UART_TX_CNT       = p_CLK_FREQ / p_UART_BAUD;
    parameter   [  11:0]                p_UART_RX_CNT       = p_UART_TX_CNT / 16;

// =============================================================================
// Internal signals declaration
// =============================================================================

    reg         [  11:0]                r_BPS_TX_CNT            ;
    reg         [   3:0]                r_X16_RX_CNT            ;
    reg         [   7:0]                r_RX_DIV16              ;
    reg                                 r_BPS_RX_TRIG           ;
    reg                                 r_BPS_TX_TRIG           ;

// =================================================================================================
// RTL Body
// =================================================================================================

/*==============================================================================+/
||                                                                              ||
||                                Output Ports                                  ||
||                                                                              ||
/+==============================================================================*/
    assign BPS_RX_TRIG                  = r_BPS_RX_TRIG         ;
    assign BPS_TX_TRIG                  = r_BPS_TX_TRIG         ;


/*==============================================================================+/
||                                                                              ||
||                               BPS Time Control                               ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_BPS_TX_CNT                <= 'd0          ;
        end else begin
            if(r_BPS_TX_CNT == p_UART_TX_CNT-1) begin
                r_BPS_TX_CNT            <= 'd0          ;
            end else begin
                r_BPS_TX_CNT            <= r_BPS_TX_CNT + 1'b1;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_BPS_TX_TRIG               <= 1'b0             ;
        end else begin
            if(r_BPS_TX_CNT == 'd1) begin
                r_BPS_TX_TRIG           <= 1'b1             ;
            end else begin
                r_BPS_TX_TRIG           <= 1'b0             ;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_RX_DIV16                  <= 'd0              ;
        end else begin
            if(r_RX_DIV16 == p_UART_RX_CNT-1) begin
                r_RX_DIV16              <= 'd0              ;
            end else begin
                r_RX_DIV16              <= r_RX_DIV16 + 1'b1;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_X16_RX_CNT                <= 'd0              ;
        end else begin
            if( r_BPS_TX_TRIG ) begin
                r_X16_RX_CNT            <= 'd0              ;
            end else if(&r_X16_RX_CNT) begin
                r_X16_RX_CNT            <= r_X16_RX_CNT     ;
            end else if(r_RX_DIV16 == 'd1) begin
                r_X16_RX_CNT            <= r_X16_RX_CNT + 1'b1;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_BPS_RX_TRIG               <= 1'b0             ;
        end else begin
            if(&r_X16_RX_CNT) begin
                r_BPS_RX_TRIG           <= r_BPS_TX_TRIG    ;
            end else if(r_RX_DIV16 == 'd1) begin
                r_BPS_RX_TRIG           <= 1'b1             ;
            end else begin
                r_BPS_RX_TRIG           <= 1'b0             ;
            end
        end
    end

endmodule
