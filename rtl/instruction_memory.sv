// Instruction Memory is ROM
// Still has write port
// Driven by PC 


module instruction_memory (
  input logic [31:0] pc,
  
  output logic [32:0] instruction
);
  
  logic [31:0] memory [63:0];
  
  always_comb begin
    instruction = memory [pc/4];
  end 
  
endmodule 
  
  