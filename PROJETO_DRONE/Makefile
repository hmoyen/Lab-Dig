SHELL=/bin/bash

#run: compile
#	@echo "Escreva finish para finalizar a simulação e ir para o proximo testbench"
#	vvp errado.out
run: compile make_wave
	

compile:
	iverilog sync_ram_16x4_file.v contador_163.v comparador_85.v contador_4_mais_menos.v contador_m_2.v converte_2b_4b.v fluxo_dados.v unidade_controle.v simulador_drone.v simulador_drone_tb.v

make_wave:
	vvp a.out
	gtkwave testbench_drone.vcd