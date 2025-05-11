library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ProgramCounter is
    Port (
        pc_clk         : in  STD_LOGIC;
        pc_load_en     : in  STD_LOGIC; -- TODO: implement load enable
        pc_in       : in  STD_LOGIC_VECTOR(11 downto 0);
        pc_curr     : out STD_LOGIC_VECTOR(11 downto 0);
        pc_next     : out STD_LOGIC_VECTOR(11 downto 0)
    );
end ProgramCounter;

architecture Behavioral of ProgramCounter is
    signal pc_num       : UNSIGNED(11 downto 0); 
begin
    process(pc_clk)
    begin
        if rising_edge(pc_clk) then
            pc_num <= unsigned(pc_in) + 4;
        end if;
    end process;

    pc_curr <= pc_in; -- forward current value
    pc_next <= STD_LOGIC_VECTOR(pc_num); -- append trailing zeros
end Behavioral;


