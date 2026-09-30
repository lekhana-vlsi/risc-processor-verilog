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