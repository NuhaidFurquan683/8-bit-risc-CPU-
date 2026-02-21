module test_register_file();
    // signals
    logic Clock;
    logic nReset;
    logic WB;
    logic [3:0] Rd;
    logic [3:0] Ra;
    logic [3:0] Rb;
    logic [7:0] Data;
    logic [7:0] A;
    logic [7:0] B;
    logic [7:0] LED0;
    logic [7:0] LED1;
    
    // connect register file
    register_file uut (
        .Clock(Clock),
        .nReset(nReset),
        .WB(WB),
        .Rd(Rd),
        .Ra(Ra),
        .Rb(Rb),
        .Data(Data),
        .A(A),
        .B(B),
        .LED0(LED0),
        .LED1(LED1)
    );
    
    // clock
    initial begin
        Clock = 0;
        forever #5 Clock = ~Clock;
    end
    
    // tests
    initial begin
        // start everything
        nReset = 1;
        WB = 0;
        Rd = 4'd0;
        Ra = 4'd0;
        Rb = 4'd0;
        Data = 8'd0;
        
        #2;
        
        // TEST 1: reset
        nReset = 0;
        #10;
        nReset = 1;
        #10;
        // all registers should be 0
        
        // TEST 2: read R0 and R1
        Ra = 4'd0;
        Rb = 4'd1;
        #10;
        // A should be 0, B should be 1
        
        // TEST 3: write 42 to R2
        WB = 1;
        Rd = 4'd2;
        Data = 8'd42;
        #10;
        WB = 0;
        Ra = 4'd2;
        #10;
        // A should be 42
        
        // TEST 4: write 100 to R3
        WB = 1;
        Rd = 4'd3;
        Data = 8'd100;
        #10;
        WB = 0; 
        Ra = 4'd3;
        #10;
        // A should be 100
        
        // TEST 5: read R2 and R3 at same time
        Ra = 4'd2;
        Rb = 4'd3;
        #10;
        // A = 42, B = 100
        
        // TEST 6: write to a bunch of registers
        WB = 1;
        Rd = 4'd4; Data = 8'd10; #10;
        Rd = 4'd5; Data = 8'd20; #10;
        Rd = 4'd6; Data = 8'd30; #10;
        Rd = 4'd7; Data = 8'd40; #10;
        WB = 0;
        
        // read them back
        Ra = 4'd4; Rb = 4'd5; #10; // A=10, B=20
        Ra = 4'd6; Rb = 4'd7; #10; // A=30, B=40
        
        // TEST 7: try to write to R0 (shouldn't work)
        WB = 1;
        Rd = 4'd0;
        Data = 8'd255;
        #10;
        WB = 0;
        Ra = 4'd0;
        #10;
        // A should still be 0
        
        // TEST 8: try to write to R1 (shouldn't work)
        WB = 1;
        Rd = 4'd1;
        Data = 8'd255;
        #10;
        WB = 0;
        Ra = 4'd1;
        #10;
        // A should still be 1
        
        // TEST 9: write to LED registers R14 and R15
        WB = 1;
        Rd = 4'd14;
        Data = 8'b10101010;
        #10;
        Rd = 4'd15;
        Data = 8'b11110000;
        #10;
        WB = 0;
        #10;
        // LED0 = 10101010, LED1 = 11110000
        
        // read them
        Ra = 4'd14;
        Rb = 4'd15;
        #10;
        // A = 10101010, B = 11110000
        
        // TEST 10: write when WB is off (nothing should happen)
        WB = 0;
        Rd = 4'd8;
        Data = 8'd99;
        #10;
        Ra = 4'd8;
        #10;
        // A should be 0 (nothing was written)
        
        // TEST 11: overwrite R2
        WB = 1;
        Rd = 4'd2;
        Data = 8'd200;
        #10;
        WB = 0;
        Ra = 4'd2;
        #10;
        // A = 200 now
        
        // TEST 12: write and read same time
        WB = 1;
        Rd = 4'd9;
        Data = 8'd55;
        Ra = 4'd9;
        #5;
        // A = 0 (hasn't written yet)
        #5;
        WB = 0;
        #10;
        // A = 55 (now it's written)
        
        // TEST 13: fill up all the registers
        WB = 1;
        Rd = 4'd2;  Data = 8'd2;  #10;
        Rd = 4'd3;  Data = 8'd3;  #10;
        Rd = 4'd4;  Data = 8'd4;  #10;
        Rd = 4'd5;  Data = 8'd5;  #10;
        Rd = 4'd6;  Data = 8'd6;  #10;
        Rd = 4'd7;  Data = 8'd7;  #10;
        Rd = 4'd8;  Data = 8'd8;  #10;
        Rd = 4'd9;  Data = 8'd9;  #10;
        Rd = 4'd10; Data = 8'd10; #10;
        Rd = 4'd11; Data = 8'd11; #10;
        Rd = 4'd12; Data = 8'd12; #10;
        Rd = 4'd13; Data = 8'd13; #10;
        WB = 0;
        
        // check them
        Ra = 4'd2;  Rb = 4'd3;  #10; // A=2,  B=3
        Ra = 4'd4;  Rb = 4'd5;  #10; // A=4,  B=5
        Ra = 4'd6;  Rb = 4'd7;  #10; // A=6,  B=7
        Ra = 4'd8;  Rb = 4'd9;  #10; // A=8,  B=9
        Ra = 4'd10; Rb = 4'd11; #10; // A=10, B=11
        Ra = 4'd12; Rb = 4'd13; #10; // A=12, B=13
        
        // TEST 14: reset clears everything
        nReset = 0;
        #10;
        nReset = 1;
        #10;
        
        // check they're all 0
        Ra = 4'd2;  Rb = 4'd3;  #10; // A=0, B=0
        Ra = 4'd14; Rb = 4'd15; #10; // A=0, B=0, LEDs=0
        
        // TEST 15: max value
        WB = 1;
        Rd = 4'd10;
        Data = 8'd255;
        #10;
        WB = 0;
        Ra = 4'd10;
        #10;
        // A = 255
        
        // TEST 16: min value
        WB = 1;
        Rd = 4'd11;
        Data = 8'd0;
        #10;
        WB = 0;
        Ra = 4'd11;
        #10;
        // A = 0
        
      // End simulation
        #20;

        #10000;  // Hold waveforms for 10000 time units
        $finish;
    end
endmodule