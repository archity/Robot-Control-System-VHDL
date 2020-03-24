library ieee;
use ieee.std_logic_1164.all;

entity Count is
    generic(threshold : natural);
    port(reset, clk, start : in std_logic;
    aboveth : out std_logic);
end Count;


architecture Behav of Count is
    type States is (idle, counting);
    signal state, nextState : States;
    signal c : natural := 0;
    begin
        -- Update the current state to the next state at the rising edge of clk
	    process(reset, clk)
	    begin
		    if (reset = '1') then state <= idle;
		    elsif (clk'event and clk='1') then
			    state <= nextState;
		    end if;
        end process;
        
        process(start, state, clk)
        begin
            if(rising_edge(clk))
            then
            case state is

                when idle =>
                    if start = '1' then nextState <= counting;
                    elsif start = '0' then nextState <= idle;
                    end if;

                when counting =>
                    if c >= threshold then nextState <= idle;
                    elsif c < threshold then nextState <= counting;
                    end if;

            end case;
            end if;
        end process;


        process(start, state, clk)
        begin
            if(rising_edge(clk))
            then

                if(state = idle and start = '0')
                then c <= 0;
                    if(c >= threshold )
                    then aboveth <= '1';
                    else aboveth <= '0';
                    end if;
                end if;

                if(state = idle and start = '1')
                then c <= c + 1;
                    if(c >= threshold )
                    then aboveth <= '1';
                    else aboveth <= '0';
                    end if;
                end if;

                if(state = counting and c < threshold)
                then c <= c + 1;
                    if(c >= threshold )
                    then aboveth <= '1';
                    else aboveth <= '0';
                    end if;
                end if;

                if(state = counting and c >= threshold)
                then c <= 0;
                    if(c >= threshold )
                    then aboveth <= '1';
                    else aboveth <= '0';
                    end if;
                end if;
            end if;
        end process;

end Behav;