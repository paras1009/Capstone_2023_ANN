module testbench;
	reg clk, rst;
	reg rst_sum;
	reg ld_in, ld_weight, shift_in, change, ld_multiplication;
	reg ld_bias_LSB, ld_bias_MSB, bias_addition;
	reg ReLU_computation;
	reg ld_max_func;
	reg [15:0]in;
	reg [3:0]ld_neuron;
	
	reg fetch_weight;

	integer i;

	ANN ann(
	.clk(clk), .rst(rst), .rst_sum(rst_sum),
	.ld_in(ld_in), .ld_weight(ld_weight), .shift_in(shift_in), .change(change), .ld_multiplication(ld_multiplication), 
	.ld_bias_LSB(ld_bias_LSB), .ld_bias_MSB(ld_bias_MSB), .bias_addition(bias_addition),
	.ReLU_computation(ReLU_computation),
	.ld_max_func(ld_max_func),
	.ld_neuron(ld_neuron),
	.in(in)
	);

	// intantiating all the memories
	wire [15:0]w_l2_0, w_l2_1, w_l2_2, w_l2_3, w_l2_4, w_l2_5, w_l2_6, w_l7_0, w_l2_8, w_l2_9;
	neuron_memory_16 #(.dataFile("w_l2_0.txt")) W0(.rst(rst), .clk(clk), .read_en(fetch_weight), .data_out(w_l2_0));
	neuron_memory_16 #(.dataFile("w_l2_1.txt")) W1(.rst(rst), .clk(clk), .read_en(fetch_weight), .data_out(w_l2_1));
	neuron_memory_16 #(.dataFile("w_l2_2.txt")) W2(.rst(rst), .clk(clk), .read_en(fetch_weight), .data_out(w_l2_2));
	neuron_memory_16 #(.dataFile("w_l2_3.txt")) W3(.rst(rst), .clk(clk), .read_en(fetch_weight), .data_out(w_l2_3));
	neuron_memory_16 #(.dataFile("w_l2_4.txt")) W4(.rst(rst), .clk(clk), .read_en(fetch_weight), .data_out(w_l2_4));
	neuron_memory_16 #(.dataFile("w_l2_5.txt")) W5(.rst(rst), .clk(clk), .read_en(fetch_weight), .data_out(w_l2_5));
	neuron_memory_16 #(.dataFile("w_l2_6.txt")) W6(.rst(rst), .clk(clk), .read_en(fetch_weight), .data_out(w_l2_6));
	neuron_memory_16 #(.dataFile("w_l2_7.txt")) W7(.rst(rst), .clk(clk), .read_en(fetch_weight), .data_out(w_l2_7));
	neuron_memory_16 #(.dataFile("w_l2_8.txt")) W8(.rst(rst), .clk(clk), .read_en(fetch_weight), .data_out(w_l2_8));
	neuron_memory_16 #(.dataFile("w_l2_9.txt")) W9(.rst(rst), .clk(clk), .read_en(fetch_weight), .data_out(w_l2_9));

	wire [15:0]inputs;
	neuron_memory_16 #(.dataFile("input_2.txt")) IN(.rst(rst), .clk(clk), .read_en(fetch_weight), .data_out(inputs));

	// making memory arrays
	reg [15:0]input_array[31:0];
	reg [15:0]weight_memory_0[31:0];
	reg [15:0]weight_memory_1[31:0];
	reg [15:0]weight_memory_2[31:0];
	reg [15:0]weight_memory_3[31:0];
	reg [15:0]weight_memory_4[31:0];
	reg [15:0]weight_memory_5[31:0];
	reg [15:0]weight_memory_6[31:0];
	reg [15:0]weight_memory_7[31:0];
	reg [15:0]weight_memory_8[31:0];
	reg [15:0]weight_memory_9[31:0];
	

	initial begin
		clk = 1;	
 		forever #5 clk = ~clk;
	end	

	initial begin
		$dumpfile("testbench.vcd");
		$dumpvars(0, testbench);

	end

	initial begin 
		
		#3 rst = 1;
		#20 rst = 0;
		#10 fetch_weight = 1;
	   for(i = 0; i < 32; i= i + 1) begin 
			#10 input_array[i] = inputs;
		end
		#0 fetch_weight = 0;
		#10 fetch_weight = 1;
	   for(i = 0; i < 32; i= i + 1) begin 
				#10 weight_memory_0[i] = w_l2_0;
		end
		#0 fetch_weight = 0;
		#10 fetch_weight = 1;
	   for(i = 0; i < 32; i= i + 1) begin 
				#10 weight_memory_1[i] = w_l2_1;
		end
		#0 fetch_weight = 0;
		#10 fetch_weight = 1;
	   for(i = 0; i < 32; i= i + 1) begin 
				#10 weight_memory_2[i] = w_l2_2;
		end
		#0 fetch_weight = 0;
		#10 fetch_weight = 1;
	   for(i = 0; i < 32; i= i + 1) begin 
				#10 weight_memory_3[i] = w_l2_3;
		end
		#0 fetch_weight = 0;
		#10 fetch_weight = 1;
	   for(i = 0; i < 32; i= i + 1) begin 
				#10 weight_memory_4[i] = w_l2_4;
		end
		#0 fetch_weight = 0;
		#10 fetch_weight = 1;
	   for(i = 0; i < 32; i= i + 1) begin 
				#10 weight_memory_5[i] = w_l2_5;
		end
		#0 fetch_weight = 0;
		#10 fetch_weight = 1;
	   for(i = 0; i < 32; i= i + 1) begin 
				#10 weight_memory_6[i] = w_l2_6;
		end
		#0 fetch_weight = 0;
		#10 fetch_weight = 1;
	   for(i = 0; i < 32; i= i + 1) begin 
				#10 weight_memory_7[i] = w_l2_7;
		end
		#0 fetch_weight = 0;
		#10 fetch_weight = 1;
	   for(i = 0; i < 32; i= i + 1) begin 
				#10 weight_memory_8[i] = w_l2_8;
		end
		#0 fetch_weight = 0;
		#10 fetch_weight = 1;
	   for(i = 0; i < 32; i= i + 1) begin 
				#10 weight_memory_9[i] = w_l2_9;
		end
		#0 fetch_weight = 0;
	


		//------------------------------ Inputs -----------------------------------
		#10 ld_in = 1; // start giving inputs and storing it in shift register
		/*	 in = 16'b0000000000000001;
		#10 in = 16'b0000000000000010;
		#10 in = 16'b0000000000000011; // give more weights after this
		*/
		for(i = 0; i < 32; i = i + 1) begin
			#10 in = input_array[i];
		end

		#10 ld_in = 0;

		// --------------- For Neuron : N0
		#0 ld_weight = 1;
		    ld_neuron = 4'b0000;
			 ld_multiplication = 1; change = 0;
			 // weights
		#0	 in = weight_memory_0[0];   // adder takes two clock cycle to do the addition
		#20 shift_in = 1;
		    in = weight_memory_0[1];
		/*#20 in = 16'b0000000000000011;*/
		for(i = 2; i < 32; i = i + 1) begin
			#20 in = weight_memory_0[i];
		end
		#30 change = 1; // extra signal for shifting of last signal
		#0  shift_in = 0;
			 ld_weight = 0;
			 ld_multiplication = 0;
		#10 ld_bias_LSB = 1;
			 in = 16'b0101101000000000;
		#10 ld_bias_LSB = 0; 
			 ld_bias_MSB = 1;
			 in = 16'b1111111111111011;
		#10 ld_bias_MSB = 0; bias_addition = 1;
		#10 bias_addition = 0;
		#10 ReLU_computation = 1;
		#10 ReLU_computation = 0;
		    rst_sum = 1;
		

		// ---------------- For Neuron : N1
		#10 rst_sum = 0;	 
   	#0 ld_weight = 1;
		    ld_neuron = 4'b0001;
			 ld_multiplication = 1; change = 0;
			 // weights
		#0	 in = weight_memory_1[0];   // adder takes two clock cycle to do the addition
		#20 shift_in = 1;
		    in = weight_memory_1[1];
		//#20 in = 16'b0000000000000011;
		for(i = 2; i < 32; i = i + 1) begin
			#20 in = weight_memory_1[i];
		end
		#30 change = 1; // extra signal for shifting of last signal
		#0  shift_in = 0;
			 ld_weight = 0;
			 ld_multiplication = 0;
		#10 ld_bias_LSB = 1;
			 in = 16'b1110101001111000;
		#10 ld_bias_LSB = 0; 
			 ld_bias_MSB = 1;
			 in = 16'b1111111111111111;
		#10 ld_bias_MSB = 0; bias_addition = 1;
		#10 bias_addition = 0;
		#10 ReLU_computation = 1;
		#10 ReLU_computation = 0;
		    rst_sum = 1;

		// -------------- For Neuron : N2
		#10 rst_sum = 0;	 
   	#0 ld_weight = 1;
		    ld_neuron = 4'b0010;
			 ld_multiplication = 1; change = 0;
			 // weights
		#0	 in = weight_memory_2[0];   // adder takes two clock cycle to do the addition
		#20 shift_in = 1;
		    in = weight_memory_2[1];
		//#20 in = 16'b0000000000000011;
		for(i = 2; i < 32; i = i + 1) begin
			#20 in = weight_memory_2[i];
		end
		#30 change = 1; // extra signal for shifting of last signal
		#0  shift_in = 0;
			 ld_weight = 0;
			 ld_multiplication = 0;
		#10 ld_bias_LSB = 1;
			 in = 16'b0011001100000000;
		#10 ld_bias_LSB = 0; 
			 ld_bias_MSB = 1;
			 in = 16'b0000000000000011;
		#10 ld_bias_MSB = 0; bias_addition = 1;
		#10 bias_addition = 0;
		#10 ReLU_computation = 1;
		#10 ReLU_computation = 0;
		    rst_sum = 1;

		// -------------- For Neuron : N3
		#10 rst_sum = 0;	 
   	#0 ld_weight = 1;
		    ld_neuron = 4'b0011;
			 ld_multiplication = 1; change = 0;
			 // weights
		#0	 in = weight_memory_3[0];   // adder takes two clock cycle to do the addition
		#20 shift_in = 1;
		    in = weight_memory_3[1];
		//#20 in = 16'b0000000000000011;
		for(i = 2; i < 32; i = i + 1) begin
			#20 in = weight_memory_3[i];
		end
		#30 change = 1; // extra signal for shifting of last signal
		#0  shift_in = 0;
			 ld_weight = 0;
			 ld_multiplication = 0;
		#10 ld_bias_LSB = 1;
			 in = 16'b0001100110100000;
		#10 ld_bias_LSB = 0; 
			 ld_bias_MSB = 1;
			 in = 16'b1111111111111111;
		#10 ld_bias_MSB = 0; bias_addition = 1;
		#10 bias_addition = 0;
		#10 ReLU_computation = 1;
		#10 ReLU_computation = 0;
		    rst_sum = 1;

	// -------------- For Neuron : N4
		#10 rst_sum = 0;	 
   	#0 ld_weight = 1;
		    ld_neuron = 4'b0100;
			 ld_multiplication = 1; change = 0;
			 // weights
		#0	 in = weight_memory_4[0];   // adder takes two clock cycle to do the addition
		#20 shift_in = 1;
		    in = weight_memory_4[1];
		//#20 in = 16'b0000000000000011;
		for(i = 2; i < 32; i = i + 1) begin
			#20 in = weight_memory_4[i];
		end
		#30 change = 1; // extra signal for shifting of last signal
		#0  shift_in = 0;
			 ld_weight = 0;
			 ld_multiplication = 0;
		#10 ld_bias_LSB = 1;
			 in = 16'b0100111010000000;
		#10 ld_bias_LSB = 0; 
			 ld_bias_MSB = 1;
			 in = 16'b0000000000000001;
		#10 ld_bias_MSB = 0; bias_addition = 1;
		#10 bias_addition = 0;
		#10 ReLU_computation = 1;
		#10 ReLU_computation = 0;
		    rst_sum = 1;

		// -------------- For Neuron : N5
		#10 rst_sum = 0;	 
   	#0 ld_weight = 1;
		    ld_neuron = 4'b0101;
			 ld_multiplication = 1; change = 0;
			 // weights
		#0	 in = weight_memory_5[0];   // adder takes two clock cycle to do the addition
		#20 shift_in = 1;
		    in = weight_memory_5[1];
		//#20 in = 16'b0000000000000011;
		for(i = 2; i < 32; i = i + 1) begin
			#20 in = weight_memory_5[i];
		end
		#30 change = 1; // extra signal for shifting of last signal
		#0  shift_in = 0;
			 ld_weight = 0;
			 ld_multiplication = 0;
		#10 ld_bias_LSB = 1;
			 in = 16'b0110110011000000;
		#10 ld_bias_LSB = 0; 
			 ld_bias_MSB = 1;
			 in = 16'b1111111111111110;
		#10 ld_bias_MSB = 0; bias_addition = 1;
		#10 bias_addition = 0;
		#10 ReLU_computation = 1;
		#10 ReLU_computation = 0;
		    rst_sum = 1;

		// -------------- For Neuron : N6
		#10 rst_sum = 0;	 
   	#0 ld_weight = 1;
		    ld_neuron = 4'b0110;
			 ld_multiplication = 1; change = 0;
			 // weights
		#0	 in = weight_memory_6[0];   // adder takes two clock cycle to do the addition
		#20 shift_in = 1;
		    in = weight_memory_6[1];
		//#20 in = 16'b0000000000000011;
		for(i = 2; i < 32; i = i + 1) begin
			#20 in = weight_memory_6[i];
		end
		#30 change = 1; // extra signal for shifting of last signal
		#0  shift_in = 0;
			 ld_weight = 0;
			 ld_multiplication = 0;
		#10 ld_bias_LSB = 1;
			 in = 16'b0011111000000000;
		#10 ld_bias_LSB = 0; 
			 ld_bias_MSB = 1;
			 in = 16'b1111111111111110;
		#10 ld_bias_MSB = 0; bias_addition = 1;
		#10 bias_addition = 0;
		#10 ReLU_computation = 1;
		#10 ReLU_computation = 0;
		    rst_sum = 1;

		// -------------- For Neuron : N7
		#10 rst_sum = 0;	 
   	#0 ld_weight = 1;
		    ld_neuron = 4'b0111;
			 ld_multiplication = 1; change = 0;
			 // weights
		#0	 in = weight_memory_7[0];   // adder takes two clock cycle to do the addition
		#20 shift_in = 1;
		    in = weight_memory_7[1];
		//#20 in = 16'b0000000000000011;
		for(i = 2; i < 32; i = i + 1) begin
			#20 in = weight_memory_7[i];
		end
		#30 change = 1; // extra signal for shifting of last signal
		#0  shift_in = 0;
			 ld_weight = 0;
			 ld_multiplication = 0;
		#10 ld_bias_LSB = 1;
			 in = 16'b1110011000000000;
		#10 ld_bias_LSB = 0; 
			 ld_bias_MSB = 1;
			 in = 16'b1111111111110001;
		#10 ld_bias_MSB = 0; bias_addition = 1;
		#10 bias_addition = 0;
		#10 ReLU_computation = 1;
		#10 ReLU_computation = 0;
		    rst_sum = 1;

		// -------------- For Neuron : N8
		#10 rst_sum = 0;	 
   	#0 ld_weight = 1;
		    ld_neuron = 4'b1000;
			 ld_multiplication = 1; change = 0;
			 // weights
		#0	 in = weight_memory_8[0];   // adder takes two clock cycle to do the addition
		#20 shift_in = 1;
		    in = weight_memory_8[1];
		//#20 in = 16'b0000000000000011;
		for(i = 2; i < 32; i = i + 1) begin
			#20 in = weight_memory_8[i];
		end
		#30 change = 1; // extra signal for shifting of last signal
		#0  shift_in = 0;
			 ld_weight = 0;
			 ld_multiplication = 0;
		#10 ld_bias_LSB = 1;
			 in = 16'b0000011100000000;
		#10 ld_bias_LSB = 0; 
			 ld_bias_MSB = 1;
			 in = 16'b0000000000000100;
		#10 ld_bias_MSB = 0; bias_addition = 1;
		#10 bias_addition = 0;
		#10 ReLU_computation = 1;
		#10 ReLU_computation = 0;
		    rst_sum = 1;

		// -------------- For Neuron : N9
		#10 rst_sum = 0;	 
   	#0 ld_weight = 1;
		    ld_neuron = 4'b1001;
			 ld_multiplication = 1; change = 0;
			 // weights
		#0	 in = weight_memory_9[0];   // adder takes two clock cycle to do the addition
		#20 shift_in = 1;
		    in = weight_memory_9[1];
		//#20 in = 16'b0000000000000011;
		for(i = 2; i < 32; i = i + 1) begin
			#20 in = weight_memory_9[i];
		end
		#30 change = 1; // extra signal for shifting of last signal
		#0  shift_in = 0;
			 ld_weight = 0;
			 ld_multiplication = 0;
		#10 ld_bias_LSB = 1;
			 in = 16'b1010110010000000;
		#10 ld_bias_LSB = 0; 
			 ld_bias_MSB = 1;
			 in = 16'b1111111111111101;
		#10 ld_bias_MSB = 0; bias_addition = 1;
		#10 bias_addition = 0;
		#10 ReLU_computation = 1;
		#10 ReLU_computation = 0;
		    rst_sum = 1;

		// --------------------- Loading the max function --------------------
		#10 ld_max_func = 1;
	

		#100 $finish;
	end
	

