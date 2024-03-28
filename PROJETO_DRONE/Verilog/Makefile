SHELL=/bin/bash

# run: compile
# 	@echo "Escreva finish para finalizar a simulação e ir para o proximo testbench"
# 	vvp errado.out
run: compile make_wave
	

compile:
	iverilog sync_ram_16x4_file1.v sync_ram_16x4_file2.v sync_rom_16x4_file1.v sync_rom_16x4_file2.v contador_163.v comparador_85.v contador_4_mais_menos_limitado.v contador_16_mais_menos_limitado.v contador_5.v contador_1_5_mais_menos_limitado.v contador_m_32.v contador_m_24.v contador_m_16.v converte_2b_4b.v edge_detector.v fluxo_dados.v unidade_controle.v contador_3_mais_menos.v simulador_drone.v hexa7seg.v simulador_drone_tb.v 


make_wave:
	vvp a.out
	gtkwave testbench_drone.vcd

new_file:
	cat simulador_drone.v sync_ram_16x4_file.v contador_163.v comparador_85.v contador_4_mais_menos_limitado.v contador_5.v contador_1_5_mais_menos_limitado.v contador_m_2.v contador_m_1.v contador_m_05.v converte_2b_4b.v edge_detector.v fluxo_dados.v unidade_controle.v contador_3_mais_menos.v > tudo.v 