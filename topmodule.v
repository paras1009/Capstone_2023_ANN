module ANN(
	input clk, rst,
	input rst_sum,
	input ld_in, ld_weight, shift_in, change, ld_multiplication, 
	input ld_bias_LSB, ld_bias_MSB, bias_addition,
	input ReLU_computation,
	input ld_max_func,
	input [3:0]ld_neuron, // control signal from tb to decide the number of neuron
	input [15:0]in,
	output reg [3:0]number // final predicted digit
	
);

	integer i;
	reg [15:0]in_ff[31:0];
	reg [15:0]weight;
	reg [31:0]multiply_out, multiply_FF, bias, Y, X, sum;
	reg [31:0]ReLU_out[9:0]; // 10 ReLU result for 10 neurons, each of 32-bits

	reg [31:0]temp;

	// --------------------------------- Storing 32*16-bit inputs into the registers -----------------------------
	// Shift Register : Method-2
	//reg [15:0]in_ff1, in_ff2, in_ff3;
	
	always @ (posedge clk) begin
		if(rst) begin
			for (i = 0; i < 32; i = i + 1) begin
				in_ff[i] <= 16'b00000000000000000;
			end 
		end
		else if(ld_in) begin
			in_ff[0] <= in;
			for (i = 1; i < 32; i = i + 1) begin
				in_ff[i] <= in_ff[i-1];
			end
		end
	end	
	
	// --------------------------------- Weight load -----------------------------
	// Storing weight memory into registers
	always @ (posedge clk) begin
		if(rst) weight <= 16'bxxxxxxxxxxxxxxxx;
		else if(ld_weight) weight <= in; // at every clock cycle it will take different value from 'memory'
		else weight <= 16'bxxxxxxxxxxxxxxxx;		// as per the address values that we are incrementing.
	end	

	// --------------------------------- Bias load -----------------------------
	// Bias load for LSB 
	// Storing bias into registers
	always @ (posedge clk) begin
		if(rst) bias[15:0] <= 16'b0000000000000000;
		else if(ld_bias_LSB) bias[15:0] <= in; // at every clock cycle it will take different value from 'memory'
		else bias[15:0] <= bias[15:0];		// as per the address values that we are incrementing.
	end

	// Bias load for MSB
	// Storing bias into registers
	always @ (posedge clk) begin
		if(rst) bias[31:16] <= 16'b0000000000000000;
		else if(ld_bias_MSB) bias[31:16] <= in; // at every clock cycle it will take different value from 'memory'
		else bias[31:16] <= bias[31:16];		// as per the address values that we are incrementing.
	end

	/*wire [31:0]temp;
	assign temp = { {16{in_ff[0][15]}}, in_ff[0][15:0] };*/
	
	// ------------------- Shifting the value of inputs in the register at every clock cycle -----------------------------
	always @ (in or change) begin
		if(shift_in) begin
			in_ff[0] <= in_ff[2];
			for (i = 1; i < 32; i = i + 1) begin
				in_ff[i] <= in_ff[i-1];
			end
		end
	end
	// ---------------------------------------------------------------------------------------------------------------------

	// Block for Multiplication
	always @ (weight or rst or rst_sum) begin
		if(rst) multiply_out = 3'b000;  
	   else if(rst_sum == 1) multiply_out = 0;
		// at every clock cycle if input and weights are loaded then do the multiplication
		else if(ld_weight == 1) begin	
			multiply_out = { {16{in_ff[2][15]}}, in_ff[2][15:0] } * { {16{weight[15]}}, weight[15:0] };
		end
		//else multiply_out = multiply_out;
	end

	always @ (posedge clk) begin
		if(rst) begin
			multiply_FF <= 0;
		end
		else if(rst_sum == 1) multiply_FF <= 0;
		else multiply_FF <= multiply_out;
	end

	reg mux_sel, ldX, add_enable;

	// Multiplexer and Adder
	always @ (multiply_FF or bias) begin
		if(rst) Y = 0;
		else if(rst_sum == 1) Y = 0;
		else /*if(mux_sel == 0) begin*/ 
				Y = multiply_FF;
		//end
		/*else if (mux_sel)begin
			Y = bias;
		end
     	 else 
         Y = 0; */
	end 

	// Loading the value of 'X'
	always @ (posedge clk) begin
		if(rst) X <= 0;
		else if(rst_sum == 1) X <= 0;
		else if(ldX) X <= sum;
		else X <= X;
	end

	// Cummulative Adder
	always @ (*) begin
		if(rst) sum = 0;
		else if(rst_sum == 1) sum = 0;
		else if (add_enable) sum = Y + X;
		else sum = sum;
	end

	// bias addtion
	always @ (posedge clk) begin
		if(rst) sum = 0;
		else if(rst_sum == 1) sum = 0;
		if(bias_addition) begin
			sum = sum + bias;
		end
	end

	// --------------------------------------- ReLU_computation ----------------------------
	always @ (posedge clk) begin
		if(rst) begin
			for (i = 0; i < 32; i = i + 1) begin
				ReLU_out[i] <= 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
			end 
		end
		// N0: 
		else if((ReLU_computation == 1) && (ld_neuron == 4'b0000)) begin
			if(sum[31] == 1) ReLU_out[0] = 32'b00000000000000000000000000000000;
			else ReLU_out[0] = sum;
		end
		// N1: 
		else if((ReLU_computation == 1) && (ld_neuron == 4'b0001)) begin
			if(sum[31] == 1) ReLU_out[1] = 32'b00000000000000000000000000000000;
			else ReLU_out[1] = sum;
		end		
		// N2: 
		else if((ReLU_computation == 1) && (ld_neuron == 4'b0010)) begin
			if(sum[31] == 1) ReLU_out[2] = 32'b00000000000000000000000000000000;
			else ReLU_out[2] = sum;
		end	
		// N3: 
		else if((ReLU_computation == 1) && (ld_neuron == 4'b0011)) begin
			if(sum[31] == 1) ReLU_out[3] = 32'b00000000000000000000000000000000;
			else ReLU_out[3] = sum;
		end
		// N4: 
		else if((ReLU_computation == 1) && (ld_neuron == 4'b0100)) begin
			if(sum[31] == 1) ReLU_out[4] = 32'b00000000000000000000000000000000;
			else ReLU_out[4] = sum;
		end
		// N5: 
		else if((ReLU_computation == 1) && (ld_neuron == 4'b0101)) begin
			if(sum[31] == 1) ReLU_out[5] = 32'b00000000000000000000000000000000;
			else ReLU_out[5] = sum;
		end
		// N6: 
		else if((ReLU_computation == 1) && (ld_neuron == 4'b0110)) begin
			if(sum[31] == 1) ReLU_out[6] = 32'b00000000000000000000000000000000;
			else ReLU_out[6] = sum;
		end
		// N7: 
		else if((ReLU_computation == 1) && (ld_neuron == 4'b0111)) begin
			if(sum[31] == 1) ReLU_out[7] = 32'b00000000000000000000000000000000;
			else ReLU_out[7] = sum;
		end
		// N8: 
		else if((ReLU_computation == 1) && (ld_neuron == 4'b1000)) begin
			if(sum[31] == 1) ReLU_out[8] = 32'b00000000000000000000000000000000;
			else ReLU_out[8] = sum;
		end
		// N9: 
		else if((ReLU_computation == 1) && (ld_neuron == 4'b1001)) begin
			if(sum[31] == 1) ReLU_out[9] = 32'b00000000000000000000000000000000;
			else ReLU_out[9] = sum;
		end

	end
		
	// ------------------------------- Max function computation ---------------------------------
	always @ (posedge clk) begin
		if(rst) number <= 4'bx;
		else if(ld_max_func) begin
			  
				// 0th
				 temp = ReLU_out[0];
				 number = 4'b0000;
		
			// 1st
			 if (ReLU_out[1][30:20] > temp[30:20]) begin
				temp = ReLU_out[1];
				number = 4'b0001;
			 end
			else if (ReLU_out[1][30:20] == temp[30:20]) begin
				if (ReLU_out[1][19:0] > temp[19:0]) begin
					temp = ReLU_out[1];
					number = 4'b0001;
				end
			end

			// 2nd
			 if (ReLU_out[2][30:20] > temp[30:20]) begin
				temp = ReLU_out[2];
				number = 4'b0010;
			 end
			else if (ReLU_out[2][30:20] == temp[30:20]) begin
				if (ReLU_out[2][19:0] > temp[19:0]) begin
					temp = ReLU_out[2];
					number = 4'b0010;
				end
			end

			// 3rd
			 if (ReLU_out[3][30:20] > temp[30:20]) begin
				temp = ReLU_out[3];
				number = 4'b0011;
			 end
			else if (ReLU_out[3][30:20] == temp[30:20]) begin
				if (ReLU_out[3][19:0] > temp[19:0]) begin
					temp = ReLU_out[3];
					number = 4'b0011;
				end
			end

			// 4th
			 if (ReLU_out[4][30:20] > temp[30:20]) begin
				temp = ReLU_out[4];
				number = 4'b0100;
			 end
			else if (ReLU_out[4][30:20] == temp[30:20]) begin
				if (ReLU_out[4][19:0] > temp[19:0]) begin
					temp = ReLU_out[4];
					number = 4'b0100;
				end
			end

			// 5th
			 if (ReLU_out[5][30:20] > temp[30:20]) begin
				temp = ReLU_out[5];
				number = 4'b0101;
			 end
			else if (ReLU_out[5][30:20] == temp[30:20]) begin
				if (ReLU_out[5][19:0] > temp[19:0]) begin
					temp = ReLU_out[5];
					number = 4'b0101;
				end
			end

			// 6th
			 if (ReLU_out[6][30:20] > temp[30:20]) begin
				temp = ReLU_out[6];
				number = 4'b0110;
			 end
			else if (ReLU_out[6][30:20] == temp[30:20]) begin
				if (ReLU_out[6][19:0] > temp[19:0]) begin
					temp = ReLU_out[6];
					number = 4'b0110;
				end
			end

			// 7th
			 if (ReLU_out[7][30:20] > temp[30:20]) begin
				temp = ReLU_out[7];
				number = 4'b0111;
			 end
			else if (ReLU_out[7][30:20] == temp[30:20]) begin
				if (ReLU_out[7][19:0] > temp[19:0]) begin
					temp = ReLU_out[7];
					number = 4'b0111;
				end
			end

			// 8th
			 if (ReLU_out[8][30:20] > temp[30:20]) begin
				temp = ReLU_out[8];
				number = 4'b1000;
			 end
			else if (ReLU_out[8][30:20] == temp[30:20]) begin
				if (ReLU_out[8][19:0] > temp[19:0]) begin
					temp = ReLU_out[8];
					number = 4'b1000;
				end
			end

			// 9th
			 if (ReLU_out[9][30:20] > temp[30:20]) begin
				temp = ReLU_out[9];
				number = 4'b1001;
			 end
			else if (ReLU_out[9][30:20] == temp[30:20]) begin
				if (ReLU_out[9][19:0] > temp[19:0]) begin
					temp = ReLU_out[9];
					number = 4'b1001;
				end
			end
			 

		end
		else number <= 1'bx;
	end
		


	// -------------------------------- FSM for cummulative addition ------------------------------------
	reg [3:0] state, next_state;
	parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011;

	always @ (posedge clk) state <= next_state;

	always @ (*) begin
		next_state = 4'bxxxx;

		case(state) 
		S0: begin
			// initializing every control signal with '0'
			add_enable = 0; /*mux_sel = 0;*/ ldX = 0;
			if(ld_multiplication) next_state = S1;
			else next_state = S0;
		    end
		S1: begin
			// Adder
			add_enable = 1; /*mux_sel = 0;*/ ldX = 0;
			next_state = S2;
		     end
		S2: begin
			 // Storing sum values in X
			 add_enable = 0; /*mux_sel = 0;*/ ldX = 1;
			 if (!shift_in) next_state = S3;
			 else next_state = S1;
			 end		
		S3: begin
			// stop doing the addition
			ldX = 0;
			next_state = S0; 
	 	    end
		default: next_state = S0;

		endcase
	end
	// ---------------------------------------------------------------------------------------------------------------------


endmodule


