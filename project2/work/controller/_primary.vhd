library verilog;
use verilog.vl_types.all;
entity controller is
    port(
        opcode          : in     vl_logic_vector(5 downto 0);
        funct           : in     vl_logic_vector(5 downto 0);
        aluop           : out    vl_logic_vector(2 downto 0);
        memwrite        : out    vl_logic;
        memtoreg        : out    vl_logic;
        regdst          : out    vl_logic;
        regwrite        : out    vl_logic;
        alusrc          : out    vl_logic;
        npc_sel         : out    vl_logic_vector(1 downto 0);
        of_control      : out    vl_logic;
        ext_sel         : out    vl_logic;
        sh_flag         : out    vl_logic
    );
end controller;
