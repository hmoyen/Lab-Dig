module fluxo_dados(

    input        clock,
    input        registraDif,
    input        zeraDif,
    input        zeraR, // clear do registrador
    input        registraR, // habilita o registrador
    input        zeraCR, // clear do contador da rodada
    input        contaCR, // conta do contador da rodada
    input        zeraCE, // clear do contador do endereço
    input        contaCE, // conta do contador do endereço
    input        zeraT, // clear do  contador timeout
    input        contaT, // conta do contador timeout
    input        zeraTI, // clear do  contador timeout inicial do jogo
    input        contaTI, // conta do contador timeout inicial do jogo
    input  [3:0] botoes, // chaves de entrada
    input        grava,  //sinal de controle pra gravar a nova jogada
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
    output [3:0] db_rodada, //OR entre todas as chaves de entrada de Dado
    output [12:0] Q, //saida do contador timeout
	  output timeout,
    output timeout_jogada_inicial
);

wire [3:0] s_endereco, s_jogada, s_dado, s_rodada, s_endereco_ram, leds_reg;
wire fim_rodada;
wire timeout_meio, timeout_inteiro;
wire [3:0] dificil;
//wire conta_timeout, zera_timeout;

    // RAM
    sync_ram_16x4_file RAM(
      .clk (clock),
      .we(grava),
      .data(botoes),
      .addr(s_endereco_ram),
      .q(s_dado)

    );

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
        .D(botoes),
        .Q(s_jogada)
    );

    registrador_4 registrador_dificuldade(

        .clock(clock),
        .clear(zeraDif),
        .enable(registraDif),
        .D(botoes),
        .Q(dificil)
    );


    // comparador_85
    comparador_85 comparador_jogada (
      .A   (s_dado ),
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

      .reset(1'b0),
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
				.fim(timeout_inteiro),
				.meio(timeout_meio)
	  );

    	 // contador_m_2 (2 segundos pra um clock de 1kHz)
	  contador_m_2 contador_tempo_display_jogada_inicial(
	            .clock(clock),
             .zera_as(1'b0),
             .zera_s(zeraTI),
             .conta(contaTI),
					.Q(),
				.fim(timeout_jogada_inicial),
				.meio()
	  );

    assign s_endereco_ram = grava ? s_rodada : s_endereco;
    assign db_tem_jogada = |botoes;
    assign zera_timeout = registraR | zeraR;
    assign db_contagem = s_endereco;
    assign db_jogada = s_jogada;
    assign db_memoria = s_dado;
    assign fimCE = fim_rodada;
    assign db_rodada = s_rodada;
    assign timeout = (dificil == 4'b0010) ? timeout_meio : timeout_inteiro; 
    
    assign leds = (contaTI) ? s_dado : botoes ;
	  //assign conta_timeout = zeraR | contaC | registraR | zeraC;

endmodule

