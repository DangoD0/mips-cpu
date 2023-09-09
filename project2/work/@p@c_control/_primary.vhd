library verilog;
use verilog.vl_types.all;
entity PC_control is
    port(
        PC_change_flag  : in     vl_logic;
        npc             : in     vl_logic_vector(31 downto 0);
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        pc              : out    vl_logic_vector(31 downto 0)
    );
end PC_control;
