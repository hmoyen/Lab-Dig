module fluxo_dados(
input reset,
input iniciar,
input [1:0] controle,
input confirma,
input clock,
input zeraPosicoes,
input resetaVidas,
input contaT,
input zeraT,
input move_drone,
input desloca_horizontal,
input escolhe_modo,
input escolhe_vida,
output colisao,
output fim_espera,
output fim_mapa,
output [3:0] db_posicao_horizontal,
output [3:0] db_posicao_vertical,
output [3:0] db_obstaculos,
output [1:0] modo,
output [2:0] colisao_counter_out,
output [2:0] vidas_out
);

wire [1:0] posicao_vertical;
wire [3:0] obstaculos, posicao_horizontal;
wire [2:0] fim_espera_interno, vidas, colisao_counter;
wire [1:0] modo_interno;
wire [1:0] borda_controle;
wire borda, colisao_interno;


contador_163 contador_posicao_horizontal(
    .clock(clock),
    .clr(~zeraPosicoes),
    .ld(1'b1),
    .ent(1'b1),
    .enp(desloca_horizontal),
    .D(),
    .Q(posicao_horizontal),
    .rco(fim_mapa) 
);

contador_m_2 contador_tempo_jogada_facil(
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(zeraT),
    .conta(contaT),
    .Q(),
    .fim(fim_espera_interno[0]),
    .meio()
);

contador_m_1 contador_tempo_jogada_medio(
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(zeraT),
    .conta(contaT),
    .Q(),
    .fim(fim_espera_interno[1]),
    .meio()
);

contador_m_05 contador_tempo_jogada_dificl(
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(zeraT),
    .conta(contaT),
    .Q(),
    .fim(fim_espera_interno[2]),
    .meio()
);

sync_ram_16x4_file mapa_jogo(
    .clk(clock),
    .we(1'b0),
    .data(4'b0),
    .addr(posicao_horizontal + 4'b0001),
    .q(obstaculos)
);

contador_4_mais_menos_limitado contador_posicao_vertical(
    .clock(clock), 
    .clr(1'b1), 
    .ld(~zeraPosicoes), 
    .soma(controle[0]), 
    .sub(controle[1]), 
    .enp(move_drone & borda), 
    .D(2'b10), 
    .Q(posicao_vertical), 
    .rco()
);


contador_3_mais_menos contador_modo( // 0 = FACIL, 1 = MEDIO, 2 = DIFICIL
    .clock(clock),
    .clr(~iniciar),
    .ld(1'b1),
    .soma(controle[0]),
    .sub(controle[1]),
    .enp(escolhe_modo & borda),
    .D(),
    .Q(modo_interno),
    .rco()
);

contador_1_5_mais_menos_limitado contador_vidas(
    .clock(clock), 
    .clr(1'b1), 
    .ld(~resetaVidas), 
    .soma(controle[0]), 
    .sub(controle[1]), 
    .enp(escolhe_vida & borda), 
    .D(3'b001), 
    .Q(vidas), 
    .rco()
);

contador_5 contador_colisao(
    .clock(clock),
    .clr(~zeraPosicoes),
    .ld(1'b1),
    .ent(colisao_interno),
    .enp(desloca_horizontal),
    .D(),
    .Q(colisao_counter),
    .rco()
);


edge_detector detector_borda0(
    .clock(clock),
    .reset(1'b0),
    .sinal(controle[0]),
    .pulso(borda_controle[0])
);

edge_detector detector_borda1(
    .clock(clock),
    .reset(1'b0),
    .sinal(controle[1]),
    .pulso(borda_controle[1])
);


converte_2b_4b conversor_posicao( // ENCODER
    .posicao_2b(posicao_vertical),
    .posicao_4b(db_posicao_vertical)
);

assign db_posicao_horizontal = posicao_horizontal;
assign db_obstaculos = obstaculos;
assign colisao_interno = obstaculos[posicao_vertical] == 1 ? 1'b1 : 1'b0;
assign fim_espera = fim_espera_interno[modo_interno];
assign modo = modo_interno;
assign borda = borda_controle[0] | borda_controle[1];
assign colisao = ((colisao_interno == 1) & (colisao_counter == vidas)) ? 1'b1 : 1'b0;
assign colisao_counter_out = colisao_counter;
assign vidas_out = vidas;
endmodule