// =================================================================================================
// File Name      : pcie_int.v
// Module         : PCIE_INT
// Function       : Interrupt
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

module PCIE_INT (
    input                               PCIE_RST                                ,//(i) [  1] async. reset (low active)
    input                               PCIE_CLK                                ,//(i) [  1] clock
    //pcie core
    output                              CFG_INTERRUPT_N                         ,//(o) [  1] CFG interrupt
    input                               CFG_INTERRUPT_RDY_N                     ,//(i) [  1] CFG interrupt ready
    output      [  7:0]                 CFG_INTERRUPT_DI                        ,//(o) [  8] Configuration Interrupt Data In

    output                              CFG_INTERRUPT_ASSERT_N                  ,//(o) [  1] Configuration Legacy Interrupt Assert/Deassert
    input                               CFG_INTERRUPT_MSIENABLE                 ,//(i) [  1] Configuration Interrupt MSI Enabled
    input       [  7:0]                 CFG_INTERRUPT_DO                        ,//(i) [  8] Configuration Interrupt Data Out
    input       [  2:0]                 CFG_INTERRUPT_MMENABLE                  ,//(i) [  3] Configuration Interrupt Multiple Message Enable
    //interrupt
    input       [  7:0]                 INTR_FACT                               ,//(i) [  8] Interrupt Factor
    input                               INTR_CLR                                ,//(i) [  1] Interrupt Clear
    output      [  7:0]                 INTR_STATUS                              //(o) [  8] Interrupt Status
    ) ;

// =============================================================================
// localparam Declare
// =============================================================================

    localparam                          p_ST_IDLE               = 4'b0001       ;//(p) [  4]
    localparam                          p_ST_ASSERT_WT          = 4'b0010       ;//(p) [  4]
    localparam                          p_ST_CLR_WT             = 4'b0100       ;//(p) [  4]
    localparam                          p_ST_DEASSERT_WT        = 4'b1000       ;//(p) [  4]

// =============================================================================
// Internal Signal Declare
// =============================================================================

    reg         [   3:0]                r_FSM                                   ;
    reg                                 r_INTR_CLR_G                            ;
    reg                                 r_CFG_INTERRUPT_N                       ;
    reg                                 r_CFG_INTERRUPT_ASSERT_N                ;
    reg         [   7:0]                r_INTR_FACT                             ;
    reg         [   7:0]                r_INTR_STATUS                           ;


// =================================================================================================
// RTL Body
// =================================================================================================

/*============================================================================+/
||                                                                            ||
||                           Output ports                                     ||
||                                                                            ||
/+============================================================================*/

    assign CFG_INTERRUPT_DI             = 8'd0                                  ;
    assign CFG_INTERRUPT_N              = r_CFG_INTERRUPT_N                     ;
    assign CFG_INTERRUPT_ASSERT_N       = r_CFG_INTERRUPT_ASSERT_N              ;
    assign INTR_STATUS                  = r_INTR_STATUS                         ;

