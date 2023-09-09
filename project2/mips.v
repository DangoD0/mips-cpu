`include "E:/project2/define_code.vh"
module mips(clk, rst) ;
input  clk ;
input  rst ;
wire alusrc,ext_sel,IRWr;
wire [1:0]npc_sel;
wire [31:0]imout,data1,data2,alunum_b,dmaddr,pc,aluout,dout_tmp,extended,npc,imtemp;
wire [31:0] dm_din,dout;
wire oflow;
wire [2:0]aluop;
reg [4:0]wrreg;
reg [31:0]wrdata;
wire bgt_flag_tmp;
wire [1:0]of_control;
wire oflow_late,PC_change_flag;
wire [31:0]dout_late,aluout_late;
controller controller(zero,clk,imout[31:26],imout[5:0],oflow,bgt_flag,aluop,memwrite, 
memtoreg,regwrite, alusrc,regdst, npc_sel,of_control,ext_sel,
lb_flag,sb_flag,sh_flag,PC_change_flag,IRWr,bgtz_flag);

assign extended=ext_sel?{{16{imout[15]}},imout[15:0]}:{16'b0,imout[15:0]};
assign alunum_b=alusrc?extended:data2;

assign dm_din = sb_flag?{dm.dm[aluout_late[9:0]+3],dm.dm[aluout_late[9:0]+2],
            dm.dm[aluout_late[9:0]+1],data2[7:0]}:sh_flag?{data2[15:0],
            dm.dm[aluout_late[9:0]+1],dm.dm[aluout_late[9:0]]}:data2;
assign dout = lb_flag?{{24{dout_tmp[7]}},dout_tmp[7:0]}:dout_tmp;

im_1k im(pc[9:0],imtemp);

InsReader IR(imtemp,IRWr,clk,imout);


registers GPR(clk,imout[25:21],imout[20:16],data1,data2,regwrite,wrreg,wrdata,rst,oflow_late,of_control);


dm_1k dm(aluout_late[9:0],dm_din,memwrite,clk,dout_tmp);
extraReg DR(clk,dout,dout_late);

alu alu(aluop,data1,alunum_b,aluout,zero,oflow,bgt_flag_tmp);
aluoutReg aluoutReg(clk,aluout,aluout_late,oflow,oflow_late,bgt_flag_tmp,bgt_flag);

npc NPC(PC_change_flag,npc_sel,zero,pc,imout,data1,npc,bgtz_flag,imout[31:26]);
PC_control PC_control(PC_change_flag,npc,clk,rst,pc);
always@(*)
begin
    if((imout[31:26]==`jal)) begin wrreg=5'b11111;wrdata=pc; end//jal
    else begin 
    wrreg=regdst?imout[15:11]:imout[20:16];
    wrdata=memtoreg?dout_late:aluout_late;
    end
end

endmodule