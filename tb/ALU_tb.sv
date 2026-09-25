module ALU_tb;
  
  logic [31:0] srcA;
  logic [31:0] srcB;
  logic [3:0] ALUControl;
  logic [31:0] ALUResult;
  logic Zero;
  
  ALU alutest (
    .srcA(srcA),
    .srcB(srcB),
    .ALUControl(ALUControl),
    .ALUResult(ALUResult),
    .Zero(Zero)
  );
  
  initial begin
  srcA = 32'b10;
  srcB = 32'b01;
  ALUControl = 4'b0101;
    
  #1
  
    $display( "SLT: %b and Zero: %b", ALUResult, Zero);
    
  ALUControl = 4'b0000;
    
  #2
    
    $display( "SUM: %d and Zero: %d", ALUResult, Zero);
      
  ALUControl = 4'b0001;
    
  #3
    
    $display( "DIFFERENCE: %d and Zero: %d", ALUResult, Zero);
      
  ALUControl = 4'b0010;
    
  #4
    
    $display( "AND: %d and Zero: %d", ALUResult, Zero);
      
  ALUControl = 4'b0011;
    
  #5
    
    $display( "OR: %d and Zero: %d", ALUResult, Zero);
      
  ALUControl = 4'b0100;

  #6
    
    $display( "XOR: %d and Zero: %d", ALUResult, Zero);
      
  ALUControl = 4'b0110;
    
    
  #7
    
    $display( "SLL: %d and Zero: %d", ALUResult, Zero);
      
  ALUControl = 4'b0111;

  #8
    
    $display( "SRL: %d and Zero: %d", ALUResult, Zero);    
      
  ALUControl = 4'b1111;
    
    $display("Result :%d and Zero: %d", ALUResult, Zero);
  
    
  end 
  

  
endmodule