// =================================================================================================
// File Name      : pcie_up_dma.v
// Module         : PCIE_UP_DMA
// Function       : PCIE Upload dma module
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

module PCIE_UP_DMA # (
    parameter                           p_CH_ID        = 1'b0                    //(p)  [  2]
    )(
    //clock and reset
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
    //system signal
    input       [  15:0]                COMPLETER_ID                            ,//(i)  [ 16]
    //local buffer
    input                               UP_LBUF_RD_REQ                          ,//(i)  [  1] Local buffer read request
    output                              UP_LBUF_RD_ACK                          ,//(i)  [  1] Local buffer read acknowledge
    input       [   7:0]                UP_LBUF_RD_PSZ                          ,//(i)  [  8] Local buffer read package size
    input       [  15:0]                UP_LBUF_RD_BSZ                          ,//(i)  [ 16] Local buffer read burst size
    input       [  31:0]                UP_LBUF_RD_FSZ                          ,//(i)  [ 32] Local buffer read file size
    input       [  15:0]                UP_LBUF_RD_VCH                          ,//(i)  [ 16] Local buffer read channel
    input       [  63:0]                UP_LBUF_RD_DATA                         ,//(i)  [ 64] Local buffer read data
    input                               UP_LBUF_RD_DVLD                         ,//(i)  [  1] Locak buffer read data valid
    input                               UP_LBUF_RD_SOP                          ,//(i)  [  1] Locak buffer read start of package
    input                               UP_LBUF_RD_EOP                          ,//(i)  [  1] Locak buffer read end of package
    input                               UP_LBUF_RD_SOB                          ,//(i)  [  1] Locak buffer read start of buffer
    input                               UP_LBUF_RD_EOB                          ,//(i)  [  1] Locak buffer read end of buffer
    input                               UP_LBUF_RD_SOF                          ,//(i)  [  1] Locak buffer read start of file
    input                               UP_LBUF_RD_EOF                          ,//(i)  [  1] Locak buffer read end of file
    //upload buffer
    input                               UP_EBUF_RD_RDY                          ,//(i)  [  1]
    output                              UP_EBUF_RD_REQ                          ,//(o)  [  1]
    input       [  95:0]                UP_EBUF_RD_DATA                         ,//(i)  [ 96]
    output                              UP_FBUF_WR_INT                          ,//(o)  [  1]
    output                              UP_FBUF_WR_REQ                          ,//(o)  [  1]
    output      [ 127:0]                UP_FBUF_WR_DATA                         ,//(o)  [ 96]
     //pcie tx
    output                              UPK_TX_REQ                              ,//(o)  [  1]
    input                               UPK_TX_ACK                              ,//(i)  [  1]
    output                              UPK_TX_DVLD                             ,//(o)  [  1]
    output      [  63:0]                UPK_TX_DATA                             ,//(o)  [ 64]
    output      [   1:0]                UPK_TX_MASK                             ,//(o)  [  2]
    output                              UPK_TX_SOP                              ,//(o)  [  1]
    output                              UPK_TX_EOP                              ,//(o)  [  1]
    output                              UPK_TX_END                               //(o)  [  1]
    );

// =============================================================================
// Parameter Declare
// =============================================================================

    localparam                          p_MEM_RD32_FMT  = 7'b0000000            ;//(p)  [  7]
    localparam                          p_MEM_RD64_FMT  = 7'b0100000            ;//(p)  [  7]
    localparam                          p_MEM_WR32_FMT  = 7'b1000000            ;//(p)  [  7]
    localparam                          p_MEM_WR64_FMT  = 7'b1100000            ;//(p)  [  7]

    localparam                          p_IDLE          = 6'b000001             ;//(p)  [  6]
    localparam                          p_EBUF_CHK      = 6'b000010             ;//(p)  [  6]
    localparam                          p_EBUF_REQ      = 6'b000100             ;//(p)  [  6]
    localparam                          p_TX_REQ        = 6'b001000             ;//(p)  [  6]
    localparam                          p_TX_DATA       = 6'b010000             ;//(p)  [  6]
    localparam                          p_FBUF_REQ      = 6'b100000             ;//(p)  [  6]

