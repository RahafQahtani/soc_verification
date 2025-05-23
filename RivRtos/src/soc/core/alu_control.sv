module alu_control (
    input logic [2:0] fun3,
    input logic fun7_5,
    // additional signal added 
    input logic [6:0] fun7,
    input logic [1:0] alu_op,
    output alu_t alu_ctrl
);

// alu_op 00 for load/store
// alu_op 10 r-type
// alu_op 11 i-type 
// alu_op 01 for branches
parameter LOAD_STORE = 2'b00, R_TYPE = 2'b11, I_TYPE = 2'b01, B_TYPE = 2'b10;

always_comb begin 
    case(alu_op)
        R_TYPE: begin 
           alu_ctrl = alu_t'({fun7, fun3});
           //alu_ctrl = alu_t'({ fun7_5, fun3});
        end
        I_TYPE: begin 
        if (fun3 == 3'b001) begin
            alu_ctrl = alu_t'({fun7, fun3});
            end
        else if (fun3 == 3'b101 && fun7 == 7'b0110100) begin 
             alu_ctrl = alu_t'({fun7, fun3});
        end else if (fun3 == 3'b101) begin // This else if make the above one redundant 
            alu_ctrl =  alu_t'({1'b0, fun7[5], 5'b0, fun3});
        end else begin 
            alu_ctrl =  alu_t'({7'b0, fun3});
        end
        end
        LOAD_STORE: begin
            alu_ctrl = ADD; 
        end

        B_TYPE: begin 
            case(fun3[2:1])
                2'b00: alu_ctrl = SUB;
                2'b01: alu_ctrl = SUB;
                2'b10: alu_ctrl = SLT;
                2'b11: alu_ctrl = SLTU;
            endcase
        end
    endcase
end

endmodule : alu_control