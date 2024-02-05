module fluxo_dados(

    input        clock,
    input        zeraR,
    input        zeraC, // clear do contador
    input        registraR,
    input        contaC, // conta do contador
    input  [3:0] chaves,
    output       chavesIgualMemoria,
    output       fimC,
    output       jogada_feita,
    output       db_tem_jogada,
    output [3:0] db_contagem,
    output [3:0] db_jogada,
    output [3:0] db_memoria,
    output [11:0] Q,
	 output timeout
);

wire [3:0] s_endereco, s_chaves, s_dado;
wire conta_timeout, zera_timeout;



    // contador_163
    contador_163 contador (
      .clock( clock ),
      .clr  ( ~zeraC ),
      .ld   ( 1'b1 ),
      .ent  ( 1'b1 ),
      .enp  ( contaC ),
      .D    ( 4'b0) ,
      .Q    ( s_endereco ),
      .rco  ( fimC )
    );

    registrador_4 registrador(

        .clock(clock),
        .clear(zeraR),
        .enable(registraR),
        .D(chaves),
        .Q(s_chaves)
    );

    sync_rom_16x4 memoria(

        .clock(clock),
        .address(s_endereco),
        .data_out(s_dado)

    );

    // comparador_85
    comparador_85 comparador (
      .A   ( s_dado ),
      .B   ( s_chaves ),
      .ALBi( 1'b0 ),
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo(  ),
      .AGBo(  ),
      .AEBo( chavesIgualMemoria )
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
             .zera_s(zera_timeout),
             .conta(~conta_timeout),
					.Q(Q),
				.fim(timeout),
				.meio()
	  );

    assign db_tem_jogada = chaves[0] | chaves[1] | chaves[2] | chaves [3];
    assign zera_timeout = registraR | zeraR;
    assign db_contagem = s_endereco;
    assign db_jogada = s_chaves;
    assign db_memoria = s_dado;
	assign conta_timeout = zeraR | contaC | registraR | zeraC;

endmodule

