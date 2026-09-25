// Controller wrapper for Main and ALU Decoders.
// Houses the decoders and distributes signals to them

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
        ALU_op = 2'b00;
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
         
module ALU_decoder (
  input logic [1:0] ALU_op, 
  input logic [31:0] instruction, 
  
  output logic [3:0] ALUControl
); 
  
  
  logic [2:0] funct3;
  logic funct7_5;
  
  always_comb begin
    case (ALU_op) 
      
      2'b00: begin 
        //ADD
        ALUControl = 4'b0000;
      end 
      
      2'b01: begin
        //SUB
        ALUControl = 4'b0001;
      end 
      
      2'b10: begin
        // Check funct3/7
        case (funct3) 
          
          3'b000: begin
            // add or subtr: check funct7_5
            if (funct7_5 == 1'b1) 
              ALUControl = 4'b0001;
            else if (funct7_5 == 1'b0)
              ALUControl = 4'b0000;
          end 
          
          3'b111: begin 
            ALUControl = 4'b0010;
          end 
          
          3'b110: begin 
            ALUControl = 4'b0011;
          end 
          
          3'b100: begin 
            ALUControl = 4'b0100;
          end 
          
          3'b010: begin 
            ALUControl = 4'b0101;
          end 
          
          3'b001: begin 
            if (funct7_5 == 1'b0)
              ALUControl = 4'b0110;
          end 
          
          3'b101: begin 
             if (funct7_5 == 1'b0)
              ALUControl = 4'b0111;
          end 
          
          default: begin
            ALUControl = 4'b0000;
          end
          
        endcase 
      end 
      
      default: begin
        ALUControl = 4'b0000;
      end 
      
    endcase 
  end 
  
  assign funct3   = instruction[14:12];
  assign funct7_5 = instruction[30]; //distinguishes subtraction from addition, or arithmetic shifts from logical shifts
  
endmodule