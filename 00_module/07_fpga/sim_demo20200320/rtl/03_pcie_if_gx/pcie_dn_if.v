// =================================================================================================
// File Name      : pcie_dn_if.v
// Module         : PCIE_DN_IF
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

module PCIE_DN_IF (
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
    input                               USER_CLK                                ,//(i)  [  1]
    input                               USER_RST                                ,//(i)  [  1]

    input                               DN_FILE_SOF                             ,//(i)  [  1]
    input                               DN_FILE_EOF                             ,//(i)  [  1]
    input       [  15:0]                DN_FILE_VCH                             ,//(i)  [ 16]
    input       [  31:0]                DN_FILE_ADDR                            ,//(i)  [ 32]
    input       [  31:0]                DN_FILE_SIZE                            ,//(i)  [ 32]

    input                               DN_LBUF_RD_RDY                          ,//(i)  [  1]
    output                              DN_LBUF_RD_REQ                          ,//(o)  [  1]
    input       [  63:0]                DN_LBUF_RD_DATA                         ,//(i)  [ 64]
    input                               DN_LBUF_RD_DVLD                         ,//(i)  [  1]
    input                               DN_LBUF_RD_SOP                          ,//(i)  [  1]
    input                               DN_LBUF_RD_EOP                          ,//(i)  [  1]

    output                              DMA_DN_INT                              ,//(o)  [  1]
    input       [  15:0]                DMA_DN_RDY                              ,//(i)  [ 16]
    output      [  63:0]                DMA_DN_DATA                             ,//(o)  [ 64]
    output                              DMA_DN_DVLD                             ,//(o)  [  1]
    output                              DMA_DN_SOF                              ,//(o)  [  1]
    output                              DMA_DN_EOF                              ,//(o)  [  1]
    output      [  15:0]                DMA_DN_VCH                              ,//(o)  [ 16]
    output      [  31:0]                DMA_DN_ADDR                             ,//(o)  [ 32]
    output      [  31:0]                DMA_DN_SIZE                             ,//(o)  [ 32]

    output                              DMA_WR_START                            ,//(o)  [ 16]
    output      [  15:0]                DMA_WR_VCH                              ,//(o)  [ 16]
    output      [  31:0]                DMA_WR_ADDR                             ,//(o)  [ 32]
    output      [  31:0]                DMA_WR_SIZE                              //(o)  [ 32]
    );

// =============================================================================
// Parameter Declare
// =============================================================================

    localparam                          p_IDLE          = 6'b00_0001            ;//(p)  [  6]
    localparam                          p_CBUF_REQ      = 6'b00_0010            ;//(p)  [  6]
    localparam                          p_LBUF_CHK      = 6'b00_0100            ;//(p)  [  6]
    localparam                          p_LBUF_REQ      = 6'b00_1000            ;//(p)  [  6]
    localparam                          p_END_CHK       = 6'b01_0000            ;//(p)  [  6]
    localparam                          p_END           = 6'b10_0000            ;//(p)  [  6]

