// Copyright (c) 2018  Lulinchen, All Rights Reserved
// AUTHOR : 	Lulinchen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

`include "global.v"
module tb();

	parameter  FRAME_WIDTH = 112;
	parameter  FRAME_HEIGHT = 48;
	parameter  SIM_FRAMES = 2;
	
	reg						rstn;
	reg						clk;
	reg						sdc_init_done;
	initial begin
		rstn = `RESET_ACTIVE;
		#(`RESET_DELAY); 
		$display("T%d rstn done#############################", $time);
		rstn = `RESET_IDLE;
		
		//#10000 
		//$finish();
	end
`ifdef DUMP_FSDB
	initial begin
		$fsdbDumpfile("ecb.fsdb");
		$fsdbDumpvars(5, tb);
	end  
`elsif DUMP_VCD
	initial begin
		$dumpfile("test.vcd");
		$dumpvars(3, tb);
		
	end
`endif
	initial begin
		clk = 1;
		forever begin
			clk = ~clk;
			#(`CLK_PERIOD_DIV2);
		end
	end
	reg			[15:0]			frame_width_0;
	reg			[15:0]			frame_height_0;


	task process_cmdline;
		frame_width_0			= FRAME_WIDTH;
		frame_height_0			= FRAME_HEIGHT;
		
		if (!$value$plusargs("width=%d", frame_width_0)) begin
			$display("Frame width is NOT specified");
		end
		if (!$value$plusargs("height=%d", frame_height_0)) begin
			$display("Frame height is NOT specified");
		end

		$display(" Geometry:            %0dx%0d",	frame_width_0, frame_height_0				);	
	endtask
	initial 
		process_cmdline;
		
	/*
	reg			clear;
	reg			add_pt;
	reg	[`W_PW+`W_PH+1:0]	new_pt;
	wire 		sort_sorting;
	integer seed = 123;
	initial begin
		clear = 0;
		add_pt = 0;
		#(`RESET_DELAY); 
		#(`RESET_DELAY); 
		@(posedge clk)
		clear <= 1;
		@(posedge clk)
		clear <= 0;
		
		for(int i=0; i<11; i++) begin
		//for(int i=32; i>16; i--) begin
			@(posedge clk)
			add_pt <= 1;
			if (i%2 ==0) begin
				new_pt <= $random(seed);
			end
			@(posedge clk)
			add_pt <= 0;
			//@(posedge clk)
			
			@(negedge sort_sorting)
			;
			@(posedge clk)
			;
			@(posedge clk)
			;
		end
		
		for(int i=0; i<7; i++) begin
		//for(int i=32; i>16; i--) begin
			@(posedge clk)
			add_pt <= 1;
			//if (i%2 ==0) begin
			//	new_pt <= $random(seed);
			//end
			@(posedge clk)
			add_pt <= 0;
			//@(posedge clk)
			
			@(negedge sort_sorting)
			;
			@(posedge clk)
			;
			@(posedge clk)
			;
		end
		
		dump_mem();
		
		#1000
		$finish;
	end
	
	task dump_mem();
		
		$display("---total data sorted: %d ------ ", tb.sort.total)	;

		$display("--------------------------------");	
		for(int i=0; i< tb.sort.total ; i++) begin
			$display("%x------%x, %x", i, tb.sort.data_buf.u.mem[i][`W_PW+`W_PH+1 +1 +:8], tb.sort.data_buf.u.mem[i][`W_PW+`W_PH+1:0]);
		end
			
	
	endtask
	
	//sort sort(
	sort_with_eq sort(
		.clk		(clk),
		.rstn		(rstn),
		.clear		(clear),
		.new_pt		(new_pt),
		.add_pt		(add_pt),
		.sorting	(sort_sorting),
		.total      ()
	);
	
	*/
	
	
	reg		[`W_PW:0]	x;
	reg		[`W_PH:0]	y;
	reg		[`W_PW:0]	w; 
	reg		[`W_PH:0]	h; 
	
	reg			clear;
	reg			add_pt;
	reg			update;
	wire		sorting;
	
	reg			disp_en=0;
	int w0 = 11;
	int h0 = 11;
	int seed= 5;
	initial begin
		clear = 0;
		add_pt = 0;
		update = 0;
		w	= w0;
		h   = h0;
		x = $random(seed);
		y <= {$random} % tb.draw.pic_height;	
		#(`RESET_DELAY); 
		#(`RESET_DELAY); 
		@(posedge clk)
		clear <= 1;
		@(posedge clk)
		clear <= 0;
			// x <= {$random} % tb.draw.pic_width;
			// y <= {$random} % tb.draw.pic_height;	
			// x <= $random() % 'h400;
			// y <= $random() % 'h400;
	
			// w <= {$random}% 64 + 4;
			// h <= {$random}% 64+ 4;
			
		for (int f=0; f < 2; f++ ) begin
			for(int i=0; i<8; i++) begin
			 // for(int i=0; i<2; i++) begin
			// for(int i=32; i>16; i--) begin
				@(posedge clk)
					add_pt <= 1;
				//w <= (i+1)*w0;
				//h <= (i+1)*h0;
				
				//x <= (i)*w0;
				//y <= (i)*h0;	
				// w <= {$random}% 64 + 4;
				// h <= {$random}% 64+ 4;
			// if (i==0)begin
				//x <= x + 1;
				x <= {$random} % tb.draw.pic_width;
				y <= {$random} % tb.draw.pic_height;	
			// end	
				// x <= 0;
				// y <= 0;
					// x <= $random() % 'h800;
				// y <= $random() % 'h800;
		
				w <= {$random}% 64 + 4;
				h <= {$random}% 64+ 4;
				
				//x <= x + w;
				//y <= y + h;
				//x <= 320-2;
				//y <=  240 - 3;
				@(posedge clk)
				add_pt <= 0;
				//@(posedge clk)
				
				// $display("%T  deactive add_pt ", $time);	
				@(posedge clk)	
				;
				@(posedge clk)	
				;
				@(posedge clk)	
				;
				@(posedge clk)	
				;
				@(posedge clk)	
				;
				@(posedge clk)	
				;
				// $display("%T befote wiati ", $time);
				 wait (!sorting);
				// $display("%T after wiati ", $time);
				@(posedge clk)
				;
				@(posedge clk)
				;
				
			//	@(posedge clk)
			//	add_pt <= 1;
			//	// w <= (i+2)*w;
			//	// h <= (i+2)*h;
			//	w <= (i+1)*w;
			//	h <= (i+1)*h;
			//	
			//	//x <= (i+1)*5+w+1;
			//	x <= (i+1)*5;
			//	y <= (i+1)*5;
			//	@(posedge clk)
			//	add_pt <= 0;
			//	//@(posedge clk)
			//	
			//	@(negedge sorting)
			//	;
			//	@(posedge clk)
			//	;
			//	@(posedge clk)
			//	;
			end
			
			//dump_mem();
			@(posedge clk)
				update <= 1;
			@(posedge clk)
				update <= 0;
			
			disp_en = 1;
			
		end	
		// for(int i=1; i< 33; i++)
			// $display("T%d   log2: ", i, $clog2(i));
	
		//#1500000
		//#1000000
		//$finish;
	end
