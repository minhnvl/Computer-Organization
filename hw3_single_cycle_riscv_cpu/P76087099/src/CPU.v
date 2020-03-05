// Please include verilog file if you write module in other file
module CPU(
    input             clk,
    input             rst,
    input      [31:0] data_out,
    input      [31:0] instr_out,
    output            instr_read,
    output            data_read,
    output     [31:0] instr_addr,
    output     [31:0] data_addr,
    output reg [3:0]  data_write,
    output reg [31:0] data_in
);
    reg             boolen_check;
    reg     [31:0]  pc_in
    reg     [1:0]   brannch_ctrl // output of Branch Ctrl function

    wire    [31:0]  pc_out;
    wire    [31:0]  ALUout;
    wire    [31:0]  PCIMM;
    wire    [2:0]   ImmType, ALUOP;
    wire            RegWrite, PCtoRegSRC, ALUSRC, RDSRC, MemRead, MemWrite, MemtoReg;
    wire    [1:0]   Branch;

    assign instr_addr = pc_out;
    
    /* Add your design */
    always @(posedge clk) begin
        if (rst) begin
            boolen_check <= 1'b0;
        end
        else begin
            boolen_check <= 1'b1;
        end
    end

    if (boolen_check) begin
        case(brannch_ctrl)
            2'b00:
                pc_in = ALUout;
            2'b01:
                pc_in = PCIMM; 
            2'b10:
                pc_in = pc_out + 4;
            default:
                pc_in = 32'b0;
        endcase
    end



    PC programpc_out (
        .clk(clk),
        .rst(rst),
        .pc_in(pc_in),
        .boolen_check(boolen_check),
        .pc_out(pc_out)
    );
    Decoder decoder (
        .clk(clk),
        .rst(rst),
        .opcode(pc_out[6:0]),
        .ImmType(ImmType),
        .RegWrite(RegWrite),
        .PCtoRegSRC(PCtoRegSRC),
        .ALUOP(ALUOP),
        .ALUSRC(ALUSRC),
        .RDSRC(RDSRC),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemtoReg(MemtoReg),
        .Branch(Branch),
    );



endmodule
//---------------------------

// Block PC
module PC (
    input   clk;
    input   rst;
    input   pc_in;
    input   boolen_check;
    output  reg [31:0]  pc_out;

);
    always @(posedge clk) begin
        if (rst) 
            pc_out <= 32'b0;
        else 
            pc_out <= (boolen_check)? pc_in:pc_out;
        
    end

endmodule

//----------------

// Block Decoder

module Decoder (
    input   clk;
    input   rst;
    input   opcode;
    output  ImmType;
    output  RegWrite;
    output  PCtoRegSRC;
    output  ALUOP;
    output  ALUSRC;
    output  RDSRC;
    output  MemRead;
    output  MemWrite;
    output  MemtoReg;
    output  Branch;

);

   
endmodule

//

module ImmdediateGenerator(
    input   clk;
    input   rst;
    input   ImmType;
    input   
);

endmodule