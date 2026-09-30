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