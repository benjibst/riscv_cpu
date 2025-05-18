library IEEE;
  use IEEE.STD_LOGIC_1164.all;

entity InstructionDecode is
  port (
    id_instruction : in  STD_LOGIC_VECTOR(31 downto 0);
    id_rd_write_en : in  STD_LOGIC;
    id_rd_val      : in  STD_LOGIC_VECTOR(31 downto 0);
    id_pc_curr     : in  STD_LOGIC_VECTOR(11 downto 0);
    id_pc_next     : in  STD_LOGIC_VECTOR(11 downto 0);
    id_pc_curr_se  : out STD_LOGIC_VECTOR(31 downto 0);
    id_pc_next_se  : out STD_LOGIC_VECTOR(31 downto 0);
    id_rs1_val     : out STD_LOGIC_VECTOR(31 downto 0);
    id_rs2_val     : out STD_LOGIC_VECTOR(31 downto 0);
    id_imm_val     : out STD_LOGIC_VECTOR(31 downto 0);
    id_opclass     : out STD_LOGIC_VECTOR(4 downto 0);
    id_alu_opcode  : out STD_LOGIC_VECTOR(2 downto 0);
    id_a_sel       : out STD_LOGIC;
    id_b_sel       : out STD_LOGIC;
    id_cond_opcode : out STD_LOGIC_VECTOR(2 downto 0)

  );
end entity;

architecture RTL of InstructionDecode is
  signal rd     : STD_LOGIC_VECTOR(4 downto 0);
  signal rs1    : STD_LOGIC_VECTOR(4 downto 0);
  signal rs2    : STD_LOGIC_VECTOR(4 downto 0);
  signal imm    : STD_LOGIC_VECTOR(31 downto 0);
  signal opcode : STD_LOGIC_VECTOR(6 downto 0);
  signal funct3 : STD_LOGIC_VECTOR(2 downto 0);
  signal funct7 : STD_LOGIC_VECTOR(6 downto 0);
begin
  current_pc_se: entity work.SignExtension(RTL) port map (
    se_in  => id_pc_curr,
    se_out => id_pc_curr_se
  );
  next_pc_se: entity work.SignExtension(RTL) port map (
    se_in  => id_pc_next,
    se_out => id_pc_next_se
  );
end architecture;
