#!/bin/python3

# Generic imports
import argparse
import re

# Global verbosity control
verbose = False

# -------------------------------------------------------
# ISA DESCRIPTION
# -------------------------------------------------------
from dataclasses import dataclass


# Holds information required to parse & encode a specific instruction
@dataclass
class cmd_info:
    # Command name
    cmd: str

    # Encoding used
    encoding: str

    # Opcode
    opcode: int

    # Number of register arguments
    regnum: int

    # If has immediate or branch label argument
    immediate: bool
    branch: bool

    # Allowed immediate range
    imm_min: int
    imm_max: int

    # Constructor setting relevant parameters for the different encodings
    def __init__(self, cmd, encoding, opcode):
        self.cmd = cmd
        self.encoding = encoding
        self.opcode = opcode

        match self.encoding:
            case "R":
                self.regnum = 3
                self.immediate = False
                self.branch = False

                self.imm_min = 0
                self.imm_max = 0
            case "I":
                self.regnum = 2
                self.immediate = True
                self.branch = False

                self.imm_min = -8
                self.imm_max = 7
            case "B":
                self.regnum = 1
                self.immediate = False
                self.branch = True

                self.imm_min = -128
                self.imm_max = 127
            case "L":
                self.regnum = 1
                self.immediate = True
                self.branch = False

                self.imm_min = -128
                self.imm_max = 127

    # Function to produce the different immediate encodings
    def encode_immediate(self, imm):
        encoded = 0

        match self.encoding:
            case "R":
                print("Attempting to encode immediate of R type instruction\n")
                exit(1)
            case "I":
                encoded |= imm & 0xf
            case "B":
                encoded |= (imm & 0xff) << 4
            case "L":
                encoded |= imm & 0xff

        return encoded


# Maps command string to a command info dataclass
imap = {
    "beqz": cmd_info("beqz", "B", 0x0),
    "or": cmd_info("or", "R", 0x1),
    "add": cmd_info("add", "R", 0x2),
    "sub": cmd_info("sub", "R", 0x3),
    "and": cmd_info("and", "R", 0x4),
    "xor": cmd_info("xor", "R", 0x5),
    "sll": cmd_info("sll", "R", 0x6),
    "srl": cmd_info("srl", "R", 0x7),
    "li": cmd_info("li", "L", 0x8),
    "ori": cmd_info("ori", "I", 0x9),
    "addi": cmd_info("addi", "I", 0xa),
    "subi": cmd_info("subi", "I", 0xb),
    "andi": cmd_info("andi", "I", 0xc),
    "xori": cmd_info("xori", "I", 0xd),
    "slli": cmd_info("slli", "I", 0xe),
    "srli": cmd_info("srli", "I", 0xf)
}


# Holds all the information about a parsed instruction
@dataclass
class instruction:
    line: str
    info: cmd_info
    registers: list
    imm: int
    branch: str
    addr: int


# Register ranges for all instructions
REG_MIN = 0
REG_MAX = 15

# Reg address and opcode masks
REG_MASK = 0xf
OPCODE_MASK = 0xf

# Opcode location in instruction
OPCODE_SHIFT = 12

# Location of registers within instruction encodings
REG_SHIFT = {
    "R": [8, 4, 0],
    "I": [8, 4, -1],
    "B": [0, -1, -1],
    "L": [8, -1, -1]
}

# Machine code width per instruction in Bytes
# 16b instructions
OUTPUT_WIDTH = 4


# -------------------------------------------------------
# Helper Functions
# -------------------------------------------------------
# Verbosity controlled print
def DEBUG(msg):
    if (verbose):
        print(msg)


# Parse arguments in a line
# Words should be a list of argument words
def parse(info, words):
    DEBUG(f'Parsing arguments \"{words}\"')

    # Store whole list of arguments for debug printing
    args = words

    # Create instruction dataclass
    instr = instruction("", info, list(), 0, "", 0)

    # Parse required register names
    DEBUG(f'Parsing {info.regnum} registers')
    for i in range(info.regnum):
        if (len(words) != 0):
            DEBUG(f'Converting register name {words[0]}')

            # Convert textual regname to unsigned int value
            regval = get_regval(words[0])
            instr.registers.append(regval)
            DEBUG(f'Found register number {regval}')

            # Remove parsed word from argument list
            del words[0]
        else:
            print("Missing register value in line ending\n")
            print(args)
            exit(1)

    # Parse an immediate if required
    if (info.immediate):
        if (len(words) != 0):
            DEBUG(f'Parsing immediate {words[0]}')
            immval = get_immval(words[0], info)
            instr.imm = immval
            DEBUG(f'Got immediate value {immval}')
            del words[0]
        else:
            print("Missing immediate value in line ending\n")
            print(args)
            exit(1)

    # Parse a branch target if required
    if (info.branch):
        if (len(words) != 0):
            DEBUG(f'Found branch target {words[0]}')
            # Store branch target as string to resolve later
            instr.branch = words[0]
            del words[0]
        else:
            print("Missing branch target in line ending\n")
            print(args)
            exit(1)

    # Return any un-parsed arguments and the instruction dataclass
    return instr, words


# Convert a register name to a register number
def get_regval(regname):
    if (regname[0] != "r"):
        print(f'Register name \"{regname}\" does not begin with r\n')
        exit(1)

    regname = regname[1:]

    try:
        regval = int(regname)
    except Exception as e:
        print(f'Failed to convert regname \"{regname}\" to integer\n')
        print(e)
        exit(1)

    if ((regval < REG_MIN) or (regval > REG_MAX)):
        print(f'Register {regval} is out of range\n')
        exit(1)

    return regval


