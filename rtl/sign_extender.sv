module sign_extender (
  
  input logic [31:0] instruction,
  input logic [2:0] imm_src, //What type of instruction it is
  
  output logic [31:0] imm_ext //immediate extended
);
  
  
  
  // Instruction types: I, S, B, U, J
  
  always_comb begin
    
    case (imm_src)
      
      3'b000: begin 
        // I type
        imm_ext = { {20{instruction[31]}}, instruction[31:20] };     
      end 
      
      3'b001: begin 
        // S type
        imm_ext = { {20{instruction[31]}}, instruction[31:25], instruction [11:7]};
      end 
      
      3'b010: begin 
        // B type
        imm_ext = { {19{instruction[31]}}, instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0 };
      end 
      
      3'b011: begin 
        // U type
        imm_ext = { instruction[31:12], 12'b0 };
      end 
      
      3'b100: begin 
        // J type 
        imm_ext = { {11{instruction[31]}}, instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0 };
      end 
      
      default: begin
        imm_ext = 32'b0; // Added default case to prevent latch generation
      end
      
    endcase 
    
    
  end 
  
  
endmodule