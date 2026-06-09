`timescale 1ns/1ns

module instr_reg(
    input clk,
    input rst,
    input instr_write_en,
    input [23:0] curr_instr,
    output [23:0] instr_out
);

reg [23:0] mem;

assign instr_out = mem;

always@(posedge clk)
begin
    if(rst)
        mem <= 24'd0;
    else if (instr_write_en == 1'b1)
        mem <= curr_instr;
end

endmodule