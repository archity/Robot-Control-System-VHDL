library ieee;
use ieee.std_logic_1164.all;

entity RobotTestBench is
end RobotTestBench;

architecture test of RobotTestBench is
    component Robot is
        port(reset, clk, athome, findfood, lostfood, closetofood, success, aboverestth, abovesearchth, scantimeup : in std_logic;
     rest, search, food : out std_logic);
    end component;

    signal reset, clk, athome, findfood, lostfood, closetofood, success, aboverestth, abovesearchth, scantimeup, rest, search, food : std_logic := '0';


    begin
        A: Robot port map(reset, clk, athome, findfood, lostfood, closetofood, success, aboverestth, abovesearchth, scantimeup,
         rest, search, food);
            reset <= '1', '0' after 5 ns;


            aboverestth <= '0', '1' after 10 ns;
            findfood <= '0', '1' after 15 ns;

            lostfood <= '1' after 20 ns;




        process
        begin
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
            clk <= '0';
	    end process;
        

    end test;



library work;


configuration config1 of work.RobotTestBench is 
    for test 
       for A : Robot use entity work.Robot(Automaton);
       end for;
    end for; 
end config1; 
