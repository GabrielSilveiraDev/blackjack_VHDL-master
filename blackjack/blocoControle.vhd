library ieee;
use ieee.std_logic_1164.all;
--Retirar cmdSetCarta e cmdResetCarta


entity blocoControle is
		port(
			clk: in std_logic;
			reset_req: in std_logic; 
			chipselect: in std_logic;
			readd: in std_logic;
			writee: in std_logic;
			addCarta: in std_logic;
			sttPontosMaiorDezesseis, sttPontosMaiorVinte, sttCompBaralho, sttIMenor13, sttAddCarta: in std_logic;
			
			interrupt, cmdAcabaJogo, cmdMemRAM, cmdSetI, cmdResetI, cmdSomaPontos, cmdSubTam, cmdSubCarta, cmdResetBaralho, cmdSetBaralho, cmdResetTam, 
			cmdSetTam, cmdMultI, cmdSetPontos, cmdResetPontos, cmdSetAddCarta, cmdResetAddCarta,
			cmdSetCarta, cmdResetCarta, cmdResetPos, cmdSetPos, cmdSetBaralhoI, cmdMultBaralho: out std_logic
			);
end entity;

architecture FSM of blocoControle is
	type Estado is (
		SL00 ,SL01, SL01a, SL01b, SL02, SL03, SL04, SL05, SL06, SL07, SL07a, SL08, 
		SL09, SL09a, SL10, SL11, SL12, SL12a, SL13, SL14, SL15, 
		SL16, SL16a, SL17, SL18, SL19, SL20, SL21, SL22, SL23, SL24, SL25, SL26, SL27, SL27a, SL28
	); 
	signal estadoAtual, proximoEstado: Estado;	
	
