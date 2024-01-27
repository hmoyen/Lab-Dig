module exp4_fluxo_dados(

    input        clock,
    input        zeraR,
    input        zeraC, // clear do contador
    input        registraR,
    input        contaC, // conta do contador
    input  [3:0] chaves,
    output       chavesIgualMemoria,
    output       fimC,
    output [3:0] db_contagem,
    output [3:0] db_chaves,
    output [3:0] db_memoria
);

wire [3:0] s_endereco, s_chaves, s_dado;

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
      .ALBo( ),
      .AGBo( ),
      .AEBo( chavesIgualMemoria )
    );

    assign db_contagem = s_endereco;
    assign db_chaves = s_chaves;
    assign db_memoria = s_dado;

endmodule

