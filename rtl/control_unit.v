`timescale 1ns/1ns

module control_unit(
    input clk,
    input rst,
    input [4:0] op_code,
    input equal_flag,
    input less_than_flag,
    input greater_than_flag,
    input programming_mode,

    output reg buffer_reg_write_en,
    output reg pc_write,
    output reg instr_write_en,
    output reg reg_file_write_en,
    output reg data_read_en,
    output reg data_write_en,
    output reg mem_to_reg,
    output reg alu_src,
    output reg jump,
    output reg flag_write_en
);

localparam FETCH = 4'd0;
localparam DECODE = 4'd1;
localparam ALU_EXECUTE = 4'd2;
localparam MEM_READ = 4'd3;
localparam MEM_WRITE = 4'd4;
localparam WRITEBACK_ALU = 4'd5;
localparam WRITEBACK_MEM = 4'd6;
localparam JUMP_STATE = 4'd7;
localparam BRANCH_STATE = 4'd8; 

reg [3:0] state;
reg [3:0] next_state;

// state change

always@(posedge clk)
begin
    if(rst || programming_mode)
        state <= FETCH;
    else
        state <= next_state;
end

// next state logic

always@(*)
begin

    next_state = state;

    case(state)

        FETCH: next_state = DECODE;

        DECODE: 
        begin
            case(op_code)
            5'b00000,
            5'b00001,
            5'b00010,
            5'b00011,
            5'b00100,
            5'b00101,
            5'b00110,
            5'b00111,
            5'b01000,
            5'b01001,
            5'b01010:
            next_state = ALU_EXECUTE;

            5'b01011: next_state = MEM_READ;
            
            5'b01100: next_state = MEM_WRITE;

            5'b01101: next_state = JUMP_STATE;

            5'b01110,
            5'b01111,
            5'b10000,
            5'b10001,
            5'b10010,
            5'b10011: next_state = BRANCH_STATE;


            endcase
        end

        ALU_EXECUTE:
        next_state = WRITEBACK_ALU;

        MEM_READ:
        next_state = WRITEBACK_MEM;

        MEM_WRITE:
        next_state = FETCH;

        JUMP_STATE:
        next_state = FETCH;

        BRANCH_STATE:
        next_state = FETCH;

        WRITEBACK_ALU:
        next_state = FETCH;

        WRITEBACK_MEM:
        next_state = FETCH;

        default: next_state = FETCH;

    endcase
end

// output logic

always@(*)
begin
    pc_write = 1'b0;
    instr_write_en = 1'b0;
    reg_file_write_en = 1'b0;
    data_read_en = 1'b0;
    data_write_en = 1'b0;
    mem_to_reg = 1'b0;
    alu_src = 1'b0;
    jump = 1'b0;
    flag_write_en = 1'b0;
    buffer_reg_write_en = 1'b0;

    case(state)
    
        FETCH: begin
            pc_write = 1'b1;
            instr_write_en = 1'b1;
        end

        DECODE:
        begin
            buffer_reg_write_en = 1'b1;
            if(op_code == 5'b00010 || op_code == 5'b00011 || op_code == 5'b01000 || op_code == 5'b01001)
                alu_src = 1'b1;
            else
                alu_src = 1'b0;
        end

        ALU_EXECUTE: begin
        flag_write_en = (op_code == 5'b01010);
        end

        MEM_READ:
        data_read_en = 1'b1;

        WRITEBACK_ALU:
        begin
            if(op_code != 5'b01010) // CMP
                reg_file_write_en = 1'b1;
        end

        WRITEBACK_MEM:begin
            reg_file_write_en = 1'b1;
            mem_to_reg = 1'b1;
        end

        MEM_WRITE:
        data_write_en = 1'b1;

        JUMP_STATE:
        begin
        jump = 1'b1;
        pc_write = 1'b1;
        end

        BRANCH_STATE: begin
            
            // BEQ
            if(op_code == 5'b01110)
            begin
                jump = equal_flag;
                pc_write = equal_flag;
            end
            // BNE
            else if(op_code == 5'b01111)
            begin
                jump = ~equal_flag;
                pc_write = ~equal_flag;
            end
            // BLT
            else if(op_code == 5'b10000)
            begin
                jump = less_than_flag;
                pc_write = less_than_flag;
            end
            // BLE
            else if(op_code == 5'b10001)
            begin
                jump = (equal_flag | less_than_flag);
                pc_write = (equal_flag | less_than_flag);
            end
            // BGT
            else if(op_code == 5'b10010)
            begin
                jump = greater_than_flag;
                pc_write = greater_than_flag;
            end
            // BGE
            else if(op_code == 5'b10011)
            begin
                jump = (equal_flag | greater_than_flag);
                pc_write = (equal_flag | greater_than_flag);
            end

        end
    
    endcase
    
end

endmodule