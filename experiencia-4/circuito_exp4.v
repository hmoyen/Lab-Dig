
module circuito_exp4 (
    input clock,
    input reset,
    input iniciar,
    input [3:0] chaves,
    output pronto,
    output db_igual,
    output db_iniciar,
    output [6:0] db_contagem,
    output [6:0] db_memoria,
    output [6:0] db_chaves,
    output [6:0] db_estado
    );


    wire zeraC, contaC, zeraR, registraR, fimC;
    wire [3:0] db_contagem_hex, db_memoria_hex, db_chaves_hex, db_estado_hex;

    exp4_unidade_controle uc (
    .clock(clock),
    .reset(reset),
    .iniciar,
    .fimC(fimC),
    .zeraC(zeraC),
    .contaC(contaC),
    .zeraR(zeraR),
    .registraR(registraR),
    .pronto(pronto),
    .db_estado(db_estado_hex)
    );


    exp4_fluxo_dados fd(

    .clock(clock),
    .zeraR(zeraR),
    .zeraC(zeraC), // clear do contador
    .registraR(registraR),
    .contaC(contaC), // conta do contador
    .chaves(chaves),
    .chavesIgualMemoria(db_igual),
    .fimC(fimC),
    .db_contagem(db_contagem_hex),
    .db_chaves(db_chaves_hex),
    .db_memoria(db_memoria_hex)
    );

    hexa7seg hexa7seg_CHAVES (

      .hexa(db_chaves_hex),
      .display(db_chaves)
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


assign db_iniciar = iniciar;

endmodule
