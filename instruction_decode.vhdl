ENTITY InstructionDecode IS
    PORT (
        id_instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        id_rd_write_en : IN STD_LOGIC;
        id_rd_val : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        id_pc_curr : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        id_pc_next : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
        id_pc_curr_se : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        id_pc_next_se : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        id_rs1_val : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        id_rs2_val : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        id_imm_val : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        id_opclass : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
        id_alu_opcode : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        id_a_sel : OUT STD_LOGIC;
        id_b_sel : OUT STD_LOGIC;
        id_cond_opcode : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);

    );
END ENTITY InstructionDecode;