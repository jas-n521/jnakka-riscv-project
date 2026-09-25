// Data Memory
// RAM
// Read and Write Access
// Read is combinational
// Write is sequential, uses WE

module RAM (
  input logic memWrite,
  input logic [31:0] address,
  input logic [31:0] writeData,
  input logic clk,
  input logic rst,
  
  output logic [31:0] readData
);

  logic [32:0] memory [255:0];
  
  always_ff @ (posedge clk or posedge rst) begin
    if (rst) begin
      for (int i = 0; i < 256; i++) begin
        memory[i] <= 0;
      end 
    end 
    
    else begin
      if (memWrite) begin
        memory [address/4] <=  writeData;
      end 
    end 
    
  end 
  
  always_comb begin
    readData = memory[address/4];
  end 
  
endmodule
