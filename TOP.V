`timescale 1ns/1ps

// ============================================================
// Module:      top.v
// Description: 4-bit 2-Stage Pipelined RISC Processor
//              Stage 1: IF (Instruction Fetch)
//              Stage 2: ID/EX (Decode + Execute)
//              IF/ID pipeline register between stages
// Author:      lekhana
// Date:        05-09-2026
// ============================================================

module top(
  input  clk,
  input  reset,
  output [3:0] debug_pc,
  output [3:0] debug_result
);

  // ============================================================
  // SECTION 1: WIRE DECLARATIONS
  // ============================================================

  // --- Stage 1: Fetch Wires ---
  wire [3:0]  pc_out;       // Current instruction address (Stage 1)
  wire [11:0] instruction;  // Raw fetched instruction (Stage 1 output)

  // --- IF/ID Pipeline Register ---
  reg [11:0] if_id_instruction; // instruction captured from Stage 1
                                 // Stage 2 reads from this

  // --- Stage 2: Decode/Execute Field Wires ---
  wire [3:0] opcode;  // if_id_instruction[11:8]
  wire [1:0] dst;     // if_id_instruction[7:6]
  wire [1:0] src1;    // if_id_instruction[5:4]
  wire [1:0] src2;    // if_id_instruction[3:2]
  wire [1:0] imm;     // if_id_instruction[1:0]

  // --- Decoder Control Signal Wires ---
  wire [2:0] alu_op;
  wire reg_write;
  wire mem_read;
  wire jump;

  // --- Jump Address Wire ---
  wire [3:0] jump_addr;

  // --- Data Path Wires ---
  wire [3:0] rdata1;
  wire [3:0] rdata2;
  wire [3:0] alu_result;
  wire [3:0] wdata;

  // ============================================================
  // SECTION 2A: IF/ID PIPELINE REGISTER
  // Captures fetched instruction at each clock edge
  // Enables Stage 2 to process previous instruction while
  // Stage 1 fetches next instruction simultaneously
  // ============================================================
  always @(posedge clk or posedge reset) begin
    if (reset)
      if_id_instruction <= 12'b000000000000;
    else
      if_id_instruction <= instruction;
  end

  // ============================================================
  // SECTION 2B: INSTRUCTION FIELD EXTRACTION
  // Reads from IF/ID pipeline register — NOT direct instruction
  // 1-cycle delay is intentional — this IS the pipeline behavior
  // ============================================================
  assign opcode    = if_id_instruction[11:8];
  assign dst       = if_id_instruction[7:6];
  assign src1      = if_id_instruction[5:4];
  assign src2      = if_id_instruction[3:2];
  assign imm       = if_id_instruction[1:0];
  assign jump_addr = {2'b00, if_id_instruction[1:0]};

  // ============================================================
  // SECTION 3: MUX — WRITE DATA SELECTION
  // ============================================================
  assign wdata = mem_read ?
    {2'b00, imm} :
    alu_result;

  // ============================================================
  // SECTION 4: DEBUG OUTPUTS
  // ============================================================
  assign debug_pc     = pc_out;
  assign debug_result = alu_result;

  // ============================================================
  // SECTION 5: MODULE INSTANTIATIONS
  // ============================================================

  // --- BLOCK 1: PROGRAM COUNTER ---
  // Reads 'jump' from decoder (via if_id pipeline — 1 cycle delay)
  pc my_pc (
    .clk(clk),
    .reset(reset),
    .jump(jump),
    .jump_addr(jump_addr),
    .pc_out(pc_out)
  );

  // --- BLOCK 2: INSTRUCTION MEMORY ---
  // Stage 1: Combinational read, output goes to IF/ID register
  inst_mem my_inst_mem (
    .addr(pc_out),
    .inst(instruction)
  );

  // --- BLOCK 3: DECODER ---
  // Stage 2: Reads from if_id_instruction (via opcode wire)
  decoder my_decoder (
    .opcode(opcode),
    .alu_op(alu_op),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .jump(jump)
  );

  // --- BLOCK 4: REGISTER FILE ---
  // Stage 2: Reads/writes registers
  reg_file my_reg_file (
    .clk(clk),
    .we(reg_write),
    .raddr1(src1),
    .raddr2(src2),
    .waddr(dst),
    .wdata(wdata),
    .rdata1(rdata1),
    .rdata2(rdata2)
  );

  // --- BLOCK 5: ALU ---
  // Stage 2: Computes result from register data
  alu my_alu (
    .a(rdata1),
    .b(rdata2),
    .opcode(alu_op),
    .result(alu_result)
  );

endmodule