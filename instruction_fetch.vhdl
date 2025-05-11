library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity InstructionFetch is
    port (
        if_clk          : in  std_logic:= '0';
        if_load_en      : in  std_logic:= '1';
        if_pc_in        : in  std_logic_vector(11 downto 0):= (others => '0');
        if_instruction  : out std_logic_vector(31 downto 0):= (others => '0');
        if_pc_curr      : out std_logic_vector(11 downto 0):= (others => '0');
        if_pc_next      : out std_logic_vector(11 downto 0):= (others => '0')
    );
end InstructionFetch;

architecture Behavioral of InstructionFetch is
    signal if_pc_curr_reg : std_logic_vector(11 downto 0);
begin
    pc : entity work.ProgramCounter(Behavioral)
        port map (
             pc_clk     =>  if_clk      ,
             pc_load_en =>  if_load_en  ,
             pc_in      =>  if_pc_in    ,
             pc_curr    =>  if_pc_curr_reg ,
             pc_next    =>  if_pc_next  
        );
    im : entity work.InstructionMemory(Behavioral) 
        port map (
             im_addr    =>  if_pc_curr_reg(11 downto 0),
             im_clk     =>  if_clk,
             im_data    =>  if_instruction
        );
    if_pc_curr <= if_pc_curr_reg;

end Behavioral;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity InstructionFetchTB is
end InstructionFetchTB;

architecture Behavioral of InstructionFetchTB is
    signal clk_period : time := 10 ns;

    signal tb_clk         : std_logic := '0';
    signal tb_load_en     : std_logic := '1';
    signal tb_pc_in       : std_logic_vector(11 downto 0) := (others => '0');
    signal tb_instruction : std_logic_vector(31 downto 0):= (others => '0');
    signal tb_pc_curr     : std_logic_vector(11 downto 0):= (others => '0');
    signal tb_pc_next     : std_logic_vector(11 downto 0):= (others => '0');
begin
    tb_pc_in <= tb_pc_next;
    uut: entity work.InstructionFetch(Behavioral)
        port map (
            if_clk         => tb_clk,
            if_load_en     => tb_load_en,
            if_pc_in       => tb_pc_in,
            if_instruction => tb_instruction,
            if_pc_curr     => tb_pc_curr,
            if_pc_next     => tb_pc_next
        );
    process
    begin
        while true loop
            tb_clk <= '1';
            wait for clk_period / 2;
            tb_clk <= '0';
            wait for clk_period / 2;
        end loop;
    end process;
end Behavioral;
