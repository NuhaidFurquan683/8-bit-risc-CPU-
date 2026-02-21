module test_decoder();
    // signals
    logic [3:0] Opcode;
    logic [2:0] ALUOp;
    logic WB;
    logic ImmEnable;
    logic ImmType;
    logic Branch;
    
    // connect decoder
    decoder uut (
        .Opcode(Opcode),
        .ALUOp(ALUOp),
        .WB(WB),
        .ImmEnable(ImmEnable),
        .ImmType(ImmType),
        .Branch(Branch)
    );
    
    // tests
    initial begin
        Opcode = 4'b0000;
        
        #10;
        
        // TEST 1: beqz (branch if zero)
        Opcode = 4'b0000;
        #10;
        // should get: ALUOp=000, WB=0, ImmEnable=0, Branch=1
        
        // TEST 2: or
        Opcode = 4'b0001;
        #10;
        // should get: ALUOp=001, WB=1, ImmEnable=0, Branch=0
        
        // TEST 3: add
        Opcode = 4'b0010;
        #10;
        // should get: ALUOp=010, WB=1, ImmEnable=0, Branch=0
        
        // TEST 4: sub
        Opcode = 4'b0011;
        #10;
        // should get: ALUOp=011, WB=1, ImmEnable=0, Branch=0
        
        // TEST 5: and
        Opcode = 4'b0100;
        #10;
        // should get: ALUOp=100, WB=1, ImmEnable=0, Branch=0
        
        // TEST 6: xor
        Opcode = 4'b0101;
        #10;
        // should get: ALUOp=101, WB=1, ImmEnable=0, Branch=0
        
        // TEST 7: sll (shift left)
        Opcode = 4'b0110;
        #10;
        // should get: ALUOp=110, WB=1, ImmEnable=0, Branch=0
        
        // TEST 8: srl (shift right)
        Opcode = 4'b0111;
        #10;
        // should get: ALUOp=111, WB=1, ImmEnable=0, Branch=0
        
        // TEST 9: li (load immediate)
        Opcode = 4'b1000;
        #10;
        // should get: ALUOp=000, WB=1, ImmEnable=1, ImmType=1, Branch=0
        
        // TEST 10: ori (or immediate)
        Opcode = 4'b1001;
        #10;
        // should get: ALUOp=001, WB=1, ImmEnable=1, ImmType=0, Branch=0
        
        // TEST 11: addi (add immediate)
        Opcode = 4'b1010;
        #10;
        // should get: ALUOp=010, WB=1, ImmEnable=1, ImmType=0, Branch=0
        
        // TEST 12: subi (subtract immediate)
        Opcode = 4'b1011;
        #10;
        // should get: ALUOp=011, WB=1, ImmEnable=1, ImmType=0, Branch=0
        
        // TEST 13: andi (and immediate)
        Opcode = 4'b1100;
        #10;
        // should get: ALUOp=100, WB=1, ImmEnable=1, ImmType=0, Branch=0
        
        // TEST 14: xori (xor immediate)
        Opcode = 4'b1101;
        #10;
        // should get: ALUOp=101, WB=1, ImmEnable=1, ImmType=0, Branch=0
        
        // TEST 15: slli (shift left immediate)
        Opcode = 4'b1110;
        #10;
        // should get: ALUOp=110, WB=1, ImmEnable=1, ImmType=0, Branch=0
        
        // TEST 16: srli (shift right immediate)
        Opcode = 4'b1111;
        #10;
        // should get: ALUOp=111, WB=1, ImmEnable=1, ImmType=0, Branch=0
        
        // go through all opcodes again to double check
        Opcode = 4'b0000; #10;
        Opcode = 4'b0001; #10;
        Opcode = 4'b0010; #10;
        Opcode = 4'b0011; #10;
        Opcode = 4'b0100; #10;
        Opcode = 4'b0101; #10;
        Opcode = 4'b0110; #10;
        Opcode = 4'b0111; #10;
        Opcode = 4'b1000; #10;
        Opcode = 4'b1001; #10;
        Opcode = 4'b1010; #10;
        Opcode = 4'b1011; #10;
        Opcode = 4'b1100; #10;
        Opcode = 4'b1101; #10;
        Opcode = 4'b1110; #10;
        Opcode = 4'b1111; #10;
        
        // End simulation
        #20;

        #10000;  // Hold waveforms for 10000 time units
        $finish;
    end
endmodule