// =================================================================================================
// File Name      : pcie_dn_uek.v
// Module         : PCIE_DN_UEK
// Function       : DNload Empty buffer load module
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

module PCIE_DN_DEK # (
    parameter                           p_CH_ID        = 1'b0                    //(p)  [  2]
    )(
    //system
    input                               PCIE_CLK                                ,//(i)  [  1]
    input                               PCIE_RST                                ,//(i)  [  1]
    //register
    input       [  15:0]                COMPLETER_ID                            ,//(i)  [ 16]
    input                               DN_EBUF_WR_TRIG                         ,//(i)  [  1]
    input       [  63:0]                DN_EBUF_WR_ADDR                         ,//(i)  [ 64]
    input       [  23:0]                DN_EBUF_WR_SIZE                         ,//(i)  [ 24]
    //dma
    input                               DN_EBUF_WR_REQ                          ,//(i)  [  1]
    input       [  15:0]                DN_EBUF_WR_DATA                         ,//(i)  [ 16]
    //pcie tx
    output                              DEK_TX_REQ                              ,//(o)  [  1]
    input                               DEK_TX_ACK                              ,//(i)  [  1]
    output                              DEK_TX_DVLD                             ,//(o)  [  1]
    output      [  63:0]                DEK_TX_DATA                             ,//(o)  [ 64]
    output      [   1:0]                DEK_TX_MASK                             ,//(o)  [  2]
    output                              DEK_TX_SOP                              ,//(o)  [  1]
    output                              DEK_TX_EOP                               //(o)  [  1]
    );

// =============================================================================
// Parameter Declare
// =============================================================================

    localparam                          p_MEM_RD32_FMT  = 7'b0000000            ;//(p)  [  7]
    localparam                          p_MEM_WR32_FMT  = 7'b1000000            ;//(p)  [  7]
    localparam                          p_MEM_RD64_FMT  = 7'b0100000            ;//(p)  [  7]
    localparam                          p_MEM_WR64_FMT  = 7'b1100000            ;//(p)  [  7]

// =============================================================================
// Internal signal define
// =============================================================================

    reg         [  63:0]                r_DN_EBUF_WR_ADDR                       ;//(r)  [ 64]
    reg         [  23:0]                r_DN_EBUF_WR_SIZE                       ;//(r)  [ 24]
    reg         [  15:0]                r_DN_EBUF_WR_DATA                       ;//(r)  [ 16]
    reg                                 r_DN_EBUF_WR_REQ                        ;//(r)  [  1]

    reg         [  63:0]                r_DMA_ADDR                              ;//(r)  [ 64]
    reg                                 r_WR64_FLAG                             ;//(r)  [  1]
    reg         [  22:0]                r_OFT_ADDR                              ;//(r)  [ 21]
    reg         [ 127:0]                r_DMA_DATA                              ;//(r)  [128]

    wire        [  31:0]                s_DMA_DATA3                             ;//(s)  [ 32]
    wire        [  31:0]                s_DMA_DATA2                             ;//(s)  [ 32]
    wire        [  31:0]                s_DMA_DATA1                             ;//(s)  [ 32]
    wire        [  31:0]                s_DMA_DATA0                             ;//(s)  [ 32]
    wire        [  31:0]                s_DMA_DATA3_SWAP                        ;//(s)  [ 32]
    wire        [  31:0]                s_DMA_DATA2_SWAP                        ;//(s)  [ 32]
    wire        [  31:0]                s_DMA_DATA1_SWAP                        ;//(s)  [ 32]
    wire        [  31:0]                s_DMA_DATA0_SWAP                        ;//(s)  [ 32]

    reg                                 r_DEK_TX_ACK_DFF1                       ;//(r)  [  1]
    reg                                 r_DEK_TX_ACK_DFF2                       ;//(r)  [  1]
    reg                                 r_DEK_TX_ACK_DFF3                       ;//(r)  [  1]
    reg                                 r_DEK_TX_ACK_DFF4                       ;//(r)  [  1]

    reg                                 r_DEK_TX_REQ                            ;//(r)  [  1]
    reg                                 r_DEK_TX_DVLD                           ;//(r)  [  5]
    reg                                 r_DEK_TX_SOP                            ;//(r)  [  1]
    reg                                 r_DEK_TX_EOP                            ;//(r)  [  1]
    reg         [   1:0]                r_DEK_TX_MASK                           ;//(r)  [  2]
    reg         [  63:0]                r_DEK_TX_DATA                           ;//(r)  [ 64]

