library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplexador4 is
	generic (
		width: positive := 8
	);
	port(
		inp0, inp1, inp2, inp3: in std_logic_vector(width-1 downto 0);
		sel: in std_logic_vector(1 downto 0);
		outp: out std_logic_vector(width-1 downto 0)
	);
end entity;

architecture behavioural of multiplexador4 is
	signal tmp: std_logic_vector(width-1 downto 0);
begin
	with sel select
		tmp <= 	inp0 when "00",
					inp1 when "01",
					inp2 when "10",
					inp3 when others;
	outp <= tmp  after 1ns;
end;