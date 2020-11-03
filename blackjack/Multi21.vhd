library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Multi21 is
	generic (tam: NATURAL);
	port (
		a: in std_logic_vector(tam-1 downto 0);
		b: in std_logic_vector(tam-1 downto 0);
		op: in std_logic;
		saida: out std_logic_vector(tam-1 downto 0)
	);
end entity;

architecture arch of Multi21 is
begin
	saida <= a when op = '0' else b;
				
end architecture;