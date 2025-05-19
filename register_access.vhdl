library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.NUMERIC_STD.all;

entity RegisterAccess is
  port (
    ra_clk      : in  STD_LOGIC;
    ra_rdaddr   : in  STD_LOGIC_VECTOR(4 downto 0);  -- External address input
    ra_rs1addr  : in  STD_LOGIC_VECTOR(4 downto 0);  -- rs1 address
    ra_rs2addr  : in  STD_LOGIC_VECTOR(4 downto 0);  -- rs2 address
    ra_write_en : in  STD_LOGIC;                     -- Write enable
    ra_rdval    : in  STD_LOGIC_VECTOR(31 downto 0); -- Data to write
    ra_rs1val   : out STD_LOGIC_VECTOR(31 downto 0); -- Output for rs1
    ra_rs2val   : out STD_LOGIC_VECTOR(31 downto 0)  -- Output for rs2
  );
end entity;

architecture RTL of RegisterAccess is
  signal addr_mux_out : STD_LOGIC_VECTOR(4 downto 0);
begin
  addr_mux: entity work.Multiplexer2_1
    generic map (
      WIDTH => 5
    )
    port map (
      mp_a   => ra_rs1addr,   -- External address input
      mp_b   => ra_rdaddr,    -- rs1 address
      mp_out => addr_mux_out, -- Output to register file
      mp_s   => ra_write_en -- Select signal for multiplexer
    );
  registerfile: entity work.RegisterFile
    port map (
      rf_clk     => ra_clk,
      rf_rwaddr  => addr_mux_out, -- Address input from the multiplexer
      rf_rs2addr => ra_rs2addr,   -- External address input
      rf_we      => ra_write_en,
      rf_rdval   => ra_rdval,
      rf_rs1val  => ra_rs1val,    -- Output rs1 value
      rf_rs2val  => ra_rs2val -- Output rs2 value
    );
end architecture;
library IEEE;
  use IEEE.STD_LOGIC_1164.all;
  use IEEE.NUMERIC_STD.all;

entity RegisterAccessTB is
end entity;

architecture RTL of RegisterAccessTB is
  signal clk_period : TIME := 10 ns;

  signal tb_clk     : STD_LOGIC                     := '0';
  signal tb_rdaddr  : STD_LOGIC_VECTOR(4 downto 0)  := (others => '0');
  signal tb_rs1addr : STD_LOGIC_VECTOR(4 downto 0)  := (others => '0');
  signal tb_rs2addr : STD_LOGIC_VECTOR(4 downto 0)  := (others => '0');
  signal tb_we      : STD_LOGIC                     := '1';
  signal tb_rdval   : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal tb_rs1val  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
  signal tb_rs2val  : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
begin
  uut: entity work.RegisterAccess
    port map (
      ra_clk      => tb_clk,
      ra_rdaddr   => tb_rdaddr,
      ra_rs1addr  => tb_rs1addr,
      ra_rs2addr  => tb_rs2addr,
      ra_write_en => tb_we,
      ra_rdval    => tb_rdval,
      ra_rs1val   => tb_rs1val,
      ra_rs2val   => tb_rs2val
    );

  process
  begin
    wait for 10 ns;
    while true loop
      tb_clk <= '1';
      wait for clk_period / 2;
      tb_clk <= '0';
      wait for clk_period / 2;
    end loop;
  end process;

  process
  begin --loop through the first 15 addresses and read them
    wait for 9 ns;
    tb_we <= '0';
    for i in 0 to 15 loop
      tb_rs1addr <= STD_LOGIC_VECTOR(to_unsigned(i, 5));
      tb_rs2addr <= STD_LOGIC_VECTOR(to_unsigned(15 - i, 5));
      wait for clk_period;
    end loop;
    tb_we <= '1';
    for i in 0 to 15 loop
      tb_rdaddr <= STD_LOGIC_VECTOR(to_unsigned(i + 16, 5));
      tb_rdval <= STD_LOGIC_VECTOR(to_unsigned(i, 32));
      wait for clk_period;
    end loop;
    tb_we <= '0';
    for i in 0 to 15 loop
      tb_rs1addr <= STD_LOGIC_VECTOR(to_unsigned(i + 16, 5));
      tb_rs2addr <= STD_LOGIC_VECTOR(to_unsigned(31 - i, 5));
      wait for clk_period;
    end loop;
    wait;
  end process;
end architecture;
