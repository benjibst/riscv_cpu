library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity ComparatorUnit is
  port (
    cu_clk     : in  STD_LOGIC;
    cu_rs1_val : in  STD_LOGIC_VECTOR(31 downto 0);
    cu_rs2_val : in  STD_LOGIC_VECTOR(31 downto 0);
    cu_funct3  : in  STD_LOGIC_VECTOR(2 downto 0);
    cu_result  : out STD_LOGIC
  );
end entity;

architecture RTL of ComparatorUnit is
  signal result : STD_LOGIC;
  signal lt     : STD_LOGIC;
  signal le     : STD_LOGIC;
  signal ltu    : STD_LOGIC;
begin
  process (cu_rs1_val, cu_rs2_val)
  begin
    lt <= '1' when signed(cu_rs1_val) < signed(cu_rs2_val) else '0';
    le <= '1' when signed(cu_rs1_val) <= signed(cu_rs2_val) else '0';
    ltu <= '1' when unsigned(cu_rs1_val) < unsigned(cu_rs2_val) else '0';
  end process;

  process (cu_rs1_val, cu_rs2_val, cu_funct3)
  begin
    case (cu_funct3) is
      when "000" => -- BEQ
        result <= le and not lt;
      when "001" => -- BNE
        result <= not le or lt;
      when "100" => -- BLT
        result <= lt;
      when "101" => -- BGE
        result <= not lt;
      when "110" => -- BLTU
        result <= ltu;
      when "111" => -- BGEU
        result <= not ltu;
      when others =>
        result <= '0';
    end case;
  end process;

  process (cu_clk)
  begin
    if (rising_edge(cu_clk)) then
      cu_result <= result;
    end if;
  end process;
end architecture;
