library IEEE;
  use IEEE.STD_LOGIC_1164.all;

entity DecodeUnit is
  port (
    du_clk        : in  STD_LOGIC;
    du_funct3_in  : in  STD_LOGIC_VECTOR(2 downto 0);
    du_funct7_in  : in  STD_LOGIC_VECTOR(6 downto 0);
    du_opcode     : in  STD_LOGIC_VECTOR(6 downto 0);
    du_funct3_out : out STD_LOGIC_VECTOR(2 downto 0);
    du_a_sel      : out STD_LOGIC; --RS1 or PC
    du_b_sel      : out STD_LOGIC; --RS2 or IMM
    du_opclass    : out STD_LOGIC_VECTOR(4 downto 0)
  );
end entity;

architecture RTL of DecodeUnit is
  signal op_class : STD_LOGIC_VECTOR(4 downto 0);
  signal funct3   : STD_LOGIC_VECTOR(2 downto 0);
  signal a_sel    : STD_LOGIC;
  signal b_sel    : STD_LOGIC;
begin
  funct3 <= du_funct3_in;

  process (du_opcode)
  begin
    case (du_opcode) is
      when "0110011" => -- ALU
        op_class <= "00001";
        a_sel <= '0';
        b_sel <= '0';
      when "0010011" => -- ALU IMM
        op_class <= "00001";
        a_sel <= '0';
        b_sel <= '1';
      when "0100011" => -- Store
        op_class <= "00010";
        a_sel <= '0';
        b_sel <= '1';
      when "0000011" => -- Load
        op_class <= "00100";
        a_sel <= '0';
        b_sel <= '1';
      when "1100011" => -- Branch
        op_class <= "01000";
        a_sel <= '1';
        b_sel <= '1';
      when "1101111" | "1100111" => -- JUMP
        op_class <= "10000";
        a_sel <= '1';
        b_sel <= '1';
      when others =>
        op_class <= "00000";
    end case;
  end process;

  process (du_clk)
  begin
    if (rising_edge(du_clk)) then
      du_opclass <= op_class;
      du_funct3_out <= funct3;
      du_a_sel <= a_sel;
      du_b_sel <= b_sel;
    end if;
  end process;
end architecture;
