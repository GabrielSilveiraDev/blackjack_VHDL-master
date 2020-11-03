--refinar algoritmo para entrega parcial -15/10

-- Projeto de Sistemas Digitais:
-- Grupo: Arthur Pellenz Winck (19201620), Gabriel Fornaza da Silveira(19201618)

--DESCRIÇÃO:
--O jogo simula uma partida de blackjack ou vinte-e-um. Nele, se o jogador fica com mais de 21 pontos ele perde e se 
--somar 17 pontos ele nao pode pegar mais cartas (por isso, existe um comparador if pontos > 16). O jogador deve tentar alcancar o maior numero de pontos sem ultrapassar o limite. Os pontos vem dos numeros das cartas podendo variar entre 1 e 13, sendo que
--o baralho é composto por 52 cartas (1,1,1,1,2,2,2,2...) e esta armazenado na memoria ram. A carta que sera retirada a cada rodada e aleatoria e sera recebida do testbench. Quando a carta for somada aos pontos do jogador, ela sera retirada
--do baralho. No fim do algoritmo (quando o jogador perde ou desiste de pegar cartas) a pontuacao e retornada. A pontuacao e zerada quando passa-se de 20 pontos.
--
--
-- ALGORITMO:
-- inicio do algoritmo (Baixamos o nível do algoritmo para se basear mais em C para simplificar a criação da FSMD)
		--baralho = []
		--int pontos = 0
		--addCarta = 0
		--	  
		-- while True:
			--  	addCarta = input ();
			--		if (addCarta == 1){
			--		//Recebe a carta aleatória do Testbench
			--		uint carta = input ();   
			--			if baralho[i] != 0 {	
			--	        	pontos = pontos + carta
			--			
			--	        	if pontos > 20{
			--	        		pontos = 0;
			--					addCarta = 0;
			--	        		break;
			--				};
			--	
			--	        	if pontos > 16{
			--					addCarta = 0
			--	        		break;
			--				};
			--				};
			--		else{
			--			break
			--				}
			--output(pontos)
			--output(mao)
-- fim do algoritmo

-- VARIAVEIS:
		-- bool addCarta
		-- uint i
		-- uint carta
		-- uint pontos
		-- array baralho

-- OPERACOES E COMANDOS/STATUS EQUIVALENTES (==>) , ordenado por variavel tipo do sinal (comando ou status) e depois por variavel
--		COMANDOS:
--		carta = input(); 				 ==> cmdSetCarta
--		i = i ++; 					    	 ==> cmdSetI
--		i = 0;								==> cmdResetI
--		baralho[i] = i + 1  ==> cmdSetBaralhoI
--		pontos = 0			==> cmdResetPontos
--		pontos = pontos + carta ==> cmdSetPontos
-- 		addCarta = input();			==> cmdSetAddCarta

--STATUS:
--		addCarta == 1 ==> sttAddCarta
--		pontos > 20 	==> sttPontosMaiorVinte
--		pontos > 16 	==> sttPontosMaiorDezesseis
--		i < 13				==> sttIMenor13
--		baralho[i] != 0 ==> sttCompBaralho

--FSMD DO BLOCO DE CONTROLE (a ser refinado apos o projeto do Bloco Operativo)
-- inicio do algoritmo (Baixamos o nível do algoritmo para se basear mais em C para simplificar a criação da FSMD)
		--SL00: inicio do algoritmo
		--SL01: i = 0
		--SL01a: for (i, i > 13, i++):
		--SL02: 	baralho[i] = i + 1
		--SL03: 	--
		--SL04: int pontos = 0
		--SL05: addCarta = 0
		--	  
		--SL06: while True:
			--SL07:  	addCarta = input ();
			--SL08:		if (addCarta == 1){
			--SL09		uint carta = input ();   		
			--		//Remove a carta correspondente do baralho; se a carta existe, executa a retirada da carta do baralho, a soma de pontos e a checagem da condição de vitória
			--SL10 		baralho[carta-1] // chama baralho[carta-1]
			--SL11		if baralho[carta-1] != '0':
			--SL12				baralho[carta-1] = 0
			--SL12a				-- Espera por escrita
			--SL13	        	pontos = pontos + carta					
			--SL14	        	if pontos > 20{
			--SL15	        		pontos = 0;
			--SL16					addCarta = 0;
			--SL17	        		break;
			--SL18				};
			--	
			--SL19	        	if pontos > 16{
			--SL20					addCarta = 0
			--SL21	        		break;
			--SL22				};
			--SL23				};
			--SL24		else{
			--SL25			break
			--SL26				}
			--SL27 output(pontos)
			--SL27a //Espera
			--SL28 fim do algoritmo



-- BLOCO OPERATIVO - Circuitos COMBINACIONAIS para implementaçao das operaçoes
--	 Incrementador: 		i++									==> cmdSetI
-- 	 Somador: 				pontos = pontos + carta 						==> cmdSetPontos
--	 Comparador Maior: pontos > 16								==> sttPontosMaiorDezesseis
--   Comparador Maior: pontos > 20								==> sttPontosMaiorVinte 	
--	 Multiplexador:  baralho [i] = 0 ou baralho[i] = i + 1	=> cmdMultBaralho
-- 	Comparador Menor: i < 13					==> sttIMenor13
--	Comparador Igual (invertido): baralho[i] != 0 ==> sttCompBaralho

-- BLOCO OPERATIVO - Circuitos SEQUENCIAIS para implementaçao das operaçoes
-- Memoria Ram ;  baralho[i] = i + 1  ==> cmdSetBaralho
-- Registrador (carga):  carta = input()	==> cmdSetCarta
-- Registrador (reset) pontos = 0; - cmdResetPontos
-- Registrador (carga) pontos = pontos + carta - cmdSetPontos
-- Registrador (reset): i = 0 	==> cmdResetI
-- Registrador (carga): i = 0  	==> cmdSetI
-- Registrador (carga): addCarta = input() ==> cmdSetAddCarta
-- Registrador (reset): addCarta = 0; 		==> cmdResetAddCarta


-- DIAGRAMA DE TRANSICAO DE ESTADOS DO BLOCO DE CONTROLE
		--SL00: inicio do algoritmo
		--SL01: i = 0
		--SL01a: for (i, i < 13, i++):	sttIMenor13/SL01b !sttIMenor13/SL04
		--SL02: 	baralho[i] = i + 1 	----SL03
		--SL03: 	}	----SL01a
		--SL04: int pontos = 0	----SL04
		--SL05: addCarta = 0		----SL06
		--	  
		--SL06: while True:		--- SL07
			-- //Recebe 1 ou 0 para continuar o jogo ou parar
			--SL07:  	addCarta = input (); 						----	input_read/SL07a
			--SL07a: 	//Recebe addCarta							---- SL08
			--SL08:		if (addCarta == 1){							----sttAddCarta/SL09	!sttAddCarta/SL30						
			--SL09		uint carta = input ();   					---- input_read/SL09a
			--SL09a		//espera carta								---- SL10
			--		//Remove a carta correspondente do baralho; se a carta existe, executa a retirada da carta do baralho, a soma de pontos e a checagem da condição de vitória
			--SL10 		baralho[carta-1] // espera para leitura
			--SL11		if baralho[carta-1] != '0':				----sttCompBaralho/SL12 !sttCompBaralho/SL06
			--SL12				baralho[carta-1] = 0			----SL12a
			--SL12a				-- Espera por escrita			----SL13
			--SL13	        	pontos = pontos + carta		----SL14
			--SL14	        	if pontos > 20{						----sttPontosMaiorVinte/SL15 !sttPontosMaiorVinte/SL18
			--SL15	        		pontos = 0;						----SL16
			--SL16					addCarta = 0;					-----SL17
			--SL17	        		break;								-----SL27
			--SL18				};											----SL19
			--	
			--SL19	        	if pontos > 16{						----sttPontosMaiorDezesseis/SL20 !sttPontosMaiorDezesseis/SL22
			--SL20					addCarta = 0					----SL21
			--SL21	        		break;								-----   ==> SL27
			--SL22				};											----SL23
			--SL23				};											----SL26
			--SL24		else {											----SL25
			--SL25			break					-----  SL27
			--SL26				}						----- SL06
			--SL27 output(pontos)						----SL27a
			--SL27a //											----SL28
			--SL28 fim do algoritmo						----SL00




