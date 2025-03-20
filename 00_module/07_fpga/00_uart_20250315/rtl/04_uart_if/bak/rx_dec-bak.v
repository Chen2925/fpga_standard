
`timescale 1ns/1ps

module RX_DEC (
    input                               USER_CLK                                ,// (i) [   1]
    input                               USER_RST                                ,// (i) [   1]

    // User Register Signal
    input                               UART_RX_BERR                            ,// (o) [   1]
    input                               UART_RX_VLD                             ,// (o) [   1]
    input      [   7:0]                 UART_RX_DAT                             ,// (o) [   8]

    // Frame Buffer read
    output                              REG_WR_REQ                              ,// (o) [   1]
    output      [  31:0]                REG_WR_DATA                             ,// (o) [  32]
    output                              REG_RD_REQ                              ,// (o) [   1]
    output      [  15:0]                REG_OP_ADDR                              // (o) [   8]
);

// =============================================================================
// Internal Parameter Declare
// =============================================================================

    parameter                           P_CRLF          = 16'h0D0A              ;

    parameter                           P_WR            = 8'h57                 ;
    parameter                           P_RD            = 8'h52                 ;
    parameter                           P_SPACE         = 8'h20                 ;

    parameter                           P_FSM_IDLE      = 7'b0000001            ;
    parameter                           P_FSM_SPACE1    = 7'b0000010            ;
    parameter                           P_FSM_ADDR      = 7'b0000100            ;
    parameter                           P_FSM_SPACE2    = 7'b0001000            ;
    parameter                           P_FSM_DATA      = 7'b0010000            ;
    parameter                           P_FSM_END       = 7'b0100000            ;
    parameter                           P_FSM_DONE      = 7'b1000000            ;

// =============================================================================
// Internal signals declaration
// =============================================================================

    reg         [  6:0]                 r_FSM                                   ;
    wire                                s_FSM_IDLE                              ;
    wire                                s_FSM_CMD                               ;
    wire                                s_FSM_SPACE1                            ;
    wire                                s_FSM_ADDR                              ;
    wire                                s_FSM_SPACE2                            ;
    wire                                s_FSM_DATA                              ;
    wire                                s_FSM_END                               ;
    wire                                s_FSM_DONE                              ;

    reg         [  7:0]                 r_RX_CMD                                ;
    wire                                s_RX_CMD                                ;
    wire                                s_RX_WR                                 ;
    wire                                s_RX_RD                                 ;
    reg                                 r_RX_WR                                 ;
    reg                                 r_RX_RD                                 ;
    wire                                s_RX_SPACE                              ;
    wire                                s_SPACE_ERR                             ;
    wire                                s_ASCII_VLD                             ;
    wire        [  7:0]                 s_ASCII                                 ;
    wire                                s_HEX_ERR                               ;
    wire                                s_HEX_VLD                               ;
    wire        [  3:0]                 s_HEX                                   ;
    reg         [ 15:0]                 r_RX_ADDR                               ;
    reg         [ 31:0]                 r_RX_DATA                               ;
    reg         [  3:0]                 r_RX_HEX_CNT                            ;
    wire                                s_RX_ADDR_END                           ;
    wire                                s_RX_DATA_END                           ;
    reg         [ 15:0]                 r_RX_END                                ;
    reg         [  3:0]                 r_RX_END_CNT                            ;
    wire                                s_RX_END                                ;
    wire                                s_RX_ERR                                ;

// =================================================================================================
// RTL Body
// =================================================================================================



/*==============================================================================+/
||                                                                              ||
||                                Output Ports                                  ||
||                                                                              ||
/+==============================================================================*/

    assign REG_WR_REQ                    = s_FSM_DONE & r_RX_WR             ;
    assign REG_WR_DATA                   = r_RX_DATA                        ;
    assign REG_RD_REQ                    = s_FSM_DONE & r_RX_RD             ;
    assign REG_OP_ADDR                   = r_RX_ADDR                        ;


/*==============================================================================+/
||                                                                              ||
||                              FSM                                             ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge USER_CLK or posedge USER_RST) begin
        if (USER_RST) begin
            r_FSM                       <= P_FSM_IDLE ;
        end else begin
            case (r_FSM)
                P_FSM_IDLE :
                    if (s_RX_CMD) begin
                        r_FSM           <= P_FSM_SPACE1;
                    end else begin
                        r_FSM           <= P_FSM_IDLE ;
                    end

                P_FSM_SPACE1:
                    if (s_RX_SPACE) begin
                        r_FSM           <= P_FSM_ADDR;
                    end else if (s_SPACE_ERR | UART_RX_BERR) begin
                        r_FSM           <= P_FSM_IDLE ;
                    end else begin
                        r_FSM           <= P_FSM_SPACE1 ;
                    end

                P_FSM_ADDR:
                    if (s_RX_ADDR_END & r_RX_WR) begin
                        r_FSM           <= P_FSM_SPACE2 ;
                    end else if (s_RX_ADDR_END & r_RX_RD) begin
                        r_FSM           <= P_FSM_END ;
                    end else if ( UART_RX_BERR) begin
                        r_FSM           <= P_FSM_IDLE ;
                    end else begin
                        r_FSM           <= P_FSM_ADDR ;
                    end

                P_FSM_SPACE2:
                    if (s_RX_SPACE) begin
                        r_FSM           <= P_FSM_DATA;
                    end else if (s_SPACE_ERR | UART_RX_BERR) begin
                        r_FSM           <= P_FSM_IDLE ;
                    end else begin
                        r_FSM           <= P_FSM_SPACE2 ;
                    end

                P_FSM_DATA :
                   if (s_RX_DATA_END) begin
                        r_FSM           <= P_FSM_END ;
                    end else if ( UART_RX_BERR) begin
                        r_FSM           <= P_FSM_IDLE ;
                    end else begin
                        r_FSM           <= P_FSM_DATA ;
                    end

                P_FSM_END:
                   if (s_RX_END ) begin
                        r_FSM           <= P_FSM_DONE ;
                    end else if (s_RX_ERR) begin
                        r_FSM           <= P_FSM_IDLE ;
                    end else begin
                        r_FSM           <= P_FSM_END ;
                    end

                P_FSM_DONE :
                        r_FSM           <= P_FSM_IDLE ;

                default :
                    r_FSM               <= P_FSM_IDLE ;
            endcase
        end
    end

    assign s_FSM_IDLE                   = r_FSM[0] ;
    assign s_FSM_SPACE1                 = r_FSM[1] ;
    assign s_FSM_ADDR                   = r_FSM[2] ;
    assign s_FSM_SPACE2                 = r_FSM[3] ;
    assign s_FSM_DATA                   = r_FSM[4] ;
    assign s_FSM_END                    = r_FSM[5] ;
    assign s_FSM_DONE                   = r_FSM[6] ;

/*==============================================================================+/
||                                                                              ||
||                              CMD                                             ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_RX_CMD                    <= 'b0 ;
        end else begin
            if (UART_RX_VLD) begin
                r_RX_CMD                <= UART_RX_DAT ;
            end
        end
    end

    assign s_RX_CMD                     = s_RX_WR | s_RX_RD;
    assign s_RX_WR                      = (r_RX_CMD == P_WR) & s_FSM_IDLE ;
    assign s_RX_RD                      = (r_RX_CMD == P_RD) & s_FSM_IDLE ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_RX_WR                     <= 'b0 ;
            r_RX_RD                     <= 'b0 ;
        end else begin
            if (s_RX_WR) begin
                r_RX_WR                 <= 1'b1 ;
            end else if (s_FSM_IDLE) begin
                r_RX_WR                 <= 1'b0 ;
        end

            if (s_RX_RD) begin
                r_RX_RD                 <= 1'b1 ;
            end else if (s_FSM_IDLE) begin
                r_RX_RD                 <= 1'b0 ;
            end
        end
    end

/*==============================================================================+/
||                                                                              ||
||                              SPACE                                           ||
||                                                                              ||
/+==============================================================================*/

    assign s_RX_SPACE                   = (UART_RX_DAT == P_SPACE) & (s_FSM_SPACE1 | s_FSM_SPACE2 ) & UART_RX_VLD ;
    assign s_SPACE_ERR                  = (UART_RX_DAT != P_SPACE) & (s_FSM_SPACE1 | s_FSM_SPACE2 ) & UART_RX_VLD ;

/*==============================================================================+/
||                                                                              ||
||                              ADDR & DATA                                     ||
||                                                                              ||
/+==============================================================================*/

    assign s_ASCII_VLD                  = UART_RX_VLD & (s_FSM_ADDR | s_FSM_DATA) ;
    assign s_ASCII                      = UART_RX_DAT ;

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_RX_ADDR                   <= 'b0 ;
        end else begin
            if(s_HEX_VLD & s_FSM_ADDR & (s_ASCII == 8'h7F))begin
                r_RX_ADDR               <= { 4'b0 , r_RX_ADDR[15:4] } ;
            end else if (s_HEX_VLD & s_FSM_ADDR ) begin
                r_RX_ADDR               <= { r_RX_ADDR[11:0] , s_HEX } ;
            end else begin
                r_RX_ADDR               <= r_RX_ADDR ;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_RX_DATA                   <= 'b0 ;
        end else begin
            if(s_HEX_VLD & s_FSM_DATA & (s_ASCII == 8'h7F))begin
                r_RX_DATA               <= { 4'b0 , r_RX_DATA[31:4]} ;
            end else if (s_HEX_VLD & s_FSM_DATA ) begin
                r_RX_DATA               <= { r_RX_DATA[27:0] , s_HEX } ;
            end else begin
                r_RX_DATA               <= r_RX_DATA ;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_RX_HEX_CNT               <= 'b0 ;
        end else begin
            if (s_FSM_ADDR | s_FSM_DATA) begin
                if(s_HEX_VLD & (s_ASCII == 8'h7F))begin
                    r_RX_HEX_CNT        <= r_RX_HEX_CNT - 1'b1 ;
                end else if (s_HEX_VLD) begin
                    r_RX_HEX_CNT        <= r_RX_HEX_CNT + 1'b1 ;
                end else begin
                    r_RX_HEX_CNT        <= r_RX_HEX_CNT ;
                end
            end else begin
                r_RX_HEX_CNT            <= 'b0 ;
            end
        end
    end

    assign s_RX_ADDR_END                = (r_RX_HEX_CNT == 4'h4) ;
    assign s_RX_DATA_END                = (r_RX_HEX_CNT == 4'h8) ;

/*==============================================================================+/
||                                                                              ||
||                              END                                            ||
||                                                                              ||
/+==============================================================================*/

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_RX_END                    <= 'b0 ;
        end else begin
            if (UART_RX_VLD & s_FSM_END ) begin
                r_RX_END                <= { r_RX_END[7:0] , UART_RX_DAT } ;
            end else begin
                r_RX_END                <= r_RX_END ;
            end
        end
    end

    always @(posedge USER_CLK or posedge USER_RST) begin
        if(USER_RST) begin
            r_RX_END_CNT                <= 'b0 ;
        end else begin
            if (s_FSM_END) begin
                if (UART_RX_VLD) begin
                    r_RX_END_CNT        <= r_RX_END_CNT + 1'b1;
                end else begin
                    r_RX_END_CNT        <= r_RX_END_CNT ;
                end
            end else begin
                r_RX_END_CNT            <= 'b0 ;
            end
        end
    end

    assign s_RX_END                     = (r_RX_END == P_CRLF) & (r_RX_END_CNT == 4'h2) ;
    assign s_RX_ERR                     = (r_RX_END != P_CRLF) & (r_RX_END_CNT == 4'h2) ;

/*==============================================================================+/
||                                                                              ||
||                              Ascii to HEX & CRC8                             ||
||                                                                              ||
/+==============================================================================*/
    ASCII2HEX U_ASCII2HEX (
        .USER_CLK                       ( USER_CLK              ),// (i) [   1]
        .USER_RST                       ( USER_RST              ),// (i) [   1]

        .ASCII_VLD                      ( s_ASCII_VLD           ),// (i) [   1]
        .ASCII                          ( s_ASCII               ),// (i) [   8]
        .HEX_VLD                        ( s_HEX_VLD             ),// (o) [   1]
        .HEX_ERR                        ( s_HEX_ERR             ),// (o) [   1]
        .HEX                            ( s_HEX                 ) // (o) [   4]
    );

endmodule