// =============================================================================
// Internal Signal Declare
// =============================================================================

    reg                                 r_CBUF_WEN                              ;//(r)  [  1]
    reg         [  89:0]                r_CBUF_WDT                              ;//(r)  [ 90]
    wire                                s_CBUF_RST                              ;//(s)  [  1]
    wire                                s_CBUF_REN                              ;//(s)  [  1]
    wire        [  89:0]                s_CBUF_RDT                              ;//(s)  [ 90]
    wire                                s_CBUF_EMPTY                            ;//(s)  [  1]
    reg                                 r_CBUF_RDY                              ;//(r)  [  1]
    reg                                 r_CBUF_DVLD                             ;//(r)  [  1]
    reg         [  89:0]                r_CBUF_DATA                             ;//(r)  [ 90]

    reg         [  15:0]                r_DN_FILE_VCH                           ;//(r)  [ 16]
    reg         [  31:0]                r_DN_FILE_ADDR                          ;//(r)  [ 32]
    reg         [  31:0]                r_DN_FILE_SIZE                          ;//(r)  [ 32]
    reg         [  24:0]                r_DN_TNUM                               ;//(r)  [ 25]
    reg         [  28:0]                r_DN_DNUM                               ;//(r)  [ 29]
    reg                                 r_DMA_DN_RDY                            ;//(r)  [  1]

    reg         [   5:0]                r_FSM                                   ;//(r)  [  6]
    wire                                s_ST_IDLE                               ;//(s)  [  1]
    wire                                s_ST_LBUF_CHK                           ;//(s)  [  1]

    wire                                s_DN_LBUF_RD_REQ                        ;//(s)  [  1]
    reg                                 r_DN_LBUF_RD_REQ                        ;//(r)  [  1]
    reg         [  63:0]                r_DN_LBUF_RD_DATA                       ;//(r)  [ 64]
    reg                                 r_DN_LBUF_RD_DVLD                       ;//(r)  [  1]
    reg         [  26:0]                r_DN_LBUF_RD_DCNT                       ;//(r)  [ 32]

    wire                                s_DMA_DN_SOF                            ;//(s)  [  1]
    wire                                s_DMA_DN_EOF                            ;//(s)  [  1]

    reg                                 r_DMA_DN_DEN                            ;//(r)  [  1]
    reg         [  63:0]                r_DMA_DN_DATA                           ;//(r)  [ 64]
    reg                                 r_DMA_DN_DVLD                           ;//(r)  [  1]
    reg                                 r_DMA_DN_SOF                            ;//(r)  [  1]
    reg                                 r_DMA_DN_EOF                            ;//(r)  [  1]
    reg         [  15:0]                r_DMA_DN_VCH                            ;//(r)  [ 16]
    reg         [  31:0]                r_DMA_DN_ADDR                           ;//(r)  [ 31]
    reg         [  31:0]                r_DMA_DN_SIZE                           ;//(r)  [ 31]
    reg                                 r_DMA_DN_INT                            ;//(r)  [  1]

// =================================================================================================
// RTL Body
// =================================================================================================

/*=============================================================================+/
||                                                                             ||
||                              Output Ports                                   ||
||                                                                             ||
/+=============================================================================*/

