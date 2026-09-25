// DATAPATH
// 5 core blocks: PC, Sign Extender, ALU, Reg File, Adder (PC + ImmExt)
// MUXES: Src MUX

module datapath (
  input logic clk, 
  input logic rst,
  input logic pc_src, 
  input logic regWrite, 
  input logic [2:0] imm_src, 
  input logic ALU_src,
  input logic [3:0] ALUControl,
  input logic [31:0] instruction,
  input logic [31:0] readData, 
  input logic [1:0] result_src,
  
  output logic [31:0] pc,
  output logic [31:0] ALUResult,
  output logic Zero,
  output logic [31:0] readout2
);
  
  logic [31:0] pc_plus_4;
  logic [31:0] write_in; //(The output of the writeback mux, which goes into the Register File's write data port).
  						 //could be pc+4, ALU Result, or Read data depending on result
  logic [31:0] readout1; //(The first output of the Register File, representing register rs1).
  logic [31:0] imm_ext; //(The sign-extended immediate value from the extend unit).
  logic [31:0] srcB;
  logic [31:0] pc_target;
  
  logic [4:0] read1; //address to be read in reg file
  logic [4:0] read2; //address to be read in reg file
  logic [4:0] write1; //address to be written to in reg file
  
  regfile rf_top (
    .clk(clk),
    .rst(rst),
    .read1(read1), // read port 1. address to be read  
    .read2(read2), // read port 2. address to be read
    .write1(write1), // write port. address to be written to
    .write_in(write_in), //value to be written at write port
    .write_en(regWrite),
    .readout1(readout1), //value read at read port 1.
    .readout2(readout2) //value read at read port 2
  ); 
  
  sign_extender sext_top (
    .instruction(instruction),
    .imm_src(imm_src), //What type of instruction it is
    .imm_ext(imm_ext)
  );
  
  program_counter pc_top (
    .clk(clk),
    .rst(rst),
    .pc_src(pc_src), //accounts for instruction type, and whether conditions are met.
    .pc_target(pc_target), //target address given by branch or jump instructions
    .pc(pc),
    .pc_plus_4(pc_plus_4)
  ); 
  
  ALU alu_top (
    .srcA(readout1),
    .srcB(srcB),
    .ALUControl(ALUControl), //Selector for mux.
    .ALUResult(ALUResult), //DATA output
    .Zero(Zero)
  ); 
  
  always_comb begin
    // pc + imm_ext --> pc_target  done
    // srcB  done
    // result aka write into regfile    done
    // read1, read2, write1    
        
    case (ALU_src)
      1'b0: begin
        srcB = readout2;
      end 
      
      1'b1: begin
        srcB = imm_ext;
      end 
    endcase
    
    case (result_src)
      1'b00: begin
        write_in = ALUResult;
      end 
      
      1'b01: begin
        write_in = readData;
      end 
      
      1'b10: begin
        write_in = pc_plus_4;
      end 
    endcase
    
  end 
  
    assign read1 = instruction[19:15];
    assign read2 = instruction[24:20];
    assign write1 = instruction [11:7];
    assign pc_target = pc + imm_ext;
  
endmodule 

module regfile (
  //32 register addresses needs 5 bits 
  input logic clk,
  input logic rst,
  input logic [4:0] read1, // read port 1. address to be read  
  input logic [4:0] read2, // read port 2. address to be read
  input logic [4:0] write1, // write port. address to be written to
  input logic [31:0] write_in, //value to be written at write port
  input logic write_en,
  
  output logic [31:0] readout1, //value read at read port 1.
  output logic [31:0] readout2 //value read at read port 2
  
);
  
  
  logic [31:0] file [31:0]; 
  
  always_ff @ (posedge clk or posedge rst) begin
    
    if (rst) begin
      integer i;
      
      for (i=0; i<32; i++) begin
        file[i] <= 0;
      end 
        
    end 
    
    else begin
      if (write1 != 0) begin 
        if (write_en) 
        	file[write1] <= write_in;
      	else 
        	file[write1] <= file[write1];
      end 
      
      else file[write1] <= file[write1];
    end 
    
    
  end 
  
  assign readout1 = (read1 == 5'b0) ? 0:file[read1];
  assign readout2 = (read2 == 5'b0) ? 0:file[read2];
  
endmodule
    
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
        shift_reg = shift_reg << srcB;
        
        ALUResult = shift_reg;
        
      end 
      
      4'b0111: begin
        //SRL
        shift_reg = srcA;
        shift_reg = shift_reg >> srcB;
        
        ALUResult = shift_reg;
        
      end 
      
      default: begin
        
        ALUResult = 32'b0;
        
      end 
      
    endcase  
   
  end 
  
  assign Zero = (ALUResult == 0);
  
endmodule

module program_counter (
  
  input logic clk,
  input logic rst,
  input logic pc_src, //accounts for instruction type, and whether conditions are met.
  input logic [31:0] pc_target, //target address given by branch or jump instructions
  
  output logic [31:0] pc,
  output logic [31:0] pc_plus_4
  
);
  
  logic [31:0] pc_next;  
  
  always_ff @ (posedge clk or posedge rst) begin
      
      if (rst) 
        pc <= 32'd0;
        
      else 
        pc <= pc_next;
          
  end 
  
  
  
  always_comb begin
    
    case (pc_src)
      
      1'b0 : begin 
        pc_next = pc + 32'd4;
      end 
        
      1'b1: begin
        pc_next = pc_target;
      end 
      
      default: begin
        pc_next = pc + 32'd4;
      end 
      
    endcase 
    
  end 
  
  assign pc_plus_4 = pc + 32'd4;
      
endmodule

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

