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
        zeraT = (Eatual == inicial || Eatual == preparacao || Eatual == inicio_rodada || Eatual == proximo) ? 1 : 0; 
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