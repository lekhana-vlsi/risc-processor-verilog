`timescale 1ns/1ps

module processor(
  input clk,
  input reset
);

  // ===== INTERNAL WIRES =====

  // PC and instruction fetch
  wire [3:0] pc_out;
  wire [11:0] instruction;

  // Instruction fields
  wire [3:0] opcode;
  wire [1:0] dst;
  wire [1:0] src1;
  wire [1:0] src2;
  wire [1:0] imm;

  // Decoder control signals
  wire [2:0] alu_op;
  wire reg_write;
  wire mem_read;
  wire jump;

  // Jump address
  wire [3:0] jump_addr;

  // Register file signals
  wire [3:0] rdata1;
  wire [3:0] rdata2;
  wire [3:0] wdata;

  // ALU signals
  wire [3:0] alu_result;

  // ===== INSTRUCTION FIELD EXTRACTION =====
  assign opcode    = instruction[11:8];
  assign dst       = instruction[7:6];
  assign src1      = instruction[5:4];
  assign src2      = instruction[3:2];
  assign imm       = instruction[1:0];
  assign jump_addr = {2'b00, instruction[1:0]};

  // ===== MUX: Select write data =====
  // mem_read=1 (LOAD) → use immediate value
  // mem_read=0 (others) → use ALU result
  assign wdata = mem_read ?
    {2'b00, imm} :
    alu_result;

  // ===== BLOCK 1: PROGRAM COUNTER =====
  pc my_pc (
    .clk(clk),
    .reset(reset),
    .jump(jump),
    .jump_addr(jump_addr),
    .pc_out(pc_out)
  );

  // ===== BLOCK 2: INSTRUCTION MEMORY =====
  inst_mem my_inst_mem (
    .addr(pc_out),
    .inst(instruction)
  );

  // ===== BLOCK 3: DECODER =====
  decoder my_decoder (
    .opcode(opcode),
    .alu_op(alu_op),
    .reg_write(reg_write),
    .mem_read(mem_read),
    .jump(jump)
  );

  // ===== BLOCK 4: REGISTER FILE =====
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

  // ===== BLOCK 5: ALU =====
  alu my_alu (
    .a(rdata1),
    .b(rdata2),
    .opcode(alu_op),
    .result(alu_result)
  );

endmodule






`timescale 1ns/1ps

module pc(
  input clk,
  input reset,
  input jump,
  input [3:0] jump_addr,
  output reg [3:0] pc_out
);

  always @(posedge clk or posedge reset) begin

    if (reset) begin
      pc_out <= 4'b0000;
    end

    else if (jump) begin
      pc_out <= jump_addr;
    end

    else begin
      pc_out <= pc_out + 1;
    end

  end

endmodule





`timescale 1ns/1ps

module inst_mem(
  input [3:0] addr,
  output reg [11:0] inst
);

  always @(*) begin
    case(addr)

      4'd0: inst = 12'b011000000011;
      4'd1: inst = 12'b011001000010;
      4'd2: inst = 12'b000010000100;
      4'd3: inst = 12'b000111100100;
      4'd4: inst = 12'b001000101100;
      4'd5: inst = 12'b001101101100;
      4'd6: inst = 12'b010010000000;
      4'd7: inst = 12'b010111010000;

      // Safe instruction for PC >= 8
      4'd8: inst = 12'b111100000000;
      4'd9: inst = 12'b111100000000;
      4'd10: inst = 12'b111100000000;
      4'd11: inst = 12'b111100000000;
      4'd12: inst = 12'b111100000000;
      4'd13: inst = 12'b111100000000;
      4'd14: inst = 12'b111100000000;
      4'd15: inst = 12'b111100000000;

      default: inst = 12'b111100000000;

    endcase
  end

endmodule





`timescale 1ns/1ps

module decoder(
  input [3:0] opcode,
  output reg [2:0] alu_op,
  output reg reg_write,
  output reg mem_read,
  output reg jump
);

  always @(*) begin

    alu_op    = 3'b000;
    reg_write = 0;
    mem_read  = 0;
    jump      = 0;

    case(opcode)

      4'b0000: begin
        alu_op    = 3'b000;
        reg_write = 1;
      end

      4'b0001: begin
        alu_op    = 3'b001;
        reg_write = 1;
      end

      4'b0010: begin
        alu_op    = 3'b010;
        reg_write = 1;
      end

      4'b0011: begin
        alu_op    = 3'b011;
        reg_write = 1;
      end

      4'b0100: begin
        alu_op    = 3'b100;
        reg_write = 1;
      end

      4'b0101: begin
        alu_op    = 3'b111;
        reg_write = 1;
      end

      4'b0110: begin
        mem_read  = 1;
        reg_write = 1;
      end

      4'b0111: begin
        jump = 1;
      end

      default: begin
        alu_op    = 3'b000;
        reg_write = 0;
        mem_read  = 0;
        jump      = 0;
      end

    endcase
  end

endmodule





`timescale 1ns/1ps

module reg_file(
  input clk,
  input we,
  input [1:0] raddr1,
  input [1:0] raddr2,
  input [1:0] waddr,
  input [3:0] wdata,
  output [3:0] rdata1,
  output [3:0] rdata2
);

  reg [3:0] regs [0:3];

  assign rdata1 = regs[raddr1];
  assign rdata2 = regs[raddr2];

  always @(posedge clk) begin
    if (we) begin
      regs[waddr] <= wdata;
    end
  end

endmodule





`timescale 1ns/1ps

module reg_file(
  input clk,
  input we,
  input [1:0] raddr1,
  input [1:0] raddr2,
  input [1:0] waddr,
  input [3:0] wdata,
  output [3:0] rdata1,
  output [3:0] rdata2
);

  reg [3:0] regs [0:3];

  assign rdata1 = regs[raddr1];
  assign rdata2 = regs[raddr2];

  always @(posedge clk) begin
    if (we) begin
      regs[waddr] <= wdata;
    end
  end

endmodule