// ================================================================================================
// RTL Body
// ================================================================================================

/*============================================================================+/
||                                                                            ||
||                                Output Port                                 ||
||                                                                            ||
/+============================================================================*/

    assign  DEK_TX_REQ                  = r_DEK_TX_REQ                          ;
    assign  DEK_TX_DVLD                 = r_DEK_TX_DVLD                         ;
    assign  DEK_TX_DATA                 = r_DEK_TX_DATA                         ;
    assign  DEK_TX_MASK                 = r_DEK_TX_MASK                         ;
    assign  DEK_TX_SOP                  = r_DEK_TX_SOP                          ;
    assign  DEK_TX_EOP                  = r_DEK_TX_EOP                          ;

/*============================================================================+/
||                                                                            ||
||              Download request packet generate control                      ||
||                                                                            ||
/+============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_EBUF_WR_DATA           <= 'b0 ;
        end else begin
            if (DN_EBUF_WR_REQ) begin
                r_DN_EBUF_WR_DATA       <= DN_EBUF_WR_DATA ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_EBUF_WR_ADDR           <= 1'b0 ;
            r_DN_EBUF_WR_SIZE           <= 1'b0 ;
        end else begin
            if (DN_EBUF_WR_TRIG) begin
                r_DN_EBUF_WR_ADDR       <= DN_EBUF_WR_ADDR ;
                r_DN_EBUF_WR_SIZE       <= DN_EBUF_WR_SIZE ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DEK_TX_ACK_DFF1           <= 'b0 ;
            r_DEK_TX_ACK_DFF2           <= 'b0 ;
            r_DEK_TX_ACK_DFF3           <= 'b0 ;
            r_DEK_TX_ACK_DFF4           <= 'b0 ;
        end else begin
            r_DEK_TX_ACK_DFF1           <= DEK_TX_ACK           ;
            r_DEK_TX_ACK_DFF2           <= r_DEK_TX_ACK_DFF1    ;
            r_DEK_TX_ACK_DFF3           <= r_DEK_TX_ACK_DFF2    ;
            r_DEK_TX_ACK_DFF4           <= r_DEK_TX_ACK_DFF3    ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DN_EBUF_WR_REQ            <= 'b0 ;
        end else begin
            r_DN_EBUF_WR_REQ            <= DN_EBUF_WR_REQ ;
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DEK_TX_REQ                <= 'b0 ;
        end else begin
            if (r_DN_EBUF_WR_REQ) begin
                r_DEK_TX_REQ            <= 1'b1 ;
            end else if (r_DEK_TX_ACK_DFF1) begin
                r_DEK_TX_REQ            <= 1'b0 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_OFT_ADDR                  <= 23'd0 ;
        end else begin
            if (DN_EBUF_WR_TRIG) begin
                r_OFT_ADDR              <= 23'd0 ;
            end else if (r_DEK_TX_EOP) begin
                r_OFT_ADDR              <= r_OFT_ADDR + 9'd32 ;
            end
        end
    end

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DMA_ADDR                  <= 'b0 ;
        end else begin
            r_DMA_ADDR                  <= r_DN_EBUF_WR_ADDR + r_OFT_ADDR[21:0] ;
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
            r_DMA_DATA                  <= 128'd0 ;
        end else begin
            r_DMA_DATA                  <= {6'd0 , ~r_OFT_ADDR[22] , r_OFT_ADDR[22] , 8'd0 , r_DN_EBUF_WR_DATA[15:0] , 96'd0} ;
        end
    end

    assign  s_DMA_DATA3                 = r_DMA_DATA[127:96] ;
    assign  s_DMA_DATA2                 = r_DMA_DATA[95:64]  ;
    assign  s_DMA_DATA1                 = r_DMA_DATA[63:32]  ;
    assign  s_DMA_DATA0                 = r_DMA_DATA[31:00]  ;

    assign  s_DMA_DATA0_SWAP[31:24]     = s_DMA_DATA0[ 7: 0] ;
    assign  s_DMA_DATA0_SWAP[23:16]     = s_DMA_DATA0[15: 8] ;
    assign  s_DMA_DATA0_SWAP[15: 8]     = s_DMA_DATA0[23:16] ;
    assign  s_DMA_DATA0_SWAP[ 7: 0]     = s_DMA_DATA0[31:24] ;

    assign  s_DMA_DATA1_SWAP[31:24]     = s_DMA_DATA1[ 7: 0] ;
    assign  s_DMA_DATA1_SWAP[23:16]     = s_DMA_DATA1[15: 8] ;
    assign  s_DMA_DATA1_SWAP[15: 8]     = s_DMA_DATA1[23:16] ;
    assign  s_DMA_DATA1_SWAP[ 7: 0]     = s_DMA_DATA1[31:24] ;

    assign  s_DMA_DATA2_SWAP[31:24]     = s_DMA_DATA2[ 7: 0] ;
    assign  s_DMA_DATA2_SWAP[23:16]     = s_DMA_DATA2[15: 8] ;
    assign  s_DMA_DATA2_SWAP[15: 8]     = s_DMA_DATA2[23:16] ;
    assign  s_DMA_DATA2_SWAP[ 7: 0]     = s_DMA_DATA2[31:24] ;

    assign  s_DMA_DATA3_SWAP[31:24]     = s_DMA_DATA3[ 7: 0] ;
    assign  s_DMA_DATA3_SWAP[23:16]     = s_DMA_DATA3[15: 8] ;
    assign  s_DMA_DATA3_SWAP[15: 8]     = s_DMA_DATA3[23:16] ;
    assign  s_DMA_DATA3_SWAP[ 7: 0]     = s_DMA_DATA3[31:24] ;

/*============================================================================+/
||                                                                            ||
||              Download request packet generate control                      ||
||                                                                            ||
/+============================================================================*/

    // UEK  RD_REQ  TAG = 0Y100XXX
    // UFK  WR_REQ  TAG = 0Y101XXX
    // DEK  WR_REQ  TAG = 0Y110XXX
    // DFK  RD_REQ  TAG = 0Y111XXX
    // UPK  WR_REQ  TAG = 0Y0XXXXX
    // DPK  RD_REQ  TAG = 1YXXXXXX

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST) begin
            r_DEK_TX_DVLD                   <= 'b0      ;
            r_DEK_TX_SOP                    <= 'b0      ;
            r_DEK_TX_EOP                    <= 'b0      ;
            r_DEK_TX_MASK                   <= 'b0      ;
            r_DEK_TX_DATA                   <= 'b0      ;
        end else begin
            if (r_DEK_TX_ACK_DFF1) begin
                r_DEK_TX_DVLD               <= 1'b1     ;
                r_DEK_TX_SOP                <= 1'b1     ;
                r_DEK_TX_EOP                <= 1'b0     ;
                r_DEK_TX_MASK               <= 2'b11    ;

                r_DEK_TX_DATA[63:32]        <= {
                                               COMPLETER_ID             , // |heard1| --packet head
                                               {1'b0,p_CH_ID,6'b110000} , // |      | --packet head TAG
                                               {4'b1111}                , // |      | --packet head Last BE
                                               {4'b1111}                  // |      | --packet head Frist BE
                                               };

                r_DEK_TX_DATA[31:00]        <= {
                                               {1'b0}                   , // |heard0| --packet head R
                                               {1'b1}                   , // |      | --packet head FMT*TYPE[6]
                                               r_WR64_FLAG              , // |      | --packet head FMT*TYPE[5]
                                               {5'b0}                   , // |      | --packet head FMT*TYPE[4:3]
                                               {1'b0}                   , // |      | --packet head R
                                               {3'b0}                   , // |      | --packet head TC
                                               {4'b0}                   , // |      | --packet head R
                                               {1'b0}                   , // |      | --packet head TC
                                               {1'b0}                   , // |      | --packet head EP
                                               {2'b0}                   , // |      | --packet head ATTR
                                               {2'b0}                   , // |      | --packet head R
                                               {3'b0,7'b0000100}          // |      | --packet head payload length 16 byte = 4DW (Number in DW)
                                               };

            end else if (r_DEK_TX_ACK_DFF2) begin
                r_DEK_TX_DVLD               <= 1'b1  ;
                r_DEK_TX_SOP                <= 1'b0  ;
                r_DEK_TX_EOP                <= 1'b0  ;
                r_DEK_TX_MASK               <= 2'b11 ;

                if (r_WR64_FLAG) begin
                    r_DEK_TX_DATA[63:32]    <= r_DMA_ADDR[31:00]        ; // |heard3| --address low 3 bit must be 0 with QWord address
                    r_DEK_TX_DATA[31:00]    <= r_DMA_ADDR[63:32]        ; // |heard2| --address low 3 bit must be 0 with QWord address
                end else begin
                    r_DEK_TX_DATA[63:32]    <= s_DMA_DATA0_SWAP         ; // |Data 0|
                    r_DEK_TX_DATA[31:00]    <= r_DMA_ADDR[31:00]        ; // |heard2| --address low 3 bit must be 0 with QWord address
                end

            end else if (r_DEK_TX_ACK_DFF3) begin
                r_DEK_TX_DVLD               <= 1'b1                     ;
                r_DEK_TX_SOP                <= 1'b0                     ;
                r_DEK_TX_EOP                <= 1'b0                     ;
                r_DEK_TX_MASK               <= 2'b11                    ;

                if (r_WR64_FLAG) begin
                    r_DEK_TX_DATA[63:32]    <= s_DMA_DATA1_SWAP         ; // |Data 1|
                    r_DEK_TX_DATA[31:00]    <= s_DMA_DATA0_SWAP         ; // |Data 0|
                end else begin
                    r_DEK_TX_DATA[63:32]    <= s_DMA_DATA2_SWAP         ; // |Data 2|
                    r_DEK_TX_DATA[31:00]    <= s_DMA_DATA1_SWAP         ; // |Data 1|
                end

            end else if (r_DEK_TX_ACK_DFF4) begin
                r_DEK_TX_DVLD               <= 1'b1                     ;
                r_DEK_TX_SOP                <= 1'b0                     ;
                r_DEK_TX_EOP                <= 1'b1                     ;
                if (r_WR64_FLAG) begin
                    r_DEK_TX_MASK           <= 2'b11                    ;
                    r_DEK_TX_DATA[63:32]    <= s_DMA_DATA3_SWAP         ; // |Data 3|
                    r_DEK_TX_DATA[31:00]    <= s_DMA_DATA2_SWAP         ; // |Data 2|
                end else begin
                    r_DEK_TX_MASK           <= 2'b01                    ;
                    r_DEK_TX_DATA[63:32]    <= 32'd0                    ; // |Unused|
                    r_DEK_TX_DATA[31:00]    <= s_DMA_DATA3_SWAP         ; // |Data 3|
                end

            end else begin
                r_DEK_TX_DVLD               <= 'b0                      ;
                r_DEK_TX_SOP                <= 'b0                      ;
                r_DEK_TX_EOP                <= 'b0                      ;
                r_DEK_TX_MASK               <= 'b0                      ;
                r_DEK_TX_DATA               <= 'b0                      ;
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
