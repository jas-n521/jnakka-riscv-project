# jnakka-riscv-project
Self-led RISC-V CPU Project. Single cycle for now, will be pipelined in the future

A 32-bit RISC-V processor (RV32I) written in SystemVerilog, built from scratch as a learning project in computer architecture and digital design.

The current version is a **single-cycle** implementation: every instruction is fetched, decoded, executed, and written back in one clock cycle. A **5-stage pipelined** version is planned next.

## Status

**In progress.** The hardware components are written; integration and full-system verification are underway.

- [x] ALU
- [x] Register file (32 × 32-bit)
- [x] Immediate generator / sign extender
- [x] Instruction memory (ROM)
- [x] Data memory (RAM)
- [x] Program counter
- [x] Control unit (main decoder, ALU decoder, controller wrapper)
- [x] Datapath
- [ ] Top-level integration
- [ ] Top-level testbench and test programs
- [ ] Remaining RV32I instructions (JALR, LUI, AUIPC)
- [ ] FPGA implementation (Artix-7)
- [ ] 5-stage pipeline with hazard detection and forwarding

## Supported Instructions

| Type | Instructions | Status |
|------|-------------|--------|
| R-type | `add`, `sub`, `and`, `or`, `slt`, ... | Decoded |
| I-type (ALU) | `addi`, `andi`, `ori`, `slti`, ... | Decoded |
| I-type (load) | `lw` | Decoded |
| S-type | `sw` | Decoded |
| B-type | `beq` | Decoded |
| J-type | `jal` | Decoded |
| I-type (jump) | `jalr` | Planned |
| U-type | `lui`, `auipc` | Planned |

## Architecture

The design is split into a **controller** and a **datapath**:

- **Controller**: the main decoder reads the opcode and generates control signals (`RegWrite`, `ImmSrc`, `ALUSrc`, `MemWrite`, `ResultSrc`, `Branch`, `Jump`, `ALUOp`). The ALU decoder combines `ALUOp` with `funct3`/`funct7` to select the ALU operation.
- **Datapath**: the PC, register file, immediate generator, ALU, and the muxes that route data between them, plus the instruction and data memories.

## Repository Structure

```
riscv-project/
├── rtl/        # SystemVerilog design modules
├── tb/         # Testbenches
├── programs/   # Assembly test programs (.s) and machine code (.hex)
└── vivado/     # Vivado project (generated files are git-ignored)
```

## Tools

- **HDL:** SystemVerilog
- **Simulation:** Vivado Simulator (xsim)
- **Assembler:** RARS (converts RISC-V assembly to machine code)
- **Target FPGA:** Xilinx Artix-7

## Running a Simulation

1. Write a test program in RISC-V assembly and assemble it with RARS. Export the machine code as a hex file into `programs/`.
2. The instruction memory loads the program with `$readmemh`.
3. Open the Vivado project, add the files in `rtl/` as design sources and `tb/` as simulation sources, and run a behavioral simulation.
4. Check the register file and data memory contents in the waveform viewer.

## What I'm Learning

- How an ISA maps onto hardware, from instruction encoding to control signals
- Designing clean, synthesizable combinational and sequential logic in SystemVerilog
- Verifying a multi-module design, from unit tests up to full-system tests
- (Next) Pipelining, hazards, and forwarding

## Author

**Jasmitha Nakka**, Electrical and Computer Engineering, NC State University