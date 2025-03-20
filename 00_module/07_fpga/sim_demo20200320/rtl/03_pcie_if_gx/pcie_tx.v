// =================================================================================================
// File Name      : pcie_tx.v
// Module         : PCIE_TX
// Function       : PCIE transmit module
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

module PCIE_TX (
    //system signals
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
    input                               PCIE_TX_EN                              ,//(i)  [  1]
    //completion packet tx
    input                               CPK_TX_REQ                              ,//(i)  [  1]
    output                              CPK_TX_ACK                              ,//(o)  [  1]
    input                               CPK_TX_DVLD                             ,//(i)  [  1]
    input       [  63:0]                CPK_TX_DATA                             ,//(i)  [ 64]
    input       [   1:0]                CPK_TX_MASK                             ,//(i)  [  2]
    input                               CPK_TX_SOP                              ,//(i)  [  1]
    input                               CPK_TX_EOP                              ,//(i)  [  1]
    //channel packet tx
    input                               UEK_TX_REQ                              ,//(i)  [  1]
    output                              UEK_TX_ACK                              ,//(o)  [  1]
    input                               UEK_TX_DVLD                             ,//(i)  [  1]
    input       [  63:0]                UEK_TX_DATA                             ,//(i)  [ 64]
    input       [   1:0]                UEK_TX_MASK                             ,//(i)  [  2]
    input                               UEK_TX_SOP                              ,//(i)  [  1]
    input                               UEK_TX_EOP                              ,//(i)  [  1]
    //channel packet tx
    input                               UFK_TX_REQ                              ,//(i)  [  1]
    output                              UFK_TX_ACK                              ,//(o)  [  1]
    input                               UFK_TX_DVLD                             ,//(i)  [  1]
    input       [  63:0]                UFK_TX_DATA                             ,//(i)  [ 64]
    input       [   1:0]                UFK_TX_MASK                             ,//(i)  [  2]
    input                               UFK_TX_SOP                              ,//(i)  [  1]
    input                               UFK_TX_EOP                              ,//(i)  [  1]
    //channel packet tx
    input                               DEK_TX_REQ                              ,//(i)  [  1]
    output                              DEK_TX_ACK                              ,//(o)  [  1]
    input                               DEK_TX_DVLD                             ,//(i)  [  1]
    input       [  63:0]                DEK_TX_DATA                             ,//(i)  [ 64]
    input       [   1:0]                DEK_TX_MASK                             ,//(i)  [  2]
    input                               DEK_TX_SOP                              ,//(i)  [  1]
    input                               DEK_TX_EOP                              ,//(i)  [  1]
    //channel packet tx
    input                               DFK_TX_REQ                              ,//(i)  [  1]
    output                              DFK_TX_ACK                              ,//(o)  [  1]
    input                               DFK_TX_DVLD                             ,//(i)  [  1]
    input       [  63:0]                DFK_TX_DATA                             ,//(i)  [ 64]
    input       [   1:0]                DFK_TX_MASK                             ,//(i)  [  2]
    input                               DFK_TX_SOP                              ,//(i)  [  1]
    input                               DFK_TX_EOP                              ,//(i)  [  1]
    //channel packet tx
    input                               UPK_TX_REQ                              ,//(i)  [  1]
    output                              UPK_TX_ACK                              ,//(o)  [  1]
    input                               UPK_TX_DVLD                             ,//(i)  [  1]
    input       [  63:0]                UPK_TX_DATA                             ,//(i)  [ 64]
    input       [   1:0]                UPK_TX_MASK                             ,//(i)  [  2]
    input                               UPK_TX_SOP                              ,//(i)  [  1]
    input                               UPK_TX_EOP                              ,//(i)  [  1]
    input                               UPK_TX_END                              ,//(i)  [  1]
    //channel packet tx
    input                               DPK_TX_REQ                              ,//(i)  [  1]
    output                              DPK_TX_ACK                              ,//(o)  [  1]
    input                               DPK_TX_DVLD                             ,//(i)  [  1]
    input       [  63:0]                DPK_TX_DATA                             ,//(i)  [ 64]
    input       [   1:0]                DPK_TX_MASK                             ,//(i)  [  2]
    input                               DPK_TX_SOP                              ,//(i)  [  1]
    input                               DPK_TX_EOP                              ,//(i)  [  1]
    input                               DPK_TX_END                              ,//(i)  [  1]
    //pcie core
    output      [  63:0]                AXIS_TX_TDATA                           ,//(o)  [ 64]
    output      [   7:0]                AXIS_TX_TKEEP                           ,//(o)  [  8]
    output                              AXIS_TX_TVALID                          ,//(o)  [  1]
    output                              AXIS_TX_TLAST                           ,//(o)  [  1]
    input                               AXIS_TX_TREADY                          ,//(i)  [  1]
    output      [   3:0]                AXIS_TX_TUSER                            //(o)  [  4]
    );

