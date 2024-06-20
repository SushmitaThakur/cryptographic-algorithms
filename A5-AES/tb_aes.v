`timescale 1 ns/10 ps  // time-unit = 1 ns, precision = 10 ps

module tb_aes;
  	reg clk;            // Clock signal
  	reg rst_n;          // Reset signal
	reg [127:0] plaintext, key;
	wire [127:0] ciphertext;

	localparam period = 20;
	// Parameters for simulation

	aes UUT (.clk(clk), .rst_n(rst_n), .plaintext_in(plaintext), .key_in(key), .ciphertext_out(ciphertext));
	
    // // Clock generation
    always #(period/2) clk = ~clk;

	// reset - old
	// initial begin 
	// 	#period;
	// 	rst_n = 1;
	// 	#(10*period);
	// 	rst_n = 0;
	// end

	// reset - new (updated after M's comment)
	initial begin 
		rst_n = 0;
		#(2*period);
		rst_n = 1;
	end

	initial begin
		
		$dumpfile("tb_aes_waves.vcd");
        $dumpvars(0, tb_aes);

		clk = 1'b1;
		// updated after M's comment
		// 	rst_n = 0;
		plaintext = 128'h11111111111111111111111111111111;
		key = 128'h3C4FCF098815F7ABA5D2AE2816157E2B;
		#(11*period);
		$monitor("ciphertext = %h", ciphertext);
		$finish();

	end
endmodule
