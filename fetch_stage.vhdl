library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity InstructionFetch is
  port (
    if_clk         : in  STD_LOGIC                     := '0';
    if_load_en     : in  STD_LOGIC                     := '1';
    if_pc_in       : in  STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
    if_instruction : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    if_pc_curr     : out STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
    if_pc_next     : out STD_LOGIC_VECTOR(11 downto 0) := (others => '0')
  );
end entity;

architecture RTL of InstructionFetch is
  signal if_pc_curr_reg : STD_LOGIC_VECTOR(11 downto 0);
begin
  pc: entity work.ProgramCounter(RTL) port map (
    pc_clk     => if_clk,
    pc_load_en => if_load_en,
    pc_in      => if_pc_in,
    pc_curr    => if_pc_curr_reg,
    pc_next    => if_pc_next
  );
  im: entity work.InstructionMemory(RTL) port map (
    im_addr => if_pc_curr_reg(11 downto 0),
    im_clk  => if_clk,
    im_data => if_instruction
  );
  if_pc_curr <= if_pc_curr_reg;

end architecture;

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity InstructionFetchTB is
end entity;

architecture RTL of InstructionFetchTB is
  signal clk_period : TIME := 10 ns;

  signal tb_clk         : STD_LOGIC                     := '0';
  signal tb_load_en     : STD_LOGIC                     := '1';
  signal tb_pc_in       : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
  signal tb_instruction : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal tb_pc_curr     : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
  signal tb_pc_next     : STD_LOGIC_VECTOR(11 downto 0) := (others => '0');
begin
  tb_pc_in <= tb_pc_next;
  uut: entity work.InstructionFetch(RTL) port map (
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
end architecture;
