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
            mp_a => ra_rs1addr, -- External address input
            mp_b => ra_rdaddr, -- rs1 address
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
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY RegisterAccessTB IS
END RegisterAccessTB;

ARCHITECTURE RTL OF RegisterAccessTB IS
    SIGNAL clk_period : TIME := 10 ns;

    SIGNAL tb_clk : STD_LOGIC := '0';
    SIGNAL tb_rdaddr : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_rs1addr : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_rs2addr : STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_we : STD_LOGIC := '1';
    SIGNAL tb_rdval : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_rs1val : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_rs2val : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
BEGIN
    uut : ENTITY work.RegisterAccess
        PORT MAP(
            ra_clk => tb_clk,
            ra_rdaddr => tb_rdaddr,
            ra_rs1addr => tb_rs1addr,
            ra_rs2addr => tb_rs2addr,
            ra_we => tb_we,
            ra_rdval => tb_rdval,
            ra_rs1val => tb_rs1val,
            ra_rs2val => tb_rs2val
        );
    PROCESS
    BEGIN
        WAIT FOR 10 ns;
        WHILE true LOOP
            tb_clk <= '1';
            WAIT FOR clk_period / 2;
            tb_clk <= '0';
            WAIT FOR clk_period / 2;
        END LOOP;
    END PROCESS;

    PROCESS
    BEGIN --loop through the first 15 addresses and read them
        WAIT FOR 9 ns;
        tb_we <= '0';
        FOR i IN 0 TO 15 LOOP
            tb_rs1addr <= STD_LOGIC_VECTOR(to_unsigned(i, 5));
            tb_rs2addr <= STD_LOGIC_VECTOR(to_unsigned(15 - i, 5));
            WAIT FOR clk_period;
        END LOOP;
        tb_we <= '1';
        FOR i IN 0 TO 15 LOOP
            tb_rdaddr <= STD_LOGIC_VECTOR(to_unsigned(i + 16, 5));
            tb_rdval <= STD_LOGIC_VECTOR(to_unsigned(i, 32));
            WAIT FOR clk_period;
        END LOOP;
        tb_we <= '0';
        FOR i IN 0 TO 15 LOOP
            tb_rs1addr <= STD_LOGIC_VECTOR(to_unsigned(i + 16, 5));
            tb_rs2addr <= STD_LOGIC_VECTOR(to_unsigned(31 - i, 5));
            WAIT FOR clk_period;
        END LOOP;
        WAIT;
    END PROCESS;
END RTL;