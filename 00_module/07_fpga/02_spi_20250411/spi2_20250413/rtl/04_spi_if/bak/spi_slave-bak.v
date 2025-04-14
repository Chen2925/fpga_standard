// =================================================================================================
// File Name      : spi_slave.v
// Module         : spi_slave
// Function       : spi_slave
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

`timescale 1 ps/1 ps

module SPI_SLAVE (
    // Global signals
    input                               RST                                     ,//(i) [  1]
    input                               CLK                                     ,//(i) [  1]
    // reg interface
    output                              SPI_WR_EN                               ,//(o)[  1] SPI write enable
    output      [  15:0]                SPI_WR_DATA                             ,//(o)[ 16] SPI write data
    output      [   7:0]                SPI_OP_ADDR                             ,//(o)[  8] SPI write address
    output                              SPI_RD_EN                               ,//(o)[  1] SPI read  enable
    input       [  15:0]                SPI_RD_DATA                             ,//(i)[ 16] SPI read  data
    input                               SPI_RD_ACK                              ,//(i)[  1] SPI read  data ACK
    // SPI interface
    input                               SPI_GP_XRST                             ,//(o) [  1]
    input                               SPI_GP_CS                               ,//(o) [  1]
    input                               SPI_GP_CLK                              ,//(o) [  1]
    input                               SPI_GP_MOSI                             ,//(o) [  1]
    output                              SPI_GP_MISO                             ,//(i) [  1]
    output                              SPI_GP_BUSY                              //(1) [  1]
    );

// =============================================================================
// Prameter define
// =============================================================================

    parameter                           P_CLK_DIV   = 5'h10                     ;// Devider(2,4,8,16)

// =============================================================================
// Internal signal define
// =============================================================================

    reg                                 r_SPI_CLK_DFF                           ;//(r)[  1]
    wire                                s_SPI_CLK_RISE                          ;//(s)[  1]
    wire                                s_SPI_CLK_FALL                          ;//(s)[  1]
    reg         [   7:0]                r_SPI_OP_ADDR                              ;//(r)[  8]
    reg         [  15:0]                r_SPI_WR_DATA                              ;//(r)[ 16]
    reg                                 r_SPI_RD_EN                             ;//(r)[  1]
    reg                                 r_SPI_WR_FLAG                           ;//(r)[  1]
    reg                                 r_SPI_WR_EN                             ;//(r)[  1]
    reg                                 r_SPI_RD_FLAG                           ;//(r)[  1]
    reg         [   4:0]                r_SPI_CNT                               ;//(r)[  5]
    reg         [  15:0]                r_SPI_RD_DATA                           ;//(r)[ 16]
    wire                                s_SPI_BIT_EOP                           ;//(s)[  1]

// =============================================================================
// output
// =============================================================================

    assign SPI_WR_EN                    = r_SPI_WR_EN                           ;
    assign SPI_WR_DATA                  = r_SPI_WR_DATA                         ;
    assign SPI_OP_ADDR                  = r_SPI_OP_ADDR                         ;
    assign SPI_RD_EN                    = r_SPI_RD_EN                           ;

    assign SPI_GP_MISO                  = r_SPI_RD_DATA[15]                     ;
    assign SPI_GP_BUSY                  = r_SPI_WR_EN | r_SPI_RD_EN             ;

// =============================================================================
//                     rtl body
// =============================================================================

/*=============================================================================+/
||                                                                             ||
||                                    xxx                                      ||
||                                                                             ||
/+=============================================================================*/

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
            r_SPI_OP_ADDR               <= 'b0 ;
        end else if(s_SPI_CLK_RISE & (r_SPI_CNT < 5'd8)) begin
            r_SPI_OP_ADDR               <= {r_SPI_OP_ADDR[6:0],SPI_GP_MOSI} ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_WR_DATA               <= 'b0 ;
        end else if(s_SPI_CLK_RISE & (r_SPI_CNT > 5'd8)) begin
            r_SPI_WR_DATA               <= {r_SPI_WR_DATA[14:0],SPI_GP_MOSI} ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_RD_EN                 <= 1'b0 ;
        end else if(s_SPI_CLK_RISE & (r_SPI_CNT == 5'd8) & (~SPI_GP_MOSI))begin
            r_SPI_RD_EN                 <= 1'b1 ;
        end else begin
            r_SPI_RD_EN                 <= 1'b0 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_WR_FLAG               <= 1'b0 ;
        end else if(s_SPI_BIT_EOP) begin
            r_SPI_WR_FLAG               <= 1'b0 ;
        end else if(s_SPI_CLK_RISE & (r_SPI_CNT == 5'd8) & (SPI_GP_MOSI)) begin
            r_SPI_WR_FLAG               <= 1'b1 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_WR_EN                 <= 1'b0 ;
        end else if(r_SPI_WR_FLAG & s_SPI_BIT_EOP) begin
            r_SPI_WR_EN                 <= 1'b1 ;
        end else begin
            r_SPI_WR_EN                 <= 1'b0 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_RD_FLAG               <= 1'b0 ;
        end else if(s_SPI_BIT_EOP) begin
            r_SPI_RD_FLAG               <= 1'b0 ;
        end else if(s_SPI_CLK_RISE & (r_SPI_CNT == 5'd8) & (~SPI_GP_MOSI)) begin
            r_SPI_RD_FLAG               <= 1'b1 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_CNT                   <= 'b0 ;
        end else if(s_SPI_BIT_EOP) begin
            r_SPI_CNT                   <= 'b0 ;
        end else if(s_SPI_CLK_RISE) begin
            r_SPI_CNT                  <= r_SPI_CNT + 1 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_SPI_RD_DATA               <= 'b0 ;
        end else if(SPI_RD_ACK) begin
            r_SPI_RD_DATA               <= SPI_RD_DATA ;
        end else if(s_SPI_CLK_FALL & (r_SPI_CNT < 5'd8)) begin
            r_SPI_RD_DATA               <= {r_SPI_RD_DATA[14:0],1'b0} ;
        end
    end

    assign s_SPI_BIT_EOP                = (r_SPI_CNT == 5'd24) & s_SPI_CLK_FALL ;


endmodule