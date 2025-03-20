// =================================================================================================
// File Name      : pcie_rx.v
// Module         : PCIE_RX
// Function       : PCIE receive module
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

module PCIE_RX (
    //system signals
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]

    //pcie rx
    input       [  63:0]                AXIS_RX_TDATA                           ,//(i)  [ 64]
    input       [   7:0]                AXIS_RX_TKEEP                           ,//(i)  [  8]
    input                               AXIS_RX_TLAST                           ,//(i)  [  1]
    input                               AXIS_RX_TVALID                          ,//(i)  [  1]
    output                              AXIS_RX_TREADY                          ,//(o)  [  1]
    input       [21:0]                  AXIS_RX_TUSER                           ,//(i)  [ 22]

    //pcie download cpld
    output                              BAR0_DN_CPLD_SOP                        ,//(o)  [   ]
    output                              BAR0_DN_CPLD_EOP                        ,//(o)  [   ]
    output      [  63:0]                BAR0_DN_CPLD_DATA                       ,//(o)  [ 64]
    output                              BAR0_DN_CPLD_DVLD                       ,//(o)  [   ]
    output      [   7:0]                BAR0_DN_CPLD_TAG                        ,//(o)  [  8]
    output      [  11:0]                BAR0_DN_CPLD_DCNT                       ,//(o)  [ 12]

    //pcie register command
    output                              BAR0_REG_WR_REQ                         ,//(i)  [  1]
    output                              BAR0_REG_RD_REQ                         ,//(i)  [  1]
    input                               BAR0_REG_WR_OK                          ,//(o)  [  1]
    input                               BAR0_REG_RD_OK                          ,//(o)  [  1]
    output      [  31:0]                BAR0_REG_WR_DATA                        ,//(o)  [ 32]
    output      [  63:0]                BAR0_REG_OP_ADDR                        ,//(o)  [ 64]
    //pcie register info
    output      [   6:0]                BAR0_RX_FMT                             ,//(o)  [  7]
    output      [   2:0]                BAR0_RX_TC                              ,//(o)  [  3]
    output                              BAR0_RX_TD                              ,//(o)  [  1]
    output                              BAR0_RX_EP                              ,//(o)  [  1]
    output      [   1:0]                BAR0_RX_ATTR                            ,//(o)  [  2]
    output      [   9:0]                BAR0_RX_LEN                             ,//(o)  [ 10]
    output      [  15:0]                BAR0_RX_RID                             ,//(o)  [ 16]
    output      [   7:0]                BAR0_RX_RTAG                            ,//(o)  [  8]
    output      [   7:0]                BAR0_RX_BE                               //(o)  [  8]
    );

// =============================================================================
// localparam Declare
// =============================================================================

    //fmt&type
    localparam  P_MEM_RD32_FMT          = 7'b0000000                            ;//(p)  [  7]  Memory read request with 32 bits address
    localparam  P_MEM_WR32_FMT          = 7'b1000000                            ;//(p)  [  7]  Memory write request with 32 bits address
    localparam  P_MEM_RD64_FMT          = 7'b0100000                            ;//(p)  [  7]  Memory read request with 64 bits address
    localparam  P_MEM_WR64_FMT          = 7'b1100000                            ;//(p)  [  7]  Memory write request with 64 bits address
    localparam  P_MEM_RW32_FMT          = 6'b000000                             ;//(p)  [  6]  Memory read or write request with 32 bits address
    localparam  P_MEM_RW64_FMT          = 6'b100000                             ;//(p)  [  6]  Memory read or write request with 64 bits address
    localparam  P_CPLD_FMT              = 7'b1001010                            ;//(p)  [  7]  CPLD decode

