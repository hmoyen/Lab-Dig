module simulador_drone(
    input clock,
    input reset,
    input iniciar,
    input [1:0] controle,
    input confirma,
    output venceu,
    output perdeu,
    output [3:0] db_posicao_horizontal,
    output [3:0] db_posicao_vertical,
    output [3:0] db_obstaculos,
    output [3:0] db_estado,
    output [1:0] db_modo,
    output [2:0] db_fim_espera_intero
);

wire move_drone, desloca_horizontal, zeraPosicoes, colisao, fim_espera, fim_mapa, contaT, zeraT, escolhe_menu;

//wire [3:0] posicao_horizontal, posicao_vertical;

unidade_controle uc(
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
    .confirma(confirma),
    .fim_espera(fim_espera),
    .fim_mapa(fim_mapa),
    .colisao(colisao),
    .zeraPosicoes(zeraPosicoes),
    .contaT(contaT),
    .zeraT(zeraT),
    .move_drone(move_drone),
    .desloca_horizontal(desloca_horizontal),
    .escolhe_menu(escolhe_menu),
    .venceu(venceu),
    .perdeu(perdeu),
    .db_estado(db_estado)
);

fluxo_dados fd(
    .reset(reset),
    .iniciar(iniciar),
    .controle(controle),
    .confirma(confirma),
    .clock(clock),
    .zeraPosicoes(zeraPosicoes),
    .contaT(contaT),
    .zeraT(zeraT),
    .move_drone(move_drone),
    .desloca_horizontal(desloca_horizontal),
    .escolhe_menu(escolhe_menu),
    .colisao(colisao),
    .fim_espera(fim_espera),
    .fim_mapa(fim_mapa),
    .db_posicao_horizontal(db_posicao_horizontal),
    .db_posicao_vertical(db_posicao_vertical),
    .db_obstaculos(db_obstaculos),
    .modo(db_modo),
    .db_fim_espera_intero(db_fim_espera_intero)
);

// hexa7seg posicao_horizontal_hex7(
//     .hexa(posicao_vertical),
//     .display()
// );

endmodule



