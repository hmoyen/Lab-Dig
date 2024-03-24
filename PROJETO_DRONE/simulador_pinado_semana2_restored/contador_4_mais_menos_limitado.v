
module contador_4_mais_menos_limitado ( clock, clr, ld, soma, sub, enp, D, Q, rco);
    input clock, clr, ld, enp, soma, sub;
    input [1:0] D;
    output reg [1:0] Q;
    output reg rco;

    always @ (posedge clock)
        if (~clr)               Q <= 2'b0;
        else if (~ld)           Q <= D;
        else if (enp) begin
            if (soma == 1 && Q!=2'b11)        Q <= Q + 1;
            else if (sub == 1 && Q!=2'b00)     Q <= Q - 1;
        end
        else                    Q <= Q;
 
    always @ (Q or enp)
        if (enp && (Q == 2'b00))   rco = 1;
        else                       rco = 0;
endmodule