SHELL=/bin/bash

run: compile
	vvp a.out

compile:
	iverilog exp4_fluxo_dados.v exp4_unidade_controle.v registrador_4.v sync_rom_16x4.v contador_163.v comparador_85.v circuito_exp4.v circuito_exp4_tb.v hexa7seg.v 

