library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.STD_LOGIC_ARITH.all;
  use work.optypes.comp_op;

entity ComparatorUnit is
  port (
    cu_clk     : in  STD_LOGIC;
    cu_rs1_val : in  STD_LOGIC_VECTOR(31 downto 0);
    cu_rs2_val : in  STD_LOGIC_VECTOR(31 downto 0);
    cu_comp_op : in  comp_op;
    cu_result  : out STD_LOGIC
  );
end entity;

architecture RTL of ComparatorUnit is
  signal result : STD_LOGIC;
  signal lt     : STD_LOGIC;
  signal eq     : STD_LOGIC;
  signal ltu    : STD_LOGIC;
begin
  process (cu_rs1_val, cu_rs2_val)
  begin
    lt <= '1' when signed(cu_rs1_val) < signed(cu_rs2_val) else '0';
    eq <= '1' when signed(cu_rs1_val) = signed(cu_rs2_val) else '0';
    ltu <= '1' when unsigned(cu_rs1_val) < unsigned(cu_rs2_val) else '0';
  end process;

  process (cu_rs1_val, cu_rs2_val, cu_comp_op, eq, lt, ltu)
  begin
    case cu_comp_op is
      when comp_eq => -- BEQ
        result <= eq;
      when comp_ne => -- BNE
        result <= not eq;
      when comp_lt => -- BLT
        result <= lt;
      when comp_ge => -- BGE
        result <= not lt;
      when comp_ltu => -- BLTU
        result <= ltu;
      when comp_geu => -- BGEU
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
