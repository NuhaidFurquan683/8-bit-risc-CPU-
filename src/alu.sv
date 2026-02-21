module alu (
    input  logic [2:0] ALUOp,   // 3-bit operation selector
    input  logic [7:0] A,       // First operand
    input  logic [7:0] B,       // Second operand
    output logic [7:0] result,  // Operation result
    output logic Zero,    // 1 if result is zero
    output logic Carry    // Carry/borrow from arithmetic operations
);
    logic [7:0] add_result;     // Result from adder
    logic add_carry;      // Carry from adder
    logic [7:0] sub_result;     // Result from subtractor
    logic sub_carry;      // Carry from subtractor

    // Instantiate 8-bit adder/subtractor units
    adder_8bit adder (
        .A(A),
        .B(B),
        .sub(1'b0),             // Add mode
        .result(add_result),
        .carryOut(add_carry)
    );

    adder_8bit subtractor (
        .A(A),
        .B(B),
        .sub(1'b1),             // Subtract mode
        .result(sub_result),
        .carryOut(sub_carry)
    );

    // Main ALU operation selector
    always_comb begin
        // Default values to prevent latches
        result = 8'b0;
        Carry = 1'b0;

        case (ALUOp)
            3'b000: begin // Passthrough: result = B
                result = B;
            end

            3'b001: begin // OR: result = A | B
                result = A | B;
            end

            3'b010: begin // ADD: result = A + B
                result = add_result;
                Carry = add_carry;
            end

            3'b011: begin // SUB: result = A - B
                result = sub_result;
                Carry = sub_carry;
            end

            3'b100: begin // AND: result = A & B
                result = A & B;
            end

            3'b101: begin // XOR: result = A ^ B
                result = A ^ B;
            end

            3'b110: begin // Shift Left: result = A << B
                result = A << B;
            end

            3'b111: begin // Shift Right: result = A >> B
                result = A >> B;
            end

            default: begin
                result = 8'b0;
            end
        endcase
    end

    // Zero flag: set when result is all zeros
    assign Zero = (result == 8'b0);
endmodule