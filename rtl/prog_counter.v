`timescale 1ns/1ns

module prog_counter(
    input clk,
    input rst,
    input jump,
    input pc_write,
    input programming_mode,
    input [15:0] label,
    output reg [15:0] curr_address
);


always@(posedge clk)
begin
    if(rst || programming_mode) 
        curr_address <= 16'd0;
    else if(pc_write == 1'b1)
    begin
        if(jump == 1'b1)
            curr_address <= label;
        else
            curr_address <= curr_address + 1;
    end
end

endmodule