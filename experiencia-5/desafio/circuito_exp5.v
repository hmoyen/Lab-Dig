
module circuito_exp5 (
input clock,
input reset,
input iniciar,
input [3:0] chaves,
output acertou,
output errou,
output pronto,
output [3:0] leds,
output [6:0] db_contagem,
output [6:0] db_memoria,
output [6:0] db_estado,
output [6:0] db_jogadafeita,
output db_clock,
output db_tem_jogada,
output db_timeout,
output [11:0] db_Q
);

    wire zeraC, contaC, zeraR, registraR, fimC;
    wire [3:0] db_contagem_hex, db_memoria_hex, db_jogada_hex, db_estado_hex;
    wire jogada;
	 wire timeout;

    unidade_controle uc (
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
	 .timeout(timeout),
    .fimC(fimC),
    .zeraC(zeraC),
    .contaC(contaC),
    .zeraR(zeraR),
    .registraR(registraR),
    .pronto(pronto),
    .db_estado(db_estado_hex),
    .igual(igual),
    .errou(errou),
    .acertou(acertou),
    .jogada(jogada)
    );


    fluxo_dados fd(

    .clock(clock),
    .zeraR(zeraR),
    .zeraC(zeraC), // ~clear do contador
    .registraR(registraR),
    .contaC(contaC), // conta do contador
    .chaves(chaves),
    .chavesIgualMemoria(igual),
    .fimC(fimC),
    .db_contagem(db_contagem_hex),
    .db_jogada(db_jogada_hex),
    .db_memoria(db_memoria_hex),
    .jogada_feita(jogada),
    .db_tem_jogada(db_tem_jogada),
	 .timeout(timeout),
     .Q(db_Q)
    );

    hexa7seg hexa7seg_CHAVES (

      .hexa(db_jogada_hex),
      .display(db_jogadafeita)
    );
	 
	 hexa7seg hexa7seg_CONT (

      .hexa(db_contagem_hex),
      .display(db_contagem)
    );

    hexa7seg hexa7seg_MEM (

      .hexa(db_memoria_hex),
      .display(db_memoria)
    );

    hexa7seg hexa7seg_EST (

      .hexa(db_estado_hex),
      .display(db_estado)
    );

assign leds = db_jogada_hex;
assign db_clock = clock;
assign db_timeout = timeout;
endmodule
