`timescale 1ns/1ps

// ============================================================
// Module:   top_tb.v
// Description: 4-bit 2-Stage Pipelined RISC Processor Testbench
// ============================================================

module top_tb;

  // ============================================================
  // TESTBENCH SIGNALS
  // ============================================================

  reg clk = 0;
  reg reset;

  wire [3:0] debug_pc;
  wire [3:0] debug_result;

  // ============================================================
  // DUT
  // ============================================================

  top uut (
    .clk(clk),
    .reset(reset),
    .debug_pc(debug_pc),
    .debug_result(debug_result)
  );

  // ============================================================
  // CLOCK
  // 10 ns period = 100 MHz
  // ============================================================

  always #5 clk = ~clk;

  // ============================================================
  // MAIN TEST
  // ============================================================

  initial begin

    // ==========================================================
    // PHASE 1: RESET
    // ==========================================================

    $display("========================================");
    $display("        4-BIT 2-STAGE PIPELINED RISC");
    $display("========================================");

    $display("");
    $display("=== PHASE 1: RESET ===");

    reset = 1;

    #20;

    $display("Reset released at t=%0t", $time);

    reset = 0;

    // ==========================================================
    // PHASE 2: PROGRAM EXECUTION
    // ==========================================================

    $display("=== PHASE 2: PROGRAM EXECUTION ===");

    // ----------------------------------------------------------
    // Cycle 1
    // Pipeline filling
    // ----------------------------------------------------------

    $display("Cycle 1 | pc=%0d | Stage1=%b | Stage2=%b",
             uut.pc_out,
             uut.instruction,
             uut.if_id_instruction);

    // ----------------------------------------------------------
    // Cycle 2
    // LOAD R0,3
    // ----------------------------------------------------------

    #10;

    $display("Cycle 2 | pc=%0d | Stage1=%b | Stage2=%b | result=%0d",
             uut.pc_out,
             uut.instruction,
             uut.if_id_instruction,
             uut.wdata);

    // ----------------------------------------------------------
    // Cycle 3
    // LOAD R1,2
    // ----------------------------------------------------------

    #10;

    $display("Cycle 3 | pc=%0d | Stage1=%b | Stage2=%b | result=%0d",
             uut.pc_out,
             uut.instruction,
             uut.if_id_instruction,
             uut.wdata);

    // ----------------------------------------------------------
    // Cycle 4
    // ADD R2,R0,R1
    // ----------------------------------------------------------

    #10;

    $display("Cycle 4 | pc=%0d | Stage1=%b | Stage2=%b",
             uut.pc_out,
             uut.instruction,
             uut.if_id_instruction);

    $display("        | rdata1=%0d rdata2=%0d result=%0d",
             uut.rdata1,
             uut.rdata2,
             uut.wdata);

    // ----------------------------------------------------------
    // Cycle 5
    // SUB R3,R2,R1
    // ----------------------------------------------------------

    #10;

    $display("Cycle 5 | pc=%0d | Stage2=%b | rdata1=%0d rdata2=%0d result=%0d",
             uut.pc_out,
             uut.if_id_instruction,
             uut.rdata1,
             uut.rdata2,
             uut.wdata);

    // ----------------------------------------------------------
    // Cycle 6
    // AND R0,R2,R3
    // ----------------------------------------------------------

    #10;

    $display("Cycle 6 | pc=%0d | Stage2=%b | rdata1=%0d rdata2=%0d result=%0d",
             uut.pc_out,
             uut.if_id_instruction,
             uut.rdata1,
             uut.rdata2,
             uut.wdata);

    // ----------------------------------------------------------
    // Cycle 7
    // OR R1,R2,R3
    // ----------------------------------------------------------

    #10;

    $display("Cycle 7 | pc=%0d | Stage2=%b | rdata1=%0d rdata2=%0d result=%0d",
             uut.pc_out,
             uut.if_id_instruction,
             uut.rdata1,
             uut.rdata2,
             uut.wdata);

    // ----------------------------------------------------------
    // Cycle 8
    // NOT R2,R0
    // ----------------------------------------------------------

    #10;

    $display("Cycle 8 | pc=%0d | Stage2=%b | rdata1=%0d result=%0d",
             uut.pc_out,
             uut.if_id_instruction,
             uut.rdata1,
             uut.wdata);

    // ----------------------------------------------------------
    // Cycle 9
    // MOV R3,R1
    // ----------------------------------------------------------

    #10;

    $display("Cycle 9 | pc=%0d | Stage2=%b | rdata1=%0d result=%0d",
             uut.pc_out,
             uut.if_id_instruction,
             uut.rdata1,
             uut.wdata);

    // ==========================================================
    // PHASE 3: FINAL REGISTER STATE
    // ==========================================================

    #10;

    $display("");
    $display("=== PHASE 3: FINAL REGISTER STATE ===");

    $display("R0 = %0d (expected 1)",
             uut.my_reg_file.regs[0]);

    $display("R1 = %0d (expected 7)",
             uut.my_reg_file.regs[1]);

    $display("R2 = %0d (expected 14)",
             uut.my_reg_file.regs[2]);

    $display("R3 = %0d (expected 7)",
             uut.my_reg_file.regs[3]);

    $display("");

    // ==========================================================
    // FINAL CHECK
    // ==========================================================

    if ((uut.my_reg_file.regs[0] == 4'd1) &&
        (uut.my_reg_file.regs[1] == 4'd7) &&
        (uut.my_reg_file.regs[2] == 4'd14) &&
        (uut.my_reg_file.regs[3] == 4'd7)) begin

      $display("FINAL RESULT: ALL CORRECT");
      $display("Processor: FULLY VERIFIED");

    end
    else begin

      $display("FINAL RESULT: ERROR DETECTED");

    end

    // ==========================================================
    // END
    // ==========================================================

    $display("");
    $display("=== SIMULATION COMPLETE ===");

    $finish;

  end

endmodule