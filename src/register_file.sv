module register_file (
    input  logic Clock,      // System clock
    input  logic nReset,     // Active-low reset
    input  logic WB,         // Write-back enable
    input  logic [3:0]  Rd,         // Destination register address (write)
    input  logic [3:0]  Ra,         // Source register A address (read)
    input  logic [3:0]  Rb,         // Source register B address (read)
    input  logic [7:0]  Data,       // Data to write to Rd
    output logic [7:0]  A,          // Output: data from register Ra
    output logic [7:0]  B,          // Output: data from register Rb
    output logic [7:0]  LED0,       // Output: value of R14 (for LED display)
    output logic [7:0]  LED1        // Output: value of R15 (for LED display)
);
    // Register array: 16 registers, each 8 bits wide
    logic [7:0] registers [0:15];

    // Synchronous write: update register on rising clock edge
    always_ff @(posedge Clock or negedge nReset) begin
        if (!nReset) begin
            // Reset: clear all registers to 0
            for (int i = 0; i < 16; i++) begin
                registers[i] <= 8'b0;
            end
        end else begin
            // Write to register if WB is enabled and destination is not R0 or R1
            if (WB && (Rd != 4'd0) && (Rd != 4'd1)) begin
                registers[Rd] <= Data;
            end
        end
    end

    // Combinational read: output register values immediately
    always_comb begin
        // Read port A
        if (Ra == 4'd0) begin
            A = 8'b0;               // R0 always reads as 0
        end else if (Ra == 4'd1) begin
            A = 8'b00000001;        // R1 always reads as 1
        end else begin
            A = registers[Ra];      // Read from register array
        end

        // Read port B
        if (Rb == 4'd0) begin
            B = 8'b0;               // R0 always reads as 0
        end else if (Rb == 4'd1) begin
            B = 8'b00000001;        // R1 always reads as 1
        end else begin
            B = registers[Rb];      // Read from register array
        end
    end

    // LED outputs: always show R14 and R15 values
    // Note: After reset, these will be 0 until written to
    assign LED0 = registers[14];
    assign LED1 = registers[15];
endmodule