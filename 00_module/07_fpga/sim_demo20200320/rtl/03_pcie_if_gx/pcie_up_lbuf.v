// =================================================================================================
// File Name      : pcie_up_lbuf.v
// Module         : PCIE_UP_LBUF
// Function       : Upload local buffer module
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

module PCIE_UP_LBUF (
    //system signals
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
    input                               USER_CLK                                ,//(i)  [  1]
    input                               USER_RST                                ,//(i)  [  1]

    output                              UP_LBUF_WR_RDY                          ,//(i)  [ 16]
    input       [  63:0]                UP_LBUF_WR_DATA                         ,//(o)  [ 64]
    input                               UP_LBUF_WR_DVLD                         ,//(o)  [  1]
    input                               UP_LBUF_WR_SOF                          ,//(o)  [  1]
    input                               UP_LBUF_WR_EOF                          ,//(o)  [  1]
    input       [  15:0]                UP_LBUF_WR_VCH                          ,//(o)  [ 16]
    input       [  31:0]                UP_LBUF_WR_ADDR                         ,//(o)  [ 32]
    input       [  31:0]                UP_LBUF_WR_FSZ                          ,//(o)  [ 32]
    input                               UP_LBUF_WR_SOB                          ,//(o)  [  1]
    input                               UP_LBUF_WR_EOB                          ,//(o)  [  1]
    input       [  15:0]                UP_LBUF_WR_BSZ                          ,//(o)  [ 16]

    output                              UP_LBUF_RD_REQ                          ,//(o)  [  1] Local buffer read request
    input                               UP_LBUF_RD_ACK                          ,//(i)  [  1] Local buffer read acknowledge
    output      [   7:0]                UP_LBUF_RD_PSZ                          ,//(o)  [  8] Local buffer read package size
    output      [  15:0]                UP_LBUF_RD_BSZ                          ,//(o)  [ 16] Local buffer read burst size
    output      [  31:0]                UP_LBUF_RD_FSZ                          ,//(o)  [ 32] Local buffer read file size
    output      [  15:0]                UP_LBUF_RD_VCH                          ,//(o)  [ 16] Local buffer read channel
    output      [  63:0]                UP_LBUF_RD_DATA                         ,//(o)  [ 64] Local buffer read data
    output                              UP_LBUF_RD_DVLD                         ,//(o)  [  1] Locak buffer read data valid
    output                              UP_LBUF_RD_SOP                          ,//(o)  [  1] Locak buffer read start of package
    output                              UP_LBUF_RD_EOP                          ,//(o)  [  1] Locak buffer read end of package
    output                              UP_LBUF_RD_SOB                          ,//(o)  [  1] Locak buffer read start of buffer
    output                              UP_LBUF_RD_EOB                          ,//(o)  [  1] Locak buffer read end of buffer
    output                              UP_LBUF_RD_SOF                          ,//(o)  [  1] Locak buffer read start of file
    output                              UP_LBUF_RD_EOF                           //(o)  [  1] Locak buffer read end of file
    );

// =============================================================================
// Parameter Declare
// =============================================================================

    localparam                          p_IDLE          = 5'b00001              ;//(p)  [  5]
    localparam                          p_CBUF_RD       = 5'b00010              ;//(p)  [  5]
    localparam                          p_TX_REQ        = 5'b00100              ;//(p)  [  5]
    localparam                          p_TX_CHK        = 5'b01000              ;//(p)  [  5]
    localparam                          p_TX_DATA       = 5'b10000              ;//(p)  [  5]