begin
	process(estadoAtual, chipselect, readd, writee, sttPontosMaiorDezesseis, sttPontosMaiorVinte, sttAddCarta,
		sttCompBaralho) is
	--Copiei e colei a lógica de transição de estados
	begin 
		--FSM - DIAGRAMA DE TRANSICAO DE ESTADOS DO BLOCO DE CONTROLE
		proximoEstado <= estadoAtual;
		case estadoAtual is
		
						--SL00: inicio do algoritmo --SL01
			when SL00 =>
				proximoEstado <= SL01;
				
			--SL01: baralho = [1,2,3,4,5,6,7,8,9,10,11,12,13]
			when SL01 =>
				proximoEstado <= SL01a;
				
			--SL01a: for (i, i > 13, i++):
			when SL01a =>
				if sttIMenor13 = '1' then
					proximoEstado <= SL01b;
				else
					proximoEstado <= SL04;
				end if;
						
			--SL02: 	baralho[i] = i + 1 	----SL03
			when SL02 =>
				proximoEstado <= SL03;
				
			--SL03: 	}	----SL01a
			when SL03 =>
				proximoEstado <= SL01a;
			
			--SL04: int pos = 0 	
			when SL04 =>
				proximoEstado <= SL05;
				
			--SL05: addCarta = 0
			when SL05 =>
				proximoEstado <= SL06;
				
			--SL06: while True:		--- SL07
			when SL06 =>
				proximoEstado <= SL07;
			
			--SL07:  	addCarta = input (); 						----	input_read/SL07a
			when SL07 =>
				if chipselect = '1' and writee ='1' then
					proximoEstado <= SL07a;
				end if;
			
			--SL07a: 	//Recebe addCarta							---- SL08
			when SL07a =>
				proximoEstado <= SL08;
				
			--SL08:		if (addCarta == 1){			----sttAddCarta/SL09	!sttAddCarta/SL27
			when SL08 =>
				if addCarta='1' then
					proximoEstado <= SL09;
				else
					proximoEstado <= SL27;
				end if;
			
			--SL09		uint carta = input ();   					---- input_read/SL09a
			when SL09 =>
				if chipselect = '1' and writee ='1' then
					proximoEstado <= SL09a;
				end if;
				
			--SL09a		//Recebe carta								---- SL10
			when SL09a =>
				proximoEstado <= SL10;
			
			--SL10 		baralho[carta-1] // espera para leitura
			when SL10 =>
				proximoEstado <= SL11;
				
			--SL11			if  (baralho[i] == carta){			----- sttCompBaralho/SL12	!sttCompBaralho/SL10
			when SL11 =>
				if sttCompBaralho = '1' then
					proximoEstado <= SL12;
				else
					proximoEstado <= SL06;
				end if;
			
			--SL12				baralho[carta-1] = 0			----SL12a
			when SL12 =>
				proximoEstado <= SL12a;
				
			--SL12a				-- Espera por escrita			----SL13
			when SL12a =>
				proximoEstado <= SL13;
				
			--SL13	        	pontos = pontos + carta		----SL14
			when SL13 =>
				proximoEstado <= SL14;
			
			--SL14	        	if pontos > 20{						----sttPontosMaiorVinte/SL15 !sttPontosMaiorVinte/SL18
			when SL14 =>
				if sttPontosMaiorVinte = '1' then
					proximoEstado <= SL15;
				else
					proximoEstado <= SL18;
				end if;
				
			--SL15	        		pontos = 0;						----SL16
			when SL15 =>
				proximoEstado <= SL16;
			
			--SL16					addCarta = 0;					-----SL17
			when SL16 =>
				proximoEstado <= SL17;
				
				
			--SL17	        		break;								-----SL27
			when SL17 =>
				proximoEstado <= SL27;
				
			--SL18				};											----SL19			when SL19 =>
			when SL18 =>
				proximoEstado <= SL19;
			
			--SL19	        	if pontos > 16{						----sttPontosMaiorDezesseis/SL20 !sttPontosMaiorDezesseis/SL22
			when SL19 =>
				if sttPontosMaiorDezesseis = '1' then
					proximoEstado <= SL20;
				else
					proximoEstado <= SL22;
				end if;
				
			--SL20					addCarta = 0					----SL21
			when SL20 =>
				proximoEstado <= SL21;
				
			--SL21	        		break;								-----   ==> SL27
			when SL21 =>
				proximoEstado <= SL27;
			
			--SL22				};											----SL24
			when SL22 =>
				proximoEstado <= SL23;
				
			--SL23				};											----SL26
			when SL23 =>
				proximoEstado <= SL26;

			
			--SL24		else {											----SL25
			when SL24 =>
				proximoEstado <= SL25;
				
			--SL25			break					-----  SL27
			when SL25 =>
				proximoEstado <= SL27;
				
			--SL26				}						----- SL06
			when SL26 =>
				proximoEstado <= SL06;
				
			--SL27 output(pontos)						----SL27a
			when SL27 =>
				proximoEstado <= SL27a;
				
			--SL27a //											----SL28
			when SL27a =>
				proximoEstado <= SL28;
				
			--SL28 fim do algoritmo						----SL00
			when SL28 =>
				proximoEstado <= SL00;
				
			when others =>
				null;
		end case;
	end process;

		-- internal state
	process(clk, reset_req) is
		begin
			if reset_req = '1' then
				estadoAtual <= SL01;
			elsif rising_edge(clk) then
				estadoAtual <= proximoEstado;
			end if;
	end process;
	
	process(estadoAtual) is
	begin

	--i++									==> cmdSetI
	cmdSetI <= '0';

	--i = 0 	==> cmdResetI
	cmdResetI <= '0';

	--pontos + carta 				==> cmdSomaPontos
	cmdSomaPontos <= '0';

	--tam--								==> cmdSubTam
	cmdSubTam <= '0';

	--carta - 1								==> cmdSubCarta  
	cmdSubCarta <= '0';

	--baralho = [1,2,3,4,5,6,7,8,9,10,11,12,13]*4 	=> cmdResetBaralho
	cmdResetBaralho <='0';

	--baralho[i] = baralho[i+1]  ==> cmdSetBaralho
	cmdSetBaralho <= '0';

	--tam = 52 		==> cmdResetTam
	cmdResetTam <= '0';
	
	--tam = input()		==> cmdSetTam
	cmdSetTam <= '0';

	--pontos = pontos + carta			----cmdSetPontos
	cmdSetPontos <= '0';

	--pontos = 0;					----cmdResetPontos
	cmdResetPontos <= '0';

	-- addCarta = input() ==> cmdSetAddCarta
	cmdSetAddCarta <= '0';

	--addCarta = 0		----cmdResetAddCarta
	cmdResetAddCarta <= '0';

	--carta = input(); 				 ==> cmdSetCarta
	cmdSetCarta <= '0';
	
	--pos = 0 			----cmdResetPos
	cmdResetPos <= '0';

	--pos = 1							----cmdSetPos
	cmdSetPos <= '0';
	
	interrupt <= '0';

	cmdSetBaralhoI <= '0';
	

--DIAGRAMA DE SAIDAS DO BLOCO DE CONTROLE

	case estadoAtual is
	-- SL00: inicio do algoritmo
	
	-- SL01: baralho = [1,2,3,4,5,6,7,8,9,10,11,12,13]  ----cmdResetBaralho
		--when SL01 =>
			--cmdResetBaralho <= '1';

		when SL01a =>
			if sttIMenor13 = '1' then
				cmdSetBaralhoI <= '1';
			end if;
			
	--SL02: 	baralho[i] = i + 1 	----
		
	--SL03: int pontos = 0		----cmdResetPontos
		when SL03 =>
			cmdSetI <= '1';
	--SL04:
		when SL04 =>
			cmdResetPontos <= '1';
			cmdResetI <= '1';
	--SL07:  	addCarta = input (); 			----interrupt
		when SL07 =>
			interrupt <= '1';
	--SL07a: 											----cmdSetAddCarta
		when SL07a =>
			interrupt <= '0';	--pode ser 0
			cmdSetAddCarta <= '1';
	--SL09		uint carta = input ();   	----interrupt
		when SL09 =>
			interrupt <= '1';
	--SL09a		//Recebe carta				----cmdSetCarta
		when SL09a =>
			interrupt <= '0';
			cmdSetCarta <= '1';
	--SL12				pos = i						----cmdSetPos
		when SL12 =>
			cmdSetPos <= '1';
	--SL14	        	pontos = pontos + carta			----cmdSetPontos
		when SL14 =>
			cmdSetPontos <= '1';
	--SL16				//espera da memoria ram		---cmdMemRAM
		when SL16 =>
			cmdMemRAM <= '1';
	--SL16a					baralho[i] = baralho[i + 1];	----cmdSetBaralho
		when SL16a =>
			cmdSetBaralho <= '1';
	--SL18				tam --;										----cmdSetTam	
		when SL18 =>
			cmdSetTam <= '1';
	--SL20	        		pontos = 0;					----cmdResetPontos
		when SL20 =>
			cmdResetPontos <= '1';
	--SL21					addCarta = 0;			----cmdResetAddCarta	
		when SL21 =>
			cmdResetAddCarta <= '1';
	--SL22	        		break;							----cmdAcabaJogo
		when SL22 =>
			cmdAcabaJogo <= '1';
	--SL25					addCarta = 0			----cmdResetAddCarta
		when SL25 =>
			cmdResetAddCarta <= '1';
	--SL26	        		break;						----cmdAcabaJogo
		when SL26 =>
			cmdAcabaJogo <= '1';

			
	--SL33 FIM DO ALGORITMO
		when others =>
			null;
		end case;
	end process;
end architecture;
		

