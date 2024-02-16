/* --------------------------------------------------------------------
 * Arquivo   : circuito_exp6_tb-MODELO.vhd
 * Projeto   : Experiencia 5 - Desenvolvimento de Projeto de 
 *             Circuitos Digitais em FPGA
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog MODELO para circuito da Experiencia 5 
 *
 *             1) Plano de teste com 4 jogadas certas  
 *                e erro na quinta jogada
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     27/01/2024  1.0     Edson Midorikawa  versao inicial
 * --------------------------------------------------------------------
*/

`timescale 1ns/1ns

module circuito_exp6_tb_certo;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [3:0] chaves_in  = 4'b0000;

    wire       ganhou_out;
    wire       perdeu_out  ;
    
    wire       pronto_out ;
    wire [3:0] leds_out   ;

    // wire       db_igual_out      ;
    wire [6:0] db_contagem_out   ;
    wire [6:0] db_memoria_out    ;
    wire [6:0] db_estado_out     ;
    wire       db_timeout_out;
    wire [6:0] db_jogadafeita_out;
    wire [6:0] db_rodada_out     ;
    wire       db_clock_out      ;
    wire       db_iniciar_out    ;
    wire       db_tem_jogada_out ;
    wire       db_enderecoIgualRodada_out;
    wire       db_jogada_correta_out;
    wire [12:0] db_Q_out;

    // Configuração do clock
    parameter clockPeriod = 1000; // 

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    circuito_jogo_base dut (
      .clock          ( clock_in    ),
      .reset          ( reset_in    ),
      .iniciar        ( iniciar_in  ),
      .chaves         ( chaves_in   ),
      .ganhou        ( ganhou_out ),
      .perdeu         ( perdeu_out  ),
      .pronto         ( pronto_out  ),
      .leds           ( leds_out    ),
      .db_contagem    ( db_contagem_out    ),
      .db_memoria     ( db_memoria_out     ),
      .db_estado      ( db_estado_out      ),
      .db_jogadafeita ( db_jogadafeita_out ),
      .db_rodada      ( db_rodada_out      ),
      .db_clock       ( db_clock_out       ),   
      .db_tem_jogada  ( db_tem_jogada_out  ),
      .db_timeout      (db_timeout_out),
      .db_enderecoIgualRodada (db_enderecoIgualRodada_out),
      .db_jogada_correta (db_jogada_correta_out),
      .db_Q(db_Q_out)
    );

    initial $dumpfile("testbench.vcd");
    initial $dumpvars(0, circuito_exp6_tb_certo);

    // geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in   = 1;
      reset_in   = 0;
      iniciar_in = 0;
      chaves_in  = 4'b0000;
      #clockPeriod;

      /*
       * Cenario de Teste 1 - acerta as 16 jogadas
       */

      // Teste 1. resetar circuito
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;
      // espera
      #(5*clockPeriod);

      // Teste 2. iniciar=1 por 5 periodos de clock
      caso = 2;
      iniciar_in = 1;
      #(5*clockPeriod);
      iniciar_in = 0;
      // espera
      #(5*clockPeriod);

      // Teste 3. jogada #1 (ajustar chaves para 0001 por 10 periodos de clock
      caso = 3;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 4. jogada #2 (recolocar chaves para 0001 por 10 periodos de clock
      caso = 4;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 5. jogada #3 (ajustar chaves para 0010 por 10 periodos de clock
      caso = 5;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 6. jogada #4 errada (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 6;
      @(negedge clock_in);
      chaves_in = 4'b0001; // jogada certa = 4'b1000
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      //make the other instructions, following the same intructions with the values below
      // Teste 7. jogada #5 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 7;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 8. jogada #6 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 8;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);
      
      // Teste 9. jogada #7 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 9;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 10. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 10;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 11. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 11;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 12. jogada #10 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 12;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 14. jogada #7 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 13;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 15. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 14;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 16. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 15;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 17. jogada #10 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 16;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 18. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 17;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

            // Teste 14. jogada #7 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 18;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 15. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 19;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 16. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 20;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 17. jogada #10 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 21;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 18. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 22;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 15. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 23;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

                  // Teste 14. jogada #7 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 24;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 15. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 25;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 16. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 26;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 17. jogada #10 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 27;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 18. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 28;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 19. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 29;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 20. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 30;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 14. jogada #7 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 31;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 15. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 32;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 16. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 33;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 17. jogada #10 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 34;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 18. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 35;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 19. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 36;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 20. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 37;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 21. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 38;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 14. jogada #7 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 39;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 15. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 40;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 16. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 41;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 17. jogada #10 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 42;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 18. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 43;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 19. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 44;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 20. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 45;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 21. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 46;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 22. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 47;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 14. jogada #7 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 48;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 15. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 49;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 16. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 50;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 17. jogada #10 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 51;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 18. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 52;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 19. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 53;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 20. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 54;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 21. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 55;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 22. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 56;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 23. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 57;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 14. jogada #7 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 58;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 15. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 59;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 16. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 60;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 17. jogada #10 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 61;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 18. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 62;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 19. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 63;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 20. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 64;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 21. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 65;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 22. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 66;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 23. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 67;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 24. jogada #8 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 68;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 14. jogada #7 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 69;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 15. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 70;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 16. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 71;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 17. jogada #10 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 72;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 18. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 73;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 19. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 74;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 20. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 75;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 21. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 76;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 22. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 77;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 23. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 78;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 24. jogada #8 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 79;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 25. jogada #8 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 80;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 14. jogada #7 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 81;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 15. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 82;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 16. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 83;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 17. jogada #10 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 84;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 18. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 85;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 19. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 86;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 20. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 87;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 21. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 88;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 22. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 89;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 23. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 90;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 24. jogada #8 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 91;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 25. jogada #8 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 92;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 26. jogada #8 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 93;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 14. jogada #7 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 94;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 15. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 95;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 16. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 96;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 17. jogada #10 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 97;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 18. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 98;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 19. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 99;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 20. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 100;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 21. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 101;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 22. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 102;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 23. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 103;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 24. jogada #8 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 104;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 25. jogada #8 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 105;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 26. jogada #8 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 106;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 27. jogada #8 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 107;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 14. jogada #7 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 108;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 15. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 109;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 16. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 110;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 17. jogada #10 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 111;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 18. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 112;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 19. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 113;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 20. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 114;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 21. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 115;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 22. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 116;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 23. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 117;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 24. jogada #8 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 118;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 25. jogada #8 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 119;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 26. jogada #8 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 120;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 27. jogada #8 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 121;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 28. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 122;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 14. jogada #7 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 123;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 15. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 124;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 16. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 125;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 17. jogada #10 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 126;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 18. jogada #9 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 127;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 19. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 128;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 20. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 129;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 21. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 130;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 22. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 131;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 23. jogada #8 (ajustar chaves para 0010 por 10 periodos de clock)
      caso = 132;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 24. jogada #8 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 133;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 25. jogada #8 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 134;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 26. jogada #8 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 135;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 27. jogada #8 (ajustar chaves para 1000 por 10 periodos de clock)
      caso = 136;
      @(negedge clock_in);
      chaves_in = 4'b1000;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 28. jogada #8 (ajustar chaves para 0001 por 10 periodos de clock)
      caso = 137;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 29. jogada #8 (ajustar chaves para 0100 por 10 periodos de clock)
      caso = 138;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      

      
      // final dos casos de teste da simulacao

      caso = 300;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule


