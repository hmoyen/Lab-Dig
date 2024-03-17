
module contador_3_mais_menos ( clock, clr, ld, soma, sub, enp, D, Q, rco);
    input clock, clr, ld, enp, soma, sub;
    input [1:0] D;
    output reg [1:0] Q;
    output reg rco;

    always @ (posedge clock) begin
        if (~clr)               Q <= 2'b0;
        else if (~ld)           Q <= D;
        else if (enp) begin

            if (soma == 1) begin
                if (Q==2'b10)               Q <= 2'b0;
                else                        Q <= Q + 1;
            end 

            else if (sub == 1) begin
                if (Q==2'b00)               Q <= 2'b10;
                else                        Q <= Q - 1;
            end 

        end

        else  begin
            Q <= Q;
        end 

    end
    
 
    always @ (Q or enp)
        if (enp && (Q == 2'b00))   rco = 1;
        else                       rco = 0;
endmodule