// =============================================================================
// Internal Signal Declare
// =============================================================================

    reg                                 r_CBUF_WEN                              ;//(r)  [  1]
    reg         [  71:0]                r_CBUF_WDT                              ;//(r)  [ 72]
    wire                                s_CBUF_RST                              ;//(s)  [  1]
    wire                                s_CBUF_EMPTY                            ;//(s)  [  1]
    reg                                 r_CBUF_RDY                              ;//(r)  [  1]
    reg                                 r_CBUF_REN                              ;//(r)  [  1]
    wire        [  71:0]                s_CBUF_RDT                              ;//(s)  [ 72]

    reg         [   4:0]                r_FSM                                   ;//(r)  [  5]
    wire                                s_ST_CBUF_RD                            ;//(s)  [  1]
    wire                                s_ST_TX_REQ                             ;//(s)  [  1]
    wire                                s_ST_TX_CHK                             ;//(s)  [  1]
    reg                                 r_ST_TX_CHK                             ;//(r)  [  1]

    reg                                 r_UP_LBUF_RD_REQ                        ;//(r)  [  1]
    reg         [  31:0]                r_DBUF_FSZ                              ;//(r)  [ 32]
    reg         [  15:0]                r_DBUF_VCH                              ;//(r)  [ 16]
    reg         [  15:0]                r_DBUF_BSZ                              ;//(r)  [ 16]
    reg         [  15:0]                r_DBUF_DCNT                             ;//(r)  [ 16]
    reg         [   7:0]                r_DBUF_PSZ                              ;//(r)  [  8]
    reg         [   4:0]                r_DBUF_RCNT                             ;//(r)  [  5]
    reg                                 r_TX_LAST                               ;//(r)  [  1]

    wire                                s_DBUF_REN                              ;//(s)  [  1]
    wire                                s_DBUF_SOP                              ;//(s)  [  1]
    wire                                s_DBUF_EOP                              ;//(s)  [  1]
    reg                                 r_DBUF_REN                              ;//(r)  [  1]
    reg                                 r_DBUF_SOP                              ;//(r)  [  1]
    reg                                 r_DBUF_EOP                              ;//(r)  [  1]

    wire                                s_DBUF_RST                              ;//(s)  [  1]
    reg                                 r_DBUF_WEN                              ;//(r)  [  1]
    reg         [  71:0]                r_DBUF_WDT                              ;//(r)  [ 72]
    wire        [  71:0]                s_DBUF_RDT                              ;//(s)  [ 72]
    wire        [  10:0]                s_DBUF_WCNT                             ;//(r)  [ 10]
    reg                                 r_DBUF_WRDY                             ;//(r)  [  1]

    reg         [  63:0]                r_DBUF_RD_DATA                          ;//(s)  [ 64]
    reg                                 r_DBUF_RD_DVLD                          ;//(r)  [  1]
    reg                                 r_DBUF_RD_SOP                           ;//(r)  [  1]
    reg                                 r_DBUF_RD_EOP                           ;//(r)  [  1]
    reg                                 r_DBUF_RD_SOB                           ;//(r)  [  1]
    reg                                 r_DBUF_RD_EOB                           ;//(r)  [  1]
    reg                                 r_DBUF_RD_SOF                           ;//(r)  [  1]
    reg                                 r_DBUF_RD_EOF                           ;//(r)  [  1]
    reg         [  31:0]                r_DBUF_RD_FSZ                           ;//(r)  [ 32]
    reg         [  15:0]                r_DBUF_RD_BSZ                           ;//(r)  [ 16]
    reg         [   7:0]                r_DBUF_RD_PSZ                           ;//(r)  [  8]
    reg         [  15:0]                r_DBUF_RD_VCH                           ;//(r)  [ 16]

// =================================================================================================
// RTL Body
// =================================================================================================

/*=============================================================================+/
||                                                                             ||
||                              Output Ports                                   ||
||                                                                             ||
/+=============================================================================*/

    assign  UP_LBUF_WR_RDY              = r_DBUF_WRDY                           ;
    assign  UP_LBUF_RD_REQ              = r_UP_LBUF_RD_REQ                      ;

    assign  UP_LBUF_RD_DATA             = r_DBUF_RD_DATA                        ;
    assign  UP_LBUF_RD_DVLD             = r_DBUF_RD_DVLD                        ;
    assign  UP_LBUF_RD_SOP              = r_DBUF_RD_SOP                         ;
    assign  UP_LBUF_RD_EOP              = r_DBUF_RD_EOP                         ;
    assign  UP_LBUF_RD_SOB              = r_DBUF_RD_SOB                         ;
    assign  UP_LBUF_RD_EOB              = r_DBUF_RD_EOB                         ;
    assign  UP_LBUF_RD_SOF              = r_DBUF_RD_SOF                         ;
    assign  UP_LBUF_RD_EOF              = r_DBUF_RD_EOF                         ;
    assign  UP_LBUF_RD_FSZ              = r_DBUF_RD_FSZ                         ;
    assign  UP_LBUF_RD_BSZ              = r_DBUF_RD_BSZ                         ;
    assign  UP_LBUF_RD_PSZ              = r_DBUF_RD_PSZ                         ;
    assign  UP_LBUF_RD_VCH              = r_DBUF_RD_VCH                         ;

