// =================================================================================================
// File Name      : pcie_UP_if.v
// Module         : PCIE_UP_IF
// Function       :
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

module PCIE_UP_IF (
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
    input                               USER_CLK                                ,//(i)  [  1]
    input                               USER_RST                                ,//(i)  [  1]

    input                               UP_FILE_SOF                             ,//(i)  [  1]
    input                               UP_FILE_EOF                             ,//(i)  [  1]
    input       [  15:0]                UP_FILE_VCH                             ,//(i)  [ 16]
    input       [  31:0]                UP_FILE_ADDR                            ,//(i)  [ 32]
    input       [  31:0]                UP_FILE_SIZE                            ,//(i)  [ 32]

    output                              DMA_RD_START                            ,//(o)  [  1]
    output      [  15:0]                DMA_RD_VCH                              ,//(o)  [ 16]
    output      [  31:0]                DMA_RD_ADDR                             ,//(o)  [ 32]
    output      [  31:0]                DMA_RD_SIZE                             ,//(o)  [ 32]

    output                              DMA_UP_RDY                              ,//(i)  [  1]
    input       [  63:0]                DMA_UP_DATA                             ,//(i)  [ 64]
    input                               DMA_UP_DVLD                             ,//(i)  [  1]
    input                               DMA_UP_SOF                              ,//(i)  [  1]
    input                               DMA_UP_EOF                              ,//(i)  [  1]
    input       [  15:0]                DMA_UP_VCH                              ,//(i)  [ 16]
    input       [  31:0]                DMA_UP_ADDR                             ,//(i)  [ 32]
    input       [  31:0]                DMA_UP_SIZE                             ,//(i)  [ 32]

    input                               UP_LBUF_WR_RDY                          ,//(i)  [ 16]
    output      [  63:0]                UP_LBUF_WR_DATA                         ,//(o)  [ 64]
    output                              UP_LBUF_WR_DVLD                         ,//(o)  [  1]
    output                              UP_LBUF_WR_SOF                          ,//(o)  [  1]
    output                              UP_LBUF_WR_EOF                          ,//(o)  [  1]
    output      [  15:0]                UP_LBUF_WR_VCH                          ,//(o)  [ 16]
    output      [  31:0]                UP_LBUF_WR_ADDR                         ,//(o)  [ 32]
    output      [  31:0]                UP_LBUF_WR_FSZ                          ,//(o)  [ 32]
    output                              UP_LBUF_WR_SOB                          ,//(o)  [  1]
    output                              UP_LBUF_WR_EOB                          ,//(o)  [  1]
    output      [  15:0]                UP_LBUF_WR_BSZ                           //(o)  [ 16]
    );

// =============================================================================
// Internal Signal Declare
// =============================================================================

    reg                                 r_CBUF_WEN                              ;//(r)  [  1]
    reg         [  89:0]                r_CBUF_WDT                              ;//(r)  [ 90]
    wire                                s_CBUF_RST                              ;//(s)  [  1]
    reg                                 r_CBUF_REN                              ;//(r)  [  1]
    wire        [  89:0]                s_CBUF_RDT                              ;//(s)  [ 90]
    wire                                s_CBUF_EMPTY                            ;//(s)  [  1]
    reg                                 r_CBUF_RDY                              ;//(r)  [  1]
    reg         [   7:0]                r_CBUF_RSHFT                            ;//(r)  [  8]

    reg                                 r_DMA_RD_START                          ;//(r)  [  1]
    reg         [  15:0]                r_DMA_RD_VCH                            ;//(r)  [ 16]
    reg         [  31:0]                r_DMA_RD_ADDR                           ;//(r)  [ 32]
    reg         [  31:0]                r_DMA_RD_SIZE                           ;//(r)  [ 32]

    reg                                 r_DMA_UP_RDY                            ;//(r)  [  1]

    reg         [  63:0]                r_DMA_UP_DATA                           ;//(r)  [ 64]
    reg                                 r_DMA_UP_DVLD                           ;//(r)  [  1]
    reg                                 r_DMA_UP_SOF                            ;//(r)  [  1]
    reg                                 r_DMA_UP_EOF                            ;//(r)  [  1]
    reg         [  15:0]                r_DMA_UP_VCH                            ;//(r)  [ 16]
    reg         [  31:0]                r_DMA_UP_ADDR                           ;//(r)  [ 32]
    reg         [  31:0]                r_DMA_UP_SIZE                           ;//(r)  [ 32]
    reg         [  11:0]                r_DMA_UP_DCNT                           ;//(r)  [ 12]
    wire                                s_DMA_UP_4K_SOP                         ;//(s)  [  1]
    wire                                s_DMA_UP_4K_EOP                         ;//(s)  [  1]
    reg                                 r_DMA_UP_4K_SOP                         ;//(r)  [  1]
    reg                                 r_DMA_UP_4K_EOP                         ;//(r)  [  1]

    reg         [  63:0]                r_UP_LBUF_WR_DATA                       ;//(r)  [ 64]
    reg                                 r_UP_LBUF_WR_DVLD                       ;//(r)  [  1]
    reg                                 r_UP_LBUF_WR_SOF                        ;//(r)  [  1]
    reg                                 r_UP_LBUF_WR_EOF                        ;//(r)  [  1]
    reg         [  15:0]                r_UP_LBUF_WR_VCH                        ;//(r)  [ 16]
    reg         [  31:0]                r_UP_LBUF_WR_ADDR                       ;//(r)  [ 32]
    reg         [  31:0]                r_UP_LBUF_WR_FSZ                        ;//(r)  [ 32]
    reg                                 r_UP_LBUF_WR_SOB                        ;//(r)  [  1]
    reg                                 r_UP_LBUF_WR_EOB                        ;//(r)  [  1]
    reg         [  15:0]                r_UP_LBUF_WR_BSZ                        ;//(r)  [ 16]

