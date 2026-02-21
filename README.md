# 8-Bit RISC CPU — SystemVerilog Implementation

A custom 8-bit RISC processor designed and implemented in SystemVerilog, complete with a Python assembler, individual module testbenches, and a full CPU integration test.

---

## Architecture Overview

The CPU is built around a simple RISC ISA with 16 instructions, 16 general-purpose 8-bit registers, and a 16-bit instruction word.

```
Instruction Memory → Program Counter → Decoder → Register File → ALU → Register File (writeback)
```

### Key Design Decisions
- **16 instructions** encoded in 4-bit opcodes
- **16 registers** (R0–R15), each 8-bits wide — R0 hardwired to 0, R1 hardwired to 1
- **R14 and R15** connected to LED outputs
- **Signed branching** support for forward and backward jumps
- **Active-low synchronous reset** on the Program Counter
- Subtraction implemented as `A + ~B + 1` to reuse full adder hardware

---

## Instruction Set Architecture (ISA)

| Instruction | Encoding | Opcode | Operation         |
|-------------|----------|--------|-------------------|
| `beqz`      | B        | 0000   | Branch if zero    |
| `or`        | R        | 0001   | A \| B            |
| `add`       | R        | 0010   | A + B             |
| `sub`       | R        | 0011   | A – B             |
| `and`       | R        | 0100   | A & B             |
| `xor`       | R        | 0101   | A ^ B             |
| `sll`       | R        | 0110   | A << B            |
| `srl`       | R        | 0111   | A >> B            |
| `li`        | L        | 1000   | Load immediate    |
| `ori`       | I        | 1001   | A \| imm          |
| `addi`      | I        | 1010   | A + imm           |
| `subi`      | I        | 1011   | A – imm           |
| `andi`      | I        | 1100   | A & imm           |
| `xori`      | I        | 1101   | A ^ imm           |
| `slli`      | I        | 1110   | A << imm          |
| `srli`      | I        | 1111   | A >> imm          |

### Instruction Formats

| Format | Bits [15:12] | Bits [11:8] | Bits [7:4] | Bits [3:0] |
|--------|-------------|-------------|------------|------------|
| R      | opcode      | rd          | rs1        | rs2        |
| I      | opcode      | rd          | rs1        | imm[3:0]   |
| L      | opcode      | rd          | imm[7:0]            ||
| B      | opcode      | imm[11:4]               | rs1        |

---

## Module Descriptions

| File                    | Description                                               |
|-------------------------|-----------------------------------------------------------|
| `program_counter.sv`    | 8-bit PC with synchronous reset, increment, and branching |
| `alu.sv`                | ALU with 8 operations, carry and zero flag outputs        |
| `adder_8bit.sv`         | 8-bit ripple-carry adder (add/subtract via carry-in)      |
| `fullAdder.sv`          | 1-bit full adder — base unit for the adder chain          |
| `decoder.sv`            | Decodes 4-bit opcode into ALUop, WB, ImmEnable, ImmType, Branch |
| `register_file.sv`      | 16×8-bit register file with dual read ports and sync write |
| `instruction_memory.sv` | ROM storing the program (loaded from assembled hex)       |
| `totalCPU.sv`           | Top-level integration of all modules                      |

### Decoder Output Signals

| Signal      | Width  | Function                                      |
|-------------|--------|-----------------------------------------------|
| `ALUop`     | 3-bit  | Selects ALU operation                         |
| `WB`        | 1-bit  | Enable register writeback                     |
| `ImmEnable` | 1-bit  | Use immediate instead of register source      |
| `ImmType`   | 1-bit  | `0` = I-type immediate, `1` = L-type immediate |
| `Branch`    | 1-bit  | Flags instruction as a branch                 |

---

## Assembler

A Python assembler (`assembler.py`) converts assembly source into hex machine code for loading into instruction memory.

### Usage

```bash
python3 assembler.py -o output.txt input.asm
```

Enable verbose mode with `-v`:
```bash
python3 assembler.py -v -o output.txt input.asm
```

### Example Program (`text.txt`)

```asm
li r2, 5
li r3, 6
xor r4, r3, r2
beqz r0, NEXT
li r14, 8
NEXT: beqz r4, SKIP
li r12, 8
SKIP: beqz r2, END
li r13, 4
END: beqz r0, END
```

---

## Testbenches

| File                      | Tests                            |
|---------------------------|----------------------------------|
| `test_alu.sv`             | All 8 ALU operations             |
| `test_decoder.sv`         | All 16 opcodes and output signals |
| `test_program_counter.sv` | Reset, increment, branching      |
| `test_register_file.sv`   | Read, write, hardwired registers |
| `totalTestBenches.sv`     | Full CPU integration test        |

Simulation was performed using **AMD Vivado**.

---

## File Structure

```
.
├── src/
│   ├── program_counter.sv
│   ├── alu.sv
│   ├── adder_8bit.sv
│   ├── fullAdder.sv
│   ├── decoder.sv
│   ├── register_file.sv
│   ├── instruction_memory.sv
├── testbenches/
│   ├── test_alu.sv
│   ├── test_decoder.sv
│   ├── test_program_counter.sv
│   ├── test_register_file.sv
├── assembler/
│   ├── assembler.py
│   ├── text.txt          # Example assembly program
│   └── output.txt        # Assembled hex output
├── report/
│   └── report.pdf
└── README.md
```

---

## References

1. Harris, D. M., & Harris, S. L. (2021). *Digital Design and Computer Architecture: ARM Edition*. Morgan Kaufmann.
2. Patterson, D. A., & Hennessy, J. L. (2017). *Computer Organization and Design* (5th ed.). Morgan Kaufmann.
3. Karnaugh Map Tutorial — [All About Circuits](https://www.allaboutcircuits.com)
4. IEEE Standard for SystemVerilog (IEEE Std 1800-2017)
5. Synthesis and simulation: AMD Vivado
