LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY InstructionFetch IS
    PORT (
        if_clk : IN STD_LOGIC := '0';
        if_load_en : IN STD_LOGIC := '1';
        if_pc_in : IN STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
        if_instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        if_pc_curr : OUT STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
        if_pc_next : OUT STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0')
    );
END InstructionFetch;

ARCHITECTURE RTL OF InstructionFetch IS
    SIGNAL if_pc_curr_reg : STD_LOGIC_VECTOR(11 DOWNTO 0);
BEGIN
    pc : ENTITY work.ProgramCounter(RTL)
        PORT MAP(
            pc_clk => if_clk,
            pc_load_en => if_load_en,
            pc_in => if_pc_in,
            pc_curr => if_pc_curr_reg,
            pc_next => if_pc_next
        );
    im : ENTITY work.InstructionMemory(RTL)
        PORT MAP(
            im_addr => if_pc_curr_reg(11 DOWNTO 0),
            im_clk => if_clk,
            im_data => if_instruction
        );
    if_pc_curr <= if_pc_curr_reg;

END RTL;

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY InstructionFetchTB IS
END InstructionFetchTB;

ARCHITECTURE RTL OF InstructionFetchTB IS
    SIGNAL clk_period : TIME := 10 ns;

    SIGNAL tb_clk : STD_LOGIC := '0';
    SIGNAL tb_load_en : STD_LOGIC := '1';
    SIGNAL tb_pc_in : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_instruction : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_pc_curr : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tb_pc_next : STD_LOGIC_VECTOR(11 DOWNTO 0) := (OTHERS => '0');
BEGIN
    tb_pc_in <= tb_pc_next;
    uut : ENTITY work.InstructionFetch(RTL)
        PORT MAP(
            if_clk => tb_clk,
            if_load_en => tb_load_en,
            if_pc_in => tb_pc_in,
            if_instruction => tb_instruction,
            if_pc_curr => tb_pc_curr,
            if_pc_next => tb_pc_next
        );
    PROCESS
    BEGIN
        WHILE true LOOP
            tb_clk <= '1';
            WAIT FOR clk_period / 2;
            tb_clk <= '0';
            WAIT FOR clk_period / 2;
        END LOOP;
    END PROCESS;
END RTL;