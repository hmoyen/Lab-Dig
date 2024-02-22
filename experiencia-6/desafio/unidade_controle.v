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
    output reg gravaRAM,
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
    parameter espera_incremento = 4'b1001; // 9
    parameter grava       = 4'b1100; //C 

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
                                 (enderecoIgualRodada) ? ultima_rodada:
                                          proxima_jogada;
            proxima_jogada: Eprox = espera;
            ultima_rodada:     Eprox = fimCR ? vitoria : proxima_rodada;
            proxima_rodada:     Eprox = espera_incremento;
            espera_incremento:      Eprox = timeout ? tout :
											jogada ? grava: espera_incremento;
            grava:                  Eprox = inicio_rodada;
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
        contaT    = (Eatual == espera || Eatual == espera_incremento) ? 1'b1 : 1'b0;
        zeraT     = (Eatual == inicial || Eatual == preparacao || Eatual == inicio_rodada || Eatual == proxima_jogada || Eatual == proxima_rodada) ? 1'b1 : 1'b0;
        pronto    = (Eatual == derrota || Eatual == vitoria || Eatual == tout) ? 1'b1 : 1'b0; 
        errou     = (Eatual == derrota || Eatual == tout) ? 1'b1: 1'b0;
        acertou   = (Eatual == vitoria) ? 1'b1 : 1'b0;
        gravaRAM   = (Eatual == grava)   ? 1'b1 : 1'b0;

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
            grava:     db_estado = 4'b1100; //C
            espera_incremento: db_estado = 4'b1001; //9

            default:     db_estado = 4'b1111;  // F
        endcase
    end

endmodule