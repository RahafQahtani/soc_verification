import riscv_types::*;
module alu (
    input alu_t alu_ctrl,
    input logic [31:0] op1,
    input logic [31:0] op2,
    output logic [31:0] alu_result, 
    output logic zero
);


    logic [32:0] add_o, sub_o;

    assign add_o = op1 + op2;
    assign sub_o = op1 - op2;

    always_comb begin 
        case(alu_ctrl)
			ADD: alu_result = add_o[31:0];
            ROL_: alu_result = (op1 << op2[4:0]) | (op1 >> (32 - op2[4:0]));
            ROR_: alu_result = (op1 >> op2[4:0]) | (op1 << (32 - op2[4:0]));
            SUB: alu_result = sub_o[31:0];
      		SLT: alu_result = $signed(op1) < $signed(op2) ? 1'b1 : 1'b0;
	        SLL_: alu_result = op1 << op2[4:0];
            ANDN: alu_result = op1 & op2;
            ORN: alu_result = op1 | op2;
            XNORN: alu_result = op1 ^ op2;
            PACK: alu_result = {op2[15:0], op1[15:0]};
            PACKH: alu_result = {16'b0, op2[7:0], op1[7:0]};
            SRL_: alu_result = op1 >> op2[4:0];
            SRA_: alu_result = $signed(op1) >>> op2[4:0];
            XOR: alu_result = op1 ^ op2;
            AND_: alu_result = op1 & op2;
            OR: alu_result  = op1 | op2;
            SLTU: alu_result = {31'h0, {op1 < op2}};// TODO: modified to remove sg error
            default: alu_result = 32'd0;
        endcase
    end
    
    
    assign zero = (alu_result == 0);
endmodule