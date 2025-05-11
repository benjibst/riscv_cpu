LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY RegisterFile IS
    PORT (
        rf_clk : IN STD_LOGIC := '0';
        rf_rwaddr : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        rf_rs2addr : IN STD_LOGIC_VECTOR(4 DOWNTO 0) := (OTHERS => '0');
        rf_we : IN STD_LOGIC := '0';
        rf_rdval : IN STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        rf_rs1val : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        rf_rs2val : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0')
    );
END RegisterFile;

ARCHITECTURE RTL OF RegisterFile IS
    TYPE memory_array IS ARRAY (0 TO 31) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL registers : memory_array := (
        0 => x"80000001",
        1 => x"40000002",
        2 => x"20000004",
        3 => x"10000008",
        4 => x"08000010",
        5 => x"04000020",
        6 => x"02000040",
        7 => x"01000080",
        8 => x"00800100",
        9 => x"00400200",
        10 => x"00200400",
        11 => x"00100800",
        12 => x"00081000",
        13 => x"00042000",
        14 => x"00024000",
        15 => x"00018000"
        OTHERS => x"00000000"
    );
    SIGNAL rs1val_latch : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL rs2val_latch : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

    PROCESS (rf_clk)
    BEGIN
        IF rising_edge(rf_clk) THEN
            IF rf_we = '1' THEN
                registers(to_integer(unsigned(rf_rwaddr))) <= rf_rdval;
            END IF;
            rs1val_latch <= registers(to_integer(unsigned(rf_addr)));
            rs2val_latch <= registers(to_integer(unsigned(rf_dpra)));
        END IF;
    END PROCESS;
    rf_rs1val <= rs1val_latch;
    rf_rs2val <= rs2val_latch;
END RTL;