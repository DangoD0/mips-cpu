module aluoutReg(clk, aluout, aluout_late, oflow, oflow_late,bgt_flag_tmp,bgt_flag);
  input clk;
  input [31:0] aluout;
  input oflow;
  input bgt_flag_tmp;
  output reg [31:0] aluout_late;
  output reg oflow_late;
  output reg bgt_flag;
  
  always@(posedge clk)
  begin
    aluout_late <= aluout;
    oflow_late <= oflow;
    bgt_flag <= bgt_flag_tmp;
  end
  
endmodule