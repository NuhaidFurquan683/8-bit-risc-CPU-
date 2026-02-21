module test_program_counter();
    // signals for testing
    logic Clock;
    logic nReset;
    logic Taken;
    logic [7:0] Bamt;
    logic [7:0] PC;

    // connect my program counter module
    program_counter uut (
        .Clock(Clock),
        .nReset(nReset),
        .Taken(Taken),
        .Bamt(Bamt),
        .PC(PC)
    );

    // make the clock go up and down every 5ns
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end

    // run the tests
    initial begin
        // start everything at 0
        nReset = 1;
        Taken = 0;
        Bamt = 8'd0;

        #2;

        // TEST 1: reset the PC
        nReset = 0;  // reset on
        #10;
        nReset = 1;  // reset off
        #10;
        // PC should be 0 now

        // TEST 2: just count up normally
        Taken = 0;
        #10; // PC = 1
        #10; // PC = 2
        #10; // PC = 3
        #10; // PC = 4

        // TEST 3: try a branch (jump forward)
        Taken = 1;      // branch taken
        Bamt = 8'd10;   // jump 10 forward
        #10; // PC should be 14 now (4 + 10)

        // TEST 4: back to normal counting
        Taken = 0;
        #10; // PC = 15
        #10; // PC = 16

        // TEST 5: another branch
        Taken = 1;
        Bamt = 8'd20;
        #10; // PC = 36 (16 + 20)

        // TEST 6: try a backwards branch (negative number)
        Taken = 1;
        Bamt = 8'b11110110; // this is -10
        #10; // PC = 26 (36 - 10)

        // TEST 7: count up again
        Taken = 0;
        #10; // PC = 27
        #10; // PC = 28

        // TEST 8: big jump forward
        Taken = 1;
        Bamt = 8'd100;
        #10; // PC = 128 (28 + 100)

        // TEST 9: reset in the middle
        #10;
        nReset = 0;
        #10;
        nReset = 1;
        #10; // PC back to 0

        // TEST 10: keep going from 0
        Taken = 0;
        #10; // PC = 1
        #10; // PC = 2

        // TEST 11: branch by 1 (same as counting)
        Taken = 1;
        Bamt = 8'd1;
        #10; // PC = 3

        // TEST 12: really big jump
        Bamt = 8'd200;
        #10; // PC = 203

        // End simulation
        #20;

        #10000;  // Hold waveforms for 10000 time units
        $finish;
    end
endmodule