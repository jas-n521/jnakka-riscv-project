/*Simple end-of-run testbench to see if CPU has the correct values saved to each register by the end of an assembly program,
  also makes sure CPU didn't alter any registers it wasn't supposed to. */

module endofrun_tb;

logic rst;
logic clk = 0;
always #5 clk = ~clk;   // toggles every 5 time units, so the period is 10

CPU cpu_run (
    .clk(clk),
    .rst(rst)
);

int fails = 0;

initial begin
    $dumpfile("dump.vcd");          // file the waveform is saved to
    $dumpvars(0, endofrun_tb);      // record every signal in the testbench and everything below it

    rst = 1;
    repeat(2) @(posedge clk);
    rst = 0;

    repeat(30) @(posedge clk); // program should take about 15 cycles to run (18 instr., 3 skipped). We check after 30 cycles for good measure.
    #1;

    // Check registers that should be written!
    if (cpu_run.dp.rf_top.file[1] == 5)  
        $display("PASS: x1 = 5");
    else begin 
        $display("FAIL: x1 = %0d (expected 5)",  cpu_run.dp.rf_top.file[1]); fails++; 
    end

    if (cpu_run.dp.rf_top.file[2] == 10) 
        $display("PASS: x2 = 10");
    else begin 
        $display("FAIL: x2 = %0d (expected 10)", cpu_run.dp.rf_top.file[2]); fails++; 
    end

    if (cpu_run.dp.rf_top.file[3] == 15) 
        $display("PASS: x3 = 15");
    else begin 
        $display("FAIL: x3 = %0d (expected 15)", cpu_run.dp.rf_top.file[3]); fails++; 
    end

    if (cpu_run.dp.rf_top.file[4] == 5)  
        $display("PASS: x4 = 5");
    else begin 
        $display("FAIL: x4 = %0d (expected 5)",  cpu_run.dp.rf_top.file[4]); fails++; 
    end

    if (cpu_run.dp.rf_top.file[5] == 15) 
        $display("PASS: x5 = 15 (sw/lw round trip)");
    else begin 
        $display("FAIL: x5 = %0d (expected 15)", cpu_run.dp.rf_top.file[5]); fails++; 
    end

    if (cpu_run.dp.rf_top.file[7] == 7)  
        $display("PASS: x7 = 7 (beq not taken)");
    else begin 
        $display("FAIL: x7 = %0d (expected 7)",  cpu_run.dp.rf_top.file[7]); fails++; 
    end

    if (cpu_run.dp.rf_top.file[10] == 32'h3C) 
        $display("PASS: x10 = 0x3C (jal link)");
    else begin 
        $display("FAIL: x10 = 0x%08h (expected 0x0000003C)", cpu_run.dp.rf_top.file[10]); fails++; 
    end

    if (cpu_run.dp.rf_top.file[12] == 32'hFFFFFFFF) 
        $display("PASS: x12 = 0xFFFFFFFF (negative addi)");
    else begin 
        $display("FAIL: x12 = 0x%08h (expected 0xFFFFFFFF)", cpu_run.dp.rf_top.file[12]); fails++; 
    end

    // Check registers that should NOT be written!
    if (cpu_run.dp.rf_top.file[0] == 0)  
        $display("PASS: x0 = 0 (write blocked)");
    else begin 
        $display("FAIL: x0 = %0d (expected 0)",  cpu_run.dp.rf_top.file[0]); fails++; 
    end

    if (cpu_run.dp.rf_top.file[6] == 0)  
        $display("PASS: x6 = 0 (beq taken, skipped)");
    else begin 
        $display("FAIL: x6 = %0d (expected 0)",  cpu_run.dp.rf_top.file[6]); fails++; 
    end

    if (cpu_run.dp.rf_top.file[8] == 0)  
        $display("PASS: x8 = 0 (andi)");
    else begin 
        $display("FAIL: x8 = %0d (expected 0)",  cpu_run.dp.rf_top.file[8]); fails++; 
    end

    if (cpu_run.dp.rf_top.file[9] == 0)  
        $display("PASS: x9 = 0 (x0 compare, skipped)");
    else begin 
        $display("FAIL: x9 = %0d (expected 0)",  cpu_run.dp.rf_top.file[9]); fails++; 
    end

    if (cpu_run.dp.rf_top.file[11] == 0) 
        $display("PASS: x11 = 0 (jal jumped, skipped)");
    else begin 
        $display("FAIL: x11 = %0d (expected 0)", cpu_run.dp.rf_top.file[11]); fails++; 
    end

    // Check Memory and PC!
    if (cpu_run.ram.memory[1] == 15) 
        $display("PASS: mem[1] = 15 (sw)");
    else begin 
        $display("FAIL: mem[1] = %0d (expected 15)", cpu_run.ram.memory[1]); fails++; 
    end

    if (cpu_run.dp.pc == 32'h44) 
        $display("PASS: PC = 0x44 (reached final loop)");
    else begin 
        $display("FAIL: PC = 0x%08h (expected 0x00000044)", cpu_run.dp.pc); fails++; 
    end

    //Summary
    if (fails == 0) $display("\n*** ALL TESTS PASSED ***");
    else            $display("\n*** %0d TEST(S) FAILED ***", fails);

    $finish;

end 

endmodule