module fluxo_dados(
input reset,
input iniciar,
input [1:0] controle_vertical,
input [1:0] controle_horizontal,
input confirma,
input clock,
input zeraPosicoes,
input resetaVidas,
input contaT,
input zeraT,
input desloca,
input escolhe_modo,
input escolhe_vida,
input checa_colisao,
output colisao,
output timeout,
output fim_mapa,
output borda_movimento,
output [3:0] db_posicao_horizontal,
output [3:0] db_posicao_vertical,
output [3:0] db_obstaculos,
output [1:0] modo,
output [2:0] colisao_counter_out,
output [2:0] vidas_out
);

wire [1:0] posicao_vertical;
wire [3:0] obstaculos, posicao_horizontal;
wire [2:0] timeout_interno, vidas, colisao_counter;
wire [1:0] modo_interno;
wire [1:0] borda_controle_vertical, borda_controle_horizontal;
wire borda_vertical, borda_horizontal, colisao_interno, colisao_interno_pulso;


contador_16_mais_menos_limitado contador_posicao_horizontal(
    .clock(clock), 
    .clr(~zeraPosicoes), 
    .ld(1'b1), 
    .soma(controle_horizontal[0]), 
    .sub(controle_horizontal[1]), 
    .enp(desloca & borda_horizontal), 
    .D(), 
    .Q(posicao_horizontal), 
    .rco()
);


contador_4_mais_menos_limitado contador_posicao_vertical(
    .clock(clock), 
    .clr(1'b1), 
    .ld(~zeraPosicoes), 
    .soma(controle_vertical[0]), 
    .sub(controle_vertical[1]), 
    .enp(desloca & borda_vertical), 
    .D(2'b10), 
    .Q(posicao_vertical), 
    .rco()
);

contador_m_32 contador_tempo_jogada_facil(
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(zeraT),
    .conta(contaT),
    .Q(),
    .fim(timeout_interno[0]),
    .meio()
);

contador_m_24 contador_tempo_jogada_medio(
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(zeraT),
    .conta(contaT),
    .Q(),
    .fim(timeout_interno[1]),
    .meio()
);

contador_m_16 contador_tempo_jogada_dificl(
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(zeraT),
    .conta(contaT),
    .Q(),
    .fim(timeout_interno[2]),
    .meio()
);

sync_ram_16x4_file mapa_jogo(
    .clk(clock),
    .we(1'b0),
    .data(4'b0),
    .addr(posicao_horizontal),
    .q(obstaculos)
);


contador_3_mais_menos contador_modo( // 0 = FACIL, 1 = MEDIO, 2 = DIFICIL
    .clock(clock),
    .clr(~iniciar),
    .ld(1'b1),
    .soma(controle_vertical[0]),
    .sub(controle_vertical[1]),
    .enp(escolhe_modo & borda_vertical),
    .D(),
    .Q(modo_interno),
    .rco()
);

contador_1_5_mais_menos_limitado contador_vidas(
    .clock(clock), 
    .clr(1'b1), 
    .ld(~resetaVidas), 
    .soma(controle_vertical[0]), 
    .sub(controle_vertical[1]), 
    .enp(escolhe_vida & borda_vertical), 
    .D(3'b001), 
    .Q(vidas), 
    .rco()
);

contador_5 contador_colisao(
    .clock(clock),
    .clr(~zeraPosicoes),
    .ld(1'b1),
    .ent(colisao_interno_pulso),
    .enp(checa_colisao),
    .D(),
    .Q(colisao_counter),
    .rco()
);


edge_detector detector_borda_vertical_0(
    .clock(clock),
    .reset(1'b0),
    .sinal(controle_vertical[0]),
    .pulso(borda_controle_vertical[0])
);

edge_detector detector_borda_vertical_1(
    .clock(clock),
    .reset(1'b0),
    .sinal(controle_vertical[1]),
    .pulso(borda_controle_vertical[1])
);

edge_detector detector_borda_horizontal_0(
    .clock(clock),
    .reset(1'b0),
    .sinal(controle_horizontal[0]),
    .pulso(borda_controle_horizontal[0])
);

edge_detector detector_borda_horizontal_1(
    .clock(clock),
    .reset(1'b0),
    .sinal(controle_horizontal[1]),
    .pulso(borda_controle_horizontal[1])
);

edge_detector detector_colisao_pulso(
    .clock(clock),
    .reset(1'b0),
    .sinal(colisao_interno & checa_colisao),
    .pulso(colisao_interno_pulso)
);


converte_2b_4b conversor_posicao( // ENCODER
    .posicao_2b(posicao_vertical),
    .posicao_4b(db_posicao_vertical)
);

assign db_posicao_horizontal = posicao_horizontal;
assign db_obstaculos = obstaculos;
assign colisao_interno = obstaculos[posicao_vertical] == 1 ? 1'b1 : 1'b0;
assign timeout = timeout_interno[modo_interno];
assign modo = modo_interno;
assign borda_vertical = borda_controle_vertical[0] | borda_controle_vertical[1];
assign borda_horizontal = borda_controle_horizontal[0] | borda_controle_horizontal[1];
assign borda = borda_controle_horizontal | borda_controle_vertical;
assign borda_movimento = borda;
assign colisao = ((colisao_interno == 1) & (colisao_counter == vidas)) ? 1'b1 : 1'b0;
assign colisao_counter_out = colisao_counter;
assign vidas_out = vidas;
endmodule
