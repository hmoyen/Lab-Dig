module fluxo_dados(

    input        clock,
    input        zeraR, // clear do registrador
    input        registraR, // habilita o registrador
    input        zeraCR, // clear do contador da rodada
    input        contaCR, // conta do contador da rodada
    input        zeraCE, // clear do contador do endereço
    input        contaCE, // conta do contador do endereço
    input        zeraT, // clear do  contador timeout
    input        contaT, // conta do contador timeout
    input  [3:0] chaves, // chaves de entrada
    output       jogada_correta, // chaves iguais a memoria
    output       enderecoIgualRodada, // endereco igual a rodada
    output       fimCE, // fim do contador do endereço
    output       fimCR, // fim do contador da rodada
    output       jogada_feita,
    output [3:0] leds, //valor da ROM cujo endereço é a rodada atual
    output       db_tem_jogada,
    output [3:0] db_contagem,
    output [3:0] db_jogada,
    output [3:0] db_memoria,
    output [3:0] db_rodada,
    output [11:0] Q,
	  output timeout
);

wire [3:0] s_endereco, s_jogada, s_dado, s_rodada;
wire fim_rodada;
//wire conta_timeout, zera_timeout;



    // contador_163
    contador_163 contador_endereco (
      .clock( clock ),
      .clr  ( ~zeraCE ),
      .ld   ( 1'b1 ),
      .ent  ( 1'b1 ),
      .enp  ( contaCE ),
      .D    ( 4'b0) ,
      .Q    ( s_endereco ),
      .rco  ( fim_rodada )
    );

    contador_163 contador_rodada (
      .clock( clock ),
      .clr  ( ~zeraCR ),
      .ld   ( 1'b1 ),
      .ent  ( 1'b1 ),
      .enp  ( contaCR ),
      .D    ( 4'b0) ,
      .Q    ( s_rodada ),
      .rco  ( fimCR )
    );

    registrador_4 registrador(

        .clock(clock),
        .clear(zeraR),
        .enable(registraR),
        .D(chaves),
        .Q(s_jogada)
    );

    sync_rom_16x4 memoria1( // ROM usada pra comparar valores

        .clock(clock),
        .address(s_endereco),
        .data_in(s_jogada),
        .enable(1'b0),
        .data_out(s_dado)

    );

    sync_rom_16x4 memoria2( // ROM usada pra sempre mostrar o novo valor (indice da rodada)

    .clock(clock),
    .address(s_rodada),
    .data_in(s_jogada),
    .enable(1'b0),
    .data_out(leds)

    );

    // comparador_85
    comparador_85 comparador_jogada (
      .A   ( s_dado ),
      .B   ( s_jogada ),
      .ALBi( 1'b0 ),
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo(  ),
      .AGBo(  ),
      .AEBo( jogada_correta )
    );

    // comparador_85
    comparador_85 comparador_endereco (
      .A   ( s_rodada ),
      .B   ( s_endereco ),
      .ALBi( 1'b0 ),
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo(  ),
      .AGBo(  ),
      .AEBo( enderecoIgualRodada )
    );

    edge_detector edge_detect (

      .reset(registraR),
      .clock(clock),
      .sinal(db_tem_jogada),
      .pulso(jogada_feita)
    );
	 
	 // contador_m
	  contador_m contador_timeout(
	            .clock(clock),
             .zera_as(1'b0),
             .zera_s(zeraT),
             .conta(contaT),
					.Q(Q),
				.fim(timeout),
				.meio()
	  );

    assign db_tem_jogada = |chaves;
    assign zera_timeout = registraR | zeraR;
    assign db_contagem = s_endereco;
    assign db_jogada = s_jogada;
    assign db_memoria = s_dado;
    assign fimCE = fim_rodada;
    assign db_rodada = s_rodada;
	  //assign conta_timeout = zeraR | contaC | registraR | zeraC;

endmodule

