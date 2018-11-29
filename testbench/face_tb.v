// Copyright (c) 2018  Lulinchen, All Rights Reserved
// AUTHOR : 	Lulinchen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

`include "global.v"

`define	MAX_PATH			256

module tb();
	
	parameter  FRAME_WIDTH = 112;
	parameter  FRAME_HEIGHT = 48;
	parameter  SIM_FRAMES = 2;
	reg						rstn;
	reg						clk;
	initial begin
		rstn = `RESET_ACTIVE;
		#(`RESET_DELAY); 
		$display("T%d rstn done#############################", $time);
		rstn = `RESET_IDLE;
	end


	initial begin
		clk = 1;
		forever begin
			clk = ~clk;
			#(`CLK_PERIOD_DIV2);
		end
	end
	
	reg			[15:0]			frame_width_0;
	reg			[15:0]			frame_height_0;
	reg			[31:0]			pic_to_sim;
	reg		[`MAX_PATH*8-1:0]	sequence_name_0;
	
	
	task process_cmdline;
		frame_width_0			= FRAME_WIDTH;
		frame_height_0			= FRAME_HEIGHT;
		pic_to_sim				= SIM_FRAMES;
		
		if (!$value$plusargs("width=%d", frame_width_0)) begin
			$display("Frame width is NOT specified");
		end
		if (!$value$plusargs("height=%d", frame_height_0)) begin
			$display("Frame height is NOT specified");
		end
		if (!$value$plusargs("frames=%d", pic_to_sim)) begin
			$display("Frames to be encoded is NOT specified, use whole file");
		end
		if (!$value$plusargs("input=%s", sequence_name_0)) begin
			$display("Missing input sequence file.");
			$finish;
		end

		
		$display(" Geometry:            %0dx%0d",	frame_width_0, frame_height_0				);
		$display(" InputSequence:       %0s",		sequence_name_0								);
		$display(" SimFrames:           %0d",		pic_to_sim								    );
	endtask
	initial 
		process_cmdline;
	
	initial begin
		#(`RESET_DELAY)
		#(`RESET_DELAY)
		
		//#100000000  $finish();
		
		@($root.tb.face.vj_frame_ready)	 
		;
		@($root.tb.face.vsync_o)	
		;			
		@(!$root.tb.face.vsync_o)	
		;	
		@($root.tb.face.vsync_o)	
		;	
		#200 $finish;
	end
	wire	[`W_CAMD_I:0]	cam_data_0;
	wire							sdc_init_done  = 1'b1;
	sensor	sensor0 (
		.sequence_name	(sequence_name_0),
		.width    		(frame_width_0),
		.height    		(frame_height_0),
		.pic_to_sim   	(pic_to_sim),
		.cam_active		(sdc_init_done),
		.cam_clk    	(cam_clk),
		.cam_href    	(cam_href_0),
		.cam_vsync    	(cam_vsync_0),
		.cam_data    	(cam_data_0));
		
	//wire [2:0]				cam_scale =  1;	
	reg [2:0]				cam_scale; // =  1;	
	always @*
		if (frame_width_0 > 1024)
			cam_scale = 4;
		else if (frame_width_0 > 512)
			cam_scale = 2;
		else 
			cam_scale = 1;
	
	wire	[31:0]	pic_width = frame_width_0/cam_scale;
	wire	[31:0]	pic_height = frame_height_0/cam_scale;
	
	reg		[2:0]	MAX_SCALE_CNT;
	always @*
		if (pic_width/5 > 24 && pic_height/5 > 24)
			MAX_SCALE_CNT = 5;
		else if (pic_width/3 > 24 && pic_height/3 > 24)
			MAX_SCALE_CNT = 4;
		else if (pic_width/2 > 24 && pic_height/2 > 24)
			MAX_SCALE_CNT = 3;
		else if (pic_width/1.5 > 24 && pic_height/1.5 > 24)
			MAX_SCALE_CNT = 2;
		else if (pic_width/1 > 24 && pic_height/1 > 24)
			MAX_SCALE_CNT = 1;
		else begin
			$display("input pic ture too small");
			$finish;
		end
		
	face face(
		.clk				(clk	),
		.rstn				(rstn		),	
		
		.SCALE_FACTOR0 		( 2),
		.SCALE_FACTOR1 		( 3),
		.SCALE_FACTOR2 		( 4),
		.SCALE_FACTOR3 		( 6),
		.SCALE_FACTOR4 		(10),
		.MAX_SCALE_CNT 		(MAX_SCALE_CNT), 
		.PIC_SCALED_WIDTH0  (pic_width),
		.PIC_SCALED_HEIGHT0 (pic_height),
		.PIC_SCALED_WIDTH1  (pic_width/1.5),
		.PIC_SCALED_HEIGHT1 (pic_height/1.5),
		.PIC_SCALED_WIDTH2  (pic_width/2),
		.PIC_SCALED_HEIGHT2 (pic_height/2),
		.PIC_SCALED_WIDTH3  (pic_width/3),
		.PIC_SCALED_HEIGHT3 (pic_height/3),
		.PIC_SCALED_WIDTH4  (pic_width/5),
		.PIC_SCALED_HEIGHT4 (pic_height/5),	
		
		.cam_width			(frame_width_0),
		.cam_height			(frame_height_0),
	
		.pic_width			(pic_width),
		.pic_height			(pic_height),
	
		.cam_scale			(cam_scale),
		.en					(1),
		
		.cam_clk			(cam_clk),
		.cam_vsync_i		(cam_vsync_0),
		.cam_href_i			(cam_href_0),
		.cam_data_i			(cam_data_0),	
		// .cnt_h				(cnt_h),
		// .cnt_v				(cnt_v),	
		
		.vsync_o			(vsync_o),
		.hsync_o			(hsync_o),
		.de_o				(de_o),
		.q          		(q)
		);
	
	DumpYUV DumpYUV (
		cam_clk,
		vsync_o,
		hsync_o,
		de_o,
		q		
		);
	
`ifdef DUMP_FSDB
	initial begin
		$fsdbDumpfile("ecb.fsdb");
		$fsdbDumpvars(4, tb);
	end  
`elsif DUMP_VCD
	initial begin
		$dumpfile("test.vcd");
		$dumpvars(3, tb);
	end
`endif
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
	//wire    [`W4:0]  uyvy_word = {vo_data_d[0][`W1-:`W1P], vo_data_d[1][`W1-:`W1P], vo_data_d[2][`W1-:`W1P], vo_data_d[3][`W1-:`W1P]};
	//wire    [`W4:0]  uyvy_word = vo_data_d[0][`W1-:`W1P];
	//wire    [`W4:0]  uyvy_word = {vo_data[`W1-:`W1P], vo_data[`W2-:`W1P], vo_data_prv[`W1-:`W1P], vo_data_prv[`W2-:`W1P]};
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

/*

interface itf_line(input clk);

	logic [`W1P*`W_SIZE-1:0]	pixel_i;
	logic 			pixel_i_en;
	logic 			new_line;
	logic 			new_pic;
	logic 			radical_en;
	logic [25:0]	radical;
	logic			cascade_end;
	logic			col_end;
	logic			ready_for_next_col;

	clocking cb@( `CLK_EDGE);
		output pixel_i;
		output pixel_i_en;
		output new_line;
		output new_pic;
		output radical;
		output radical_en;
		input cascade_end;
		input col_end;
		input ready_for_next_col;
	endclocking
	
	task init();
		pixel_i <= 0;
		pixel_i_en <= 0;
		new_line <= 0;
		new_pic <= 0;
		radical <= 0;
		radical_en <= 0;
	endtask
	
	task drive_sqrt();
		
		@cb;
		@cb;
		for(int i= 2**25; i< 2**26 ; i++) begin
			radical_en <= 1;
			radical <= i;
			@cb;
			radical_en <= 0;
			@cb;
			repeat(64) @cb;
		end
		
			// radical_en <= 1;
			// radical <= 0;
			// @cb;

		radical_en <= 0;
		@cb;
		@cb;	
	endtask
	
	task drive_one_line(input integer width);
		@cb;
		@cb;
		new_line <= 1;
		new_pic <= 1;
		@cb;
		new_line <= 0;
		new_pic <= 0;
		@cb;
		@cb;
		pixel_i <= 1;
		pixel_i_en <= 1;
		for(int i= 0; i< width ; i++)
			@cb;
		pixel_i <= 0;
		pixel_i_en <= 0;
		@cb;
		@cb;
		@cb;
	endtask
	
	task drive_one_pic(input integer width, input integer height, input [`MAX_PATH*8-1:0] sequence_name );
		integer						fd;
		integer						errno;
		reg			[640-1:0]		errinfo;
		reg		[`W1:0] 	pic_data[];
		
		pic_data = new[width*height];
		
		fd = $fopen(sequence_name, "rb");
		if (fd == 0) begin
			errno = $ferror(fd, errinfo);
			$display("sensor_hd() Failed to open file %0s for read.", sequence_name);
			$display("errno: %0d", errno);
			$display("reason: %0s", errinfo);
			$finish();
		end
		
		for(int i= 0; i< height ; i++) 
			for(int j= 0; j< width ; j++) 
				$root.tb.frame_buf.u.mem[i*`FRAME_BUF_LINE+j] <= $fgetc(fd);
		
	endtask
	
	
endinterface

*/