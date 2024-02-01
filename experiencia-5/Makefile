SHELL=/bin/bash

run: compile
	vvp a.out

compile:
	iverilog fluxo_dados.v unidade_controle.v registrador_4.v sync_rom_16x4.v contador_163.v edge_detector.v comparador_85.v circuito_exp5.v circuito_exp5_tb.v hexa7seg.v 

