
module circuito_jogo_base (
input clock,
input reset,
input iniciar,
input [3:0] chaves,
output ganhou,
output perdeu,
output pronto,
output [3:0] leds,
output [6:0] db_contagem,
output [6:0] db_memoria,
output [6:0] db_estado,
output [6:0] db_jogadafeita,
output [6:0] db_rodada,
output db_clock,
output db_tem_jogada,
output db_timeout,
output db_jogada_correta,
output db_enderecoIgualRodada,
output [11:0] db_Q
);

  wire zeraCE, contaCE, zeraCR, contaCR, zeraR, registraR, fimCE, fimCR, zeraT, contaT;
  wire [3:0] db_contagem_hex, db_memoria_hex, db_jogada_hex, db_estado_hex, db_rodada_hex;
  wire jogada, jogada_correta, enderecoIgualRodada;
  wire timeout;
  

  unidade_controle uc (
  .clock(clock),
  .reset(reset),
  .iniciar(iniciar),
  .fimCE(fimCE),
  .fimCR(fimCR),
  .jogada(jogada),
  .enderecoIgualRodada(enderecoIgualRodada),
  .jogada_correta(jogada_correta),
  .timeout(timeout),
  .zeraCE(zeraCE),
  .contaCE(contaCE),
  .zeraCR(zeraCR),
  .contaCR(contaCR),
  .zeraR(zeraR),
  .registraR(registraR),
  .zeraT(zeraT),
  .contaT(contaT),
  .pronto(pronto),
  .errou(errou),
  .acertou(acertou),
  .db_estado(db_estado_hex)
  );


  fluxo_dados fd(
  .clock(clock),
  .zeraR(zeraR), // clear do registrador
  .registraR(registraR), // habilita o registrador
  .zeraCR(zeraCR), // clear do contador da rodada
  .contaCR(contaCR), // conta do contador da rodada
  .zeraCE(zeraCE), // clear do contador do endereço
  .contaCE(contaCE), // conta do contador do endereço
  .zeraT(zeraT), // clear do  contador timeout
  .contaT(contaT), // conta do contador timeout
  .chaves(chaves), // chaves de entrada
  .jogada_correta(jogada_correta), // chaves iguais a memoria
  .enderecoIgualRodada(enderecoIgualRodada), // endereco igual a rodada
  .fimCE(fimCE), // fim do contador do endereço
  .fimCR(fimCR), // fim do contador da rodada
  .jogada_feita(jogada),
  .leds(leds), //valor da ROM cujo endereço é a rodada atual
  .db_tem_jogada(db_tem_jogada),
  .db_contagem(db_contagem_hex),
  .db_jogada(db_jogada_hex),
  .db_memoria(db_memoria_hex),
  .Q(db_Q),
  .db_rodada(db_rodada_hex),
  .timeout(timeout)
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

  hexa7seg hexa7seg_ROD (

    .hexa(db_rodada_hex),
    .display(db_rodada)
  );


assign db_clock = clock;
assign db_timeout = timeout;
assign db_jogada_correta = jogada_correta;
assign db_enderecoIgualRodada = enderecoIgualRodada;



endmodule
