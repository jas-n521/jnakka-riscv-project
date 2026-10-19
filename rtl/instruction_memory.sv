// Instruction Memory is ROM
// Driven by PC 

`default_nettype none
module instruction_memory (
  input logic [31:0] pc,
  
  output logic [31:0] instruction
);
  
  logic [31:0] memory [63:0];
  
  initial begin 
    $readmemh("../programs/testfile1.hex", memory);
  end 

  always_comb begin
    instruction = memory [pc/4];
  end 
  
endmodule 
  
  