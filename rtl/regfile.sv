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
    
  