onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /circuito_exp5_tb_acertou/caso
add wave -noupdate /circuito_exp5_tb_acertou/clock_in
add wave -noupdate -divider Entradas
add wave -noupdate /circuito_exp5_tb_acertou/reset_in
add wave -noupdate /circuito_exp5_tb_acertou/iniciar_in
add wave -noupdate /circuito_exp5_tb_acertou/chaves_in
add wave -noupdate -divider {Detecçao da jogada}
add wave -noupdate /circuito_exp5_tb_acertou/db_tem_jogada_out
add wave -noupdate /circuito_exp5_tb_acertou/dut/fd/db_jogada
add wave -noupdate -divider Depuraçao
add wave -noupdate /circuito_exp5_tb_acertou/db_igual_out
add wave -noupdate -divider Resultado
add wave -noupdate /circuito_exp5_tb_acertou/acertou_out
add wave -noupdate /circuito_exp5_tb_acertou/errou_out
add wave -noupdate /circuito_exp5_tb_acertou/pronto_out
add wave -noupdate -divider Saidas
add wave -noupdate /circuito_exp5_tb_acertou/leds_out
add wave -noupdate -divider FD
add wave -noupdate /circuito_exp5_tb_acertou/dut/fd/db_contagem
add wave -noupdate /circuito_exp5_tb_acertou/dut/fd/db_memoria
add wave -noupdate -divider UC
add wave -noupdate -radix hexadecimal /circuito_exp5_tb_acertou/dut/uc/db_estado
add wave -noupdate /circuito_exp5_tb_acertou/dut/uc/zeraC
add wave -noupdate /circuito_exp5_tb_acertou/dut/uc/contaC
add wave -noupdate /circuito_exp5_tb_acertou/dut/uc/zeraR
add wave -noupdate /circuito_exp5_tb_acertou/dut/uc/registraR
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3727 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 466
configure wave -valuecolwidth 59
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
WaveRestoreZoom {6084 ns} {6996 ns}
