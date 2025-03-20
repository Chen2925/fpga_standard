// =================================================================================================
// File Name        : I2C_SLAVE0_IF.v
// Module           : I2C_SLAVE0_IF
// Function         : I2C_SLAVE0_IF
// Type             : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level    Date         Coded by          Contents            Comp
//
// =================================================================================================
// End Revision
// =================================================================================================
`define SIM
`timescale 1ps / 1ps

module I2C_SLAVE0_IF (
    // Global signals
    input                               CLK                                     ,//(i)[  1] System clock  200M
    input                               RST                                     ,//(i)[  1] System reset
    // I2C interface
    input                               I2C_IF_SCL                              ,//(i)[  1] I2C clocl
`ifdef SIM
    input                               I2C_IF_SDA_IN                           ,//(i)[  1] I2C data in for sim
    output                              I2C_IF_SDA_OUT                          ,//(o)[  1] I2C data out for sim
    output                              I2C_IF_SDA_OE                           ,//(o)[  1]
`else
    inout                               I2C_IF_SDA                              ,//(io)[  1] I2C data
`endif

    output                              I2C_WR_EN                               ,//(o)[  1] I2C write enable
    output      [   7:0]                I2C_WR_DATA                             ,//(o)[  8] I2C write data
    output      [   7:0]                I2C_OP_ADDR                             ,//(o)[  8] I2C write address
    output                              I2C_RD_EN                               ,//(o)[  1] I2C read  enable
    input       [   7:0]                I2C_RD_DATA                             ,//(i)[  8] I2C read  data
    input                               I2C_RD_ACK                               //(i)[  1] I2C read  data ACK

    ) ;

// =============================================================================
// Prameter define
// =============================================================================

    parameter                           P_I2C_IDLE    = 10'b00_0000_0001        ;//(p)[ 10]
    parameter                           P_I2C_SLADR   = 10'b00_0000_0010        ;//(p)[ 10]
    parameter                           P_I2C_SLACK   = 10'b00_0000_0100        ;//(p)[ 10]
    parameter                           P_I2C_SUADR   = 10'b00_0000_1000        ;//(p)[ 10]
    parameter                           P_I2C_SUACK   = 10'b00_0001_0000        ;//(p)[ 10]
    parameter                           P_I2C_WDATA   = 10'b00_0010_0000        ;//(p)[ 10]
    parameter                           P_I2C_WACK    = 10'b00_0100_0000        ;//(p)[ 10]
    parameter                           P_I2C_RDATA   = 10'b00_1000_0000        ;//(p)[ 10]
    parameter                           P_I2C_RNACK   = 10'b01_0000_0000        ;//(p)[ 10]
    parameter                           P_I2C_STOP    = 10'b10_0000_0000        ;//(p)[ 10]

// =============================================================================
// Internal signal define
// =============================================================================

    wire                                s_I2C_IF_SDA_IN                         ;//(s)[  1] for sim
    reg         [   3:0]                r_I2C_SDA_OE                            ;//(r)[  1] for sim

    reg         [   3:0]                r_SDA_REG                               ;//(r)[  4]
    reg         [   3:0]                r_SCL_REG                               ;//(r)[  4]
    reg         [   3:0]                r_I2C_BIT_CNT                           ;//(r)[  4]
    reg                                 r_I2C_BIT_CNT_END                       ;//(r)[  1]
    wire                                s_SCL_POS                               ;//(r)[  1]
    wire                                s_SCL_NEG                               ;//(r)[  1]
    wire                                s_SDA_POS                               ;//(r)[  1]
    wire                                s_SDA_NEG                               ;//(r)[  1]
    wire                                s_I2C_START                             ;//(r)[  1]
    wire                                s_I2C_STOP                              ;//(r)[  1]
    reg         [   9:0]                r_I2C_FSM                               ;//(r)[ 10]

    reg                                 r_FSM_I2C_IDLE                          ;//(r)[  1]
    reg                                 r_FSM_I2C_SLADR                         ;//(r)[  1]
    reg                                 r_FSM_I2C_SLACK                         ;//(r)[  1]
    reg                                 r_FSM_I2C_SUADR                         ;//(r)[  1]
    reg                                 r_FSM_I2C_SUACK                         ;//(r)[  1]
    reg                                 r_FSM_I2C_WDATA                         ;//(r)[  1]
    reg                                 r_FSM_I2C_WACK                          ;//(r)[  1]
    reg                                 r_FSM_I2C_RDATA                         ;//(r)[  1]
    reg                                 r_FSM_I2C_RNACK                         ;//(r)[  1]
    reg                                 r_FSM_I2C_STOP                          ;//(r)[  1]

    reg         [   7:0]                r_I2C_WR_DATA                           ;//(r)[  8]
    reg         [   7:0]                r_I2C_RD_DATA                           ;//(r)[  8]
    reg         [   7:0]                r_I2C_SLV_ADDR                          ;//(r)[  8]
    reg         [   7:0]                r_I2C_OP_ADDR                           ;//(r)[  8]
    reg         [   1:0]                r_SCL_NEG_DLY                           ;//(r)[  2]
    reg                                 r_I2C_SDA_O                             ;//(r)[  1]
    reg                                 r_I2C_IO_T                              ;//(r)[  1]
    reg                                 r_I2C_IO_T_DFF0                         ;//(r)[  1]
    reg                                 r_I2C_IO_T_DFF1                         ;//(r)[  1]
    reg                                 r_I2C_IO_T_DFF2                         ;//(r)[  1]
    reg                                 r_I2C_SDA_O_DFF0                        ;//(r)[  1]
    reg                                 r_I2C_SDA_O_DFF1                        ;//(r)[  1]
    reg                                 r_I2C_SDA_O_DFF2                        ;//(r)[  1]
    reg                                 r_I2C_RD_EN                             ;//(r)[  1]
    reg                                 r_I2C_WR_EN                             ;//(r)[  1]

// =================================================================================================
// RTL Body
// =================================================================================================

/*=============================================================================+/
||                                                                             ||
||                              Output                                         ||
||                                                                             ||
/+=============================================================================*/

`ifdef SIM
    assign I2C_IF_SDA_OUT               = r_I2C_IO_T_DFF2 ? r_I2C_SDA_O_DFF2 : 1'bz ;   //for sim
    assign s_I2C_IF_SDA_IN              = r_I2C_IO_T_DFF2 ? 1'bz : I2C_IF_SDA_IN ;      //for sim
    assign I2C_IF_SDA_OE                = r_I2C_SDA_OE[3]                       ;       //for sim
`else
    assign I2C_IF_SDA                   = r_I2C_IO_T_DFF2 ? r_I2C_SDA_O_DFF2 : 1'bz ;
`endif

    assign I2C_WR_EN                    = r_I2C_WR_EN                           ;
    assign I2C_WR_DATA                  = r_I2C_WR_DATA                         ;
    assign I2C_OP_ADDR                  = r_I2C_OP_ADDR                         ;
    assign I2C_RD_EN                    = r_I2C_RD_EN                           ;

/*=============================================================================+/
||                                                                             ||
||                       I2C write/read FSM control                            ||
||                                                                             ||
/+=============================================================================*/

`ifdef SIM
     always @ (posedge CLK or posedge RST) begin
        if(RST) begin
            r_SDA_REG                   <= 4'd0 ;
        end else begin
            r_SDA_REG                   <= {r_SDA_REG[2:0],s_I2C_IF_SDA_IN}     ;
        end
    end
`else
     always @ (posedge CLK or posedge RST) begin
        if(RST) begin
            r_SDA_REG                   <= 4'd0 ;
        end else begin
            r_SDA_REG                   <= {r_SDA_REG[2:0],I2C_IF_SDA}          ;
        end
    end
`endif

    always @ (posedge CLK or posedge RST) begin
        if(RST) begin
            r_SCL_REG                   <= 4'd0 ;
        end else begin
            r_SCL_REG                   <= {r_SCL_REG[2:0],I2C_IF_SCL}          ;
        end
    end

    // 8 bits address/data counter
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            r_I2C_BIT_CNT               <= 'b0 ;
            r_I2C_BIT_CNT_END           <= 'b0 ;
        end else begin
            if (r_FSM_I2C_SLADR |  r_FSM_I2C_SUADR | r_FSM_I2C_WDATA | r_FSM_I2C_RDATA ) begin
                if (s_SCL_POS) begin
                    r_I2C_BIT_CNT <= r_I2C_BIT_CNT + 1'b1 ;
                end
            end else begin
                r_I2C_BIT_CNT           <= 4'b0 ;
            end

            r_I2C_BIT_CNT_END           <= r_I2C_BIT_CNT[3] ;
        end
    end

    assign s_SCL_POS                    = (~r_SCL_REG[3]) & (~r_SCL_REG[2]) & r_SCL_REG[1] & r_SCL_REG[0]   ;
    assign s_SCL_NEG                    = (~r_SCL_REG[0]) & (~r_SCL_REG[1]) & r_SCL_REG[2] & r_SCL_REG[3]   ;
    assign s_SDA_POS                    = (~r_SDA_REG[3]) & (~r_SDA_REG[2]) & r_SDA_REG[1] & r_SDA_REG[0]   ;
    assign s_SDA_NEG                    = (~r_SDA_REG[0]) & (~r_SDA_REG[1]) & r_SDA_REG[2] & r_SDA_REG[3]   ;
    assign s_I2C_START                  = s_SDA_NEG && I2C_IF_SCL;
    assign s_I2C_STOP                   = s_SDA_POS && I2C_IF_SCL;

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            r_I2C_FSM                   <= P_I2C_IDLE ;
        end else begin
            case (r_I2C_FSM)
                P_I2C_IDLE  :
                    if (s_I2C_START) begin
                        r_I2C_FSM       <= P_I2C_SLADR ;
                    end

                P_I2C_SLADR :
                    if ( r_I2C_BIT_CNT_END & s_SCL_NEG  ) begin
                        r_I2C_FSM       <= P_I2C_SLACK ;
                    end

                P_I2C_SLACK :
                    if( s_SCL_NEG & r_I2C_SLV_ADDR[0]) begin
                        r_I2C_FSM       <= P_I2C_RDATA ;
                    end else if( s_SCL_NEG ) begin
                        r_I2C_FSM       <= P_I2C_SUADR ;
                    end

                P_I2C_SUADR :
                    if (r_I2C_BIT_CNT_END & s_SCL_NEG) begin
                        r_I2C_FSM       <= P_I2C_SUACK ;
                    end

                P_I2C_SUACK :
                    if (s_SCL_NEG ) begin
                        r_I2C_FSM       <= P_I2C_WDATA ;
                    end

                P_I2C_WDATA :
                    if(s_I2C_STOP ) begin
                        r_I2C_FSM       <= P_I2C_IDLE ;
                    end else if (r_I2C_BIT_CNT_END & s_SCL_NEG) begin
                        r_I2C_FSM       <= P_I2C_WACK ;
                    end

                P_I2C_WACK  :
                    if( s_SCL_NEG ) begin
                        r_I2C_FSM       <= P_I2C_STOP ;
                    end

                P_I2C_RDATA :
                    if (r_I2C_BIT_CNT_END & s_SCL_NEG ) begin
                        r_I2C_FSM       <= P_I2C_RNACK ;
                    end

                P_I2C_RNACK  :
                    if (s_SCL_NEG ) begin
                        r_I2C_FSM       <= P_I2C_STOP ;
                    end

                P_I2C_STOP  :
                    if (s_I2C_STOP ) begin
                        r_I2C_FSM       <= P_I2C_IDLE ;
                    end

                default     :
                    r_I2C_FSM           <= P_I2C_IDLE ;
            endcase
        end
    end

    always @(posedge CLK) begin
        r_FSM_I2C_IDLE                  = r_I2C_FSM[0]                          ;
        r_FSM_I2C_SLADR                 = r_I2C_FSM[1]                          ;
        r_FSM_I2C_SLACK                 = r_I2C_FSM[2]                          ;
        r_FSM_I2C_SUADR                 = r_I2C_FSM[3]                          ;
        r_FSM_I2C_SUACK                 = r_I2C_FSM[4]                          ;
        r_FSM_I2C_WDATA                 = r_I2C_FSM[5]                          ;
        r_FSM_I2C_WACK                  = r_I2C_FSM[6]                          ;
        r_FSM_I2C_RDATA                 = r_I2C_FSM[7]                          ;
        r_FSM_I2C_RNACK                 = r_I2C_FSM[8]                          ;
        r_FSM_I2C_STOP                  = r_I2C_FSM[9]                          ;
    end
/*=============================================================================+/
||                                                                             ||
||                                I2C SDA control                              ||
||                                                                             ||
/+=============================================================================*/
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            r_I2C_WR_DATA               <= 'b0                                  ;
        end else begin
            if((r_FSM_I2C_WDATA) & s_SCL_POS) begin
                r_I2C_WR_DATA               <={r_I2C_WR_DATA[6:0] , r_SDA_REG[3] } ;
            end
        end
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            r_I2C_SLV_ADDR              <= 'b0                                  ;
        end else begin
            if((r_FSM_I2C_SLADR ) & s_SCL_POS) begin
                r_I2C_SLV_ADDR              <= {r_I2C_SLV_ADDR[6:0] , r_SDA_REG[3]} ;
            end
        end
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            r_I2C_OP_ADDR               <= 'b0                                  ;
        end else begin
            if((r_FSM_I2C_SUADR ) & s_SCL_POS) begin
                r_I2C_OP_ADDR               <= {r_I2C_OP_ADDR[6:0] , r_SDA_REG[3]} ;
            end
        end
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            r_I2C_RD_DATA               <= 'b0                                  ;
        end else begin
            if( I2C_RD_ACK ) begin
                r_I2C_RD_DATA               <= I2C_RD_DATA                      ;
            end else if((r_FSM_I2C_RDATA) & s_SCL_NEG) begin
                r_I2C_RD_DATA               <= {r_I2C_RD_DATA[6:0] , 1'b0 } ;
            end
        end
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            r_SCL_NEG_DLY               <= 2'b0                                 ;
        end else begin
            r_SCL_NEG_DLY               <= {r_SCL_NEG_DLY[0],s_SCL_NEG }        ;
        end
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            r_I2C_SDA_O                 <= 1'b1                                 ;
        end else begin
            if(r_FSM_I2C_SLACK | r_FSM_I2C_SUACK | r_FSM_I2C_WACK ) begin
                r_I2C_SDA_O                 <= 1'b0                             ;
            end else begin
                if((r_FSM_I2C_RDATA) & r_SCL_NEG_DLY[1]) begin
                    r_I2C_SDA_O                 <= r_I2C_RD_DATA[7]    ;
                end
            end
        end
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            r_I2C_IO_T                  <= 'b0 ;
            r_I2C_IO_T_DFF0             <= 'b0 ;
            r_I2C_IO_T_DFF1             <= 'b0 ;
            r_I2C_IO_T_DFF2             <= 'b0 ;

            r_I2C_SDA_O_DFF0            <= 'b0 ;
            r_I2C_SDA_O_DFF1            <= 'b0 ;
            r_I2C_SDA_O_DFF2            <= 'b0 ;
        end else begin
            r_I2C_IO_T                  <= r_FSM_I2C_SLACK | r_FSM_I2C_SUACK | r_FSM_I2C_WACK | r_FSM_I2C_RDATA ;
            r_I2C_IO_T_DFF0             <= r_I2C_IO_T       ;
            r_I2C_IO_T_DFF1             <= r_I2C_IO_T_DFF0  ;
            r_I2C_IO_T_DFF2             <= r_I2C_IO_T_DFF1  ;

            r_I2C_SDA_O_DFF0            <= r_I2C_SDA_O      ;
            r_I2C_SDA_O_DFF1            <= r_I2C_SDA_O_DFF0 ;
            r_I2C_SDA_O_DFF2            <= r_I2C_SDA_O_DFF1 ;

        end
    end

    always @(posedge CLK or posedge RST)begin
        if(RST)begin
            r_I2C_SDA_OE                <= 'b0 ;
        end else begin
            r_I2C_SDA_OE[0]             <= r_FSM_I2C_SLACK | r_FSM_I2C_SUACK | r_FSM_I2C_WACK | r_FSM_I2C_RDATA  ;
            r_I2C_SDA_OE[1]             <= r_I2C_SDA_OE[0] ;
            r_I2C_SDA_OE[2]             <= r_I2C_SDA_OE[1] ;
            r_I2C_SDA_OE[3]             <= r_I2C_SDA_OE[2] ;
        end
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            r_I2C_WR_EN                 <= 1'b0                                 ;
        end else begin
            if( (r_FSM_I2C_WACK)) begin
                if( ~r_I2C_SLV_ADDR[0] & s_SCL_NEG & (r_I2C_SLV_ADDR[7:1] == 7'h00)) begin
                    r_I2C_WR_EN         <= 1'b1                                 ;
                end else begin
                    r_I2C_WR_EN         <= 1'b0                                 ;
                end
            end else begin
                r_I2C_WR_EN             <= 1'b0                                 ;
            end
        end
    end

    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            r_I2C_RD_EN                 <= 1'b0                                 ;
        end else begin
            if(r_I2C_SLV_ADDR[0] & s_SCL_NEG & r_FSM_I2C_SLACK & (r_I2C_SLV_ADDR[7:1] == 7'h00)) begin
                r_I2C_RD_EN                 <= 1'b1                             ;
            end else begin
                r_I2C_RD_EN                 <= 1'b0                             ;
            end
        end
    end

endmodule