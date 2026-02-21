module program_counter (
    input  logic Clock,      // System clock signal
    input  logic nReset,     // Active-low reset (0 = reset, 1 = normal)
    input  logic Taken,      // Branch taken signal (1 = take branch)
    input  logic [7:0] Bamt,       // Branch amount (signed, how far to jump)
    output logic [7:0] PC          // Current program counter value
);
    // Sequential logic: updates on rising edge of clock or falling edge of reset
    always_ff @(posedge Clock or negedge nReset) begin
        if (!nReset) begin
            // Reset: set PC back to address 0 (start of program)
            PC <= 8'b0;
        end else begin
            if (Taken) begin
                // Branch taken: add signed branch amount to PC
                PC <= PC + Bamt;
            end else begin
                // Normal execution: increment PC by 1
                PC <= PC + 8'd1;
            end
        end
    end
endmodule