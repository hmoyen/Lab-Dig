SHELL=/bin/bash

#run: compile
#	@echo "Escreva finish para finalizar a simulação e ir para o proximo testbench"
#	vvp errado.out
run: compile make_wave
	

compile:
	iverilog contador_m.v contador_m_2.v sync_ram_16x4_file.v fluxo_dados.v unidade_controle.v registrador_4.v contador_163.v edge_detector.v comparador_85.v jogo_desafio_memoria.v  hexa7seg.v circuito_exp7_timeoutDesafio_tb.v

make_wave:
	vvp a.out
	gtkwave testbench.vcd

