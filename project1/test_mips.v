`timescale 1ns/1ps

module test_mips();

reg clk,reset;

mips cpu(clk,reset);


initial
begin
    clk=1;
    reset=1;
    #5 reset=0;
end

always
    #25 clk=~clk;

endmodule