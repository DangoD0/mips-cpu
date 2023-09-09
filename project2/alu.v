module alu(aluop,a,b,out,zero,oflow,bgt_flag_tmp);
		input		[2:0]	aluop;
		input		[31:0]	a, b;
		output reg	[31:0]	out;
		output	bgt_flag_tmp;
		output zero;
    output oflow;
	wire [31:0] sub_ab;
	wire [31:0] add_ab;
	wire 		oflow_add;
	wire 		oflow;
	wire 		slt;

	assign zero = (out == 0);

	assign sub_ab = a - b;
	assign add_ab = a + b;

	assign oflow_add = (a[31] == b[31] && add_ab[31] != a[31]) ? 1 : 0;

	assign oflow = (aluop == 3'b000) ? oflow_add : 0;
	assign bgt_flag_tmp = (a > 0) ? 1 : 0;
  
	always @(*) begin
		case (aluop)//000:add 001:or 010:stl 011:sub 100:lui
			3'd0:  out <= add_ab;				/* add */
			3'd1:  out <= a | b;				/* or */
			3'd2:  out <= ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;	/* slt */
			3'd3:  out <= sub_ab;				/* sub */
			3'd4:  out <= {b[15:0],16'b0};
			default: 
			begin
				//out <= 0;
				$display("no use sel for aluop");

			end
		endcase
	end

endmodule