-- DIAGRAMA DE SAIDAS DO BLOCO DE CONTROLE
		
		--SL00: inicio do algoritmo
		--SL01: i =0						---cmdResetI
		--SL01a: for (i, i < 13, i++) {	
		--SL02: 	baralho[i] = i + 1 	---cmdSetBaralhoI
		--SL03: 	} 							---cmdSetI								
		--SL04: int pontos = 0		----cmdResetPontos
		--SL05: addCarta = 0		----cmdResetAddCarta
		--	  
		--SL06: while True:		--- SL07
			-- //Recebe 1 ou 0 para continuar o jogo ou parar
			--SL07:  	addCarta = input (); 			----interrupt
			--SL07a: 											----cmdSetAddCarta					
			--SL08:		if (addCarta == 1){												
			--SL09		uint carta = input ();   	----interrupt
			--SL09a		//Recebe carta				----cmdSetCarta
			--		//Remove a carta correspondente do baralho; se a carta existe, executa a retirada da carta do baralho, a soma de pontos e a checagem da condição de vitória
			--SL10 		baralho[carta-1] // chama baralho[carta-1]
			--SL11		if baralho[carta-1] != '0':				
			--SL12				baralho[carta-1] = 0		----cmdSetBaralhoI & cmdMultBaralho = 1
			--SL12a				-- Espera por escrita
			--SL13				pontos = pontos + carta		----cmdSetPontos
			--SL14	        	if pontos > 20{					
			--SL15	        		pontos = 0;					----cmdResetPontos
			--SL16					addCarta = 0;			----cmdResetAddCarta	
			--SL17	        		break;						
			--SL18				};										
			--	
			--SL19	        	if pontos > 16{						
			--SL20					addCarta = 0			----cmdResetAddCarta
			--SL21	        		break;						
			--SL22				};								
			--SL23				};				
			--SL24		if (addCarta == 0){							
			--SL25			break							
			--SL26				}				
			--		
			--SL27 output(pontos)				----interrupt
			--SL27a: //Receber saida
			--SL28 fim do algoritmo				

