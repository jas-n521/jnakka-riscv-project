// Controller wrapper for Main and ALU Decoders.
// Houses the decoders and distributes signals to them

`default_nettype none
module decoder_control (
  
  input logic [31:0] instruction, 
  input logic Zero, 
  
  output logic pc_src, 
  output logic regWrite, 
  output logic [2:0] imm_src, 
  output logic memWrite, 
  output logic [1:0] result_src,
  output logic ALU_src,
  output logic [3:0] ALUControl
); 
  
 logic branch;
 logic jump;
 logic [1:0] ALU_op;
 
  main_decoder md_inst (
    .instruction(instruction),
    .regWrite(regWrite),
    .imm_src(imm_src), 
    .memWrite(memWrite), 
    .result_src(result_src),
    .branch(branch),
    .jump(jump),
    .ALU_src(ALU_src),
    .ALU_op(ALU_op)
  );
  
  ALU_decoder ad_inst (
    .ALU_op(ALU_op), 
    .instruction(instruction), 
    .ALUControl(ALUControl)
  );
 
 always_comb begin
   
   pc_src = (Zero & branch) | jump; 

   
   
 end 
  
endmodule 