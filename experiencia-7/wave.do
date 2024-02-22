onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 -radix hexadecimal /circuito_exp6_tb_certo/clock_in
add wave -noupdate -height 30 -radix hexadecimal /circuito_exp6_tb_certo/caso
add wave -noupdate -radix hexadecimal /circuito_exp6_tb_certo/dut/uc/db_estado
add wave -noupdate -divider {CASO E ESTADO}
add wave -noupdate -height 30 -radix hexadecimal /circuito_exp6_tb_certo/reset_in
add wave -noupdate -height 30 -radix hexadecimal /circuito_exp6_tb_certo/iniciar_in
add wave -noupdate -height 30 -radix hexadecimal /circuito_exp6_tb_certo/chaves_in
add wave -noupdate /circuito_exp6_tb_certo/dut/fd/edge_detect/pulso
add wave -noupdate -divider -height 30 ENTRADAS
add wave -noupdate -height 30 -radix hexadecimal /circuito_exp6_tb_certo/ganhou_out
add wave -noupdate -height 30 -radix hexadecimal /circuito_exp6_tb_certo/perdeu_out
add wave -noupdate -height 30 -radix hexadecimal /circuito_exp6_tb_certo/pronto_out
add wave -noupdate -height 30 -radix hexadecimal /circuito_exp6_tb_certo/leds_out
add wave -noupdate -divider -height 30 SAIDAS
add wave -noupdate -height 30 -radix hexadecimal /circuito_exp6_tb_certo/db_timeout_out
add wave -noupdate -height 30 -radix hexadecimal /circuito_exp6_tb_certo/db_tem_jogada_out
add wave -noupdate -height 30 -radix hexadecimal /circuito_exp6_tb_certo/db_enderecoIgualRodada_out
add wave -noupdate -height 30 -radix hexadecimal /circuito_exp6_tb_certo/db_jogada_correta_out
add wave -noupdate -divider CONTAGENS
add wave -noupdate /circuito_exp6_tb_certo/dut/fd/memoria2/data_out
add wave -noupdate /circuito_exp6_tb_certo/dut/fd/memoria1/data_out
add wave -noupdate -divider ROMS
add wave -noupdate /circuito_exp6_tb_certo/dut/fd/registrador/Q
add wave -noupdate /circuito_exp6_tb_certo/dut/fd/contador_rodada/Q
add wave -noupdate /circuito_exp6_tb_certo/dut/fd/contador_endereco/Q
add wave -noupdate -divider {CONTADOR E REG}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2723844 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 240
configure wave -valuecolwidth 39
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {2695452 ns} {2739819 ns}
