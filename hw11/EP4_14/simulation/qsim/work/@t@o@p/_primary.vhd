library verilog;
use verilog.vl_types.all;
entity TOP is
    port(
        \out\           : out    vl_logic;
        rst             : in     vl_logic;
        clk             : in     vl_logic;
        \in\            : in     vl_logic
    );
end TOP;
