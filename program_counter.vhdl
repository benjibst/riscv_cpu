LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY ProgramCounter IS
    PORT (
        pc_clk : IN STD_LOGIC := '0'; -- clock input
        pc_load_en : IN STD_LOGIC := '0'; -- TODO: implement load enable
        pc_in : IN STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0'); -- TODO: implement load enable
        pc_curr : OUT STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
        pc_next : OUT STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0')
    );
END ProgramCounter;

ARCHITECTURE RTL OF ProgramCounter IS
    SIGNAL pc_num : UNSIGNED(11 DOWNTO 0); -- PC value is stored in 10 bits internally
BEGIN
    PROCESS (pc_clk)
    BEGIN
        IF rising_edge(pc_clk) THEN
            pc_num <= unsigned(pc_in); -- increment by 1, will be shifted left by 2
        END IF;
    END PROCESS;

    pc_curr <= STD_LOGIC_VECTOR(pc_num); -- forward current value
    pc_next <= STD_LOGIC_VECTOR(pc_num + 4); -- append trailing zeros
END RTL;