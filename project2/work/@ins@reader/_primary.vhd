library verilog;
use verilog.vl_types.all;
entity InsReader is
    port(
        in_im           : in     vl_logic_vector(31 downto 0);
        IRWr            : in     vl_logic;
        clk             : in     vl_logic;
        out_im          : out    vl_logic_vector(31 downto 0)
    );
end InsReader;
