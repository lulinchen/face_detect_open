// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

`include "global.v"

module face (
	input						clk, 
	input						rstn,

	input	[3 :0] SCALE_FACTOR0,      // = 2, // 
	input	[3 :0] SCALE_FACTOR1,      // = 3, // 1.5
	input	[3 :0] SCALE_FACTOR2,      // = 4, // 2
	input	[3 :0] SCALE_FACTOR3,      // = 6, // 3
	input	[3 :0] SCALE_FACTOR4,      // =10, // 5
	input	[2 :0] MAX_SCALE_CNT,      // = 4, 	
	input	[`W_PW:0] PIC_SCALED_WIDTH0  ,    //= 480,
	input	[`W_PH:0] PIC_SCALED_HEIGHT0 ,    //= 270,
	input	[`W_PW:0] PIC_SCALED_WIDTH1  ,    //= 360,
	input	[`W_PH:0] PIC_SCALED_HEIGHT1 ,    //= 180,
	input	[`W_PW:0] PIC_SCALED_WIDTH2  ,    //= 240,
	input	[`W_PH:0] PIC_SCALED_HEIGHT2 ,    //= 135,
	input	[`W_PW:0] PIC_SCALED_WIDTH3  ,    //= 160,
	input	[`W_PH:0] PIC_SCALED_HEIGHT3 ,    //= 90,
	input	[`W_PW:0] PIC_SCALED_WIDTH4  ,    //= 96,
	input	[`W_PH:0] PIC_SCALED_HEIGHT4 ,    //= 54
	
	input	[`W_PW:0]			cam_width,
	input	[`W_PH:0]			cam_height,
	
	input	[`W_PW:0]			pic_width,
	input	[`W_PH:0]			pic_height,	
	
	input	[2:0]				cam_scale,
	input						en,	
	input						cam_clk,
	
	input							cam_vsync_i,
	input							cam_hsync_i,
	input							cam_href_i,
	input		[`W1:0]				cam_data_i,			//Y

	// input		[`W_PW:0]			cnt_h, 
	// input		[`W_PH:0]			cnt_v, 
	
	output							vsync_o,
	output							hsync_o,
	output							de_o,
	output							q
	);
	
	