// =============================================================================
// localparam Declare
// =============================================================================

    localparam                          P_IDLE        = 8'b00000001             ;//(p)  [  8]
    localparam                          P_CPK         = 8'b00000010             ;//(p)  [  8]
    localparam                          P_UEK         = 8'b00000100             ;//(p)  [  8]
    localparam                          P_UFK         = 8'b00001000             ;//(p)  [  8]
    localparam                          P_DEK         = 8'b00010000             ;//(p)  [  8]
    localparam                          P_DFK         = 8'b00100000             ;//(p)  [  8]
    localparam                          P_DPK         = 8'b01000000             ;//(p)  [  8]
    localparam                          P_UPK         = 8'b10000000             ;//(p)  [  8]

// =============================================================================
// Internal Signal Declare
// =============================================================================

    reg         [   7:0]                r_FSM                                   ;//(r)  [  5]
    wire                                s_FSM_IDLE                              ;//(s)  [  1]
    wire                                s_FSM_CPK                               ;//(s)  [  1]
    wire                                s_FSM_UEK                               ;//(s)  [  1]
    wire                                s_FSM_UFK                               ;//(s)  [  1]
    wire                                s_FSM_DEK                               ;//(s)  [  1]
    wire                                s_FSM_DFK                               ;//(s)  [  1]
    wire                                s_FSM_DPK                               ;//(s)  [  1]
    wire                                s_FSM_UPK                               ;//(s)  [  1]
    wire                                s_CPK_TX_ACK                            ;//(s)  [  1]
    wire                                s_UEK_TX_ACK                            ;//(s)  [  1]
    wire                                s_UFK_TX_ACK                            ;//(s)  [  1]
    wire                                s_DEK_TX_ACK                            ;//(s)  [  1]
    wire                                s_DFK_TX_ACK                            ;//(s)  [  1]
    wire                                s_DPK_TX_ACK                            ;//(s)  [  1]
    wire                                s_UPK_TX_ACK                            ;//(s)  [  1]

    reg                                 r_FSM_CPK                               ;//(r)  [  1]
    reg                                 r_FSM_UEK                               ;//(r)  [  1]
    reg                                 r_FSM_UFK                               ;//(r)  [  1]
    reg                                 r_FSM_DEK                               ;//(r)  [  1]
    reg                                 r_FSM_DFK                               ;//(r)  [  1]
    reg                                 r_FSM_DPK                               ;//(r)  [  1]
    reg                                 r_FSM_UPK                               ;//(r)  [  1]
    reg                                 r_CPK_TX_ACK                            ;//(r)  [  1]
    reg                                 r_UEK_TX_ACK                            ;//(r)  [  1]
    reg                                 r_UFK_TX_ACK                            ;//(r)  [  1]
    reg                                 r_DEK_TX_ACK                            ;//(r)  [  1]
    reg                                 r_DFK_TX_ACK                            ;//(r)  [  1]
    reg                                 r_DPK_TX_ACK                            ;//(r)  [  1]
    reg                                 r_UPK_TX_ACK                            ;//(r)  [  1]

    reg                                 r_BUF_WEN                               ;//(r)  [  1]
    reg         [  67:0]                r_BUF_WDT                               ;//(r)  [ 68]
    reg                                 r_BUF_WEN_DFF1                          ;//(r)  [  1]
    reg         [  67:0]                r_BUF_WDT_DFF1                          ;//(r)  [ 68]
    reg                                 r_BUF_WEN_DFF2                          ;//(r)  [  1]
    reg         [  67:0]                r_BUF_WDT_DFF2                          ;//(r)  [ 68]

    wire        [  71:0]                s_BUF_WDT                               ;//(s)  [ 72]
    wire                                s_BUF_WEN                               ;//(s)  [  1]
    wire        [  71:0]                s_BUF_RDT                               ;//(s)  [ 72]
    wire                                s_BUF_REN                               ;//(s)  [  1]
    wire                                s_BUF_AFULL                             ;//(s)  [  1]
    wire                                s_BUF_EMPTY                             ;//(s)  [  1]
    reg                                 r_BUF_AFULL                             ;//(r)  [  1]
    reg                                 r_BUF_REN                               ;//(r)  [  1]
    wire        [  11:0]                s_BUF_DCNT                              ;//(s)  [ 12]

    wire        [  63:0]                s_AXIS_TX_TDATA                         ;//(s)  [ 64]
    wire        [   7:0]                s_AXIS_TX_TKEEP                         ;//(s)  [  8]
    wire                                s_AXIS_TX_TVALID                        ;//(s)  [  1]
    wire                                s_AXIS_TX_TLAST                         ;//(s)  [  1]

    reg         [  63:0]                r_AXIS_TX_TDATA                         ;//(r)  [ 64]
    reg         [   7:0]                r_AXIS_TX_TKEEP                         ;//(r)  [  8]
    reg                                 r_AXIS_TX_TVALID                        ;//(r)  [  1]
    reg                                 r_AXIS_TX_TLAST                         ;//(r)  [  1]

