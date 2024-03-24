module simulador_drone(
    input clock,
    input reset,
    input iniciar,
    input [1:0] controle,
    input confirma,
    output venceu,
    output perdeu,
    output [6:0] db_posicao_horizontal,
    output [6:0] db_posicao_vertical,
    output [6:0] db_obstaculos,
    output [6:0] db_estado,
    output [1:0] db_modo,
    output [6:0] colisao_counter_out,
    output [6:0] db_vidas
);

wire move_drone, desloca_horizontal, zeraPosicoes, colisao, fim_espera, fim_mapa, contaT, zeraT, escolhe_modo, escolhe_vida, resetaVidas, confirma_pulso;

wire [3:0] posicao_horizontal, posicao_vertical, obstaculos, estado;
wire [2:0] vidas, colisao_counter;


fluxo_dados fd(
    .reset(reset),
    .iniciar(iniciar),
    .controle(controle),
    .confirma(confirma_pulso),
    .clock(clock),
    .zeraPosicoes(zeraPosicoes),
    .resetaVidas(resetaVidas),
    .contaT(contaT),
    .zeraT(zeraT),
    .move_drone(move_drone),
    .desloca_horizontal(desloca_horizontal),
    .escolhe_modo(escolhe_modo),
    .escolhe_vida(escolhe_vida),
    .colisao(colisao),
    .fim_espera(fim_espera),
    .fim_mapa(fim_mapa),
    .db_posicao_horizontal(posicao_horizontal),
    .db_posicao_vertical(posicao_vertical),
    .db_obstaculos(obstaculos),
    .modo(db_modo),
    .colisao_counter_out(colisao_counter),
    .vidas_out(vidas)
);
unidade_controle uc(
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
    .confirma(confirma_pulso),
    .fim_espera(fim_espera),
    .fim_mapa(fim_mapa),
    .colisao(colisao),
    .zeraPosicoes(zeraPosicoes),
    .contaT(contaT),
    .zeraT(zeraT),
    .escolhe_modo(escolhe_modo),
    .escolhe_vida(escolhe_vida),
    .move_drone(move_drone),
    .resetaVidas(resetaVidas),
    .desloca_horizontal(desloca_horizontal),
    .venceu(venceu),
    .perdeu(perdeu),
    .db_estado(estado)
);

edge_detector confirma_edge(
    .clock(clock),
    .reset(),
    .sinal(confirma),
    .pulso(confirma_pulso)
);

hexa7seg display_posicao_horizontal(
    .hexa(posicao_horizontal),
    .display(db_posicao_horizontal)
);

hexa7seg display_posicao_vertical(
    .hexa(posicao_vertical),
    .display(db_posicao_vertical)
);

hexa7seg display_obstaculos(
    .hexa(obstaculos),
    .display(db_obstaculos)
);

hexa7seg display_estado(
    .hexa(estado),
    .display(db_estado)
);

hexa7seg display_colisao_counter(
    .hexa({1'b0, colisao_counter}),
    .display(colisao_counter_out)
);

hexa7seg display_vidas(
    .hexa({1'b0, vidas}),
    .display(db_vidas)
);





endmodule



