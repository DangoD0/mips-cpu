module PC_control(	
			input PC_change_flag,	 
			input [31:0] npc,
			input clk,
			input rst,
			output reg [31:0]pc
		);
	initial
		begin
			pc <= 32'h0000_3000;
		end
	always@(posedge clk, posedge rst)
		begin
			if(PC_change_flag)
				begin
					if(rst) pc <= 32'h0000_3000;
					else pc <= npc;
				end
		end
endmodule