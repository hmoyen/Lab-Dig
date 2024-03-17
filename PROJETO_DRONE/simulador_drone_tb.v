module simulador_drone_tb;

reg clock = 0;
reg reset = 0;
reg iniciar = 0;
reg [1:0] controle = 2'b00;
reg confirma = 0;
wire venceu, perdeu;
wire [3:0] db_posicao_horizontal, db_posicao_vertical, db_obstaculos, db_estado;
wire [1:0] db_modo;
wire [2:0] colisao_counter_out;
integer i;


simulador_drone dut(
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
    .controle(controle),
    .confirma(confirma),
    .venceu(venceu),
    .perdeu(perdeu),
    .db_posicao_horizontal(db_posicao_horizontal),
    .db_posicao_vertical(db_posicao_vertical),
    .db_obstaculos(db_obstaculos),
    .db_estado(db_estado),
    .db_modo(db_modo),
    .colisao_counter_out(colisao_counter_out)
);

parameter clockPeriod = 1000;


// Gerador de clock
always #((clockPeriod / 2)) clock = ~clock;

reg [20:0] caso;

   // Geração do arquivo VCD
    initial $dumpfile("testbench_drone.vcd");
    initial $dumpvars(0, simulador_drone_tb);

    // Geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

    caso = 0;
    // Teste 1: Resetar circuito
    caso = 1;
    // Gerar pulso de reset
    @(negedge clock);
    reset = 1;
    #(clockPeriod);
    reset = 0;
    // Esperar
    #(10*clockPeriod);

    // Teste 2: iniciar = 1 por 5 períodos de clock
    caso = 2;
    iniciar = 1;
    #(2*clockPeriod);
    iniciar = 0;
    #(10*clockPeriod);


    //COLOCAR NO MODO FACIL
    caso = 5;
    #(10*clockPeriod);
    controle = 2'b00;
    confirma = 1;
    #(10*clockPeriod);
    confirma = 0;
    #(10*clockPeriod);

    //CASO 6: ESCOLHER 3 VIDAS
    controle = 2'b01;
    #(10*clockPeriod);
    controle = 2'b00;
    #(10*clockPeriod);
    controle = 2'b01;
    #(10*clockPeriod);
    controle = 2'b00;
    #(10*clockPeriod);
    confirma = 1;
    #(10*clockPeriod);




    // //Teste 3: controle = 00
    // caso = 3;
    // controle = 2'b01;
    // #(2002*clockPeriod);

    for (i = 0 ;i < 6 ; i = i + 1) begin
      caso = 8 + i;
      controle = 2'b00;
      #(2002*clockPeriod);
    end

    //Teste 4: controle = 10
    caso = 4;
    controle = 2'b10;
    #(5*clockPeriod);
    controle = 2'b00;
        #(5*clockPeriod);
    controle = 2'b10;
    #(2002*clockPeriod);

    //Teste 4: controle = 00
    caso = 5;
    controle = 2'b00;
    #(2002*clockPeriod);

    //Teste 4: controle = 01
    caso = 6;
    controle = 2'b00;
    #(5*clockPeriod);
    controle = 2'b01;
    #(5*clockPeriod);
    controle = 2'b00;
    #(5*clockPeriod);
    controle = 2'b01;
    #(2002*clockPeriod);

    //Teste 4: controle = 10
    caso = 7;
    controle = 2'b00;
    #(5*clockPeriod);
    controle = 2'b01;
    #(2002*clockPeriod);

    for (i = 0 ;i < 6 ; i = i + 1) begin
      caso = 8 + i;
      controle = 2'b00;
      #(2002*clockPeriod);
    end
    
    caso = 15;
    controle = 2'b00;
    #(5*clockPeriod);
    controle = 2'b10;
    #(3*2002*clockPeriod);

    caso = 16;
    controle = 2'b00;
    #(5*clockPeriod);
    controle = 2'b01;
    #(3*2002*clockPeriod);

      

    $stop;
    end


endmodule