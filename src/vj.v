// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION


`include "global.v"

module vj(
	input					clk,
	input 					rstn,
	input	[`W_PW:0]		pic_width,
	input	[`W_PH:0]		pic_height,
	input					init,
	input	[`W1P*`W_SIZE-1:0]		pixel_i,
	input					pixel_i_en,
	output reg				ready_for_next_col,				
	output					cascade_ready,
	
	output					col_end,
	output reg				face_detected
	);

(* max_fanout = 32 *)	reg		[32:0]	pixel_i_en_d;
	always @(*)		pixel_i_en_d[0] = pixel_i_en;
	always @(`CLK_RST_EDGE)
        if (`RST)	pixel_i_en_d[32:1] <= 0;
		else		pixel_i_en_d[32:1] <= {pixel_i_en_d[32:1], pixel_i_en};
	
	
/*
	reg		[0:23][`WII :0]	p;
	reg		[0:23][`WII :0]	p_d1;
	reg		[0:23][`WII :0]	p_d2 ;
	reg		[0:23][`WII :0]	p_d3 ;
	reg		[0:23][`WII :0]	p_d4 ;
	reg		[0:23][`WII :0]	p_d5 ;
	reg		[0:23][`WII :0]	p_d6 ;
	reg		[0:23][`WII :0]	p_d7 ;
	reg		[0:23][`WII :0]	p_d8 ;
	reg		[0:23][`WII :0]	p_d9 ;
	reg		[0:23][`WII :0]	p_d10;
	reg		[0:23][`WII :0]	p_d11;
	reg		[0:23][`WII :0]	p_d12;
	reg		[0:23][`WII :0]	p_d13;
	reg		[0:23][`WII :0]	p_d14;
	reg		[0:23][`WII :0]	p_d15;
	reg		[0:23][`WII :0]	p_d16;
	reg		[0:23][`WII :0]	p_d17;
	reg		[0:23][`WII :0]	p_d18;
	reg		[0:23][`WII :0]	p_d19;
	reg		[0:23][`WII :0]	p_d20;
	reg		[0:23][`WII :0]	p_d21;
	reg		[0:23][`WII :0]	p_d22;
	reg		[0:23][`WII :0]	p_d23;
	
	genvar i;
	genvar j;
	generate 	
		for (i=0; i<`W_SIZE; i=i+1) begin : RERANGE_PIXEL
			always @(*)		p[i] = pixel_i[`W1P*(`W_SIZE-i) -1 -:`W1P];
		end
	endgenerate

	always @(`CLK_EDGE)	begin                                                    
		if(pixel_i_en)			p_d1  <= {p[0], p[0]+p[1], p[2:23]};                 
		if(pixel_i_en_d[1 ])	p_d2  <= {p_d1[0:1 ], p_d1[1 ]+p_d1[2 ], p_d1[3 :23]};
		if(pixel_i_en_d[2 ])	p_d3  <= {p_d2 [0:2 ], p_d2 [2 ]+p_d2 [3 ], p_d2 [4 :23]};
		if(pixel_i_en_d[3 ])	p_d4  <= {p_d3 [0:3 ], p_d3 [3 ]+p_d3 [4 ], p_d3 [5 :23]};
		if(pixel_i_en_d[4 ])	p_d5  <= {p_d4 [0:4 ], p_d4 [4 ]+p_d4 [5 ], p_d4 [6 :23]};
		if(pixel_i_en_d[5 ])	p_d6  <= {p_d5 [0:5 ], p_d5 [5 ]+p_d5 [6 ], p_d5 [7 :23]};
		if(pixel_i_en_d[6 ])	p_d7  <= {p_d6 [0:6 ], p_d6 [6 ]+p_d6 [7 ], p_d6 [8 :23]};
		if(pixel_i_en_d[7 ])	p_d8  <= {p_d7 [0:7 ], p_d7 [7 ]+p_d7 [8 ], p_d7 [9 :23]};
		if(pixel_i_en_d[8 ])	p_d9  <= {p_d8 [0:8 ], p_d8 [8 ]+p_d8 [9 ], p_d8 [10:23]};
		if(pixel_i_en_d[9 ])	p_d10 <= {p_d9 [0:9 ], p_d9 [9 ]+p_d9 [10], p_d9 [11:23]};
		if(pixel_i_en_d[10])	p_d11 <= {p_d10[0:10], p_d10[10]+p_d10[11], p_d10[12:23]};
		if(pixel_i_en_d[11])	p_d12 <= {p_d11[0:11], p_d11[11]+p_d11[12], p_d11[13:23]};
		if(pixel_i_en_d[12])	p_d13 <= {p_d12[0:12], p_d12[12]+p_d12[13], p_d12[14:23]};
		if(pixel_i_en_d[13])	p_d14 <= {p_d13[0:13], p_d13[13]+p_d13[14], p_d13[15:23]};
		if(pixel_i_en_d[14])	p_d15 <= {p_d14[0:14], p_d14[14]+p_d14[15], p_d14[16:23]};
		if(pixel_i_en_d[15])	p_d16 <= {p_d15[0:15], p_d15[15]+p_d15[16], p_d15[17:23]};
		if(pixel_i_en_d[16])	p_d17 <= {p_d16[0:16], p_d16[16]+p_d16[17], p_d16[18:23]};
		if(pixel_i_en_d[17])	p_d18 <= {p_d17[0:17], p_d17[17]+p_d17[18], p_d17[19:23]};
		if(pixel_i_en_d[18])	p_d19 <= {p_d18[0:18], p_d18[18]+p_d18[19], p_d18[20:23]};
		if(pixel_i_en_d[19])	p_d20 <= {p_d19[0:19], p_d19[19]+p_d19[20], p_d19[21:23]};
		if(pixel_i_en_d[20])	p_d21 <= {p_d20[0:20], p_d20[20]+p_d20[21], p_d20[22:23]};
		if(pixel_i_en_d[21])	p_d22 <= {p_d21[0:21], p_d21[21]+p_d21[22], p_d21[23:23]};
		if(pixel_i_en_d[22])	p_d23 <= {p_d22[0:22], p_d22[22]+p_d22[23]             };
	end                                                                   

	
	//  ii_reg
	reg		[0:23][0:23][`WII :0] 	ii_reg;
	reg			ii_reg_shift;
	
	always @(`CLK_RST_EDGE)
        if (`RST)			ii_reg <= 0;
		//else if (pixel_i_en_d[23]) begin
		else if (ii_reg_shift) begin
			ii_reg[0 ] <=  ii_reg[1 ] - ii_reg[0];
			ii_reg[1 ] <=  ii_reg[2 ] - ii_reg[0];
			ii_reg[2 ] <=  ii_reg[3 ] - ii_reg[0];
			ii_reg[3 ] <=  ii_reg[4 ] - ii_reg[0];
			ii_reg[4 ] <=  ii_reg[5 ] - ii_reg[0];
			ii_reg[5 ] <=  ii_reg[6 ] - ii_reg[0];
			ii_reg[6 ] <=  ii_reg[7 ] - ii_reg[0];
			ii_reg[7 ] <=  ii_reg[8 ] - ii_reg[0];
			ii_reg[8 ] <=  ii_reg[9 ] - ii_reg[0];
			ii_reg[9 ] <=  ii_reg[10] - ii_reg[0];
			ii_reg[10] <=  ii_reg[11] - ii_reg[0];
			ii_reg[11] <=  ii_reg[12] - ii_reg[0];
			ii_reg[12] <=  ii_reg[13] - ii_reg[0];
			ii_reg[13] <=  ii_reg[14] - ii_reg[0];
			ii_reg[14] <=  ii_reg[15] - ii_reg[0];
			ii_reg[15] <=  ii_reg[16] - ii_reg[0];
			ii_reg[16] <=  ii_reg[17] - ii_reg[0];
			ii_reg[17] <=  ii_reg[18] - ii_reg[0];
			ii_reg[18] <=  ii_reg[19] - ii_reg[0];
			ii_reg[19] <=  ii_reg[20] - ii_reg[0];
			ii_reg[20] <=  ii_reg[21] - ii_reg[0];
			ii_reg[21] <=  ii_reg[22] - ii_reg[0];
			ii_reg[22] <=  ii_reg[23] - ii_reg[0];
			ii_reg[23] <=  ii_reg[23] - ii_reg[0] + p_d23;
		end
*/		

		
		
	genvar i;
	genvar j;	
	genvar k;	
		
	reg		[0:23][0:23][`WII :0]	p_d;
	generate 	
		for (i=0; i<`W_SIZE; i=i+1) begin : RERANGE_PIXEL
			always @(*)		p_d[0][i] = pixel_i[`W1P*(`W_SIZE-i) -1 -:`W1P];
		end
	endgenerate		
	
	generate 	
		for (j=1; j<`W_SIZE; j=j+1) begin : GEN_COL_II
			if (j < `W_SIZE-1) begin
				always @(`CLK_EDGE)	
					if (pixel_i_en_d[j-1])
						p_d[j]  <= {p_d[j-1][0:j-1], p_d[j-1][j-1]+p_d[j-1][j], p_d[j-1][j+1:`W_SIZE-1]};   
			end else  begin
				always @(`CLK_EDGE)	
					if (pixel_i_en_d[j-1])
						p_d[j]  <= {p_d[j-1][0:j-1], p_d[j-1][j-1]+p_d[j-1][j]};     // p_d[23]  <= {p_d[22][0:22], p[22][22]+p[22][23]};
			end
		end
	endgenerate
		//  ii_reg
	reg		[0:23][0:23][`WII :0] 	ii_reg;
	reg			ii_reg_shift;
	
	generate 	
		// for (j=0; j<`W_SIZE -1; j=j+1) begin : GEN_ROW_II
			// always @(`CLK_RST_EDGE)
				// if (`RST)					ii_reg[j] <= 0;
				// else if (ii_reg_shift)
						// ii_reg[j] <= ii_reg[j+1] - ii_reg[0];    //  ii width is large donot generate carry bit, so can add all together  just for simulation, synthesis will generate large width adder, use another generate to add seperate pixels 
		// end
		
		for (j=0; j<`W_SIZE -1; j=j+1) begin : GEN_ROW_II
			for (k=0; k<`W_SIZE; k=k+1) begin : PIXEL_ADD
				always @(`CLK_RST_EDGE)
					if (`RST)					ii_reg[j][k] <= 0;
					else if (ii_reg_shift)
							ii_reg[j][k] <= ii_reg[j+1][k] - ii_reg[0][k];    //  ii width is large donot generate carry bit, so can add all together  just for simulation, synthesis will generate large width adder, use another generate to add seperate pixels 
			end
		end
		for (k=0; k<`W_SIZE; k=k+1) begin : PIXEL_ADD
			always @(`CLK_RST_EDGE)
				if (`RST)	ii_reg[`W_SIZE -1][k] <= 0;
				else if (ii_reg_shift) 
							ii_reg[`W_SIZE -1][k] <= ii_reg[`W_SIZE -1][k] - ii_reg[0][k] + p_d[23][k];
		end
	endgenerate
	

	
	//=================================================================================================
	reg		[0:23][0:23][`WSII :0]	ps_d;	
	generate 	
		for (j=0; j<`W_SIZE; j=j+1) begin : CAL_SQUARE
			always @(*)		ps_d[0][j] = pixel_i[`W1P*(`W_SIZE-j) -1 -:`W1P] * pixel_i[`W1P*(`W_SIZE-j) -1 -:`W1P];
		end
	endgenerate

	generate 	
		for (j=1; j<`W_SIZE; j=j+1) begin : GEN_COL_SQUARE_INTER
			if (j < `W_SIZE-1) begin
				always @(`CLK_EDGE)	
					if (pixel_i_en_d[j-1])
						ps_d[j]  <= {ps_d[j-1][0:j-1], ps_d[j-1][j-1]+ps_d[j-1][j], ps_d[j-1][j+1:`W_SIZE-1]};   
			end else  begin
				always @(`CLK_EDGE)	
					if (pixel_i_en_d[j-1])
						ps_d[j]  <= {ps_d[j-1][0:j-1], ps_d[j-1][j-1]+ps_d[j-1][j]};     // ps_d[23]  <= {ps_d[22][0:22], p[22][22]+p[22][23]};
			end
		end
	endgenerate
	
	reg		[0:23][0:23][`WSII :0] 	square_ii_reg;
	generate 	
		// for (j=0; j<`W_SIZE -1; j=j+1) begin : GEN_ROW_SQUARE_INTER
			// always @(`CLK_RST_EDGE)
				// if (`RST)					square_ii_reg[j] <= 0;
				// else if (ii_reg_shift)
						// square_ii_reg[j] <= square_ii_reg[j+1] - square_ii_reg[0];
		// end
		// always @(`CLK_RST_EDGE)
			// if (`RST)	square_ii_reg[`W_SIZE -1] <= 0;
			// else if (ii_reg_shift) 
						// square_ii_reg[`W_SIZE -1] <= square_ii_reg[`W_SIZE -1] - square_ii_reg[0] + ps_d[23];
						
		for (j=0; j<`W_SIZE -1; j=j+1) begin : GEN_ROW_SQUARE_INTER
			for (k=0; k<`W_SIZE; k=k+1) begin : PIXEL_SQ_ADD
				always @(`CLK_RST_EDGE)
					if (`RST)					square_ii_reg[j][k] <= 0;
					else if (ii_reg_shift)
							square_ii_reg[j][k] <= square_ii_reg[j+1][k] - square_ii_reg[0][k];
			end
		end
		for (k=0; k<`W_SIZE; k=k+1) begin : PIXEL_SQ_ADD
			always @(`CLK_RST_EDGE)
				if (`RST)	square_ii_reg[`W_SIZE -1][k] <= 0;
				else if (ii_reg_shift) 
							square_ii_reg[`W_SIZE -1][k] <= square_ii_reg[`W_SIZE -1][k] - square_ii_reg[0][k] + ps_d[23][k];
		end
	endgenerate
	
	//=================================================================================================
	
	
	
	
	reg		[11:0]		aa_rect0_rom;
	wire	[19:0]		qa_rect0_rom;
	wire	[`W_WEIGHT:0]		qa_rect0_weight_rom;
	reg		[19:0]		qa_rect0_rom_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	qa_rect0_rom_d1 <= 0;
		else 		qa_rect0_rom_d1 <= qa_rect0_rom;
	reg		[`W_WEIGHT:0]		qa_rect0_weight_rom_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	qa_rect0_weight_rom_d1 <= 0;
		else 		qa_rect0_weight_rom_d1 <= qa_rect0_weight_rom;
	wire	[4:0]		rect0_x, rect0_y, rect0_w, rect0_h;
	
	// here need a register for better timing
	assign 				{rect0_x, rect0_y, rect0_w, rect0_h} = qa_rect0_rom_d1;  
	rect0_rom rect0_rom(
		.clk		(clk),
		.addr		(aa_rect0_rom),
		.q			(qa_rect0_rom)
		);
	rect0_wieght_rom rect0_wieght_rom(
		.clk		(clk),
		.addr		(aa_rect0_rom),
		.q			(qa_rect0_weight_rom)
		);
		
	reg		[11:0]		aa_rect1_rom;
	wire	[19:0]		qa_rect1_rom;
	wire	[`W_WEIGHT:0]		qa_rect1_weight_rom;
	reg		[19:0]		qa_rect1_rom_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	qa_rect1_rom_d1 <= 0;
		else 		qa_rect1_rom_d1 <= qa_rect1_rom;
	reg		[`W_WEIGHT:0]		qa_rect1_weight_rom_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	qa_rect1_weight_rom_d1 <= 0;
		else 		qa_rect1_weight_rom_d1 <= qa_rect1_weight_rom;
	
	
	wire	[4:0]		rect1_x, rect1_y, rect1_w, rect1_h;
	assign 				{rect1_x, rect1_y, rect1_w, rect1_h} = qa_rect1_rom_d1;  
	rect1_rom rect1_rom(
		.clk		(clk),
		.addr		(aa_rect1_rom),
		.q			(qa_rect1_rom)
		);
	rect1_wieght_rom rect1_wieght_rom(
		.clk		(clk),
		.addr		(aa_rect1_rom),
		.q			(qa_rect1_weight_rom)
		);
		
	reg		[11:0]		aa_rect2_rom;
	wire	[19:0]		qa_rect2_rom;
	wire	[`W_WEIGHT:0]		qa_rect2_weight_rom;
	reg		[19:0]		qa_rect2_rom_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	qa_rect2_rom_d1 <= 0;
		else 		qa_rect2_rom_d1 <= qa_rect2_rom;
	reg		[`W_WEIGHT:0]		qa_rect2_weight_rom_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	qa_rect2_weight_rom_d1 <= 0;
		else 		qa_rect2_weight_rom_d1 <= qa_rect2_weight_rom;
	wire	[4:0]		rect2_x, rect2_y, rect2_w, rect2_h;
	assign 				{rect2_x, rect2_y, rect2_w, rect2_h} = qa_rect2_rom_d1; 
	rect2_rom rect2_rom(
		.clk		(clk),
		.addr		(aa_rect2_rom),
		.q			(qa_rect2_rom)
		);
	rect2_wieght_rom rect2_wieght_rom(
		.clk		(clk),
		.addr		(aa_rect2_rom),
		.q			(qa_rect2_weight_rom)
		);
		
	reg		[11:0]				aa_weak_thresh_rom;
	wire	[`W_WEAK_TH:0]		qa_weak_thresh_rom;
	reg		[`W_WEAK_TH:0]		qa_weak_thresh_rom_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	qa_weak_thresh_rom_d1 <= 0;
		else 		qa_weak_thresh_rom_d1 <= qa_weak_thresh_rom;
	
	weak_thresh_rom weak_thresh_rom(
		.clk		(clk),
		.addr		(aa_weak_thresh_rom),
		.q			(qa_weak_thresh_rom)
		);
		
	reg		[11:0]				aa_left_tree_rom;
	wire	[`W_TREE:0]			qa_left_tree_rom;
	reg		[`W_TREE:0]		qa_left_tree_rom_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	qa_left_tree_rom_d1 <= 0;
		else 		qa_left_tree_rom_d1 <= qa_left_tree_rom;	
	
	left_tree_rom left_tree_rom(
		.clk		(clk),
		.addr		(aa_left_tree_rom),
		.q			(qa_left_tree_rom)
		);
		
	reg		[11:0]				aa_right_tree_rom;
	wire	[`W_TREE:0]			qa_right_tree_rom;
	reg		[`W_TREE:0]		qa_right_tree_rom_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	qa_right_tree_rom_d1 <= 0;
		else 		qa_right_tree_rom_d1 <= qa_right_tree_rom;	
	
	right_tree_rom right_tree_rom(
		.clk		(clk),
		.addr		(aa_right_tree_rom),
		.q			(qa_right_tree_rom)
		);
	
	reg		[4:0]				aa_strong_thresh_rom;
	wire	[`W_STRONG_TH:0]		qa_strong_thresh_rom;
	reg		[`W_STRONG_TH:0]		qa_strong_thresh_rom_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	qa_strong_thresh_rom_d1 <= 0;
		else 		qa_strong_thresh_rom_d1 <= qa_strong_thresh_rom;
		
	strong_thresh_rom strong_thresh_rom(
		.clk		(clk),
		.addr		(aa_strong_thresh_rom),
		.q			(qa_strong_thresh_rom)
		);
	
	
	//=================================================================================================
	reg		[`W_PW:0]	ii_reg_col_cnt; 
	reg					ii_reg_inited; 
	reg					ii_reg_ready; 
	wire				variance_sqrt_valid; 
	reg					classify_go; 
	reg					classify_en; 
	reg		[11:0]		weak_cnt;
	reg		[4:0]		strong_cnt;
	reg					first_weak, last_weak;
	reg					last_strong;
	reg					detected_fail;
	reg					strong_fail;
	reg					cascade_end;
	reg		[11:0]		weak_stages_acc;
	
	//wire	col_end = (ii_reg_col_cnt == pic_width) & cascade_end;
	//assign	col_end = (ii_reg_col_cnt == pic_width) & cascade_end;
	assign	col_end = (ii_reg_col_cnt == pic_width) & cascade_end;
	
	
	
	
	reg		[4:0]		strong_cnt_d1, strong_cnt_d2, strong_cnt_d3;
	reg		[4:0]		strong_cnt_b2, strong_cnt_b1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{strong_cnt_b1, strong_cnt, strong_cnt_d1, strong_cnt_d2, strong_cnt_d3} <= 0;
		else 		{strong_cnt_b1, strong_cnt, strong_cnt_d1, strong_cnt_d2, strong_cnt_d3} <= {strong_cnt_b2, strong_cnt_b1, strong_cnt, strong_cnt_d1, strong_cnt_d2};

	reg		[7:0]	ii_reg_ready_d;
	always @(*)	ii_reg_ready_d[0] = ii_reg_ready;
	always @(`CLK_RST_EDGE)
		if (`RST)	ii_reg_ready_d[7:1] <= 0;
		else 		ii_reg_ready_d[7:1] <= ii_reg_ready_d;	
	
	reg		[32:0]	classify_en_d;
	always @(*)		classify_en_d[0] = classify_en;
	always @(`CLK_RST_EDGE)
        if (`RST)	classify_en_d[32:1] <= 0;
		else		classify_en_d[32:1] <= classify_en_d;
		
	reg		[32:0]	first_weak_d;
	always @(*)		first_weak_d[0] = first_weak;
	always @(`CLK_RST_EDGE)
        if (`RST)	first_weak_d[32:1] <= 0;
		else		first_weak_d[32:1] <= first_weak_d;
	
	reg		[32:0]	last_weak_d;
	always @(*)		last_weak_d[0] = last_weak;
	always @(`CLK_RST_EDGE)
        if (`RST)	last_weak_d[32:1] <= 0;
		else		last_weak_d[32:1] <= last_weak_d;
	
	reg		[32:0]	last_strong_d;
	always @(*)		last_strong_d[0] = last_strong;
	always @(`CLK_RST_EDGE)
        if (`RST)	last_strong_d[32:1] <= 0;
		else		last_strong_d[32:1] <= last_strong_d;
	
	
	wire	ii_reg_inited_f = ii_reg_shift&(ii_reg_col_cnt==`W_SIZE-1);
	always @(`CLK_RST_EDGE)
        if (`RST)					ii_reg_col_cnt <= 0;
		else if (init)				ii_reg_col_cnt <= 0;
		else if (ii_reg_shift)		ii_reg_col_cnt <= ii_reg_col_cnt + 1;
	always @(`CLK_RST_EDGE)
        if (`RST)					ii_reg_inited <= 0;
		else if (init)				ii_reg_inited <= 0;
		else if (ii_reg_inited_f)	ii_reg_inited <= 1;
	always @(`CLK_RST_EDGE)
        if (`RST)								ii_reg_ready <= 0;
		else if (ii_reg_inited_f)				ii_reg_ready <= 1;
		else if (ii_reg_shift&ii_reg_inited)	ii_reg_ready <= 1;
		else 									ii_reg_ready <= 0;
	
	// cascade_end
	reg		ii_reg_shift_b1;
		
	reg		[1:0]	line_ii_semaphore;
	reg				ii_reg_ready_b1;
	reg				cascade_done;
	always @(`CLK_RST_EDGE)
        if (`RST)					cascade_done <= 0;
		//else if (ii_reg_ready)	cascade_done <= 0;
		// else if (ii_reg_shift)	cascade_done <= 0;
		else if (ii_reg_shift_b1)	cascade_done <= 0;
		else if (cascade_end)		cascade_done <= 1;
	
	always @(`CLK_RST_EDGE)
        if (`RST)	line_ii_semaphore <= 0;
	//	else case ( {pixel_i_en_d[22], ii_reg_shift})
		else case ( {pixel_i_en_d[22], ii_reg_shift_b1})
			2'b10 : line_ii_semaphore <= line_ii_semaphore + 1;
			2'b01 : line_ii_semaphore <= line_ii_semaphore - 1;
			endcase
	//always @(`CLK_RST_EDGE)
    //    if (`RST)										ii_reg_shift <= 0;
	//	else if (!ii_reg_inited)						ii_reg_shift <= pixel_i_en_d[22];
	//	else if (cascade_done&&line_ii_semaphore!=0)	ii_reg_shift <= 1;
	//	else 											ii_reg_shift <= 0;
	
	//  two much comb here
	
	// ii_reg_shift  --> ii_reg_inited
	// line_ii_semaphore
	//  add a signal ii_reg_inited_b1 to generate a ii_reg_shift_b1
	//always @(*)		ii_reg_shift = (~ii_reg_inited&pixel_i_en_d[23] )|| (ii_reg_inited && cascade_done&&line_ii_semaphore!=0);
	reg		ii_reg_inited_b1;

	reg		[`W_PW:0]	ii_reg_col_cnt_b1;
	always @(`CLK_RST_EDGE)
        if (`RST)					ii_reg_col_cnt_b1 <= 0;
		else if (init)				ii_reg_col_cnt_b1 <= 0;
		else if (ii_reg_shift_b1)	ii_reg_col_cnt_b1 <= ii_reg_col_cnt_b1 + 1;
		
	wire	ii_reg_inited_f_b1 = ii_reg_shift_b1&(ii_reg_col_cnt_b1==24-1);
	always @(`CLK_RST_EDGE)
        if (`RST)							ii_reg_inited_b1 <= 0;
		else if (init)						ii_reg_inited_b1 <= 0;
		else if (ii_reg_inited_f_b1)		ii_reg_inited_b1 <= 1;
							
	 always @(*)	ii_reg_shift_b1 = (~ii_reg_inited_b1&pixel_i_en_d[22] )|| (cascade_done&&line_ii_semaphore!=0);
	always @(`CLK_RST_EDGE)
		if (`RST)	ii_reg_shift <= 0;
		else 		ii_reg_shift <= ii_reg_shift_b1;
	
	 wire		ii_reg_shift__ = (~ii_reg_inited&pixel_i_en_d[23] )|| (cascade_done&&line_ii_semaphore!=0);
	// always @(*)		ii_reg_shift = (~ii_reg_inited&pixel_i_en_d[23] )|| (cascade_done&&line_ii_semaphore!=0);
    
	always @(`CLK_RST_EDGE)
        if (`RST)	ready_for_next_col <= 0;
		else		ready_for_next_col <= ii_reg_ready;
		
	//------------------------------------------------------------
	wire	[11:0]	qa_weak_stages_acc_rom;
	weak_stages_acc_rom weak_stages_acc_rom(
		.clk		(clk),
		.addr		(strong_cnt_b2),
		.q			(qa_weak_stages_acc_rom)
		);

	always @(`CLK_RST_EDGE)
        if (`RST)			classify_go <= 0;
		else 				classify_go <= variance_sqrt_valid;
		
		
	//TODO: flollowing combinational should be be optimised  add some register
	always @(*)		strong_fail = detected_fail & last_weak_d[8];
	
	// the strong_fail cannot include the last strong
	// if the last strong is failed the cascade_end will be pulse twice
	// use (weak_cnt == `TATAL_WEAK_STAGES-1)  to start next subwindow to save some clks
	assign			cascade_end = strong_fail&!last_strong_d[8] | (weak_cnt == `TATAL_WEAK_STAGES-1);
	
	always @(*)		face_detected = !detected_fail & last_weak_d[8] & last_strong_d[8];
	
	assign	cascade_ready =  strong_fail | last_weak_d[8] & last_strong_d[8];
	 
	 
	always @(`CLK_RST_EDGE)
        if (`RST)									classify_en <= 0;
		else if (classify_go)						classify_en <= 1;	
		else if (strong_fail || (weak_cnt == `TATAL_WEAK_STAGES-1))	
													classify_en <= 0;
	always @(`CLK_RST_EDGE)
        if (`RST)				weak_cnt <= 0;
		else					weak_cnt <= classify_en? weak_cnt + 1 : 0;
	always @(`CLK_RST_EDGE)
        if (`RST)				weak_stages_acc <= 0;
		else					weak_stages_acc <= qa_weak_stages_acc_rom;

	always @(`CLK_RST_EDGE)
        if (`RST)								strong_cnt_b2 <= 0;
		else if (classify_go)					strong_cnt_b2 <= 0;
		else if (strong_fail)					strong_cnt_b2 <= 0;
		else if (weak_cnt==weak_stages_acc-3)	strong_cnt_b2 <= (strong_cnt_b2==`STAGE_N-1 )? 0 : strong_cnt_b2+1;
	always @(`CLK_RST_EDGE)
        if (`RST)	last_weak <= 0;	
		else 		last_weak <= weak_cnt==weak_stages_acc-2 ? 1 : 0;
	always @(`CLK_RST_EDGE)
        if (`RST)	first_weak <= 0;	
		else 		first_weak <= classify_go || ( last_weak & !last_strong);
	always @(`CLK_RST_EDGE)
        if (`RST)	last_strong <= 0;	
		else 		last_strong <= strong_cnt_b1==`STAGE_N-1 ? 1 : 0;
		
	
	
	//==========================================================
	
	wire		[`WII:0]	mean = ii_reg[23][23];
	wire		[`WSII:0]	square_mean = square_ii_reg[23][23];
	
	reg			[`WII+`WII+1:0]	mean_x2;
	always @(`CLK_RST_EDGE)
        if (`ZST)				mean_x2 <= 0;
		else if (ii_reg_ready)	mean_x2 = mean * mean;
		
	reg			[`WII+`WII+1:0]	square_mean_x_size;
	always @(`CLK_RST_EDGE)
        if (`ZST)				square_mean_x_size <= 0;
		else if (ii_reg_ready)	square_mean_x_size <= square_mean * (`W_SIZE * `W_SIZE);
	
	reg		[`W_VAR+`W_VAR+1:0]			variance;
	wire	[`W_VAR:0]					variance_sqrt;
	
	always @(`CLK_RST_EDGE)
        if (`ZST)		variance <= 0;
		else			variance <= square_mean_x_size -  mean_x2;
	
	sqrt_root2 #(.WI	(`W_VAR+`W_VAR+1+1)) sqrt_root(
	//sqrt_root #(.WI	(`W_VAR+`W_VAR+1+1)) sqrt_root(
	//sqrt_root 	sqrt_root(
		.clk			(clk), 
		.rstn			(rstn), 
		.en				(ii_reg_ready_d[2]), 
		.radical		(variance), 		
		.root_en		(variance_sqrt_valid),	 
		.root			(variance_sqrt),		  // 要乘以 weak_threshhold
		.remainder	    ()
		);
	

	always @(*)		aa_rect0_rom = weak_cnt;
	always @(*)		aa_rect1_rom = weak_cnt;
	always @(*)		aa_rect2_rom = weak_cnt;
	always @(*)		aa_weak_thresh_rom = weak_cnt;
	always @(*)		aa_left_tree_rom = weak_cnt;
	always @(*)		aa_right_tree_rom = weak_cnt;
	
	always @(*)		aa_strong_thresh_rom = strong_cnt;
	
	//=================================================================================================
	//===============
	reg		[`W_WEIGHT:0] w0, w1, w2;
	//reg		[`W_VAR:0]			variance_sqrt;
	reg		[`W_WEAK_TH:0]		weak_thresh;
	reg		[`W_TREE:0]			right_tree, left_tree;
	reg		[`W_STRONG_TH:0]	strong_thresh;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{w0, w1, w2} <= 0;
		else 		{w0, w1, w2} <= {qa_rect0_weight_rom_d1, qa_rect1_weight_rom_d1, qa_rect2_weight_rom_d1};
	always @(`CLK_RST_EDGE)
		if (`ZST)	weak_thresh <= 0;
		else		weak_thresh <= qa_weak_thresh_rom_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{right_tree, left_tree} <= 0;
		else		{right_tree, left_tree} <= {qa_right_tree_rom_d1, qa_left_tree_rom_d1};
	always @(`CLK_RST_EDGE)
		if (`ZST)	strong_thresh <= 0;
		else		strong_thresh <= qa_strong_thresh_rom_d1;
		
	
	// p0  p1
	// p2  p3
	// ii  should include the current pixels??
	// ii(x,y) = 0  for x or y = 0   
	//  

	reg		[`WII:0] rect0_p0, rect0_p1, rect0_p2, rect0_p3; 
	wire	[4:0]	rect0_p0_x = rect0_x;
	wire	[4:0]	rect0_p0_y = rect0_y;
	wire	[4:0]	rect0_p1_x = rect0_x + rect0_w;
	wire	[4:0]	rect0_p1_y = rect0_y;	
	wire	[4:0]	rect0_p2_x = rect0_x;
	wire	[4:0]	rect0_p2_y = rect0_y + rect0_h;
	wire	[4:0]	rect0_p3_x = rect0_x + rect0_w;
	wire	[4:0]	rect0_p3_y = rect0_y + rect0_h;
	always @(`CLK_RST_EDGE)
		if (`RST)	rect0_p0 <= 0;
		else if (rect0_p0_x==0 || rect0_p0_y==0)
					rect0_p0 <= 0;
		else		rect0_p0 <= ii_reg[rect0_p0_x-1][rect0_p0_y-1];
	always @(`CLK_RST_EDGE)
		if (`RST)	rect0_p1 <= 0;
		else if (rect0_p1_x==0 || rect0_p1_y==0)
					rect0_p1 <= 0;
		else		rect0_p1 <= ii_reg[rect0_p1_x-1][rect0_p1_y-1];
	always @(`CLK_RST_EDGE)
		if (`RST)	rect0_p2 <= 0;
		else if (rect0_p2_x==0 || rect0_p2_y==0)
					rect0_p2 <= 0;
		else		rect0_p2 <= ii_reg[rect0_p2_x-1][rect0_p2_y-1];
	always @(`CLK_RST_EDGE)
		if (`RST)	rect0_p3 <= 0;
		else if (rect0_p3_x==0 || rect0_p3_y==0)
					rect0_p3 <= 0;
		else		rect0_p3 <= ii_reg[rect0_p3_x-1][rect0_p3_y-1];
	
	reg		[`WII:0] rect1_p0, rect1_p1, rect1_p2, rect1_p3; 
	wire	[4:0]	rect1_p0_x = rect1_x;
	wire	[4:0]	rect1_p0_y = rect1_y;
	wire	[4:0]	rect1_p1_x = rect1_x + rect1_w;
	wire	[4:0]	rect1_p1_y = rect1_y;	
	wire	[4:0]	rect1_p2_x = rect1_x;
	wire	[4:0]	rect1_p2_y = rect1_y + rect1_h;
	wire	[4:0]	rect1_p3_x = rect1_x + rect1_w;
	wire	[4:0]	rect1_p3_y = rect1_y + rect1_h;
	always @(`CLK_RST_EDGE)
		if (`RST)	rect1_p0 <= 0;
		else if (rect1_p0_x==0 || rect1_p0_y==0)
					rect1_p0 <= 0;
		else		rect1_p0 <= ii_reg[rect1_p0_x-1][rect1_p0_y-1];
	always @(`CLK_RST_EDGE)
		if (`RST)	rect1_p1 <= 0;
		else if (rect1_p1_x==0 || rect1_p1_y==0)
					rect1_p1 <= 0;
		else		rect1_p1 <= ii_reg[rect1_p1_x-1][rect1_p1_y-1];
	always @(`CLK_RST_EDGE)
		if (`RST)	rect1_p2 <= 0;
		else if (rect1_p2_x==0 || rect1_p2_y==0)
					rect1_p2 <= 0;
		else		rect1_p2 <= ii_reg[rect1_p2_x-1][rect1_p2_y-1];
	always @(`CLK_RST_EDGE)
		if (`RST)	rect1_p3 <= 0;
		else if (rect1_p3_x==0 || rect1_p3_y==0)
					rect1_p3 <= 0;
		else		rect1_p3 <= ii_reg[rect1_p3_x-1][rect1_p3_y-1];
	
	reg		[`WII:0] rect2_p0, rect2_p1, rect2_p2, rect2_p3; 
	wire	[4:0]	rect2_p0_x = rect2_x;
	wire	[4:0]	rect2_p0_y = rect2_y;
	wire	[4:0]	rect2_p1_x = rect2_x + rect2_w;
	wire	[4:0]	rect2_p1_y = rect2_y;	
	wire	[4:0]	rect2_p2_x = rect2_x;
	wire	[4:0]	rect2_p2_y = rect2_y + rect2_h;
	wire	[4:0]	rect2_p3_x = rect2_x + rect2_w;
	wire	[4:0]	rect2_p3_y = rect2_y + rect2_h;
	always @(`CLK_RST_EDGE)
		if (`RST)	rect2_p0 <= 0;
		else if (rect2_p0_x==0 || rect2_p0_y==0)
					rect2_p0 <= 0;
		else		rect2_p0 <= ii_reg[rect2_p0_x-1][rect2_p0_y-1];
	always @(`CLK_RST_EDGE)
		if (`RST)	rect2_p1 <= 0;
		else if (rect2_p1_x==0 || rect2_p1_y==0)
					rect2_p1 <= 0;
		else		rect2_p1 <= ii_reg[rect2_p1_x-1][rect2_p1_y-1];
	always @(`CLK_RST_EDGE)
		if (`RST)	rect2_p2 <= 0;
		else if (rect2_p2_x==0 || rect2_p2_y==0)
					rect2_p2 <= 0;
		else		rect2_p2 <= ii_reg[rect2_p2_x-1][rect2_p2_y-1];
	always @(`CLK_RST_EDGE)
		if (`RST)	rect2_p3 <= 0;
		else if (rect2_p3_x==0 || rect2_p3_y==0)
					rect2_p3 <= 0;
		else		rect2_p3 <= ii_reg[rect2_p3_x-1][rect2_p3_y-1];
		
		
	//===============================================================================
	
`ifdef SIMULATING	
	integer		simu_cnt;
	always @(`CLK_RST_EDGE)
		if (`RST)	simu_cnt <= 0;
		else 		simu_cnt <= classify_go? 0 : simu_cnt + 1;
`endif
	
	classifier classifier(
		.clk			(clk		),
		.rstn			(rstn		),
		//.init			(init),
		.init			(classify_go),
		.first_weak		(first_weak_d[3]),
		.en				(classify_en_d[3]),
		.w0				(w0),
		.w1				(w1),
		.w2				(w2),
		.r0 			(rect0_p0),
		.r1 			(rect0_p1),
		.r2 			(rect0_p2),
		.r3 			(rect0_p3),
		.r4 			(rect1_p0),
		.r5 			(rect1_p1),
		.r6 			(rect1_p2),
		.r7 			(rect1_p3),
		.r8 			(rect2_p0),
		.r9 			(rect2_p1),
		.r10			(rect2_p2),
		.r11			(rect2_p3),
		
		.variance_sqrt	(variance_sqrt	),
		.weak_thresh	(weak_thresh	),
		.left_tree		(left_tree	),
		.right_tree		(right_tree	),
		.strong_thresh	(strong_thresh	),
		.detected_fail	(detected_fail	)
		);

	
	
endmodule 



// latency  5 clk
module classifier(
	input					clk,
	input 					rstn,
	
	input					init,   // reset  init the  strong_accumulator_result
	input					first_weak,   // reset  init the  strong_accumulator_result
	input					en,
	
	input	[`W_WEIGHT:0]	w0, w1, w2,
	
	input	[`WII:0]		r0, r1, r2, r3,					
	input	[`WII:0]		r4, r5, r6, r7,					
	input	[`WII:0]		r8, r9, r10, r11,					
	

	// used for varian conpute 
	// so dont need four rectangle to conpute 
	// just one 
	//input	[`WII:0]		p0, p1, p2, p3,	    		// E(x)
	//input	[`WSII:0]		ssp0, ssp1, ssp2, ssp3,	    // E(x2)
	
	input 	[`W_VAR:0]			variance_sqrt,
	input	[`W_WEAK_TH:0]		weak_thresh,
	input signed	[`W_TREE:0]	right_tree, left_tree,
	input	[`W_STRONG_TH:0]	strong_thresh,
	output	reg					result_valid,
	output	reg					detected_fail			
	);
	
	// r0~11  		-- result_rect0~3 	-- 		result_feature
	// weak_thresh	-- weak_thresh_d1	--	var_norm_weak_thresh --- tree_mux_sel ---   strong_accumulator_result   -- 
	// left_tree												     left_tree_d3
	// right_tree													 right_tree_d3
	// en															 d3			
	
	reg		signed [`W_WEIGHT:0]		w0_d1, w1_d1, w2_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{w0_d1, w1_d1, w2_d1} <= 0;
		else 		{w0_d1, w1_d1, w2_d1} <= {w0, w1, w2};
		
	reg	signed	[`W_WEAK_TH:0]		weak_thresh_d1, weak_thresh_d2, weak_thresh_d3;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{weak_thresh_d1, weak_thresh_d2, weak_thresh_d3} <= 0;
		else 		{weak_thresh_d1, weak_thresh_d2, weak_thresh_d3} <= {weak_thresh, weak_thresh_d1, weak_thresh_d2};
	
	reg	signed	[`W_TREE:0]		right_tree_d1, right_tree_d2, right_tree_d3;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{right_tree_d1, right_tree_d2, right_tree_d3} <= 0;
		else 		{right_tree_d1, right_tree_d2, right_tree_d3} <= {right_tree, right_tree_d1, right_tree_d2};
	
	reg	signed	[`W_TREE:0]		left_tree_d1, left_tree_d2, left_tree_d3;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{left_tree_d1, left_tree_d2, left_tree_d3} <= 0;
		else 		{left_tree_d1, left_tree_d2, left_tree_d3} <= {left_tree, left_tree_d1, left_tree_d2};
	
	reg						en_d1, en_d2, en_d3, en_d4, en_d5;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{en_d1, en_d2, en_d3, en_d4, en_d5} <= 0;
		else 		{en_d1, en_d2, en_d3, en_d4, en_d5} <= {en, en_d1, en_d2, en_d3, en_d4};
	
	reg						first_weak_d1, first_weak_d2, first_weak_d3, first_weak_d4, first_weak_d5;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{first_weak_d1, first_weak_d2, first_weak_d3, first_weak_d4, first_weak_d5} <= 0;
		else 		{first_weak_d1, first_weak_d2, first_weak_d3, first_weak_d4, first_weak_d5} <= {first_weak, first_weak_d1, first_weak_d2, first_weak_d3, first_weak_d4};
	reg	signed		[`W_STRONG_TH:0] strong_thresh_d1, strong_thresh_d2, strong_thresh_d3, strong_thresh_d4, strong_thresh_d5;
	always @(`CLK_RST_EDGE)
		if (`ZST)	{strong_thresh_d1, strong_thresh_d2, strong_thresh_d3, strong_thresh_d4, strong_thresh_d5} <= 0;
		else 		{strong_thresh_d1, strong_thresh_d2, strong_thresh_d3, strong_thresh_d4, strong_thresh_d5} <= {strong_thresh, strong_thresh_d1, strong_thresh_d2, strong_thresh_d3, strong_thresh_d4};
	
	
	
	
	reg	signed	[`WII:0]					result_rect0, result_rect1, result_rect2; 
	reg	signed	[`WII+`W_WEIGHT+1:0]		result_feature;
	always @(`CLK_RST_EDGE)
		if (`ZST)	result_rect0 <= 0;
		else 		result_rect0 <= (r0 + r3) - (r1 + r2);
	always @(`CLK_RST_EDGE)
		if (`ZST)	result_rect1 <= 0;
		else 		result_rect1 <= (r4 + r7) - (r5 + r6);
	always @(`CLK_RST_EDGE)
		if (`ZST)	result_rect2 <= 0;
		else 		result_rect2 <= (r8 + r11) - (r9 + r10);
		
	always @(`CLK_RST_EDGE)
		if (`RST)	result_feature <= 0;
		else 		result_feature <= w0_d1*result_rect0 + w1_d1*result_rect1 + w2_d1*result_rect2;
	
	
	wire		result_feature_valid = en_d2;
	wire		strong_accumulator_result_valid = en_d4;
	
	
	reg	signed	[34:0]	var_norm_weak_thresh;	
	always @(`CLK_RST_EDGE)
		if (`RST)					var_norm_weak_thresh <= 0;
		else if (variance_sqrt==0)	var_norm_weak_thresh <= weak_thresh_d1;
		else 						var_norm_weak_thresh <= $signed({1'b0, variance_sqrt}) * weak_thresh_d1;
	
	reg						tree_mux_sel;
	reg	 signed	[`W_ACC:0]		strong_accumulator_result;
	always @(`CLK_RST_EDGE)
		if (`ZST)		tree_mux_sel <= 0;
		else 			tree_mux_sel <=  (result_feature >= var_norm_weak_thresh)? 1: 0;
		
	wire 	signed	[`W_TREE:0]	tree =  tree_mux_sel? $signed(right_tree_d3) : $signed(left_tree_d3);
	
	always @(`CLK_RST_EDGE)
		if (`ZST)			strong_accumulator_result <= 0;
		else if (init)		strong_accumulator_result <= 0;
	//	else if (en_d3)		strong_accumulator_result <= strong_accumulator_result +  tree_mux_sel? $signed(right_tree_d3) : $signed(left_tree_d3);
		else if (first_weak_d3)strong_accumulator_result <= tree;
		else if (en_d3)		strong_accumulator_result <= strong_accumulator_result +  tree;
		
	always @(`CLK_RST_EDGE)
		if (`RST)			detected_fail <= 0;										
		else if (en_d4)		detected_fail <= ($signed(strong_accumulator_result) < $signed(strong_thresh_d4))? 1 : 0;
	//	else if (en_d4)		detected_fail <= ($signed(strong_accumulator_result) < 0.4*$signed(strong_thresh_d4))? 1 : 0;
	always @(`CLK_RST_EDGE)
		if (`RST)			result_valid <= 0;										
		else				result_valid <= en_d4;
endmodule


// this one is piplined one use two much mulplier and has bad timing around the multiplier
module sqrt_root #(parameter WI = 26)(
	input					clk,
	input 					rstn,
	input 					en,
	input 		[WI-1:0]	radical,
	output					root_en,		
	output		[WI/2 -1:0]	root,		
	output		[WI/2:0]	remainder
	);
	
	
	reg		[WI/2 :0] [WI/2 -1:0]	a;
	wire	[WI/2 :0] [WI/2 -1:0]	bit_shift;
	reg		[WI/2 :0] [WI-1:0]		radical_d;
	reg		[WI/2 :0] 				en_d;
	genvar i;
	
	always @(`CLK_RST_EDGE)
		if (`RST)	a[0] <= 0;
		else 		a[0] <= 1<< WI/2 -1;
	//always @(*)	a[0] = 1<< WI/2 -1;
	wire	[WI/2 -1:0] one	= 1;
	
	always @(*)	radical_d[0] = radical;
	always @(`CLK_RST_EDGE)
		if (`RST)	radical_d[WI/2 :1] <= 0;
		else 		radical_d[WI/2 :1] <= {radical_d[WI/2 :1], radical_d[0]};
	always @(*)	en_d[0] = en;
	always @(`CLK_RST_EDGE)
		if (`RST)	en_d[WI/2 :1] <= 0;
		else 		en_d[WI/2 :1] <= {en_d[WI/2 :1], en_d[0]};
	// a[0] ~ WI/2， if a[i] > result   a[i+1] should be let the bit associate with a[i] to be 0
	//  need optimaze the multiply, maybe  need one more clk,
	generate 	
		for (i=0; i<WI/2; i=i+1) begin : it
			assign bit_shift[i] = one << (WI/2 -1-i);
			always @(`CLK_RST_EDGE)
				if (`RST)			a[i+1] <= 0;
				else if (a[i]*a[i] > radical_d[i])
					if (i < WI/2-1)
					//	a[i+1] <= a[i] -  (one << (WI/2 -1-i)) +  one << (WI/2 -1-i-1) ;
						a[i+1] <= (a[i] ^ bit_shift[i]) | bit_shift[i+1] ;
					else
					//	a[i+1] <= a[i] -  one << (WI/2 -1-i) ;
						a[i+1] <= (a[i] ^ bit_shift[i]) ;
				else
					if (i < WI/2-1)
						//a[i+1] <= a[i] +  one << (WI/2 -1-i-1);	
						a[i+1] <=  a[i] | bit_shift[i+1] ;
					else
						a[i+1] <= a[i];	
						
		end
	endgenerate
	
	wire	[WI/2 -1:0]	a0  = a[0 ];
	wire	[WI/2 -1:0]	a1  = a[1 ];
	wire	[WI/2 -1:0]	a2  = a[2 ];
	wire	[WI/2 -1:0]	a3  = a[3 ];
	wire	[WI/2 -1:0]	a4  = a[4 ];
	wire	[WI/2 -1:0]	a5  = a[5 ];
	wire	[WI/2 -1:0]	a6  = a[6 ];
	wire	[WI/2 -1:0]	a7  = a[7 ];
	wire	[WI/2 -1:0]	a8  = a[8 ];
	wire	[WI/2 -1:0]	a9  = a[9 ];
	wire	[WI/2 -1:0]	a10 = a[10];
	wire	[WI/2 -1:0]	a11 = a[11];
	wire	[WI/2 -1:0]	a12 = a[12];
	wire	[WI/2 -1:0]	a13 = a[13];

	assign 	root_en = en_d[WI/2];
	assign 	root = a[WI/2];
	assign 	remainder = radical_d[WI/2] - root*root ;
	wire	[WI-1:0] 	radical_o = radical_d[WI/2];
endmodule



module sqrt_root2 #(parameter WI = 26)(
	input					clk,
	input 					rstn,
	input 					en,
	input 		[WI-1:0]	radical,
	output reg					root_en,		
	output reg		[WI/2 -1:0]	root,		
	output		[WI/2:0]	remainder
	);
	
	parameter W_CNT_BITS = $clog2(WI);
	

	wire	[WI/2 :0] [WI/2 -1:0]	bit_shift;
	wire	[WI/2 -1:0] one	= 1;
	reg	[WI+2:0][WI-1:0]	radical_d;
	always @(*)	radical_d[0] = radical;
	always @(`CLK_RST_EDGE)
		if (`RST)	radical_d[WI+2:1] <= 0;
		else 		radical_d[WI+2:1] <= radical_d;
		
	reg	[WI+2:0]	en_d;
	always @(*)	en_d[0] = en;
	always @(`CLK_RST_EDGE)
		if (`RST)	en_d[WI+2:1] <= 0;
		else 		en_d[WI+2:1] <= en_d;
		
	// should let a*a - b in a stange 
	// gt 0 or not be combinional
	reg		 [WI/2 -1:0]	tmp_res; 
	reg						tmp_res_gt;
	always @(`CLK_RST_EDGE)
		if (`RST)	tmp_res_gt <= 0;
		else 		tmp_res_gt <= tmp_res*tmp_res >  radical;
	
	//go	+|
	//max_f  					 +|
	//en	 |++++++++++++++++++++|
	//cnt	 |0..............MAX-1| MAX	
	wire	cnt_bits_go = en;	
	reg						cnt_bits_e;
	reg		[ W_CNT_BITS:0]		cnt_bits;
	wire				cnt_bits_max_f = cnt_bits == WI-1;
	always @(`CLK_RST_EDGE)
		if (`RST)					cnt_bits_e <= 0;
		else if (cnt_bits_go)		cnt_bits_e <= 1;
		else if (cnt_bits_max_f)	cnt_bits_e <= 0;
	
	always @(`CLK_RST_EDGE)
		if (`RST)	cnt_bits <= 0;
		else 		cnt_bits <= cnt_bits_e? cnt_bits + 1 : 0;

	always @(`CLK_RST_EDGE)
		if (`RST)				tmp_res <= 0;
		else if (cnt_bits_go)	tmp_res <= one << (WI/2 -1);
		else if (cnt_bits[0])	
			if (tmp_res_gt)	
				tmp_res <= tmp_res ^ (one << (WI/2 -1 -cnt_bits[W_CNT_BITS:1]));
			else 
				tmp_res <= tmp_res;
		else if (!cnt_bits[0])	
			//if (cnt_bits[])
				tmp_res <= tmp_res | (one << (WI/2 - 2 -cnt_bits[W_CNT_BITS:1]));  // the last cycle cnt_bits[W_CNT_BITS:1] = WI/2 -1  will one << -1;
	
	reg	[7:0]	cnt_bits_max_f_d;
	always @(*)	cnt_bits_max_f_d[0] = cnt_bits_max_f;
	always @(`CLK_RST_EDGE)
		if (`RST)	cnt_bits_max_f_d[7:1] <= 0;
		else 		cnt_bits_max_f_d[7:1] <= cnt_bits_max_f_d;
	
	//assign 	root_en = cnt_bits_max_f_d[1];
	
	always @(`CLK_RST_EDGE)
		if (`RST)	root_en <= 0;
		else 		root_en <= cnt_bits_max_f_d[1];
	always @(`CLK_RST_EDGE)
		if (`RST)						root <= 0;
		else if (cnt_bits_max_f_d[1])	root <= tmp_res;
		
	assign 	remainder = radical_d[WI+2] - root*root ;
	wire	[WI-1:0] 	radical_o = radical_d[WI];
endmodule



	