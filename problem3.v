module problem3(
	input[3:0] x,
	output[3:0] y,
	input[1:0] index,
	input value);

	wire d0;
	wire d1;
	wire d2;
	wire d3;

	Decoder dec(index, d0, d1, d2, d3);
	Mux mux0(x[0], value, d0, y[0]);
	Mux mux1(x[1], value, d1, y[1]);
	Mux mux2(x[2], value, d2, y[2]);
	Mux mux3(x[3], value, d3, y[3]);

endmodule 

// Taken from class notes, modyfied to 2 bits and remove enable bit 
module Mux(input x0, input x1, input s, output y);
	
	reg y;
	always @(x0, x1, s)
	begin
		if (s == 0) 
			assign y = x0;
		if (s == 1) 
			assign y = x1;
	end
endmodule

// Taken from class notes, modyfied to remove enable bit 
module Decoder(input[1:0] x, output d0, output d1, output d2, output d3);
	
	assign d0 = ~x[1] & ~x[0];
	assign d1 = ~x[1] & x[0];
	assign d2 = x[1] & ~x[0];
	assign d3 = x[1] & x[0];
endmodule

module Test;

	reg[3:0] x;
	reg[1:0] index;
	reg value; 
	wire[3:0] y;

	problem3 circuit(x, y, index, value);

	initial begin

		$monitor("%d x=%b y=%b index=%b value=%b", 
			$time,
			x[3:0], y[3:0], index[1:0], value);

		#10 x = 4'b0000; index = 2'b00; value =1;
		#10 x = 4'b0000; index = 2'b01; value =1;
		#10 x = 4'b0000; index = 2'b10; value =1;
		#10 x = 4'b0000; index = 2'b11; value =1;
		#10 x = 4'b1111; index = 2'b00; value =0;
		#10 x = 4'b1111; index = 2'b01; value =0;
		#10 x = 4'b1111; index = 2'b10; value =0;
		#10 x = 4'b1111; index = 2'b11; value =0;
		#10 $finish; 

	end
endmodule