// =============================================================================
// Internal Signal Declare
// =============================================================================

    reg                                 r_AXIS_RX_TFRIST                        ;//(r)  [  1]
    reg                                 r_RX_ST_SOP                             ;//(r)  [  7]
    reg                                 r_RX_ST_EOP                             ;//(r)  [  1]
    reg                                 r_RX_ST_VALID                           ;//(r)  [  1]
    reg         [  63:0]                r_RX_ST_DATA                            ;//(r)  [ 64]
    reg                                 r_RX_ST_BAR0                            ;//(r)  [  1]
    reg         [  63:0]                r_RX_ST_DATA_DFF                        ;//(r)  [ 64]
    reg                                 r_RX_ST_BAR0_DFF                        ;//(r)  [  1]

    wire                                s_CPLD_SOP                              ;//(s)  [  1]
    wire                                s_MEM32_SOP                             ;//(s)  [  1]

    reg                                 r_CPLD_SOP_DFF1                         ;//(r)  [  1]
    reg                                 r_CPLD_SOP_DFF2                         ;//(r)  [  1]
    reg         [  11:0]                r_CPLD_DCNT                             ;//(r)  [ 12]
    reg         [   7:0]                r_CPLD_TAG                              ;//(r)  [  8]
    reg                                 r_CPLD_EN                               ;//(r)  [  1]
    reg         [  63:0]                r_CPLD_DATA                             ;//(r)  [ 64]
    reg                                 r_CPLD_DVLD                             ;//(r)  [  1]
    reg                                 r_CPLD_EOP                              ;//(r)  [  1]

    reg                                 r_BAR0_DN_CPLD_SOP                      ;//(r)  [  1]
    reg                                 r_BAR0_DN_CPLD_EOP                      ;//(r)  [  1]
    reg         [  63:0]                r_BAR0_DN_CPLD_DATA                     ;//(r)  [ 64]
    reg                                 r_BAR0_DN_CPLD_DVLD                     ;//(r)  [  1]
    reg         [   7:0]                r_BAR0_DN_CPLD_TAG                      ;//(r)  [  8]
    reg         [  11:0]                r_BAR0_DN_CPLD_DCNT                     ;//(r)  [ 12]

    reg                                 r_MEM32_SOP_DFF1                        ;//(r)  [  1]

    reg                                 r_MEM_RD_REQ                            ;//(r)  [  1]
    reg                                 r_MEM_WR_REQ                            ;//(r)  [  1]
    reg         [  31:0]                r_MEM_WR_DATA                           ;//(r)  [ 32]
    reg         [  63:0]                r_MEM_OP_ADDR                           ;//(r)  [ 64]
    reg         [  31:0]                r_MEM_OP_HEAD1                          ;//(r)  [ 32]
    reg         [  31:0]                r_MEM_OP_HEAD0                          ;//(r)  [ 32]

    reg                                 r_BUF_WEN                               ;//(r)  [  1]
    reg         [ 179:0]                r_BUF_WDAT                              ;//(s)  [180]
    wire        [ 179:0]                s_BUF_RDAT                              ;//(s)  [180]
    wire                                s_BUF_EMPTY                             ;//(s)  [  1]
    reg         [   2:0]                r_SHFT                                  ;//(r)  [  4]
    reg                                 r_OP_ST                                 ;//(r)  [  1]
    reg                                 r_BUF_REN                               ;//(r)  [  1]

    reg                                 r_BAR0_REG_WR_REQ                       ;//(r)  [  1]
    reg                                 r_BAR0_REG_RD_REQ                       ;//(r)  [  1]
    reg         [  31:0]                r_BAR0_REG_WR_DATA                      ;//(r)  [ 32]
    reg         [  63:0]                r_BAR0_REG_OP_ADDR                      ;//(r)  [ 64]

    reg         [   6:0]                r_BAR0_RX_FMT                           ;//(r)  [  7]
    reg         [   2:0]                r_BAR0_RX_TC                            ;//(r)  [  3]
    reg                                 r_BAR0_RX_TD                            ;//(r)  [  1]
    reg                                 r_BAR0_RX_EP                            ;//(r)  [  1]
    reg         [   1:0]                r_BAR0_RX_ATTR                          ;//(r)  [  2]
    reg         [   9:0]                r_BAR0_RX_LEN                           ;//(r)  [ 10]
    reg         [  15:0]                r_BAR0_RX_RID                           ;//(r)  [ 16]
    reg         [   7:0]                r_BAR0_RX_RTAG                          ;//(r)  [  8]
    reg         [   7:0]                r_BAR0_RX_BE                            ;//(r)  [  8]

// =================================================================================================
// RTL Body
// =================================================================================================

