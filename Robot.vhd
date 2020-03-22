library ieee;
use ieee.std_logic_1164.all;

entity Robot is
	port(reset, clk, athome, findfood, lostfood, closetofood, success, aboverestth, abovesearchth, scantimeup : in std_logic;
	 rest, search, food : out std_logic);
end Robot;
 
architecture Automaton of Robot is
type States is (idle, resting, randomwalk, movetofood, scanarena, homing, grabfood, movetohome, deposit);
signal state, nextState : States;
begin

	-- Update the current state to the next state at the rising edge of clk
	process(reset, clk)
	begin
		if (reset = '1') then state <= idle;
		elsif (clk'event and clk='1') then
			state <= nextState;
		end if;
	end process;

	process(state, athome, findfood, lostfood, closetofood, success, aboverestth, abovesearchth, scantimeup)
	begin
		case state is

			-- The control is sent from one state (state) to another state (nextState) depending
			-- upon the control signals, based on the state diagram.

			when idle =>
				nextState <= resting;

			when resting =>
				if aboverestth = '1' then nextState <= randomwalk;
				else nextState <= resting;
				end if;

			when randomwalk =>
				if abovesearchth = '1' then nextState <= homing;
				elsif findfood = '1' and abovesearchth = '0' then nextState <= movetofood;
				elsif findfood = '0' and abovesearchth = '0' then nextState <= randomwalk;
				end if;

			when homing =>
				if athome = '1' then nextState <= resting;
				elsif athome = '0' then nextState <= homing;
				end if;

			when movetofood =>
				if abovesearchth = '1' then nextState <= homing;
				elsif abovesearchth = '0' and lostfood = '1' then nextState <= scanarena;
				elsif abovesearchth = '0' and lostfood = '0' and closetofood = '1' then nextState <= grabfood;
				elsif abovesearchth = '0' and lostfood = '0' and closetofood = '0' then nextState <= movetofood;
				end if;

			when scanarena =>
				if abovesearchth = '1' then nextState <= homing;
				elsif abovesearchth = '0' and findfood = '1' then nextState <= movetofood;
				elsif abovesearchth = '0' and findfood = '0' and scantimeup = '1' then nextState <= randomwalk;
				elsif abovesearchth = '0' and findfood = '0' and scantimeup = '0' then nextState <= scanarena;
				end if;

			when grabfood =>
				if success = '1' then nextState <= movetohome;
				elsif success = '0' then nextState <= grabfood;
				end if;

			when movetohome =>
				if athome = '1' then nextState <= deposit;
				elsif athome = '0' then nextState <= movetohome;
				end if;

			when deposit =>
				if success = '1' then nextState <= resting;
				elsif success = '0' then nextState <= deposit;
				end if;

		end case;

	end process;


	
	-- This process block assigns output signal based on current state and input signals.

	process(state, athome, findfood, lostfood, closetofood, success, aboverestth, abovesearchth, scantimeup)
	begin
		if(state = idle)
		then rest <= '1';
		end if;

		if(state = resting and aboverestth = '1')
		then search <= '1';
		else search <= '0';
		end if;

		if(state = movetofood and closetofood = '1' and abovesearchth = '0' and lostfood = '0')
		then food <= '1';
		else food <= '0';
		end if;

		if( (state = homing and athome = '1') or (state = deposit and success = '1') )
		then rest <= '1';
		else rest <= '0';
		end if;
	end process;

end Automaton;





