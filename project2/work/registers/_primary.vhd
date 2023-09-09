library verilog;
use verilog.vl_types.all;
entity registers is
    port(
        read1           : in     vl_logic_vector(4 downto 0);
        read2           : in     vl_logic_vector(4 downto 0);
        data1           : out    vl_logic_vector(31 downto 0);
        data2           : out    vl_logic_vector(31 downto 0);
        regwrite        : in     vl_logic;
        wrreg           : in     vl_logic_vector(4 downto 0);
        wrdata          : in     vl_logic_vector(31 downto 0);
        rst             : in     vl_logic;
        overflow_flag   : in     vl_logic;
        of_control      : in     vl_logic;
        clk             : in     vl_logic
    );
end registers;
