// Please include verilog file if you write module in other file
`include "Decoder.v"
`include "PC.v"
`include "Register.v"
`include "SignExtend.v"
`include "ALUCtrl.v"
`include "ALU.v"
`include "BranchCtrl.v"

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

/* Add your design */
parameter BYTE=3'b000,
          HWORD=3'b001,
          BYTE_U=3'b010,
          HWORD_U=3'b011,
          WORD = 3'b100;

wire  [31:0]  pc_out;
reg   [31:0]  pc_in ;
wire  [31:0]  data1;
wire  [31:0]  data2;
wire  [31:0]  w_data;
wire  [2:0]   ImmType;
wire          RegWrite,PCtoRegSrc,ALUSrc,RDSrc,MemRead,MemWrite,MemtoReg;
wire  [1:0]   Branch;
wire  [2:0 ]  ALUOp;
wire  [31:0]  extendnum;
wire  [31:0]  PCReg ;
wire  [31:0]  ALUReg;
wire  [3:0]   OpCtrl;
wire  [31:0]  ALUOut;
wire  [31:0]  result ;
wire  [31:0]  PCIMM;
wire          ZeroFlag;
wire  [1:0]   branchCtrl;
wire  [2:0]   data_type;
reg   [31:0]  data_out_cpu;
wire  [31:0]  instr_out_cpu;
wire flush;
wire stall;
reg  [1:0]counter_instr;

assign instr_out_cpu = (flush)?32'b0:instr_out;
assign stall = (counter_instr == 2'b01 & MemRead) ? 1'b1 :
               (counter_instr != 2'b00          ) ? 1'b0 :
                                              1'b1 ;
always@(posedge clk or posedge rst) begin
    if(rst)
        counter_instr <= 2'b00;
    else 
        counter_instr <= (counter_instr == 2'b01 & MemRead) ? counter_instr + 2'b1 :
                         (counter_instr != 2'b0           ) ? 2'b0                 :
                                                              counter_instr + 2'b1 ; 
end

assign instr_addr = pc_out ;
assign instr_read = 1'b1;
assign PCIMM      = pc_out+extendnum;
assign PCReg      = PCtoRegSrc ? PCIMM:pc_out+4;
assign result     = RDSrc ? PCReg:ALUOut;
assign ALUReg     = ALUSrc? data2 : extendnum;
assign data_read  = counter_instr == 2'b10 ? 1'b0:MemRead;
assign data_addr  = ALUOut;
assign w_data     = MemtoReg ? result: data_out_cpu;

always@(*) begin
    case(branchCtrl)
        2'b00:
            pc_in = ALUOut;
        2'b01:
            pc_in = PCIMM;
        2'b10:
            pc_in = pc_out + 4;
        default:
            pc_in = 32'b0;
    endcase
end

always@(*) begin
    data_write = 4'b0;
    if(MemWrite)begin
        case(data_type)       
            BYTE:data_write[data_addr[1:0]]=1'b1;
            HWORD:data_write[{data_addr[1],1'b0}+:2] = 2'b11;
            default:data_write = 4'hf; 
        endcase 
    end
end

always@(*) begin
    data_in = 32'b0;
    case(data_type)
            BYTE:data_in[{data_addr[1:0],3'b0}+:8] = data2[7:0];
            HWORD:data_in[{data_addr[1],4'b0}+:16]=data2[15:0];
            default:data_in=data2; 
    endcase
end

always@(*) begin
    data_out_cpu = 32'b0;
    case(data_type)
          BYTE:begin
            data_out_cpu[7:0] = data_out[{data_addr[1:0],3'b0}+:8];
            data_out_cpu[31:8] = {24{data_out_cpu[7]}};
          end
          HWORD:begin
            data_out_cpu[15:0] = data_out[{data_addr[1],4'b0}+:16];
            data_out_cpu[31:16] = {16{data_out_cpu[15]}};
          end
          BYTE_U:data_out_cpu[7:0] = data_out[{data_addr[1:0],3'b0}+:8];
          HWORD_U:data_out_cpu[15:0] = data_out[{data_addr[1],4'b0}+:16];
          default: data_out_cpu=data_out;
    endcase
end

PC programpc_out (
    .clk(clk),
    .rst(rst),
    .stall(stall),
    .pc_in(pc_in),
    .flush(flush),
    .pc_out(pc_out)
);

Decoder decoder (
    .rst(rst),
    .clk(clk),
    .opcode(instr_out_cpu[6:0]),
    .ImmType(ImmType),
    .RegWrite(RegWrite),
    .PCtoRegSrc(PCtoRegSrc),
    .ALUSrc(ALUSrc),
    .RDSrc(RDSrc),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .Branch(Branch),
    .ALUOp(ALUOp)
);

Register register (
    .rst(rst),
    .clk(clk),
    .rs1(instr_out_cpu[19:15]),
    .rs2(instr_out_cpu[24:20]),
    .rd(instr_out_cpu[11:7]),
    .r_data1(data1),
    .r_data2(data2),
    .w_data(w_data),
    .w_signal(RegWrite)
);

SignExtend signExtend(
    .rst(rst),
    .clk(clk),
    .SignType(ImmType),
    .SignNumber(instr_out_cpu[31:12]),
    .SignNumber1(instr_out_cpu[11:7]),
    .out(extendnum)
); 

ALUCtrl aluctrl(
    .rst(rst),
    .clk(clk),
    .ALUOp(ALUOp),
    .Funct7(instr_out_cpu[31:25]),
    .Funct3(instr_out_cpu[14:12]),
    .ALUCtrl(OpCtrl),
    .data_type(data_type)
);

ALU alu (
    .rst(rst),
    .clk(clk),
    .ALUCtrl(OpCtrl),
    .r1_data(data1),
    .r2_data(ALUReg),
    .ALUOut(ALUOut),
    .shamt(instr_out_cpu[24:20]),
    .ZeroFlag(ZeroFlag)
);

BranchCtrl branchctrl (
    .rst(rst),
    .clk(clk),
    .Branch(Branch),
    .Funct3(instr_out_cpu[14:12]),
    .ZeroFlag(ZeroFlag),
    .ALUResult(ALUOut[0]),
    .Signal(branchCtrl)
       
 );

endmodule
