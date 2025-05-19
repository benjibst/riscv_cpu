library IEEE;
  use IEEE.STD_LOGIC_1164.all;

entity ImmediateExtension is
  port (
    ie_clk     : in  STD_LOGIC;
    ie_instr   : in  STD_LOGIC_VECTOR(31 downto 0);
    ie_imm_out : out STD_LOGIC_VECTOR(31 downto 0)
  );
end entity;

architecture RTL of ImmediateExtension is
  signal opcode        : STD_LOGIC_VECTOR(6 downto 0);
  signal sign_extended : STD_LOGIC_VECTOR(31 downto 0);
begin
  opcode <= ie_instr(6 downto 0);

  process (ie_instr)
  begin
    case (opcode) is
      ----------------------------------------------------------------
      when "0110011" => -- R type instructions (ALU with 2 register operands)
        sign_extended <= (others => '0');
      ----------------------------------------------------------------
      when "0010011" | "0000011" | "1100111" => -- I type instructions (ALU with register and immediate | LOAD instructions | JALR instruction)
        sign_extended <= (others => '0') & ie_instr(31 downto 20) when ie_instr(31) = '0'
      else
        (others => "1") & ie_instr(31 downto 20);
      ----------------------------------------------------------------
      when "0100011" => -- S type instructions (STORE)
        sign_extended <= (others => '0') & ie_instr(31 downto 25) & ie_instr(11 downto 7) when ie_instr(31) = '0'
      else
        (others => "1") & ie_instr(31 downto 25) & ie_instr(11 downto 7);
      ----------------------------------------------------------------
      when "1100011" => -- B type instructions (BRANCH)
        sign_extended <= (others => '0') & (ie_instr(31) & ie_instr(7) & ie_instr(30 downto 25) & ie_instr(11 downto 8)) when ie_instr(31) = '0'
      else
        (others => '1') & (ie_instr(31) & ie_instr(7) & ie_instr(30 downto 25) & ie_instr(11 downto 8));
      ----------------------------------------------------------------
      when "1101111" => -- J type instructions (only JAL)
        sign_extended <= (others => '0') & (ie_instr(31) & ie_instr(19 downto 12) & ie_instr(20) & ie_instr(30 downto 21)) when ie_instr(31) = '0'
      else
        (others => "1") & (ie_instr(31) & ie_instr(19 downto 12) & ie_instr(20) & ie_instr(30 downto 21));
      ----------------------------------------------------------------
      when "0110111" | "0010111" => -- U type instructions
        sign_extended <= (ie_instr(31 downto 12) & (others => '0'));
    end case;
  end process;

  process (ie_clk)
  begin
    if (rising_edge(ie_clk)) then
      ie_imm_out <= sign_extended;
    end if;
  end process;
end architecture;
