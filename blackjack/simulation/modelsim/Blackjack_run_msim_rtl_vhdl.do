transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vcom -93 -work work {C:/Users/Avell/Desktop/Aula/SD/blackjack_VHDL-master/blackjack/Blackjack.vhd}
vcom -93 -work work {C:/Users/Avell/Desktop/Aula/SD/blackjack_VHDL-master/blackjack/Incrementador.vhd}
vcom -93 -work work {C:/Users/Avell/Desktop/Aula/SD/blackjack_VHDL-master/blackjack/Decrementador.vhd}
vcom -93 -work work {C:/Users/Avell/Desktop/Aula/SD/blackjack_VHDL-master/blackjack/Multi21.vhd}
vcom -93 -work work {C:/Users/Avell/Desktop/Aula/SD/blackjack_VHDL-master/blackjack/Soma2.vhd}
vcom -93 -work work {C:/Users/Avell/Desktop/Aula/SD/blackjack_VHDL-master/blackjack/CompMaior.vhd}
vcom -93 -work work {C:/Users/Avell/Desktop/Aula/SD/blackjack_VHDL-master/blackjack/CompIgual.vhd}
vcom -93 -work work {C:/Users/Avell/Desktop/Aula/SD/blackjack_VHDL-master/blackjack/blocoControle.vhd}
vcom -93 -work work {C:/Users/Avell/Desktop/Aula/SD/blackjack_VHDL-master/blackjack/blocoOperativo.vhd}
vcom -93 -work work {C:/Users/Avell/Desktop/Aula/SD/blackjack_VHDL-master/blackjack/registrador.vhd}
vcom -93 -work work {C:/Users/Avell/Desktop/Aula/SD/blackjack_VHDL-master/blackjack/memoriaram.vhd}

