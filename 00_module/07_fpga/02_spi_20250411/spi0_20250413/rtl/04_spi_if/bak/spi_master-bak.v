// =================================================================================================
// File Name      : spi_ctrl.v
// Module         : SPI_CTRL
// Function       : SPI interface timing control
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date          Coded by                Contents
// 0.1.0      2018/8/20     Benson                  Create new
//
// =================================================================================================
// End Revision
// =================================================================================================

//mode0 idle 0 pos sample neg change

`timescale 1 ps/1 ps

module SPI_MASTER (
    // Global signals
    input                               SYS_RST                                 ,//(i) [  1]
    input                               SYS_CLK                                 ,//(i) [  1]
    // User interface
    input                               SPI_WR_REQ                              ,//(i) [  1]
    input           [ 7:0]              SPI_WR_ADDR                             ,//(i) [  8]
    input           [15:0]              SPI_WR_DATA                             ,//(i) [ 16]
    output                              SPI_WR_ACK                              ,//(o) [  1]
    input                               SPI_RD_REQ                              ,//(i) [  1]
    input           [ 7:0]              SPI_RD_ADDR                             ,//(i) [  8]
    output                              SPI_RD_ACK                              ,//(o) [ 16]
    output          [15:0]              SPI_RD_DATA                             ,//(o) [  1]

    input                               SPI_OP_SEL                              ,//(i) [  1]
    output                              SPI_OP_BUSY                             ,//(o) [  1]
    output                              SPI_OP_ERR                              ,//(o) [  1]
    // SPI interface
    output                              SPI_GP0_XRST                            ,//(o) [  1]
    output                              SPI_GP0_CS                              ,//(o) [  1]
    output                              SPI_GP0_CLK                             ,//(o) [  1]
    output                              SPI_GP0_SDI                             ,//(o) [  1]
    input                               SPI_GP0_SDO                             ,//(i) [  1]
    input                               SPI_GP0_BUSY                             //(1) [  1]
) ;

// =============================================================================
// Internal Signal Declare
// =============================================================================

    parameter                           P_CLK_DIV   = 5'h10                     ;// Devider(2,4,8,16)

    reg             [ 15:0]             r_SPI_RST_CNT                           ;
    reg                                 r_SPI_GP0_RST                           ;
    reg                                 r_SPI_GP1_RST                           ;

    reg                                 r_SPI_OP_START                          ;
    reg             [  1:0]             r_SPI_OP_CHID                           ;
    reg             [  6:0]             r_SPI_OP_ADDR                           ;
    reg             [ 15:0]             r_SPI_WR_DATA                           ;
    reg                                 r_SPI_OP_BUSY                           ;
    reg                                 r_SPI_OP_SEL                            ;
    reg                                 r_SPI_OP_CMD                            ;
    reg                                 r_SPI_OP_EN                             ;
    reg                                 r_SPI_RD_RPT                            ;

    reg             [  3:0]             r_SPI_CLK_DIV                           ;
    reg                                 r_SPI_CLK                               ;
    reg                                 r_SPI_CLK_DFF                           ;
    wire                                s_SPI_CLK_RISE                          ;
    wire                                s_SPI_CLK_FALL                          ;
    reg                                 r_SPI_BIT_EN                            ;

    wire            [  7:0]             s_SPI_CS                                ;
    reg             [  4:0]             r_SPI_BIT_CNT                           ;
    wire                                s_SPI_BIT_EOP                           ;

    reg             [ 23:0]             r_SPI_SDI_SHFT                          ;
    reg             [ 15:0]             r_SPI_SDO_SHFT                          ;
    reg                                 r_SPI_SDO_IN                            ;
    reg                                 r_SPI_SDO_EN                            ;

    reg                                 r_SPI0_BUSY_IFF0                        ;
    reg                                 r_SPI0_BUSY_IFF1                        ;
    reg                                 r_SPI1_BUSY_IFF0                        ;
    reg                                 r_SPI1_BUSY_IFF1                        ;

    wire                                s_SPI0_BUSY_ACK                         ;
    wire                                s_SPI1_BUSY_ACK                         ;
    wire                                s_SPI_BUSY_ACK                          ;

    reg                                 r_SPI_WR_ACK                            ;
    reg                                 r_SPI_RD_ACK                            ;
    wire                                s_SPI_RD_ACK                            ;
    reg             [ 15:0]             r_SPI_RD_DATA                           ;

    reg                                 r_TIME_OUT_EN                           ;
    reg             [ 15:0]             r_TIME_OUT_CNT                          ;

    wire                                s_SPI_OP_ERR                            ;
    reg                                 r_SPI_OP_ERR                            ;

// =================================================================================================
// RTL Body
// =================================================================================================

    assign SPI_WR_ACK                   = r_SPI_WR_ACK                          ;
    assign SPI_RD_ACK                   = s_SPI_RD_ACK                          ;
    assign SPI_RD_DATA                  = r_SPI_RD_DATA                         ;
    assign SPI_OP_BUSY                  = r_SPI_OP_BUSY                         ;
    assign SPI_OP_ERR                   = r_SPI_OP_ERR                          ;

    assign SPI_GP0_XRST                 = r_SPI_GP0_RST                         ;
    assign SPI_GP0_CLK                  = r_SPI_CLK_DFF                         ;
    assign SPI_GP0_SDI                  = r_SPI_SDI_SHFT[23]                    ;
    assign SPI_GP0_CS                   = s_SPI_CS                              ;

/*==============================================================================+/
||                                                                              ||
||                          SPI Write/Read Request                              ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI_RST_CNT               <= 16'b0 ;
            r_SPI_GP0_RST               <=  1'b0 ;
        end else begin
            if (~r_SPI_RST_CNT[15]) begin
                r_SPI_RST_CNT           <= r_SPI_RST_CNT + 1'b1 ;
            end

            r_SPI_GP0_RST               <= r_SPI_RST_CNT[15] ;
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI_OP_START              <=  1'b0 ;
            r_SPI_OP_ADDR               <=  7'b0 ;
            r_SPI_WR_DATA               <= 16'b0 ;
            r_SPI_OP_BUSY               <=  1'b0 ;
            r_SPI_OP_SEL                <=  1'b0 ;
        end else begin
            r_SPI_OP_START              <= SPI_WR_REQ | SPI_RD_REQ | (~r_SPI_RD_RPT & r_SPI_RD_ACK) ;

            if (SPI_WR_REQ) begin
                r_SPI_OP_ADDR           <= SPI_WR_ADDR[6:0] ;
                r_SPI_WR_DATA           <= SPI_WR_DATA ;
            end else if (SPI_RD_REQ) begin
                r_SPI_OP_ADDR           <= SPI_RD_ADDR[6:0] ;
            end

            if (s_SPI_BUSY_ACK) begin
                r_SPI_OP_BUSY           <= 'b0 ;
            end else if (SPI_WR_REQ | SPI_RD_REQ) begin
                r_SPI_OP_BUSY           <= 'b1 ;
                r_SPI_OP_SEL            <= SPI_OP_SEL ;
            end
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI_OP_CMD                <= 'b0 ;
        end else begin
            if (SPI_WR_REQ) begin
                r_SPI_OP_CMD            <= 1'b1 ;
            end else if (SPI_RD_REQ) begin
                r_SPI_OP_CMD            <= 1'b0 ;
            end
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI_OP_EN                 <= 'b0 ;
        end else begin
            if (s_SPI_BIT_EOP) begin
                r_SPI_OP_EN             <= 'b0 ;
            end else if (r_SPI_OP_START) begin
                r_SPI_OP_EN             <= 'b1 ;
            end
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI_RD_RPT                <= 1'b0 ;
        end else begin
            if (SPI_RD_REQ) begin
                r_SPI_RD_RPT            <= 1'b0 ;
            end else if (r_SPI_RD_ACK) begin
                r_SPI_RD_RPT            <= r_SPI_RD_RPT + 1'b1 ;
            end
        end
    end

/*==============================================================================+/
||                                                                              ||
||                   SPI Clock                                                  ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI_CLK_DIV               <= 5'b0 ;
        end else begin
            r_SPI_CLK_DIV               <= r_SPI_CLK_DIV + 1'b1 ;
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI_CLK                   <= 'b0 ;
            r_SPI_CLK_DFF               <= 'b0 ;
        end else begin
            case (P_CLK_DIV)
                5'h02   : r_SPI_CLK     <= r_SPI_CLK_DIV[0] ;
                5'h04   : r_SPI_CLK     <= r_SPI_CLK_DIV[1] ;
                5'h08   : r_SPI_CLK     <= r_SPI_CLK_DIV[2] ;
                5'h10   : r_SPI_CLK     <= r_SPI_CLK_DIV[3] ;
                default : r_SPI_CLK     <= r_SPI_CLK_DIV[0] ;
            endcase

            r_SPI_CLK_DFF               <= r_SPI_CLK ;
        end
    end

    assign s_SPI_CLK_RISE               =  r_SPI_CLK & ~r_SPI_CLK_DFF ;
    assign s_SPI_CLK_FALL               = ~r_SPI_CLK &  r_SPI_CLK_DFF ;

/*==============================================================================+/
||                                                                              ||
||                   SPI Timing Control                                         ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI_BIT_EN                <= 'b0 ;
        end else begin
            if (s_SPI_BIT_EOP) begin
                r_SPI_BIT_EN            <= 'b0 ;
            end else if (s_SPI_CLK_FALL & r_SPI_OP_EN & r_SPI0_BUSY_IFF1) begin
                r_SPI_BIT_EN            <= 'b1 ;
            end
        end
    end

    assign s_SPI_CS                     = ~(r_SPI_BIT_EN & r_SPI_OP_SEL) ;

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI_BIT_CNT               <= 'b0 ;
        end else begin
            if (s_SPI_BIT_EOP) begin
                r_SPI_BIT_CNT           <= 'b0 ;
            end else if (r_SPI_BIT_EN & s_SPI_CLK_RISE) begin
                r_SPI_BIT_CNT           <= r_SPI_BIT_CNT + 1'b1 ;
            end
        end
    end

    assign s_SPI_BIT_EOP                = (r_SPI_BIT_CNT == 5'd24) & s_SPI_CLK_FALL ;

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI_SDI_SHFT              <= 'b0 ;
        end else begin
            if (r_SPI_OP_START) begin
                r_SPI_SDI_SHFT          <= {r_SPI_OP_ADDR,r_SPI_OP_CMD,r_SPI_WR_DATA} ;
            end else if (r_SPI_BIT_EN & s_SPI_CLK_FALL) begin
                r_SPI_SDI_SHFT          <= {r_SPI_SDI_SHFT[22:0],1'b1} ;
            end
        end
    end

/*==============================================================================+/
||                                                                              ||
||                   SPI Input Control                                          ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI_SDO_IN                <= 1'b1 ;
        end else begin
            if (r_SPI_OP_SEL) begin
                r_SPI_SDO_IN            <= SPI_GP0_SDO ;
            end
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI_SDO_EN                <= 'b0 ;
            r_SPI_SDO_SHFT              <= 'b0 ;
        end else begin
            if (s_SPI_BIT_EOP) begin
                r_SPI_SDO_EN            <= 'b0 ;
            end else if (r_SPI_BIT_EN & s_SPI_CLK_RISE & (r_SPI_BIT_CNT == 5'h08)) begin
                r_SPI_SDO_EN            <= 'b1 ;
            end

            if (r_SPI_SDO_EN & s_SPI_CLK_FALL) begin
                r_SPI_SDO_SHFT          <= {r_SPI_SDO_SHFT[14:0],r_SPI_SDO_IN} ;
            end
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI0_BUSY_IFF0            <= 'b0 ;
            r_SPI0_BUSY_IFF1            <= 'b0 ;

        end else begin
            r_SPI0_BUSY_IFF0            <= SPI_GP0_BUSY    ;
            r_SPI0_BUSY_IFF1            <= r_SPI0_BUSY_IFF0 ;

        end
    end

    assign s_SPI0_BUSY_ACK              = r_SPI0_BUSY_IFF0 & ~r_SPI0_BUSY_IFF1 ;
    assign s_SPI_BUSY_ACK               = s_SPI0_BUSY_ACK   ;

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI_WR_ACK                <= 'b0 ;
            r_SPI_RD_ACK                <= 'b0 ;
            r_SPI_RD_DATA               <= 'b0 ;
        end else begin
            r_SPI_WR_ACK                <= s_SPI_BUSY_ACK &  r_SPI_OP_CMD ;
            r_SPI_RD_ACK                <= s_SPI_BUSY_ACK & ~r_SPI_OP_CMD ;
            r_SPI_RD_DATA               <= r_SPI_SDO_SHFT ;
        end
    end

    assign s_SPI_RD_ACK                 = r_SPI_RD_ACK & r_SPI_RD_RPT ;

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_TIME_OUT_EN               <= 'b0 ;
            r_TIME_OUT_CNT              <= 'b0 ;
        end else begin
            if (s_SPI_BUSY_ACK | s_SPI_OP_ERR) begin
                r_TIME_OUT_EN           <= 'b0 ;
            end else if (s_SPI_BIT_EOP) begin
                r_TIME_OUT_EN           <= 'b1 ;
            end

            if (r_TIME_OUT_EN) begin
                r_TIME_OUT_CNT          <= r_TIME_OUT_CNT + 1'b1 ;
            end
        end
    end

    assign s_SPI_OP_ERR                 = &r_TIME_OUT_CNT & r_TIME_OUT_EN ;

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SPI_OP_ERR                <= 'b0 ;
        end else begin
            if (r_SPI_OP_START) begin
                r_SPI_OP_ERR            <= 'b0 ;
            end else if (s_SPI_OP_ERR) begin
                r_SPI_OP_ERR            <= 'b1 ;
            end
        end
    end

endmodule
