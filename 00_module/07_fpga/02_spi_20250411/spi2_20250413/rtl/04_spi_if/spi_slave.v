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

module SPI_SLAVE (
    // Global signals
    input                               RST                                     ,//(i) [  1]
    input                               CLK                                     ,//(i) [  1]
    // REG interface
    output                              REG_WR_REQ                              ,//(o)  [   1]
    output                              REG_RD_REQ                              ,//(o)  [   1]
    input                               REG_RD_ACK                              ,//(i)  [   1]
    output      [  15:0]                REG_WR_DATA                             ,//(o)  [  32]
    input       [  15:0]                REG_RD_DATA                             ,//(i)  [  32]
    output      [   7:0]                REG_OP_ADDR                             ,//(o)  [  16]

    // SPI interface
    input                               SPI_GP_XRST                             ,//(i) [  1]
    input                               SPI_GP_CS                               ,//(i) [  1]
    input                               SPI_GP_CLK                              ,//(i) [  1]
    input                               SPI_GP_MOSI                             ,//(i) [  1]
    output                              SPI_GP_MISO                             ,//(o) [  1]
    output                              SPI_GP_BUSY                              //(o) [  1]
    );

// =============================================================================
// Prameter define
// =============================================================================

// =============================================================================
// Internal signal define
// =============================================================================

    wire                                s_SPI_RST                               ;//(s)[  1]
    reg                                 r_SPI_CLK_DFF                           ;//(r)[  1]
    wire                                s_SPI_CLK_RISE                          ;//(s)[  1]
    wire                                s_SPI_CLK_FALL                          ;//(s)[  1]
    reg         [   4:0]                r_SPI_BIT_CNT                           ;//(r)[  5]
    reg         [   7:0]                r_SPI_OP_ADDR                           ;//(r)[  8]
    reg                                 r_SPI_WR_FLAG                           ;//(r)[  1]
    reg                                 r_SPI_RD_FLAG                           ;//(r)[  1]
    reg                                 r_SPI_RD_EN                             ;//(r)[  1]
    reg         [  15:0]                r_SPI_WR_DATA                           ;//(r)[ 16]
    wire                                s_SPI_EOP                               ;//(s)[  1]
    reg                                 r_SPI_WR_EN                             ;//(r)[  1]
    reg         [  15:0]                r_REG_RD_DATA                           ;//(r)[ 16]

// =============================================================================
// output
// =============================================================================

    assign REG_WR_REQ                   = r_SPI_WR_EN                           ;
    assign REG_RD_REQ                   = r_SPI_RD_EN                           ;
    assign REG_WR_DATA                  = r_SPI_WR_DATA                         ;
    assign REG_OP_ADDR                  = r_SPI_OP_ADDR                         ;
    assign SPI_GP_MISO                   = r_REG_RD_DATA[15]                     ;
    assign SPI_GP_BUSY                  = |r_SPI_BIT_CNT                        ;

// =============================================================================
//                     rtl body
// =============================================================================

/*=============================================================================+/
||                                                                             ||
||                                    xxx                                      ||
||                                                                             ||
/+=============================================================================*/

    assign s_SPI_RST                    = RST & SPI_GP_XRST                     ;

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_CLK_DFF               <= 'b0 ;
        end else begin
            r_SPI_CLK_DFF               <= SPI_GP_CLK ;
        end
    end

    assign s_SPI_CLK_RISE               =  SPI_GP_CLK & ~r_SPI_CLK_DFF ;
    assign s_SPI_CLK_FALL               = ~SPI_GP_CLK &  r_SPI_CLK_DFF ;

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_BIT_CNT               <= 'b0 ;
        end else if(s_SPI_EOP)begin
            r_SPI_BIT_CNT               <= 'b0 ;
        end else if(s_SPI_CLK_FALL) begin
            r_SPI_BIT_CNT               <= r_SPI_BIT_CNT + 5'd1 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_OP_ADDR               <= 'b0 ;
        end else if(s_SPI_CLK_FALL & (r_SPI_BIT_CNT < 5'd8)) begin
            r_SPI_OP_ADDR               <= {r_SPI_OP_ADDR[6:0],SPI_GP_MOSI} ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_WR_FLAG               <= 1'b0 ;
            r_SPI_RD_FLAG               <= 1'b0 ;
        end else if(s_SPI_CLK_FALL & (r_SPI_BIT_CNT == 5'd9) & (~SPI_GP_MOSI)) begin
            r_SPI_WR_FLAG               <= 1'b1 ;
        end else if(s_SPI_CLK_FALL & (r_SPI_BIT_CNT == 5'd9) & (SPI_GP_MOSI))begin
            r_SPI_RD_FLAG               <= 1'b1 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_RD_EN                 <= 1'b0 ;
        end else if(s_SPI_CLK_FALL & (r_SPI_BIT_CNT == 5'd8) & (SPI_GP_MOSI))begin
            r_SPI_RD_EN                 <= 1'b1 ;
        end else begin
            r_SPI_RD_EN                 <= 1'b0 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_WR_DATA               <= 'b0 ;
        end else if(s_SPI_CLK_FALL & (r_SPI_BIT_CNT > 5'd9)) begin
            r_SPI_WR_DATA               <= {r_SPI_WR_DATA[14:0],SPI_GP_MOSI} ;
        end
    end

    assign s_SPI_EOP                    = ((r_SPI_BIT_CNT == 5'd25) & s_SPI_CLK_RISE)  ;

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_WR_EN                 <= 1'b0 ;
        end else if(s_SPI_EOP & r_SPI_WR_FLAG) begin
            r_SPI_WR_EN                 <= 1'b1 ;
        end else begin
            r_SPI_WR_EN                 <= 1'b0 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_REG_RD_DATA               <= 'b0 ;
        end else if(REG_RD_ACK) begin
            r_REG_RD_DATA               <= REG_RD_DATA ;
        end else if(s_SPI_CLK_RISE & (r_SPI_BIT_CNT > 5'd9))begin
            r_REG_RD_DATA               <= {r_REG_RD_DATA[14:0],1'b0} ;
        end
    end

endmodule