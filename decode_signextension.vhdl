library IEEE;
  use IEEE.STD_LOGIC_1164.all;

entity DecodeSignExtension is
  port (
    dse_clk    : in  STD_LOGIC;
    dse_instr  : in  STD_LOGIC_VECTOR(31 downto 0);
    dse_se_out : out STD_LOGIC_VECTOR(31 downto 0)
  );
end entity;

architecture RTL of DecodeSignExtension is
  signal opcode        : STD_LOGIC_VECTOR(6 downto 0);
  signal funct3        : STD_LOGIC_VECTOR(2 downto 0);
  signal sign_extended : STD_LOGIC_VECTOR(31 downto 0);
begin
  opcode <= dse_instr(6 downto 0);
  funct3 <= dse_instr(14 downto 12);

  process (dse_instr)
  begin
    case (opcode) is
      when "0110011" => -- ALU operations are between 2 registers so no sign extension
        sign_extended <= (others => '0');
      when "0010011" => -- ALU immediate operations
        case funct3 is
          when "001" => -- SLLI
            sign_extended <= (others => '0'); --no sign extension needed for shifting instructions
          when "101" => -- SRLI/SRAI
            sign_extended <= (others => '0');
          when others =>
            sign_extended <= (others => '0') & dse_instr(31 downto 20); -- sign extend immediate
        end case;
      when "0100011" => -- Store
        sign_extended <= (others => '0') & dse_instr(31 downto 25) & dse_instr(11 downto 7);
      when "0000011" => -- Load
        sign_extended <= (others => '0') & dse_instr(31 downto 20);
      when "1100011" => -- Branch
        sign_extended <= (others => '0') & dse_instr(31) & dse_instr(7) & dse_instr(30 downto 25) & dse_instr(11 downto 8);
      when "1101111" => -- JUMP
        sign_extended <= (others => '0') & dse_instr(31) & dse_instr(19 downto 12) & dse_instr(20) & dse_instr(30 downto 21);
    end case;
  end process;

  process (dse_clk)
  begin
    if (rising_edge(dse_clk)) then
      dse_se_out <= sign_extended;
    end if;
  end process;
end architecture;

library IEEE;
  use IEEE.STD_LOGIC_1164.all;

entity DecodeSignExtensionTB is
end entity;

architecture RTL of DecodeSignExtensionTB is
  signal tb_clk    : STD_LOGIC                     := '0';
  signal tb_instr  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal tb_se_out : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

begin

  uut: entity work.DecodeSignExtension(RTL) port map (
    dse_clk    => tb_clk,
    dse_instr  => tb_instr,
    dse_se_out => tb_se_out
  );

  process
  begin
    while true loop
      tb_clk <= '1';
      wait for 10 ns;
      tb_clk <= '0';
      wait for 10 ns;
    end loop;
  end process;

  process
  begin
    -- test every insctruction class
    --test JUMP
    tb_instr <= "1_0000110000_1_11000000"; -- JUMP
  end process;
end architecture;
