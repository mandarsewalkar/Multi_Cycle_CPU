`timescale 1ns/1ns

//====================================================
// Registers
//====================================================

`define R0   5'd0
`define R1   5'd1
`define R2   5'd2
`define R3   5'd3
`define R4   5'd4
`define R5   5'd5
`define R6   5'd6
`define R7   5'd7
`define R8   5'd8
`define R9   5'd9
`define R10  5'd10
`define R11  5'd11
`define R12  5'd12
`define R13  5'd13
`define R14  5'd14
`define R15  5'd15
`define R16  5'd16
`define R17  5'd17
`define R18  5'd18
`define R19  5'd19
`define R20  5'd20
`define R21  5'd21
`define R22  5'd22
`define R23  5'd23
`define R24  5'd24
`define R25  5'd25
`define R26  5'd26
`define R27  5'd27
`define R28  5'd28
`define R29  5'd29
`define R30  5'd30
`define R31  5'd31

module top_instructions_tb;

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
// Tasks
//--------------------------------------------------

task ADD;
input [15:0] addr;
input [4:0] rd;
input [4:0] rs1;
input [4:0] rs2;
begin
    load_instruction(
        addr,
        {5'b00000,rd,rs1,rs2,4'd0}
    );
end
endtask

task SUB;
input [15:0] addr;
input [4:0] rd;
input [4:0] rs1;
input [4:0] rs2;
begin
    load_instruction(
        addr,
        {5'b00001,rd,rs1,rs2,4'd0}
    );
end
endtask

task ADDI;
input [15:0] addr;
input [4:0] rd;
input [4:0] rs1;
input [7:0] imm;
begin
    load_instruction(
        addr,
        {5'b00010,rd,rs1,1'b0,imm}
    );
end
endtask

task SUBI;
input [15:0] addr;
input [4:0] rd;
input [4:0] rs1;
input [7:0] imm;
begin
    load_instruction(
        addr,
        {5'b00011,rd,rs1,1'b0,imm}
    );
end
endtask

task AND_OP;
input [15:0] addr;
input [4:0] rd;
input [4:0] rs1;
input [4:0] rs2;
begin
    load_instruction(
        addr,
        {5'b00100,rd,rs1,rs2,4'd0}
    );
end
endtask

task OR_OP;
input [15:0] addr;
input [4:0] rd;
input [4:0] rs1;
input [4:0] rs2;
begin
    load_instruction(
        addr,
        {5'b00101,rd,rs1,rs2,4'd0}
    );
end
endtask

task XOR_OP;
input [15:0] addr;
input [4:0] rd;
input [4:0] rs1;
input [4:0] rs2;
begin
    load_instruction(
        addr,
        {5'b00110,rd,rs1,rs2,4'd0}
    );
end
endtask

task NOT_OP;
input [15:0] addr;
input [4:0] rd;
input [4:0] rs1;
begin
    load_instruction(
        addr,
        {5'b00111,rd,rs1,9'd0}
    );
end
endtask

task SHL;
input [15:0] addr;
input [4:0] rd;
input [4:0] rs1;
input [3:0] shamt;
begin
    load_instruction(
        addr,
        {5'b01000,rd,rs1,5'd0,shamt}
    );
end
endtask

task SHR;
input [15:0] addr;
input [4:0] rd;
input [4:0] rs1;
input [3:0] shamt;
begin
    load_instruction(
        addr,
        {5'b01001,rd,rs1,5'd0,shamt}
    );
end
endtask

task CMP;
input [15:0] addr;
input [4:0] rs1;
input [4:0] rs2;
begin
    load_instruction(
        addr,
        {5'b01010,rs1,rs2,9'd0}
    );
end
endtask

task LOAD;
input [15:0] addr;
input [4:0] rd;
input [4:0] rs1;
begin
    load_instruction(
        addr,
        {5'b01011,rd,rs1,9'd0}
    );
end
endtask

task STORE;
input [15:0] addr;
input [4:0] addr_reg;
input [4:0] data_reg;
begin
    load_instruction(
        addr,
        {5'b01100,addr_reg,data_reg,9'd0}
    );
end
endtask

task JMP;
input [15:0] addr;
input [15:0] label;
begin
    load_instruction(
        addr,
        {5'b01101,3'd0,label}
    );
end
endtask

task BEQ;
input [15:0] addr;
input [15:0] label;
begin
    load_instruction(
        addr,
        {5'b01110,3'd0,label}
    );
end
endtask

task BNE;
input [15:0] addr;
input [15:0] label;
begin
    load_instruction(
        addr,
        {5'b01111,3'd0,label}
    );
end
endtask

task BLT;
input [15:0] addr;
input [15:0] label;
begin
    load_instruction(
        addr,
        {5'b10000,3'd0,label}
    );
end
endtask

task BLE;
input [15:0] addr;
input [15:0] label;
begin
    load_instruction(
        addr,
        {5'b10001,3'd0,label}
    );
end
endtask

task BGT;
input [15:0] addr;
input [15:0] label;
begin
    load_instruction(
        addr,
        {5'b10010,3'd0,label}
    );
end
endtask

task BGE;
input [15:0] addr;
input [15:0] label;
begin
    load_instruction(
        addr,
        {5'b10011,3'd0,label}
    );
end
endtask



//--------------------------------------------------
// Test Program
//--------------------------------------------------

initial begin

    rst = 1'b1;
    programming_mode = 1'b0;
    load_add = 16'd0;
    instr_load = 24'd0;

    repeat(2) @(posedge clk);
    rst = 1'b0;
    programming_mode = 1'b1;


    //============== USER PROGRAM START ======================//


    // SEARCH IN ARRAY

    // CREATE ARRAY

    ADDI(0,`R1,`R0,0); // R1 = 0
    ADDI(1,`R2,`R0,99); // R2 = 99
    STORE(2,`R1,`R2); // STORE 99 AT MEM ADD 0

    ADDI(3,`R1,`R1,1); // INCREMENT R1
    ADDI(4,`R2,`R0,23);
    STORE(5,`R1,`R2); // STORE 23 AT MEM ADD 0

    ADDI(6,`R1,`R1,1); // INCREMENT R1
    ADDI(7,`R2,`R0,67);
    STORE(8,`R1,`R2); // STORE 67 AT MEM ADD 0

    ADDI(9,`R1,`R1,1); // INCREMENT R1
    ADDI(10,`R2,`R0,38);
    STORE(11,`R1,`R2); // STORE 38 AT MEM ADD 0

    ADDI(12,`R1,`R1,1); // INCREMENT R1
    ADDI(13,`R2,`R0,170);
    STORE(14,`R1,`R2); // STORE 170 AT MEM ADD 0

    ADDI(15,`R1,`R1,1); // INCREMENT R1
    ADDI(16,`R2,`R0,4);
    STORE(17,`R1,`R2); // STORE 4 AT MEM ADD 0


    ADDI(18,`R1,`R0,0);
    LOAD(19,`R10,`R1); // INITIALIZATION

    ADDI(20,`R11,`R0,1); // I = 1
    ADDI(21,`R12,`R0,5); // MAX INDEX

    LOAD(22,`R13,`R11);

    CMP(23,`R13,`R10);
    BGT(24,27); // OVER-WRITE 

    JMP(25,29); // CONTINUE

    ADDI(27,`R10,`R13,0); // OVER-WRITING BIGGER NUMBER

    ADDI(29,`R11,`R11,1); // INCREMENT I

    CMP(30,`R11,`R12);
    BLE(31,22); // LOOP EXIT CONDITION
    
    //============== USER PROGRAM END ======================//

    @(posedge clk);

    programming_mode = 1'b0;

    //--------------------------------------------------
    // Execute
    //--------------------------------------------------

    repeat(2000) @(posedge clk);

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