//	reg			capture_go;
	reg			vj_frame_ready;
	reg			face_working;
	
	wire 		capture_go = en & !face_working;
	always @(`CLK_RST_EDGE)
		if (`RST)					face_working <= 0;
		else if (capture_go)		face_working <= 1;
		else if (vj_frame_ready)	face_working <= 0;
	
	
	wire	[`W_AFRAMEBUF:0]	aa_frame_buf;
	wire						cena_frame_buf;
	wire	[`W_AFRAMEBUF:0]	ab_frame_buf;
	reg		[`W1:0]				db_frame_buf;
	reg							cenb_frame_buf;
	wire	[`W1:0]				qa_frame_buf;
	
	//rfdp262144x8 frame_buf(   // 512 x 512
	rfdp143360x8 frame_buf(		// 512X280
		.CLKA   (clk),
		.CENA   (cena_frame_buf),
		.AA     (aa_frame_buf),
		.QA     (qa_frame_buf),
		.CLKB   (cam_clk),
		.CENB   (cenb_frame_buf),
		.AB     (ab_frame_buf),
		.DB     (db_frame_buf)
		);
		
	capture capture(
		.clk				(cam_clk	),
		.rstn				(rstn		),	
		.cam_scale			(cam_scale),
		.capture_go			(capture_go_Dc),
		.cam_vsync_i		(cam_vsync_i),
		.cam_href_i			(cam_href_i),
		.cam_data_i			(cam_data_i),	
		.capture_ready		(capture_ready_Dc),
		.ab_frame_buf		(ab_frame_buf),  
		.cenb_frame_buf		(cenb_frame_buf),
		.db_frame_buf       (db_frame_buf)
		
	);
	
	
	go_CDC_go go_CDC_go_capture_go (
		clk,
		rstn,
		capture_go,
		cam_clk,
		rstn,
		capture_go_Dc
		);
	go_CDC_go go_CDC_go_capture_ready (
		cam_clk,
		rstn,
		capture_ready_Dc,
		clk,
		rstn,
		capture_ready
		);
	

	wire	[`W1P*`W_SIZE-1:0]		pixels;
	wire							pixels_en;
	wire						ready_for_next_col;		
	wire	[`W_PW:0]			vj_col;
	wire	[`W_PH:0]			vj_row;
	
	reg		[2:0]				scale_cnt;    
	reg		[3:0]				scale_factor;    // 3bit integer 1bit decimal
	reg		[`W_PW:0]			pic_scaled_width;
	reg		[`W_PH:0]			pic_scaled_height;	
	
	wire	scale_cnt_max_f = scale_cnt == (MAX_SCALE_CNT-1);

	wire		vj_scaled_frame_ready;
	//wire	  	vj_fetch_go = capture_ready || vj_scaled_frame_ready & !scale_cnt_max_f;
	reg			vj_fetch_go;
	always @(`CLK_RST_EDGE)
		if (`RST)	vj_fetch_go <= 0;
		else 		vj_fetch_go <= capture_ready || vj_scaled_frame_ready & !scale_cnt_max_f;
	reg		[0:0]		vj_fetch_go_d1;
	always @(`CLK_RST_EDGE)
		if (`ZST)	vj_fetch_go_d1 <= 0;
		else 		vj_fetch_go_d1 <= vj_fetch_go;
	//assign 		vj_frame_ready = vj_scaled_frame_ready &scale_cnt_max_f;
	always @(`CLK_RST_EDGE)
		if (`RST)	vj_frame_ready <= 0;
		else 		vj_frame_ready <= vj_scaled_frame_ready &scale_cnt_max_f;
	always @(`CLK_RST_EDGE)
		if (`RST)						scale_cnt <= 0;
		else if (vj_scaled_frame_ready)	scale_cnt <= scale_cnt_max_f? 0 : scale_cnt + 1;
		
	// vj_scaled_frame_ready   
	// 							vj_fetch_go		vj_fetch_go_d1
	//							scale_cnt
	//											scale_factor
	always @(`CLK_RST_EDGE)
		if (`RST)	scale_factor <= SCALE_FACTOR0;
		else case(scale_cnt)
			0 : scale_factor <= SCALE_FACTOR0;
			1 : scale_factor <= SCALE_FACTOR1;
			2 : scale_factor <= SCALE_FACTOR2;
			3 : scale_factor <= SCALE_FACTOR3;
			4 : scale_factor <= SCALE_FACTOR4;
			default: scale_factor <= SCALE_FACTOR0;
			endcase
	
	
	always @(`CLK_RST_EDGE)
		if (`RST)	pic_scaled_width <= PIC_SCALED_WIDTH0;
		else case(scale_cnt)
			0 : pic_scaled_width <= PIC_SCALED_WIDTH0;
			1 : pic_scaled_width <= PIC_SCALED_WIDTH1;
			2 : pic_scaled_width <= PIC_SCALED_WIDTH2;
			3 : pic_scaled_width <= PIC_SCALED_WIDTH3;
			4 : pic_scaled_width <= PIC_SCALED_WIDTH4;
			default: pic_scaled_width <= PIC_SCALED_WIDTH0;
			endcase
	
	always @(`CLK_RST_EDGE)
		if (`RST)	pic_scaled_height <= PIC_SCALED_HEIGHT0;
		else case(scale_cnt)
			0 : pic_scaled_height <= PIC_SCALED_HEIGHT0;
			1 : pic_scaled_height <= PIC_SCALED_HEIGHT1;
			2 : pic_scaled_height <= PIC_SCALED_HEIGHT2;
			3 : pic_scaled_height <= PIC_SCALED_HEIGHT3;
			4 : pic_scaled_height <= PIC_SCALED_HEIGHT4;
			default: pic_scaled_height <= PIC_SCALED_HEIGHT0;
			endcase
			
	vj_fetch vj_fetch(
		.clk					(clk		),
		.rstn					(rstn		),			
		// .pic_width				(pic_width),
		// .pic_height				(pic_height	),
		// .step					(2	),	
		.pic_width				(pic_scaled_width),
		.pic_height				(pic_scaled_height	),
		.step					(scale_factor	),	
	
		.vj_fetch_go			(vj_fetch_go_d1),
		
		.pixels					(pixels),
		.pixels_en				(pixels_en),
		.vj_row_init			(vj_init),
		.ready_for_next_col		(ready_for_next_col),
		.cascade_end			(cascade_end	),
		.vj_col					(vj_col),
		.vj_row					(vj_row),
		//.vj_frame_ready			(vj_frame_ready),
		.vj_frame_ready			(vj_scaled_frame_ready),
		.cena_frame_buf   		(cena_frame_buf),
		.aa_frame_buf     		(aa_frame_buf),
		.qa_frame_buf     		(qa_frame_buf),
		.face_detected			(face_detected)
		);
	vj vj (
		.clk					(clk		),
		.rstn					(rstn		),
		.init					(vj_init),
		.pixel_i				(pixels	),
		.pixel_i_en				(pixels_en	),
		.ready_for_next_col		(ready_for_next_col	),
		.col_end				(	),
		.cascade_ready			(cascade_end	),
		.face_detected			(face_detected	)
		);	
		
`ifdef SIMULATING
	reg		[31:0]	frame_cnt;
	always @(`CLK_EDGE)
		if (`RST) 					frame_cnt <= 0;
		else if (vj_frame_ready)	frame_cnt <= frame_cnt + 1;
	always @(`CLK_EDGE)
		if(vj_frame_ready)
			$display(" %d============ processing frame %d done ================",$time, frame_cnt);
	always @(`CLK_EDGE)
		if(vj_init)
			$display(" %d============ processing @ row %d ",$time, vj_row);
	always @(`CLK_EDGE)
		if(face_detected)
			$display(" %d============detected a face @ row %d, col %d",$time, vj_row, vj_col);
