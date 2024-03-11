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

wire desloca, zeraPosicoes, colisao, fim_espera, fim_mapa;

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
    .colisao(colisao),
    .fim_espera(fim_espera),
    .fim_mapa(fim_mapa),
    .db_posicao_horizontal(db_posicao_horizontal),
    .db_posicao_vertical(db_posicao_vertical),
    .db_obstaculos(db_obstaculos)
);




endmodule
//------------------------------------------------------------------
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
module contador_4_mais_menos ( clock, clr, ld, soma, sub, enp, D, Q, rco);
    input clock, clr, ld, enp, soma, sub;
    input [1:0] D;
    output reg [1:0] Q;
    output reg rco;

    always @ (posedge clock)
        if (~clr)               Q <= 2'b0;
        else if (~ld)           Q <= D;
        else if (enp) begin
            if (soma && (Q!=2'b11))         Q <= Q + 1;
            else if (sub && (Q!=2'b00))     Q <= Q - 1;
        end
        else                    Q <= Q;
 
    always @ (Q or enp)
        if (enp && (Q == 2'b00))   rco = 1;
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

module contador_m_2 #(parameter M=2000, N=13)
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

module contador_m #(parameter M=5000, N=13)
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
module converte_2b_4b( 
    input  [1:0] posicao_2b,
    output [3:0] posicao_4b
);


assign posicao_4b = posicao_2b == 2'b00 ? 4'b0001 :
                    posicao_2b == 2'b01 ? 4'b0010 :
                    posicao_2b == 2'b10 ? 4'b0100 :
                    posicao_2b == 2'b11 ? 4'b1000 : 4'bxxxx; 


endmodule/* ------------------------------------------------------------------------
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
input reset,
input iniciar,
input [1:0] controle,
input clock,
input desloca,
input zeraPosicoes,
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
    .clock(clear),
    .clr(~zeraPosicoes),
    .ld(1'b1),
    .ent(1'b1),
    .enp(desloca),
    .D(),
    .Q(posicao_horizontal),
    .rco(fim_mapa) 
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

contador_m_2 contador_tempo_jogada(
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(zeraT),
    .conta(contaT),
    .Q(),
    .fim(fim_espera),
    .meio()
);

// comparador_85 compara_colisao(
//     .ALBi(1'b0), 
//     .AGBi(1'b0), 
//     .AEBi(1'b1), 
//     .A(posicao_vertical), 
//     .B(obstaculos[posicao_vertical]), 
//     .ALBo(), 
//     .AGBo(), 
//     .AEBo(colisao)
// );

sync_ram_16x4_file mapa_jogo(
    .clk(clock),
    .we(1'b0),
    .data(4'b0),
    .addr(posicao_horizontal),
    .q(obstaculos)
);

converte_2b_4b conversor_posicao(
    .posicao_2b(posicao_vertical),
    .posicao_4b(db_posicao_vertical)
);

assign db_posicao_horizontal = posicao_horizontal;
assign db_obstaculos = obstaculos;
assign colisao = obstaculos[posicao_vertical] == 1 ? 1'b1 : 1'b0;









endmodule/* ----------------------------------------------------------------
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

endmodule

// Arquivo   : sync_ram_16x4_file.v
// Projeto   : Experiencia 7 - Projeto do Jogo do Desafio da Memória
 
//------------------------------------------------------------------
// Descricao : RAM sincrona 16x4
//
//   - conteudo inicial armazenado em arquivo .txt
//   - descricao baseada em template 'single_port_ram_with_init.v' 
//     do Intel Quartus Prime
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     02/02/2024  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//

module sync_ram_16x4_file #(
    parameter BINFILE = "ram_init.txt"
)
(
    input        clk,
    input        we,
    input  [3:0] data,
    input  [3:0] addr,
    output [3:0] q
);

    // Variavel RAM (armazena dados)
    reg [3:0] ram[15:0];

    // Registra endereco de acesso
    reg [3:0] addr_reg;

    // Especifica conteudo inicial da RAM
    // a partir da leitura de arquivo usando $readmemb
    initial 
    begin : INICIA_RAM
        // leitura do conteudo a partir de um arquivo
        $readmemb(BINFILE, ram);
    end 

    always @ (posedge clk)
    begin
        // Escrita da memoria
        if (we)
            ram[addr] <= data;

        addr_reg <= addr;
    end

    // Atribuicao continua retorna dado
    assign q = ram[addr_reg];

endmodule//------------------------------------------------------------------
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
    input      fim_espera,
    input      fim_mapa,
    input      colisao,
    output reg zeraPosicoes,
    output reg contaT,
    output reg zeraT,
    output reg desloca,
    output reg venceu,
    output reg perdeu,
    output reg [3:0] db_estado
);

    // Define estados
    parameter inicial    = 4'b0000;  // 0
    parameter preparacao = 4'b0001;  // 1
    parameter inicio_rodada = 4'b0010; // 2
    parameter espera     = 4'b0011; // 3
    parameter deslocamento     = 4'b0100; // 4
    parameter checa_colisao     = 4'b0101; // 5
    parameter proximo     = 4'b0110; // 6
    parameter derrota     = 4'b0111; // 7
    parameter vitoria     = 4'b1000; // 8
    
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
            inicial:    Eprox = iniciar ? preparacao : inicial;
            preparacao: Eprox = inicio_rodada;
            inicio_rodada: Eprox = espera;
            espera:     Eprox = fim_espera ? deslocamento : espera;
            deslocamento: Eprox = checa_colisao;
            checa_colisao: Eprox = colisao ? derrota : proximo;
            proximo:    Eprox = fim_mapa ? vitoria : inicio_rodada; 
            derrota:   Eprox = iniciar ? preparacao : derrota;
            vitoria:   Eprox = iniciar ? preparacao : vitoria;
            
            default:     Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraPosicoes = (Eatual == inicial || Eatual == preparacao) ? 1 : 0;
        contaT = (Eatual == espera) ? 1 : 0;
        zeraT = (Eatual != espera) ? 1 : 0; 
        desloca = (Eatual == deslocamento) ? 1 : 0;
        venceu = (Eatual == vitoria) ? 1 : 0;
        perdeu = (Eatual == derrota) ? 1 : 0;
        
        // Saida de depuracao (estado) 
        case (Eatual)
            inicial:    db_estado = 4'b0000;  // 0
            preparacao: db_estado = 4'b0001;  // 1
            inicio_rodada: db_estado = 4'b0010;  // 2
            espera:     db_estado = 4'b0011;  // 3
            deslocamento: db_estado = 4'b0100;  // 4
            checa_colisao: db_estado = 4'b0101;  // 5
            proximo:    db_estado = 4'b0110;  // 6
            derrota:   db_estado = 4'b0111;  // 7
            vitoria:   db_estado = 4'b1000;  // 8

            default:     db_estado = 4'b1111;  // F
        endcase
    end

endmodule