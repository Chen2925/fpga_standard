// =================================================================================================
// File Name      : pcie_up_ebuf.v
// Module         : PCIE_UP_EBUF
// Function       : Upload empty buffer control module
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level    Date         Coded by          Contents            Comp
// 0.0.1        2018/07/24   chen.y            create new          speed-clouds
// =================================================================================================
// End Revision
// =================================================================================================

`timescale 1ps / 1ps

module PCIE_UP_EBUF (
    //system
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
    //register
    output                              UP_EBUF_WR_RDY                          ,//(o)  [  1]
    input                               UP_EBUF_WR_REQ                          ,//(i)  [  1]
    input       [  95:0]                UP_EBUF_WR_DATA                         ,//(i)  [ 96]
    output      [   8:0]                UP_EBUF_WR_DCNT                         ,//(o)  [  9]
    //upload dma
    output                              UP_EBUF_RD_RDY                          ,//(o)  [  1]
    input                               UP_EBUF_RD_REQ                          ,//(i)  [  1]
    output      [  95:0]                UP_EBUF_RD_DATA                          //(o)  [ 96]
    );

// =============================================================================
// Internal signal define
// =============================================================================

    reg                                 r_UP_EBUF_WEN                           ;//(r)  [  1]
    reg         [  95:0]                r_UP_EBUF_WDT                           ;//(r)  [ 96]
    reg                                 r_UP_EBUF_REN                           ;//(r)  [  1]
    wire        [ 107:0]                s_UP_EBUF_WDT                           ;//(r)  [108]
    wire        [ 107:0]                s_UP_EBUF_RDT                           ;//(r)  [108]
    reg                                 r_UP_EBUF_WR_RDY                        ;//(r)  [  1]
    reg                                 r_UP_EBUF_RD_RDY                        ;//(r)  [  1]
    reg         [  95:0]                r_UP_EBUF_RD_DATA                       ;//(r)  [ 96]
    wire                                s_UP_EBUF_AFULL                         ;//(s)  [  1]
    wire                                s_UP_EBUF_EMPTY                         ;//(s)  [  1]
    wire        [   9:0]                s_UP_EBUF_DCNT                          ;//(s)  [  9]
    reg         [   8:0]                r_UP_EBUF_DCNT                          ;//(r)  [  9]

// ================================================================================================
// RTL Body
// ================================================================================================

/*=============================================================================+/
||                                                                             ||
||                             Output Port                                     ||
||                                                                             ||
/+=============================================================================*/

    assign  UP_EBUF_WR_RDY              = r_UP_EBUF_WR_RDY                      ;
    assign  UP_EBUF_WR_DCNT             = r_UP_EBUF_DCNT                        ;
    assign  UP_EBUF_RD_RDY              = r_UP_EBUF_RD_RDY                      ;
    assign  UP_EBUF_RD_DATA             = r_UP_EBUF_RD_DATA                     ;

/*=============================================================================+/
||                                                                             ||
||                     Empty Buffer Queue Control                              ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_EBUF_WEN               <= 'b0 ;
            r_UP_EBUF_WDT               <= 'b0 ;
        end else begin
            r_UP_EBUF_WEN               <= UP_EBUF_WR_REQ  ;
            r_UP_EBUF_WDT               <= UP_EBUF_WR_DATA ;
        end
    end

    assign  s_UP_EBUF_WDT               = {12'd0 , r_UP_EBUF_WDT} ;

    sfifo_i108o108_d512 U_UP_EBUF (
        .srst                           ( PCIE_RST          ),//(i)
        .clk                            ( PCIE_CLK          ),//(i)
        .wr_en                          ( r_UP_EBUF_WEN     ),//(i)
        .din                            ( s_UP_EBUF_WDT     ),//(i)
        .rd_en                          ( r_UP_EBUF_REN     ),//(o)
        .dout                           ( s_UP_EBUF_RDT     ),//(o)
        .almost_empty                   (                   ),//(o)
        .almost_full                    ( s_UP_EBUF_AFULL   ),//(o)
        .empty                          ( s_UP_EBUF_EMPTY   ),//(o)
        .full                           (                   ),//(o)
        .data_count                     ( s_UP_EBUF_DCNT    ) //(o)
        ) ;

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_EBUF_REN               <= 'b0 ;
        end else begin
            r_UP_EBUF_REN               <= UP_EBUF_RD_REQ ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_EBUF_RD_DATA           <= 'b0 ;
        end else begin
            r_UP_EBUF_RD_DATA           <= s_UP_EBUF_RDT[95:0] ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_EBUF_DCNT              <= 'b0 ;
        end else begin
            r_UP_EBUF_DCNT              <= s_UP_EBUF_DCNT[8:0] ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_EBUF_RD_RDY            <= 1'b0 ;
        end else begin
            r_UP_EBUF_RD_RDY            <= ~ s_UP_EBUF_EMPTY ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_EBUF_WR_RDY            <= 1'b1 ;
        end else begin
            r_UP_EBUF_WR_RDY            <= ~ r_UP_EBUF_DCNT[8] ;
        end
    end

endmodule