// =================================================================================================
// RTL Body
// =================================================================================================

/*=============================================================================+/
||                                                                             ||
||                              Output Ports                                   ||
||                                                                             ||
/+=============================================================================*/

    assign  DMA_RD_START                = r_DMA_RD_START                        ;
    assign  DMA_RD_VCH                  = r_DMA_RD_VCH                          ;
    assign  DMA_RD_ADDR                 = r_DMA_RD_ADDR                         ;
    assign  DMA_RD_SIZE                 = r_DMA_RD_SIZE                         ;

    assign  DMA_UP_RDY                  = r_DMA_UP_RDY                          ;

    assign  UP_LBUF_WR_DATA             = r_UP_LBUF_WR_DATA                     ;
    assign  UP_LBUF_WR_DVLD             = r_UP_LBUF_WR_DVLD                     ;
    assign  UP_LBUF_WR_SOF              = r_UP_LBUF_WR_SOF                      ;
    assign  UP_LBUF_WR_EOF              = r_UP_LBUF_WR_EOF                      ;
    assign  UP_LBUF_WR_SOB              = r_UP_LBUF_WR_SOB                      ;
    assign  UP_LBUF_WR_EOB              = r_UP_LBUF_WR_EOB                      ;
    assign  UP_LBUF_WR_VCH              = r_UP_LBUF_WR_VCH                      ;
    assign  UP_LBUF_WR_ADDR             = r_UP_LBUF_WR_ADDR                     ;
    assign  UP_LBUF_WR_FSZ              = r_UP_LBUF_WR_FSZ                      ;
    assign  UP_LBUF_WR_BSZ              = r_UP_LBUF_WR_BSZ                      ;

