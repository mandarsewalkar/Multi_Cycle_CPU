`timescale 1ns/1ns

module register_file(
    input clk,
    input rst,
    input write_en,
    input alu_src,
    input buffer_reg_write_en,

    input [4:0] rs1_add,
    input [4:0] rs2_add,
    input [4:0] rd_add,

    input mem_to_reg,
    input [15:0] rd_val_alu,
    input [15:0] rd_val_mem,
    input [7:0] immediate,

    output reg [15:0] A,
    output reg [15:0] B
);

reg [15:0] mem [0:31];
integer i;

initial begin
    mem[0]  = 8'd0;
    mem[1]  = 8'd250;
    mem[2]  = 8'd44;
    mem[3]  = 8'd67;
    mem[4]  = 8'd191;
    mem[5]  = 8'd101;
    mem[6]  = 8'd34;
    mem[7]  = 8'd157;
    mem[8]  = 8'd140;
    mem[9]  = 8'd99;
    mem[10] = 8'd8;
    mem[11] = 8'd250;
    mem[12] = 8'd66;
    mem[13] = 8'd1;
    mem[14] = 8'd5;
    mem[15] = 8'd5;
end

always@(posedge clk)
begin
    if(rst)
        for(i=0;i<32;i=i+1)
        mem[i] <= 8'd0;
    else if(write_en)
        begin
            if(mem_to_reg)
                mem[rd_add] <= rd_val_mem;
            else if(rd_add == 5'd0)
                mem[rd_add] <= 16'd0;
            else
                mem[rd_add] <= rd_val_alu;
        end
end

always@(posedge clk)
begin
    A = mem[rs1_add];
    if(buffer_reg_write_en)
    begin
        B = alu_src ? {8'd0, immediate} : mem[rs2_add];
    end
end

endmodule