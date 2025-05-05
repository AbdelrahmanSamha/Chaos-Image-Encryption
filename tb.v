`timescale 1ns/1ps

module tb();
    reg clk;
    reg rst;
    reg start;
    reg [7:0] block_idx_a;
    reg [7:0] block_idx_b;
    wire [255:0] hash_out;
    wire hash_valid;

    // Instantiate DUT
    toplevel dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .block_idx_a(block_idx_a),
        .block_idx_b(block_idx_b),
        .hash_out(hash_out),
        .hash_valid(hash_valid)
    );

    // Clock generation (100 MHz)
    initial begin
        clk = 0;
        rst = 1;
        #4 rst = 0;
    end
    
    always #5 clk = ~clk;

    // Test stimulus
    initial begin
        // Wait for reset release
        @(negedge rst);
        #20;

        //--------------------------------------------------------------------
        // Test Case 1: "abc"
        //--------------------------------------------------------------------
        $display("\n[TEST 1] 'abc'");
        block_idx_a = 8'd0;
        block_idx_b = 8'd1;
        start = 1;
        #10 start = 0;
        wait(hash_valid);
        #10;
        if(hash_out === 256'hba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad) begin
            $display("PASS: abc hash correct");
        end else begin
            $display("FAIL: abc");
            $display("Expected: ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad");
            $display("Received: %h", hash_out);
        end

        //--------------------------------------------------------------------
        // Test Case 2: Empty string
        //--------------------------------------------------------------------
        #100;
        $display("\n[TEST 2] Empty string");
        block_idx_a = 8'd2;
        block_idx_b = 8'd3;
        start = 1;
        #10 start = 0;
        wait(hash_valid);
        #10;
        if(hash_out === 256'he3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855) begin
            $display("PASS: empty string hash correct");
        end else begin
            $display("FAIL: empty string");
            $display("Expected: e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855");
            $display("Received: %h", hash_out);
        end

        //--------------------------------------------------------------------
        // Test Case 3: AbdelrahmanSamha2136821
        //--------------------------------------------------------------------
        #100;
        $display("\n[TEST 3] AbdelrahmanSamha2136821");
        block_idx_a = 8'd4;
        block_idx_b = 8'd5;
        start = 1;
        #10 start = 0;
        wait(hash_valid);
        #10;
        if(hash_out === 256'hd01bf890033d69a466c098fe235709546f452b2a7c0fc4391039602704faa953) begin
            $display("PASS: message hash correct");
        end else begin
            $display("FAIL: message");
            $display("Expected: 2262bcde23bbe32eaa9a7d0198a456b0deb05087a564b332e8454e7fed214360");
            $display("Received: %h", hash_out);
        end

        $finish;
    end

    

    // Timeout
    initial begin
        #500000;
        $display("Test timeout!");
        $finish;
    end
endmodule
