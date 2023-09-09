
module registers(clk,read1,read2,data1,data2,regwrite,wrreg,wrdata,rst,overflow_flag,of_control);
	input clk,rst,overflow_flag;
	input [1:0]of_control;
	input [4:0]	read1, read2;
	output [31:0] data1, data2;
	input regwrite;
	input [4:0]wrreg;
	input [31:0]wrdata;
	reg [31:0]memory[0:31];
	reg [31:0]_data1,_data2;
	integer i;
	
	initial begin
		for(i=0;i<32;i=i+1)
			if(i != 28 && i != 29)
				memory[i] = 0;
		memory[28] = 32'h00001800;
		memory[29] = 32'h00002ffc;
	end
	
	always @(posedge rst)
	begin
		if(rst) 
		begin
			for(i=0;i<32;i=i+1)
				if(i != 28 && i != 29)
					memory[i] <= 0;
			memory[28] <= 32'h00001800;
			memory[29] <= 32'h00002ffc;
	   	end
	end
	
	always @(*) begin		
	 	if (read1 == 5'd0)
			_data1 = 32'd0;
		else if ((read1 == wrreg) && regwrite)
			_data1 = wrdata;
		else
			_data1 = memory[read1][31:0];
			
		if (read2 == 5'd0)
			_data2 = 32'd0;
		else if ((read2 == wrreg) && regwrite)
			_data2 = wrdata;
		else
			_data2 = memory[read2][31:0];
	end
	
	assign data1=_data1;
	assign data2=_data2;
	
	always@(posedge clk)begin
		if (regwrite && wrreg != 5'd0 && of_control != 2'b11)begin
			memory[wrreg] <= wrdata;
		end
		else if(of_control == 2'b11)
			$display("overflow error!");
			
		if(of_control[1] && wrreg!=5'b0)
		  	memory[30][0] <= of_control[0];

	end
endmodule