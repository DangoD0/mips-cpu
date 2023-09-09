`include "E:/project2/define_code.vh"
module controller(
		input zero,
    	input clk,
		input [5:0]	opcode,funct,
		input of_flag,bgt_flag,
		output reg [2:0]aluop,
		output reg	memwrite, memtoreg,
		output reg	regwrite, alusrc,regdst,
		output reg [1:0]npc_sel,
		output reg [1:0]of_control,
		output reg ext_sel,
		output reg lb_flag,
		output reg sb_flag,
		output reg sh_flag,
		output reg PC_change_flag,
		output reg IRWr,
		output reg bgtz_flag
		);
	reg of_wire_flag,bgtz_wire_flag;
	reg [2:0]state,next_state;//000:if 001:dcd/rf 010:exe 011:mem 100:wb	  
	//reg firstflag=0;
	initial begin
		aluop	= 3'b000;//000:add 001:or 010:slt 011:sub 100:lui
		alusrc		= 1'b0;//1:imme 0:rs
		memtoreg	= 1'b0;
		ext_sel = 1'b0;//1:sign ext 0:zero ext
		memwrite	= 1'b0;//memwrite EN
		regdst		= 1'b0;//1:rd 0:rt
		regwrite	= 1'b0;//regwrite EN
		npc_sel = 2'b00;//00:+4,01:beq,10:j/jal,11:jr
		of_control =2'b0;//overflow control
		lb_flag = 1'b0;
		sb_flag = 1'b0;
	  	PC_change_flag = 1'b0;
	  	state = 3'b000;
	  end
	always @(posedge clk) 
		begin
			state <= next_state;
		end
	
	always @(state or opcode or funct) begin
		case(state)
			3'b000: //if
				begin
					next_state = 3'b001;
				end
				
			3'b001: //rf
				begin
					case (opcode)
						`j:
							begin
								next_state = 3'b000;						
							end
						`jal:
							begin
								next_state = 3'b100;				
							end
						`bgtz:
							begin
								next_state = 3'b010;				
							end
						6'b000000://R-type
							begin
								if(funct == `jr) 
									begin
										next_state = 3'b000;	
									end
								else 
									begin
										next_state = 3'b010;				
									end
							end
						default: 
							begin
								next_state = 3'b010; //I-type
							end
					endcase
				end
				
			3'b010: //exe
				begin
					case (opcode)
						`beq: 
							begin
								next_state = 3'b000;				
							end
						`bgtz:
							begin
								next_state = 3'b000;				
							end
						`lw: 
							begin
								next_state = 3'b011;			 
							end
						`sw: 
							begin
								next_state = 3'b011;				
							end
						`lb: 
							begin
								next_state = 3'b011;			 	
							end
						`sb: 
							begin
								next_state = 3'b011;				
							end
						`sh:
							begin
								next_state = 3'b011;	
							end
						default:                             //without dm
							begin 
								next_state = 3'b100; 				
							end
					endcase
				end
			
			3'b011://mem
				begin
					if(opcode == `lw || opcode == `lb)
						begin
							next_state = 3'b100;						//lw lb
						end
					else 
						begin
							next_state = 3'b000;						//sw sb
						end			
				end
				
			3'b100: //wb
				begin
				  	//firstflag=1;
					next_state = 3'b000;
				end
				
		endcase
		
	end	
		
	//ctrl signals
	always @(*) 
	begin
	//state1
	  	//IRWr
		if (state == 3'b000)IRWr = 1;
		else IRWr = 0;
			
		//PC_Wr
		//if(firstflag)
		if (state == 3'b000)PC_change_flag = 1;
		else PC_change_flag = 0;
		if((state == 3'b100 && opcode==`jal) || (state == 3'b001 && opcode == 6'b000000 && funct == `jr)) 
			PC_change_flag = 1;
		if((state == 3'b010 && opcode == `bgtz)) PC_change_flag=bgtz_flag;
		if(state == 3'b010 && opcode == `beq) PC_change_flag=zero;
		if(state == 3'b001 && opcode == `j) PC_change_flag=1;
			
	//state2
		//npc_sel
		if ((state == 3'b001)&&opcode==`j) npc_sel=2'b10;
		else if ((state == 3'b010||state==3'b001) && opcode == `beq) npc_sel=2'b01;
		else if ((state == 3'b001 || state == 3'b100)&&opcode==`jal) npc_sel=2'b10;
		else if((state == 3'b001 || state == 3'b010)&&opcode==`bgtz&&bgtz_flag) npc_sel=2'b01;
		else if (opcode == 6'b000000 && funct == `jr && (state == 3'b001||state == 3'b000))  npc_sel=2'b11;
		else npc_sel=2'b00;
		
	//state3
		//aluop,000:add,001:or,010:slt,011:sub,100:lui
		if (state == 3'b010)
			begin
				if (opcode == 6'b000000 && funct == `addu) aluop = 3'b000;
				else if (opcode == 6'b000000 && funct == `subu) aluop = 3'b011;
				else if (opcode == `beq) aluop=3'b011;
				else if (opcode == 6'b000000 && funct == `slt) aluop = 3'b010;
				else if (opcode == `ori) aluop = 3'b001;
				else if (opcode == `lw || opcode == `sw || opcode == `addi || opcode == `addiu 
				|| opcode == `lb || opcode == `sb || opcode == `sh)  aluop = 3'b000;
				else if (opcode == `lui)  aluop = 3'b100;
				else aluop = 3'b111;
			end
		else if(state==3'b011 && (opcode == `lw || opcode == `sw 
		||opcode == `lb || opcode == `sb || opcode == `sh)) aluop=3'b000;
		else aluop = 3'b111;
		
		//alusrc
		if (state == 3'b010)
			begin
				if(opcode == 6'b000000 && (funct == `addu || funct == `subu || funct == `slt)) alusrc = 0;
				else if(opcode == `ori || opcode == `lw || opcode == `sw || opcode == `lui 
				|| opcode == `addi || opcode == `addiu || opcode == `lb || opcode == `sb || opcode == `sh) alusrc = 1;
				else alusrc = 0;
			end
		else if(state == 3'b100 && funct == `ori) alusrc = 1;//special state
		else if(state == 3'b011 && (opcode == `lw || opcode == `sw ||opcode == `lb || opcode == `sb || opcode == `sh)) alusrc = 1;
		else alusrc = 0;
			
		//ext_sel
		if (state == 3'b010 &&(opcode == `ori||opcode == `addiu)) ext_sel = 1'b0;
		else ext_sel = 1'b1;
		
	//state4
	
		//sb_flag
		if (state == 3'b011 && opcode == `sb) sb_flag = 1;
		else sb_flag = 0;
		//sh_flag
		if(state == 3'b011 && opcode == `sh) sh_flag = 1;
		else sh_flag = 0;
		//lb_flag
		if (state == 3'b011 && opcode == `lb) lb_flag = 1;
		else lb_flag = 0;
			
		//memwrite
		if (state == 3'b011 && (opcode == `sw || opcode == `sb || opcode == `sh)) memwrite = 1;
		else memwrite = 0;
		
		
	//state5
		
		//regdst
		if (state == 3'b100)
			begin
				if(opcode==`lw||opcode==`lb||opcode==`addi||opcode==`addiu||opcode==`lui
					||opcode==`ori) regdst=1'b0;//I-type except sw,sb,beq
				else regdst = 1'b1;
			end
		else regdst = 1'b1;
		
		//memtoreg
		if(state == 3'b100)
			begin
				if(opcode == `lw||opcode == `lb) memtoreg = 1'b1;
				else memtoreg = 1'b0;
			end
		else memtoreg = 1'b0;
			
		//regwrite
		if (state == 3'b100)
			regwrite = 1'b1;
		else regwrite = 1'b0;
			
		//of_control
		if (state == 3'b010)
			of_wire_flag=of_flag;
		if (state == 3'b100 && opcode==`addi && of_wire_flag)
			of_control = 2'b11;
		//else if (state == 3'b100 && opcode==`addi && !of_wire_flag)
			//of_control = 2'b10;
		else of_control = 2'b0;
		
		if((state == 3'b001||state == 3'b010) && bgt_flag==1)
			bgtz_wire_flag=1;
		else bgtz_wire_flag=0;
		if ((state == 3'b001 || state == 3'b010) && opcode==`bgtz && bgtz_wire_flag)
			bgtz_flag =1;
		else bgtz_flag = 0;  
		
	end
endmodule