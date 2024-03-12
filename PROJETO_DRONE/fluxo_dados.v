module fluxo_dados(
input reset,
input iniciar,
input [1:0] controle,
input clock,
input desloca,
input zeraPosicoes,
input contaT,
input zeraT,
output colisao,
output fim_espera,
output fim_mapa,
output [3:0] db_posicao_horizontal,
output [3:0] db_posicao_vertical,
output [3:0] db_obstaculos
);

wire [1:0] posicao_vertical;
wire [3:0] obstaculos, posicao_horizontal;


contador_163 contador_posicao_horizontal(
    .clock(clock),
    .clr(~zeraPosicoes),
    .ld(1'b1),
    .ent(1'b1),
    .enp(desloca),
    .D(),
    .Q(posicao_horizontal),
    .rco(fim_mapa) 
);
contador_m_2 contador_tempo_jogada(
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(zeraT),
    .conta(contaT),
    .Q(),
    .fim(fim_espera),
    .meio()
);

sync_ram_16x4_file mapa_jogo(
    .clk(clock),
    .we(1'b0),
    .data(4'b0),
    .addr(posicao_horizontal + 1),
    .q(obstaculos)
);

contador_4_mais_menos contador_posicao_vertical(
    .clock(clock), 
    .clr(1'b1), 
    .ld(~zeraPosicoes), 
    .soma(controle[0]), 
    .sub(controle[1]), 
    .enp(desloca), 
    .D(2'b10), 
    .Q(posicao_vertical), 
    .rco()
);


converte_2b_4b conversor_posicao(
    .posicao_2b(posicao_vertical),
    .posicao_4b(db_posicao_vertical)
);

assign db_posicao_horizontal = posicao_horizontal;
assign db_obstaculos = obstaculos;
assign colisao = obstaculos[posicao_vertical] == 1 ? 1'b1 : 1'b0;









endmodule