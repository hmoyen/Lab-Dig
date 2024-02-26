module circuito_exp7_timeout_tb;

    // Sinais para conectar com o DUT
    // Valores iniciais para fins de simulacao (ModelSim)
    reg clock_in   = 1;
    reg reset_in   = 0;
    reg iniciar_in = 0;
    reg [3:0] chaves_in  = 4'b0000;

    wire ganhou_out;
    wire perdeu_out;
    wire pronto_out;
    wire [3:0] leds_out;
    wire [6:0] db_contagem_out;
    wire [6:0] db_memoria_out;
    wire [6:0] db_estado_out;
    wire [6:0] db_jogadafeita_out;
    wire [6:0] db_rodada_out;
    wire db_clock_out;
    wire db_tem_jogada_out;
    wire db_timeout_out;
    wire db_jogada_correta_out;
    wire db_enderecoIgualRodada_out;
    wire db_grava_out;
    wire [12:0] db_Q_out;

    // Configuração do período do clock
    parameter clockPeriod = 1000; // Defina o período do clock conforme necessário

    // Identificação do caso de teste
    reg [31:0] caso = 0;

    // Array para armazenar as jogadas
    reg [3:0] jogadas[0:15];

    // Variável para controlar o número de jogadas
    reg [4:0] jogada_counter = 0;

    integer i;
    reg [3:0] sequencia [15:0];
    
    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // Instanciação do DUT (Device Under Test)
    jogo_desafio_memoria dut (
      .clock          ( clock_in    ),
      .reset          ( reset_in    ),
      .iniciar        ( iniciar_in  ),
      .botoes         ( chaves_in   ),
      .ganhou         ( ganhou_out ),
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
      .db_timeout     ( db_timeout_out     ),
      .db_jogada_correta      ( db_jogada_correta_out     ),
      .db_enderecoIgualRodada ( db_enderecoIgualRodada_out ),
      .db_grava               ( db_grava_out               ),
      .db_Q                   ( db_Q_out                   )
    );

    // Geração do arquivo VCD
    initial $dumpfile("testbench_timeout.vcd");
    initial $dumpvars(0, circuito_exp7_timeout_tb);

    // Geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      sequencia[0] = 4'b0001;
      sequencia[1] = 4'b0010;
      sequencia[2] = 4'b0100;
      sequencia[3] = 4'b1000;
      sequencia[4] = 4'b0100;
      sequencia[5] = 4'b0010;
      sequencia[6] = 4'b0001;
      sequencia[7] = 4'b0010;
      sequencia[8] = 4'b0100;
      sequencia[9] = 4'b1000;
      sequencia[10] = 4'b0100;
      sequencia[11] = 4'b0010;
      sequencia[12] = 4'b0001;
      sequencia[13] = 4'b0010;
      sequencia[14] = 4'b0100;
      sequencia[15] = 4'b1000;

      // Condições iniciais
      caso       = 0;
      clock_in   = 1;
      reset_in   = 0;
      iniciar_in = 0;
      chaves_in  = 4'b0000;
      #clockPeriod;

      // Cenário de teste 1 - acerta as 16 jogadas

      // Teste 1: Resetar circuito
      caso = 1;
      // Gerar pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;
      // Esperar
      #(5*clockPeriod);

      // Teste 2: iniciar = 1 por 5 períodos de clock
      caso = 2;
      iniciar_in = 1;
      #(5*clockPeriod);
      iniciar_in = 0;
      // Esperar
      #(2005*clockPeriod);

      // Teste 2: iniciar = 1 por 5 períodos de clock
      caso = 3;
      chaves_in = sequencia[0];
      
      #(100*clockPeriod);
      chaves_in <= 4'b0000;
      #(100*clockPeriod);
      chaves_in = sequencia[1];
      #(100*clockPeriod);
      chaves_in <= 4'b0000;
      #(100*clockPeriod);

      for(jogada_counter=3; jogada_counter<18; jogada_counter = jogada_counter + 1) begin
        for(i=0; i<(jogada_counter); i = i+1) begin
          caso <= caso + 1;
          
          if (jogada_counter == 5 && i==4) begin // timeout na jogada adicional da terceira rodada
            chaves_in <= 4'b0000;
            #(6000*clockPeriod);
            jogada_counter <= 18;
            i<= 19; // sai do loop
          end
          else begin
            chaves_in <= sequencia[i];
          end
          #(100*clockPeriod);
          chaves_in <= 4'b0000;
          #(100*clockPeriod);

        end
      end
      #(100*clockPeriod);
      #(100*clockPeriod);
      #(100*clockPeriod);
      #(1000*clockPeriod);
    $display("Fim da simulacao");
    $stop;
    end
    

endmodule
