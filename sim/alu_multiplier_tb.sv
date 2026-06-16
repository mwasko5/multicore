`timescale 1ns / 1ps

module alu_multiplier_tb();

    // 1. Declare Testbench Signals
    logic        CLK;
    logic        RST_N;
    logic [63:0] IN_A;
    logic [63:0] IN_B;
    logic [63:0] OUTPUT;

    // 2. Instantiate the Device Under Test (DUT)
    alu_multiplier dut (
        .CLK(CLK),
        .RST_N(RST_N),
        .IN_A(IN_A),
        .IN_B(IN_B),
        .OUTPUT(OUTPUT)
    );

    // 3. Clock Generation (10ns period)
    always #5 CLK = ~CLK;

    // 4. Task to drive inputs and self-check the output
    task test_mult(input logic [63:0] a, input logic [63:0] b, input logic [63:0] expected);
        begin
            // Align with the clock edge and drive inputs
            @(posedge CLK);
            IN_A = a;
            IN_B = b;
            
            // Wait 3 clock cycles for the data to propagate through the pipeline
            repeat(3) @(posedge CLK);
            
            // Wait 1 timestep to safely sample the output after the clock edge
            #1; 
            
            // Check the result
            if (OUTPUT === expected) begin
                $display("[PASS] Time=%0t | A=%h, B=%h | Out=%h", $time, a, b, OUTPUT);
            end else begin
                $error("[FAIL] Time=%0t | A=%h, B=%h | Expected=%h, Got=%h", $time, a, b, expected, OUTPUT);
            end
        end
    endtask

    // 5. Main Stimulus Block
    initial begin
        // Initialize Signals
        CLK   = 0;
        RST_N = 0;
        IN_A  = '0;
        IN_B  = '0;

        $display("--- Starting ALU Multiplier Testbench ---");

        // Hold reset for a few cycles, then release
        #20;
        RST_N = 1;

        // Test Case 1: Simple small numbers (5 * 4 = 20)
        test_mult(64'd5, 64'd4, 64'd20);

        // Test Case 2: Zero multiplication
        test_mult(64'd100, 64'd0, 64'd0);

        // Test Case 3: Max 32-bit unsigned values (0xFFFFFFFF * 0xFFFFFFFF)
        // Expected result is 0xFFFFFFFE00000001
        test_mult(64'h00000000FFFFFFFF, 64'h00000000FFFFFFFF, 64'hFFFFFFFE00000001);

        // Test Case 4: Verify upper 32 bits are ignored
        // We put garbage hex data in the upper 32 bits, but only multiply 2 * 3
        test_mult(64'hDEADBEEF00000002, 64'hCAFEBABE00000003, 64'd6);

        $display("--- Testbench Complete ---");
        $finish;
    end

endmodule