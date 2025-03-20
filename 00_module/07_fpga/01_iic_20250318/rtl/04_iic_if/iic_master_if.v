// =================================================================================================
// File Name        : I2C_MASTER_IF.v
// Module           : I2C_MASTER_IF
// Function         : I2C interface timing control
// Type             : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level    Date         Coded by          Contents
//
// =================================================================================================
// End Revision
// =================================================================================================
`define SIM
`timescale 1ps / 1ps

module I2C_MASTER_IF (
    // Global signals
    input                               SYS_CLK                                 ,//(i)[  1] System clock
    input                               SYS_RST                                 ,//(i)[  1] System reset
    // I2C interface
    output                              I2C_IF_SCL                              ,//(o)[  1] I2C clocl

`ifdef SIM
    input                               I2C_IF_SDA_IN                           ,//(i) [  1] I2C data in for sim
    output                              I2C_IF_SDA_OUT                          ,//(o) [  1] I2C data out for sim
`else
    inout                               I2C_IF_SDA                              ,//(io) [  1] I2C data
`endif

    // User interface
    input                               I2C_WR_EN                               ,//(i)[  1] I2C write enable
    input       [ 7:0]                  I2C_WR_DATA                             ,//(i)[  8] I2C write data
    output                              I2C_WR_ACK                              ,//(o)[  1] I2C Write ack
    input                               I2C_RD_EN                               ,//(i)[  1] I2C read enable
    output                              I2C_RD_ACK                              ,//(o)[  1] I2C read ack
    output      [ 7:0]                  I2C_RD_DATA                             ,//(o)[  8] I2C read data

    input       [ 7:0]                  I2C_SLV_ADDR                            ,//(i)[  8] I2C slaver address
    input       [ 7:0]                  I2C_SUB_ADDR                            ,//(i)[  8] I2C sub address
    output                              I2C_ACK_ERR                             ,//(o)[  1] I2C access error
    output                              I2C_BUSY                                 //(o)[  1] I2C access busy
    ) ;

// =============================================================================
// Prameter define
// =============================================================================

//  parameter                           P_SCL_HOLDT = 16'd1250                  ;//(p)[  1] I2C clock hold time *SYS_CLK
    parameter                           P_SCL_HOLDT = 16'd50                    ;//(p)[  1] I2C clock hold time *SYS_CLK SIM

    parameter                           P_I2C_IDLE  = 12'b0000_0000_0001        ;//(p)[ 12] Idle
    parameter                           P_I2C_START = 12'b0000_0000_0010        ;//(p)[ 12] I2C start
    parameter                           P_I2C_SLADR = 12'b0000_0000_0100        ;//(p)[ 12] I2C slaver address
    parameter                           P_I2C_SLACK = 12'b0000_0000_1000        ;//(p)[ 12] I2C slaver address ack
    parameter                           P_I2C_SUADR = 12'b0000_0001_0000        ;//(p)[ 12] I2C sub address
    parameter                           P_I2C_SUACK = 12'b0000_0010_0000        ;//(p)[ 12] I2C sub address ack
    parameter                           P_I2C_WDATA = 12'b0000_0100_0000        ;//(p)[ 12] I2C write data
    parameter                           P_I2C_WACK  = 12'b0000_1000_0000        ;//(p)[ 12] I2C write data ack
    parameter                           P_I2C_RDATA = 12'b0001_0000_0000        ;//(p)[ 12] I2C read data
    parameter                           P_I2C_RACK  = 12'b0010_0000_0000        ;//(p)[ 12] I2C read data ack
    parameter                           P_I2C_STOP  = 12'b0100_0000_0000        ;//(p)[ 12] I2C access stop
    parameter                           P_I2C_WAIT  = 12'b1000_0000_0000        ;//(p)[ 12] I2C access error

// =============================================================================
// Internal signal define
// =============================================================================

    reg         [11:0]                  r_I2C_FSM                               ;//(r)[ 12]
    reg                                 r_I2C_START                             ;//(r)[  1]
    reg                                 r_FSM_I2C_IDLE                          ;//(r)[  1]
    reg                                 r_FSM_I2C_START                         ;//(r)[  1]
    reg                                 r_FSM_I2C_SLADR                         ;//(r)[  1]
    reg                                 r_FSM_I2C_SLACK                         ;//(r)[  1]
    reg                                 r_FSM_I2C_SUADR                         ;//(r)[  1]
    reg                                 r_FSM_I2C_SUACK                         ;//(r)[  1]
    reg                                 r_FSM_I2C_WDATA                         ;//(r)[  1]
    reg                                 r_FSM_I2C_WACK                          ;//(r)[  1]
    reg                                 r_FSM_I2C_RDATA                         ;//(r)[  1]
    reg                                 r_FSM_I2C_RACK                          ;//(r)[  1]
    reg                                 r_FSM_I2C_STOP                          ;//(r)[  1]
    reg                                 r_FSM_I2C_WAIT                          ;//(r)[  1]

    reg                                 r_WR_FLAG                               ;//(r)[  1]
    reg                                 r_RD_FLAG                               ;//(r)[  1]

    reg         [15:0]                  r_SCL_HOLDT_CNT                         ;//(r)[ 16]
    wire                                s_SCL_HALF_CYCLE                        ;//(s)[  1]
    reg                                 r_SCL_QUAT_CYCLE                        ;//(r)[  1]
    reg                                 r_SCL_CYCLE                             ;//(r)[  1]
    reg                                 r_SCL_CYCLE_FF                          ;//(r)[  1]
    reg                                 r_CYCLE_FLAG                            ;//(r)[  1]
    reg                                 r_I2C_SCL                               ;//(r)[  1]
    reg                                 r_I2C_SCL_OFF0                          ;//(r)[  1]
    reg                                 r_I2C_SCL_OFF1                          ;//(r)[  1]
    reg                                 r_I2C_SCL_OFF2                          ;//(r)[  1]

    reg                                 r_RE_START                              ;//(r)[  1]
    reg                                 r_SAD_START                             ;//(r)[  1]

    reg         [ 7:0]                  r_SLV_ADDR                              ;//(r)[  8]
    reg         [ 7:0]                  r_SLV_ADDR2                             ;//(r)[  8]
    reg         [ 7:0]                  r_SUB_ADDR                              ;//(r)[  8]
    reg         [ 7:0]                  r_WR_DATA                               ;//(r)[  8]
    reg                                 r_WR_ACK                                ;//(r)[  1]

    reg                                 r_I2C_SDA_O                             ;//(r)[  1]
    reg                                 r_I2C_SDA_O_DFF0                        ;//(r)[  1]
    reg                                 r_I2C_SDA_O_DFF1                        ;//(r)[  1]
    reg                                 r_I2C_SDA_O_DFF2                        ;//(r)[  1]
    reg                                 r_I2C_SDA_I_DFF0                        ;//(r)[  1]
    reg                                 r_I2C_SDA_I_DFF1                        ;//(r)[  1]
    reg                                 r_I2C_SDA_I_DFF2                        ;//(r)[  1]

    reg         [ 3:0]                  r_I2C_BIT_CNT                           ;//(r)[  4]
    reg                                 r_I2C_BIT_CNT_END                       ;//(r)[  1]
    reg         [ 7:0]                  r_I2C_RX_SHIFT                          ;//(r)[  8]

    reg         [ 7:0]                  r_RD_DATA                               ;//(r)[  8]
    reg                                 r_RD_ACK                                ;//(r)[  1]

    reg                                 r_I2C_IO_T                              ;//(r)[  1]
    reg                                 r_I2C_IO_T_DFF0                         ;//(r)[  1]
    reg                                 r_I2C_IO_T_DFF1                         ;//(r)[  1]
    reg                                 r_I2C_IO_T_DFF2                         ;//(r)[  1]
    reg                                 r_I2C_ACK_ERR                           ;//(r)[  1]
    reg                                 r_I2C_BUSY                              ;//(r)[  1]

    wire                                s_I2C_IF_SDA_IN                         ;//(s)[  1]

// =================================================================================================
// RTL Body
// =================================================================================================

/*=============================================================================+/
||                                                                             ||
||                              Output                                         ||
||                                                                             ||
/+=============================================================================*/

    assign I2C_WR_ACK                   = r_WR_ACK                              ;
    assign I2C_RD_ACK                   = r_RD_ACK                              ;
    assign I2C_RD_DATA                  = r_RD_DATA                             ;

    assign I2C_IF_SCL                   = r_I2C_SCL_OFF2                        ;
`ifdef SIM
    assign I2C_IF_SDA_OUT               = r_I2C_IO_T_DFF2 ? 1'bz : r_I2C_SDA_O_DFF2 ; //SIM OUT
    assign s_I2C_IF_SDA_IN              = r_I2C_IO_T_DFF2 ? I2C_IF_SDA_IN: 1'bz     ; //SIM IN
`else
    assign I2C_IF_SDA                   = r_I2C_IO_T_DFF2 ? 1'bz : r_I2C_SDA_O_DFF2 ; //SIM OUT
`endif

    assign I2C_ACK_ERR                  = r_I2C_ACK_ERR                         ;
    assign I2C_BUSY                     = r_I2C_BUSY                            ;

/*=============================================================================+/
||                                                                             ||
||                       I2C write/read FSM control                            ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_I2C_START                 <= 1'b0 ;
        end else begin
            r_I2C_START                 <= I2C_WR_EN | I2C_RD_EN ;
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_WR_FLAG                   <= 1'b0 ;
        end else begin
            if (I2C_WR_EN) begin
                r_WR_FLAG               <= 1'b1 ;
            end else if (r_FSM_I2C_WAIT & r_SCL_CYCLE) begin
                r_WR_FLAG               <= 1'b0 ;
            end
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_RD_FLAG                   <= 1'b0 ;
        end else begin
            if (I2C_RD_EN) begin
                r_RD_FLAG               <= 1'b1 ;
            end else if (r_FSM_I2C_WAIT & r_SCL_CYCLE) begin
                r_RD_FLAG               <= 1'b0 ;
            end
        end
    end

    // FSM control
    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_I2C_FSM                   <= P_I2C_IDLE ;
        end else begin
            case (r_I2C_FSM)
                P_I2C_IDLE  :
                    if (r_I2C_START) begin
                        r_I2C_FSM       <= P_I2C_START ;
                    end

                P_I2C_START :
                    if (r_SCL_CYCLE) begin
                        r_I2C_FSM        <= P_I2C_SLADR ;
                    end

                P_I2C_SLADR :
                    if (r_I2C_BIT_CNT_END & r_SCL_CYCLE) begin
                        r_I2C_FSM       <= P_I2C_SLACK ;
                    end

                P_I2C_SLACK :
                    if (r_RE_START & r_SCL_CYCLE) begin
                        r_I2C_FSM       <= P_I2C_RDATA ;
                    end else if (r_SCL_CYCLE) begin
                        r_I2C_FSM       <= P_I2C_SUADR ;
                    end

                P_I2C_SUADR :
                    if (r_I2C_BIT_CNT_END & r_SCL_CYCLE) begin
                        r_I2C_FSM       <= P_I2C_SUACK ;
                    end

                P_I2C_SUACK :
                    if (r_SCL_CYCLE & r_WR_FLAG) begin
                        r_I2C_FSM       <= P_I2C_WDATA ;
                    end else if (r_SCL_CYCLE & r_RD_FLAG) begin
                        r_I2C_FSM       <= P_I2C_STOP ;
                    end

                P_I2C_WDATA :
                    if (r_I2C_BIT_CNT_END & r_SCL_CYCLE) begin
                        r_I2C_FSM       <= P_I2C_WACK ;
                    end

                P_I2C_WACK  :
                    if (r_SCL_CYCLE) begin
                        r_I2C_FSM       <= P_I2C_STOP ;
                    end

                P_I2C_RDATA :
                    if (r_I2C_BIT_CNT_END & r_SCL_CYCLE) begin
                        r_I2C_FSM       <= P_I2C_RACK ;
                    end

                P_I2C_RACK  :
                    if (r_SCL_CYCLE) begin
                        r_I2C_FSM       <= P_I2C_STOP ;
                    end

                P_I2C_STOP  :
                    if (r_SCL_CYCLE) begin
                        r_I2C_FSM       <= P_I2C_WAIT ;
                    end

                P_I2C_WAIT  :
                    if (r_SCL_CYCLE & r_RD_FLAG) begin
                        r_I2C_FSM       <= P_I2C_START ;
                    end else if (r_SCL_CYCLE) begin
                        r_I2C_FSM       <= P_I2C_IDLE ;
                    end

                default     :
                    r_I2C_FSM           <= P_I2C_IDLE ;
            endcase
        end
    end

    always @(posedge SYS_CLK) begin
        r_FSM_I2C_IDLE                  = r_I2C_FSM[0] ;
        r_FSM_I2C_START                 = r_I2C_FSM[1] ;
        r_FSM_I2C_SLADR                 = r_I2C_FSM[2] ;
        r_FSM_I2C_SLACK                 = r_I2C_FSM[3] ;
        r_FSM_I2C_SUADR                 = r_I2C_FSM[4] ;
        r_FSM_I2C_SUACK                 = r_I2C_FSM[5] ;
        r_FSM_I2C_WDATA                 = r_I2C_FSM[6] ;
        r_FSM_I2C_WACK                  = r_I2C_FSM[7] ;
        r_FSM_I2C_RDATA                 = r_I2C_FSM[8] ;
        r_FSM_I2C_RACK                  = r_I2C_FSM[9] ;
        r_FSM_I2C_STOP                  = r_I2C_FSM[10] ;
        r_FSM_I2C_WAIT                  = r_I2C_FSM[11] ;
    end

/*=============================================================================+/
||                                                                             ||
||                                 I2C SCL control                             ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_RE_START                  <= 1'b0 ;
        end else begin
            if (r_FSM_I2C_SUACK & r_SCL_CYCLE & r_RD_FLAG) begin
                r_RE_START              <= 1'b1 ;
            end else if (r_RD_ACK) begin
                r_RE_START              <= 1'b0 ;
            end
        end
    end

    // I2C clock hold time count
    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SCL_HOLDT_CNT             <= 'b0 ;
        end else begin
            if (r_FSM_I2C_IDLE) begin
                r_SCL_HOLDT_CNT         <= 16'b0 ;
            end else if (s_SCL_HALF_CYCLE) begin
                r_SCL_HOLDT_CNT         <= 16'b0 ;
            end else begin
                r_SCL_HOLDT_CNT         <= r_SCL_HOLDT_CNT + 1'b1 ;
            end
        end
    end

    assign s_SCL_HALF_CYCLE             = (r_SCL_HOLDT_CNT == P_SCL_HOLDT - 1 ) ? 1'b1 : 1'b0 ;

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SCL_QUAT_CYCLE            <= 'b0 ;
        end else begin
            if (r_SCL_HOLDT_CNT == P_SCL_HOLDT/2 - 1) begin
                r_SCL_QUAT_CYCLE        <= 'b1 ;
            end else begin
                r_SCL_QUAT_CYCLE        <= 'b0 ;
            end
        end
    end

    // SCL control
    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_CYCLE_FLAG                <= 1'b0 ;
        end else begin
            if (s_SCL_HALF_CYCLE) begin
                r_CYCLE_FLAG            <= ~r_CYCLE_FLAG ;
            end
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_I2C_SCL                   <= 1'b1 ;
        end else begin
            if (r_FSM_I2C_START) begin
                if (r_SCL_CYCLE) begin
                    r_I2C_SCL           <= 1'b0 ;
                end else if (s_SCL_HALF_CYCLE) begin
                    r_I2C_SCL           <= 1'b1 ;
                end
            end else if (r_FSM_I2C_STOP & s_SCL_HALF_CYCLE) begin
                r_I2C_SCL               <= 1'b1 ;
            end else if (r_FSM_I2C_WAIT) begin
                r_I2C_SCL               <= 1'b1 ;
            end else if (s_SCL_HALF_CYCLE) begin
                r_I2C_SCL               <= ~r_I2C_SCL ;
            end
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SCL_CYCLE                 <= 'b0 ;
            r_SCL_CYCLE_FF              <= 'b0 ;
        end else begin
            r_SCL_CYCLE                 <= s_SCL_HALF_CYCLE & r_CYCLE_FLAG ;
            r_SCL_CYCLE_FF              <= r_SCL_CYCLE ;
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SAD_START                 <= 1'b0 ;
        end else begin
            if ( r_SCL_QUAT_CYCLE ) begin
                r_SAD_START             <= r_CYCLE_FLAG & r_FSM_I2C_START ;
            end else begin
                r_SAD_START             <= 1'b0 ;
            end
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_I2C_SCL_OFF0              <= 1'b1 ;
            r_I2C_SCL_OFF1              <= 1'b1 ;
            r_I2C_SCL_OFF2              <= 1'b1 ;
        end else begin
            if (~r_I2C_SCL) begin
                r_I2C_SCL_OFF0          <= 1'b0 ;
            end else begin
                r_I2C_SCL_OFF0          <= 1'b1 ;
            end

            r_I2C_SCL_OFF1              <= r_I2C_SCL_OFF0 ;
            r_I2C_SCL_OFF2              <= r_I2C_SCL_OFF1 ;
        end
    end

/*=============================================================================+/
||                                                                             ||
||                                I2C SDA control                              ||
||                                                                             ||
/+=============================================================================*/

    // Address and write data latch
    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SLV_ADDR                  <= 8'b0 ;
            r_SLV_ADDR2                 <= 8'b0 ;
        end else begin
            if (I2C_WR_EN) begin
                r_SLV_ADDR              <= I2C_SLV_ADDR ;
                r_SLV_ADDR2             <= I2C_SLV_ADDR ;
            end else if (I2C_RD_EN) begin
                r_SLV_ADDR              <= I2C_SLV_ADDR ;
                r_SLV_ADDR2             <= {I2C_SLV_ADDR[7:1],1'b1} ;
            end else if (r_FSM_I2C_SUACK) begin
                r_SLV_ADDR              <= r_SLV_ADDR2 ;
            end else if (r_FSM_I2C_SLADR & r_SCL_CYCLE) begin
                r_SLV_ADDR              <= {r_SLV_ADDR[6:0],1'b0} ;
            end
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_SUB_ADDR                  <= 8'b0 ;
        end else begin
            if (I2C_WR_EN | I2C_RD_EN) begin
                r_SUB_ADDR              <= I2C_SUB_ADDR ;
            end else if (r_FSM_I2C_SUADR & r_SCL_CYCLE) begin
                r_SUB_ADDR              <= {r_SUB_ADDR[6:0],1'b0} ;
            end
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_WR_DATA                  <= 8'b0 ;
        end else begin
            if (I2C_WR_EN) begin
                r_WR_DATA               <= I2C_WR_DATA ;
            end else if (r_FSM_I2C_WDATA & r_SCL_CYCLE) begin
                r_WR_DATA               <= {r_WR_DATA[6:0],1'b0} ;
            end
        end
    end

    // 8 bits address/data counter
    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_I2C_BIT_CNT               <= 'b0 ;
            r_I2C_BIT_CNT_END           <= 'b0 ;
        end else begin
            if (r_FSM_I2C_SLADR | r_FSM_I2C_SUADR | r_FSM_I2C_WDATA | r_FSM_I2C_RDATA) begin
                if (r_SCL_CYCLE) begin
                    r_I2C_BIT_CNT <= r_I2C_BIT_CNT + 1'b1 ;
                end
            end else begin
                r_I2C_BIT_CNT           <= 4'b0 ;
            end

            r_I2C_BIT_CNT_END           <= &r_I2C_BIT_CNT[2:0] ;
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_I2C_SDA_O                 <= 1'b1 ;
        end else begin
            if (r_FSM_I2C_START & r_SAD_START) begin
                r_I2C_SDA_O             <= 1'b0 ;
            end else if (r_FSM_I2C_START & r_SCL_QUAT_CYCLE) begin
                r_I2C_SDA_O             <= 1'b1 ;
            end else if (r_FSM_I2C_SLADR & r_SCL_QUAT_CYCLE) begin
                r_I2C_SDA_O             <= r_SLV_ADDR[7] ;
            end else if (r_FSM_I2C_SUADR & r_SCL_QUAT_CYCLE) begin
                r_I2C_SDA_O             <= r_SUB_ADDR[7] ;
            end else if (r_FSM_I2C_WDATA & r_SCL_QUAT_CYCLE) begin
                r_I2C_SDA_O             <= r_WR_DATA[7] ;
            end else if (r_FSM_I2C_STOP) begin
                if (r_SCL_CYCLE_FF) begin
                    r_I2C_SDA_O         <= 1'b1 ;
                end else begin
                    r_I2C_SDA_O         <= 1'b0 ;
                end
            end else if (r_FSM_I2C_IDLE | r_FSM_I2C_SLACK | r_FSM_I2C_SUACK | r_FSM_I2C_RACK | r_FSM_I2C_WAIT) begin
                r_I2C_SDA_O             <= 1'b1 ;
            end
        end
    end

    // Write data ack
    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_WR_ACK                    <= 1'b0 ;
        end else begin
            r_WR_ACK                    <= r_WR_FLAG & r_FSM_I2C_WAIT & r_SCL_CYCLE ;
        end
    end

/*=============================================================================+/
||                                                                             ||
||                             I2C SCL/SDA control                             ||
||                                                                             ||
/+=============================================================================*/
`ifdef SIM
    always @(posedge SYS_CLK ) begin
        r_I2C_SDA_I_DFF0                <= s_I2C_IF_SDA_IN  ;
        r_I2C_SDA_I_DFF1                <= r_I2C_SDA_I_DFF0 ;
        r_I2C_SDA_I_DFF2                <= r_I2C_SDA_I_DFF1 ;
    end
`else
    always @(posedge SYS_CLK ) begin
        r_I2C_SDA_I_DFF0                <= I2C_IF_SDA       ;
        r_I2C_SDA_I_DFF1                <= r_I2C_SDA_I_DFF0 ;
        r_I2C_SDA_I_DFF2                <= r_I2C_SDA_I_DFF1 ;
    end
`endif

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
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

/*=============================================================================+/
||                                                                             ||
||                             I2C SDA read data                               ||
||                                                                             ||
/+=============================================================================*/

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_I2C_RX_SHIFT              <= 8'b0 ;
        end else begin
            if (r_FSM_I2C_RDATA & r_SCL_CYCLE) begin
                r_I2C_RX_SHIFT          <= {r_I2C_RX_SHIFT[6:0],r_I2C_SDA_I_DFF2} ;
            end
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_RD_ACK                    <= 1'b0 ;
            r_RD_DATA                   <= 8'b0 ;
        end else begin
            r_RD_ACK                    <= r_FSM_I2C_RACK & r_SCL_CYCLE ;
            r_RD_DATA                   <= r_I2C_RX_SHIFT ;
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_I2C_ACK_ERR               <= 1'b0 ;
        end else begin
            if (r_I2C_START) begin
                r_I2C_ACK_ERR           <= 1'b0 ;
            end else if (r_FSM_I2C_SLACK | r_FSM_I2C_SUACK | r_FSM_I2C_WACK) begin
                if ((s_SCL_HALF_CYCLE & ~r_I2C_SCL) & r_I2C_SDA_I_DFF2) begin
                    r_I2C_ACK_ERR       <= 1'b1 ;
                end
            end
        end
    end

    always @(posedge SYS_CLK or posedge SYS_RST) begin
        if (SYS_RST) begin
            r_I2C_BUSY                  <= 1'b0 ;
        end else begin
            if (r_I2C_FSM == P_I2C_IDLE) begin
                r_I2C_BUSY              <= 1'b0 ;
            end else begin
                r_I2C_BUSY              <= 1'b1 ;
            end
        end
    end

endmodule
