//RegWrite: 1 if we are writing a result back to a register (like add, lw, addi).
//ImmSrc: Tells the Extender how to reconstruct the immediate value (e.g., 00 for I-type, 01 for S-type, 10 for B-type).
//ALUSrc: 0 to feed the second register into the ALU; 1 to feed the immediate value. This signal is for a mux that sits before the ALU.
//MemWrite: 1 if we are writing to RAM (sw).
//ResultSrc: 00 to write the ALU result to registers; 01 to write the RAM data; 10 to write $PC+4$.
//Branch: 1 if we are running a branch instruction (beq).
//ALUOp: A 2-bit code we pass to the ALU Decoder to help it figure out the math (00 = Add, 01 = Subtract, 10 = Look at funct3/7).

module main_decoder (
  
  input logic [31:0] instruction, //instruction
               
  output logic regWrite,
  output logic [2:0] imm_src, 
  output logic memWrite, 
  output logic [1:0] result_src,
  output logic branch,
  output logic jump,
  output logic ALU_src,
  output logic [1:0] ALU_op
); 
               
               
                               
  always_comb begin 
    regWrite = 0; 
    memWrite = 0; 
    branch = 0; 
    jump = 0;
	imm_src = 3'b000; 
    result_src = 2'b00; 
    ALU_src = 0; 
    ALU_op = 2'b00;
    
    
    case (instruction[6:0]) 
      
      7'b0110011: begin 
        //R-type
        regWrite = 1;
        result_src = 2'b00;
        ALU_op = 2'b10;
        ALU_src = 0;
      end 
      
      7'b0010011: begin
        //I-type ALU
        regWrite = 1;
        result_src = 2'b00;
        imm_src = 3'b000;
        ALU_src = 1;
        ALU_op = 2'b10;
      end 
      
      7'b0000011: begin
        //I-type load
        regWrite = 1;
        imm_src = 3'b000;
        ALU_op = 2'b00;
        ALU_src = 1;
        result_src = 2'b01;
      end 
        
      7'b0100011: begin
         //S-type store
        imm_src = 3'b001;
        ALU_op = 2'b00;
        ALU_src = 1;
        memWrite = 1;
        
      end 
      
      7'b1100011: begin 
        //B-type branch
        branch = 1;
        ALU_op = 2'b01;
        imm_src = 3'b010;
      end 
      
      7'b1101111: begin
        //J type jal
        imm_src = 3'b100;
        jump = 1;
        ALU_op = 2'b00;
        result_src = 2'b10;
        regWrite = 1;
      end 
      
      default: begin
        // Default catch all
        regWrite   = 0;
        memWrite   = 0;
        branch     = 0;
        jump       = 0;
      end
      
    endcase 
        
  end 
         
endmodule        
         
 