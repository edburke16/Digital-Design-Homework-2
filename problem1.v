module problem1(
	input[7:0] a,
	input[7:0] b,
	output eq,
	output lt,
	output gt);

	wire c1e; 
	wire c1l;
	wire c1g;
	wire c2e;
	wire c2l;
	wire c2g;

	Comparator c1(a[3:0], b[3:0], c1e, c1l, c1g); 
	Comparator c2(a[7:4], b[7:4], c2e, c2l, c2g); 
	and (eq, c1e, c2e); 
	assign lt = (c2l | (c1l & c2e));
	assign gt = (c2g | (c1g & c2e));
endmodule 

// Comparator is borrowed from the course notes, as the instructions say we can 
module Comparator(
	input[3:0] a,
	input[3:0] b,
	output eq,
	output lt,
	output gt);

	wire[3:0] x;
	assign x = a ~^ b;
	assign eq = x[3] & x[2] & x[1] & x[0];
	assign lt = (~a[3] & b[3]) |
		(x[3] & ~a[2] & b[2]) |
		(x[3] & x[2] & ~a[1] & b[1]) |
		(x[3] & x[2] & x[1] & ~a[0] & b[0]);
	assign gt = (a[3] & ~b[3]) |
		(x[3] & a[2] & ~b[2]) |
		(x[3] & x[2] & a[1] & ~b[1]) |
		(x[3] & x[2] & x[1] & a[0] & ~b[0]);
endmodule

module Test;

	wire eq, lt, gt;
	reg[7:0] a, b; 

	problem1 circuit(a, b, eq, lt, gt);

	initial begin

		$monitor("%d a=%d b=%d eq=%b lt=%b gt=%b", 
			$time,
			a[7:0], b[7:0], eq, lt, gt);

		#10 a = 0; b = 0;
		#10 a = 45; b = 45;
		#10 a = 45; b = 30;
		#10 a = 30; b = 45;
		#10 a = 8'b00000000; b = 8'b00000000;
		#10 a = 8'b11111111; b = 8'b11111111;
		#10 a = 8'b11110000; b = 8'b00001111;
		#10 a = 8'b00001111; b = 8'b11110000;
		#10 $finish; 

	end
endmodule

/* 
Explanation: 
	First, I split the two inputs in half, sending the first halves through one 4-bit 
comparator, then I do the same with the second halves in the other 4-bit comparator. 
For the eq output, I simply AND the two eq outputs of the comparators. For the gt and lt 
outputs, I first check the output of the comparator checking bits [7:4], and if it is not 
equal I go with whichever it does return. If it is equal, I then check the output of the 
other comparator. 
*/