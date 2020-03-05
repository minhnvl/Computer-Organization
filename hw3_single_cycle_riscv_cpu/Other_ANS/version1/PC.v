module PC (
    input clk,
    input rst,
    input stall,
    input [31:0] pc_in,
    output reg [31:0]pc_out,
    output reg flush
);

always@(posedge clk or posedge rst)begin
    if(rst)
        pc_out <= 32'b0;
    else
        pc_out <= (stall) ? pc_out :pc_in;
end

always@(posedge clk or posedge rst) begin
    if(rst)
        flush <= 1'b1;
    else 
        flush <= ~stall;
end


endmodule 
