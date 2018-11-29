// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

`include "global.v"

module vj_fetch(
	input							clk,
	input							rstn,
	input	[`W_PW:0]				pic_width,
	input	[`W_PH:0]				pic_height,
	input	[4:0]					step,
	
	input							vj_fetch_go,
	output reg	[`W1P*`W_SIZE-1:0]	pixels,
	output reg						pixels_en,
	output reg						vj_row_init,
	input							ready_for_next_col,				
	input							cascade_end,
	input							col_end,
	output reg		[`W_PW:0]		vj_col,
	output reg		[`W_PH:0]		vj_row,
	output reg						vj_frame_ready,
	
	output reg		[`W_AFRAMEBUF:0]	aa_frame_buf,     // 512x512 8bit
	output reg							cena_frame_buf,
	input		[`W1:0]					qa_frame_buf,
	
	input								face_detected
	);
	
	
	
	
	reg		[`W_PW:0]	pic_width_r;
	reg		[`W_PH:0]	pic_height_r;
	always @(`CLK_RST_EDGE)
		if (`RST)	{ pic_width_r, pic_height_r} <= -1;
		else if (vj_fetch_go) begin
			pic_width_r <= pic_width;
			pic_height_r <= pic_height;
		end
	
	
	
	// initial fetch 24 coloum 
	// reg		[`W_PW:0]		vj_col;
	// reg		[`W_PH:0]		vj_row;
	reg		[`W_PW:0]		read_col;
	reg		[`W_PH:0]		read_row;
		
	wire	coloum_ready;
	wire	row_init_ready;
	//reg		row_init_go;

	reg		vj_row_ready;
	// reg		vj_frame_ready;
	wire	row_init_go = vj_fetch_go | vj_row_ready&(vj_row != pic_height_r-`W_SIZE);
	always@* vj_row_init = row_init_go;
	reg		coloum_fetch_go;
	always @(`CLK_RST_EDGE)
		if (`RST)	vj_row_ready <= 0;
		else 		vj_row_ready <= cascade_end & (vj_col == pic_width_r-`W_SIZE);
	always @(`CLK_RST_EDGE)
		if (`RST)	vj_frame_ready <= 0;
		else 		vj_frame_ready <= vj_row_ready & (vj_row == pic_height_r-`W_SIZE);
	
	always @(`CLK_RST_EDGE)
		if (`RST)					vj_col <= 0;
		else if (row_init_go)		vj_col <= 0;
		else if (cascade_end)		vj_col <= vj_col + 1;
		
	always @(`CLK_RST_EDGE)
		if (`RST)					vj_row <= 0;
		else if (vj_fetch_go) 		vj_row <= 0;	
		else if (row_init_go)		vj_row <= vj_row + 1;	

	//go	+|
	//max_f  					 +|
	//en	 |++++++++++++++++++++|
	//cnt	 |0..............MAX-1| MAX		
	reg					cnt_row_init_e;
	reg		[ 4 :0]		cnt_row_init;
	wire				cnt_row_init_max_f = cnt_row_init == `W_SIZE -1;
	always @(`CLK_RST_EDGE)
		if (`RST)						cnt_row_init_e <= 0;
		else if (row_init_go)			cnt_row_init_e <= 1;
		else if (cnt_row_init_max_f&coloum_ready)	cnt_row_init_e <= 0;
	
	always @(`CLK_RST_EDGE)
		if (`RST)					cnt_row_init <= 0;
		else if(cnt_row_init_e)		cnt_row_init <= cnt_row_init + coloum_ready;
		else 						cnt_row_init <= 0;
	assign row_init_ready = cnt_row_init_max_f&coloum_ready;
	
	
	always @(`CLK_RST_EDGE)
		if (`RST)														coloum_fetch_go <= 0;
		else if (row_init_go)											coloum_fetch_go <= 1;
		else if (cnt_row_init_e & coloum_ready &!cnt_row_init_max_f)  	coloum_fetch_go <= 1;   // 24 times
		else if (ready_for_next_col && read_col < pic_width_r)			coloum_fetch_go <= 1;
		else 															coloum_fetch_go <= 0;
	reg		[7:0]	coloum_fetch_go_d;
	always @(*)	coloum_fetch_go_d[0] = coloum_fetch_go;
	always @(`CLK_RST_EDGE)
		if (`RST)	coloum_fetch_go_d[7:1] <= 0;
		else 		coloum_fetch_go_d[7:1] <= coloum_fetch_go_d;
		
		
		
	//go	+|
	//max_f  					 +|
	//en	 |++++++++++++++++++++|
	//cnt	 |0..............MAX-1| 0		
	reg					cnt_fetch_e;
	reg		[ 4 :0]		cnt_fetch;
	wire				cnt_fetch_max_f = cnt_fetch == `W_SIZE-1;
	always @(`CLK_RST_EDGE)
		if (`RST)					cnt_fetch_e <= 0;
		else if (coloum_fetch_go)		cnt_fetch_e <= 1;
		else if (cnt_fetch_max_f)	cnt_fetch_e <= 0;
	
	always @(`CLK_RST_EDGE)
		if (`RST)	cnt_fetch <= 0;
		else if(cnt_fetch_e)		cnt_fetch <= cnt_fetch_max_f? 0: cnt_fetch + 1;
	reg		[7:0]	cnt_fetch_max_f_d;
	always @(*)	cnt_fetch_max_f_d[0] = cnt_fetch_max_f;
	always @(`CLK_RST_EDGE)
		if (`RST)	cnt_fetch_max_f_d[7:1] <= 0;
		else 		cnt_fetch_max_f_d[7:1] <= cnt_fetch_max_f_d;
	reg		[7:0]	cnt_fetch_e_d;
	always @(*)	cnt_fetch_e_d[0] = cnt_fetch_e;
	always @(`CLK_RST_EDGE)
		if (`RST)	cnt_fetch_e_d[7:1] <= 0;
		else 		cnt_fetch_e_d[7:1] <= cnt_fetch_e_d;
	reg		[7:0][4:0]	cnt_fetch_d;
	always @(*)	cnt_fetch_d[0] = cnt_fetch;
	always @(`CLK_RST_EDGE)
		if (`RST)	cnt_fetch_d[7:1] <= 0;
		else 		cnt_fetch_d[7:1] <= cnt_fetch_d;
		
	assign coloum_ready = cnt_fetch_max_f;
	
	always @(`CLK_RST_EDGE)
		if (`RST)						read_col <= 0;
		else if(row_init_go)			read_col <= 0;
		else if (cnt_fetch_max_f_d[1])	read_col <= read_col + 1;
		
	always @(`CLK_RST_EDGE)
		if (`RST)						read_row <= 0;
		else 							read_row <= vj_row + cnt_fetch;
	
	reg		[`W_FRAME_COL+1:0] 	read_col_addr;
	reg		[`W_FRAME_ROW+1:0] 	vj_row_addr;
	reg		[`W_FRAME_ROW+1:0] 	read_row_addr;
	// here need use accumulate not multiply
	reg		[`W_AFRAMEBUF:0] 	row_step;	
	always @(`CLK_RST_EDGE)
		if (`RST)	row_step <= 0;
		else		row_step <= step*`FRAME_BUF_LINE;  // just shift  not mupltiply
	
	always @(`CLK_RST_EDGE)
		if (`RST)						read_col_addr <= 0;
		else if(row_init_go)			read_col_addr <= 0;	
		else if(cnt_fetch_max_f_d[1]) 	read_col_addr <= read_col_addr + step;	
	
	always @(`CLK_RST_EDGE)
		if (`RST)					vj_row_addr <= 0;
		else if (vj_fetch_go) 		vj_row_addr <= 0;	
		else if (row_init_go)		vj_row_addr <= vj_row_addr + step;	
	
	always @(`CLK_RST_EDGE)
		if (`RST)						read_row_addr <= 0;
		else if(coloum_fetch_go_d[1])	read_row_addr <= vj_row_addr;
		else if(cnt_fetch_e_d[1]) 		read_row_addr <= read_row_addr + step;	
	

	always @(`CLK_RST_EDGE)
		if (`RST)	aa_frame_buf <= 0;
	//	else		aa_frame_buf <= read_row_addr + read_col_addr;
		else		aa_frame_buf <= {read_row_addr[`W_FRAME_ROW+1:1], read_col_addr[`W_FRAME_COL+1 : 1]};
		
	// always @(`CLK_RST_EDGE)
		// if (`ZST)	aa_frame_buf <= 0;
		// else 		aa_frame_buf <= read_row*step*`FRAME_BUF_LINE + read_col*step;
		
	always @(`CLK_RST_EDGE)
		if (`RST)	cena_frame_buf <= 1;
		else 		cena_frame_buf <= ~cnt_fetch_e_d[1];
	
	reg		[7:0][`W1:0]	qa_frame_buf_d;
	always @(*)	qa_frame_buf_d[0] = qa_frame_buf;
	always @(`CLK_RST_EDGE)
		if (`RST)	qa_frame_buf_d[7:1] <= 0;
		else 		qa_frame_buf_d[7:1] <= qa_frame_buf_d;
	
	reg		[0:`W_SIZE-1][`W1:0]	pixels_alias;
	always @(`CLK_RST_EDGE)
		if (`RST)	pixels_alias <= 0;
		else if (cnt_fetch_e_d[4])
			pixels_alias[cnt_fetch_d[4]] <= qa_frame_buf_d[1];
	always@*	pixels = pixels_alias;
	always @(`CLK_RST_EDGE)
		if (`RST)	pixels_en <= 0;
		else 		pixels_en <= cnt_fetch_max_f_d[4];
	

endmodule

	