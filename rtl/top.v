`timescale 1ns/1ns

module top(
    // General
    input clk,
    input rst,

    // Programming
    input programming_mode,
    input [15:0] load_add,
    input [23:0] instr_load
);

    // Program Counter
    wire jump;
    wire pc_write;
    wire [15:0]  label;
    wire [15:0]  pc_address;

    // Program Memory
    wire [23:0] Prog_mem_instr;

    // Instruction Register
    wire instr_write_en;
    wire [23:0] instr_out;

    // Decoder
    wire [3:0] alu_code;
    wire [4:0] op_code;
    wire [7:0] immediate;

    // Control / Register Addresses
    wire [4:0] rd;
    wire [4:0] rs1;
    wire [4:0] rs2;

    // Register File
    wire reg_file_write_en;
    wire alu_src;
    wire mem_to_reg;
    wire [15:0]  A;
    wire [15:0]  B;

    // ALU
    wire [15:0] alu_out;
    wire ov_flag;
    wire equal_flag;
    wire less_than_flag;
    wire greater_than_flag;
    wire flag_write_en;

    // Data Memory
    wire data_write_en;
    wire data_read_en;
    wire [15:0] MDR;

    // control unit

    control_unit ctrl_unit(
    // inputs
    clk,
    rst,
    op_code,
    equal_flag,
    less_than_flag,
    greater_than_flag,
    programming_mode,
    
    // outputs
    buffer_reg_write_en,
    pc_write,
    instr_write_en,
    reg_file_write_en,
    data_read_en,
    data_write_en,
    mem_to_reg,
    alu_src,
    jump,
    flag_write_en
    );

    prog_counter pc(
        clk,
        rst,
        jump,
        pc_write,
        programming_mode,
        label,
        pc_address
    );

    prog_mem prog_mem(
        clk,
        rst,
        programming_mode,
        pc_address,
        load_add,
        instr_load,
        Prog_mem_instr
    );

    instr_reg instr_reg(
        clk,
        rst,
        instr_write_en,
        Prog_mem_instr,
        instr_out
    );

    decoder decoder(
        instr_out,
        alu_code,
        op_code,
        rd,
        rs1,
        rs2,
        immediate,
        label
    );

    register_file reg_file(
        clk,
        rst,
        reg_file_write_en,
        alu_src,
        buffer_reg_write_en,
        rs1,
        rs2,
        rd,
        mem_to_reg,
        alu_out,
        MDR,
        immediate,
        A,
        B
    );

    alu alu(
        clk,
        flag_write_en,
        A,
        B,
        alu_code,
        alu_out,
        ov_flag,
        equal_flag,
        less_than_flag,
        greater_than_flag
    );

    data_mem data_mem(
        clk,
        rst,
        data_write_en,
        data_read_en,
        alu_out,
        B,
        MDR
    );

endmodule