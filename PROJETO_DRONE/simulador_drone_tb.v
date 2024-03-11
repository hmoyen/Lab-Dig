module simulador_drone_tb;

reg clock = 0;
reg reset = 0;
reg iniciar = 0;
reg [1:0] controle = 2'b01;
wire venceu, perdeu;
wire [3:0] db_posicao_horizontal, db_posicao_vertical, db_obstaculos, db_estado;

simulador_drone dut(
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
    .controle(controle),
    .venceu(venceu),
    .perdeu(perdeu),
    .db_posicao_horizontal(db_posicao_horizontal),
    .db_posicao_vertical(db_posicao_vertical),
    .db_obstaculos(db_obstaculos),
    .db_estado(db_estado)
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
    #(5*clockPeriod);

    // Teste 2: iniciar = 1 por 5 períodos de clock
    caso = 2;
    iniciar = 1;
    #(5*clockPeriod);
    iniciar = 0;

    //Teste 3: controle = 00
    caso = 3;
    controle = 2'b00;
    #(2002*clockPeriod);

    //Teste 4: controle = 10
    caso = 4;
    controle = 2'b10;
    #(2002*clockPeriod);

    //Teste 4: controle = 00
    caso = 4;
    controle = 2'b00;
    #(2002*clockPeriod);

    //Teste 4: controle = 01
    caso = 4;
    controle = 2'b01;
    #(2002*clockPeriod);

    //Teste 4: controle = 10
    caso = 4;
    controle = 2'b10;
    #(2002*clockPeriod);


    $stop;
    end


endmodule