module instruction_memory(
    input logic [7:0] PC,
    output logic [15:0] Instr
);

 // Unpacked array: 256 locations, each holding a 16-bit instruction
    logic [15:0] memory [0:255];

    // Combinational read: output instruction at current PC address
    assign Instr = memory[PC];
endmodule