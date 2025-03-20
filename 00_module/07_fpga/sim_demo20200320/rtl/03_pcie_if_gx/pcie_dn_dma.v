// =================================================================================================
// File Name      : pcie_dn_dma.v
// Module         : PCIE_DN_DMA
// Function       : PCIE download dma module
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

module PCIE_DN_DMA # (
    parameter                           p_CH_ID        = 1'b0                    //(p)  [  2]
    )(
    //clock and reset
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
    //system signal
    input                               DN_CX_EOP                               ,//(i)  [  1]
    input       [  15:0]                COMPLETER_ID                            ,//(i)  [ 16] CFG_BUSDEV
    //local buffer
    input                               DN_LBUF_WR_RDY                          ,//(i)  [  1]
    output                              DN_LBUF_WR_REQ                          ,//(o)  [  1]
    //bufq
    input                               DN_FBUF_RD_RDY                          ,//(i)  [  1]
    output                              DN_FBUF_RD_REQ                          ,//(o)  [  1]
    input       [  95:0]                DN_FBUF_RD_DATA                         ,//(i)  [ 96]
    output                              DN_EBUF_WR_REQ                          ,//(o)  [  1]
    output      [  15:0]                DN_EBUF_WR_DATA                         ,//(o)  [ 16]
    //pcie tx
    output                              DPK_TX_REQ                              ,//(i)  [  1]
    input                               DPK_TX_ACK                              ,//(o)  [  1]
    output                              DPK_TX_DVLD                             ,//(i)  [  1]
    output      [  63:0]                DPK_TX_DATA                             ,//(i)  [ 64]
    output      [   1:0]                DPK_TX_MASK                             ,//(i)  [  2]
    output                              DPK_TX_SOP                              ,//(i)  [  1]
    output                              DPK_TX_EOP                              ,//(i)  [  1]
    output                              DPK_TX_END                               //(i)  [  1]
    );

// =============================================================================
// Parameter Declare
// =============================================================================

    localparam                          p_MEM_RD32_FMT  = 7'b0000000            ;//(p)  [  7]
    localparam                          p_MEM_WR32_FMT  = 7'b1000000            ;//(p)  [  7]
    localparam                          p_MEM_RD64_FMT  = 7'b0100000            ;//(p)  [  7]
    localparam                          p_MEM_WR64_FMT  = 7'b1100000            ;//(p)  [  7]

    localparam                          p_IDLE          = 7'b0000001            ;//(p)  [  7]
    localparam                          p_FBUF_CHK      = 7'b0000010            ;//(p)  [  7]
    localparam                          p_FBUF_REQ      = 7'b0000100            ;//(p)  [  7]
    localparam                          p_LBUF_CHK      = 7'b0001000            ;//(p)  [  7]
    localparam                          p_TX_REQ        = 7'b0010000            ;//(p)  [  7]
    localparam                          p_TX_DATA       = 7'b0100000            ;//(p)  [  7]
    localparam                          p_EBUF_REQ      = 7'b1000000            ;//(p)  [  7]

// =============================================================================
// Internal Signal Declare
// =============================================================================

    reg                                 r_DN_CX_EOP                             ;//(r)  [  1]
    reg                                 r_DN_FBUF_RD_RDY                        ;//(r)  [  1]
    reg                                 r_DN_LBUF_WR_RDY                        ;//(r)  [  1]
    reg                                 r_DPK_TX_ACK                            ;//(r)  [  1]
    reg         [   7:0]                r_DN_TAG_CNT                            ;//(r)  [  8]
    reg                                 r_DN_TAG_RDY                            ;//(r)  [  1]

    reg         [   6:0]                r_FSM                                   ;//(r)  [  7]
    wire                                s_ST_FBUF_REQ                           ;//(s)  [  1]
    wire                                s_ST_TX_REQ                             ;//(s)  [  1]
    wire                                s_ST_EBUF_REQ                           ;//(s)  [  1]

    reg                                 r_DN_FBUF_RD_REQ                        ;//(r)  [  1]
    reg                                 r_DN_EBUF_WR_REQ                        ;//(r)  [  1]
    reg                                 r_DN_LBUF_WR_REQ                        ;//(r)  [  1]
    reg         [  15:0]                r_DN_EBUF_WR_DATA                       ;//(r)  [ 16]

    reg         [  63:0]                r_DMA_ADDR                              ;//(r)  [ 64]
    reg         [  15:0]                r_DMA_SIZE                              ;//(r)  [ 16]
    reg                                 r_DMA_H0                                ;//(r)  [  1]
    reg                                 r_DMA_H1                                ;//(r)  [  1]
    reg                                 r_DMA_TX                                ;//(r)  [  1]
    reg         [   7:0]                r_DMA_DCNT                              ;//(r)  [ 16]
    reg                                 r_RD64_FLAG                             ;//(r)  [  1]
    reg                                 r_DPK_TX_END                            ;//(r)  [  1]
    wire                                s_DPK_TX_H0                             ;//(s)  [  1]
    wire                                s_DPK_TX_H1                             ;//(s)  [  1]

    reg         [   7:0]                r_TAG_CNT                               ;//(r)  [  8]
    reg                                 r_DPK_TX_REQ                            ;//(r)  [  1]
    reg                                 r_DPK_TX_SOP                            ;//(r)  [  1]
    reg                                 r_DPK_TX_EOP                            ;//(r)  [  1]
    reg                                 r_DPK_TX_DVLD                           ;//(r)  [  5]
    reg         [   1:0]                r_DPK_TX_MASK                           ;//(r)  [  2]
    reg         [  63:0]                r_DPK_TX_DATA                           ;//(r)  [ 64]

