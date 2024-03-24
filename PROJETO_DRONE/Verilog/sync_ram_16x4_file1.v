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

module sync_ram_16x4_file1 #(
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
        //$readmemb(BINFILE, ram);
        ram[0] <= 4'b0000;
        ram[1] <= 4'b0010;
        ram[2] <= 4'b0100;
        ram[3] <= 4'b1000;
        ram[4] <= 4'b0100;
        ram[5] <= 4'b0010;
        ram[6] <= 4'b0001;
        ram[7] <= 4'b0001;
        ram[8] <= 4'b0010;
        ram[9] <= 4'b0010;
        ram[10] <= 4'b0100;
        ram[11] <= 4'b0100;
        ram[12] <= 4'b1000;
        ram[13] <= 4'b1000;
        ram[14] <= 4'b0001;
        ram[15] <= 4'b0100;

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

endmodule