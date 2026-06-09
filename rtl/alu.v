`timescale 1ns/1ns

module alu (
    input clk,
    input flag_write_en,
    input [15:0] a,
    input [15:0] b,
    input [3:0] alu_code,
    output reg [15:0] y,
    output reg ov_flag,
    output reg equal_flag,
    output reg less_than_flag,
    output reg greater_than_flag
);

reg equal_bit;
reg less_than_bit;
reg greater_than_bit;


always @(*)
begin

    y = 16'd0;
    ov_flag = 1'b0;
    equal_bit = 1'b0;
    less_than_bit = 1'b0;
    greater_than_bit = 1'b0;
    
    case(alu_code)
    
    4'd0: {ov_flag , y} = a + b;
    4'd1: {ov_flag , y} = a - b;
    4'd2: y = a & b;
    4'd3: y = a | b;
    4'd4: y = a ^ b;
    4'd5: y = ~a;
    4'd6: y = a;
    4'd7: y = a << b[3:0];
    4'd8: y = a >> b[3:0];
    4'd9:
    begin
        if(a < b)
            less_than_bit = 1'b1;

        else if(a > b)
            greater_than_bit = 1'b1;

        else
            equal_bit = 1'b1;
    end

    default: y = 16'd0;
    
    endcase

end


always @(posedge clk)
begin
    if (flag_write_en)
    begin
        equal_flag <= equal_bit;
        less_than_flag <= less_than_bit;
        greater_than_flag <= greater_than_bit;
    end
end

endmodule
