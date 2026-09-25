// Explanation on hardware level: a mux has 2 inputs, one is 4 and the value of PC and an adder that adds those values, the other input is target address. the selector is pc_src which comes from CU. then the output of the mux is connected to PC. PC only accepts that value from mux when clk signal happens.

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
      