// =================================================================================================
// RTL Body
// =================================================================================================

/*=============================================================================+/
||                                                                             ||
||                                   Output Ports                              ||
||                                                                             ||
/+=============================================================================*/

    assign  DN_LBUF_WR_REQ              = r_DN_LBUF_WR_REQ                      ;
    assign  DN_FBUF_RD_REQ              = r_DN_FBUF_RD_REQ                      ;
    assign  DN_EBUF_WR_REQ              = r_DN_EBUF_WR_REQ                      ;
    assign  DN_EBUF_WR_DATA             = r_DN_EBUF_WR_DATA                     ;

    assign  DPK_TX_REQ                  = r_DPK_TX_REQ                          ;
    assign  DPK_TX_DVLD                 = r_DPK_TX_DVLD                         ;
    assign  DPK_TX_DATA                 = r_DPK_TX_DATA                         ;
    assign  DPK_TX_MASK                 = r_DPK_TX_MASK                         ;
    assign  DPK_TX_SOP                  = r_DPK_TX_SOP                          ;
    assign  DPK_TX_EOP                  = r_DPK_TX_EOP                          ;
    assign  DPK_TX_END                  = r_DPK_TX_END                          ;

/*============================================================================+/
||                                                                            ||
||                                     DFF                                    ||
||                                                                            ||
/+============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_CX_EOP                 <= 1'b0 ;
        end else begin
            r_DN_CX_EOP                 <= DN_CX_EOP ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_FBUF_RD_RDY            <= 1'b0 ;
            r_DN_LBUF_WR_RDY            <= 1'b0 ;
        end else begin
            r_DN_FBUF_RD_RDY            <= DN_FBUF_RD_RDY ;
            r_DN_LBUF_WR_RDY            <= DN_LBUF_WR_RDY ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DPK_TX_ACK                <= 1'b0 ;
        end else begin
            r_DPK_TX_ACK                <= DPK_TX_ACK ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_TAG_CNT                <= 8'd64 ;
        end else begin
            if (r_DN_CX_EOP == 1'b1 && r_DPK_TX_EOP == 1'b0) begin
                r_DN_TAG_CNT            <= r_DN_TAG_CNT + 1'b1 ;
            end else if (r_DN_CX_EOP == 1'b0 && r_DPK_TX_EOP == 1'b1) begin
                r_DN_TAG_CNT            <= r_DN_TAG_CNT - 1'b1 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_TAG_RDY                <= 1'b0 ;
        end else begin
            r_DN_TAG_RDY                <= | r_DN_TAG_CNT[7:5] ;
        end
    end

/*============================================================================+/
||                                                                            ||
||                             Download DMA Control FSM                       ||
||                                                                            ||
/+============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_FSM                       <= p_IDLE ;
        end else begin
            case (r_FSM)
                p_IDLE :
                    begin
                        if (r_DN_TAG_RDY) begin
                            r_FSM       <= p_FBUF_CHK ;
                        end else begin
                            r_FSM       <= p_IDLE ;
                        end
                    end
                p_FBUF_CHK :
                    begin
                        if (r_DN_FBUF_RD_RDY) begin
                            r_FSM       <= p_FBUF_REQ ;
                        end else begin
                            r_FSM       <= p_FBUF_CHK ;
                        end
                    end
                p_FBUF_REQ :
                    begin
                        r_FSM           <= p_LBUF_CHK ;
                    end
                p_LBUF_CHK :
                    begin
                        if (r_DN_LBUF_WR_RDY) begin
                            r_FSM       <= p_TX_REQ ;
                        end else begin
                            r_FSM       <= p_LBUF_CHK ;
                        end
                    end
                p_TX_REQ :
                    begin
                        if (r_DPK_TX_ACK) begin
                            r_FSM       <= p_TX_DATA ;
                        end else begin
                            r_FSM       <= p_TX_REQ ;
                        end
                    end
                p_TX_DATA :
                    begin
                        if (r_DPK_TX_END) begin
                            r_FSM       <= p_EBUF_REQ ;
                        end else begin
                            r_FSM       <= p_TX_DATA ;
                        end
                    end
                p_EBUF_REQ :
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

    assign  s_ST_FBUF_REQ               = r_FSM[2] ;
    assign  s_ST_TX_REQ                 = r_FSM[4] ;
    assign  s_ST_EBUF_REQ               = r_FSM[6] ;

/*========================================================================+/
||                                                                        ||
||                         Download Address Control                       ||
||                                                                        ||
/+========================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DPK_TX_REQ                <= 'b0 ;
            r_DN_FBUF_RD_REQ            <= 'b0 ;
            r_DN_EBUF_WR_REQ            <= 'b0 ;
            r_DN_LBUF_WR_REQ            <= 'b0 ;
        end else begin
            r_DPK_TX_REQ                <= s_ST_TX_REQ   ;
            r_DN_FBUF_RD_REQ            <= s_ST_FBUF_REQ ;
            r_DN_EBUF_WR_REQ            <= s_ST_EBUF_REQ ;
            r_DN_LBUF_WR_REQ            <= r_DPK_TX_ACK  ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_EBUF_WR_DATA           <= 'b0 ;
        end else begin
            if (r_DN_FBUF_RD_REQ) begin
                r_DN_EBUF_WR_DATA       <= DN_FBUF_RD_DATA[95:80] ; //Buffer ID
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DMA_SIZE                  <= 'b0 ;
        end else begin
            if (r_DN_FBUF_RD_REQ) begin
                r_DMA_SIZE              <= DN_FBUF_RD_DATA[79:64] ; //buffer size
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DMA_ADDR                  <= 'b0 ;
        end else begin
            if (r_DN_FBUF_RD_REQ) begin
                r_DMA_ADDR              <= DN_FBUF_RD_DATA[63:0] ;  //address
            end else if (s_DPK_TX_H1) begin
                r_DMA_ADDR[63:7]        <= r_DMA_ADDR[63:7] + 1'b1 ; // 128 Byte
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DMA_H0                    <= 1'b0 ;
            r_DMA_H1                    <= 1'b0 ;
        end else begin
            if (r_DPK_TX_ACK) begin
                r_DMA_H0                <= 1'b1 ;
                r_DMA_H1                <= 1'b0 ;
            end else begin
                r_DMA_H0                <= ~ r_DMA_H0 ;
                r_DMA_H1                <= ~ r_DMA_H1 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DMA_DCNT                  <= 'b0 ;
        end else begin
            if (r_DPK_TX_ACK) begin
                r_DMA_DCNT              <= r_DMA_SIZE[14:7] ;
            end else if (r_DMA_H1 == 1'b1 && r_DMA_DCNT != 8'd0) begin
                r_DMA_DCNT              <= r_DMA_DCNT - 1'b1 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DMA_TX                    <= 1'b0 ;
        end else begin
            if (r_DPK_TX_ACK) begin
                r_DMA_TX                <= 1'b1 ;
            end else if (r_DMA_H1 == 1'b1 && r_DMA_DCNT == 8'd1) begin
                r_DMA_TX                <= 1'b0 ;
            end
        end
    end

    assign s_DPK_TX_H0                  = r_DMA_TX & r_DMA_H0 ;
    assign s_DPK_TX_H1                  = r_DMA_TX & r_DMA_H1 ;

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_RD64_FLAG                 <= 1'b0 ;
        end else begin
            r_RD64_FLAG                 <= | r_DMA_ADDR[63:32] ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DPK_TX_END                <= 1'b0 ;
        end else begin
            if (r_DMA_H1 == 1'b1 && r_DMA_DCNT == 8'd1) begin
                r_DPK_TX_END            <= 1'b1 ;
            end else begin
                r_DPK_TX_END            <= 1'b0 ;
            end
        end
    end

/*========================================================================+/
||                                                                        ||
||              Download request packet generate control                  ||
||                                                                        ||
/+========================================================================*/

    // UEK  RD_REQ  TAG = 0Y100XXX
    // UFK  WR_REQ  TAG = 0Y101XXX
    // DEK  WR_REQ  TAG = 0Y110XXX
    // DFK  RD_REQ  TAG = 0Y111XXX
    // UPK  WR_REQ  TAG = 0Y0XXXXX
    // DPK  RD_REQ  TAG = 1YXXXXXX

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_TAG_CNT                   <= 8'h00 ;
        end else begin
            r_TAG_CNT[7:6]              <= {1'b1,p_CH_ID} ;

            if (s_DPK_TX_H1 == 1'b1) begin
                r_TAG_CNT[5:0]          <= r_TAG_CNT[5:0] + 1'b1 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DPK_TX_DVLD                   <=  'b0 ;
            r_DPK_TX_SOP                    <=  'b0 ;
            r_DPK_TX_EOP                    <=  'b0 ;
            r_DPK_TX_MASK                   <=  'b0 ;
            r_DPK_TX_DATA                   <=  'b0 ;
        end else begin
            if (s_DPK_TX_H0 == 1'b1) begin
                r_DPK_TX_DVLD               <=  1'b1                    ;
                r_DPK_TX_SOP                <=  1'b1                    ;
                r_DPK_TX_EOP                <=  1'b0                    ;
                r_DPK_TX_MASK               <=  2'b11                   ;

                r_DPK_TX_DATA[63:32]        <=  {
                                                COMPLETER_ID            ,// |heard1| --packet head
                                                r_TAG_CNT               ,// |      | --packet head TAG
                                                {4'b1111}               ,// |      | --packet head Last BE
                                                {4'b1111}                // |      | --packet head Frist BE
                                                } ;

                r_DPK_TX_DATA[31:00]        <=  {
                                                {1'b0}                  ,// |heard0| --packet head R
                                                {1'b0}                  ,// |      | --packet head FMT*TYPE[6]
                                                r_RD64_FLAG             ,// |      | --packet head FMT*TYPE[5]
                                                {5'b0}                  ,// |      | --packet head FMT*TYPE[4:3]
                                                {1'b0}                  ,// |      | --packet head R
                                                {3'b0}                  ,// |      | --packet head TC
                                                {4'b0}                  ,// |      | --packet head R
                                                {1'b0}                  ,// |      | --packet head TC
                                                {1'b0}                  ,// |      | --packet head EP
                                                {2'b0}                  ,// |      | --packet head ATTR
                                                {2'b0}                  ,// |      | --packet head R
                                                {10'h20}                 // |      | --packet head payload length 128 byte = 32DW = 0x20 DW (Number in DW)
                                                } ;

            end else if (s_DPK_TX_H1 == 1'b1) begin
                r_DPK_TX_DVLD               <=  1'b1                    ;
                r_DPK_TX_SOP                <=  1'b0                    ;
                r_DPK_TX_EOP                <=  1'b1                    ;

                if (r_RD64_FLAG) begin
                    r_DPK_TX_MASK           <=  2'b11                   ;
                    r_DPK_TX_DATA[63:32]    <=  r_DMA_ADDR[31:00]       ; // |heard3| --address low 3 bit must be 0 with QWord address
                    r_DPK_TX_DATA[31:00]    <=  r_DMA_ADDR[63:32]       ; // |heard2| --address low 3 bit must be 0 with QWord address
                end else begin
                    r_DPK_TX_MASK           <=  2'b01                   ;
                    r_DPK_TX_DATA[63:32]    <=  32'd0                   ; // |Unused|
                    r_DPK_TX_DATA[31:00]    <=  r_DMA_ADDR[31:00]       ; // |heard2| --address low 3 bit must be 0 with QWord address
                end

            end else begin
                r_DPK_TX_DVLD               <=  'b0                     ;
                r_DPK_TX_SOP                <=  'b0                     ;
                r_DPK_TX_EOP                <=  'b0                     ;
                r_DPK_TX_MASK               <=  'b0                     ;
                r_DPK_TX_DATA               <=  'b0                     ;
            end
        end
    end

endmodule


/*
-- 64bit address :
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

-- 32bit address :
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
*/
