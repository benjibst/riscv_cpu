LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY InstructionMemory IS
    PORT (
        im_addr : IN STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0'); -- pc input
        im_clk : IN STD_LOGIC := '0'; -- clock input
        im_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
    );
END InstructionMemory;

ARCHITECTURE RTL OF InstructionMemory IS
    TYPE memory_array IS ARRAY (0 TO 1023) OF STD_LOGIC_VECTOR(31 DOWNTO 0);

    CONSTANT rom : memory_array := (
        0 => x"00000000",
        1 => x"80000001",
        2 => x"40000002",
        3 => x"20000004",
        4 => x"10000008",
        5 => x"08000010",
        6 => x"04000020",
        7 => x"02000040",
        8 => x"01000080",
        9 => x"00800100",
        10 => x"00400200",
        11 => x"00200400",
        12 => x"00100800",
        13 => x"00081000",
        14 => x"00042000",
        15 => x"00024000",
        16 => x"00018000",
        OTHERS => x"00000000"
    );

BEGIN
    PROCESS (im_clk)
    BEGIN
        IF rising_edge(im_clk) THEN
            im_data <= rom(to_integer(unsigned(im_addr(11 DOWNTO 2))));
        END IF;
    END PROCESS;
END RTL;