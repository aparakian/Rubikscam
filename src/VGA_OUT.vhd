library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_OUT is
    port (
	 -- CLOCK
    CLOCK_25  : in std_logic;
	 -- material ports
    VGA_CLK   : out std_logic; --Clock
    VGA_HS    : out std_logic; --H_SYNC
    VGA_VS    : out std_logic; --V_SYNC
    VGA_BLANK : out std_logic; --BLANK
    VGA_SYNC  : out std_logic; --SYNC
    VGA_R     : out std_logic_vector(9 downto 0); --Red[9:0]
    VGA_G     : out std_logic_vector(9 downto 0); --Green[9:0]
    VGA_B     : out std_logic_vector(9 downto 0); --Blue[9:0]
	 -- program used ports
	 SCREEN_X  : out integer range 0 to 639 := 0;
	 SCREEN_Y  : out integer range 0 to 479 := 0;
	 VGA_DATA_R : in std_logic_vector(9 downto 0);
	 VGA_DATA_G : in std_logic_vector(9 downto 0);
	 VGA_DATA_B : in std_logic_vector(9 downto 0)
    );
end VGA_OUT;

architecture VGA_OUT_arch of VGA_OUT is

signal screen_pos_y : integer range 0 to 524 := 0;
signal screen_pos_x : integer range 0 to 795 := 0;

begin
process (CLOCK_25)
	begin
	 	if rising_edge(CLOCK_25) then
			screen_pos_x <= screen_pos_x + 1;
			-- update pixel
			if screen_pos_x = 0 then VGA_HS <= '0'; end if;
			if screen_pos_x = 95 then VGA_HS <= '1'; end if;
			if screen_pos_x = 139 and screen_pos_y > 34 and screen_pos_y < 514 then VGA_BLANK <= '1'; end if;
			if screen_pos_x > 139 and screen_pos_x < 780 and screen_pos_y > 34 and screen_pos_y < 514 then 
				-- write pixels
				VGA_B <= VGA_DATA_B;
				VGA_R <= VGA_DATA_R;
				VGA_G <= VGA_DATA_G;
				-- end of pixel writing
			end if;
			if screen_pos_x = 780 then VGA_BLANK <= '0'; end if;
		
			if screen_pos_x = 795 then
				if screen_pos_y = 0 then VGA_VS <= '0'; end if;
				if screen_pos_y = 2 then VGA_VS <= '1'; end if;
				screen_pos_y <= screen_pos_y + 1;
				screen_pos_x <= 0;
				-- end of line
			end if;
		
			if screen_pos_y = 524 then 
				screen_pos_y <= 0;
				-- end of screen
			end if;
		end if;
end process ;

SCREEN_X <= screen_pos_x - 140;
SCREEN_Y <= screen_pos_y - 35;

VGA_CLK <= CLOCK_25;
VGA_SYNC <= '0'; -- signal to keep to zero, overwise, synchronisation makes on green 

end VGA_OUT_arch;