// =================================================================================================
// RTL Body
// =================================================================================================

/*============================================================================+/
||                                                                            ||
||                           Output ports                                     ||
||                                                                            ||
/+============================================================================*/

    assign  CPK_TX_ACK                  = r_CPK_TX_ACK                          ;
    assign  UEK_TX_ACK                  = r_UEK_TX_ACK                          ;
    assign  UFK_TX_ACK                  = r_UFK_TX_ACK                          ;
    assign  DEK_TX_ACK                  = r_DEK_TX_ACK                          ;
    assign  DFK_TX_ACK                  = r_DFK_TX_ACK                          ;
    assign  UPK_TX_ACK                  = r_UPK_TX_ACK                          ;
    assign  DPK_TX_ACK                  = r_DPK_TX_ACK                          ;

    assign  AXIS_TX_TDATA               = s_AXIS_TX_TDATA                       ;
    assign  AXIS_TX_TKEEP               = s_AXIS_TX_TKEEP                       ;
    assign  AXIS_TX_TVALID              = s_AXIS_TX_TVALID                      ;
    assign  AXIS_TX_TLAST               = s_AXIS_TX_TLAST                       ;
    assign  AXIS_TX_TUSER               = 4'b0000                               ;

/*============================================================================+/
||                                                                            ||
||                             Arbiter FSM                                    ||
||                                                                            ||
/+============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_FSM   <= P_IDLE;
        end else begin
            case (r_FSM)
                P_IDLE  :
                    begin
                        if (r_BUF_AFULL == 1'b0 && PCIE_TX_EN == 1'b1) begin
                            if (CPK_TX_REQ) begin
                                r_FSM   <= P_CPK ;
                            end else if (UEK_TX_REQ) begin
                                r_FSM   <= P_UEK ;
                            end else if (UFK_TX_REQ) begin
                                r_FSM   <= P_UFK ;
                            end else if (DEK_TX_REQ) begin
                                r_FSM   <= P_DEK ;
                            end else if (DFK_TX_REQ) begin
                                r_FSM   <= P_DFK ;
                            end else if (DPK_TX_REQ) begin
                                r_FSM   <= P_DPK ;
                            end else if (UPK_TX_REQ) begin
                                r_FSM   <= P_UPK ;
                            end else begin
                                r_FSM   <= P_IDLE ;
                            end
                        end else begin
                            r_FSM       <= P_IDLE ;
                        end
                    end
                P_CPK   :
                    begin
                        if (CPK_TX_EOP == 1'b1) begin
                            r_FSM       <= P_IDLE ;
                        end else begin
                            r_FSM       <= P_CPK ;
                        end
                    end
                P_UEK   :
                    begin
                        if (UEK_TX_EOP == 1'b1) begin
                            r_FSM       <= P_IDLE ;
                        end else begin
                            r_FSM       <= P_UEK ;
                        end
                    end
                P_UFK   :
                    begin
                        if (UFK_TX_EOP == 1'b1) begin
                            r_FSM       <= P_IDLE ;
                        end else begin
                            r_FSM       <= P_UFK ;
                        end
                    end
                P_DEK   :
                    begin
                        if (DEK_TX_EOP == 1'b1) begin
                            r_FSM       <= P_IDLE ;
                        end else begin
                            r_FSM       <= P_DEK ;
                        end
                    end
                P_DFK   :
                    begin
                        if (DFK_TX_EOP == 1'b1) begin
                            r_FSM       <= P_IDLE ;
                        end else begin
                            r_FSM       <= P_DFK ;
                        end
                    end
                P_DPK   :
                    begin
                        if (DPK_TX_END == 1'b1) begin
                            r_FSM       <= P_IDLE ;
                        end else begin
                            r_FSM       <= P_DPK ;
                        end
                    end
                P_UPK   :
                    begin
                        if (UPK_TX_END == 1'b1) begin
                            r_FSM       <= P_IDLE ;
                        end else begin
                            r_FSM       <= P_UPK ;
                        end
                    end
                default :
                    begin
                        r_FSM           <= P_IDLE ;
                    end
            endcase
        end
    end

    assign  s_FSM_IDLE                  = r_FSM[0] ;
    assign  s_FSM_CPK                   = r_FSM[1] ;
    assign  s_FSM_UEK                   = r_FSM[2] ;
    assign  s_FSM_UFK                   = r_FSM[3] ;
    assign  s_FSM_DEK                   = r_FSM[4] ;
    assign  s_FSM_DFK                   = r_FSM[5] ;
    assign  s_FSM_DPK                   = r_FSM[6] ;
    assign  s_FSM_UPK                   = r_FSM[7] ;

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_FSM_CPK                   <= 'b0 ;
            r_FSM_UEK                   <= 'b0 ;
            r_FSM_UFK                   <= 'b0 ;
            r_FSM_DEK                   <= 'b0 ;
            r_FSM_DFK                   <= 'b0 ;
            r_FSM_DPK                   <= 'b0 ;
            r_FSM_UPK                   <= 'b0 ;
        end else begin
            r_FSM_CPK                   <= s_FSM_CPK  ;
            r_FSM_UEK                   <= s_FSM_UEK  ;
            r_FSM_UFK                   <= s_FSM_UFK  ;
            r_FSM_DEK                   <= s_FSM_DEK  ;
            r_FSM_DFK                   <= s_FSM_DFK  ;
            r_FSM_DPK                   <= s_FSM_DPK  ;
            r_FSM_UPK                   <= s_FSM_UPK  ;
        end
    end

    assign  s_CPK_TX_ACK                = s_FSM_IDLE & (~r_BUF_AFULL) & ( CPK_TX_REQ)                                                                                                 ;
    assign  s_UEK_TX_ACK                = s_FSM_IDLE & (~r_BUF_AFULL) & (~CPK_TX_REQ) & ( UEK_TX_REQ)                                                                                 ;
    assign  s_UFK_TX_ACK                = s_FSM_IDLE & (~r_BUF_AFULL) & (~CPK_TX_REQ) & (~UEK_TX_REQ) & ( UFK_TX_REQ)                                                                 ;
    assign  s_DEK_TX_ACK                = s_FSM_IDLE & (~r_BUF_AFULL) & (~CPK_TX_REQ) & (~UEK_TX_REQ) & (~UFK_TX_REQ) & ( DEK_TX_REQ)                                                 ;
    assign  s_DFK_TX_ACK                = s_FSM_IDLE & (~r_BUF_AFULL) & (~CPK_TX_REQ) & (~UEK_TX_REQ) & (~UFK_TX_REQ) & (~DEK_TX_REQ) & ( DFK_TX_REQ)                                 ;
    assign  s_DPK_TX_ACK                = s_FSM_IDLE & (~r_BUF_AFULL) & (~CPK_TX_REQ) & (~UEK_TX_REQ) & (~UFK_TX_REQ) & (~DEK_TX_REQ) & (~DFK_TX_REQ) & ( DPK_TX_REQ)                 ;
    assign  s_UPK_TX_ACK                = s_FSM_IDLE & (~r_BUF_AFULL) & (~CPK_TX_REQ) & (~UEK_TX_REQ) & (~UFK_TX_REQ) & (~DEK_TX_REQ) & (~DFK_TX_REQ) & (~DPK_TX_REQ) & ( UPK_TX_REQ) ;

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_CPK_TX_ACK                <= 'b0 ;
            r_UEK_TX_ACK                <= 'b0 ;
            r_UFK_TX_ACK                <= 'b0 ;
            r_DEK_TX_ACK                <= 'b0 ;
            r_DFK_TX_ACK                <= 'b0 ;
            r_DPK_TX_ACK                <= 'b0 ;
            r_UPK_TX_ACK                <= 'b0 ;
        end else begin
            r_CPK_TX_ACK                <= s_CPK_TX_ACK ;
            r_UEK_TX_ACK                <= s_UEK_TX_ACK ;
            r_UFK_TX_ACK                <= s_UFK_TX_ACK ;
            r_DEK_TX_ACK                <= s_DEK_TX_ACK ;
            r_DFK_TX_ACK                <= s_DFK_TX_ACK ;
            r_DPK_TX_ACK                <= s_DPK_TX_ACK ;
            r_UPK_TX_ACK                <= s_UPK_TX_ACK ;
        end
    end

/*============================================================================+/
||                                                                            ||
||                          Transmit Buffer                                   ||
||                                                                            ||
/+============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_BUF_WEN                   <= 'b0 ;
            r_BUF_WDT                   <= 'b0 ;
        end else begin
            if (r_FSM_CPK) begin
                r_BUF_WEN               <= CPK_TX_DVLD  ;
                r_BUF_WDT[67]           <= CPK_TX_SOP   ;
                r_BUF_WDT[66]           <= CPK_TX_EOP   ;
                r_BUF_WDT[65:64]        <= CPK_TX_MASK  ;
                r_BUF_WDT[63:0]         <= CPK_TX_DATA  ;
            end else if (r_FSM_UEK) begin
                r_BUF_WEN               <= UEK_TX_DVLD  ;
                r_BUF_WDT[67]           <= UEK_TX_SOP   ;
                r_BUF_WDT[66]           <= UEK_TX_EOP   ;
                r_BUF_WDT[65:64]        <= UEK_TX_MASK  ;
                r_BUF_WDT[63:0]         <= UEK_TX_DATA  ;
            end else if (r_FSM_UFK) begin
                r_BUF_WEN               <= UFK_TX_DVLD  ;
                r_BUF_WDT[67]           <= UFK_TX_SOP   ;
                r_BUF_WDT[66]           <= UFK_TX_EOP   ;
                r_BUF_WDT[65:64]        <= UFK_TX_MASK  ;
                r_BUF_WDT[63:0]         <= UFK_TX_DATA  ;
            end else if (r_FSM_DEK) begin
                r_BUF_WEN               <= DEK_TX_DVLD  ;
                r_BUF_WDT[67]           <= DEK_TX_SOP   ;
                r_BUF_WDT[66]           <= DEK_TX_EOP   ;
                r_BUF_WDT[65:64]        <= DEK_TX_MASK  ;
                r_BUF_WDT[63:0]         <= DEK_TX_DATA  ;
            end else if (r_FSM_DFK) begin
                r_BUF_WEN               <= DFK_TX_DVLD  ;
                r_BUF_WDT[67]           <= DFK_TX_SOP   ;
                r_BUF_WDT[66]           <= DFK_TX_EOP   ;
                r_BUF_WDT[65:64]        <= DFK_TX_MASK  ;
                r_BUF_WDT[63:0]         <= DFK_TX_DATA  ;
            end else if (r_FSM_DPK) begin
                r_BUF_WEN               <= DPK_TX_DVLD  ;
                r_BUF_WDT[67]           <= DPK_TX_SOP   ;
                r_BUF_WDT[66]           <= DPK_TX_EOP   ;
                r_BUF_WDT[65:64]        <= DPK_TX_MASK  ;
                r_BUF_WDT[63:0]         <= DPK_TX_DATA  ;
            end else if (r_FSM_UPK) begin
                r_BUF_WEN               <= UPK_TX_DVLD  ;
                r_BUF_WDT[67]           <= UPK_TX_SOP   ;
                r_BUF_WDT[66]           <= UPK_TX_EOP   ;
                r_BUF_WDT[65:64]        <= UPK_TX_MASK  ;
                r_BUF_WDT[63:0]         <= UPK_TX_DATA  ;
            end else begin
                r_BUF_WEN               <= 'b0 ;
                r_BUF_WDT               <= 'b0 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_BUF_WEN_DFF1              <= 'b0 ;
            r_BUF_WDT_DFF1              <= 'b0 ;
            r_BUF_WEN_DFF2              <= 'b0 ;
            r_BUF_WDT_DFF2              <= 'b0 ;
        end else begin
            r_BUF_WEN_DFF1              <= r_BUF_WEN        ;
            r_BUF_WDT_DFF1              <= r_BUF_WDT        ;
            r_BUF_WEN_DFF2              <= r_BUF_WEN_DFF1   ;
            r_BUF_WDT_DFF2              <= r_BUF_WDT_DFF1   ;
        end
    end

    assign  s_BUF_WEN                   = r_BUF_WEN_DFF2  ;
    assign  s_BUF_WDT                   = {4'd0,r_BUF_WDT_DFF2} ;

    //i72o72_d2018
    sfifo_i72o72_d512 U_TX_BUF (
        .srst                           ( PCIE_RST              ),
        .clk                            ( PCIE_CLK              ),
        .wr_en                          ( s_BUF_WEN             ),
        .din                            ( s_BUF_WDT             ),
        .rd_en                          ( s_BUF_REN             ),
        .dout                           ( s_BUF_RDT             ),
        .almost_empty                   (                       ),
        .almost_full                    (                       ),
        .empty                          ( s_BUF_EMPTY           ),
        .full                           (                       ),
        .data_count                     ( s_BUF_DCNT            )
        );

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_BUF_AFULL                 <= 1'b0 ;
        end else begin
            r_BUF_AFULL                 <= | s_BUF_DCNT[11:10]  ;
        end
    end

    assign s_BUF_REN                    = AXIS_TX_TREADY & (~s_BUF_EMPTY) ;

    assign s_AXIS_TX_TVALID             =    s_BUF_REN                     ;
    assign s_AXIS_TX_TDATA              =    s_BUF_RDT[63:0]               ;
    assign s_AXIS_TX_TKEEP[7:4]         = {4{s_BUF_RDT[65]}}               ;
    assign s_AXIS_TX_TKEEP[3:0]         = {4{s_BUF_RDT[64]}}               ;
    assign s_AXIS_TX_TLAST              =    s_BUF_RDT[66]   & s_BUF_REN   ;

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_AXIS_TX_TVALID            <= 'b0 ;
            r_AXIS_TX_TDATA             <= 'b0 ;
            r_AXIS_TX_TKEEP             <= 'b0 ;
            r_AXIS_TX_TLAST             <= 'b0 ;
        end else begin
            r_AXIS_TX_TVALID            <= s_AXIS_TX_TVALID ;
            r_AXIS_TX_TDATA             <= s_AXIS_TX_TDATA  ;
            r_AXIS_TX_TKEEP             <= s_AXIS_TX_TKEEP  ;
            r_AXIS_TX_TLAST             <= s_AXIS_TX_TLAST  ;
        end
    end

endmodule

/*========================================================================================

    -- 64bit address memory read/write packet heard:
                 ------------------------------------------------------------------
                |      0        ||       1       ||       2       ||       3       |
                |7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0|
                |------------------------------------------------------------------|
     Byte 0-3   |R|fmt|   type  ||R| TC  |   R   ||0 0|att| R |      length        |
                |------------------------------------------------------------------|
     Byte 4-7   |          requester ID          ||     tag       || L BE  |  F BE |
                |------------------------------------------------------------------|
     Byte 8-11  |                      Address[63:32]                              |
                |------------------------------------------------------------------|
     Byte 12-15 |            Address[31:2]                                     |00 |
                 ------------------------------------------------------------------

    -- 32bit address memory read/write packet heard:
                 ------------------------------------------------------------------
                |      0        ||       1       ||       2       ||       3       |
                |7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0|
                |------------------------------------------------------------------|
     Byte 0-3   |R|fmt|   type  ||R| TC  |   R   ||0 0|att| R |      length        |
                |------------------------------------------------------------------|
     Byte 4-7   |          requester ID          ||     tag       || L BE  |  F BE |
                |------------------------------------------------------------------|
     Byte 8-11  |            Address[31:2]                                     |00 |
                |------------------------------------------------------------------|
     Byte 12-15 |                                 Reseave                          |
                 ------------------------------------------------------------------

    --  request completion packet heard:
                 ------------------------------------------------------------------
                |      0        ||       1       ||       2       ||       3       |
                |7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0||7|6|5|4|3|2|1|0|
                |------------------------------------------------------------------|
     Byte 0-3   |R|fmt|   type  ||R| TC  |   R   ||T|E|att| R |      length        |
                |------------------------------------------------------------------|
     Byte 4-7   |          completer ID          || cs  |0|      byte count        |
                |------------------------------------------------------------------|
     Byte 8-11  |          requester ID          ||     tag       ||R| low address |
                |------------------------------------------------------------------|
     Byte 12-15 |                           completer data                         |
                 ------------------------------------------------------------------

========================================================================================*/
