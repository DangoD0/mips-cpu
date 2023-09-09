`include "E:/project1/define_code.vh"
module controller(
		input [5:0]	opcode,funct,
		output reg [2:0]aluop,
		output reg	memwrite, memtoreg,
		output reg	regdst, regwrite, alusrc,
		output reg	[1:0]npc_sel,
		output reg of_control,
		output reg ext_sel,
		//output reg lb_flag
		);

	always @(*) begin
		aluop	= 3'b000;//000:add 001:or 010:slt 011:sub 100:lui
		alusrc		= 1'b0;//1:imme 0:rs
		memtoreg	= 1'b0;
		ext_sel = 1'b1;//1:sign ext 0:zero ext
		memwrite	= 1'b0;//memwrite EN
		regdst		= 1'b1;//1:rd 0:rt
		regwrite	= 1'b1;//regwrite EN
		npc_sel = 2'b00;//00:+4,01:beq,10:j/jal,11:jr
		of_control =1'b0;//overflow control
		//lb_flag = 1'b0;
		case (opcode)
			`lw: begin
				regdst   = 1'b0;
				memtoreg = 1'b1;
				alusrc   = 1'b1;
			end
			`lb: begin
				regdst   = 1'b0;
				memtoreg = 1'b1;
				alusrc   = 1'b1;
				//lb_flag = 1'b1;
			end
			`addi: begin
				regdst   = 1'b0;
				alusrc   = 1'b1;
				of_control =1'b1;
			end
			`addiu: begin
				regdst   = 1'b0;
				alusrc   = 1'b1;
				ext_sel = 1'b0;
			end
			`beq: begin
				aluop  = 3'b011;
				npc_sel = 2'b01;
				regwrite  = 1'b0;
			end
			`sw: begin	
				memwrite = 1'b1;
				alusrc   = 1'b1;
				regwrite = 1'b0;
			end
			`lui: begin 
			  aluop  = 3'b100;
			  regwrite=1'b1;
			  regdst=1'b0;
			  alusrc=1'b1;
		  end
			`j: begin	
				npc_sel = 2'b10;
				regwrite  = 1'b0;
			end
			`jal: begin	
				npc_sel = 2'b10;
			end
			`ori: begin	
				regdst = 1'b0;
				alusrc = 1'b1;
				aluop = 3'b001;
				ext_sel = 1'b0;
			end
			6'b000000: begin
			  case(funct)
			     `addu:begin
			      end
			     `subu:begin
			       aluop = 3'b011;
			       end
			     `jr:begin
			       regwrite = 1'b0;
			       npc_sel = 2'b11;
			       end
			     `slt:begin
				    alusrc = 1'b1;
			     	aluop=3'b010;
			      end
		     endcase
	   end
	endcase
	end
endmodule
