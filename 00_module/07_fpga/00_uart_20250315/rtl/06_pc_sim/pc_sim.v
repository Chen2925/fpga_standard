// =================================================================================================
// File Name    : define.v
// Entity       : None
// =================================================================================================
// Function     : simulation define file
// -------------------------------------------------------------------------------------------------
// Updata History:
// -------------------------------------------------------------------------------------------------
// REV.Level    Date        Coded-by        Contents
// v0.1.0       2019/06/10  chen.y          Create New
// -------------------------------------------------------------------------------------------------
// End Revision
// =================================================================================================

module PC_SIM(
    input                               CLK                                     ,//(i)[  1]
    input                               RST                                     ,//(i)[  1]
    //reg bist
    input                               REG_WR_REQ                              ,//(i)[  1]
    output                              REG_WR_ACK                              ,//(o)[  1]
    input       [  31:0]                REG_WR_DATA                             ,//(i)[ 32]
    input                               REG_RD_REQ                              ,//(i)[  1]
    output                              REG_RD_ACK                              ,//(o)[  1]
    output      [  31:0]                REG_RD_DATA                             ,//(o)[ 32]
    input       [   9:0]                REG_OP_ADDR                             ,//(i)[ 10]
    //uart_if
    output                              UART_RX_ERR                             ,//(i)[   1]
    output                              UART_RX_DVLD                            ,//(i)[   1]
    output      [   7:0]                UART_RX_DATA                            ,//(i)[   8]
    input                               UART_TX_REQ                             ,//(o)[   1]
    output                              UART_TX_ACK                             ,//(i)[   1]
    input       [   7:0]                UART_TX_DATA                             //(o)[   8]
    );

// =============================================================================
// Prameter define
// =============================================================================

    parameter                           p_WR_FRAME_SIZE = 4'd12                 ;//(p)[  4]
    parameter                           p_WR_DATA_SIZE  = 8'd22                 ;//(p)[  4]
    parameter                           p_RD_FRAME_SIZE = 4'd4                  ;//(p)[  4]
    parameter                           p_RD_DATA_SIZE  = 8'd13                 ;//(p)[  4]

    parameter                           p_WR            = 48'h5245475F5752      ;//REG_WR
    parameter                           p_RD            = 48'h5245475F5244      ;//REG_RD
    parameter                           p_SPACE         = 8'h20                 ;
    parameter                           p_CRLF          = 16'h0D0A              ;

    parameter                           p_PC_WR_IDLE     = 7'b000_0001          ;//(p)[  7]
    parameter                           p_PC_WR_START    = 7'b000_0010          ;//(p)[  7]
    parameter                           p_PC_WR_CONV     = 7'b000_0100          ;//(p)[  7]
    parameter                           p_PC_WR_WAIT     = 7'b000_1000          ;//(p)[  7]
    parameter                           p_PC_WR_DATA_BUF = 7'b001_0000          ;//(p)[  7]
    parameter                           p_PC_WR_DATA_OUT = 7'b010_0000          ;//(p)[  7]
    parameter                           p_PC_WR_END      = 7'b100_0000          ;//(p)[  7]

    parameter                           p_PC_RD_IDLE     = 7'b000_0001          ;//(p)[  7]
    parameter                           p_PC_RD_START    = 7'b000_0010          ;//(p)[  7]
    parameter                           p_PC_RD_CONV     = 7'b000_0100          ;//(p)[  7]
    parameter                           p_PC_RD_WAIT     = 7'b000_1000          ;//(p)[  7]
    parameter                           p_PC_RD_DATA_BUF = 7'b001_0000          ;//(p)[  7]
    parameter                           p_PC_RD_DATA_OUT = 7'b010_0000          ;//(p)[  7]
    parameter                           p_PC_RD_END      = 7'b100_0000          ;//(p)[  7]

