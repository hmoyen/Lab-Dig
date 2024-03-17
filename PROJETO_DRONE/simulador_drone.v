module simulador_drone(
    input clock,
    input reset,
    input iniciar,
    input [1:0] controle,
    input confirma,
    output venceu,
    output perdeu,
    output [3:0] db_posicao_horizontal,
    output [3:0] db_posicao_vertical,
    output [3:0] db_obstaculos,
    output [3:0] db_estado,
    output [1:0] db_modo,
    output [2:0] colisao_counter_out
);

wire move_drone, desloca_horizontal, zeraPosicoes, colisao, fim_espera, fim_mapa, contaT, zeraT, escolhe_modo, escolhe_vida, resetaVidas, confirma_pulso;

//wire [3:0] posicao_horizontal, posicao_vertical;


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
    .db_posicao_horizontal(db_posicao_horizontal),
    .db_posicao_vertical(db_posicao_vertical),
    .db_obstaculos(db_obstaculos),
    .modo(db_modo),
    .colisao_counter_out(colisao_counter_out)
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
    .db_estado(db_estado)
);

edge_detector confirma_edge(
    .clock(clock),
    .reset(),
    .sinal(confirma),
    .pulso(confirma_pulso)
);

endmodule



