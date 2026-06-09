`timescale 1ns/1ns

module top_tb;

reg clk;
reg rst;

reg programming_mode;
reg [15:0] load_add;
reg [23:0] instr_load;

top dut(
    .clk(clk),
    .rst(rst),
    .programming_mode(programming_mode),
    .load_add(load_add),
    .instr_load(instr_load)
);

//--------------------------------------------------
// Clock
//--------------------------------------------------

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

//--------------------------------------------------
// Loader
//--------------------------------------------------

task load_instruction;
input [15:0] address;
input [23:0] instruction;
begin
    @(posedge clk);
    load_add   = address;
    instr_load = instruction;
end
endtask

//--------------------------------------------------
// Test Program
//--------------------------------------------------

initial begin

    rst = 1'b0;
    programming_mode = 1'b0;
    load_add = 16'd0;
    instr_load = 24'd0;

    repeat(2) @(posedge clk);
    programming_mode = 1'b1;

    //--------------------------------------------------
    // Arithmetic
    //--------------------------------------------------

    // ADD  R3 = R1 + R2
    load_instruction(16'd0,{5'b00000,5'd3,5'd1,5'd2,4'd0});

    // SUB  R4 = R1 - R2
    load_instruction(16'd1,{5'b00001,5'd2,5'd2,5'd3,4'd0});

    // ADDI R5 = R1 + 10
    load_instruction(16'd2,{5'b00010,5'd5,5'd2,1'b0,8'd10});

    // SUBI R6 = R1 - 20
    load_instruction(16'd3,{5'b00011,5'd6,5'd1,1'b0,8'd20});

    //--------------------------------------------------
    // Logical
    //--------------------------------------------------

    // AND
    load_instruction(16'd4,{5'b00100,5'd7,5'd1,5'd2,4'd0});

    // OR
    load_instruction(16'd5,{5'b00101,5'd8,5'd1,5'd2,4'd0});

    // XOR
    load_instruction(16'd6,{5'b00110,5'd9,5'd1,5'd2,4'd0});

    // NOT
    load_instruction(16'd7,{5'b00111,5'd10,5'd1,9'd0});

    //--------------------------------------------------
    // Shifts
    //--------------------------------------------------

    // SHL R11 = R1 << 2
    load_instruction(16'd8,{5'b01000,5'd11,5'd1,5'd0,4'd2});

    // SHR R12 = R1 >> 2
    load_instruction(16'd9,{5'b01001,5'd12,5'd1,5'd0,4'd2});

    //--------------------------------------------------
    // Compare
    //--------------------------------------------------

    // CMP R1,R2
    load_instruction(16'd10,{5'b01010,5'd1,5'd2,9'd0});

    //--------------------------------------------------
    // Memory
    //--------------------------------------------------

    // STORE MEM[R1] = R2
    load_instruction(16'd11,{5'b01100,5'd1,5'd2,9'd0});

    // LOAD R13 = MEM[R1]
    load_instruction(16'd12,{5'b01011,5'd13,5'd1,9'd0});

    //--------------------------------------------------
    // Branch Tests
    //--------------------------------------------------

    // CMP R1,R1
    load_instruction(16'd13,{5'b01010,5'd1,5'd1,9'd0});

    // BEQ -> 20
    load_instruction(16'd14,{5'b01110,3'd0,16'd20});

    // skipped if BEQ works
    load_instruction(16'd15,{5'b00010,5'd20,5'd0,1'b0,8'd99});

    //--------------------------------------------------
    // Target 20
    //--------------------------------------------------

    // CMP R1,R2
    load_instruction(16'd20,{5'b01010,5'd1,5'd2,9'd0});

    // BNE -> 25
    load_instruction(16'd21,{5'b01111,3'd0,16'd25});

    load_instruction(16'd22,{5'b00010,5'd21,5'd0,1'b0,8'd88});

    //--------------------------------------------------
    // Target 25
    //--------------------------------------------------

    // CMP R2,R1
    load_instruction(16'd25,{5'b01010,5'd2,5'd1,9'd0});

    // BLT -> 30
    load_instruction(16'd26,{5'b10000,3'd0,16'd30});

    //--------------------------------------------------
    // Target 30
    //--------------------------------------------------

    // CMP R1,R2
    load_instruction(16'd30,{5'b01010,5'd1,5'd2,9'd0});

    // BGT -> 35
    load_instruction(16'd31,{5'b10010,3'd0,16'd35});

    //--------------------------------------------------
    // Target 35
    //--------------------------------------------------

    // JMP 40
    load_instruction(16'd35,{5'b01101,3'd0,16'd40});

    //--------------------------------------------------
    // Final Target
    //--------------------------------------------------

    // ADDI R31,R0,55
    load_instruction(16'd40,{5'b00010,5'd31,5'd0,1'b0,8'd55});

    @(posedge clk);

    programming_mode = 1'b0;

    //--------------------------------------------------
    // Execute
    //--------------------------------------------------

    repeat(300) @(posedge clk);

    $finish;

end

//--------------------------------------------------
// Monitor
//--------------------------------------------------

initial begin

$display("TIME\tPC\tSTATE\tOP\tALU\tEQ\tLT\tGT");

$monitor("%0t\t%0d\t%0d\t%0h\t%0d\t%b\t%b\t%b",
    $time,
    dut.pc_address,
    dut.ctrl_unit.state,
    dut.op_code,
    dut.alu_out,
    dut.equal_flag,
    dut.less_than_flag,
    dut.greater_than_flag
);

end

endmodule