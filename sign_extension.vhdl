--generic sign extension block 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
ENTITY SignExtension IS
    GENERIC (
        se_input_width : INTEGER;
        se_output_width : INTEGER
    );
    PORT (
        se_input : IN STD_LOGIC_VECTOR(se_input_width DOWNTO 0) := (OTHERS => '0');
        se_output : OUT STD_LOGIC_VECTOR(se_output_width DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY SignExtension;
ARCHITECTURE RTL OF SignExtension IS
BEGIN
    PROCESS (se_input)
    BEGIN
        IF se_input(se_input_width - 1) = '1' THEN
            se_output <= (OTHERS => '1') & se_input;
        ELSE
            se_output <= (OTHERS => '0') & se_input;
        END IF;
    END PROCESS;
END ARCHITECTURE RTL;