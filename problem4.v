module problem4(
	input x,
	input y,
	input cin,
	output s,
	output c);
	
	wire[3:0] mux1in, mux2in;
	wire[1:0] control;
	wire ncin;
	
	assign control = {x, y};
	
	not (ncin, cin);
	
	assign mux1in = {cin, ncin, ncin, cin};
	
	assign mux2in = {1'b1, cin, cin, 1'b0};
	
	Mux4To1 mux1(mux1in, control, s);
	Mux4To1 mux2(mux2in, control, c);
	
endmodule 

// Taken from class notes 
module Mux4To1(input[3:0] x, input[1:0] s, output y);
	
	reg y;
	always @(x, s)
	begin
		y = x[s];
	end
endmodule

module Test;

	reg x, y, cin;
	wire s, c;

	problem4 circuit(x, y, cin, s, c);

	initial begin

		$monitor("%d x=%b y=%b cin=%b, sum=%b, carry=%b", 
			$time,
			x, y, cin, s, c);

		#10 x = 0; y = 0; cin = 0;
		#10 x = 0; y = 0; cin = 1;
		#10 x = 0; y = 1; cin = 0;
		#10 x = 0; y = 1; cin = 1;
		#10 x = 1; y = 0; cin = 0;
		#10 x = 1; y = 0; cin = 1;
		#10 x = 1; y = 1; cin = 0;
		#10 x = 1; y = 1; cin = 1;
		
		#10 $finish; 

	end
endmodule