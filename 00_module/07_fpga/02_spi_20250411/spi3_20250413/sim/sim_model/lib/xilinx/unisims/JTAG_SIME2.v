///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 1995/2010 Xilinx, Inc.
// All Right Reserved.
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor : Xilinx
// \   \   \/     Version : 10.1
//  \   \         Description : Xilinx Functional Simulation Library Component
//  /   /                  Jtag TAP Controler for VIRTEX7
// /___/   /\     Filename : JTAG_SIME2.v
// \   \  /  \    Timestamp : Mon May 17 17:10:29 PDT 2010
//  \___\/\___\
//
// Revision:
//    05/17/10 - Initial version.
// End Revision

`timescale 1 ps/1 ps

module JTAG_SIME2( TDO, TCK, TDI, TMS);


  output TDO;

  input TCK, TDI, TMS;
   
  reg TDO;
  reg notifier;


  parameter PART_NAME = "30T";

  localparam       TestLogicReset	= 4'h0,
                   RunTestIdle		= 4'h1,
                   SelectDRScan		= 4'h2,
                   CaptureDR		= 4'h3,
                   ShiftDR		= 4'h4,
                   Exit1DR		= 4'h5,
                   PauseDR		= 4'h6,
                   Exit2DR		= 4'h7,
                   UpdateDR		= 4'h8,
                   SelectIRScan		= 4'h9,
                   CaptureIR		= 4'ha,
                   ShiftIR		= 4'hb,
                   Exit1IR		= 4'hc,
                   PauseIR		= 4'hd,
                   Exit2IR		= 4'he,
                   UpdateIR		= 4'hf;

   localparam DELAY_SIG = 1;
   
   reg TRST = 0;

   reg [3:0]    CurrentState = TestLogicReset;
   reg [14*8:0] jtag_state_name = "TestLogicReset";
   reg [14*8:0] jtag_instruction_name = "IDCODE";


//-----------------  Virtex4 Specific Constants ---------
//  localparam IRLengthMax = 10;
    localparam IRLengthMax = 24;
  localparam IDLength    = 32;

  reg [IRLengthMax-1:0] IR_CAPTURE_VAL	= 24'b010001010001010001010001,
                      BYPASS_INSTR      = 24'b111111111111111111111111,
                      IDCODE_INSTR      = 24'b001001001001001001001001,
                      USER1_INSTR       = 24'b000010100100100100100100,
                      USER2_INSTR       = 24'b000011100100100100100100,
                      USER3_INSTR       = 24'b100010100100100100100100,
                      USER4_INSTR       = 24'b100011100100100100100100;

//  localparam IRLength = 10;
  localparam IRLength = ( 
        (PART_NAME   == "7A20")         || (PART_NAME   == "7a20")      ||
        (PART_NAME   == "7A40")         || (PART_NAME   == "7a40")      ||
        (PART_NAME   == "7A105")        || (PART_NAME   == "7a105")     ||
        (PART_NAME   == "7A175T")       || (PART_NAME   == "7a175t")    ||
        (PART_NAME   == "7A335T")       || (PART_NAME   == "7a335t")    ||
        (PART_NAME   == "7K30T")        || (PART_NAME   == "7k30t")     ||
        (PART_NAME   == "7K70T")        || (PART_NAME   == "7k70t")     ||
        (PART_NAME   == "7K120T")       || (PART_NAME   == "7k120t")    ||
        (PART_NAME   == "7K230T")       || (PART_NAME   == "7k230t")    ||
        (PART_NAME   == "7V285T")       || (PART_NAME   == "7v285t"))    ?	6 : (
        (PART_NAME   == "7V450T")       || (PART_NAME   == "7v450t")    ||
        (PART_NAME   == "7V585T")       || (PART_NAME   == "7v585t")    ||
        (PART_NAME   == "7V855T")       || (PART_NAME   == "7v855t"))    ?	12 : (
        (PART_NAME   == "7VX415T")      || (PART_NAME   == "7vx415t")   ||
        (PART_NAME   == "7V1500T")      || (PART_NAME   == "7v1500t"))   ?	18 : ( 
        (PART_NAME   == "7V2000T")      || (PART_NAME   == "7v2000t"))  ?  	24 : 24 ;


//----------------- local reg  -------------------------------
  reg CaptureDR_sig = 0, RESET_sig = 0, ShiftDR_sig = 0, UpdateDR_sig = 0; 

  reg ClkIR_active = 0, ClkIR_sig = 0, ClkID_sig = 0; 

  reg ShiftIR_sig, UpdateIR_sig, ClkUpdateIR_sig; 
  
  reg [IRLength-1:0] IRcontent_sig;

  reg [IDLength-1:0] IDCODEval_sig;

  reg  BypassReg = 0, BYPASS_sig = 0, IDCODE_sig = 0, 
       USER1_sig = 0, USER2_sig = 0,
       USER3_sig = 0, USER4_sig = 0;

  reg TDO_latch;

  reg Tlrst_sig = 1; 
  reg TlrstN_sig = 1; 

  reg IRegLastBit_sig = 0, IDregLastBit_sig = 0;

  reg Rti_sig = 0; 
 //-------------------------------------------------------------
  reg [IRLength-1:0] NextIRreg; 
  reg [IRLength-1:0] ir_int; // = IR_CAPTURE_VAL[IRLength-1:0] ;
  reg [IDLength-1:0] IDreg;
 	
//####################################################################
//#####                     Initialize                           #####
//####################################################################
   initial begin
      case (PART_NAME)
                "7A20",         "7a20"          : IDCODEval_sig <= 32'h03A22093;
                "7A40",         "7a40"          : IDCODEval_sig <= 32'h03A24093;
                "7A105",        "7a105"         : IDCODEval_sig <= 32'h03A26093;
                "7A175T",       "7a175t"        : IDCODEval_sig <= 32'h03A28093;
                "7A335T",       "7a335t"        : IDCODEval_sig <= 32'h03A2A093;
                "7K30T",        "7k30t"         : IDCODEval_sig <= 32'h03A42093;
                "7K70T",        "7k70t"         : IDCODEval_sig <= 32'h03A44093;
                "7K120T",       "7k120t"        : IDCODEval_sig <= 32'h03A46093;
                "7K230T",       "7k230t"        : IDCODEval_sig <= 32'h03A48093;
                "7V285T",       "7v285t"        : IDCODEval_sig <= 32'h03A64093;
                "7V450T",       "7v450t"        : IDCODEval_sig <= 32'h03A66093;
                "7V585T",       "7v585t"        : IDCODEval_sig <= 32'h03A68093;
                "7V855T",       "7v855t"        : IDCODEval_sig <= 32'h03A6A093;
                "7VX415T",      "7vx415t"       : IDCODEval_sig <= 32'h03A84093;
                "7V1500T",      "7v1500t"       : IDCODEval_sig <= 32'h03AAA093;
                "7V2000T",      "7v2000t"       : IDCODEval_sig <= 32'h03ABB093;

         default : begin

                        $display("Attribute Syntax Error : The attribute PART_NAME on JTAG_SIME2 instance %m is set to %s. The legal values for this attributes are 7A20, 7A40, 7A105,  7A175T, 7A335T, 7K30T, 7K70T, 7K120T, 7K230T, 7V285T, 7V450T, 7V585T, 7V855T, 7VX415T, 7V1500T or 7V2000T.",  PART_NAME);
         end
       endcase // case(PART_NAME)

       ir_int <= IR_CAPTURE_VAL[IRLength-1:0];

    end // initial begin
//####################################################################
//#####                      JtagTapSM                           #####
//####################################################################
  always@(posedge TCK or posedge TRST)
     begin
       if(TRST) begin
          CurrentState = TestLogicReset;
       end
       else begin
            case(CurrentState)
 
               TestLogicReset:
                 begin
                   if(TMS == 0) begin
                      CurrentState = RunTestIdle;
                      jtag_state_name = "RunTestIdle";
                   end
                 end

               RunTestIdle:
                 begin
                   if(TMS == 1) begin
                      CurrentState = SelectDRScan;
                      jtag_state_name = "SelectDRScan";
                   end
                 end
               //-------------------------------
               // ------  DR path ---------------
               // -------------------------------
               SelectDRScan:
                 begin
                   if(TMS == 0) begin
                      CurrentState = CaptureDR;
                      jtag_state_name = "CaptureDR";
                   end
                   else if(TMS == 1) begin
                      CurrentState = SelectIRScan;
                      jtag_state_name = "SelectIRScan";
                   end
                 end
 
               CaptureDR:
                 begin
                   if(TMS == 0) begin
                      CurrentState = ShiftDR;
                      jtag_state_name = "ShiftDR";
                   end
                   else if(TMS == 1) begin
                      CurrentState = Exit1DR;
                      jtag_state_name = "Exit1DR";
                   end
                 end
              
               ShiftDR:
                 begin
                    if(IRcontent_sig == BYPASS_INSTR[IRLengthMax : (IRLengthMax - IRLength)]) 
                      BypassReg = TDI;

                   if(TMS == 1) begin
                      CurrentState = Exit1DR;
                      jtag_state_name = "Exit1DR";
                   end
                 end
              
               Exit1DR:
                 begin
                   if(TMS == 0) begin
                      CurrentState = PauseDR;
                      jtag_state_name = "PauseDR";
                   end
                   else if(TMS == 1) begin
                      CurrentState = UpdateDR;
                      jtag_state_name = "UpdateDR";
                   end
                 end
              
               PauseDR:
                 begin
                   if(TMS == 1) begin
                      CurrentState =  Exit2DR;
                      jtag_state_name = "Exit2DR";
                   end
                 end
            
               Exit2DR:
                 begin
                   if(TMS == 0) begin
                      CurrentState = ShiftDR;
                      jtag_state_name = "ShiftDR";
                   end
                   else if(TMS == 1) begin
                      CurrentState = UpdateDR;
                      jtag_state_name = "UpdateDR";
                   end
                 end
              
               UpdateDR:
                 begin
                   if(TMS == 0) begin
                      CurrentState = RunTestIdle;
                      jtag_state_name = "RunTestIdle";
                   end
                   else if(TMS == 1) begin
                      CurrentState = SelectDRScan;
                      jtag_state_name = "SelectDRScan";
                   end
                 end
               //-------------------------------
               // ------  IR path ---------------
               // -------------------------------
               SelectIRScan:
                 begin
                   if(TMS == 0) begin
                      CurrentState = CaptureIR;
                      jtag_state_name = "CaptureIR";
                   end
                   else if(TMS == 1) begin
                      CurrentState = TestLogicReset;
                      jtag_state_name = "TestLogicReset";
                   end
                 end
 
               CaptureIR:
                 begin
                   if(TMS == 0) begin
                      CurrentState = ShiftIR;
                      jtag_state_name = "ShiftIR";
                   end
                   else if(TMS == 1) begin
                      CurrentState = Exit1IR;
                      jtag_state_name = "Exit1IR";
                   end
                  end
              
               ShiftIR:
                 begin
//                   ClkIR_sig = 1;

                   if(TMS == 1) begin
                      CurrentState = Exit1IR;
                      jtag_state_name = "Exit1IR";
                   end
                 end
             
               Exit1IR:
                 begin
                   if(TMS == 0) begin
                      CurrentState = PauseIR;
                      jtag_state_name = "PauseIR";
                   end
                   else if(TMS == 1) begin
                      CurrentState = UpdateIR;
                      jtag_state_name = "UpdateIR";
                   end
                 end
              
               PauseIR:
                 begin
                   if(TMS == 1) begin
                      CurrentState =  Exit2IR;
                      jtag_state_name = "Exit2IR";
                   end
                 end
            
               Exit2IR:
                 begin
                   if(TMS == 0) begin
                      CurrentState = ShiftIR;
                      jtag_state_name = "ShiftIR";
                   end 
                   else if(TMS == 1) begin
                      CurrentState = UpdateIR;
                      jtag_state_name = "UpdateIR";
                   end
                 end
              
               UpdateIR:
                 begin
                  //-- FP
//                   ClkIR_sig = 1;

                   if(TMS == 0) begin
                      CurrentState = RunTestIdle;
                      jtag_state_name = "RunTestIdle";
                   end
                   else if(TMS == 1) begin
                      CurrentState = SelectDRScan;
                      jtag_state_name = "SelectDRScan";
                   end
                 end
             endcase // case(CurrentState)
       end // else

     end // always

//--------------------------------------------------------
  always@(CurrentState, TCK, TRST)
  begin
      ClkIR_sig = 1;

      if(TRST == 1 ) begin
            Tlrst_sig     = #DELAY_SIG 1;
            CaptureDR_sig = #DELAY_SIG 0;
            ShiftDR_sig   = #DELAY_SIG 0;
            UpdateDR_sig  = #DELAY_SIG 0;
            ShiftIR_sig   = #DELAY_SIG 0;
            UpdateIR_sig  = #DELAY_SIG 0;
      end
      else if(TRST == 0) begin
         
         case (CurrentState)
            TestLogicReset:  begin 
                  Tlrst_sig     = #DELAY_SIG 1;
                  Rti_sig       = #DELAY_SIG 0;
                  CaptureDR_sig = #DELAY_SIG 0;
                  ShiftDR_sig   = #DELAY_SIG 0;
                  UpdateDR_sig  = #DELAY_SIG 0;
                  ShiftIR_sig   = #DELAY_SIG 0;
                  UpdateIR_sig  = #DELAY_SIG 0;
            end
            RunTestIdle:  begin 
                  Tlrst_sig     = #DELAY_SIG 0;
                  Rti_sig       = #DELAY_SIG 1;
                  CaptureDR_sig = #DELAY_SIG 0;
                  ShiftDR_sig   = #DELAY_SIG 0;
                  UpdateDR_sig  = #DELAY_SIG 0;
                  ShiftIR_sig   = #DELAY_SIG 0;
                  UpdateIR_sig  = #DELAY_SIG 0;
            end
            CaptureDR:  begin 
                  Tlrst_sig     = #DELAY_SIG 0;
                  Rti_sig       = #DELAY_SIG 0;
                  CaptureDR_sig = #DELAY_SIG 1;
                  ShiftDR_sig   = #DELAY_SIG 0;
                  UpdateDR_sig  = #DELAY_SIG 0;
                  ShiftIR_sig   = #DELAY_SIG 0;
                  UpdateIR_sig  = #DELAY_SIG 0;
            end
            ShiftDR:  begin 
                  Tlrst_sig     = #DELAY_SIG 0;
                  Rti_sig       = #DELAY_SIG 0;
                  CaptureDR_sig = #DELAY_SIG 0;
                  ShiftDR_sig   = #DELAY_SIG 1;
                  UpdateDR_sig  = #DELAY_SIG 0;
                  ShiftIR_sig   = #DELAY_SIG 0;
                  UpdateIR_sig  = #DELAY_SIG 0;
            end
            UpdateDR:  begin 
                  Tlrst_sig     = #DELAY_SIG 0;
                  Rti_sig       = #DELAY_SIG 0;
                  CaptureDR_sig = #DELAY_SIG 0;
                  ShiftDR_sig   = #DELAY_SIG 0;
                  UpdateDR_sig  = #DELAY_SIG 1;
                  ShiftIR_sig   = #DELAY_SIG 0;
                  UpdateIR_sig  = #DELAY_SIG 0;
            end
            CaptureIR:  begin 
                  Tlrst_sig     = #DELAY_SIG 0;
                  Rti_sig       = #DELAY_SIG 0;
                  CaptureDR_sig = #DELAY_SIG 0;
                  ShiftDR_sig   = #DELAY_SIG 0;
                  UpdateDR_sig  = #DELAY_SIG 0;
                  ShiftIR_sig   = #DELAY_SIG 0;
                  UpdateIR_sig  = #DELAY_SIG 0;
                  ClkIR_sig     = TCK;
            end
            ShiftIR:  begin 
                  Tlrst_sig     = #DELAY_SIG 0;
                  Rti_sig       = #DELAY_SIG 0;
                  CaptureDR_sig = #DELAY_SIG 0;
                  ShiftDR_sig   = #DELAY_SIG 0;
                  UpdateDR_sig  = #DELAY_SIG 0;
                  ShiftIR_sig   = #DELAY_SIG 1;
                  UpdateIR_sig  = #DELAY_SIG 0;
                  ClkIR_sig     = TCK;
            end
            UpdateIR: begin 
                         Tlrst_sig     = #DELAY_SIG 0;
                         Rti_sig       = #DELAY_SIG 0;
                         CaptureDR_sig = #DELAY_SIG 0;
                         ShiftDR_sig   = #DELAY_SIG 0;
                         UpdateDR_sig  = #DELAY_SIG 0;
                         ShiftIR_sig   = #DELAY_SIG 0;
                         UpdateIR_sig  = #DELAY_SIG 1;
                     end
            default: begin 
                         Tlrst_sig     = #DELAY_SIG 0;
                         Rti_sig       = #DELAY_SIG 0;
                         CaptureDR_sig = #DELAY_SIG 0;
                         ShiftDR_sig   = #DELAY_SIG 0;
                         UpdateDR_sig  = #DELAY_SIG 0;
                         ShiftIR_sig   = #DELAY_SIG 0;
                         UpdateIR_sig  = #DELAY_SIG 0;
                     end
         endcase

      end

    end // always(CurrentState)
//-----------------------------------------------------
  always@(TCK)
  begin
//       ClkIR_sig = ShiftIR_sig & TCK;
       ClkUpdateIR_sig = UpdateIR_sig & ~TCK;
  end // always
   
  always@(TCK)
  begin
       ClkID_sig = IDCODE_sig & TCK;
  end // always

// RESET 
  always@(Tlrst_sig)
  begin
     glbl.JTAG_RESET_GLBL   <= Tlrst_sig;
  end

// RUNTEST
  always@(Rti_sig)
  begin
     glbl.JTAG_RUNTEST_GLBL   <= Rti_sig;
  end
//-------------- TCK  NEGATIVE EDGE activities ----------
  always@(negedge TCK, negedge UpdateDR_sig)
  begin
     if(TCK == 0) begin
        glbl.JTAG_CAPTURE_GLBL <= CaptureDR_sig;
        glbl.JTAG_SHIFT_GLBL   <= ShiftDR_sig;
        TlrstN_sig             <= Tlrst_sig;
     end

     glbl.JTAG_UPDATE_GLBL  <= UpdateDR_sig;

  end // always

//--####################################################################
//--#####                       JtagIR                             #####
//--####################################################################
   always@(posedge ClkIR_sig) begin
      NextIRreg = {TDI, ir_int[IRLength-1:1]};

      if ((TRST== 0) && (TlrstN_sig == 0)) begin
         if(ShiftIR_sig == 1) begin 
            ir_int = NextIRreg;
            IRegLastBit_sig = ir_int[0];
         end
         else begin
            ir_int = IR_CAPTURE_VAL; 
            IRegLastBit_sig = ir_int[0];
         end
      end
   end //always 
//--------------------------------------------------------
   always@(posedge ClkUpdateIR_sig or posedge TlrstN_sig or
           posedge TRST) begin
      if ((TRST== 1) || (TlrstN_sig == 1)) begin
         IRcontent_sig = IDCODE_INSTR[IRLengthMax : (IRLengthMax - IRLength)];
         IRegLastBit_sig = ir_int[0];
      end
      else if( (TRST == 0) && (TlrstN_sig == 0)) begin 
               IRcontent_sig = ir_int;
      end
   end //always 
//--####################################################################
//--#####                       JtagDecodeIR                       #####
//--####################################################################
   always@(IRcontent_sig) begin

      case(IRcontent_sig)

//          IR_CAPTURE_VAL : begin
//               ;
//               jtag_instruction_name = "IR_CAPTURE";
//          end

          BYPASS_INSTR[IRLengthMax : (IRLengthMax - IRLength)] : begin
             jtag_instruction_name = "BYPASS";
             // if BYPASS instruction, set BYPASS signal to 1
             BYPASS_sig <= 1;
             IDCODE_sig <= 0;
             USER1_sig  <= 0;
             USER2_sig  <= 0;
             USER3_sig  <= 0;
             USER4_sig  <= 0;
          end

          IDCODE_INSTR[IRLengthMax : (IRLengthMax - IRLength)] : begin
             jtag_instruction_name = "IDCODE";
             // if IDCODE instruction, set IDCODE signal to 1
             BYPASS_sig <= 0;
             IDCODE_sig <= 1;
             USER1_sig  <= 0;
             USER2_sig  <= 0;
             USER3_sig  <= 0;
             USER4_sig  <= 0;
          end

          USER1_INSTR[IRLengthMax : (IRLengthMax - IRLength)] : begin
             jtag_instruction_name = "USER1";
             // if USER1 instruction, set USER1 signal to 1 
             BYPASS_sig <= 0;
             IDCODE_sig <= 0;
             USER1_sig  <= 1;
             USER2_sig  <= 0;
             USER3_sig  <= 0;
             USER4_sig  <= 0;
          end

          USER2_INSTR[IRLengthMax : (IRLengthMax - IRLength)] : begin
             jtag_instruction_name = "USER2";
             // if USER2 instruction, set USER2 signal to 1 
             BYPASS_sig <= 0;
             IDCODE_sig <= 0;
             USER1_sig  <= 0;
             USER2_sig  <= 1;
             USER3_sig  <= 0;
             USER4_sig  <= 0;
          end

          USER3_INSTR[IRLengthMax : (IRLengthMax - IRLength)] : begin
             jtag_instruction_name = "USER3";
             // if USER3 instruction, set USER3 signal to 1 
             BYPASS_sig <= 0;
             USER1_sig  <= 0;
             USER2_sig  <= 0;
             IDCODE_sig <= 0;
             USER3_sig  <= 1;
             USER4_sig  <= 0;
           end

          USER4_INSTR[IRLengthMax : (IRLengthMax - IRLength)] : begin
             jtag_instruction_name = "USER4";
             // if USER4 instruction, set USER4 signal to 1 
             BYPASS_sig <= 0;
             IDCODE_sig <= 0;
             USER1_sig  <= 0;
             USER2_sig  <= 0;
             USER3_sig  <= 0;
             USER4_sig  <= 1;
          end
          default : begin
             jtag_instruction_name = "UNKNOWN";
             // if UNKNOWN instruction, set all signals to 0 
             BYPASS_sig <= 0;
             IDCODE_sig <= 0;
             USER1_sig  <= 0;
             USER2_sig  <= 0;
             USER3_sig  <= 0;
             USER4_sig  <= 0;
          end

      endcase
   end //always
//--####################################################################
//--#####                       JtagIDCODE                         #####
//--####################################################################
   always@(posedge ClkID_sig) begin
//     reg [(IDLength -1) : 0] IDreg;
     if(ShiftDR_sig == 1) begin
        IDreg = IDreg >> 1;
        IDreg[IDLength -1] = TDI;
     end
     else
        IDreg = IDCODEval_sig;

     IDregLastBit_sig = IDreg[0];
   end // always

//--####################################################################
//--#####                    JtagSetGlobalSignals                  #####
//--####################################################################
   always@(ClkUpdateIR_sig, Tlrst_sig, USER1_sig, USER2_sig, USER3_sig, USER4_sig) begin
      if(Tlrst_sig == 1) begin 
         glbl.JTAG_SEL1_GLBL <= 0;
         glbl.JTAG_SEL2_GLBL <= 0;
         glbl.JTAG_SEL3_GLBL <= 0;
         glbl.JTAG_SEL4_GLBL <= 0;
      end
      else if(Tlrst_sig == 0) begin
              if(USER1_sig == 1) begin
                 glbl.JTAG_SEL1_GLBL <= USER1_sig;
                 glbl.JTAG_SEL2_GLBL <= 0;
                 glbl.JTAG_SEL3_GLBL <= 0;
                 glbl.JTAG_SEL4_GLBL <= 0;
              end
              else if(USER2_sig == 1) begin
                 glbl.JTAG_SEL1_GLBL <= 0;
                 glbl.JTAG_SEL2_GLBL <= 1;
                 glbl.JTAG_SEL3_GLBL <= 0;
                 glbl.JTAG_SEL4_GLBL <= 0;
              end
              else if(USER3_sig == 1) begin
                 glbl.JTAG_SEL1_GLBL <= 0;
                 glbl.JTAG_SEL2_GLBL <= 0;
                 glbl.JTAG_SEL3_GLBL <= 1;
                 glbl.JTAG_SEL4_GLBL <= 0;
              end
              else if(USER4_sig == 1) begin
                 glbl.JTAG_SEL1_GLBL <= 0;
                 glbl.JTAG_SEL2_GLBL <= 0;
                 glbl.JTAG_SEL3_GLBL <= 0;
                 glbl.JTAG_SEL4_GLBL <= 1;
              end
              else if(ClkUpdateIR_sig == 1) begin
                 glbl.JTAG_SEL1_GLBL <= 0;
                 glbl.JTAG_SEL2_GLBL <= 0;
                 glbl.JTAG_SEL3_GLBL <= 0;
                 glbl.JTAG_SEL4_GLBL <= 0;
              end

      end
       
   end //always

//--####################################################################
//--#####                         OUTPUT                           #####
//--####################################################################
  assign glbl.JTAG_TDI_GLBL = TDI;
  assign glbl.JTAG_TCK_GLBL = TCK;
  assign glbl.JTAG_TMS_GLBL = TMS;

  always@(CurrentState, IRcontent_sig, BypassReg,
          IRegLastBit_sig, IDregLastBit_sig,  glbl.JTAG_USER_TDO1_GLBL,
          glbl.JTAG_USER_TDO2_GLBL, glbl.JTAG_USER_TDO3_GLBL, 
          glbl.JTAG_USER_TDO4_GLBL) 
  begin
      case (CurrentState)
         ShiftIR:  begin
                      TDO_latch <= IRegLastBit_sig;
                   end 
         ShiftDR:  begin
                      if(IRcontent_sig == IDCODE_INSTR[IRLengthMax : (IRLengthMax - IRLength)]) 
                          TDO_latch <= IDregLastBit_sig;
                      else if(IRcontent_sig == BYPASS_INSTR[IRLengthMax : (IRLengthMax - IRLength)]) 
                          TDO_latch <= BypassReg; 
                      else if(IRcontent_sig == USER1_INSTR[IRLengthMax : (IRLengthMax - IRLength)]) 
                          TDO_latch <= glbl.JTAG_USER_TDO1_GLBL; 
                      else if(IRcontent_sig == USER2_INSTR[IRLengthMax : (IRLengthMax - IRLength)]) 
                          TDO_latch <= glbl.JTAG_USER_TDO2_GLBL; 
                      else if(IRcontent_sig == USER3_INSTR[IRLengthMax : (IRLengthMax - IRLength)]) 
                          TDO_latch <= glbl.JTAG_USER_TDO3_GLBL; 
                      else if(IRcontent_sig == USER4_INSTR[IRLengthMax : (IRLengthMax - IRLength)]) 
                          TDO_latch <= glbl.JTAG_USER_TDO4_GLBL; 
                      else
                          TDO_latch <= 1'bz;
                      end 
         default : begin
                          TDO_latch <= 1'bz;
                   end
      endcase // case(PART_NAME)
  end // always

  always@(negedge TCK)
  begin
// 213980 NCsim compile error fix
     TDO <= # 6000 TDO_latch;
  end // always
   
//--####################################################################
//--#####                         Timing                           #####
//--####################################################################

  specify
// 213980 NCsim compile error fix
//     (TCK => TDO) = (6000:6000:6000, 6000:6000:6000);
    
     $setuphold (posedge TCK, posedge TDI , 1000:1000:1000, 2000:2000:2000, notifier);
     $setuphold (posedge TCK, negedge TDI , 1000:1000:1000, 2000:2000:2000, notifier);

     $setuphold (posedge TCK, posedge TMS , 1000:1000:1000, 2000:2000:2000, notifier);
     $setuphold (posedge TCK, negedge TMS , 1000:1000:1000, 2000:2000:2000, notifier);
  endspecify

endmodule // JTAG_SIME2
