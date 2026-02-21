module test_alu();
    // signals
    logic [2:0] ALUOp;
    logic [7:0] A;
    logic [7:0] B;
    logic [7:0] result;
    logic Zero;
    logic Carry;
    
    // connect the ALU
    alu uut (
        .ALUOp(ALUOp),
        .A(A),
        .B(B),
        .result(result),
        .Zero(Zero),
        .Carry(Carry)
    );
    
    // tests
    initial begin
        // start at 0
        ALUOp = 3'b000;
        A = 8'd0;
        B = 8'd0;
        
        #10;
        
        // TEST 1: PASSTHROUGH (just output B)
        ALUOp = 3'b000;
        A = 8'd100;
        B = 8'd50;
        #10; // result should be 50
        
        B = 8'd0;
        #10; // result = 0, Zero = 1
        
        B = 8'd255;
        #10; // result = 255
        
        // TEST 2: OR operation
        ALUOp = 3'b001;
        A = 8'b10101010;
        B = 8'b01010101;
        #10; // result = 255 (all 1s)
        
        A = 8'b11110000;
        B = 8'b00001111;
        #10; // result = 255
        
        A = 8'd0;
        B = 8'd0;
        #10; // result = 0
        
        // TEST 3: ADD
        ALUOp = 3'b010;
        A = 8'd50;
        B = 8'd30;
        #10; // result = 80
        
        A = 8'd100;
        B = 8'd100;
        #10; // result = 200
        
        A = 8'd200;
        B = 8'd100;
        #10; // result = 44 (wraps around), Carry = 1
        
        A = 8'd255;
        B = 8'd1;
        #10; // result = 0 (overflow), Zero = 1, Carry = 1
        
        A = 8'd128;
        B = 8'd128;
        #10; // result = 0, Carry = 1
        
        // TEST 4: SUB
        ALUOp = 3'b011;
        A = 8'd100;
        B = 8'd50;
        #10; // result = 50
        
        A = 8'd50;
        B = 8'd50;
        #10; // result = 0
        
        A = 8'd30;
        B = 8'd50;
        #10; // result = 236 (goes negative, wraps)
        
        A = 8'd0;
        B = 8'd1;
        #10; // result = 255 (wraps)
        
        A = 8'd255;
        B = 8'd255;
        #10; // result = 0
        
        // TEST 5: AND
        ALUOp = 3'b100;
        A = 8'b11110000;
        B = 8'b10101010;
        #10; // result = 160
        
        A = 8'b11111111;
        B = 8'b10101010;
        #10; // result = 170
        
        A = 8'd255;
        B = 8'd0;
        #10; // result = 0
        
        A = 8'b11110000;
        B = 8'b00001111;
        #10; // result = 0
        
        // TEST 6: XOR
        ALUOp = 3'b101;
        A = 8'b10101010;
        B = 8'b01010101;
        #10; // result = 255
        
        A = 8'b11110000;
        B = 8'b11110000;
        #10; // result = 0 (same number XOR = 0)
        
        A = 8'b11001100;
        B = 8'b10101010;
        #10; // result = 102
        
        A = 8'd255;
        B = 8'd255;
        #10; // result = 0
        
        // TEST 7: SHIFT LEFT
        ALUOp = 3'b110;
        A = 8'b00000001;
        B = 8'd1;
        #10; // result = 2
        
        A = 8'b00000001;
        B = 8'd4;
        #10; // result = 16
        
        A = 8'b10101010;
        B = 8'd2;
        #10; // result = 168
        
        A = 8'd255;
        B = 8'd1;
        #10; // result = 254
        
        A = 8'd128;
        B = 8'd1;
        #10; // result = 0 (bit falls off)
        
        // TEST 8: SHIFT RIGHT
        ALUOp = 3'b111;
        A = 8'b10000000;
        B = 8'd1;
        #10; // result = 64
        
        A = 8'b10000000;
        B = 8'd4;
        #10; // result = 8
        
        A = 8'b10101010;
        B = 8'd2;
        #10; // result = 42
        
        A = 8'd255;
        B = 8'd1;
        #10; // result = 127
        
        A = 8'd1;
        B = 8'd1;
        #10; // result = 0
        
        // more ADD tests
        ALUOp = 3'b010;
        A = 8'd127;
        B = 8'd127;
        #10; // result = 254
        
        A = 8'd127;
        B = 8'd128;
        #10; // result = 255
        
        A = 8'd127;
        B = 8'd129;
        #10; // result = 0, Carry = 1
        
        // more SUB tests
        ALUOp = 3'b011;
        A = 8'd255;
        B = 8'd1;
        #10; // result = 254
        
        A = 8'd128;
        B = 8'd64;
        #10; // result = 64
        
        // End simulation
        #20;

        #10000;  // Hold waveforms for 10000 time units
        $finish;
    end
endmodule