`endif	
	
	
	wire	vo_clk = cam_clk;
	wire	sorting;
	
	
	
	// x y w h cross clk should be optimize
	reg		[`W_PW+1:0]	vj_col_detected;
	reg		[`W_PH+1:0]	vj_row_detected;
	
	always @(`CLK_RST_EDGE)
		if (`RST)					{vj_col_detected, vj_row_detected} <= 0;
		else if (face_detected) begin
			vj_col_detected <= vj_col * scale_factor;
			vj_row_detected <= vj_row * scale_factor;
		end
		
	reg		[`W_PW:0]	x;
	reg		[`W_PH:0]	y;

	always @(`CLK_RST_EDGE)
		if (`RST)	{x, y} <= 0;
		else begin
			x <= vj_col_detected[`W_PW+1:1] * cam_scale;
			y <= vj_row_detected[`W_PH+1:1] * cam_scale;
		end

	reg		[`W_PW+1:0]	box_w;
	reg		[`W_PH+1:0]	box_h;
	
	always @(`CLK_RST_EDGE)
		if (`RST)	{box_w, box_h} <= 0;	
		else begin
			box_w <= `W_SIZE * scale_factor;
			box_h <= `W_SIZE * scale_factor;
		end
	reg		[`W_PW:0]	w;
	reg		[`W_PH:0]	h;

	always @(`CLK_RST_EDGE)
		if (`RST)	{w, h} <= 0;	
		else begin
			w <= box_w[`W_PW+1:1] * cam_scale;
			h <= box_h[`W_PH+1:1] * cam_scale;
		end
		

	go_CDC_go go_CDC_go_add_pt (
		clk,
		rstn,
		face_detected,
		vo_clk,
		rstn,
		add_pt
		);
	go_CDC_go go_CDC_go_frame_ready (
		clk,
		rstn,
		vj_frame_ready,
		vo_clk,
		rstn,
		vj_frame_ready_Do
		);
	go_CDC_go go_CDC_go_fetch_go (
		clk,
		rstn,
		capture_ready,
		vo_clk,
		rstn,
		clear
		);
	
	
		


	reg		update_due;
	wire	update = update_due & !sorting;
	
	always @(posedge vo_clk)
		if (!rstn)    				update_due <= 0;
		else if (vj_frame_ready_Do)    update_due <= 1;
		else if (update)			update_due <= 0;
	
	
	
	//wire	update = vj_frame_ready_Do;
	
	
	reg	[7:0]	cam_vsync_i_d;
	always @(*)	cam_vsync_i_d[0] = cam_vsync_i;
	always @(posedge vo_clk)
		if (`RST)	cam_vsync_i_d[7:1] <= 0;
		else 		cam_vsync_i_d[7:1] <= cam_vsync_i_d;
	reg	[7:0]	cam_href_i_d;
	always @(*)	cam_href_i_d[0] = cam_href_i;
	always @(posedge vo_clk)
		if (`RST)	cam_href_i_d[7:1] <= 0;
		else 		cam_href_i_d[7:1] <= cam_href_i_d;
		
		
	
	wire	vi_de_fall = !cam_href_i_d[2] & cam_href_i_d[3];
	wire	vi_vsync_fall = !cam_vsync_i_d[2] & cam_vsync_i_d[3]; 
	
	
	reg		[`W_PW:0]	cnt_h;
	reg		[`W_PH:0]	cnt_v;
	always @(posedge vo_clk)
		if (`RST)	cnt_h <= 0;
		else 		cnt_h <= cam_href_i? cnt_h +1 :0;
	always @(posedge vo_clk)
		if (`RST)	cnt_v <= 0;
		else if (vi_vsync_fall)		cnt_v <= 0;
		else if (vi_de_fall)	cnt_v <= cnt_v +1;
	
	// wire	clear = capture_go_Dc;
	

	draw draw(
		.clk				(vo_clk),
		.rstn       		(rstn),
		.add_sq     		(add_pt),
		.clear      		(clear),
	//	.clear      		(1'b0),
		.update     		(update),
		.sorting    		(sorting),
		.pic_width			(cam_width),
		.pic_height			(cam_height	),
		.x          		(x),
		.y          		(y),
		.w          		(w),
		.h          		(h),
		.cnt_h				(cnt_h),
		.cnt_v				(cnt_v),
				
		.vsync      		(cam_vsync_i),
		.hsync      		(cam_hsync_i),
		.de         		(cam_href_i),
					
		.vsync_o			(vsync_o),
		.hsync_o			(hsync_o),
		.de_o				(de_o),
		.q          		(q)
		);
	
	
	
	
endmodule
