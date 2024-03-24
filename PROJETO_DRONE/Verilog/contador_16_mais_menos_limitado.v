
module contador_16_mais_menos_limitado ( clock, clr, ld, soma, sub, enp, D, Q, rco);
    input clock, clr, ld, enp, soma, sub;
    input [3:0] D;
    output reg [3:0] Q;
    output reg rco;

    always @ (posedge clock)
        if (~clr)               Q <= 4'b0;
        else if (~ld)           Q <= D;
        else if (enp) begin
            if (soma == 1 && Q!=4'b1111)        Q <= Q + 1;
            else if (sub == 1 && Q!=4'b0000)     Q <= Q - 1;
        end
        else                    Q <= Q;
 
    always @ (Q or enp)
        if (enp && (Q == 4'b0000))   rco = 1;
        else                       rco = 0;
endmodule