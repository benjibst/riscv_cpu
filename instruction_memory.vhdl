library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity InstructionMemory is
    Port (
        im_addr    : in  STD_LOGIC_VECTOR(11 downto 0):= (others => '0'); -- pc input
        im_clk     : in  STD_LOGIC:='0'; -- clock input
        im_data    : out STD_LOGIC_VECTOR(31 downto 0):= (others => '0')
    );
end InstructionMemory;

architecture Behavioral of InstructionMemory is
    type memory_array is array (0 to 1023) of STD_LOGIC_VECTOR(31 downto 0);
    
    constant rom : memory_array := (
        0 =>    x"80000001", 
        1 =>    x"40000002", 
        2 =>    x"20000004", 
        3 =>    x"10000008",
        4 =>    x"08000010",
        5 =>    x"04000020",
        6 =>    x"02000040",
        7 =>    x"01000080",
        8 =>    x"00800100",
        9 =>    x"00400200",
        10 =>   x"00200400",
        11 =>   x"00100800",
        12 =>   x"00081000",
        13 =>   x"00042000",
        14 =>   x"00024000",
        15 =>   x"00018000",
        others => x"00000000"
    );

    signal word_address : INTEGER range 0 to 1023;
begin
    process(im_clk)
    begin
        if rising_edge(im_clk) then
            -- Read instruction from rom at address
            im_data <= rom(to_integer(unsigned(im_addr(11 downto 2))));
        end if;
    end process;

end Behavioral;