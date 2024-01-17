/*
 * ------------------------------------------------------------------
 *  Arquivo   : circuito_exp3_ativ2-PARCIAL.v
 *  Projeto   : Experiencia 3 - Um Fluxo de Dados Simples
 * ------------------------------------------------------------------
 *  Descricao : Circuito PARCIAL do fluxo de dados da Atividade 2
 * 
 *     1) COMPLETAR DESCRICAO
 * 
 * ------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      11/01/2024  1.0     Edson Midorikawa  versao inicial
 * ------------------------------------------------------------------
 */

`timescale 1ns/1ns

module testbench;

    reg        clock;
    reg        clock_tb;
    reg        zera;
    reg        carrega;
    reg        conta;
    reg  [3:0] chaves;
    wire       menor;
    wire       maior;
    wire       igual;
    wire       fim;
    wire [3:0] contagem;


    // contador_163
    circuito_exp3_ativ2 circuito (
        .clock (clock), 
        .zera (zera), 
        .carrega (carrega), 
        .conta (conta), 
        .chaves (chaves), 
        .menor (menor), 
        .maior (maior), 
        .igual (igual), 
        .fim (fim), 
        .db_contagem (contagem)
    );

    initial $dumpfile("testbench.vcd");
    initial $dumpvars(0, testbench);

    initial 
    begin
        
        //*******************************Abaixo é a simulação: ********************************************************************


        // CONDICOES INICIAIS

        clock=1;
        clock_tb = 0;
        zera=0;
        carrega=0;
        conta=0;
        chaves=0;

        #30
        
        clock = 0;

        #10
        // PRIMEIRO TESTE
        zera = 1;
        clock = 1;

        #10
        
        clock = 0;

        #30

        // SEGUNDO TESTE
        chaves=1;

        #30

        // TERCEIRO TESTE
        zera = 0;
        conta=1;
        clock = 1;

        #10
        
        clock = 0;

        #30

        //QUARTO TESTE
        conta=1;
        chaves = 4'b0010;
        clock = 1;

        #10

        clock = 0;

        #10

        clock = 1;

        #10 

        clock = 0;

        //QUINTO TESTE

        #30

        chaves=4'b0110;

        #10

        //SEXTO TESTES
        conta=1;

        #10

        clock = 1; // 1x
 
        #10

        clock = 0;

        #10

        clock = 1; //2x

        #10

        clock = 0;

        #10

        clock = 1; //3x

        #10

        clock = 0;

        #10

        clock = 1; //4x
        #10

        clock = 0;

        #10

        clock = 1; //5x

        #10

        clock = 0;

        #10

        clock = 1; //6x

        #10

        clock = 0;

        #10

        clock = 1; //7x

        #10

        clock = 0;

        #10

        clock = 1; //8x

        #10

        clock = 0;

        #10

        clock = 1; //9x

        #10

        clock = 0;

        #10

        clock = 1; //10x

        #10

        clock = 0;

        #10

        clock = 1; //11x

        #10

        clock = 0;

        #10


        //SETIMO TESTE

        conta =1;

        #10

        clock = 1;

        #50
        $display("%d", contagem);
        #10
       
$finish;

     
    end

        always #10 clock_tb = ~clock_tb;



 endmodule