// =============================================================================
// Internal Signal Declare
// =============================================================================

    reg         [   5:0]                r_FSM                                   ;//(r)  [  6]
    wire                                s_ST_EBUF_REQ                           ;//(s)  [  1]
    wire                                s_ST_TX_REQ                             ;//(s)  [  1]
    wire                                s_ST_FBUF_REQ                           ;//(s)  [  1]

    reg                                 r_UP_EBUF_RD_REQ                        ;//(r)  [  1]
    reg                                 r_UP_FBUF_WR_REQ                        ;//(r)  [  1]
    reg         [ 127:0]                r_UP_FBUF_WR_DATA                       ;//(r)  [ 96]
    reg                                 r_UP_LBUF_RD_ACK                        ;//(r)  [  1]
    reg                                 r_UP_FBUF_WR_INT                        ;//(r)  [  1]

    reg         [  15:0]                r_EBUF_ID                               ;//(r)  [ 16]
    reg         [  15:0]                r_EBUF_SIZE                             ;//(r)  [ 16]
    reg         [  63:0]                r_DMA_ADDR                              ;//(r)  [ 64]
    reg                                 r_WR64_FLAG                             ;//(r)  [  1]
    reg                                 r_FILE_SOF                              ;//(r)  [  1]
    reg                                 r_FILE_EOF                              ;//(r)  [  1]
    reg         [  31:0]                r_FILE_FSZ                              ;//(r)  [ 32]
    reg         [  15:0]                r_FILE_BSZ                              ;//(r)  [ 16]
    reg         [  15:0]                r_FILE_SID                              ;//(r)  [ 16]
    reg         [  15:0]                r_FILE_FID                              ;//(r)  [ 16]
    reg         [  15:0]                r_FILE_VCH                              ;//(r)  [ 16]

    reg         [  63:0]                r_UP_RD_DATA_2                          ;//(r)  [ 64]
    reg                                 r_UP_RD_DVLD_2                          ;//(r)  [  1]
    reg                                 r_UP_RD_SOP_2                           ;//(r)  [  1]
    reg                                 r_UP_RD_EOP_2                           ;//(r)  [  1]
    reg                                 r_UP_RD_EOB_2                           ;//(r)  [  1]

    reg         [  63:0]                r_UP_RD_DATA_1                          ;//(r)  [ 64]
    reg                                 r_UP_RD_DVLD_1                          ;//(r)  [  1]
    reg                                 r_UP_RD_SOP_1                           ;//(r)  [  1]
    reg                                 r_UP_RD_EOP_1                           ;//(r)  [  1]
    reg                                 r_UP_RD_EOB_1                           ;//(r)  [  1]

    reg         [   7:0]                r_TAG_CNT                               ;//(r)  [  8]

    reg                                 r_UPK_TX_END                            ;//(r)  [  1]
    reg                                 r_UPK_TX_REQ                            ;//(r)  [  1]
    reg                                 r_UPK_TX_SOP                            ;//(r)  [  1]
    reg                                 r_UPK_TX_EOP                            ;//(r)  [  1]
    reg         [  63:0]                r_UPK_TX_DATA                           ;//(r)  [ 64]
    reg                                 r_UPK_TX_DVLD                           ;//(r)  [  1]
    reg         [   1:0]                r_UPK_TX_MASK                           ;//(r)  [  2]

// =================================================================================================
// RTL Body
// =================================================================================================

/*============================================================================+/
||                                                                            ||
||                                  Output Ports                              ||
||                                                                            ||
/+============================================================================*/

     assign UP_LBUF_RD_ACK              = r_UP_LBUF_RD_ACK                      ;
     assign UP_EBUF_RD_REQ              = r_UP_EBUF_RD_REQ                      ;
     assign UP_FBUF_WR_INT              = r_UP_FBUF_WR_INT                      ;
     assign UP_FBUF_WR_REQ              = r_UP_FBUF_WR_REQ                      ;
     assign UP_FBUF_WR_DATA             = r_UP_FBUF_WR_DATA                     ;

     assign UPK_TX_REQ                  = r_UPK_TX_REQ                          ;
     assign UPK_TX_DVLD                 = r_UPK_TX_DVLD                         ;
     assign UPK_TX_DATA                 = r_UPK_TX_DATA                         ;
     assign UPK_TX_MASK                 = r_UPK_TX_MASK                         ;
     assign UPK_TX_SOP                  = r_UPK_TX_SOP                          ;
     assign UPK_TX_EOP                  = r_UPK_TX_EOP                          ;
     assign UPK_TX_END                  = r_UPK_TX_END                          ;

