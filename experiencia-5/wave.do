onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -height 30 -radix decimal /circuito_exp5_tb_errou/caso
add wave -noupdate -height 30 /circuito_exp5_tb_errou/clock_in
add wave -noupdate -divider Entradas
add wave -noupdate -height 30 /circuito_exp5_tb_errou/reset_in
add wave -noupdate -height 30 /circuito_exp5_tb_errou/iniciar_in
add wave -noupdate -height 30 /circuito_exp5_tb_errou/chaves_in
add wave -noupdate -divider {Detecçao da jogada}
add wave -noupdate -height 30 /circuito_exp5_tb_errou/db_tem_jogada_out
add wave -noupdate -height 30 /circuito_exp5_tb_errou/dut/fd/db_jogada
add wave -noupdate -divider Depuraçao
add wave -noupdate -height 30 /circuito_exp5_tb_errou/db_igual_out
add wave -noupdate -divider Resultado
add wave -noupdate -height 30 /circuito_exp5_tb_errou/acertou_out
add wave -noupdate -height 30 /circuito_exp5_tb_errou/errou_out
add wave -noupdate -height 30 /circuito_exp5_tb_errou/pronto_out
add wave -noupdate -divider Saidas
add wave -noupdate -height 30 /circuito_exp5_tb_errou/leds_out
add wave -noupdate -divider FD
add wave -noupdate -height 30 /circuito_exp5_tb_errou/dut/fd/db_contagem
add wave -noupdate -height 30 /circuito_exp5_tb_errou/dut/fd/db_memoria
add wave -noupdate -divider UC
add wave -noupdate -height 30 -radix unsigned /circuito_exp5_tb_errou/dut/uc/db_estado
add wave -noupdate -height 30 /circuito_exp5_tb_errou/dut/uc/zeraC
add wave -noupdate -height 30 /circuito_exp5_tb_errou/dut/uc/contaC
add wave -noupdate -height 30 /circuito_exp5_tb_errou/dut/uc/zeraR
add wave -noupdate -height 30 /circuito_exp5_tb_errou/dut/uc/registraR
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
WaveRestoreZoom {1284 ns} {2196 ns}
