library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--Mudar o cmdResetI pra 2 bits

entity blocoOperativo is
	generic(
		dataWidth: positive := 8;
		addressWidth: positive := 8
	);
	port(
		-- control inputs
		clk		: in std_logic;
		reset_req: in std_logic;
		-- data inputs
		address	: IN STD_LOGIC_VECTOR (addressWidth-1 DOWNTO 0);
		writedata: IN STD_LOGIC_VECTOR (dataWidth-1 DOWNTO 0);
		-- data outputs
		readdata	: OUT STD_LOGIC_VECTOR (dataWidth-1 DOWNTO 0);
		-- commands from OperativeBlock
		 cmdAcabaJogo, cmdMemRAM, cmdSetI, cmdResetI, cmdSomaPontos, cmdSubTam, cmdSubCarta, cmdResetBaralho, cmdSetBaralho, cmdResetTam, 
			cmdSetTam, cmdMultI, cmdSetPontos,cmdResetPontos, cmdSetAddCarta, cmdResetAddCarta,
			cmdSetCarta,cmdResetCarta,cmdResetPos, cmdSetPos, cmdSetBaralhoI, cmdMultBaralho: in std_logic;
		
			
		--status to OperativeBlock
		sttPontosMaiorDezesseis, sttPontosMaiorVinte, sttCompBaralho, sttIMenor13, sttAddCarta: out std_logic
	);
end entity;

architecture datapath of blocoOperativo is
	
	component Multi21 is
		generic (tam: NATURAL);
		port (
			a: in std_logic_vector(tam-1 downto 0);
			b: in std_logic_vector(tam-1 downto 0);
			op: in std_logic;
			saida: out std_logic_vector(tam-1 downto 0)
		);
	end component;
	
	component incrementador is
		generic(
			width: positive := 8;
			isSigned: boolean := true
		);
		port(
			inp: in std_logic_vector(width-1 downto 0);
			outp: out std_logic_vector(width-1 downto 0)
		);
	end component;
	
	component decrementador is
		generic(
			width: positive := 8;
			isSigned: boolean := true
		);
		port(
			inp: in std_logic_vector(width-1 downto 0);
			outp: out std_logic_vector(width-1 downto 0)
		);
	end component;
	
	component CompMaior is
		generic (tam: NATURAL);
		port (
			a: in std_logic_vector(tam-1 downto 0);
			b: in std_logic_vector(tam-1 downto 0);
			saida: out std_logic
		);
	end component;
	
	component CompIgual is
		generic (tam: NATURAL);
		port (
			a: in std_logic_vector(tam-1 downto 0);
			b: in std_logic_vector(tam-1 downto 0);
			saida: out std_logic
		);
	end component;
	
	component registrador is
		generic(
			width: positive := 8
		);
		port(
			-- control inputs
			clk, reset, load: in std_logic;
			-- data inputs
			datain: in std_logic_vector(width-1 downto 0);
			-- data outputs
			dataout: out std_logic_vector(width-1 downto 0)
		);
	end component;
	
	component Soma2 is
		generic (dataWidth: positive := 8);
		Port ( NUM1 : in  STD_LOGIC_VECTOR (dataWidth-1 downto 0);
				  NUM2 : in  STD_LOGIC_VECTOR (dataWidth-1 downto 0);
				  SUM : out  STD_LOGIC_VECTOR (dataWidth-1 downto 0));
	end component;

	component memoriaRAM is
		PORT(
			address	: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			clock		: IN STD_LOGIC  := '1';
			data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			wren		: IN STD_LOGIC ;
			q			: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
		);
	end component;

	signal  incI_out, regPos_out, regI_in, regI_out, decTam_out, multRAMI_out,
				regTam_in, regTam_out, regCarta_out, regPontos_out, regPontos_in, regPos_in, RAM_out, incIRAM_out: std_logic_vector(dataWidth-1 downto 0);
				
	signal	fioAddress: std_logic_vector(7 downto 0);
	signal	fioWidth: std_logic_vector(7 downto 0);