// =============================================================================
// Internal signal define
// =============================================================================

    reg         [   6:0]                r_PC_WR_FSM                             ;//(r)[  7]
    wire                                s_PC_WR_IDLE                            ;//(s)[  1]
    wire                                s_PC_WR_START                           ;//(s)[  1]
    wire                                s_PC_WR_CONV                            ;//(s)[  1]
    wire                                s_PC_WR_WAIT                            ;//(s)[  1]
    wire                                s_PC_WR_DATA_BUF                        ;//(s)[  1]
    wire                                s_PC_WR_DATA_OUT                        ;//(s)[  1]
    wire                                s_PC_WR_END                             ;//(s)[  1]

    reg         [   6:0]                r_PC_RD_FSM                             ;//(r)[  7]
    wire                                s_PC_RD_IDLE                            ;//(s)[  1]
    wire                                s_PC_RD_START                           ;//(s)[  1]
    wire                                s_PC_RD_CONV                            ;//(s)[  1]
    wire                                s_PC_RD_WAIT                            ;//(s)[  1]
    wire                                s_PC_RD_DATA_BUF                        ;//(s)[  1]
    wire                                s_PC_RD_DATA_OUT                        ;//(s)[  1]
    wire                                s_PC_RD_END                             ;//(s)[  1]

    reg         [  47:0]                r_WR_HEX                                ;//(r)[ 48]
    reg         [   3:0]                r_WR_CONV_CNT                           ;//(r)[  4]
    reg         [  15:0]                r_RD_HEX                                ;//(r)[ 16]
    reg         [   3:0]                r_RD_CONV_CNT                           ;//(r)[  4]
    wire                                s_HEX_DVLD                              ;//(s)[  1]
    wire        [   3:0]                s_HEX_DIN                               ;//(s)[  4]
    wire                                s_ASCII_DVLD                            ;//(s)[  1]
    wire        [   7:0]                s_ASCII_DOUT                            ;//(s)[  8]

    reg         [   3:0]                r_ASCII_CNT                             ;//(r)[  4]
    reg         [  95:0]                r_ASCII_DATA                            ;//(r)[ 96]
    reg         [   7:0]                r_WR_OUT_CNT                            ;//(r)[  8]
    reg         [   7:0]                r_RD_OUT_CNT                            ;//(r)[  8]
    reg         [ 175:0]                r_WR_ASCII_DATA                         ;//(r)[176]
    reg         [ 103:0]                r_RD_ASCII_DATA                         ;//(r)[104]

    reg         [   7:0]                r_UART_TX_REQ                           ;//(r)[  4]
    reg                                 r_ASCII_VLD                             ;//(r)[  1]
    wire                                s_HEX_VLD                               ;//(s)[  1]
    wire        [   3:0]                s_HEX                                   ;//(s)[  4]
    reg         [  31:0]                r_REG_RD_DATA                           ;//(r)[ 32]
    reg         [   3:0]                r_REG_RD_CNT                            ;//(r)[  4]
    reg                                 r_REG_RD_ACK                            ;//(r)[  1]

// =============================================================================
// output
// =============================================================================

    assign UART_RX_ERR                  = 1'b0                                  ;
    assign UART_RX_DVLD                 = s_PC_WR_DATA_OUT | s_PC_RD_DATA_OUT   ;
    assign UART_RX_DATA = s_PC_WR_DATA_OUT ? r_WR_ASCII_DATA[175:168] :
                          s_PC_RD_DATA_OUT ? r_RD_ASCII_DATA[103: 96] : 'b0     ;

    assign UART_TX_ACK                  = r_UART_TX_REQ[7]                      ;

    assign REG_RD_ACK                   = r_REG_RD_ACK                          ;
    assign REG_RD_DATA                  = r_REG_RD_DATA                         ;


// =============================================================================
//                     rtl body
// =============================================================================

