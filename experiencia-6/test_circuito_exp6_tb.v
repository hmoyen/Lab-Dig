module circuito_exp6_tb;

  reg [3:0] chaves_in;
  
  initial begin
    // Test case 1
    chaves_in = 4'b0010;
    #10;
    
    // Test case 2
    chaves_in = 4'b0100;
    #10;
    
    // Test case 3
    chaves_in = 4'b0100;
    #10;
    
    // Test case 4
    chaves_in = 4'b1000;
    #10;
    
    // Test case 5
    chaves_in = 4'b1000;
    #10;
    
    // Test case 6
    chaves_in = 4'b0001;
    #10;
    
    $finish;
  end
  
endmodule