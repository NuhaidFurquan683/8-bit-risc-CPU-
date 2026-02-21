module decoder (
    input  logic [3:0] Opcode,      // 4-bit instruction opcode
    output logic [2:0] ALUOp,       // ALU operation code
    output logic WB,          // Write-back enable (1 = write to register)
    output logic ImmEnable,   // Immediate enable (1 = use immediate value)
    output logic ImmType,     // Immediate type (0 = I-type, 1 = L-type)
    output logic Branch       // Branch instruction flag
);
    // Combinational logic: decode opcode to control signals
    always_comb begin
        // Default values to prevent latches (CRITICAL for combinational logic)
        ALUOp = 3'b000;
        WB = 1'b0;
        ImmEnable = 1'b0;
        ImmType = 1'b0;
        Branch = 1'b0;

        case (Opcode)
            // B-type instruction
            4'b0000: begin // beqz - Branch if equal to zero
                ALUOp = 3'b000; // Passthrough
                WB = 1'b0;   // No write-back
                ImmEnable = 1'b0;   // No immediate
                ImmType = 1'b0;   // Don't care
                Branch = 1'b1;   // Is a branch
            end

            // R-type instructions (register to register operations)
            4'b0001: begin // or
                ALUOp = 3'b001;
                WB = 1'b1;
                ImmEnable = 1'b0;
                ImmType = 1'b0;
                Branch = 1'b0;
            end

            4'b0010: begin // add
                ALUOp = 3'b010;
                WB = 1'b1;
                ImmEnable = 1'b0;
                ImmType = 1'b0;
                Branch = 1'b0;
            end

            4'b0011: begin // sub
                ALUOp = 3'b011;
                WB = 1'b1;
                ImmEnable = 1'b0;
                ImmType = 1'b0;
                Branch = 1'b0;
            end

            4'b0100: begin // and
                ALUOp = 3'b100;
                WB = 1'b1;
                ImmEnable = 1'b0;
                ImmType = 1'b0;
                Branch = 1'b0;
            end

            4'b0101: begin // xor
                ALUOp = 3'b101;
                WB = 1'b1;
                ImmEnable = 1'b0;
                ImmType = 1'b0;
                Branch = 1'b0;
            end

            4'b0110: begin // sll - Shift left logical
                ALUOp = 3'b110;
                WB = 1'b1;
                ImmEnable = 1'b0;
                ImmType = 1'b0;
                Branch = 1'b0;
            end

            4'b0111: begin // srl - Shift right logical
                ALUOp = 3'b111;
                WB = 1'b1;
                ImmEnable = 1'b0;
                ImmType = 1'b0;
                Branch = 1'b0;
            end

            // L-type instruction
            4'b1000: begin // li - Load immediate
                ALUOp = 3'b000; // Passthrough
                WB = 1'b1;
                ImmEnable = 1'b1;
                ImmType = 1'b1;   // L-type immediate
                Branch = 1'b0;
            end

            // I-type instructions (immediate operations)
            4'b1001: begin // ori
                ALUOp = 3'b001;
                WB = 1'b1;
                ImmEnable = 1'b1;
                ImmType = 1'b0;   // I-type immediate
                Branch = 1'b0;
            end

            4'b1010: begin // addi
                ALUOp = 3'b010;
                WB= 1'b1;
                ImmEnable = 1'b1;
                ImmType = 1'b0;
                Branch = 1'b0;
            end

            4'b1011: begin // subi
                ALUOp = 3'b011;
                WB = 1'b1;
                ImmEnable = 1'b1;
                ImmType = 1'b0;
                Branch = 1'b0;
            end

            4'b1100: begin // andi
                ALUOp = 3'b100;
                WB = 1'b1;
                ImmEnable = 1'b1;
                ImmType = 1'b0;
                Branch = 1'b0;
            end

            4'b1101: begin // xori
                ALUOp = 3'b101;
                WB = 1'b1;
                ImmEnable = 1'b1;
                ImmType = 1'b0;
                Branch = 1'b0;
            end

            4'b1110: begin // slli
                ALUOp = 3'b110;
                WB = 1'b1;
                ImmEnable = 1'b1;
                ImmType = 1'b0;
                Branch = 1'b0;
            end

            4'b1111: begin // srli
                ALUOp = 3'b111;
                WB = 1'b1;
                ImmEnable = 1'b1;
                ImmType = 1'b0;
                Branch = 1'b0;
            end

            default: begin
                // Keep default values for unknown opcodes
            end
        endcase
    end
endmodule