`include "fourbitalu.v"
`include "ripplescaler.v"
`include "buttonpressdetector.v"

module FourBitCPU( 
	input wire			step		/* synthesis loc="P31"				*/,
	input wire			reset_n		/* synthesis loc="P32"				*/,
	input wire 			oneMHzClock /* synthesis loc="P18"				*/,
	output reg	[3:0]	a_reg		/* synthesis loc="P48,P47,P46,P45"	*/,
	output reg	[3:0]	b_reg		/* synthesis loc="P4,P3,P2,P40"		*/,
	output reg 			zf			/* synthesis loc="P38"				*/,
	output reg			cf			/* synthesis loc="P39"				*/,
	output reg	[2:0] 	pc			/* synthesis loc="P26,P27,P28" 		*/,
	output wire 		use_a_reg	/* synthesis loc="P10"				*/
);

	`include "cpu_opcodes.v"

	wire debouncedStep;

	wire [3:0] alu_c;
	wire alu_zf;
	wire alu_cf;

	wire [8:0] program [0:7];
	
	assign program[0] = { OP_LD_A, 	4'b0100 };
	assign program[1] = { OP_LD_B, 	4'b0011 };
	assign program[2] = { OP_DEC_B,	4'bxxxx };
	assign program[3] = { OP_JC,	4'b0110 };
	assign program[4] = { OP_INC_A,	4'bxxxx };
	assign program[5] = { OP_JMP,	4'b0010 };
	assign program[6] = { OP_LD_B,	4'b0000 };
	assign program[7] = { OP_JMP,	4'b0001 };
	
	wire [8:0] statement = program[pc];
	wire [4:0] opcode 	= statement[8:4];
	wire [3:0] arg  	= statement[3:0];
	
	RippleScaler #(.BITS(10)) u0rs (
		.inclock(oneMHzClock),
		.outclock(oneKHzClock)
	);
	
	ButtonPressDetector u1pbd (
		.buttonDown(~step),
		.ackPress(1'b1),
		.clock(oneKHzClock),
		.wasPressed(debouncedStep)
	);
	
	assign use_a_reg = (opcode[4:3] === 'b10);
	wire [3:0] a_or_b_reg = use_a_reg ? a_reg : b_reg;
	
	FourBitALU u2alu (
		.opcode(opcode),
		.a(a_or_b_reg),
		.b(b_reg),
		.c(alu_c),
		.zf(alu_zf),
		.cf(alu_cf)
	);	
	
	reg inc_pc;

	always @(negedge reset_n, posedge debouncedStep)
	
		if (!reset_n)

			begin
				pc 		<= 	3'b000;
				a_reg 	<= 	4'b0000;
				b_reg 	<= 	4'b0000;
				zf 		<= 	1'b0;
				cf 		<= 	1'b0;
			end

		else 
	
			begin: opcodeHandler
			
				inc_pc = 1'b1;
				
				casez (opcode) // synthesis full_case

					5'b10???:		begin
										a_reg 	<= alu_c;
										zf 		<= alu_zf;
										cf 		<= alu_cf;
									end

					5'b11???:		begin
										b_reg 	<= alu_c;
										zf 		<= alu_zf;
										cf 		<= alu_cf;
									end
				
					OP_JMP:			begin
										pc <= arg;
										inc_pc = 1'b0;
									end
					
					OP_JZ:			if (zf)	begin
										pc <= arg;
										inc_pc = 1'b0;
									end
									
					OP_JNZ:			if (!zf) begin
										pc <= arg;
										inc_pc = 1'b0;
									end

					OP_JC:			if (cf)	begin
										pc <= arg;
										inc_pc = 1'b0;
									end
									
					OP_JNC:			if (!cf) begin
										pc <= arg;
										inc_pc = 1'b0;
									end
									
				 	OP_LD_A:		a_reg <= arg;

					OP_LD_B:		b_reg <= arg;
					
				endcase

				if (inc_pc) 
					pc <= pc + 1;

			end	
endmodule

