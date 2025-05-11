LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY RegisterAccess IS
    PORT (
        ra_clk : IN STD_LOGIC;
        ra_rdaddr : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- External address input
        ra_rs1addr : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- rs1 address
        ra_rs2addr : IN STD_LOGIC_VECTOR(4 DOWNTO 0); -- rs2 address
        ra_we : IN STD_LOGIC; -- Write enable
        ra_rdval : IN STD_LOGIC_VECTOR(31 DOWNTO 0); -- Data to write
        ra_rs1val : OUT STD_LOGIC_VECTOR(31 DOWNTO 0); -- Output for rs1
        ra_rs2val : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- Output for rs2
    );
END RegisterAccess;

ARCHITECTURE RTL OF RegisterAccess IS
    SIGNAL addr_mux_out : STD_LOGIC_VECTOR(4 DOWNTO 0);
BEGIN
    addr_mux : ENTITY work.Multiplexer2_1
        GENERIC MAP(
            WIDTH => 5
        )
        PORT MAP(
            mp_a => ra_rdaddr, -- External address input
            mp_b => ra_rs1addr, -- rs1 address
            mp_out => addr_mux_out, -- Output to register file
            mp_s => ra_we -- Select signal for multiplexer
        );
    registerfile : ENTITY work.RegisterFile
        PORT MAP(
            rf_clk => ra_clk,
            rf_rwaddr => addr_mux_out, -- Address input from the multiplexer
            rf_rs2addr => ra_rs2addr, -- External address input
            rf_we => ra_we,
            rf_rdval => ra_rdval,
            rf_rs1val => ra_rs1val, -- Output rs1 value
            rf_rs2val => ra_rs2val -- Output rs2 value
        );

END RTL;