//------------------------------------------------------------------
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
endmodule/* -----------------------------------------------------------------
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

endmodule /* comparador_85 */
module contador_4_mais_menos ( clock, clr, ld, soma, sub, enp, D, Q, rco);
    input clock, clr, ld, enp, soma, sub;
    input [1:0] D;
    output reg [1:0] Q;
    output reg rco;

    always @ (posedge clock)
        if (~clr)               Q <= 2'b0;
        else if (~ld)           Q <= D;
        else if (enp) begin
            if (soma == 1 && Q!=2'b11)        Q <= Q + 1;
            else if (sub == 1 && Q!=2'b00)     Q <= Q - 1;
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

module contador_m_1 #(parameter M=1000, N=11)
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

module contador_m_05 #(parameter M=10, N=10)
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
input confirma,
input clock,
input zeraPosicoes,
input contaT,
input zeraT,
input move_drone,
input desloca_horizontal,
input escolhe_menu,
output colisao,
output fim_espera,
output fim_mapa,
output [3:0] db_posicao_horizontal,
output [3:0] db_posicao_vertical,
output [3:0] db_obstaculos,
output [1:0] modo,
output [2:0] db_fim_espera_intero
);

wire [1:0] posicao_vertical;
wire [3:0] obstaculos, posicao_horizontal;
wire [2:0] fim_espera_interno;
wire [1:0] modo_interno;
wire [1:0] borda_controle;
wire borda;


contador_163 contador_posicao_horizontal(
    .clock(clock),
    .clr(~zeraPosicoes),
    .ld(1'b1),
    .ent(1'b1),
    .enp(desloca_horizontal),
    .D(),
    .Q(posicao_horizontal),
    .rco(fim_mapa) 
);

contador_m_2 contador_tempo_jogada_facil(
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(zeraT),
    .conta(contaT),
    .Q(),
    .fim(fim_espera_interno[0]),
    .meio()
);

contador_m_1 contador_tempo_jogada_medio(
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(zeraT),
    .conta(contaT),
    .Q(),
    .fim(fim_espera_interno[1]),
    .meio()
);

contador_m_05 contador_tempo_jogada_dificl(
    .clock(clock),
    .zera_as(1'b0),
    .zera_s(zeraT),
    .conta(contaT),
    .Q(),
    .fim(fim_espera_interno[2]),
    .meio()
);

sync_ram_16x4_file mapa_jogo(
    .clk(clock),
    .we(1'b0),
    .data(4'b0),
    .addr(posicao_horizontal + 4'b0001),
    .q(obstaculos)
);

contador_4_mais_menos contador_posicao_vertical(
    .clock(clock), 
    .clr(1'b1), 
    .ld(~zeraPosicoes), 
    .soma(controle[0]), 
    .sub(controle[1]), 
    .enp(move_drone & borda), 
    .D(2'b10), 
    .Q(posicao_vertical), 
    .rco()
);


contador_3_mais_menos contador_modo( // 0 = FACIL, 1 = MEDIO, 2 = DIFICIL
    .clock(clock),
    .clr(~iniciar),
    .ld(1'b1),
    .soma(controle[0]),
    .sub(controle[1]),
    .enp(escolhe_menu & borda),
    .D(),
    .Q(modo_interno),
    .rco()
);

edge_detector detector_borda0(
    .clock(clock),
    .reset(1'b0),
    .sinal(controle[0]),
    .pulso(borda_controle[0])
);

edge_detector detector_borda1(
    .clock(clock),
    .reset(1'b0),
    .sinal(controle[1]),
    .pulso(borda_controle[1])
);


converte_2b_4b conversor_posicao( // ENCODER
    .posicao_2b(posicao_vertical),
    .posicao_4b(db_posicao_vertical)
);

assign db_posicao_horizontal = posicao_horizontal;
assign db_obstaculos = obstaculos;
assign colisao = obstaculos[posicao_vertical] == 1 ? 1'b1 : 1'b0;
assign fim_espera = fim_espera_interno[modo_interno];
assign modo = modo_interno;
assign db_fim_espera_intero = fim_espera_interno;
assign borda = borda_controle[0] | borda_controle[1];








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
    input      confirma,
    input      fim_espera,
    input      fim_mapa,
    input      colisao,
    output reg zeraPosicoes,
    output reg contaT,
    output reg zeraT,
    output reg escolhe_menu,
    output reg move_drone,
    output reg desloca_horizontal,
    output reg venceu,
    output reg perdeu,
    output reg [3:0] db_estado
);

    // Define estados
    parameter inicial    = 4'b0000;  // 0
    parameter menu       = 4'b0010;  // 2
    parameter preparacao = 4'b0001;  // 1
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
            inicial:    Eprox = iniciar ? menu : inicial;
            menu:       Eprox = confirma ? preparacao : menu;
            preparacao: Eprox = espera;
            espera:     Eprox = fim_espera ? deslocamento : espera;
            deslocamento: Eprox = checa_colisao;
            checa_colisao: Eprox = colisao ? derrota : proximo;
            proximo:    Eprox = fim_mapa ? vitoria : espera; 
            derrota:   Eprox = iniciar ? preparacao : derrota;
            vitoria:   Eprox = iniciar ? preparacao : vitoria;
            default:     Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraPosicoes = (Eatual == inicial || Eatual == preparacao) ? 1 : 0;
        contaT = (Eatual == espera) ? 1 : 0;
        zeraT = (Eatual == inicial || Eatual == preparacao || Eatual == proximo) ? 1 : 0; 
        move_drone = (Eatual == espera) ? 1 : 0;
        desloca_horizontal = (Eatual == deslocamento) ? 1 : 0;
        venceu = (Eatual == vitoria) ? 1 : 0;
        perdeu = (Eatual == derrota) ? 1 : 0;
        escolhe_menu = (Eatual == menu) ? 1 : 0;
        
        // Saida de depuracao (estado) 
        case (Eatual)
            inicial:    db_estado = 4'b0000;  // 0
            menu:       db_estado = 4'b0010;  // 2
            preparacao: db_estado = 4'b0001;  // 1
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
module contador_3_mais_menos ( clock, clr, ld, soma, sub, enp, D, Q, rco);
    input clock, clr, ld, enp, soma, sub;
    input [1:0] D;
    output reg [1:0] Q;
    output reg rco;

    always @ (posedge clock) begin
        if (~clr)               Q <= 2'b0;
        else if (~ld)           Q <= D;
        else if (enp) begin

            if (soma == 1) begin
                if (Q==2'b10)               Q <= 2'b0;
                else                        Q <= Q + 1;
            end 

            else if (sub == 1) begin
                if (Q==2'b00)               Q <= 2'b10;
                else                        Q <= Q - 1;
            end 

        end

        else  begin
            Q <= Q;
        end 

    end
    
 
    always @ (Q or enp)
        if (enp && (Q == 2'b00))   rco = 1;
        else                       rco = 0;
endmodule