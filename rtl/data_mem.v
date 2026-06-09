`timescale 1ns/1ns

module data_mem(
    input clk,
    input rst,
    input data_write_en,
    input data_read_en,
    input [15:0] address,
    input [15:0] data_load,
    output reg [15:0] MDR
);

reg [15:0] data_mem [0:65535];
integer i;

always@(posedge clk)
begin

    if(rst)
        begin
            MDR <= 16'd0;
            for(i=0;i<65536;i=i+1)
                data_mem[i] <= 16'd0;
        end
    else if(data_write_en == 1'b1)
            data_mem[address] <= data_load;
    else if(data_read_en == 1'b1)
            MDR <= data_mem[address];

end


endmodule