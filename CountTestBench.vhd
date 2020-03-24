library ieee;
use ieee.std_logic_1164.all;

entity CountTestBench is
end CountTestBench;

architecture testCount of CountTestBench is
    constant THRESH_VALUE: integer :=  5;
    component Count is
        generic(threshold : natural);
        port(reset, clk, start : in std_logic;
        aboveth : out std_logic);
    end component Count;

    signal reset, clk, start : std_logic := '0';
    signal aboveth : std_logic := '0';
    signal threshold: natural := 0;

    begin
        A: Count
            generic map(threshold => THRESH_VALUE)
            port map(reset, clk, start, aboveth);
            

        reset <= '1', '0' after 5 ns;
        start <= '1' after 5 ns;



        process
        begin
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
        end process;
        
end architecture testCount;


library work;


configuration config1 of work.CountTestBench is 
    for testCount 
       for A : Count use entity work.Count(Automaton);
       end for;
    end for; 
end config1;
