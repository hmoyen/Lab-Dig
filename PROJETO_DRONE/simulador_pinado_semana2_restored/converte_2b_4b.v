module converte_2b_4b( 
    input  [1:0] posicao_2b,
    output [3:0] posicao_4b
);


assign posicao_4b = posicao_2b == 2'b00 ? 4'b0001 :
                    posicao_2b == 2'b01 ? 4'b0010 :
                    posicao_2b == 2'b10 ? 4'b0100 :
                    posicao_2b == 2'b11 ? 4'b1000 : 4'bxxxx; 


endmodule