# 4-bit 2-Stage Pipelined RISC Processor

## Project Overview
A 4-bit 2-stage pipelined RISC processor designed
from scratch in Verilog HDL and implemented on
Xilinx Kintex-7 FPGA using Vivado 2025.2.

## What I Built
- Custom 8-instruction ISA with 12-bit fixed format
- Complete processor datapath in Verilog
- 2-stage pipeline: IF stage and ID/EX stage
- IF/ID pipeline register (12-bit)
- 24-test comprehensive testbench — 100% pass rate
- Naturally hazard-free design (no stall logic needed)

## Instruction Set Architecture
| Instruction | Opcode | Operation |
|-------------|--------|-----------|
| ADD  | 0000 | R[dst] = R[src1] + R[src2] |
| SUB  | 0001 | R[dst] = R[src1] - R[src2] |
| AND  | 0010 | R[dst] = R[src1] & R[src2] |
| OR   | 0011 | R[dst] = R[src1] or R[src2] |
| NOT  | 0100 | R[dst] = ~R[src1] |
| MOV  | 0101 | R[dst] = R[src1] |
| LOAD | 0110 | R[dst] = immediate value |
| JMP  | 0111 | PC = jump address |

## FPGA Implementation Results
| Metric | Value |
|--------|-------|
| Device | Kintex-7 xc7k70tfdv676-1 |
| LUTs used | 46 out of 41,000 (less than 0.1%) |
| Flip-Flops | 16 out of 82,000 (less than 0.1%) |
| Clock constraint | 50 MHz |
| WNS after implementation | +4.684 ns |
| Maximum frequency | 65.3 MHz |
| Timing status | All constraints met |
| Bitstream | Generated successfully (2.87 MB) |

## Pipeline Performance
| Metric | Single-Cycle | 2-Stage Pipeline |
|--------|-------------|-----------------|
| Critical path | 19.8 ns (est.) | 15.316 ns |
| Max frequency | 50.5 MHz | 65.3 MHz |
| Throughput | 50.5 MIPS | 65.3 MIPS |
| Improvement | baseline | 29% |

## Verification Results
Test program final register state:
- R0 = 1 (expected 1) PASS
- R1 = 7 (expected 7) PASS
- R2 = 14 (expected 14) PASS
- R3 = 7 (expected 7) PASS

## Source Files
| File | Description |
|------|-------------|
| top.v | Top module — connects all blocks |
| pc.v | Program Counter |
| inst_mem.v | Instruction Memory (ROM) |
| decoder.v | Instruction Decoder |
| reg_file.v | Register File (4 x 4-bit) |
| alu.v | ALU (8 operations) |
| rca4.v | 4-bit Ripple Carry Adder |
| full_adder.v | Full Adder |
| half_adder.v | Half Adder |
| top_tb.v | Testbench |
| processor_constraints.xdc | Timing constraints |

## Tools Used
- Xilinx Vivado 2025.2
- Verilog HDL
- Target FPGA: Kintex-7 xc7k70tfdv676-1
