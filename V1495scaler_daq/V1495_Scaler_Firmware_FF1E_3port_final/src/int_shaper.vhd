--*********************************************************************************
-- 
-- Ethan Hazelton 
--  => 
--********************************************************************************
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

entity int_shaper is
  generic(
     max : integer := 20
  );
  port (
    clk        : in  std_logic;
    input      : in  std_logic; 
	 output     : out std_logic 
    );
end int_shaper;

architecture arch of int_shaper is

   type state is (IDLE_s, LOW_s, HIGH_s, WAIT_s);
   signal current_state : state := IDLE_s;
   
	signal count_low : integer := 0;
	signal count_high : integer := 0;
	signal out_sig : std_logic := '0';
	
begin

machine: process(clk)
begin
	if(rising_edge(clk)) then
	  
	  case current_state is 
	  when IDLE_s =>
	    out_sig <= '0'; 
	    if (input = '1') then
	      current_state <= LOW_s;
	    else 
		   current_state <= IDLE_s;
		 end if;
		 
		
	  when LOW_s =>
	    out_sig <= '0'; 
		 if(count_low = max - 1) then
		   current_state <= HIGH_s;
			count_low <= 0;
		 else 
		   count_low <= count_low + 1;
			current_state <= LOW_s;
		 end if; 
	  
	  
	  when HIGH_s => 
	     out_sig <= '1';
		  if(count_high = max - 1) then
		   current_state <= WAIT_s;
			count_high <= 0;
		 else 
		   count_high <= count_high + 1;
			current_state <= HIGH_s;
		 end if; 
		 
	  when WAIT_s => 
	    out_sig <= '0'; 
		 if(input = '0') then
		   current_state <= IDLE_s;
		 else 
		   current_state <= WAIT_s;
		 end if; 
		 
		 
		 
		when others=>
        out_sig <= '0'; 
		  
		  
     end case;
		  
	 
		
	end if;
	
end process machine;

output <= out_sig;


end arch;