/*=============================================================================+/
||                                                                             ||
||                                    PC_WR_FSM                                ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_PC_WR_FSM                 <= p_PC_WR_IDLE ;
        end else begin
            case(r_PC_WR_FSM)
            p_PC_WR_IDLE:
                if(REG_WR_REQ) begin
                    r_PC_WR_FSM         <= p_PC_WR_START ;
                end
            p_PC_WR_START:
                r_PC_WR_FSM             <= p_PC_WR_CONV ;
            p_PC_WR_CONV:
                if(r_WR_CONV_CNT == 4'h1)begin
                    r_PC_WR_FSM         <= p_PC_WR_WAIT ;
                end
            p_PC_WR_WAIT:
                if(r_ASCII_CNT == p_WR_FRAME_SIZE )begin
                    r_PC_WR_FSM         <= p_PC_WR_DATA_BUF ;
                end
            p_PC_WR_DATA_BUF:
                r_PC_WR_FSM             <= p_PC_WR_DATA_OUT ;
            p_PC_WR_DATA_OUT:
                if(r_WR_OUT_CNT == 8'h1 )begin
                    r_PC_WR_FSM         <= p_PC_WR_END ;
                end
            p_PC_WR_END:
                r_PC_WR_FSM             <= p_PC_WR_IDLE ;
            endcase
        end
    end

    assign s_PC_WR_IDLE                 = r_PC_WR_FSM[0]                        ;
    assign s_PC_WR_START                = r_PC_WR_FSM[1]                        ;
    assign s_PC_WR_CONV                 = r_PC_WR_FSM[2]                        ;
    assign s_PC_WR_WAIT                 = r_PC_WR_FSM[3]                        ;
    assign s_PC_WR_DATA_BUF             = r_PC_WR_FSM[4]                        ;
    assign s_PC_WR_DATA_OUT             = r_PC_WR_FSM[5]                        ;
    assign s_PC_WR_END                  = r_PC_WR_FSM[6]                        ;

/*=============================================================================+/
||                                                                             ||
||                                    PC_RD_FSM                                ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_PC_RD_FSM                 <= p_PC_RD_IDLE ;
        end else begin
            case(r_PC_RD_FSM)
            p_PC_RD_IDLE:
                if(REG_RD_REQ) begin
                    r_PC_RD_FSM         <= p_PC_RD_START ;
                end
            p_PC_RD_START:
                r_PC_RD_FSM             <= p_PC_RD_CONV ;
            p_PC_RD_CONV:
                if(r_RD_CONV_CNT == 8'h1 )begin
                    r_PC_RD_FSM         <= p_PC_RD_WAIT ;
                end
            p_PC_RD_WAIT:
                if(r_ASCII_CNT == p_RD_FRAME_SIZE )begin
                    r_PC_RD_FSM         <= p_PC_RD_DATA_BUF ;
                end
            p_PC_RD_DATA_BUF:
                r_PC_RD_FSM             <= p_PC_RD_DATA_OUT ;
            p_PC_RD_DATA_OUT:
                if(r_RD_OUT_CNT == 8'h1 )begin
                    r_PC_RD_FSM         <= p_PC_RD_END ;
                end
            p_PC_RD_END:
                r_PC_RD_FSM             <= p_PC_RD_IDLE ;
            endcase
        end
    end

    assign s_PC_RD_IDLE                 = r_PC_RD_FSM[0]                        ;
    assign s_PC_RD_START                = r_PC_RD_FSM[1]                        ;
    assign s_PC_RD_CONV                 = r_PC_RD_FSM[2]                        ;
    assign s_PC_RD_WAIT                 = r_PC_RD_FSM[3]                        ;
    assign s_PC_RD_DATA_BUF             = r_PC_RD_FSM[4]                        ;
    assign s_PC_RD_DATA_OUT             = r_PC_RD_FSM[5]                        ;
    assign s_PC_RD_END                  = r_PC_RD_FSM[6]                        ;

/*=============================================================================+/
||                                                                             ||
||                                    DATA CONV                                ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_WR_HEX                    <= 'b0 ;
        end else if(s_PC_WR_START) begin
            r_WR_HEX                    <= {REG_OP_ADDR,REG_WR_DATA} ;
        end else if(s_PC_WR_CONV) begin
            r_WR_HEX                    <= {r_WR_HEX[43:0],4'h0} ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_WR_CONV_CNT               <= p_WR_FRAME_SIZE ;
        end else if(s_PC_WR_CONV) begin
            r_WR_CONV_CNT               <= r_WR_CONV_CNT - 1 ;
        end else begin
            r_WR_CONV_CNT               <= p_WR_FRAME_SIZE ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_RD_HEX                    <= 'b0 ;
        end else if(s_PC_RD_START) begin
            r_RD_HEX                    <= REG_OP_ADDR;
        end else if(s_PC_RD_CONV) begin
            r_RD_HEX                    <= {r_RD_HEX[11:0],4'h0} ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_RD_CONV_CNT               <= p_RD_FRAME_SIZE ;
        end else if(s_PC_RD_CONV) begin
            r_RD_CONV_CNT               <= r_RD_CONV_CNT - 1 ;
        end else begin
            r_RD_CONV_CNT               <= p_RD_FRAME_SIZE ;
        end
    end

    assign s_HEX_DVLD                   = s_PC_RD_CONV | s_PC_WR_CONV ;
    assign s_HEX_DIN                    = s_PC_WR_CONV ? r_WR_HEX[47:44] :
                                          s_PC_RD_CONV ? r_RD_HEX[15:12] : 'b0 ;

    HEX2ASCII U_HEX2ASCII (
        .USER_CLK                       ( CLK                                   ),// (i) [   1]
        .USER_RST                       ( RST                                   ),// (i) [   1]

        .HEX_VLD                        ( s_HEX_DVLD                            ),// (i) [   1]
        .HEX                            ( s_HEX_DIN                             ),// (i) [   4]
        .ASCII_VLD                      ( s_ASCII_DVLD                          ),// (o) [   1]
        .ASCII                          ( s_ASCII_DOUT                          ) // (o) [   8]
    );

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_ASCII_CNT                 <= 'b0 ;
        end else if(s_ASCII_DVLD) begin
            r_ASCII_CNT                 <= r_ASCII_CNT + 1 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_ASCII_DATA             <= 'b0 ;
        end else if(s_ASCII_DVLD) begin
            r_ASCII_DATA             <= {r_ASCII_DATA[87:0],s_ASCII_DOUT} ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_RD_OUT_CNT                <= p_RD_DATA_SIZE ;
            r_WR_OUT_CNT                <= p_WR_DATA_SIZE ;
        end else if(s_PC_RD_DATA_OUT) begin
            r_RD_OUT_CNT                <= r_RD_OUT_CNT - 1 ;
        end else if(s_PC_WR_DATA_OUT) begin
            r_WR_OUT_CNT                <= r_WR_OUT_CNT - 1 ;
        end else begin
            r_RD_OUT_CNT                <= p_RD_DATA_SIZE ;
            r_WR_OUT_CNT                <= p_WR_DATA_SIZE ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_WR_ASCII_DATA             <= 'b0 ;
        end else if(s_PC_WR_DATA_BUF) begin
            r_WR_ASCII_DATA             <= {p_WR,p_SPACE,r_ASCII_DATA[95:64],p_SPACE,r_ASCII_DATA[63:0],p_CRLF};
        end else if(s_PC_WR_DATA_OUT) begin
            r_WR_ASCII_DATA             <= {r_WR_ASCII_DATA[167:0],8'b0} ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_RD_ASCII_DATA             <= 'b0 ;
        end else if(s_PC_RD_DATA_BUF) begin
            r_RD_ASCII_DATA             <= {p_RD,p_SPACE,r_ASCII_DATA[31:0],p_CRLF};
        end else if(s_PC_RD_DATA_OUT) begin
            r_RD_ASCII_DATA             <= {r_RD_ASCII_DATA[95:0],8'b0} ;
        end
    end

/*=============================================================================+/
||                                                                             ||
||                                    DATA CONV                                ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_UART_TX_REQ               <= 'b0 ;
        end else begin
            r_UART_TX_REQ               <= {r_UART_TX_REQ[6:0],UART_TX_REQ} ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_ASCII_VLD                 <= 1'b0 ;
        end else if(UART_TX_ACK) begin
            r_ASCII_VLD                 <= 1'b1 ;
        end else if(~UART_TX_REQ) begin
            r_ASCII_VLD                 <= 1'b0 ;
        end
    end

    ASCII2HEX U_ASCII2HEX (
        .USER_CLK                       ( CLK                   ),// (i) [   1]
        .USER_RST                       ( RST                   ),// (i) [   1]

        .ASCII_VLD                      ( UART_TX_REQ & r_ASCII_VLD  ),// (i) [   1]
        .ASCII                          ( UART_TX_DATA          ),// (i) [   8]
        .HEX_VLD                        ( s_HEX_VLD             ),// (o) [   1]
        .HEX_ERR                        (                       ),// (o) [   1]
        .HEX                            ( s_HEX                 ) // (o) [   4]
    );

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_REG_RD_DATA               <= 'b0 ;
        end else if(s_HEX_VLD & r_REG_RD_CNT <= 4'h7) begin
            r_REG_RD_DATA               <= {r_REG_RD_DATA[27:0],s_HEX} ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_REG_RD_CNT                <= 'b0 ;
        end else if(s_HEX_VLD) begin
            r_REG_RD_CNT                <= r_REG_RD_CNT + 1'b1 ;
        end else begin
            r_REG_RD_CNT                <= 'b0 ;
        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_REG_RD_ACK                <= 'b0 ;
        end else if(r_REG_RD_CNT == 4'h7) begin
            r_REG_RD_ACK                <= 1'b1 ;
        end else begin
            r_REG_RD_ACK                <= 'b0 ;
        end
    end

endmodule