endmodule

module neuron_memory_16 #(parameter dataFile=".txt") (
	input rst, clk, read_en,
	output reg [15:0]data_out 
);
	reg [15:0]memory_array[31:0];
	reg [4:0]addr;
	
	initial begin
		$readmemb(dataFile, memory_array);
	end

	always @ (posedge clk) begin
		if(rst) begin
			addr <= 0;
			data_out <= 3'bxxx;
		end
		else if(read_en) begin // from here we are reading the data into the array weight_out[2:0]
			data_out <= memory_array[addr];
			addr <= addr + 1;
		end
		else data_out <= data_out;
			
	end

endmodule


/*
module neuron_memor_32 #(parameter dataFile=".txt") (
	input rst, clk, read_en,
	output reg [31:0]weight_out 
);
	reg [31:0]memory_array[31:0];
	reg [4:0]addr;
	
	initial begin
		$readmemb(dataFile, memory_array);
	end

	always @ (posedge clk) begin
		if(rst) begin
			addr <= 0;
			weight_out <= 3'bxxx;
		end
		else if(read_en) begin // from here we are reading the data into the array weight_out[2:0]
			weight_out <= memory_array[addr];
			addr <= addr + 1;
		end
		else weight_out <= weight_out;
			
	end

endmodule
*/

