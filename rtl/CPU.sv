// This is the final top level module. It connects the datapath, control unit, RAM, and ROM
`default_nettype none
module CPU (
    input logic clk,
    input logic rst

    // No outputs needed
);

logic Zero;
logic [31:0] instruction;
logic pc_src;
logic regWrite;
logic [2:0] imm_src;
logic ALU_src;
logic memWrite;
logic [3:0] ALUControl;
logic [31:0] readData;
logic [1:0] result_src;
logic [31:0] pc;
logic [31:0] ALUResult;
logic [31:0] readout2;  //from regfile

datapath dp (
  .clk(clk), 
  .rst(rst),
  .pc_src(pc_src), 
  .regWrite(regWrite), 
  .imm_src(imm_src), 
  .ALU_src(ALU_src),
  .ALUControl(ALUControl),
  .instruction(instruction),
  .readData(readData), 
  .result_src(result_src),
  
  .pc(pc),
  .ALUResult(ALUResult),
  .Zero(Zero),
  .readout2(readout2) //from regfile
);

decoder_control controlunit (
  .instruction(instruction), 
  .Zero(Zero),

  .pc_src(pc_src), 
  .regWrite(regWrite), 
  .imm_src(imm_src), 
  .memWrite(memWrite), 
  .result_src(result_src),
  .ALU_src(ALU_src),
  .ALUControl(ALUControl)
);

RAM ram(
  .address(ALUResult),
  .writeData(readout2),
  .memWrite(memWrite),
  .readData(readData),
  .clk(clk),
  .rst(rst)
);

instruction_memory ROM(
  .pc(pc),
  .instruction(instruction)
);

endmodule

