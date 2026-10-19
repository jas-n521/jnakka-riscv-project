//32 bit ALU
//3 INPUTS, 2 OUTPUTS
`default_nettype none
module ALU (
  
  input logic [31:0] srcA,
  input logic [31:0] srcB,
  input logic [3:0] ALUControl, //Selector for mux.
  
  output logic [31:0] ALUResult, //DATA output
  output logic Zero // 1 if DATA output was 0, 0 if anything else
  
);
  
  //Completely Combinational Logic 
  // Note : & is bitwise AND, && evaluates each entire term as T or F
  // ! is logical NOT, ~ is bitwise NOT
  
  logic [31:0] shift_reg;
  
  always_comb begin
    shift_reg = 32'b0;
        
    case (ALUControl) 
      
      4'b0000: begin
        //ADD
        
        ALUResult = srcA + srcB;
        
      end 
      
      4'b0001: begin
        //SUB
        
        ALUResult = srcA - srcB;
        
      end 
      
      4'b0010: begin
        //AND
        
        ALUResult = srcA & srcB;
        
      end 
      
      4'b0011: begin
        //OR
        
        ALUResult = srcA | srcB;
        
      end 
      
      4'b0100: begin
        //XOR
        ALUResult = (srcA & (~srcB)) | ((~srcA) & srcB);   // Can also use srcA ^ srcB
        
      end 
      
      4'b0101: begin
        //SLT
        ALUResult = ($signed(srcA) < $signed(srcB));
        
      end 
      
      4'b0110: begin
        //SLL
        // A is value to be shifted
        // B is amount of positions to be shifted.
        
        shift_reg = srcA;
        shift_reg = shift_reg << srcB[4:0];
        
        ALUResult = shift_reg;
        
      end 
      
      4'b0111: begin
        //SRL
        shift_reg = srcA;
        shift_reg = shift_reg >> srcB[4:0];
        
        ALUResult = shift_reg;
        
      end 

      4'b1000: begin
        //SRA
        //Not implemented yet.
        ALUResult = 32'b0;
      
      end 

      4'b1001: begin
        //SLTU
        // Not implemented yet.
        ALUResult = 32'b0;

      end 
      
      default: begin
        
        ALUResult = 32'b0;
        
      end 
      
    endcase  
   
  end 
  
  assign Zero = (ALUResult == 0);
  
endmodule