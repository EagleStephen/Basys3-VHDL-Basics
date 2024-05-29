----------------------------------------------------------------------------------
-- Company: Abdullah Gul University
-- Engineer: Bilal KABAS
-- 
-- Create Date: 07.02.2020 22:49:47
-- Module Name: Example 1 - Behavioral
-- Project Name: Example 1
-- Target Devices: Basys3
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity example1 is
  Generic (
    SWITCH_NUM  : integer:= 16);
  
  Port (
    sw          : in std_logic_vector(SWITCH_NUM - 1 downto 0);
    led         : out std_logic_vector(SWITCH_NUM - 1 downto 0));
end example1;

architecture Behavioral of example1 is
begin
    led <= sw;
end Behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pulse_delay is
    Port (
        clk : in STD_LOGIC;
        rst : in STD_LOGIC;
        pulse_in : in STD_LOGIC;
        pulse_out : out STD_LOGIC
    );
end pulse_delay;

architecture Behavioral of pulse_delay is
    signal pulse_reg : std_logic_vector(1 downto 0); -- Two stage shift register
begin
    process(clk, rst)
    begin
        if rst = '1' then
            pulse_reg <= (others => '0');
        elsif rising_edge(clk) then
            pulse_reg <= pulse_reg(0) & pulse_in; -- Shift register
        end if;
    end process;

    pulse_out <= pulse_reg(1); -- Delayed pulse
end Behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_pulse_delay is
end tb_pulse_delay;

architecture Behavioral of tb_pulse_delay is
    -- Component Declaration
    component pulse_delay
        Port (
            clk : in STD_LOGIC;
            rst : in STD_LOGIC;
            pulse_in : in STD_LOGIC;
            pulse_out : out STD_LOGIC
        );
    end component;

    -- Signals for testbench
    signal clk_tb : STD_LOGIC := '0';
    signal rst_tb : STD_LOGIC := '0';
    signal pulse_in_tb : STD_LOGIC := '0';
    signal pulse_out_tb : STD_LOGIC;

    -- Clock period
    constant clk_period : time := 10 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: pulse_delay
        Port map (
            clk => clk_tb,
            rst => rst_tb,
            pulse_in => pulse_in_tb,
            pulse_out => pulse_out_tb
        );

    -- Clock process
    clk_process: process
    begin
        while true loop
            clk_tb <= '0';
            wait for clk_period/2;
            clk_tb <= '1';
            wait for clk_period/2;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize Inputs
        rst_tb <= '1';
        wait for clk_period * 2;
        rst_tb <= '0';

        -- Apply pulse every 10 clock cycles
        for i in 0 to 99 loop
            if (i mod 10 = 0) then
                pulse_in_tb <= '1';
            else
                pulse_in_tb <= '0';
            end if;
            wait for clk_period;
        end loop;

        -- Stop simulation
        wait;
    end process;

end Behavioral;