/*=============================================================================+/
||                                                                             ||
||                          Output Port                                        ||
||                                                                             ||
/+=============================================================================*/

    assign  BAR0_DN_CPLD_SOP            = r_BAR0_DN_CPLD_SOP                    ;
    assign  BAR0_DN_CPLD_EOP            = r_BAR0_DN_CPLD_EOP                    ;
    assign  BAR0_DN_CPLD_DATA           = r_BAR0_DN_CPLD_DATA                   ;
    assign  BAR0_DN_CPLD_DVLD           = r_BAR0_DN_CPLD_DVLD                   ;
    assign  BAR0_DN_CPLD_TAG            = r_BAR0_DN_CPLD_TAG                    ;
    assign  BAR0_DN_CPLD_DCNT           = r_BAR0_DN_CPLD_DCNT                   ;

    assign  BAR0_RX_FMT                 = r_BAR0_RX_FMT                         ;
    assign  BAR0_RX_TC                  = r_BAR0_RX_TC                          ;
    assign  BAR0_RX_TD                  = r_BAR0_RX_TD                          ;
    assign  BAR0_RX_EP                  = r_BAR0_RX_EP                          ;
    assign  BAR0_RX_ATTR                = r_BAR0_RX_ATTR                        ;
    assign  BAR0_RX_LEN                 = r_BAR0_RX_LEN                         ;

    assign  BAR0_RX_RID                 = r_BAR0_RX_RID                         ;
    assign  BAR0_RX_RTAG                = r_BAR0_RX_RTAG                        ;
    assign  BAR0_RX_BE                  = r_BAR0_RX_BE                          ;

    assign  BAR0_REG_RD_REQ             = r_BAR0_REG_RD_REQ                     ;
    assign  BAR0_REG_WR_REQ             = r_BAR0_REG_WR_REQ                     ;
    assign  BAR0_REG_WR_DATA            = r_BAR0_REG_WR_DATA                    ;
    assign  BAR0_REG_OP_ADDR            = r_BAR0_REG_OP_ADDR                    ;

    assign  AXIS_RX_TREADY              = 1'b1                                  ;