/*=============================================================================+/
||                                                                             ||
||                   Upload Control buffer Control                             ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_CBUF_WDT                  <= 'b0 ;
            r_CBUF_WEN                  <= 'b0 ;
        end else begin
            r_CBUF_WDT[71:64]           <= 8'd0             ;
            r_CBUF_WDT[63:32]           <= UP_LBUF_WR_FSZ   ;
            r_CBUF_WDT[31:16]           <= UP_LBUF_WR_VCH   ;
            r_CBUF_WDT[15: 0]           <= UP_LBUF_WR_BSZ   ;
            r_CBUF_WEN                  <= UP_LBUF_WR_EOB   ;
        end
    end

    assign s_CBUF_RST                   = USER_RST | PCIE_RST ;

    afifo_i72o72_d2048 U_UP_CBUF (
        .wr_clk                         ( USER_CLK      ),
        .rd_clk                         ( PCIE_CLK      ),
        .rst                            ( s_CBUF_RST    ),
        .wr_en                          ( r_CBUF_WEN    ),
        .din                            ( r_CBUF_WDT    ),
        .rd_en                          ( r_CBUF_REN    ),
        .dout                           ( s_CBUF_RDT    ),
        .full                           (               ),
        .almost_full                    (               ),
        .empty                          ( s_CBUF_EMPTY  ),
        .almost_empty                   (               ),
        .rd_data_count                  (               ),
        .wr_data_count                  (               )
        );

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_CBUF_RDY                  <= 1'b0 ;
        end else begin
            r_CBUF_RDY                  <= ~ s_CBUF_EMPTY ;
        end
    end

/*============================================================================+/
||                                                                            ||
||                       Upload Data Read Control FSM                         ||
||                                                                            ||
/+============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_FSM                       <= p_IDLE ;
        end else begin
            case (r_FSM)
                p_IDLE :
                    begin
                        if (r_CBUF_RDY) begin
                            r_FSM       <= p_CBUF_RD ;
                        end else begin
                            r_FSM       <= p_IDLE ;
                        end
                    end
                p_CBUF_RD :
                    begin
                        r_FSM           <= p_TX_REQ ;
                    end
                p_TX_REQ :
                    begin
                        if (UP_LBUF_RD_ACK) begin
                            r_FSM       <= p_TX_CHK ;
                        end else begin
                            r_FSM       <= p_TX_REQ ;
                        end
                    end
                p_TX_CHK :
                    begin
                        r_FSM           <= p_TX_DATA ;
                    end
                p_TX_DATA :
                    begin
                        if (r_DBUF_EOP) begin
                            if (r_TX_LAST) begin
                                r_FSM   <= p_IDLE ;
                            end else begin
                                r_FSM   <= p_TX_CHK ;
                            end
                        end else begin
                            r_FSM       <= p_TX_DATA ;
                        end
                    end
                default :
                    begin
                        r_FSM           <= p_IDLE ;
                    end
            endcase
        end
    end

    assign  s_ST_CBUF_RD                = r_FSM[1] ;
    assign  s_ST_TX_REQ                 = r_FSM[2] ;
    assign  s_ST_TX_CHK                 = r_FSM[3] ;

/*============================================================================+/
||                                                                            ||
||                            Buffer Read Control                             ||
||                                                                            ||
/+============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_LBUF_RD_REQ            <= 1'b0 ;
        end else begin
            r_UP_LBUF_RD_REQ            <= s_ST_TX_REQ ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_CBUF_REN                  <= 1'b0 ;
        end else begin
            r_CBUF_REN                  <= s_ST_CBUF_RD ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_ST_TX_CHK                 <= 1'b0 ;
        end else begin
            r_ST_TX_CHK                 <= s_ST_TX_CHK ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DBUF_FSZ                  <= 'b0 ;
            r_DBUF_VCH                  <= 'b0 ;
            r_DBUF_BSZ                  <= 'b0 ;
        end else begin
            if (r_CBUF_REN) begin
                r_DBUF_FSZ              <= s_CBUF_RDT[63:32] ;
                r_DBUF_VCH              <= s_CBUF_RDT[31:16] ;
                r_DBUF_BSZ              <= s_CBUF_RDT[15: 0] ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DBUF_DCNT                 <= 16'd0 ;
        end else begin
            if (r_CBUF_REN) begin
                r_DBUF_DCNT             <= s_CBUF_RDT[15:0] ;
            end else if (r_ST_TX_CHK) begin
                if (r_DBUF_DCNT >= 16'd128) begin
                    r_DBUF_DCNT         <= r_DBUF_DCNT - 8'd128 ;
                end else begin
                    r_DBUF_DCNT         <= 16'd0 ;
                end
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DBUF_PSZ                  <= 8'd0 ;
        end else begin
            if (r_ST_TX_CHK) begin
                if (r_DBUF_DCNT >= 16'd128) begin
                    r_DBUF_PSZ          <= 8'd128 ;
                end else begin
                    r_DBUF_PSZ          <= r_DBUF_DCNT[7:0] ;
                end
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DBUF_RCNT                 <= 5'd0 ;
        end else begin
            if (r_ST_TX_CHK) begin
                if (r_DBUF_DCNT >= 16'd128) begin
                    r_DBUF_RCNT         <= 5'd16 ; //8*16=128 Byte
                end else begin
                    r_DBUF_RCNT         <= r_DBUF_DCNT[7:3] ;
                end
            end else if (r_DBUF_RCNT != 5'd0) begin
                r_DBUF_RCNT             <= r_DBUF_RCNT - 1'b1 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_TX_LAST                   <= 1'b0 ;
        end else begin
            if (r_ST_TX_CHK == 1'b1 && r_DBUF_DCNT <= 16'd128) begin
                r_TX_LAST               <= 1'b1 ;
            end else if (r_DBUF_EOP) begin
                r_TX_LAST               <= 1'b0 ;
            end
        end
    end

    assign s_DBUF_REN                   = (r_DBUF_RCNT != 5'd0              ) ? 1'b1 : 1'b0 ;
    assign s_DBUF_SOP                   = (r_DBUF_RCNT == r_DBUF_PSZ[7:3]   ) ? 1'b1 : 1'b0 ;
    assign s_DBUF_EOP                   = (r_DBUF_RCNT == 5'd1              ) ? 1'b1 : 1'b0 ;

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DBUF_REN                  <= 1'b0 ;
            r_DBUF_SOP                  <= 1'b0 ;
            r_DBUF_EOP                  <= 1'b0 ;
        end else begin
            r_DBUF_REN                  <= s_DBUF_REN               ;
            r_DBUF_SOP                  <= s_DBUF_REN & s_DBUF_SOP  ;
            r_DBUF_EOP                  <= s_DBUF_REN & s_DBUF_EOP  ;
        end
    end

/*=============================================================================+/
||                                                                             ||
||                Upload local data buffer Control                             ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DBUF_WDT                  <= 'b0 ;
            r_DBUF_WEN                  <= 'b0 ;
        end else begin
            r_DBUF_WDT[71:68]           <= 4'd0            ;
            r_DBUF_WDT[67]              <= UP_LBUF_WR_SOF  ;
            r_DBUF_WDT[66]              <= UP_LBUF_WR_EOF  ;
            r_DBUF_WDT[65]              <= UP_LBUF_WR_SOB  ;
            r_DBUF_WDT[64]              <= UP_LBUF_WR_EOB  ;
            r_DBUF_WDT[63:0]            <= UP_LBUF_WR_DATA ;
            r_DBUF_WEN                  <= UP_LBUF_WR_DVLD ;
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_DBUF_WRDY                 <= 1'b0 ;
        end else begin
            r_DBUF_WRDY                 <= ~ s_DBUF_WCNT[10] ;
        end
    end

    assign s_DBUF_RST                   = USER_RST | PCIE_RST ;

    afifo_i72o72_d2048 U_UP_DBUF (
        .wr_clk                         ( USER_CLK      ),
        .rd_clk                         ( PCIE_CLK      ),
        .rst                            ( s_DBUF_RST    ),
        .wr_en                          ( r_DBUF_WEN    ),
        .din                            ( r_DBUF_WDT    ),
        .rd_en                          ( r_DBUF_REN    ),
        .dout                           ( s_DBUF_RDT    ),
        .full                           (               ),
        .almost_full                    (               ),
        .empty                          (               ),
        .almost_empty                   (               ),
        .rd_data_count                  (               ),
        .wr_data_count                  ( s_DBUF_WCNT   )
        );

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DBUF_RD_DATA              <= 'b0 ;
            r_DBUF_RD_DVLD              <= 'b0 ;
            r_DBUF_RD_SOP               <= 'b0 ;
            r_DBUF_RD_EOP               <= 'b0 ;
            r_DBUF_RD_SOB               <= 'b0 ;
            r_DBUF_RD_EOB               <= 'b0 ;
            r_DBUF_RD_SOF               <= 'b0 ;
            r_DBUF_RD_EOF               <= 'b0 ;
            r_DBUF_RD_PSZ               <= 'b0 ;
            r_DBUF_RD_BSZ               <= 'b0 ;
            r_DBUF_RD_FSZ               <= 'b0 ;
            r_DBUF_RD_VCH               <= 'b0 ;
        end else begin
            r_DBUF_RD_DATA              <= s_DBUF_RDT[63:0]             ;
            r_DBUF_RD_DVLD              <= r_DBUF_REN                   ;
            r_DBUF_RD_SOP               <= r_DBUF_SOP                   ;
            r_DBUF_RD_EOP               <= r_DBUF_EOP                   ;
            r_DBUF_RD_SOB               <= r_DBUF_REN & s_DBUF_RDT[65]  ;
            r_DBUF_RD_EOB               <= r_DBUF_REN & s_DBUF_RDT[64]  ;
            r_DBUF_RD_SOF               <= r_DBUF_REN & s_DBUF_RDT[67]  ;
            r_DBUF_RD_EOF               <= r_DBUF_REN & s_DBUF_RDT[66]  ;
            r_DBUF_RD_PSZ               <= r_DBUF_PSZ                   ;

            r_DBUF_RD_VCH               <= r_DBUF_VCH                   ;
            r_DBUF_RD_BSZ               <= r_DBUF_BSZ                   ;
            r_DBUF_RD_FSZ               <= r_DBUF_FSZ                   ;
        end
    end

endmodule
