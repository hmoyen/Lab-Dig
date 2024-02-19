SHELL=/bin/bash

#run: compile
#	@echo "Escreva finish para finalizar a simulação e ir para o proximo testbench"
#	vvp errado.out
run: compile make_wave
	

compile:
	iverilog contador_m.v sync_ram_16x4_file.v fluxo_dados.v unidade_controle.v registrador_4.v sync_rom_16x4.v contador_163.v edge_detector.v comparador_85.v circuito_jogo_base.v  hexa7seg.v circuito_exp6_tb.v

make_wave:
	vvp a.out
	gtkwave testbench.vcd