--======
--cmdResetI
--cmdSetI
--
library ieee;
use ieee.std_logic_1164.all;

entity Blackjack is
	generic(
		dataWidth: positive := 8;
		addressWidth: positive := 6
	);
	port(
		-- control inputs
		clk: in std_logic;
		reset_req: in std_logic;
		chipselect: in std_logic;
		readd: in std_logic;
		writee: in std_logic;
		addCarta: in std_logic;
		-- data inputs
		address: in std_logic_vector(addressWidth-1 downto 0);
		writedata: in std_logic_vector(dataWidth-1 downto 0);
		-- control outputs
		interrupt: out std_logic;
		-- data outputs
		readdata: out std_logic_vector(dataWidth-1 downto 0)
		
		-- tests
		--testRegI, testVetorI, testMaxdado: out std_logic_vector(dataWidth-1 downto 0);
		--testEstadoAtual: out Estado
	);
end entity;

architecture structural of Blackjack is
	component blocoControle is
		port(
			clk: in std_logic;
			reset_req: in std_logic;
			chipselect: in std_logic;
			readd: in std_logic;
			writee: in std_logic;
			addCarta: in std_logic;
			-- status from OperativeBlock
			sttPontosMaiorDezesseis, sttPontosMaiorVinte, sttCompBaralho, sttIMenor13, sttAddCarta: in std_logic;
			-- control outputs
			interrupt: out std_logic;
			--commands to OperativeBlock
			cmdSetI, cmdResetI, cmdResetBaralho, cmdSetBaralho,
				cmdSetPontos,cmdResetPontos, cmdSetAddCarta, cmdResetAddCarta,
				cmdSetCarta, cmdSetBaralhoI, cmdMultBaralho: out std_logic
			--tests
			--testEstadoAtual: out Estado
		);
	end component;

	component blocoOperativo is
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
			-- commands from commandBlock
			cmdSetI, cmdResetI, cmdSetPontos, cmdResetBaralho, cmdSetBaralho,
				cmdResetPontos, cmdSetAddCarta, cmdResetAddCarta, cmdMultBaralho,
				cmdSetCarta, cmdSetBaralhoI: in std_logic;
	
			--status to ComandBlock
			sttPontosMaiorDezesseis, sttPontosMaiorVinte, sttCompBaralho, sttIMenor13, sttAddCarta: out std_logic
		);
	end component;

	--comandos
	signal cmdSetI, cmdResetI, cmdResetBaralho, cmdSetBaralho: std_logic;
	signal cmdSetPontos, cmdResetPontos, cmdSetAddCarta, cmdResetAddCarta, cmdMultBaralho: std_logic;
	signal cmdSetCarta, cmdSetBaralhoI: std_logic;

	--status
	signal sttPontosMaiorDezesseis, sttPontosMaiorVinte,  sttCompBaralho, sttIMenor13, sttAddCarta: std_logic;
	
begin
	bloco_controle: blocoControle
		   port map(clk, reset_req, chipselect, readd, writee, addCarta,
			sttPontosMaiorDezesseis, sttPontosMaiorVinte, sttCompBaralho, sttIMenor13, sttAddCarta,
			interrupt,
			cmdSetI, cmdResetI, cmdResetBaralho, cmdSetBaralho,
			cmdSetPontos, cmdResetPontos, cmdSetAddCarta, cmdResetAddCarta, cmdMultBaralho,
			cmdSetCarta,  cmdSetBaralhoI);
			
	bloco_operativo: blocoOperativo
		generic map (dataWidth, addressWidth)
		port map (clk, reset_req,
			address, writedata,
			readdata,
			cmdSetI, cmdResetI, cmdResetBaralho, cmdSetBaralho, 
			cmdSetPontos,cmdResetPontos, cmdSetAddCarta, cmdResetAddCarta,
			cmdSetCarta, cmdSetBaralhoI, cmdMultBaralho,
			sttPontosMaiorDezesseis, sttPontosMaiorVinte, sttCompBaralho, sttIMenor13, sttAddCarta
		);

end architecture;
