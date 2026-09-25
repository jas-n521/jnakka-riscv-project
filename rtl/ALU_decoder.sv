// Code your design here


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