begin

	readdata <= regPontos_out;

	--Logica combinacional do I ====================================
	--i = pos 							==> cmdMultI
	
	MultI: Multi21
		generic map (dataWidth)
		port map (a=> incI_out, b=> regPos_out,  op =>cmdMultI, saida => regI_in);

	--Incrementador de I		
	--i = i ++; 					    	 ==> cmdSetI, cmdResetI

	IncI: incrementador
		generic map (dataWidth, true)
		port map ( inp => regI_out, outp => incI_out);

	--Registrador do I
	--i = 0  	==> cmdSetI, cmdResetI

	RegI: registrador
		generic map (dataWidth)
		port map (clk => clk, reset => cmdResetI, load => cmdSetI, datain =>  regI_in, dataout =>regI_out );

	--Logica combinacional do Tamanho ====================================
	
	--Multiplexador do tamanho
	--Reset parta o tam inicial; tam = 52 		==> cmdResetTam

	MultTam: Multi21
	generic map (dataWidth)
	port map (a=> decTam_out, b=> "00110100", op => cmdResetTam, saida => regTam_in);

	--Decrementador do Tamanho	
	--tam = tam --;  		   	   		==> cmdSetTam, cmdResetTam

	decTam: decrementador
		generic map (dataWidth, true)
		port map (inp => regTam_out, outp => decTam_out);

	--Registrador do Tamanho
	--tam = input()		==> cmdSetTam
	
	RegTam: registrador
		generic map (dataWidth)
		port map (clk => clk, reset => cmdResetTam, load => cmdSetTam, datain =>  regTam_in, dataout =>regTam_out );

	--Usamos o comparador maior ao contrário para economizar recursos

	--Logica do Datapath do Carta ====================================
	
	--Registrador de Cartas
	--carta = input()			==> cmdSetCarta

	RegCarta: registrador 
		generic map (dataWidth)
		port map (clk => clk, reset => cmdResetCarta, load => cmdSetCarta, datain => writedata, dataout => regCarta_out );

	--Logica do Datapath do Pontos ====================================

	--Somador dos pontos
	--pontos = pontos + carta		==> cmdSomaPontos

	SumPontos: Soma2
		generic map (dataWidth)
		port map (NUM1 => regPontos_out, NUM2 => regCarta_out, SUM => regPontos_in);

	--Registrador dos pontos 
	--pontos = pontos + carta 		==> cmdSetPontos

	RegPontos: registrador 
		generic map (dataWidth)
		port map (clk => clk, reset => cmdResetPontos, load => cmdSetPontos, datain =>  regPontos_in, dataout => regPontos_out );

	--Multiplexador dos pontos
	--
	
	CompPontos16: CompMaior
		generic map (dataWidth)
		port map (a => regPontos_out, b => "00010000", saida => sttPontosMaiorDezesseis);
		
	CompPontos21: CompMaior
		generic map (dataWidth)
		port map (a => regPontos_out, b => "00010101", saida => sttPontosMaiorVinte);

	-- Logica do Datapath do Pos ====================================
	
	--Multiplexador
	MultPos: Multi21
		generic map (dataWidth)
		port map (a => incI_out, b => regPos_out, op => cmdResetPos, saida => regPos_in);


	RegPos: registrador
		generic map (dataWidth)
		port map (clk => clk, reset => cmdResetPos, load => cmdSetPos, datain =>  regPos_in, dataout => regPos_out );
	

	-- Logica do Datapath do Baralho ====================================

	IncIRAM: incrementador
		generic map (dataWidth, true)
		port map ( inp => regI_out, outp => incIRAM_out);

	MultRAM: Multi21
		generic map (dataWidth)
		port map (a => incIRAM_out, b => "00000000",  op => cmdMultBaralho, saida => multRAMI_out);

	RAM: MemoriaRAM 
		port map(address => regI_out,  clock => clk, data=> multRAMI_out , wren=>cmdSetBaralhoI, q=> RAM_out);

	CompBaralho: CompIgual
		generic map (dataWidth)
		port map (a => RAM_out, b => regCarta_out, saida => sttCompBaralho);
		

end architecture;