/*=============================================================================+/
||                                                                             ||
||                               Control Buffer                                ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_CBUF_WEN                  <= 'b0 ;
            r_CBUF_WDT                  <= 'b0 ;
        end else begin
            r_CBUF_WEN                  <= UP_FILE_SOF  ;
            r_CBUF_WDT[89:80]           <= 10'd0        ;
            r_CBUF_WDT[79:64]           <= UP_FILE_VCH  ;
            r_CBUF_WDT[63:32]           <= UP_FILE_ADDR ;
            r_CBUF_WDT[31:0]            <= UP_FILE_SIZE ;
        end
    end

    assign  s_CBUF_RST                  = USER_RST | PCIE_RST ;

    afifo_i90o90_d512 U_CBUF (
        .wr_clk                         ( PCIE_CLK          ),
        .rd_clk                         ( USER_CLK          ),
        .rst                            ( s_CBUF_RST        ),
        .wr_en                          ( r_CBUF_WEN        ),
        .din                            ( r_CBUF_WDT        ),
        .rd_en                          ( r_CBUF_REN        ),
        .dout                           ( s_CBUF_RDT        ),
        .full                           (                   ),
        .almost_full                    (                   ),
        .empty                          ( s_CBUF_EMPTY      ),
        .almost_empty                   (                   ),
        .rd_data_count                  (                   ),
        .wr_data_count                  (                   )
        );

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_CBUF_RDY                  <= 1'b0 ;
        end else begin
            r_CBUF_RDY                  <= ~ s_CBUF_EMPTY ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_CBUF_RSHFT                <= 8'h80 ;
        end else begin
            r_CBUF_RSHFT                <= {r_CBUF_RSHFT[6:0] , r_CBUF_RSHFT[7]} ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_CBUF_REN                  <= 'b0 ;
        end else begin
            r_CBUF_REN                  <= r_CBUF_RDY & r_CBUF_RSHFT[0] ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DMA_RD_START              <= 'b0 ;
        end else begin
            r_DMA_RD_START              <= r_CBUF_REN ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DMA_RD_VCH                <= 'b0 ;
            r_DMA_RD_ADDR               <= 'b0 ;
            r_DMA_RD_SIZE               <= 'b0 ;
        end else begin
            if (r_CBUF_REN) begin
                r_DMA_RD_VCH            <= s_CBUF_RDT[79:64] ;
                r_DMA_RD_ADDR           <= s_CBUF_RDT[63:32] ;
                r_DMA_RD_SIZE           <= s_CBUF_RDT[31:0]  ;
            end
        end
    end

/*=============================================================================+/
||                                                                             ||
||                             Upload Interface                                ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DMA_UP_RDY                <= 1'b1 ;
        end else begin
            r_DMA_UP_RDY                <= UP_LBUF_WR_RDY ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DMA_UP_DATA               <= 'b0 ;
            r_DMA_UP_DVLD               <= 'b0 ;
            r_DMA_UP_SOF                <= 'b0 ;
            r_DMA_UP_EOF                <= 'b0 ;
            r_DMA_UP_VCH                <= 'b0 ;
            r_DMA_UP_ADDR               <= 'b0 ;
            r_DMA_UP_SIZE               <= 'b0 ;
        end else begin
            r_DMA_UP_DATA               <= DMA_UP_DATA ;
            r_DMA_UP_DVLD               <= DMA_UP_DVLD ;
            r_DMA_UP_SOF                <= DMA_UP_SOF  ;
            r_DMA_UP_EOF                <= DMA_UP_EOF  ;

            if (DMA_UP_SOF) begin
                r_DMA_UP_VCH            <= DMA_UP_VCH  ;
                r_DMA_UP_ADDR           <= DMA_UP_ADDR ;
            end

            if (DMA_UP_EOF) begin
                r_DMA_UP_SIZE           <= DMA_UP_SIZE ;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DMA_UP_DCNT               <= 12'd0 ;
        end else begin
            if (DMA_UP_SOF) begin
                r_DMA_UP_DCNT           <= 12'd8 ; // 64bit = 8byte
            end else if (DMA_UP_DVLD) begin
                r_DMA_UP_DCNT           <= r_DMA_UP_DCNT + 4'd8 ;
            end
        end
    end

    assign s_DMA_UP_4K_SOP              =  (DMA_UP_DVLD == 1'b1 && r_DMA_UP_DCNT == 12'h000) ? 1'b1 : 1'b0 ;
    assign s_DMA_UP_4K_EOP              =  (DMA_UP_DVLD == 1'b1 && r_DMA_UP_DCNT == 12'hFF8) ? 1'b1 : 1'b0 ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DMA_UP_4K_SOP             <= 'b0 ;
            r_DMA_UP_4K_EOP             <= 'b0 ;
        end else begin
            r_DMA_UP_4K_SOP             <= s_DMA_UP_4K_SOP ;
            r_DMA_UP_4K_EOP             <= s_DMA_UP_4K_EOP ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_UP_LBUF_WR_DATA           <= 'b0 ;
            r_UP_LBUF_WR_DVLD           <= 'b0 ;
            r_UP_LBUF_WR_SOF            <= 'b0 ;
            r_UP_LBUF_WR_EOF            <= 'b0 ;
            r_UP_LBUF_WR_VCH            <= 'b0 ;
            r_UP_LBUF_WR_ADDR           <= 'b0 ;
            r_UP_LBUF_WR_FSZ            <= 'b0 ;
        end else begin
            r_UP_LBUF_WR_DATA           <= r_DMA_UP_DATA ;
            r_UP_LBUF_WR_DVLD           <= r_DMA_UP_DVLD ;
            r_UP_LBUF_WR_SOF            <= r_DMA_UP_SOF  ;
            r_UP_LBUF_WR_EOF            <= r_DMA_UP_EOF  ;
            r_UP_LBUF_WR_VCH            <= r_DMA_UP_VCH  ;
            r_UP_LBUF_WR_ADDR           <= r_DMA_UP_ADDR ;
            r_UP_LBUF_WR_FSZ            <= r_DMA_UP_SIZE ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_UP_LBUF_WR_SOB            <= 'b0 ;
            r_UP_LBUF_WR_EOB            <= 'b0 ;
        end else begin
            r_UP_LBUF_WR_SOB            <= r_DMA_UP_SOF | r_DMA_UP_4K_SOP ;
            r_UP_LBUF_WR_EOB            <= r_DMA_UP_EOF | r_DMA_UP_4K_EOP ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_UP_LBUF_WR_BSZ            <= 'b0 ;
        end else begin
            if (r_DMA_UP_4K_EOP) begin
                r_UP_LBUF_WR_BSZ        <= 16'h1000 ;
            end else if (r_DMA_UP_EOF) begin
                r_UP_LBUF_WR_BSZ        <= {4'b0,r_DMA_UP_DCNT} ;
            end
        end
    end

endmodule
