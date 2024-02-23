onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {CASO E ESTADO}
add wave -noupdate -height 30 /circuito_exp7_certo_tb/dut/uc/db_estado
add wave -noupdate -height 30 -radix decimal /circuito_exp7_certo_tb/caso
add wave -noupdate -divider ENTRADAS
add wave -noupdate -height 30 /circuito_exp7_certo_tb/iniciar_in
add wave -noupdate -height 30 /circuito_exp7_certo_tb/reset_in
add wave -noupdate -height 30 /circuito_exp7_certo_tb/clock_in
add wave -noupdate -divider JOGADAS
add wave -noupdate -height 30 /circuito_exp7_certo_tb/jogada_counter
add wave -noupdate -height 30 /circuito_exp7_certo_tb/chaves_in
add wave -noupdate -height 30 /circuito_exp7_certo_tb/i
add wave -noupdate -divider SAIDAS
add wave -noupdate -height 30 /circuito_exp7_certo_tb/perdeu_out
add wave -noupdate -height 30 /circuito_exp7_certo_tb/ganhou_out
add wave -noupdate -height 30 /circuito_exp7_certo_tb/leds_out
add wave -noupdate -height 30 /circuito_exp7_certo_tb/pronto_out
add wave -noupdate -divider CONTAGENS
add wave -noupdate -height 30 /circuito_exp7_certo_tb/dut/fd/s_rodada
add wave -noupdate -height 30 /circuito_exp7_certo_tb/dut/fd/s_endereco_ram
add wave -noupdate -height 30 /circuito_exp7_certo_tb/dut/uc/timeout_jogada_inicial
add wave -noupdate -height 30 /circuito_exp7_certo_tb/db_timeout_out
add wave -noupdate -divider DEPURACAO
add wave -noupdate -height 30 /circuito_exp7_certo_tb/db_enderecoIgualRodada_out
add wave -noupdate -height 30 /circuito_exp7_certo_tb/db_jogada_correta_out
add wave -noupdate -height 30 /circuito_exp7_certo_tb/db_tem_jogada_out
add wave -noupdate -height 30 /circuito_exp7_certo_tb/db_grava_out
add wave -noupdate -divider {RAM E REG}
add wave -noupdate -height 30 /circuito_exp7_certo_tb/dut/fd/s_jogada
add wave -noupdate -height 30 /circuito_exp7_certo_tb/dut/fd/s_dado
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1186855 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 305
configure wave -valuecolwidth 100
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {5426176 ps}
