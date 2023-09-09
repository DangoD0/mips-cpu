`timescale 1us /1us
module alu_tb();
  reg [31:0] A;
  reg [31:0] B;
  reg [2:0] ALUOp;
  wire zero;
  wire [31:0] alu_res;
  wire overflow;
  wire bgezal_flag;
  
  alu alu_1(ALUOp,A,B,alu_res,zero,overflow,bgezal_flag);
  
  initial
    begin
      A = 32'hffff_ffff;
      B = 32'h0000_0001;
      ALUOp = 3'b011;
      
      # 40
      ALUOp = 3'b000;
      
      # 40
      A = 32'h7FFF_FFFF;
      B = 32'h0000_0001;
      ALUOp = 3'b000;
      
      # 40
      A = 32'h0000_0003;
      B = 32'h0000_0004;
      ALUOp = 3'b000;
      
      
      # 40
      ALUOp = 3'b010;
      
      # 40
      A = 32'h0000_0005;
      $stop;
      
    end
endmodule
