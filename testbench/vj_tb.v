// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
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
	
	wire		cascade_end;
	wire		ready_for_next_col;
	wire		col_end;
	itf_line itf_line(clk);
	
	wire	[`W1P*`W_SIZE-1:0]		pixel_i 	= itf_line.pixel_i;
	wire				pixel_i_en 	= itf_line.pixel_i_en;
	wire				new_line	= itf_line.new_line ;
	wire				new_pic	= 	  itf_line.new_pic ;
	wire				radical_en	= 	  itf_line.radical_en ;
	wire	[25:0]		radical	= 	  itf_line.radical ;
	assign itf_line.cascade_end = cascade_end ;
	assign itf_line.col_end = col_end ;
	assign itf_line.ready_for_next_col = ready_for_next_col ;
	
	
	initial begin
		itf_line.init();
		#(`RESET_DELAY)
		#(`RESET_DELAY)
		//itf_line.drive_one_line(4);
		//itf_line.drive_one_pic(1024, 1024);

		//itf_line.drive_sqrt();
		itf_line.drive_one_pic(frame_width_0, frame_height_0, sequence_name_0);
		
		//#(300000* `TIME_COEFF)
		#(30* `TIME_COEFF)
		$finish();
	end
	
	
	initial begin
	
		//#300000000 $finish();
		//#3000000 $finish();
		#200000000 $finish();
	end

	vj vj (
		.clk			(clk		),
		.rstn			(rstn		),
		.pic_width		(frame_width_0),
		.pic_height		(frame_height_0	),
		.init		(new_line	),
		.pixel_i		(pixel_i	),
		.pixel_i_en		(pixel_i_en	),
		.ready_for_next_col		(ready_for_next_col	),
		.col_end		(col_end	),
		.cascade_ready	(cascade_end	),
		.face_detected	(face_detected	)
		);
	always @(`CLK_EDGE)
		if(face_detected)
			$display(" %d============detected a face ",$time);
	/*	
	iibuffer iibuffer (
		.clk			(clk		),
		.rstn			(rstn		),
		.pixel_i		(pixel_i	),
		.pixel_i_en		(pixel_i_en	),
	    .new_line       (new_line   ),
	    .new_pic      	 (new_pic   )
		);
	sqrt_root sqrt_root(
		.clk			(clk		),
		.rstn			(rstn		),
		.en				(radical_en),
		.radical		(radical)
		//.radical		(-1)
		);
	weak_stages_rom weak_stages_rom(
		.clk		(clk),
		.addr		(30)
		);
	rect0_rom rect0_rom(
		.clk		(clk),
		.addr		(30)
		);
	*/
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
		for(int i= 0; i< 2**10 ; i++) begin
			radical_en <= 1;
			radical <= i;
			@cb;
		end
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
				pic_data[i*width+j] <= $fgetc(fd);
		@cb;
		@cb;
		
		for(int i= 0; i< height-`W_SIZE + 1; i++) begin
			
			$display("T%d ######### drive Row %d #############################", $time, i);
	
			@cb;
			@cb;
			new_line <= 1;
			if (i== 0)
				new_pic <= 1;
			@cb;
			new_line <= 0;
			new_pic <= 0;
			@cb;
			@cb;
			//pixel_i <= 2**(`W1+1)-1;
			
			for(int j= 0; j< `W_SIZE ; j++) begin
				for(int p=0; p<`W_SIZE; p++)
					pixel_i[`W1P*(`W_SIZE-p)-1 -:`W1P ] = pic_data[(i+p)*width+ j];
				pixel_i_en <= 1;
				@cb;
			end
			pixel_i <= 0;
			pixel_i_en <= 0;
			@cb;
			
			if (width - `W_SIZE>0)
			for(int j= `W_SIZE; j< width ; j++) begin 
				//wait (cascade_end)	
				wait (ready_for_next_col)	
				@cb;
				@cb;
				for(int p=0; p<`W_SIZE; p++)
					pixel_i[`W1P*(`W_SIZE-p)-1 -:`W1P ] = pic_data[(i+p)*width+ j];
				pixel_i_en <= 1;
				@cb;
				pixel_i <= 0;
				pixel_i_en <= 0;
			end
			@cb;
			@cb;
			//wait (col_end)	
			wait (ready_for_next_col)	
			//wait (cascade_end)	
			//wait (ready_for_next_col)	
			repeat(3000)	@cb;
			@cb;	
			@cb;	
			@cb;	
			@cb;	
			@cb;	
			@cb;	
			@cb;	
		end
	endtask
	
	
endinterface