/*============================================================================+/
||                                                                            ||
||                          Interrupt Control                                 ||
||                                                                            ||
/+============================================================================*/

    // INTR_CLR
    always @( posedge PCIE_CLK or posedge PCIE_RST ) begin
        if ( PCIE_RST == 1'b1 ) begin
            r_INTR_CLR_G            <= 1'b0 ;
        end else begin
            if ( INTR_CLR == 1'b1 ) begin
                r_INTR_CLR_G    <= 1'b1 ;
            end else if ( r_FSM == p_ST_IDLE ) begin
                r_INTR_CLR_G    <= 1'b0 ;
            end else if ( INTR_FACT == 8'd0 ) begin
                r_INTR_CLR_G    <= 1'b1 ;
            end
        end
    end

    assign s_INTR_CLR   = r_INTR_CLR_G | INTR_CLR ;

/*============================================================================+/
||                                                                            ||
||                          FSM -- State Machine                              ||
||                                                                            ||
/+============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST == 1'b1) begin
            r_FSM       <= p_ST_IDLE ;
        end else begin
            case (r_FSM)
                p_ST_IDLE :
                    if ( (INTR_FACT != 8'd0) && (CFG_INTERRUPT_RDY_N == 1'b1) ) begin
                        r_FSM           <= p_ST_ASSERT_WT ;
                    end else begin
                        r_FSM           <= p_ST_IDLE ;
                    end
                p_ST_ASSERT_WT :
                    if ( CFG_INTERRUPT_RDY_N == 1'b0 ) begin
                        r_FSM           <= p_ST_CLR_WT ;
                    end else begin
                        r_FSM           <= p_ST_ASSERT_WT ;
                    end
                p_ST_CLR_WT :
                    if ( s_INTR_CLR == 1'b1 ) begin
                        if ( CFG_INTERRUPT_MSIENABLE == 1'b1 ) begin
                            r_FSM       <= p_ST_IDLE ;
                        end else begin
                            r_FSM       <= p_ST_DEASSERT_WT ;
                        end
                    end else begin
                        r_FSM           <= p_ST_CLR_WT ;
                    end
                p_ST_DEASSERT_WT :
                    if ( CFG_INTERRUPT_RDY_N == 1'b0 ) begin
                        r_FSM           <= p_ST_IDLE ;
                    end else begin
                        r_FSM           <= p_ST_DEASSERT_WT ;
                    end
                default :
                    r_FSM               <= p_ST_IDLE ;
            endcase
        end
    end

/*============================================================================+/
||                                                                            ||
||                              FSM -- Deocde                                 ||
||                                                                            ||
/+============================================================================*/

    always @(posedge PCIE_CLK or posedge PCIE_RST) begin
        if (PCIE_RST == 1'b1) begin
            r_CFG_INTERRUPT_N            <= 1'b1 ;
            r_CFG_INTERRUPT_ASSERT_N     <= 1'b1 ;
            r_INTR_FACT                  <= 8'd0 ;
            r_INTR_STATUS                <= 8'd0 ;
        end else begin
            case (r_FSM)
                p_ST_IDLE       : begin
                    if ( (INTR_FACT != 8'd0) && (CFG_INTERRUPT_RDY_N == 1'b1) ) begin
                        r_CFG_INTERRUPT_N           <= 1'b0                    ;
                        r_CFG_INTERRUPT_ASSERT_N    <= CFG_INTERRUPT_MSIENABLE ;
                        r_INTR_FACT                 <= INTR_FACT               ;
                    end else begin
                        r_CFG_INTERRUPT_N           <= 1'b1 ;
                        r_CFG_INTERRUPT_ASSERT_N    <= 1'b1 ;
                        r_INTR_FACT                 <= 8'd0 ;
                    end
                    r_INTR_STATUS                   <= 8'd0 ;
                end
                p_ST_ASSERT_WT  : begin
                    if ( CFG_INTERRUPT_RDY_N == 1'b0 ) begin
                        r_CFG_INTERRUPT_N           <= 1'b1 ;
                        r_CFG_INTERRUPT_ASSERT_N    <= 1'b1 ;
                    end
                    r_INTR_STATUS                   <= 8'd0 ;
                end
                p_ST_CLR_WT     : begin
                    if ( (s_INTR_CLR == 1'b1) && (CFG_INTERRUPT_MSIENABLE == 1'b0) ) begin
                        r_CFG_INTERRUPT_N           <= 1'b0 ;
                    end
                    r_CFG_INTERRUPT_ASSERT_N        <= 1'b1 ;

                    if ( s_INTR_CLR == 1'b1 ) begin
                        r_INTR_STATUS               <= 8'd0 ;
                    end else begin
                        r_INTR_STATUS[0]            <= r_INTR_FACT[0] | INTR_FACT[0]   ;
                        r_INTR_STATUS[1]            <= r_INTR_FACT[1] | INTR_FACT[1]   ;
                        r_INTR_STATUS[2]            <= r_INTR_FACT[2] | INTR_FACT[2]   ;
                        r_INTR_STATUS[3]            <= r_INTR_FACT[3] | INTR_FACT[3]   ;
                        r_INTR_STATUS[4]            <= r_INTR_FACT[4] | INTR_FACT[4]   ;
                        r_INTR_STATUS[5]            <= r_INTR_FACT[5] | INTR_FACT[5]   ;
                        r_INTR_STATUS[6]            <= r_INTR_FACT[6] | INTR_FACT[6]   ;
                        r_INTR_STATUS[7]            <= r_INTR_FACT[7] | INTR_FACT[7]   ;
                    end
                end
                p_ST_DEASSERT_WT    : begin
                    if ( CFG_INTERRUPT_RDY_N == 1'b0 ) begin
                        r_CFG_INTERRUPT_N           <= 1'b1 ;
                    end
                    r_CFG_INTERRUPT_ASSERT_N        <= 1'b1 ;
                    r_INTR_STATUS                   <= 8'd0 ;
                end
            endcase
        end
    end

endmodule