//  assign  DN_LBUF_RD_REQ              = r_DN_LBUF_RD_REQ                      ;
    assign  DN_LBUF_RD_REQ              = s_DN_LBUF_RD_REQ                      ;

    assign  DMA_DN_DATA                 = r_DMA_DN_DATA                         ;
    assign  DMA_DN_DVLD                 = r_DMA_DN_DVLD                         ;
    assign  DMA_DN_SOF                  = r_DMA_DN_SOF                          ;
    assign  DMA_DN_EOF                  = r_DMA_DN_EOF                          ;
    assign  DMA_DN_VCH                  = r_DMA_DN_VCH                          ;
    assign  DMA_DN_ADDR                 = r_DMA_DN_ADDR                         ;
    assign  DMA_DN_SIZE                 = r_DMA_DN_SIZE                         ;

    assign  DMA_WR_START                = r_DMA_DN_SOF                          ;
    assign  DMA_WR_VCH                  = r_DMA_DN_VCH                          ;
    assign  DMA_WR_ADDR                 = r_DMA_DN_ADDR                         ;
    assign  DMA_WR_SIZE                 = r_DMA_DN_SIZE                         ;

    assign  DMA_DN_INT                  = r_DMA_DN_INT                          ;

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
            r_CBUF_WEN                  <= DN_FILE_SOF  ;
            r_CBUF_WDT[89:80]           <= 10'd0        ;
            r_CBUF_WDT[79:64]           <= DN_FILE_VCH  ;
            r_CBUF_WDT[63:32]           <= DN_FILE_ADDR ;
            r_CBUF_WDT[31:0]            <= DN_FILE_SIZE ;
        end
    end

    assign  s_CBUF_RST                  = USER_RST | PCIE_RST ;

    afifo_i90o90_d512 U_CBUF (
        .wr_clk                         ( PCIE_CLK          ),
        .rd_clk                         ( USER_CLK          ),
        .rst                            ( s_CBUF_RST        ),
        .wr_en                          ( r_CBUF_WEN        ),
        .din                            ( r_CBUF_WDT        ),
        .rd_en                          ( s_CBUF_REN        ),
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

    assign s_CBUF_REN                   = s_ST_IDLE & r_CBUF_RDY ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_CBUF_DVLD                 <= 'b0 ;
            r_CBUF_DATA                 <= 'b0 ;
        end else begin
            r_CBUF_DVLD                 <= s_CBUF_REN ;
            r_CBUF_DATA                 <= s_CBUF_RDT ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DN_FILE_VCH               <= 'b0 ;
            r_DN_FILE_ADDR              <= 'b0 ;
            r_DN_FILE_SIZE              <= 'b0 ;
        end else begin
            if (s_CBUF_REN) begin
                r_DN_FILE_VCH           <= s_CBUF_RDT[79:64] ;
                r_DN_FILE_ADDR          <= s_CBUF_RDT[63:32] ;
                r_DN_FILE_SIZE          <= s_CBUF_RDT[31:0]  ;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DN_TNUM                   <= 25'd0 ;
        end else begin
            if (r_CBUF_DVLD) begin
                r_DN_TNUM               <= r_CBUF_DATA[31:7] + (|r_CBUF_DATA[6:0]) ; // DMA minimum size 128 Byte
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DN_DNUM                   <= 29'd0 ;
        end else begin
            if (r_CBUF_DVLD) begin
                r_DN_DNUM               <= r_CBUF_DATA[31:3] ; // One Clock Data = 8byte
            end
        end
    end

/*===========================================================================+/
||                                                                           ||
||                             FSM                                           ||
||                                                                           ||
/+===========================================================================*/

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DMA_DN_RDY                <= 'b0 ;
        end else begin
            r_DMA_DN_RDY                <= r_DN_FILE_VCH[0]  & DMA_DN_RDY[0]  |
                                           r_DN_FILE_VCH[1]  & DMA_DN_RDY[1]  |
                                           r_DN_FILE_VCH[2]  & DMA_DN_RDY[2]  |
                                           r_DN_FILE_VCH[3]  & DMA_DN_RDY[3]  |
                                           r_DN_FILE_VCH[4]  & DMA_DN_RDY[4]  |
                                           r_DN_FILE_VCH[5]  & DMA_DN_RDY[5]  |
                                           r_DN_FILE_VCH[6]  & DMA_DN_RDY[6]  |
                                           r_DN_FILE_VCH[7]  & DMA_DN_RDY[7]  |
                                           r_DN_FILE_VCH[8]  & DMA_DN_RDY[8]  |
                                           r_DN_FILE_VCH[9]  & DMA_DN_RDY[9]  |
                                           r_DN_FILE_VCH[10] & DMA_DN_RDY[10] |
                                           r_DN_FILE_VCH[11] & DMA_DN_RDY[11] |
                                           r_DN_FILE_VCH[12] & DMA_DN_RDY[12] |
                                           r_DN_FILE_VCH[13] & DMA_DN_RDY[13] |
                                           r_DN_FILE_VCH[14] & DMA_DN_RDY[14] |
                                           r_DN_FILE_VCH[15] & DMA_DN_RDY[15] ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_FSM                       <= p_IDLE ;
        end else begin
            case (r_FSM)
                p_IDLE :
                    begin
                        if (r_CBUF_RDY) begin
                            r_FSM       <= p_CBUF_REQ ;
                        end else begin
                            r_FSM       <= p_IDLE ;
                        end
                    end
                p_CBUF_REQ :
                    begin
                        r_FSM           <= p_LBUF_CHK ;
                    end
                p_LBUF_CHK :
                    begin
                        if (DN_LBUF_RD_RDY & r_DMA_DN_RDY) begin
                            r_FSM       <= p_LBUF_REQ ;
                        end else begin
                            r_FSM       <= p_LBUF_CHK ;
                        end
                    end
                p_LBUF_REQ :
                    begin
                        if (DN_LBUF_RD_EOP) begin
                            r_FSM       <= p_END_CHK ;
                        end else begin
                            r_FSM       <= p_LBUF_REQ ;
                        end
                    end
                p_END_CHK :
                    begin
                        if (r_DN_LBUF_RD_DCNT == {r_DN_TNUM,4'd0}) begin
                            r_FSM       <= p_END ;
                        end else begin
                            r_FSM       <= p_LBUF_CHK ;
                        end
                    end
                p_END :
                    begin
                        r_FSM           <= p_IDLE ;
                    end
                default :
                    begin
                        r_FSM           <= p_IDLE ;
                    end
            endcase
        end
    end

    assign  s_ST_IDLE                   = r_FSM[0] ;
    assign  s_ST_LBUF_CHK               = r_FSM[2] ;

/*=============================================================================+/
||                                                                             ||
||                       Download Local Buffer IF                              ||
||                                                                             ||
/+=============================================================================*/

    assign  s_DN_LBUF_RD_REQ            = s_ST_LBUF_CHK & r_DMA_DN_RDY & DN_LBUF_RD_RDY ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DN_LBUF_RD_REQ            <= 1'b0 ;
        end else begin
            r_DN_LBUF_RD_REQ            <= s_DN_LBUF_RD_REQ ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DN_LBUF_RD_DATA           <= 'b0 ;
            r_DN_LBUF_RD_DVLD           <= 'b0 ;
        end else begin
            r_DN_LBUF_RD_DATA           <= DN_LBUF_RD_DATA ;
            r_DN_LBUF_RD_DVLD           <= DN_LBUF_RD_DVLD ;
         end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DN_LBUF_RD_DCNT           <= 'b0 ;
        end else begin
            if (r_CBUF_DVLD) begin
                r_DN_LBUF_RD_DCNT       <= 'b0 ;
            end else if (DN_LBUF_RD_DVLD) begin
                r_DN_LBUF_RD_DCNT       <= r_DN_LBUF_RD_DCNT + 1'b1 ;
            end
        end
    end

/*============================================================================+/
||                                                                            ||
||                                 Data Output                                ||
||                                                                            ||
/+============================================================================*/

    assign s_DMA_DN_SOF                 = (r_DN_LBUF_RD_DVLD == 1'b1 && r_DN_LBUF_RD_DCNT == 26'd1    ) ? 1'b1 : 1'b0 ;
    assign s_DMA_DN_EOF                 = (r_DN_LBUF_RD_DVLD == 1'b1 && r_DN_LBUF_RD_DCNT == r_DN_DNUM) ? 1'b1 : 1'b0 ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DMA_DN_DEN                <= 1'b0 ;
        end else begin
            if (r_CBUF_DVLD) begin
                r_DMA_DN_DEN            <= 1'b1 ;
            end else if (s_DMA_DN_EOF) begin
                r_DMA_DN_DEN            <= 1'b0 ;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DMA_DN_DATA               <= 'b0 ;
            r_DMA_DN_DVLD               <= 'b0 ;
            r_DMA_DN_SOF                <= 'b0 ;
            r_DMA_DN_EOF                <= 'b0 ;
            r_DMA_DN_VCH                <= 'b0 ;
            r_DMA_DN_ADDR               <= 'b0 ;
            r_DMA_DN_SIZE               <= 'b0 ;
        end else begin
            r_DMA_DN_DATA               <= r_DN_LBUF_RD_DATA                ;
            r_DMA_DN_DVLD               <= r_DN_LBUF_RD_DVLD & r_DMA_DN_DEN ;

            r_DMA_DN_SOF                <= s_DMA_DN_SOF                     ;
            r_DMA_DN_EOF                <= s_DMA_DN_EOF                     ;

            r_DMA_DN_VCH                <= r_DN_FILE_VCH                    ;
            r_DMA_DN_ADDR               <= r_DN_FILE_ADDR                   ;
            r_DMA_DN_SIZE               <= r_DN_FILE_SIZE                   ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DMA_DN_INT                <= 1'b0 ;
        end else begin
            if (r_DMA_DN_EOF) begin
                r_DMA_DN_INT            <= ~ r_DMA_DN_INT ;
            end
        end
    end

endmodule
