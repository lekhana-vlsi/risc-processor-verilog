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