# Convert an immediate string to a integer value
def get_immval(immstr, info):
    try:
        immval = int(immstr)
    except Exception as e:
        print(f'Failed to convert immediate \"{immstr}\" to integer\n')
        print(e)
        exit(1)

    if ((immval < info.imm_min) or (immval > info.imm_max)):
        print(f'Immediate {immval} is out of range\n')
        exit(1)

    return immval


# Convert an instruction to its machine code representation
def to_machine(instr, bmap):
    machcode = 0

    # Add the Opcode
    machcode |= (instr.info.opcode & OPCODE_MASK) << OPCODE_SHIFT

    # Add register values at the correct location
    for i in range(instr.info.regnum):
        machcode |= (instr.registers[i] & REG_MASK) << REG_SHIFT[instr.info.encoding][i]

    # Add an encoded immediate at the correct location
    if (instr.info.immediate):
        machcode |= instr.info.encode_immediate(instr.imm)

    # Resolve branch target and add the encoded immediate
    if (instr.branch != ""):
        offset = branch_calc(bmap, instr.branch, instr.addr, instr.info)
        machcode |= instr.info.encode_immediate(offset)

    return machcode


# Resolve a branch target from label to offset
def branch_calc(bmap, target, addr, info):
    DEBUG(f'Resolving branch target {target}')

    # See if target is a valid label
    if (target in bmap):
        DEBUG("Target is a valid label")
        offset = bmap[target] - addr

        if ((offset < info.imm_min) or (offset > info.imm_max)):
            print(f'Branch offset {offset} is out of range\n')
            exit(1)

        DEBUG(f'Branch offset is {offset}')

        return offset
    else:
        DEBUG("Trying to parse target as raw offset")
        try:
            offset = int(target)
        except Exception as e:
            print(f'Failed to convert branch target \"{target}\" to integer\n')
            print(e)
            exit(1)

        DEBUG("Succesfully parsed target as raw offset")
        return offset


# -------------------------------------------------------
# Main Flow
# -------------------------------------------------------
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Custom RISC assembler")
    parser.add_argument("-o", help="Output file", required=True)
    parser.add_argument("input", help="Input file")
    parser.add_argument("-v", help="Enable verbose mode", required=False, action="store_true")

    options = parser.parse_args()

    # Set verbose mode
    if ("v" in options and options.v == True):
        verbose = True

    DEBUG("Running assembler with options:")
    DEBUG(f'Input = {options.input}\nOutput = {options.o}\nVerbose = {verbose}')

    # List of all parsed instructions
    instructions = list()

    # Dictionary of branch labels to instruction address
    bmap = dict()

    # Try parse the input file
    try:
        # Current instruction address
        addr = 0

        # Open input file
        with open(options.input, "r") as file:
            # Read the file line by line
            for line in file:
                DEBUG(f'Parsing line \"{line.strip()}\"')

                # Split into words
                words = line.replace(",", " ").strip().split()

                # Empty line
                if (len(words) == 0):
                    continue

                # Comment line
                if (words[0].startswith("#")):
                    continue

                # Branch label found
                if (words[0][-1] == ":"):
                    if (len(words[0]) == 1):
                        print(f'Missing label name in line {line.strip()}')
                        exit(1)
                    if (":" in words[0][0:-1]):
                        print(f'Two colons found in branch label {words[0]}')
                        exit(1)
                    DEBUG(f'Found branch target \"{words[0][0:-1]}\" at address {addr}')
                    bmap[words[0][0:-1]] = addr
                    del words[0]

                # Rest of line empty
                if (len(words) == 0):
                    continue

                # Rest of line comment
                if (words[0].startswith("#")):
                    continue

                # If command is found
                if (len(words) != 0):
                    # Check command name is valid
                    if (words[0] not in imap):
                        print(f'Unknown command reached {words[0]}')
                        exit(1)

                    DEBUG(f'Found command {words[0]}')

                    # Parse command
                    cmd = words[0]
                    del words[0]
                    instr, words = parse(imap[cmd], words)
                    instructions.append(instr)

                    # Check for no trailing arguments
                    if (len(words) != 0 and not words[0].startswith("#")):
                        print("Extra text found at end of line")
                        print(line)
                        exit(1)

                    # Add instruction information
                    instructions[-1].line = line
                    instructions[-1].info = imap[cmd]
                    instructions[-1].addr = addr

                    addr = addr + 1
    except IOError as e:
        print("Failed opening input file")
        print(f'Error : {e}')
        exit(1)
    except Exception as e:
        print("Failed parsing input file")
        print(f'Error : {e}')
        exit(1)

    # Write output file
    try:
        # Open output file
        with open(options.o, "w") as file:
            DEBUG("Converting to machine code")

            # Convert each instruction to machine code and write to output file
            for instr in instructions:
                machcode = to_machine(instr, bmap)
                file.write(f'{machcode:0{OUTPUT_WIDTH}x}\n')
                DEBUG(f'Line \"{instr.line.strip()}\" encodes as 0x{machcode:0{OUTPUT_WIDTH}x}')
    except IOError as e:
        print("Failed opening output file")
        print(f'Error: {e}')
        exit(1)
    except Exception as e:
        print("Failed writing output file")
        print(f'Error : {e}')
        exit(1)
    except ValueError as e: 
        print("Your file is empty")
        print(f'Error {e}')
        exit(1)