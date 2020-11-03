library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CompIgual is
	generic (tam: NATURAL);
	port (
		a: in std_logic_vector(tam-1 downto 0);
		b: in std_logic_vector(tam-1 downto 0);
		saida: out std_logic
	);
end entity;

architecture arch of CompIgual is
begin
	saida <= '1' when a = b else '0';
end architecture;