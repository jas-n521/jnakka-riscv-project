// DATAPATH
// 5 core blocks: PC, Sign Extender, ALU, Reg File, Adder (PC + ImmExt)
// 3 muxes: writeback, next pc, and ALU src B

`default_nettype none
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
      2'b00: begin
        write_in = ALUResult;
      end 
      
      2'b01: begin
        write_in = readData;
      end 
      
      2'b10: begin
        write_in = pc_plus_4;
      end 

      default: begin
        write_in = 32'bx;
      end 
    endcase
    
  end 
  
    assign read1 = instruction[19:15];
    assign read2 = instruction[24:20];
    assign write1 = instruction [11:7];
    assign pc_target = pc + imm_ext;
  
endmodule 