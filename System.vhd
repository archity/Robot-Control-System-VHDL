library ieee;
use ieee.std_logic_1164.all;

entity System is
    port(reset_sys, clk_sys, athome_sys, findfood_sys, lostfood_sys, closetofood_sys, success_sys, scantimeup_sys : in std_logic;
    food_sys : out std_logic);
end System;


architecture AutomatonSystem of System is
    
    constant THRESH_REST_VALUE: integer :=  4;
    constant THRESH_SEARCH_VALUE: integer :=  10;

    component Robot
        port(
            reset, clk, athome, findfood, lostfood, closetofood, success, aboverestth, abovesearchth, scantimeup : in std_logic;
            rest, search, food : out std_logic
        );
    end component;

    component Count 
        generic(threshold : natural);
        port(
            reset, clk, start : in std_logic;
            aboveth : out std_logic
        );
    end component;

    -- These are wire signals used for interconnecting the 3 instances of components.
    signal rest_signal, search_signal, aboverestth_signal, abovesearchth_signal : std_logic;
    --signal threshold : natural := 0;
    begin
        U1 : Robot
        port map(
            reset => reset_sys,
            clk => clk_sys,
            athome => athome_sys,
            findfood => findfood_sys,
            lostfood => lostfood_sys,
            closetofood => closetofood_sys,
            success => success_sys,
            scantimeup => scantimeup_sys,
            aboverestth => aboverestth_signal,
            abovesearchth => abovesearchth_signal,

            rest => rest_signal,
            search => search_signal,
            food => food_sys
        );

        U2 : Count 
        generic map(threshold => THRESH_REST_VALUE)
        port map(
            reset => reset_sys,
            clk => clk_sys,
            start => rest_signal,
            aboveth => aboverestth_signal

        );

        U3 : Count 
        generic map(threshold => THRESH_SEARCH_VALUE)
        port map(
            reset => reset_sys,
            clk => clk_sys,
            start => search_signal,
            aboveth => abovesearchth_signal

        );
    
end AutomatonSystem;

    

