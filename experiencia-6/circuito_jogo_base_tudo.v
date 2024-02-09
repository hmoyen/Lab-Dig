
module circuito_jogo_base_tudo (
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
/* -----------------------------------------------------------------
 *  Arquivo   : comparador_85.v
 *  Projeto   : Experiencia 3 - Um Fluxo de Dados Simples
 * -----------------------------------------------------------------
 * Descricao : comparador de magnitude de 4 bits 
 *             similar ao CI 7485
 *             baseado em descricao comportamental disponivel em	
 * https://web.eecs.umich.edu/~jhayes/iscas.restore/74L85b.v
 * -----------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     21/12/2023  1.0     Edson Midorikawa  criacao
 * -----------------------------------------------------------------
 */

module comparador_85 (ALBi, AGBi, AEBi, A, B, ALBo, AGBo, AEBo);

    input[3:0] A, B;
    input      ALBi, AGBi, AEBi;
    output     ALBo, AGBo, AEBo;
    wire[4:0]  CSL, CSG;

    assign CSL  = ~A + B + ALBi;
    assign ALBo = ~CSL[4];
    assign CSG  = A + ~B + AGBi;
    assign AGBo = ~CSG[4];
    assign AEBo = ((A == B) && AEBi);

endmodule /* comparador_85 *///------------------------------------------------------------------
// Arquivo   : contador_163.v
// Projeto   : Experiencia 3 - Um Fluxo de Dados Simples
//------------------------------------------------------------------
// Descricao : Contador binario de 4 bits, modulo 16
//             similar ao componente 74163
//
// baseado no componente Vrcntr4u.v do livro Digital Design Principles 
// and Practices, Fifth Edition, by John F. Wakerly              
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module contador_163 ( clock, clr, ld, ent, enp, D, Q, rco );
    input clock, clr, ld, ent, enp;
    input [3:0] D;
    output reg [3:0] Q;
    output reg rco;

    always @ (posedge clock)
        if (~clr)               Q <= 4'd0;
        else if (~ld)           Q <= D;
        else if (ent && enp)    Q <= Q + 1;
        else                    Q <= Q;
 
    always @ (Q or ent)
        if (ent && (Q == 4'd15))   rco = 1;
        else                       rco = 0;
endmodule
/*---------------Laboratorio Digital-------------------------------------
 * Arquivo   : contador_m.v
 * Projeto   : Experiencia 5 - Desenvolvimento de Projeto de 
 *                             Circuitos Digitais em FPGA
 *-----------------------------------------------------------------------
 * Descricao : contador binario, modulo m, com parametros 
 *             M (modulo do contador) e N (numero de bits),
 *             sinais para clear assincrono (zera_as) e sincrono (zera_s)
 *             e saidas de fim e meio de contagem
 *             
 *-----------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     30/01/2024  1.0     Edson Midorikawa  criacao
 *-----------------------------------------------------------------------
 */

module contador_m #(parameter M=3000, N=12)
  (
   input  wire          clock,
   input  wire          zera_as,
   input  wire          zera_s,
   input  wire          conta,
   output reg  [N-1:0]  Q,
   output reg           fim,
   output reg           meio
  );

  always @(posedge clock or posedge zera_as) begin
    if (zera_as) begin
      Q <= 0;
    end else if (clock) begin
      if (zera_s) begin
        Q <= 0;
      end else if (conta) begin
        if (Q == M-1) begin
          Q <= 0;
        end else begin
          Q <= Q + 1;
        end
      end
    end
  end

  // Saidas
  always @ (Q)
      if (Q == M-1)   fim = 1;
      else            fim = 0;

  always @ (Q)
      if (Q == M/2-1) meio = 1;
      else            meio = 0;

endmodule
/* ------------------------------------------------------------------------
 *  Arquivo   : edge_detector.v
 *  Projeto   : Experiencia 5 - Desenvolvimento de Projeto de
 *                              Circuitos Digitais com FPGA
 * ------------------------------------------------------------------------
 *  Descricao : detector de borda
 *              gera um pulso na saida de 1 periodo de clock
 *              a partir da detecao da borda de subida sa entrada
 * 
 *              sinal de reset ativo em alto
 * 
 *              > codigo adaptado a partir de codigo VHDL disponivel em
 *                https://surf-vhdl.com/how-to-design-a-good-edge-detector/
 * ------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      26/01/2024  1.0     Edson Midorikawa  versao inicial
 * ------------------------------------------------------------------------
 */
 
module edge_detector (
    input  clock,
    input  reset,
    input  sinal,
    output pulso
);

    reg reg0;
    reg reg1;

    always @(posedge clock or posedge reset) begin
        if (reset) begin
            reg0 <= 1'b0;
            reg1 <= 1'b0;
        end else if (clock) begin
            reg0 <= sinal;
            reg1 <= reg0;
        end
    end

    assign pulso = ~reg1 & reg0;

endmodule
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

/* ----------------------------------------------------------------
 * Arquivo   : hexa7seg.v
 * Projeto   : Experiencia 3 - Um Fluxo de Dados Simples
 *--------------------------------------------------------------
 * Descricao : decodificador hexadecimal para 
 *             display de 7 segmentos 
 * 
 * entrada : hexa - codigo binario de 4 bits hexadecimal
 * saida   : sseg - codigo de 7 bits para display de 7 segmentos
 *
 * baseado no componente bcd7seg.v da Intel FPGA
 *--------------------------------------------------------------
 * dica de uso: mapeamento para displays da placa DE0-CV
 *              bit 6 mais significativo é o bit a esquerda
 *              p.ex. sseg(6) -> HEX0[6] ou HEX06
 *--------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     24/12/2023  1.0     Edson Midorikawa  criacao
 *--------------------------------------------------------------
 */

module hexa7seg (hexa, display);
    input      [3:0] hexa;
    output reg [6:0] display;

    /*
     *    ---
     *   | 0 |
     * 5 |   | 1
     *   |   |
     *    ---
     *   | 6 |
     * 4 |   | 2
     *   |   |
     *    ---
     *     3
     */
        
    always @(hexa)
    case (hexa)
        4'h0:    display = 7'b1000000;
        4'h1:    display = 7'b1111001;
        4'h2:    display = 7'b0100100;
        4'h3:    display = 7'b0110000;
        4'h4:    display = 7'b0011001;
        4'h5:    display = 7'b0010010;
        4'h6:    display = 7'b0000010;
        4'h7:    display = 7'b1111000;
        4'h8:    display = 7'b0000000;
        4'h9:    display = 7'b0010000;
        4'ha:    display = 7'b0001000;
        4'hb:    display = 7'b0000011;
        4'hc:    display = 7'b1000110;
        4'hd:    display = 7'b0100001;
        4'he:    display = 7'b0000110;
        4'hf:    display = 7'b0001110;
        default: display = 7'b1111111;
    endcase
endmodule
//------------------------------------------------------------------
// Arquivo   : registrador_4.v
// Projeto   : Experiencia 4 - Projeto de uma Unidade de Controle 
//------------------------------------------------------------------
// Descricao : Registrador de 4 bits
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module registrador_4 (
    input        clock,
    input        clear,
    input        enable,
    input  [3:0] D,
    output [3:0] Q
);

    reg [3:0] IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end

    assign Q = IQ;

endmodule//------------------------------------------------------------------
// Arquivo   : sync_rom_16x4.v
// Projeto   : Experiencia 4 - Projeto de uma Unidade de Controle 
//------------------------------------------------------------------
// Descricao : ROM sincrona 16x4
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module sync_rom_16x4 (clock, address, enable, data_in, data_out);
    input            clock;
    input      [3:0] address;
    input            enable;
    input      [3:0] data_in;
    output reg [3:0] data_out;

    always @ (posedge clock)
    begin
        case (address)
            4'b0000: data_out = 4'b0001;
            4'b0001: data_out = 4'b0010;
            4'b0010: data_out = 4'b0100;
            4'b0011: data_out = 4'b1000;
            4'b0100: data_out = 4'b0100;
            4'b0101: data_out = 4'b0010;
            4'b0110: data_out = 4'b0001;
            4'b0111: data_out = 4'b0001;
            4'b1000: data_out = 4'b0010;
            4'b1001: data_out = 4'b0010;
            4'b1010: data_out = 4'b0100;
            4'b1011: data_out = 4'b0100;
            4'b1100: data_out = 4'b1000;
            4'b1101: data_out = 4'b1000;
            4'b1110: data_out = 4'b0001;
            4'b1111: data_out = 4'b0100;
        endcase
    end

endmodule

//------------------------------------------------------------------
// Arquivo   : exp4_unidade_controle.v
// Projeto   : Experiencia 4 - Projeto de uma Unidade de Controle
//------------------------------------------------------------------
// Descricao : Unidade de controle
//
// usar este codigo como template (modelo) para codificar 
// máquinas de estado de unidades de controle            
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/01/2024  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module unidade_controle (
    input      clock,
    input      reset,
    input      iniciar,
    input      fimCE,
    input      fimCR,
    input      jogada,
    input      enderecoIgualRodada,
    input      jogada_correta,
    input 	   timeout,
    output reg zeraCE,
    output reg contaCE,
    output reg zeraCR,
    output reg contaCR,
    output reg zeraR,
    output reg registraR,
    output reg zeraT,
    output reg contaT,
    output reg pronto,
    output reg errou,
    output reg acertou,
    output reg [3:0] db_estado
);

    // Define estados
    parameter inicial    = 4'b0000;  // 0
    parameter preparacao = 4'b0011;  // 3
    parameter inicio_rodada = 4'b0010; // 2
    parameter espera     = 4'b0001; // 1
    parameter registra   = 4'b0100;  // 4
    parameter comparacao = 4'b0101;  // 5
    parameter proxima_jogada    = 4'b0110;  // 6
    parameter ultima_rodada = 4'b0111; // 7
    parameter proxima_rodada = 4'b1000; // 8
    parameter derrota    = 4'b1110; // E
    parameter vitoria    = 4'b1101; // D
    parameter tout       = 4'b1011; //B

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            inicial:     Eprox = iniciar ? preparacao : inicial;
            preparacao:  Eprox = inicio_rodada;
            inicio_rodada: Eprox =  espera;
            espera:      Eprox = timeout ? tout :
											jogada ? registra: espera;
            registra:    Eprox = comparacao;
            comparacao:  Eprox = (~jogada_correta) ? derrota :
                                 (fimCE) ? ultima_rodada:
                                          proxima_jogada;
            proxima_jogada: Eprox = espera;
            ultima_rodada:     Eprox = fimCR ? vitoria : proxima_rodada;
            proxima_rodada:     Eprox = inicio_rodada;
            derrota:     Eprox = (iniciar) ? preparacao : derrota;
            vitoria:     Eprox = (iniciar) ? preparacao : vitoria;
            tout:			 Eprox = (iniciar) ? preparacao : tout;
            default:     Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraCE     = (Eatual == inicial || Eatual == preparacao || Eatual == inicio_rodada ) ? 1'b1 : 1'b0;
        contaCE   = (Eatual == proxima_jogada) ? 1'b1 : 1'b0;
        zeraCR     = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        contaCR    = (Eatual == proxima_rodada) ? 1'b1 : 1'b0;
        zeraR     = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        registraR = (Eatual == registra) ? 1'b1 : 1'b0;
        contaT    = (Eatual == espera) ? 1'b1 : 1'b0;
        zeraT     = (Eatual == inicial || Eatual == preparacao || Eatual == inicio_rodada || Eatual == proxima_jogada) ? 1'b1 : 1'b0;
        pronto    = (Eatual == derrota || Eatual == vitoria || Eatual == tout) ? 1'b1 : 1'b0; 
        errou     = (Eatual == derrota || Eatual == tout) ? 1'b1: 1'b0;
        acertou   = (Eatual == vitoria) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:     db_estado = 4'b0000;  // 0
            preparacao:  db_estado = 4'b0011;  // 3
            inicio_rodada: db_estado = 4'b0010;  // 2
            espera:      db_estado = 4'b0001;  // 1
            registra:    db_estado = 4'b0100;  // 4
            comparacao:  db_estado = 4'b0101;  // 5
            proxima_jogada:     db_estado = 4'b0110;  // 6
            ultima_rodada: db_estado = 4'b0111;  // 7
            proxima_rodada: db_estado = 4'b1000;  // 8
            derrota:     db_estado = 4'b1110;  // E
            vitoria:     db_estado = 4'b1101;  // D
            tout:			 db_estado = 4'b1011;  // B

            default:     db_estado = 4'b1111;  // F
        endcase
    end

endmodule