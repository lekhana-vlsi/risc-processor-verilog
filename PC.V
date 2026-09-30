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