/*============================================================================+/
||                                                                            ||
||                             Upload DMA Control FSM                         ||
||                                                                            ||
/+============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_FSM                       <= p_IDLE ;
        end else begin
            case (r_FSM)
                p_IDLE :
                    begin
                        if (UP_LBUF_RD_REQ) begin
                            r_FSM       <= p_EBUF_CHK ;
                        end else begin
                            r_FSM       <= p_IDLE ;
                        end
                    end
                p_EBUF_CHK :
                    begin
                        if (UP_EBUF_RD_RDY) begin
                            r_FSM       <= p_EBUF_REQ ;
                        end else begin
                            r_FSM       <= p_EBUF_CHK ;
                        end
                    end
                p_EBUF_REQ :
                    begin
                        r_FSM           <= p_TX_REQ ;
                    end
                p_TX_REQ :
                    begin
                        if (UPK_TX_ACK) begin
                            r_FSM       <= p_TX_DATA ;
                        end else begin
                            r_FSM       <= p_TX_REQ ;
                        end
                    end
                p_TX_DATA :
                    begin
                        if (r_UPK_TX_END) begin
                            r_FSM       <= p_FBUF_REQ ;
                        end else begin
                            r_FSM       <= p_TX_DATA ;
                        end
                    end
                p_FBUF_REQ :
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

    assign  s_ST_EBUF_REQ               = r_FSM[2] ;
    assign  s_ST_TX_REQ                 = r_FSM[3] ;
    assign  s_ST_FBUF_REQ               = r_FSM[5] ;

/*============================================================================+/
||                                                                            ||
||                             Upload Address Control                         ||
||                                                                            ||
/+============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UPK_TX_REQ                <= 'b0 ;
            r_UP_EBUF_RD_REQ            <= 'b0 ;
            r_UP_FBUF_WR_REQ            <= 'b0 ;
        end else begin
            r_UPK_TX_REQ                <= s_ST_TX_REQ   ;
            r_UP_EBUF_RD_REQ            <= s_ST_EBUF_REQ ;
            r_UP_FBUF_WR_REQ            <= s_ST_FBUF_REQ ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_LBUF_RD_ACK            <= 'b0 ;
        end else begin
            r_UP_LBUF_RD_ACK            <= UPK_TX_ACK ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_EBUF_ID                   <= 'b0 ;
            r_EBUF_SIZE                 <= 'b0 ;
        end else begin
            if (r_UP_EBUF_RD_REQ) begin
                r_EBUF_ID               <=  UP_EBUF_RD_DATA[95:80] ;
                r_EBUF_SIZE             <=  UP_EBUF_RD_DATA[79:64] ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DMA_ADDR                  <= 64'd0 ;
        end else begin
            if (r_UP_EBUF_RD_REQ) begin
                r_DMA_ADDR              <= UP_EBUF_RD_DATA[63:0] ;
            end else if (r_UPK_TX_EOP) begin
                r_DMA_ADDR              <= r_DMA_ADDR + 8'd128 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_WR64_FLAG                 <= 1'b0 ;
        end else begin
            r_WR64_FLAG                 <= | r_DMA_ADDR[63:32] ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_FILE_BSZ                  <= 'b0 ;
            r_FILE_FSZ                  <= 'b0 ;
            r_FILE_VCH                  <= 'b0 ;
        end else begin
            if (r_UP_LBUF_RD_ACK) begin
                r_FILE_BSZ              <= UP_LBUF_RD_BSZ ;
                r_FILE_FSZ              <= UP_LBUF_RD_FSZ ;
                r_FILE_VCH              <= UP_LBUF_RD_VCH ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_FILE_SOF                  <= 'b0 ;
            r_FILE_EOF                  <= 'b0 ;
        end else begin
            if (UP_LBUF_RD_SOF) begin
                r_FILE_SOF              <= 1'b1 ;
            end else if (r_UP_FBUF_WR_REQ) begin
                r_FILE_SOF              <= 1'b0 ;
            end

            if (UP_LBUF_RD_EOF) begin
                r_FILE_EOF              <= 1'b1 ;
            end else if (r_UP_FBUF_WR_REQ) begin
                r_FILE_EOF              <= 1'b0 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_FILE_SID                  <= 'b0 ;
        end else begin
            if (r_UP_FBUF_WR_REQ) begin
                if (r_FILE_EOF) begin
                    r_FILE_SID          <= 'b0 ;
                end else begin
                    r_FILE_SID          <= r_FILE_SID + 1'b1 ;
                end
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_FILE_FID                  <= 'b0 ;
        end else begin
            if (r_UP_FBUF_WR_REQ & r_FILE_EOF) begin
                r_FILE_FID              <= r_FILE_FID + 1'b1 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_FBUF_WR_DATA            <= 'b0 ;
        end else begin
            if (s_ST_FBUF_REQ) begin
                r_UP_FBUF_WR_DATA        <= {
                                            r_FILE_SOF    ,// [127:127]  File start
                                            r_FILE_EOF    ,// [126:126]  File end
                                            6'd0          ,// [125:120]  All 0
                                            8'd0          ,// [119:112]  All 0
                                            r_EBUF_ID     ,// [111: 96]  Empty buffer ID
                                            r_FILE_VCH    ,// [ 95: 80]  Vritual channel ID
                                            r_FILE_BSZ    ,// [ 79: 64]  Buffer data size
                                            r_FILE_FSZ    ,// [ 63: 32]  File size
                                            r_FILE_FID    ,// [ 31: 16]  File ID
                                            r_FILE_SID     // [ 15: 00]  Section ID
                                            };
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_FBUF_WR_INT            <= 'b0 ;
        end else begin
            if (s_ST_FBUF_REQ & r_FILE_EOF) begin
                r_UP_FBUF_WR_INT        <= ~ r_UP_FBUF_WR_INT ;
            end
        end
    end

/*========================================================================+/
||                                                                        ||
||                       Upload Packet Transmit                           ||
||                                                                        ||
/+========================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_RD_DATA_1              <= 'b0 ;
            r_UP_RD_DVLD_1              <= 'b0 ;
            r_UP_RD_SOP_1               <= 'b0 ;
            r_UP_RD_SOP_1               <= 'b0 ;
            r_UP_RD_EOP_1               <= 'b0 ;
            r_UP_RD_EOB_1               <= 'b0 ;
        end else begin
            r_UP_RD_DATA_1[63:56]       <= UP_LBUF_RD_DATA[39:32] ;
            r_UP_RD_DATA_1[55:48]       <= UP_LBUF_RD_DATA[47:40] ;
            r_UP_RD_DATA_1[47:40]       <= UP_LBUF_RD_DATA[55:48] ;
            r_UP_RD_DATA_1[39:32]       <= UP_LBUF_RD_DATA[63:56] ;

            r_UP_RD_DATA_1[31:24]       <= UP_LBUF_RD_DATA[ 7: 0] ;
            r_UP_RD_DATA_1[23:16]       <= UP_LBUF_RD_DATA[15: 8] ;
            r_UP_RD_DATA_1[15: 8]       <= UP_LBUF_RD_DATA[23:16] ;
            r_UP_RD_DATA_1[ 7: 0]       <= UP_LBUF_RD_DATA[31:24] ;

            r_UP_RD_DVLD_1              <= UP_LBUF_RD_DVLD ;
            r_UP_RD_SOP_1               <= UP_LBUF_RD_SOP  ;
            r_UP_RD_EOP_1               <= UP_LBUF_RD_EOP  ;
            r_UP_RD_EOB_1               <= UP_LBUF_RD_EOB  ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UP_RD_DATA_2              <= 'b0 ;
            r_UP_RD_DVLD_2              <= 'b0 ;
            r_UP_RD_SOP_2               <= 'b0 ;
            r_UP_RD_EOP_2               <= 'b0 ;
            r_UP_RD_EOB_2               <= 'b0 ;
        end else begin
            r_UP_RD_DATA_2              <= r_UP_RD_DATA_1 ;
            r_UP_RD_DVLD_2              <= r_UP_RD_DVLD_1 ;
            r_UP_RD_SOP_2               <= r_UP_RD_SOP_1  ;
            r_UP_RD_EOP_2               <= r_UP_RD_EOP_1  ;
            r_UP_RD_EOB_2               <= r_UP_RD_EOB_1  ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UPK_TX_END                <= 'b0 ;
        end else begin
            r_UPK_TX_END                <= r_UP_RD_EOB_2 ;
        end
    end

    // UEK  RD_REQ  TAG = 0Y100XXX
    // UFK  WR_REQ  TAG = 0Y101XXX
    // DEK  WR_REQ  TAG = 0Y110XXX
    // DFK  RD_REQ  TAG = 0Y111XXX
    // UPK  WR_REQ  TAG = 0Y0XXXXX
    // DPK  RD_REQ  TAG = 1YXXXXXX

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_TAG_CNT                   <=  8'h00 ;
        end else begin
            r_TAG_CNT[7:5]              <=  {1'b0 , p_CH_ID , 1'b0} ;

            if (r_UPK_TX_SOP) begin
                r_TAG_CNT[4:0]          <= r_TAG_CNT[4:0] + 1'b1 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_UPK_TX_SOP                    <= 'b0  ;
            r_UPK_TX_EOP                    <= 'b0  ;
            r_UPK_TX_DATA                   <= 'b0  ;
            r_UPK_TX_DVLD                   <= 'b0  ;
            r_UPK_TX_MASK                   <= 'b0  ;
        end else begin
            if (UP_LBUF_RD_SOP) begin
                r_UPK_TX_DVLD               <= 1'b1                         ;
                r_UPK_TX_SOP                <= 1'b1                         ;
                r_UPK_TX_EOP                <= 1'b0                         ;
                r_UPK_TX_MASK               <= 2'b11                        ;

                r_UPK_TX_DATA[63:32]        <= {
                                               COMPLETER_ID                 ,   // |heard1| --packet head
                                               r_TAG_CNT                    ,   // |      | --packet head TAG
                                               {4'b1111}                    ,   // |      | --packet head Last BE
                                               {4'b1111}                        // |      | --packet head Frist BE
                                               };

                r_UPK_TX_DATA[31:0]         <= {
                                               {1'b0}                       ,   // |heard0| --packet head R
                                               {1'b1}                       ,   // |      | --packet head FMT*TYPE[6]
                                               r_WR64_FLAG                  ,   // |      | --packet head FMT*TYPE[5]
                                               {5'b0}                       ,   // |      | --packet head FMT*TYPE[4:0]
                                               {1'b0}                       ,   // |      | --packet head R
                                               {3'b0}                       ,   // |      | --packet head TC
                                               {4'b0}                       ,   // |      | --packet head R
                                               {1'b0}                       ,   // |      | --packet head TC
                                               {1'b0}                       ,   // |      | --packet head EP
                                               {2'b0}                       ,   // |      | --packet head ATTR
                                               {2'b0}                       ,   // |      | --packet head R
                                               {4'b0,UP_LBUF_RD_PSZ[7:2]}       // |      | --packet head payload length in DW
                                               };
            end else if (r_UP_RD_SOP_1) begin
                r_UPK_TX_DVLD               <= 1'b1                         ;
                r_UPK_TX_SOP                <= 1'b0                         ;
                r_UPK_TX_EOP                <= 1'b0                         ;
                r_UPK_TX_MASK               <= 2'b11                        ;

                if (r_WR64_FLAG) begin
                    r_UPK_TX_DATA[63:32]    <= r_DMA_ADDR[31:00]            ;   // |heard3| --address low 3 bit must be 0 with QWord address
                    r_UPK_TX_DATA[31:00]    <= r_DMA_ADDR[63:32]            ;   // |heard2| --address low 3 bit must be 0 with QWord address
                end else begin
                    r_UPK_TX_DATA[63:32]    <= r_UP_RD_DATA_1[31:00]        ;   // |Data 0|
                    r_UPK_TX_DATA[31:00]    <= r_DMA_ADDR[31:00]            ;   // |heard2| --address low 3 bit must be 0 with QWord address
                end

            end else if (r_UP_RD_EOP_2) begin
                r_UPK_TX_DVLD               <= 1'b1                         ;
                r_UPK_TX_SOP                <= 1'b0                         ;
                r_UPK_TX_EOP                <= 1'b1                         ;

                if (r_WR64_FLAG) begin
                    r_UPK_TX_MASK           <= 2'b11                        ;
                    r_UPK_TX_DATA[63:32]    <= r_UP_RD_DATA_2[63:32]        ;
                    r_UPK_TX_DATA[31:00]    <= r_UP_RD_DATA_2[31:00]        ;
                end else begin
                    r_UPK_TX_MASK           <= 2'b01                        ;
                    r_UPK_TX_DATA[63:32]    <= 32'd0                        ;
                    r_UPK_TX_DATA[31:00]    <= r_UP_RD_DATA_2[63:32]        ;
                end
            end else begin
                r_UPK_TX_DVLD               <= r_UP_RD_DVLD_2               ;
                r_UPK_TX_SOP                <= 1'b0                         ;
                r_UPK_TX_EOP                <= 1'b0                         ;
                r_UPK_TX_MASK               <= 2'b11                        ;

                if (r_WR64_FLAG) begin
                    r_UPK_TX_DATA[63:32]    <= r_UP_RD_DATA_2[63:32]        ;
                    r_UPK_TX_DATA[31:00]    <= r_UP_RD_DATA_2[31:00]        ;
                end else begin
                    r_UPK_TX_DATA[63:32]    <= r_UP_RD_DATA_1[31:00]        ;
                    r_UPK_TX_DATA[31:00]    <= r_UP_RD_DATA_2[63:32]        ;
                end
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
