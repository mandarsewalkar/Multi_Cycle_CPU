`timescale 1ns/1ns

module decoder(
    input [23:0] instr_in,
    output reg [3:0] alu_code,
    output reg [4:0] op_code,
    output reg [4:0] rd,
    output reg [4:0] rs1,
    output reg [4:0] rs2,
    output reg [7:0] immediate,
    output reg [15:0] label
);

// * Instruction set 
//     - ALU
//         1. ADD  0x00000
//         2. SUB  0x00001
//         3. ADDI  0x00010
//         4. SUBI  0x00011

//     - Logical
//         1. AND  0x00100
//         2. OR  0x00101
//         3. XOR  0x00110
//         4. NOT  0x00111
//         5. SHL 0x01000
//         6. SHR 0x01001

//     - Comparison

//         1. CMP 0x01010

//     - Data Movement
//         1. LOAD  0x01011
//         2. STORE  0x01100
       
//    - Flow control
//         1. JMP  0x01101
//         2. BEQ  0x01110
//         3. BNE  0x01111
//         4. BLT 0x10000
//         5. BLE 0x10001
//         6. BHT 0x10010
//         7. BHE 0x10011

always@(*)
begin

    //initialization
    alu_code = 4'd0;
    rd = 5'd0;
    rs1 = 5'd0;
    rs2 = 5'd0;
    label = 16'd0;
    immediate = 8'd0;

    op_code = instr_in[23:19];

    case(instr_in[23:19])

    // ADD
    5'b00000: begin 
        alu_code = 4'd0;
        rd  = instr_in[18:14];
        rs1 = instr_in[13:9];
        rs2 = instr_in[8:4];
    end

    // SUB
    5'b00001: begin
        alu_code = 4'd1;
        rd  = instr_in[18:14];
        rs1 = instr_in[13:9];
        rs2 = instr_in[8:4];
    end

    // ADDI
    5'b00010: begin 
        alu_code = 4'd0;
        rd  = instr_in[18:14];
        rs1 = instr_in[13:9];
        immediate = instr_in[7:0];
    end

    // SUBI
    5'b00011: begin
        alu_code = 4'd1;
        rd  = instr_in[18:14];
        rs1 = instr_in[13:9];
        immediate = instr_in[7:0];
    end

    // AND
    5'b00100: begin
        alu_code = 4'd2;
        rd  = instr_in[18:14];
        rs1 = instr_in[13:9];
        rs2 = instr_in[8:4];
    end

    // OR
    5'b00101: begin
        alu_code = 4'd3;
        rd  = instr_in[18:14];
        rs1 = instr_in[13:9];
        rs2 = instr_in[8:4];
    end

    // XOR
    5'b00110: begin
        alu_code = 4'd4;
        rd  = instr_in[18:14];
        rs1 = instr_in[13:9];
        rs2 = instr_in[8:4];
    end

    // NOT
    5'b00111: begin
        alu_code = 4'd5;
        rd = instr_in[18:14];
        rs1 = instr_in[13:9];
    end

    // SHL
    5'b01000: begin
        alu_code = 4'd7;
        rd = instr_in[18:14];
        rs1 = instr_in[13:9];
        immediate = instr_in[3:0];
    end

    // SHR
    5'b01001: begin
        alu_code = 4'd8;
        rd = instr_in[18:14];
        rs1 = instr_in[13:9];
        immediate = instr_in[3:0];
    end

    // CMP
    5'b01010: begin
        alu_code = 4'd9;
        rs1 = instr_in[18:14];
        rs2 = instr_in[13:9];
    end
    
    // LOAD
    5'b01011: begin
        alu_code = 4'd6;
        rd = instr_in[18:14];
        rs1 = instr_in[13:9];
    end

    // STORE
    5'b01100: begin
        alu_code = 4'd6;
        rs1 = instr_in[18:14];
        rs2 = instr_in[13:9];
    end

    // JUMP
    5'b01101,
    5'b01110,
    5'b01111,
    5'b10000,
    5'b10001,
    5'b10010,
    5'b10011: begin
        alu_code = 4'b1111;
        label = instr_in[15:0];
    end


    endcase
end

endmodule