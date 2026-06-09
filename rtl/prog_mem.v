`timescale 1ns/1ns

module prog_mem(
    input clk,
    input rst,
    input instr_write_en,
    input [15:0] curr_add,
    input [15:0] load_add,
    input [23:0] instr_load,
    output [23:0] curr_instr
);

reg [23:0] prog_mem [0:65535];
integer i;

assign curr_instr = prog_mem[curr_add];

always@(posedge clk)
begin

    if(rst)
        for(i=0;i<65536;i=i+1)
            prog_mem[i] <= 24'd0;
    else if(instr_write_en == 1'b1)
            prog_mem[load_add] <= instr_load;
        

end


endmodule