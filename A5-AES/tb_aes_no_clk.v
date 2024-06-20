`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module tb_aes_no_clk;
	reg [127:0] plaintext, key;
	wire [127:0] ciphertext;

	localparam period = 20;  

	aes_no_clk UUT (.plaintext_in(plaintext), .key_in(key), .ciphertext_out(ciphertext));
    
	initial begin

		// Verify with - https://www.cryptool.org/en/cto/aes-step-by-step

		$monitor("plaintext = %h, \n key = %h, \n ciphertext = %h", plaintext, key, ciphertext);
		
		// #TC-1
		// plaintext = 128'h4871625abd5647289abc172469756abf;
		// key = 128'h0123456789abcdeffedcba9876543210;
		// #period;
		// expected output: 8bdbfc009c007692d296338a9821eb5c

		// #TC-2 
		plaintext = 128'h11111111111111111111111111111111;
		key = 128'h3C4FCF098815F7ABA5D2AE2816157E2B;
		#period;
		// Expected Ciphertext: a13c4dcf3859ff78076bda87fc1856b5 

	end
endmodule

