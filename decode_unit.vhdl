library IEEE;
  use IEEE.STD_LOGIC_1164.all;

entity DecodeUnit is
  port (
    du_clk         : in  STD_LOGIC;
    du_funct3      : in  STD_LOGIC_VECTOR(2 downto 0);
    du_funct7      : in  STD_LOGIC_VECTOR(6 downto 0);
    du_opcode      : in  STD_LOGIC_VECTOR(6 downto 0);
    du_opclass     : out STD_LOGIC_VECTOR(4 downto 0);
    du_alu_opcode  : out STD_LOGIC_VECTOR(2 downto 0);
    du_a_sel       : out STD_LOGIC;                   --TODO
    du_b_sel       : out STD_LOGIC;                   --TODO
    du_cond_opcode : out STD_LOGIC_VECTOR(2 downto 0);
    du_opclass_pre : out STD_LOGIC_VECTOR(4 downto 0) --non latched as input to sign extension unit
  );
end entity;
-- opcode: xxxxx11
-- ALU: 0110011
-- Store: 0100011
-- Load: 0000011
-- Branch: 1100011
-- Jump: 1101111

architecture RTL of DecodeUnit is
  signal op_class : STD_LOGIC_VECTOR(4 downto 0);
  signal alu_op   : STD_LOGIC_VECTOR(2 downto 0);
  signal a_sel    : STD_LOGIC;
  signal b_sel    : STD_LOGIC;
  signal cond_op  : STD_LOGIC_VECTOR(2 downto 0);
begin
  cond_op <= du_funct3;
  alu_op  <= du_funct3;

  process (du_opcode)
  begin
    case (du_opcode) is
      when "0110011" => -- ALU
        op_class <= "00001";
      when "0010011" => -- ALU immediate --different opcode, have different encodings
        op_class <= "00001";
      when "0100011" => -- Store
        op_class <= "00010";
      when "0000011" => -- Load
        op_class <= "00100";
      when "1100011" => -- Branch
        op_class <= "01000";
      when "1101111" => -- JUMP
        op_class <= "10000";
      when others =>
        op_class <= "00000";
    end case;
  end process;

  process (du_clk)
  begin
    if (rising_edge(du_clk)) then
      du_opclass <= op_class;
      du_alu_opcode <= alu_op;
      du_a_sel <= a_sel;
      du_b_sel <= b_sel;
      du_cond_opcode <= cond_op;
    end if;
  end process;
end architecture;
