	component altpll is
		port (
			altpll_0_c0_clk : out std_logic;        -- clk
			altpll_0_c1_clk : out std_logic;        -- clk
			clk_clk         : in  std_logic := 'X'; -- clk
			reset_reset_n   : in  std_logic := 'X'  -- reset_n
		);
	end component altpll;

	u0 : component altpll
		port map (
			altpll_0_c0_clk => CONNECTED_TO_altpll_0_c0_clk, -- altpll_0_c0.clk
			altpll_0_c1_clk => CONNECTED_TO_altpll_0_c1_clk, -- altpll_0_c1.clk
			clk_clk         => CONNECTED_TO_clk_clk,         --         clk.clk
			reset_reset_n   => CONNECTED_TO_reset_reset_n    --       reset.reset_n
		);

