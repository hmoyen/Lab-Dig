module simulador_drone(
    input clock,
    input reset,
    input iniciar,
    input [1:0] controle,
    output venceu,
    output perdeu,
    output [3:0] db_posicao_horizontal,
    output [3:0] db_posicao_vertical,
    output [3:0] db_obstaculos,
    output [3:0] db_estado
);

wire desloca, zeraPosicoes, colisao, fim_espera, fim_mapa, contaT, zeraT;

unidade_controle uc(
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
    .fim_espera(fim_espera),
    .fim_mapa(fim_mapa),
    .colisao(colisao),
    .zeraPosicoes(zeraPosicoes),
    .contaT(contaT),
    .zeraT(zeraT),
    .desloca(desloca),
    .venceu(venceu),
    .perdeu(perdeu),
    .db_estado(db_estado)
);

fluxo_dados fd(
    .reset(reset),
    .iniciar(iniciar),
    .controle(controle),
    .clock(clock),
    .desloca(desloca),
    .zeraPosicoes(zeraPosicoes),
    .contaT(contaT),
    .zeraT(zeraT),
    .colisao(colisao),
    .fim_espera(fim_espera),
    .fim_mapa(fim_mapa),
    .db_posicao_horizontal(db_posicao_horizontal),
    .db_posicao_vertical(db_posicao_vertical),
    .db_obstaculos(db_obstaculos)
);

endmodule