/*	
	task dump_mem();
		
		$display("---total data sorted: %d ------ ", tb.draw.sort0.total)	;

		$display("--------------------------------");	
		for(int i=0; i< tb.draw.sort0.total ; i++) begin
			$display("%x------%x, %x", i, tb.draw.sort0.data_buf.u.mem[i][`W_PW+`W_PH+1 +1 +:8], tb.draw.sort0.data_buf.u.mem[i][`W_PW+`W_PH+1:0]);
		end
			
	
	endtask
*/	
	
	wire      [`W_PW:0]  	hfp_m1 		= 5 - 1;      
	wire      [`W_PW:0]  	hs_m1   	= 5 - 1;      
	wire      [`W_PW:0]  	hbp_m1		= 5 - 1;      
	wire      [`W_PW :0]  	width_m1	= frame_width_0 - 1;
	// wire      [`W_PW :0]  	width_m1	= 1920 - 1;
	// wire      [`W_PW :0]  	width_m1	= 640 - 1;
	wire      [`W_PH:0]  	vfp_m1		= 2 - 1;      
	wire      [`W_PH:0]  	vs_m1		= 2 - 1;      
	wire      [`W_PH:0]  	vbp_m1		= 9 - 1;      
	wire      [`W_PH :0]  	height_m1	= frame_height_0 - 1;
	// wire      [`W_PH :0]  	height_m1	= 1080 - 1;
	 // wire      [`W_PH :0]  	height_m1	= 480 - 1;
	
	wire		[`W_PW:0] 	cnt_h;	
	wire		[`W_PH:0] 	cnt_v;
	reg    [1:0][`W_PH:0]    cnt_h_d;
	always @(*)    cnt_h_d[0] = cnt_h;
	always @(`CLK_RST_EDGE)
		if (`RST)    cnt_h_d[1:1] <= 0;
		else         cnt_h_d[1:1] <= cnt_h_d;
	
	wire	vsync_o, hsync_o, de_o;
	wire	[`W2:0]	q;
	
	reg	[7:0]	vsync_o_d;
	always @(*)	vsync_o_d[0] = vsync_o;
	always @(`CLK_RST_EDGE)
		if (`RST)	vsync_o_d[7:1] <= 0;
		else 		vsync_o_d[7:1] <= vsync_o_d;
	reg	[15:0]	frame_cnt;
	wire	vsync_o_fall = !vsync_o & vsync_o_d[1];
	always @(`CLK_RST_EDGE)
		if (`RST)	frame_cnt <= 0;
		else if(vsync_o_fall)		frame_cnt <= frame_cnt + 1;
	always @(`CLK_RST_EDGE)
		if (frame_cnt==3)
			$finish();
	
	always @(`CLK_RST_EDGE)
		if (`RST)    cnt_h_d[1:1] <= 0;
		else         cnt_h_d[1:1] <= cnt_h_d;
	
	
	draw draw(
		.clk		(clk),
		.rstn       (rstn),
		.add_sq     (add_pt),
		.clear      (clear),
		.update     (update),
		.sorting    (sorting),
		.pic_width	(frame_width_0),
		.pic_height	(frame_height_0	),
		.x          (x),
		.y          (y),
		.w          (w),
		.h          (h),
		.cnt_h		(cnt_h),
		.cnt_v		(cnt_v),
		
		.vsync      (vsync),
		.hsync      (hsync),
		.de         (de),
		
		.vsync_o	(vsync_o),
		.hsync_o	(hsync_o),
		.de_o		(de_o),
		.q          (q)
		);
	
	
	monitor monitor(
		.clock			(clk),
		.reset			(!rstn),	
		.io_en			(disp_en),	
		.io_hfp_m1 		(hfp_m1 	),
		.io_hs_m1      	(hs_m1   ),
		.io_hbp_m1	    (hbp_m1	),
		.io_width_m1   	(width_m1),
		.io_vfp_m1	    (vfp_m1	),
		.io_vs_m1	    (vs_m1	),
		.io_vbp_m1	    (vbp_m1	),
		.io_height_m1  	(height_m1),
		
		.io_cnt_h		(cnt_h),
		.io_cnt_v		(cnt_v),
		.io_vsync		(vsync),
		.io_hsync		(hsync),
		.io_de          (de)
	);
	
	DumpYUV DumpYUV (
		clk,
		vsync_o,
		hsync_o,
		de_o,
		q		
		);
	
	
endmodule


module DumpYUV (
	input				clk,
	input				vsync,
	input				hsync,
	input				de,
	input	[`W2:0] 	q
	);

	reg         [1:0]   even_de;
	wire		   		vo_de = de;
	wire    	[`W2:0]	vo_data = q!=0? -1 : 0;
	integer        		fp_uyvy;
	reg     	[`W2:0] vo_data_prv;
	reg			[ 19:0]	nb_byte;
	reg    [7:0][`W1:0]    vo_data_d;
	always @(*)    vo_data_d[0] = vo_data;
	always @(posedge clk) 
					vo_data_d[7:1] <= vo_data_d;

	wire    [`W4:0]  uyvy_word = {vo_data_d[0], vo_data_d[1], vo_data_d[2], vo_data_d[3]};
	initial begin
		fp_uyvy = $fopen("./output.yuv","w");
		even_de = 0;
		nb_byte = 0;
	end  
	
	always @(posedge clk) 
		if (vo_de) begin
			vo_data_prv <= vo_data;
			even_de <=  even_de + 1;
			nb_byte = nb_byte + 2;
		end  
	always @(posedge clk) 
		//if ( de  && even_de == 1) begin
		if ( de  && even_de == 3) begin
			$fwrite(fp_uyvy, "%u", uyvy_word);
			$fflush(fp_uyvy);      
		end
endmodule
