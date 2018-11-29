// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

`include "global.v"

module draw(
	input					clk,
	input					rstn,
	input					add_sq,
	input					clear,
	input					update,
	output					sorting,
	input		[`W_PW:0]	pic_width,
	input		[`W_PH:0]	pic_height,
	input		[`W_PW:0]	x,
	input		[`W_PH:0]	y,
	input		[`W_PW:0]	w, 
	input		[`W_PH:0]	h, 
	input		[`W_PW:0]	cnt_h, 
	input		[`W_PH:0]	cnt_v, 
	input					vsync,
	input					hsync,
	input					de,
	output	reg				vsync_o,
	output	reg				hsync_o,
	output	reg				de_o,
	output	reg				q
	);
	
	
	//pt0 1 2 3
	wire	[7:0]	total;
	reg		[`W_PW+`W_PH+1:0]	new_pt0, new_pt1, new_pt2, new_pt3;
	// wire	[`W_PW:0] 	x1 = x + w;
	// wire	[`W_PH:0] 	y1 = y + h;
	
	reg	[`W_PW+1:0] 	x1;
	reg	[`W_PH+1:0] 	y1;
	reg				add_pt0, add_pt1, add_pt2, add_pt3; 
	reg    [7:0][`W_PW:0]    x_d;
	always @(*)    x_d[0] = x;
	always @(`CLK_RST_EDGE)
		if (`RST)    x_d[7:1] <= 0;
		else         x_d[7:1] <= x_d;
	reg    [7:0][`W_PH:0]    y_d;
	always @(*)    y_d[0] = y;
	always @(`CLK_RST_EDGE)
		if (`RST)    y_d[7:1] <= 0;
		else         y_d[7:1] <= y_d;
	reg	[7:0][`W_PW+1:0]	x1_d;
	always @(*)	x1_d[0] = x1;
	always @(`CLK_RST_EDGE)
		if (`RST)	x1_d[7:1] <= 0;
		else 		x1_d[7:1] <= x1_d;
	reg	[7:0][`W_PH+1:0]	y1_d;
	always @(*)	y1_d[0] = y1;
	always @(`CLK_RST_EDGE)
		if (`RST)	y1_d[7:1] <= 0;
		else 		y1_d[7:1] <= y1_d;
	
	wire 	add_sq_valid = add_sq & total != `MAX_PT-1;
	reg	[7:0]	add_sq_d;
	always @(*)	add_sq_d[0] = add_sq_valid;
	always @(`CLK_RST_EDGE)
		if (`RST)	add_sq_d[7:1] <= 0;
		else 		add_sq_d[7:1] <= add_sq_d;
		
	always @(`CLK_RST_EDGE)
		if (`ZST)	{x1, y1} <= 0;
		else begin
			x1 <= x + w;
			y1 <= y + h;		
		end
	
	reg		x_lt_width;
	reg		x1_lt_width;
	always @(`CLK_RST_EDGE)
		if (`RST)	{x_lt_width, x1_lt_width} <= 0;
		else begin
			// x_lt_width = x_d[1] <= width_m1;
			// x1_lt_width = x1 <= width_m1;
			x_lt_width <= x_d[1] < pic_width;
			x1_lt_width <= x1 < pic_width;	
		end
	
	always @(`CLK_RST_EDGE)
		if (`RST)	{add_pt0, add_pt1, add_pt2, add_pt3} <= 0;
		else begin
			add_pt0 <= x_lt_width  & add_sq_d[2];
			add_pt2 <= x_lt_width  & add_sq_d[2];
			add_pt1 <= x1_lt_width & add_sq_d[2];
			add_pt3 <= x1_lt_width & add_sq_d[2];
		end
		
	always @(`CLK_RST_EDGE)
		if (`RST)	new_pt0 <= 0;
		else 		new_pt0 <= {y_d[2],x_d[2]};
	always @(`CLK_RST_EDGE)
		if (`RST)	new_pt1 <= 0;
		else 		new_pt1 <= {y_d[2],x1_d[1][`W_PW:0] };
	always @(`CLK_RST_EDGE)
		if (`RST)	new_pt2 <= 0;
		else 		new_pt2 <= {y1_d[1],x_d[2]};
	always @(`CLK_RST_EDGE)
		if (`RST)	new_pt3 <= 0;
		else 		new_pt3 <= {y1_d[1],x1_d[1][`W_PW:0]};
	

	
	
	wire	[`W_PW+`W_PH+1:0]	pt0, pt1, pt2, pt3 ;
	//wire	[31:0]	pt0, pt1, pt2, pt3 ;
	wire	[7:0]	pt_cnt0, pt_cnt1, pt_cnt2, pt_cnt3 ;
	wire	[31:0]	fifo_q0, fifo_q1, fifo_q2, fifo_q3 ;
	wire	[7:0]				index_rd0, index_rd1, index_rd2, index_rd3;
	//wire	[`W_PW+`W_PH+1:0]	qa_rd0, qa_rd1, qa_rd2, qa_rd3;
	wire	[31:0]	qa_rd0, qa_rd1, qa_rd2, qa_rd3;

	
	reg	[7:0][31:0]	fifo_q0_d;
	always @(*)	fifo_q0_d[0] = fifo_q0;
	always @(`CLK_RST_EDGE)
		if (`RST)	fifo_q0_d[7:1] <= 0;
		else 		fifo_q0_d[7:1] <= fifo_q0_d;
	reg	[7:0][31:0]	fifo_q1_d;
	always @(*)	fifo_q1_d[0] = fifo_q1;
	always @(`CLK_RST_EDGE)
		if (`RST)	fifo_q1_d[7:1] <= 0;
		else 		fifo_q1_d[7:1] <= fifo_q1_d;
	reg	[7:0][31:0]	fifo_q2_d;
	always @(*)	fifo_q2_d[0] = fifo_q2;
	always @(`CLK_RST_EDGE)
		if (`RST)	fifo_q2_d[7:1] <= 0;
		else 		fifo_q2_d[7:1] <= fifo_q2_d;
	reg	[7:0][31:0]	fifo_q3_d;
	always @(*)	fifo_q3_d[0] = fifo_q3;
	always @(`CLK_RST_EDGE)
		if (`RST)	fifo_q3_d[7:1] <= 0;
		else 		fifo_q3_d[7:1] <= fifo_q3_d;

	assign 	pt0 = fifo_q0;
	assign 	pt1 = fifo_q1;
	assign 	pt2 = fifo_q2;
	assign 	pt3 = fifo_q3;
	
	reg    [31:0]    update_d;
	always @(*)    update_d[0] = update;
	always @(`CLK_RST_EDGE)
		if (`RST)    update_d[31:1] <= 0;
		else         update_d[31:1] <= update_d;
	reg    [7:0]    vsync_d;
	always @(*)    vsync_d[0] = vsync;
	always @(`CLK_RST_EDGE)
		if (`RST)    vsync_d[7:1] <= 0;
		else         vsync_d[7:1] <= vsync_d;
		
	wire	vsync_falling = !vsync & vsync_d[1];
	reg    [7:0]    hsync_d;
	always @(*)    hsync_d[0] = hsync;
	always @(`CLK_RST_EDGE)
		if (`RST)    hsync_d[7:1] <= 0;
		else         hsync_d[7:1] <= hsync_d;
	reg    [7:0]    de_d;
	always @(*)    de_d[0] = de;
	always @(`CLK_RST_EDGE)
		if (`RST)    de_d[7:1] <= 0;
		else         de_d[7:1] <= de_d;
	reg    [7:0][`W_PW:0]    cnt_h_d;
	always @(*)    cnt_h_d[0] = cnt_h;
	always @(`CLK_RST_EDGE)
		if (`RST)    cnt_h_d[7:1] <= 0;
		else         cnt_h_d[7:1] <= cnt_h_d;
	reg    [7:0][`W_PH:0]    cnt_v_d;
	always @(*)    cnt_v_d[0] = cnt_v;
	always @(`CLK_RST_EDGE)
		if (`RST)    cnt_v_d[7:1] <= 0;
		else         cnt_v_d[7:1] <= cnt_v_d;
	
	
	reg				updated;
	always @(`CLK_RST_EDGE)
		if (`RST)				updated <= 0;
		else if (update) 		updated <= 1;
	reg				drawing;
	always @(`CLK_RST_EDGE)
		if (`RST)							drawing <= 0;
		else if (updated & vsync_falling) 	drawing <= 1;
	
	
	wire		fifo_req0, fifo_req1, fifo_req2, fifo_req3;
	wire		fifo_init = updated & vsync_falling;
	
	// read sram should be pingpong
	rd_fifo rd_fifo0(
		.clk			(clk),
		.rstn			(rstn),
		.fifo_init_go	(fifo_init),
		.fifo_req		(fifo_req0),
		.pt				(fifo_q0),
		.rd_index		(index_rd0),
		.rd_qa			(qa_rd0)
		);
	rd_fifo rd_fifo1(
		.clk			(clk),
		.rstn			(rstn),
		.fifo_init_go	(fifo_init),
		.fifo_req		(fifo_req1),
		.pt				(fifo_q1),
		.rd_index		(index_rd1),
		.rd_qa			(qa_rd1)
		);
	rd_fifo rd_fifo2(
		.clk			(clk),
		.rstn			(rstn),
		.fifo_init_go	(fifo_init),
		.fifo_req		(fifo_req2),
		.pt				(fifo_q2),
		.rd_index		(index_rd2),
		.rd_qa			(qa_rd2)
		);
	rd_fifo rd_fifo3(
		.clk			(clk),
		.rstn			(rstn),
		.fifo_init_go	(fifo_init),
		.fifo_req		(fifo_req3),
		.pt				(fifo_q3),
		.rd_index		(index_rd3),
		.rd_qa			(qa_rd3)
		);
	

		
	wire	[`W_PW+`W_PH+1:0]		cur_pt = {cnt_v, cnt_h};
	assign fifo_req0 = (drawing&de) && (cur_pt>=pt0)	;
	assign fifo_req1 = (drawing&de) && (cur_pt>=pt1)	;
	assign fifo_req2 = (drawing&de) && (cur_pt>=pt2)	;
	assign fifo_req3 = (drawing&de) && (cur_pt>=pt3)	;

	reg		[7:0]	horline_cnt;
	

	// wire			cur_eq_pt0 =  pt0 <= cur_pt; 
	// wire			cur_eq_pt1 =  pt1 <= cur_pt; 
	// wire			cur_eq_pt2 =  pt2 <= cur_pt; 
	// wire			cur_eq_pt3 =  pt3 <= cur_pt; 

	reg		cur_eq_pt0, cur_eq_pt1, cur_eq_pt2,cur_eq_pt3;
	
	always @(`CLK_RST_EDGE)
		if (`RST)	{cur_eq_pt0, cur_eq_pt1, cur_eq_pt2,cur_eq_pt3} <= 0;
		else begin
			cur_eq_pt0 <=  pt0 <= cur_pt; 
			cur_eq_pt1 <=  pt1 <= cur_pt; 		
			cur_eq_pt2 <=  pt2 <= cur_pt; 		
			cur_eq_pt3 <=  pt3 <= cur_pt; 		
		end
	
	
	reg    			hor_start_pt, hor_end_pt, ver_start_pt, ver_end_pt;
	reg  [7:0]  	hor_start_pt_cnt, hor_end_pt_cnt, ver_start_pt_cnt, ver_end_pt_cnt;
	always @(`CLK_RST_EDGE)
		if (`RST)    {hor_start_pt, hor_end_pt, ver_start_pt, ver_end_pt} <= 0;
		else  begin
			hor_start_pt <=  cur_eq_pt0 || cur_eq_pt2; 
			hor_end_pt   <=  cur_eq_pt1 || cur_eq_pt3; 
			ver_start_pt <=  cur_eq_pt0 || cur_eq_pt1; 		
			ver_end_pt   <=  cur_eq_pt2 || cur_eq_pt3;  	
		end
	assign 	pt_cnt0 = cur_eq_pt0? (fifo_q0_d[1][`W_PW+`W_PH+1+1 +:8]+1):0;
	assign 	pt_cnt1 = cur_eq_pt1? (fifo_q1_d[1][`W_PW+`W_PH+1+1 +:8]+1):0;
	assign 	pt_cnt2 = cur_eq_pt2? (fifo_q2_d[1][`W_PW+`W_PH+1+1 +:8]+1):0;
	assign 	pt_cnt3 = cur_eq_pt3? (fifo_q3_d[1][`W_PW+`W_PH+1+1 +:8]+1):0;
	
	always @(`CLK_RST_EDGE)
		if (`RST) 	{hor_start_pt_cnt, hor_end_pt_cnt, ver_start_pt_cnt, ver_end_pt_cnt} <= 0;
		else begin
			hor_start_pt_cnt 	<= pt_cnt0 + pt_cnt2;
			hor_end_pt_cnt 		<= pt_cnt1 + pt_cnt3;
			ver_start_pt_cnt 	<= pt_cnt0 + pt_cnt1;
			ver_end_pt_cnt 		<= pt_cnt2 + pt_cnt3;
		end
		
	always @(`CLK_RST_EDGE)
		if (`RST)	horline_cnt <= 0;
		else if (de_d[2])
			horline_cnt <= horline_cnt +  hor_start_pt_cnt - hor_end_pt_cnt;
			// case({hor_start_pt, hor_end_pt})
				// 2'b10: horline_cnt <= horline_cnt+1;
				// 2'b01: horline_cnt <= horline_cnt-1;
			// endcase
		else 	horline_cnt <= 0;
	
	// ver_line
	reg		[10:0]	aa_line_buf;
	//reg				cena_line_buf;
	wire				cena_line_buf;
	reg		[10:0]	ab_line_buf;
	reg		[7:0]	db_line_buf;
	reg				cenb_line_buf;
	wire	[7:0]	qa_line_buf;
	
	rfdp2048x8 line_buf(
		.CLKA   (clk),
		.CENA   (cena_line_buf),
		.AA     (aa_line_buf),
		.QA     (qa_line_buf),
		.CLKB   (clk),
		.CENB   (cenb_line_buf),
		.AB     (ab_line_buf),
		.DB     (db_line_buf)
		);
	
	//always @(*) cena_line_buf = 1'b0;
	assign cena_line_buf = 1'b0;
	always @(*) aa_line_buf = cnt_h;
	
	reg	[7:0][10:0]	qa_line_buf_d;
	always @(*)	qa_line_buf_d[0] = qa_line_buf;
	always @(`CLK_RST_EDGE)
		if (`RST)	qa_line_buf_d[7:1] <= 0;
		else 		qa_line_buf_d[7:1] <= qa_line_buf_d;
		
	
	reg    [7:0]    cur_ver_cnt;
	reg    [7:0]    next_ver_cnt;
	
	
	always @(`CLK_RST_EDGE)
		if (`RST)   		 	cur_ver_cnt <= 0;
		// else if(cnt_v_d[1]==0)  cur_ver_cnt <= ver_start_pt;
		// else 				 	cur_ver_cnt <= qa_line_buf + ver_start_pt;
		else if(cnt_v_d[2]==0)  cur_ver_cnt <= ver_start_pt_cnt;
		else 				 	cur_ver_cnt <= qa_line_buf_d[1] + ver_start_pt_cnt;
	
	// draw one one pixel for the left below  point
	always @(`CLK_RST_EDGE)
		if (`RST)   		 	next_ver_cnt <= 0;
		// else if(cnt_v_d[1]==0)  next_ver_cnt <= ver_start_pt - ver_end_pt;
		// else 				 	next_ver_cnt <= qa_line_buf + ver_start_pt - ver_end_pt;
		else if(cnt_v_d[2]==0)  next_ver_cnt <= ver_start_pt_cnt - ver_end_pt_cnt;
		else 				 	next_ver_cnt <= qa_line_buf_d[1] + ver_start_pt_cnt - ver_end_pt_cnt;
	
	always @(`CLK_RST_EDGE)
		if (`RST)    db_line_buf <= 0;
	//	else         db_line_buf <= cur_ver_cnt;
		else         db_line_buf <= next_ver_cnt;
	always @(`CLK_RST_EDGE)
		if (`RST)    cenb_line_buf <= 1;
		else         cenb_line_buf <= ~de_d[3];
	always @(`CLK_RST_EDGE)
		if (`RST)    ab_line_buf <= 0;
		else         ab_line_buf <= cnt_h_d[3];
		
`ifdef DRAW_2PIXEL_WIDE


	// ver_line
	reg		[10:0]	aa_horline_buf;
	//reg				cena_horline_buf;
	wire				cena_horline_buf;
	reg		[10:0]	ab_horline_buf;
	reg		[7:0]	db_horline_buf;
	reg				cenb_horline_buf;
	wire	[7:0]	qa_horline_buf;
	
	rfdp2048x8 horline_buf(
		.CLKA   (clk),
		.CENA   (cena_horline_buf),
		.AA     (aa_horline_buf),
		.QA     (qa_horline_buf),
		.CLKB   (clk),
		.CENB   (cenb_horline_buf),
		.AB     (ab_horline_buf),
		.DB     (db_horline_buf)
		);
		
	always @(`CLK_RST_EDGE)
		if (`RST)    db_horline_buf <= 0;
		else         db_horline_buf <= horline_cnt;
	always @(`CLK_RST_EDGE)
		if (`RST)    cenb_horline_buf <= 1;
		else         cenb_horline_buf <= ~de_d[3];
	always @(`CLK_RST_EDGE)
		if (`RST)    ab_horline_buf <= 0;
		else         ab_horline_buf <= cnt_h_d[3];
	assign cena_horline_buf = 1'b0;
	always @(*) aa_horline_buf = cnt_h;
	
	reg		[7:0]		qa_horline_buf_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	qa_horline_buf_d1 <= 0;
		else 		qa_horline_buf_d1 <= qa_horline_buf;
		
	reg			horline_expand;
	always @(`CLK_RST_EDGE)
		if (`ZST)					horline_expand <= 0;
		else if (cnt_v_d[2]==0) 	horline_expand <= 0;
		else 						horline_expand <= |qa_horline_buf_d1;
	reg			horline_expand_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	horline_expand_d1 <= 0;
		else 		horline_expand_d1 <= horline_expand;

	reg		q_sp;
	reg		q_sp_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	q_sp_d1 <= 0;
		else 		q_sp_d1 <= q_sp;
		
	//always@*	q = q_sp || q_sp_d1 || horline_expand_d1;
	always@*	q = q_sp || q_sp_d1;
	always @(`CLK_RST_EDGE)
		if (`RST)	q_sp <= 0;
	//	else 		q <= horline_cnt != 0;
		else 		q_sp <= horline_cnt != 0 || cur_ver_cnt !=0 || horline_expand || horline_expand_d1;
`else
	always @(`CLK_RST_EDGE)
		if (`RST)	q <= 0;
	//	else 		q <= horline_cnt != 0;
		else 		q <= horline_cnt != 0 || cur_ver_cnt !=0;
`endif

	always @(`CLK_RST_EDGE)
		if (`RST)	de_o <= 0;
		else 		de_o <= de_d[3];
	always @(`CLK_RST_EDGE)
		if (`RST)	hsync_o <= 0;
		else 		hsync_o <= hsync_d[3];
	always @(`CLK_RST_EDGE)
		if (`RST)	vsync_o <= 0;
		else 		vsync_o <= vsync_d[3];
	
	wire 	sorting0, sorting1, sorting2, sorting3;
	//sort sort0(
	sort_with_eq sort0(
		.clk			(clk),
		.rstn			(rstn),
		.clear			(clear),
		.update			(update),
		.new_pt			(new_pt0),
		.add_pt			(add_pt0),
		.rd_init_go		(fifo_init),
		.index_rd		(index_rd0),
		.qa_rd			(qa_rd0),
		.sorting		(sorting0),
	    .total       	(total)
	);
	// sort sort1(
	sort_with_eq sort1(
		.clk			(clk),
		.rstn			(rstn),
		.clear			(clear),
		.update			(update),
		.new_pt			(new_pt1),
		.add_pt			(add_pt1),
		.rd_init_go		(fifo_init),
		.index_rd		(index_rd1),
		.qa_rd			(qa_rd1),
		.sorting		(sorting1),
	    .total       	()
	);
	// sort sort2(
	sort_with_eq sort2(
		.clk			(clk),
		.rstn			(rstn),
		.clear			(clear),
		.update			(update),
		.new_pt			(new_pt2),
		.add_pt			(add_pt2),
		.rd_init_go		(fifo_init),
		.index_rd		(index_rd2),
		.qa_rd			(qa_rd2),		
		.sorting		(sorting2),
	    .total       	()
	);
	// sort sort3(
	sort_with_eq sort3(
		.clk			(clk),
		.rstn			(rstn),
		.clear			(clear),
		.update			(update),
		.new_pt			(new_pt3),
		.add_pt			(add_pt3),
		.rd_init_go		(fifo_init),
		.index_rd		(index_rd3),
		.qa_rd			(qa_rd3),
		.sorting		(sorting3),
	    .total       	()
	);
	
	assign sorting = sorting0 | sorting1 | sorting2 | sorting3 | add_sq_d[1] |add_sq_d[2] |add_sq_d[3];

	
endmodule


module rd_fifo(
    input            				clk,
    input            				rstn,
	input							fifo_init_go,
	input							fifo_req,
	//output reg	[`W_PW+`W_PH+1:0]	pt,
	output reg	[31:0]				pt,
	output reg	[7:0]				rd_index,
	//input		[`W_PW+`W_PH+1:0]	rd_qa
	input		[31:0]				rd_qa
    );
	
	//reg							fifo_init_go, fifo_req;
	//reg		[`W_PW+`W_PH+1:0]	fifo_item0, fifo_item1, fifo_item2, fifo_item3;
	reg		[31:0]	fifo_item0, fifo_item1, fifo_item2, fifo_item3;
	//assign 		pt = fifo_item0;
	reg    [0:0]    fifo_init_e;
	always @(`CLK_RST_EDGE)
		if (`RST)    				  fifo_init_e <= 0;
		else if (fifo_init_go)        fifo_init_e <= 1;
		else if (rd_index==3) 		  fifo_init_e <= 0;
	reg    [7:0]    fifo_init_e_d;
	always @(*)    fifo_init_e_d[0] = fifo_init_e;
	always @(`CLK_RST_EDGE)
		if (`RST)    fifo_init_e_d[7:1] <= 0;
		else         fifo_init_e_d[7:1] <= fifo_init_e_d;
	reg    [7:0]    fifo_req_d;
	always @(*)    fifo_req_d[0] = fifo_req;
	always @(`CLK_RST_EDGE)
		if (`RST)    fifo_req_d[7:1] <= 0;
		else         fifo_req_d[7:1] <= fifo_req_d;

	
	// fifo_init_e     -		-
	// 0               1	2   3
	//aa               0   	1	2	3         
	//						qa0	1	2	3  
	// fifo_req
	// index_rd0		index_rd0 + 1
	//			 aa
	// 					qa_want			qa_prepare
	always @(`CLK_RST_EDGE)
		if (`RST)							rd_index <= 0;
		else if (fifo_init_go)				rd_index <= 0;
		else if (fifo_init_e | fifo_req)	rd_index <= rd_index + 1;
	
	wire 	fifo_semaphore_inc ;
	wire 	fifo_semaphore_dec ;
	reg    [2:0]    fifo_semaphore;
	
	reg    [1:0]    fifo_head, fifo_tail;
	reg		[1:0]	fifo_head_next;
	always @(*) 
		if (fifo_init_go) fifo_head_next = 0;
		else			  fifo_head_next = fifo_head + fifo_req;
	
	always @(`CLK_RST_EDGE)
		if (`RST) 				fifo_head <= 0;
		else 					fifo_head <= fifo_head_next;
	
	// always @(`CLK_RST_EDGE)
		// if (`RST) 				fifo_head <= 0;
		// else if (fifo_init_go) 	fifo_head <= 0;
		// else if (fifo_req)		fifo_head <= fifo_head + 1;
	
	wire	fifo_inc = fifo_init_e_d[2] | fifo_req_d[2];
	always @(`CLK_RST_EDGE)
		if (`RST) 				fifo_tail <= 0;
		else if (fifo_init_go) 	fifo_tail <= 0;
		else if (fifo_inc)		fifo_tail <= fifo_tail + 1;
	
	// always @(*)   
		// case(fifo_head)
		// 2'b00 :	 pt = fifo_item0;
		// 2'b01 :	 pt = fifo_item1;
		// 2'b10 :	 pt = fifo_item2;
		// 2'b11 :	 pt = fifo_item3;
		// endcase
	always @(`CLK_RST_EDGE)
		if (`ZST)	pt <= 0;
		else case(fifo_head_next)
			2'b00 :	 pt <= fifo_item0;
			2'b01 :	 pt <= fifo_item1;
			2'b10 :	 pt <= fifo_item2;
			2'b11 :	 pt <= fifo_item3;
			endcase

	always @(`CLK_RST_EDGE)
		if (`RST)    {fifo_item0, fifo_item1, fifo_item2, fifo_item3} <= -1;	
		else if ( fifo_inc) 
			case (fifo_tail)
			2'b00 :	 fifo_item0 <= rd_qa;
			2'b01 :	 fifo_item1 <= rd_qa;
			2'b10 :	 fifo_item2 <= rd_qa;
			2'b11 :	 fifo_item3 <= rd_qa;
			endcase
		
					
endmodule


	

module sort(
	input					clk,
	input					rstn,
	input					clear,
//	input		[`W_PW:0]	x,
//	input		[`W_PH:0]	y,
	input	[`W_PW+`W_PH+1:0]	new_pt,
	input					add_pt,
	input	[7:0]			index_rd,
	output	[`W_PW+`W_PH+1:0]	qa_rd,
	
	output reg				sorting,
	output reg	[7:0]		total
	
	
	
	);
	
	
	reg		sort_done;
	reg		shifting;
	//wire	[23:0]	new_pt = {y,x};
	
	reg		[`W_PW+`W_PH+1:0]	new_pt_r;
	always @(`CLK_RST_EDGE)
		if (`RST)			new_pt_r <= 0;
		else if (add_pt)	new_pt_r <= new_pt;
		
	always @(`CLK_RST_EDGE)
		if (`RST)			total <= 0;
		else if (clear) 	total <= 0;
		else if (sort_done) total <= total + 1;
	always @(`CLK_RST_EDGE)
		if (`RST)			sorting <= 0;
		else if (add_pt)	sorting <= 1;
		else if (sort_done)	sorting <= 0;
	
	
	reg		[7:0]	aa_data_buf;
	reg				cena_data_buf;
	reg		[7:0]	ab_data_buf;
	reg		[23:0]	db_data_buf;
	reg				cenb_data_buf;
	wire	[23:0]	qa_data_buf;
	
	reg	[7:0][7:0]	aa_data_buf_d;
	always @(*)	aa_data_buf_d[0] = aa_data_buf;
	always @(`CLK_RST_EDGE)
		if (`RST)	aa_data_buf_d[7:1] <= 0;
		else 		aa_data_buf_d[7:1] <= aa_data_buf_d;
	reg	[7:0][23:0]	qa_data_buf_d;
	always @(*)	qa_data_buf_d[0] = qa_data_buf;
	always @(`CLK_RST_EDGE)
		if (`RST)	qa_data_buf_d[7:1] <= 0;
		else 		qa_data_buf_d[7:1] <= qa_data_buf_d;
		
	rfdp256x24 data_buf(
		.CLKA   (clk),
	//	.CENA   (cena_data_buf),
		.CENA   (1'b0),
		.AA     (aa_data_buf),
		.QA     (qa_data_buf),
		.CLKB   (clk),
		.CENB   (cenb_data_buf),
		.AB     (ab_data_buf),
		.DB     (db_data_buf)
		);
	
	reg		inc_aa;
	wire go_inc_aa = add_pt;
	wire end_inc_aa = qa_data_buf>new_pt_r && inc_aa;
	reg		[7:0]	inser_addr;
	
	reg	[7:0]	end_inc_aa_d;
	always @(*)	end_inc_aa_d[0] = end_inc_aa;
	always @(`CLK_RST_EDGE)
		if (`RST)	end_inc_aa_d[7:1] <= 0;
		else 		end_inc_aa_d[7:1] <= end_inc_aa_d;
	
	wire  go_shift = end_inc_aa_d[2];
	reg	[7:0]	go_shift_d;
	always @(*)	go_shift_d[0] = go_shift;
	always @(`CLK_RST_EDGE)
		if (`RST)	go_shift_d[7:1] <= 0;
		else 		go_shift_d[7:1] <= go_shift_d;
	reg	[7:0]	shifting_d;
	always @(*)	shifting_d[0] = shifting;
	always @(`CLK_RST_EDGE)
		if (`RST)	shifting_d[7:1] <= 0;
		else 		shifting_d[7:1] <= shifting_d;
		

	wire	end_shift = aa_data_buf==`MAX_PT-1 && shifting;
	always @(`CLK_RST_EDGE)
		if (`RST)				shifting <= 0;
		else if (go_shift)		shifting <= 1;
		else if (end_shift)		shifting <= 0;
		
	
	always @(`CLK_RST_EDGE)
		if (`RST)				cena_data_buf <= 1;
		else if (go_inc_aa)		cena_data_buf <= 0;
		else if (end_inc_aa)	cena_data_buf <= 1;
		else if (go_shift)		cena_data_buf <= 0;
		else if (end_shift)		cena_data_buf <= 1;
	
	always @(`CLK_RST_EDGE)
		if (`RST)			aa_data_buf <= 0;
	//	else if (!sorting)	aa_data_buf <= 0;
		else if (go_inc_aa)	aa_data_buf <= 0;
		else if (inc_aa)	aa_data_buf <= aa_data_buf + 1;
		else if (go_shift)	aa_data_buf <= inser_addr;	
		else if (shifting)	aa_data_buf <= aa_data_buf + 1;
	//	else 				aa_data_buf <= 0;
		else 				aa_data_buf <= index_rd;
	
	assign qa_rd = qa_data_buf;
	
	always @(`CLK_RST_EDGE)
		if (`RST)				inc_aa <= 0;
		else if (go_inc_aa)		inc_aa <= 1;
		else if (end_inc_aa)	inc_aa <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)				inser_addr <= 0;
		else if (end_inc_aa)	inser_addr <= aa_data_buf_d[1];	
		
	// 1 比较
	always @(`CLK_RST_EDGE)
		if (`RST)						cenb_data_buf <= 1;
		else if (clear)					cenb_data_buf <= 0;
		else if (shifting_d[1])			cenb_data_buf <= 0;
		//else if (shifting)				cenb_data_buf <= 0;
		else 							cenb_data_buf <= 1;	
		
	always @(`CLK_RST_EDGE)
		if (`RST)						ab_data_buf <= 0;
		else if (clear)					ab_data_buf <= 0;	
	//	else if (shifting)				ab_data_buf <= aa_data_buf_d[1];	
		else if (shifting_d[1])			ab_data_buf <= aa_data_buf_d[1];	

	always @(`CLK_RST_EDGE)
		if (`RST)						db_data_buf <= 0;
		else if (clear)					db_data_buf <= -1;	
		else if (go_shift_d[2])			db_data_buf <= 	new_pt_r;
	//	else if (shifting_d[1])			db_data_buf <= 	qa_data_buf_d[2];
		else if (shifting_d[1])			db_data_buf <= 	qa_data_buf_d[1];
		
	always @(`CLK_RST_EDGE)
		if (`RST)	sort_done <= 0;
		else 		sort_done <= end_shift;
	
endmodule


module sort_with_eq(
	input					clk,
	input					rstn,
	input					clear,
	input					update,
	
//	input		[`W_PW:0]	x,
//	input		[`W_PH:0]	y,
	input	[`W_PW+`W_PH+1:0]	new_pt,
	input					add_pt,
	input					rd_init_go,
	input	[7:0]			index_rd,
	output	[31:0]			qa_rd,
	
	output reg				sorting,
	output reg	[7:0]		total
	
	
	
	);
	
	
	wire	clear_all = clear | update;
	reg		sort_done;
	reg		shifting;
	//wire	add_pt_valid = add_pt & total < `MAX_PT;
	//wire	[23:0]	new_pt = {y,x};
	reg		[`W_PW+`W_PH+1:0]	new_pt_r;
	always @(`CLK_RST_EDGE)
		if (`RST)			new_pt_r <= 0;
		else if (add_pt)	new_pt_r <= new_pt;
	
	always @(`CLK_RST_EDGE)
		if (`RST)			total <= 0;
		else if (clear_all) 	total <= 0;
		else if (sort_done) total <= total + 1;
	always @(`CLK_RST_EDGE)
		if (`RST)			sorting <= 0;
		else if (add_pt)	sorting <= 1;
	//	else if (add_pt_valid)	sorting <= 1;
		else if (sort_done)	sorting <= 0;
	
	
	reg		[7:0]	aa_data_buf;
	reg				cena_data_buf;
	reg		[7:0]	ab_data_buf;
	reg		[31:0]	db_data_buf;
	reg				cenb_data_buf;
	wire	[31:0]	qa_data_buf;
	
	reg	[7:0][7:0]	aa_data_buf_d;
	always @(*)	aa_data_buf_d[0] = aa_data_buf;
	always @(`CLK_RST_EDGE)
		if (`RST)	aa_data_buf_d[7:1] <= 0;
		else 		aa_data_buf_d[7:1] <= aa_data_buf_d;
	reg	[7:0]	cena_data_buf_d;
	always @(*)	cena_data_buf_d[0] = cena_data_buf;
	always @(`CLK_RST_EDGE)
		if (`RST)	cena_data_buf_d[7:1] <= 0;
		else 		cena_data_buf_d[7:1] <= cena_data_buf_d;
		
	
	reg	[7:0][31:0]	qa_data_buf_d;
	always @(*)	qa_data_buf_d[0] = qa_data_buf;
	always @(`CLK_RST_EDGE)
		if (`RST)	qa_data_buf_d[7:1] <= 0;
//`ifdef SIMULATING
//		else  if (cena_data_buf_d[1])		qa_data_buf_d[7:1] <= qa_data_buf_d;
//`else
		else 		qa_data_buf_d[7:1] <= qa_data_buf_d;
//`endif
		
	rfdp256x32 data_buf(
		.CLKA   (clk),
	//	.CENA   (cena_data_buf),
		.CENA   (1'b0),
		.AA     (aa_data_buf),
		.QA     (qa_data_buf),
		.CLKB   (clk),
		.CENB   (cenb_data_buf),
		.AB     (ab_data_buf),
		.DB     (db_data_buf)
		);
	
	
	reg		[1:0]	aa_data_rd_buf_rid;
	reg		[1:0]	ab_data_rd_buf_wid;
	reg				wid_updated;
	
	reg		[9:0]	aa_data_rd_buf;
	reg				cena_data_rd_buf;
	reg		[9:0]	ab_data_rd_buf;
	reg		[31:0]	db_data_rd_buf;
	reg				cenb_data_rd_buf;
	wire	[31:0]	qa_data_rd_buf;
	
	rfdp1024x32 data_rd_buf(
		.CLKA   (clk),
		//.CENA   (cena_data_rd_buf),
		.CENA   (1'b0),
		.AA     (aa_data_rd_buf),
		.QA     (qa_data_rd_buf),
		.CLKB   (clk),
		.CENB   (cenb_data_rd_buf),
		.AB     (ab_data_rd_buf),
		.DB     (db_data_rd_buf)
		);
	
	always @(`CLK_RST_EDGE)
		if (`RST)	begin
			ab_data_rd_buf <= 0;
			cenb_data_rd_buf <= 1;
			db_data_rd_buf <= 0;
		end else begin
			ab_data_rd_buf <= {ab_data_rd_buf_wid, ab_data_buf};
			cenb_data_rd_buf <= cenb_data_buf;
			db_data_rd_buf <= db_data_buf;
		end
	
	
	// below maybe shuld be in another clk domain
	always @(`CLK_RST_EDGE)
		if (`RST)	begin
			aa_data_rd_buf <= 0;
		//	cena_data_rd_buf <= 1;
		end else begin
			aa_data_rd_buf <= {aa_data_rd_buf_rid, index_rd};
		//	cena_data_rd_buf <= cenb_data_buf;
		end
	
	assign qa_rd = qa_data_rd_buf;
	
	always @(`CLK_RST_EDGE)
		if (`RST)				ab_data_rd_buf_wid <= 0;
		else if (update) 		ab_data_rd_buf_wid <= ab_data_rd_buf_wid + 1;
	always @(`CLK_RST_EDGE)
		if (`RST)				wid_updated <= 0;
		else if (update) 		wid_updated <= ab_data_rd_buf_wid;
	
	always @(`CLK_RST_EDGE)
		if (`RST)				aa_data_rd_buf_rid <= 0;
		// if (`RST)				aa_data_rd_buf_rid <= -1;
		else if(rd_init_go)		aa_data_rd_buf_rid <= wid_updated;
	
	
	reg		inc_aa;
	wire go_inc_aa = add_pt;
	//wire go_inc_aa = add_pt_valid;
	reg	[7:0]	inc_aa_d;
	always @(*)	inc_aa_d[0] = inc_aa;
	always @(`CLK_RST_EDGE)
		if (`RST)	inc_aa_d[7:1] <= 0;
		else 		inc_aa_d[7:1] <= inc_aa_d;
		
	
	wire end_inc_aa = qa_data_buf_d[1][`W_PW+`W_PH+1:0]>=new_pt_r && inc_aa;
	wire end_inc_aa_eq = qa_data_buf_d[1][`W_PW+`W_PH+1:0]==new_pt_r && inc_aa;
	// wire end_inc_aa = qa_data_buf[`W_PW+`W_PH+1:0]>=new_pt && inc_aa;
	// wire end_inc_aa_eq = qa_data_buf[`W_PW+`W_PH+1:0]==new_pt && inc_aa;
	
	
	reg		[7:0]	inser_addr;
	reg		[31:0]	inser_data_eq;
	
	
	
	
	reg	[7:0]	end_inc_aa_d;
	always @(*)	end_inc_aa_d[0] = end_inc_aa;
	always @(`CLK_RST_EDGE)
		if (`RST)	end_inc_aa_d[7:1] <= 0;
		else 		end_inc_aa_d[7:1] <= end_inc_aa_d;
	reg    [7:0]    end_inc_aa_eq_d;
	always @(*)    end_inc_aa_eq_d[0] = end_inc_aa_eq;
	always @(`CLK_RST_EDGE)
		if (`RST)    end_inc_aa_eq_d[7:1] <= 0;
		else         end_inc_aa_eq_d[7:1] <= end_inc_aa_eq_d;
	
	
	//wire  go_shift = end_inc_aa_d[2] & !end_inc_aa_eq_d[2];
	//wire  go_shift = end_inc_aa_d[2] & !end_inc_aa_eq_d[2];
	wire  go_shift = end_inc_aa_d[2];
	reg	[7:0]	go_shift_d;
	always @(*)	go_shift_d[0] = go_shift;
	always @(`CLK_RST_EDGE)
		if (`RST)	go_shift_d[7:1] <= 0;
		else 		go_shift_d[7:1] <= go_shift_d;
	reg	[7:0]	shifting_d;
	always @(*)	shifting_d[0] = shifting;
	always @(`CLK_RST_EDGE)
		if (`RST)	shifting_d[7:1] <= 0;
		else 		shifting_d[7:1] <= shifting_d;
	
	wire  go_shift_eq = end_inc_aa_d[2] & end_inc_aa_eq_d[2];
	reg    [7:0]    go_shift_eq_d;
	always @(*)    go_shift_eq_d[0] = go_shift_eq;
	always @(`CLK_RST_EDGE)
		if (`RST)    go_shift_eq_d[7:1] <= 0;
		else         go_shift_eq_d[7:1] <= go_shift_eq_d;
	
	

	wire	end_shift = aa_data_buf==`MAX_PT-1 && shifting || go_shift_eq_d[2];
	always @(`CLK_RST_EDGE)
		if (`RST)				shifting <= 0;
		else if (go_shift& !end_inc_aa_eq_d[2])		shifting <= 1;
		else if (end_shift)		shifting <= 0;
		
	
	always @(`CLK_RST_EDGE)
		if (`RST)				cena_data_buf <= 1;
		else if (go_inc_aa)		cena_data_buf <= 0;
		else if (end_inc_aa)	cena_data_buf <= 1;
		else if (go_shift)		cena_data_buf <= 0;
		else if (end_shift)		cena_data_buf <= 1;
	
	always @(`CLK_RST_EDGE)
		if (`RST)			aa_data_buf <= 0;
	//	else if (!sorting)	aa_data_buf <= 0;
		else if (go_inc_aa)	aa_data_buf <= 0;
		else if (inc_aa)	aa_data_buf <= aa_data_buf + 1;
		else if (go_shift)	aa_data_buf <= inser_addr;	
		else if (shifting)	aa_data_buf <= aa_data_buf + 1;
		else 				aa_data_buf <= 0;
		// else 				aa_data_buf <= index_rd;
	
	// assign qa_rd = qa_data_buf;
	
	always @(`CLK_RST_EDGE)
		if (`RST)				inc_aa <= 0;
		else if (go_inc_aa)		inc_aa <= 1;
		else if (end_inc_aa)	inc_aa <= 0;
	always @(`CLK_RST_EDGE)
		if (`RST)				inser_addr <= 0;
	//	else if (end_inc_aa)	inser_addr <= aa_data_buf_d[1];	
		else if (end_inc_aa)	inser_addr <= aa_data_buf_d[2];	
	always @(`CLK_RST_EDGE)
		if (`RST)				inser_data_eq <= 0;
	//	else if (end_inc_aa)	inser_data_eq <= qa_data_buf;	
		else if (end_inc_aa)	inser_data_eq <= qa_data_buf_d[1];	
		
	reg		[7:0]	eq_cnt;
	always @(`CLK_RST_EDGE)
		if (`RST)	eq_cnt <= 0;
		else		eq_cnt <= inser_data_eq[`W_PW+`W_PH+1+1 +:8]+1;		
		
	// 1 比较
	always @(`CLK_RST_EDGE)
		if (`RST)						cenb_data_buf <= 1;
		else if (clear_all)					cenb_data_buf <= 0;
		else if (go_shift_d[2])			cenb_data_buf <= 0;
		else if (shifting_d[1])			cenb_data_buf <= 0;
		//else if (shifting)				cenb_data_buf <= 0;
		else 							cenb_data_buf <= 1;	
		
	always @(`CLK_RST_EDGE)
		if (`RST)						ab_data_buf <= 0;
		else if (clear_all)					ab_data_buf <= 0;	
	//	else if (shifting)				ab_data_buf <= aa_data_buf_d[1];	
		else if (go_shift_d[2])			ab_data_buf <= inser_addr;
		else if (shifting_d[1])			ab_data_buf <= aa_data_buf_d[1];	

	always @(`CLK_RST_EDGE)
		if (`RST)						db_data_buf <= 0;
		else if (clear_all)					db_data_buf <= -1;	
		//else if (go_shift_eq_d[2])		db_data_buf <= 	{inser_data_eq[`W_PW+`W_PH+1+:8]+1,  new_pt};
		else if (go_shift_eq_d[2])		db_data_buf <= 	{eq_cnt, new_pt_r};
		else if (go_shift_d[2])			db_data_buf <= 	new_pt_r;
	//	else if (shifting_d[1])			db_data_buf <= 	qa_data_buf_d[2];
		else if (shifting_d[1])			db_data_buf <= 	qa_data_buf_d[1];
		
	always @(`CLK_RST_EDGE)
		if (`RST)	sort_done <= 0;
		else 		sort_done <= end_shift;
	
endmodule
