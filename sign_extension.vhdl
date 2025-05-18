--generic sign extension

library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

entity SignExtension is
  generic (
    se_input_width  : INTEGER;
    se_output_width : INTEGER
  );
  port (
    se_in  : in  STD_LOGIC_VECTOR(se_input_width downto 0)  := (others => '0');
    se_out : out STD_LOGIC_VECTOR(se_output_width downto 0) := (others => '0')
  );
end entity;

architecture RTL of SignExtension is
begin
  se_out <= (others => '1') & se_in when se_in(se_input_width - 1) = '1' else
             (others => '0') & se_in;
end architecture;
