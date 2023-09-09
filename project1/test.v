`timescale 1ns/1ns
module test;
  reg clk,rst;
  mips mips(clk, rst) ;
  initial begin
    clk=0;rst=0;
    #5 rst=1;
    #5 rst=0;
  end
  always
    #10 clk=~clk;
endmodule