/*=============================================================================+/
||                                                                             ||
||                                Input DFF                                    ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_AXIS_RX_TFRIST            <= 1'b1 ;
        end else begin
            if (AXIS_RX_TVALID) begin
                r_AXIS_RX_TFRIST        <= AXIS_RX_TLAST ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_RX_ST_SOP                 <= 'b0 ;
            r_RX_ST_EOP                 <= 'b0 ;
            r_RX_ST_VALID               <= 'b0 ;
            r_RX_ST_DATA                <= 'b0 ;
            r_RX_ST_BAR0                <= 'b0 ;
        end else begin
            r_RX_ST_SOP                 <= AXIS_RX_TVALID & r_AXIS_RX_TFRIST    ;
            r_RX_ST_EOP                 <= AXIS_RX_TVALID &   AXIS_RX_TLAST     ;
            r_RX_ST_VALID               <= AXIS_RX_TVALID                       ;
            r_RX_ST_DATA                <= AXIS_RX_TDATA                        ;
            r_RX_ST_BAR0                <= AXIS_RX_TUSER[2]                     ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_RX_ST_DATA_DFF            <= 'b0 ;
            r_RX_ST_BAR0_DFF            <= 'b0 ;
        end else begin
            if (r_RX_ST_VALID) begin
                r_RX_ST_DATA_DFF        <= r_RX_ST_DATA  ;
                r_RX_ST_BAR0_DFF        <= r_RX_ST_BAR0  ;
            end
        end
    end

    assign s_CPLD_SOP   = (r_RX_ST_SOP == 1'b1 && r_RX_ST_DATA[30:24] == P_CPLD_FMT     ) ? 1'b1 : 1'b0 ;
    assign s_MEM32_SOP  = (r_RX_ST_SOP == 1'b1 && r_RX_ST_DATA[29:24] == P_MEM_RW32_FMT ) ? 1'b1 : 1'b0 ;

/*=============================================================================+/
||                                                                             ||
||                    CPLD Packet Decode                                       ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_CPLD_SOP_DFF1             <= 1'b0;
            r_CPLD_SOP_DFF2             <= 1'b0;
        end else begin
            r_CPLD_SOP_DFF1             <= s_CPLD_SOP       ;
            r_CPLD_SOP_DFF2             <= r_CPLD_SOP_DFF1  ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_CPLD_DCNT                 <= 'b0;
            r_CPLD_TAG                  <= 'b0;
        end else begin
            if (s_CPLD_SOP      )       begin   r_CPLD_DCNT <= r_RX_ST_DATA[43:32]  ; end
            if (r_CPLD_SOP_DFF1 )       begin   r_CPLD_TAG  <= r_RX_ST_DATA[15: 8]  ; end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_CPLD_EN                   <= 1'b0;
        end else begin
            if (r_CPLD_SOP_DFF1) begin
                r_CPLD_EN               <= 1'b1;
            end else if (r_RX_ST_EOP) begin
                r_CPLD_EN               <= 1'b0;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_CPLD_DATA                 <= 'b0 ;
            r_CPLD_DVLD                 <= 'b0 ;
            r_CPLD_EOP                  <= 'b0 ;
        end else begin
            r_CPLD_DATA                 <= {r_RX_ST_DATA[31:0] , r_RX_ST_DATA_DFF[63:32]} ;
            r_CPLD_DVLD                 <=  r_RX_ST_VALID      & r_CPLD_EN                ;
            r_CPLD_EOP                  <=  r_RX_ST_EOP        & r_CPLD_EN                ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_BAR0_DN_CPLD_SOP          <= 'b0 ;
            r_BAR0_DN_CPLD_EOP          <= 'b0 ;
            r_BAR0_DN_CPLD_DATA         <= 'b0 ;
            r_BAR0_DN_CPLD_DVLD         <= 'b0 ;
            r_BAR0_DN_CPLD_TAG          <= 'b0 ;
            r_BAR0_DN_CPLD_DCNT         <= 'b0 ;
        end else begin
            r_BAR0_DN_CPLD_SOP          <= r_CPLD_SOP_DFF2  ;
            r_BAR0_DN_CPLD_EOP          <= r_CPLD_EOP       ;
            r_BAR0_DN_CPLD_DVLD         <= r_CPLD_DVLD      ;
            r_BAR0_DN_CPLD_DATA         <= r_CPLD_DATA      ;
            r_BAR0_DN_CPLD_TAG          <= r_CPLD_TAG       ;
            r_BAR0_DN_CPLD_DCNT         <= r_CPLD_DCNT      ;
        end
    end

/*=============================================================================+/
||                                                                             ||
||                    Memory Read & Write Packet Decode                        ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_MEM32_SOP_DFF1            <= 1'b0 ;
        end else begin
            r_MEM32_SOP_DFF1            <= s_MEM32_SOP ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_MEM_RD_REQ                <= 'b0 ;
            r_MEM_WR_REQ                <= 'b0 ;
            r_MEM_OP_HEAD1              <= 'b0 ;
            r_MEM_OP_HEAD0              <= 'b0 ;
        end else begin
            if (r_MEM32_SOP_DFF1 & r_RX_ST_BAR0_DFF) begin
                r_MEM_RD_REQ            <= ~r_RX_ST_DATA_DFF[30]      ;
                r_MEM_WR_REQ            <=  r_RX_ST_DATA_DFF[30]      ;
                r_MEM_OP_HEAD1          <=  r_RX_ST_DATA_DFF[63:32]   ;
                r_MEM_OP_HEAD0          <=  r_RX_ST_DATA_DFF[31:0]    ;
            end else begin
                r_MEM_RD_REQ            <= 'b0 ;
                r_MEM_WR_REQ            <= 'b0 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_MEM_OP_ADDR               <= 'b0 ;
        end else begin
            if (r_MEM32_SOP_DFF1 & r_RX_ST_BAR0_DFF) begin
                r_MEM_OP_ADDR[63:32]    <=  32'h00000000        ;
                r_MEM_OP_ADDR[31: 0]    <=  r_RX_ST_DATA[31:0]  ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_MEM_WR_DATA               <= 'b0 ;
        end else begin
            if (r_MEM32_SOP_DFF1 & r_RX_ST_BAR0) begin
//              r_MEM_WR_DATA[31:24]    <= r_RX_ST_DATA[39:32]  ;
//              r_MEM_WR_DATA[23:16]    <= r_RX_ST_DATA[47:40]  ;
//              r_MEM_WR_DATA[15: 8]    <= r_RX_ST_DATA[55:48]  ;
//              r_MEM_WR_DATA[ 7: 0]    <= r_RX_ST_DATA[63:56]  ;

                r_MEM_WR_DATA[31:24]    <= r_RX_ST_DATA[63:56]  ;
                r_MEM_WR_DATA[23:16]    <= r_RX_ST_DATA[55:48]  ;
                r_MEM_WR_DATA[15: 8]    <= r_RX_ST_DATA[47:40]  ;
                r_MEM_WR_DATA[ 7: 0]    <= r_RX_ST_DATA[39:32]  ;
            end
        end
    end


/*=============================================================================+/
||                                                                             ||
||                       Register R/W Command Buffer                           ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_BUF_WEN                  <= 'b0 ;
        end else begin
            r_BUF_WEN                  <= r_MEM_RD_REQ | r_MEM_WR_REQ ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_BUF_WDAT                 <= 'b0 ;
        end else begin
            r_BUF_WDAT                 <= { 20'd0                   ,
                                            r_MEM_OP_HEAD0[31:12]   , //[20] r_BUF_WDAT[159:140]
                                            r_MEM_WR_REQ            , //[ 1] r_BUF_WDAT[    139]
                                            r_MEM_RD_REQ            , //[ 1] r_BUF_WDAT[    138]
                                            r_MEM_OP_HEAD0[9:0]     , //[10] r_BUF_WDAT[137:128]
                                            r_MEM_OP_HEAD1          , //[32] r_BUF_WDAT[127: 96]
                                            r_MEM_OP_ADDR           , //[64] r_BUF_WDAT[ 95: 32]
                                            r_MEM_WR_DATA             //[32] r_BUF_WDAT[ 31:  0]
                                          };
        end
    end

    sfifo_i180_o180_d512 U_CBUF (
        .srst                           ( PCIE_RST          ),//(i)
        .clk                            ( PCIE_CLK          ),//(i)
        .wr_en                          ( r_BUF_WEN         ),//(i)
        .din                            ( r_BUF_WDAT        ),//(i)
        .rd_en                          ( r_BUF_REN         ),//(o)
        .dout                           ( s_BUF_RDAT        ),//(o)
        .almost_empty                   (                   ),//(o)
        .almost_full                    (                   ),//(o)
        .empty                          ( s_BUF_EMPTY       ),//(o)
        .full                           (                   ),//(o)
        .data_count                     (                   ) //(o)
        );

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_SHFT                      <= 3'b001 ;
        end else begin
            r_SHFT                      <= {r_SHFT[0] , r_SHFT[2:1]} ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_OP_ST                     <= 1'b0 ;
        end else begin
            if (r_BUF_REN) begin
                r_OP_ST                 <= 1'b1 ;
            end else if (r_BAR0_REG_WR_REQ | BAR0_REG_RD_OK) begin
                r_OP_ST                 <= 1'b0 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_BUF_REN                   <= 'b0 ;
        end else begin
            r_BUF_REN                   <= r_SHFT[0] & (~s_BUF_EMPTY) & (~r_OP_ST) ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_BAR0_RX_FMT               <= 'b0 ;
            r_BAR0_RX_TC                <= 'b0 ;
            r_BAR0_RX_TD                <= 'b0 ;
            r_BAR0_RX_EP                <= 'b0 ;
            r_BAR0_RX_ATTR              <= 'b0 ;
            r_BAR0_RX_LEN               <= 'b0 ;
            r_BAR0_RX_RID               <= 'b0 ;
            r_BAR0_RX_RTAG              <= 'b0 ;
            r_BAR0_RX_BE                <= 'b0 ;

            r_BAR0_REG_WR_REQ           <= 'b0 ;
            r_BAR0_REG_RD_REQ           <= 'b0 ;
            r_BAR0_REG_WR_DATA          <= 'b0 ;
            r_BAR0_REG_OP_ADDR          <= 'b0 ;
        end else begin
            r_BAR0_RX_FMT               <= s_BUF_RDAT[158:152]              ; // [128+30:128+24]    Head0[30:24]
            r_BAR0_RX_TC                <= s_BUF_RDAT[150:148]              ; // [128+22:128+20]    Head0[22:20]
            r_BAR0_RX_TD                <= s_BUF_RDAT[143]                  ; // [128+15:128+15]    Head0[15]
            r_BAR0_RX_EP                <= s_BUF_RDAT[142]                  ; // [128+14:128+14]    Head0[14]
            r_BAR0_RX_ATTR              <= s_BUF_RDAT[141:140]              ; // [128+13:128+12]    Head0[13:12]
            r_BAR0_RX_LEN               <= s_BUF_RDAT[137:128]              ; // [128+ 9:128+ 0]    Head0[9:0]

            r_BAR0_RX_RID               <= s_BUF_RDAT[127:112]              ; // [ 96+31: 96+16]    Head1[31:16]
            r_BAR0_RX_RTAG              <= s_BUF_RDAT[111:104]              ; // [ 96+15: 96+ 8]    Head1[15:8]
            r_BAR0_RX_BE                <= s_BUF_RDAT[103:96]               ; // [ 96+ 7: 96+ 0]    Head1[7:0]

            r_BAR0_REG_WR_REQ           <= s_BUF_RDAT[139]  & r_BUF_REN     ;
            r_BAR0_REG_RD_REQ           <= s_BUF_RDAT[138]  & r_BUF_REN     ;
            r_BAR0_REG_OP_ADDR          <= s_BUF_RDAT[95:32]                ;
            r_BAR0_REG_WR_DATA          <= s_BUF_RDAT[31:0]                 ;
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
