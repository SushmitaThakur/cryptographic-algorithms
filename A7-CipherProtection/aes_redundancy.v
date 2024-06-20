module aes_redundancy (    
    input wire clk,
    input wire rst_n,
    input wire [127:0] plaintext_in,
    input wire [127:0] key_in,
    output wire [127:0] ciphertext_out);

    wire [127:0] c1, c2, c3, parity_out;
    reg [127:0] parity_checked_out;    

    aes a1 (.clk(clk), .rst_n(rst_n), .plaintext_in(plaintext_in), .key_in(key_in), .ciphertext_out(c1));
    aes a2 (.clk(clk), .rst_n(rst_n), .plaintext_in(plaintext_in), .key_in(key_in), .ciphertext_out(c2));
    aes a3 (.clk(clk), .rst_n(rst_n), .plaintext_in(plaintext_in), .key_in(key_in), .ciphertext_out(c3));

  // Generate parity bit by XOR-ing the outputs of first two copies
    assign parity_out = c1 ^ c2;

    // Select output from copy with correct parity
    always @ * begin
        if ( parity_out == 0) 
            parity_checked_out = c1;
        else 
            parity_checked_out = c3;
    end 

    // if it is the last round, store the ciphertext 
    assign ciphertext_out =  parity_checked_out;

endmodule