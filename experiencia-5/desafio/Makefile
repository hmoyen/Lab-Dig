SHELL=/bin/bash

run: compile
	@echo "Escreva finish para finalizar a simulação e ir para o proximo testbench"
	vvp errado.out


compile:
	iverilog -o errado.out contador_m.v fluxo_dados.v unidade_controle.v registrador_4.v sync_rom_16x4.v contador_163.v edge_detector.v comparador_85.v circuito_exp5.v  hexa7seg.v circuito_exp5_tb_errou.v


