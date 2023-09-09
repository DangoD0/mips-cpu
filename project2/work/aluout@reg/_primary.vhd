library verilog;
use verilog.vl_types.all;
entity aluoutReg is
    port(
        clk             : in     vl_logic;
        aluout          : in     vl_logic_vector(31 downto 0);
        aluout_late     : out    vl_logic_vector(31 downto 0);
        oflow           : in     vl_logic;
        oflow_late      : out    vl_logic
    );
end aluoutReg;
