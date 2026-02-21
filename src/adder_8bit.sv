`timescale 1ns / 1ps

module adder_8bit (
    input  logic [7:0] A,
    input  logic [7:0] B,
    input  logic sub,
    output logic [7:0] result,
    output logic carryOut 
);

    logic [7:0] B_modified;     // B or ~B depending on add/subtract
    logic [7:0] carry;
    
    assign B_modified = sub ? ~B : B;
    
    fullAdder fa0 (
        .a(A[0]), 
        .b(B_modified[0]), 
        .carryIn(sub),        
        .sum(result[0]), 
        .carryOut(carry[0])
    );
    
    fullAdder fa1 (
        .a(A[1]), 
        .b(B_modified[1]), 
        .carryIn(carry[0]), 
        .sum(result[1]), 
        .carryOut(carry[1])
    );
    
    fullAdder fa2 (
        .a(A[2]), 
        .b(B_modified[2]), 
        .carryIn(carry[1]), 
        .sum(result[2]), 
        .carryOut(carry[2])
    );
    
    fullAdder fa3 (
        .a(A[3]), 
        .b(B_modified[3]), 
        .carryIn(carry[2]), 
        .sum(result[3]), 
        .carryOut(carry[3])
    );
    
    fullAdder fa4 (
        .a(A[4]), 
        .b(B_modified[4]), 
        .carryIn(carry[3]), 
        .sum(result[4]), 
        .carryOut(carry[4])
    );
    
    fullAdder fa5 (
        .a(A[5]), 
        .b(B_modified[5]), 
        .carryIn(carry[4]), 
        .sum(result[5]), 
        .carryOut(carry[5])
    );
    
    fullAdder fa6 (
        .a(A[6]), 
        .b(B_modified[6]), 
        .carryIn(carry[5]), 
        .sum(result[6]), 
        .carryOut(carry[6])
    );
    
    fullAdder fa7 (
        .a(A[7]), 
        .b(B_modified[7]), 
        .carryIn(carry[6]), 
        .sum(result[7]), 
        .carryOut(carry[7])
    );
    

    assign carryOut = carry[7];
endmodule

