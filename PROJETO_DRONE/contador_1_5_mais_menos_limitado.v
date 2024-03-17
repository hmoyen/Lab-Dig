
module contador_1_5_mais_menos_limitado ( clock, clr, ld, soma, sub, enp, D, Q, rco);
    input clock, clr, ld, enp, soma, sub;
    input [2:0] D;
    output reg [2:0] Q;
    output reg rco;

    always @ (posedge clock)
        if (~clr)               Q <= 3'b000;
        else if (~ld)           Q <= D;
        else if (enp) begin
            if (soma == 1 && Q!=3'b101)        Q <= Q + 1;
            else if (sub == 1 && Q!=3'b001)     Q <= Q - 1;
        end
        else                    Q <= Q;
 
    always @ (Q or enp)
        if (enp && (Q == 3'b00))   rco = 1;
        else                       rco = 0;
endmodule