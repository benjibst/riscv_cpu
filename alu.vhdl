library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.riscv_types_pkg.all;

entity ALU is
  port (
    alu_clk        : in  STD_LOGIC;
    alu_a          : in  STD_LOGIC_VECTOR(31 downto 0);
    alu_b          : in  STD_LOGIC_VECTOR(31 downto 0);
    alu_op         : in  alu_op;
    alu_result     : out STD_LOGIC_VECTOR(31 downto 0);
    alu_result_pre : out STD_LOGIC_VECTOR(31 downto 0)
  );
end entity;

architecture RTL of ALU is
  signal result : STD_LOGIC_VECTOR(31 downto 0);

  function sra32(val : signed(31 downto 0); amount : integer) return signed is
    variable res : signed(31 downto 0);
  begin
    if amount >= 32 then
      if val(31) = '1' then
        res := (others => '1'); -- Sign extend with '1'
      else
        res := (others => '0');
      end if;
    else
      res := (val(31) & val(31 downto amount)); -- Shift with sign extension
      for i in 0 to amount - 1 loop
        res(i) := val(31); -- Sign extend lower bits
      end loop;
    end if;
    return res;
  end function;
begin
  alu_result_pre <= result;

  process (alu_a, alu_b, alu_op)
  begin
    result <= (others => '0'); -- Default value
    case alu_op is
      when alu_add =>
        result <= std_logic_vector(signed(alu_a) + signed(alu_b));
      when alu_sub =>
        result <= std_logic_vector(signed(alu_a) - signed(alu_b));
      when alu_sll =>
        result <= std_logic_vector(signed(alu_a) sll to_integer(unsigned(alu_b)));
      when alu_srl =>
        result <= std_logic_vector(signed(alu_a) srl to_integer(unsigned(alu_b)));
      when alu_sra =>
        result <= std_logic_vector(shift_right(signed(alu_a), to_integer(unsigned((alu_b)))));
      when alu_slt =>
        result(0) <= '1' when signed(alu_a) < signed(alu_b)
      else
      '0';
      when alu_sltu =>
        result(0) <= '1' when unsigned(alu_a) < unsigned(alu_b)
      else
      '0';
      when alu_xor =>
        result <= alu_a xor alu_b;
      when alu_or =>
        result <= alu_a or alu_b;
      when alu_and =>
        result <= alu_a and alu_b;
      when alu_lui =>
        result <= alu_b;
    end case;
  end process;

  process (alu_clk)
  begin
    if (rising_edge(alu_clk)) then
      alu_result <= result;
    end if;
  end process;
end architecture;
