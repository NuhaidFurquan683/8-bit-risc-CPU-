`timescale 1ns / 1ps

module fullAdder (
    input  logic a,         // First input bit
    input  logic b,         // Second input bit
    input  logic carryIn,   // Carry input from previous stage
    output logic sum,       // Sum output
    output logic carryOut   // Carry output to next stage
);
    logic i, j, k, l;
    
    xor g0 (i, a, b);
    xor g1 (sum, i, carryIn);
    and g2 (j, a, b);
    and g3 (k, a, carryIn);
    and g4 (l, b, carryIn);
    
    or  g5 (carryOut, j, k, l);
endmodule

