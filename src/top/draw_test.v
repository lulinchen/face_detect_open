`include "global.v"

`define W_HDMITX 23


`ifdef FPGA_0_ALTERA
    `define LED_INIT_VALUE          1'b1
    `define LED_POL                 ~
`else
    `define LED_INIT_VALUE          1'b0
    `define LED_POL         		
`endif

module system_top(
	`ifdef FPGA_0_XILINX
		input							clk_ref_i_p,
		input							clk_ref_i_n,
	`else
		input                           clk_ref_i,          // oscillator
	`endif    
	`ifdef FPGA_0_XILINX
		input                           rst_i,             // high active  
	`else
		input                           rstn_i,             // low active  -- user_pb0
	`endif
	
	input	                      	vi_clk,
    input	                      	vi_vsync,
    input	                      	vi_hsync,
    input	                      	vi_de,
	input		  [`W_HDMITX:0]     vi_data, 
	
	output                          vo_clk,
(* iob = "TRUE" *)   output reg                      vo_vsync,
(* iob = "TRUE" *)   output reg                      vo_hsync,
(* iob = "TRUE" *)   output reg                      vo_de,
(* iob = "TRUE" *)	 output reg	  [`W_HDMITX:0]     vo_data, 
	output         [1:0]          video_format,  // 00 2D  others 3D
	
	    output reg                      LED0,
    output reg                      LED1,
    output reg                      LED2,
    output reg                      LED3,
    output reg                      LED4,
    output reg                      LED5,
    output reg                      LED6,
    output reg                      LED7
	);


	assign		video_format=0;   // 00 2D  others 3D
	
	/*
	`ifdef FPGA_0_XILINX
		wire		rstn_i = ~rst_i;
		wire							clk_ref;
		IBUFDS clkin1_ibufgds(	
			.O  (clk_ref),
			.I  (clk_ref_i_p),
			.IB (clk_ref_i_n)
			);
		wire						pll_main_locked;
		wire						p0_c0, p0_c1;
		wire  						clk = p0_c1;	
		pll_main pll_main(
			.clk_in1	(clk_ref),
			.clk_out1	(p0_c0),					// 300M
			.clk_out2	(p0_c1),					// 250M
			.locked		(pll_main_locked)
			);
			
		//wire 	int_vo_clk_75_25;
		//wire 	int_vo_clk_148_5;
		//pll_74_25 pll_hdmi(
		//	.clk_in1		(clk_ref),
		//	.clk_out1 	(int_vo_clk_75_25),
		//	.clk_out2 	(int_vo_clk_148_5)
		//);		
	`else
		wire                            clk_ref = clk_ref_i;
	`endif
	*/
	wire	clk = vi_clk;
	wire	rstn = ~rst_i;
	assign	vo_clk = vi_clk;
	
	reg	[7:0]	vi_vsync_d;
	always @(*)	vi_vsync_d[0] = vi_vsync;
	always @(`CLK_RST_EDGE)
		if (`RST)	vi_vsync_d[7:1] <= 0;
		else 		vi_vsync_d[7:1] <= vi_vsync_d;
	reg	[7:0]	vi_hsync_d;
	always @(*)	vi_hsync_d[0] = vi_hsync;
	always @(`CLK_RST_EDGE)
		if (`RST)	vi_hsync_d[7:1] <= 0;
		else 		vi_hsync_d[7:1] <= vi_hsync_d;
	reg	[7:0]	vi_de_d;
	always @(*)	vi_de_d[0] = vi_de;
	always @(`CLK_RST_EDGE)
		if (`RST)	vi_de_d[7:1] <= 0;
		else 		vi_de_d[7:1] <= vi_de_d;
		
	reg	[7:0][`W_HDMITX:0]	vi_data_d;
	always @(*)	vi_data_d[0] = vi_data;
	always @(`CLK_RST_EDGE)
		if (`RST)	vi_data_d[7:1] <= 0;
		else 		vi_data_d[7:1] <= vi_data_d;
	
	wire	vi_de_fall = !vi_de_d[1] & vi_de_d[2]; 
	
	wire	vi_vsync_fall = !vi_vsync_d[1] & vi_vsync_d[2]; 
	wire	vi_vsync_rise =  vi_vsync_d[1] & !vi_vsync_d[2]; 
	
	reg		[`W_PW:0]	cnt_h;
	reg		[`W_PH:0]	cnt_v;
	always @(`CLK_RST_EDGE)
		if (`RST)	cnt_h <= 0;
		else 		cnt_h <= vi_de_d[1]? cnt_h +1 :0;
	always @(`CLK_RST_EDGE)
		if (`RST)	cnt_v <= 0;
		else if (vi_vsync_fall)		cnt_v <= 0;
		else if (vi_de_fall)	cnt_v <= cnt_v +1;
	
	
	reg		add_sq;
	//wire	add_sq = cnt_v[3:0] == 15 && cnt_h == 64;
	always @(`CLK_RST_EDGE)
		if (`RST)	add_sq <= 0;
		// else 		add_sq <= cnt_v[10:0] == 15 && cnt_h == 64;
		else 		add_sq <= cnt_v[5:0] == 15 && cnt_h == 64;
	
	reg	[7:0]	add_sq_d;
	always @(*)	add_sq_d[0] = add_sq;
	always @(`CLK_RST_EDGE)
		if (`RST)	add_sq_d[7:1] <= 0;
		else 		add_sq_d[7:1] <= add_sq_d;

	
 (* mark_debug = "true"*)	reg			[`W_PW:0]	x;
 (* mark_debug = "true"*)	reg			[`W_PH:0]	y;
	
	always @(`CLK_RST_EDGE)
		if (`RST)			{x, y} <= 0;
		//else if (add_sq) begin
		else begin
			x <= vi_data_d[4][10:0];
			y <= vi_data_d[4][19:10];
		end
	
	
	draw draw(
		.clk		(clk),
		.rstn		(rstn),
		.add_sq		(add_sq_d[1]),
		.clear		(1'b0),
		.update		(vi_vsync_rise),
		.sorting	(),
		// .width_m1	(1919),
		// .height_m1	(1079),
		.pic_width				(1920),
		.pic_height				(1080),
		
		
		// .width_m1	(1279),
		// .height_m1	(719),
		
		.x			(x),
		.y			(y),
		//.y			(512),
		.w			(48 ), 
		//.h			(64), 
		.h			(48), 
		.cnt_h		(cnt_h), 
		.cnt_v		(cnt_v), 
		.vsync		(vi_vsync_d[1]),
		.hsync		(vi_hsync_d[1]),
		.de			(vi_de_d[1]),
		.vsync_o	(vsync_o),
		.hsync_o	(hsync_o),
		.de_o		(de_o),
		.q          (q_o)
	);

	
	wire	[`W_HDMITX:0] data_o  = q_o ?  {vi_data_d[5][`W_HDMITX:8], 8'hff}: vi_data_d[5];
	
	
	reg	[7:0]	vsync_o_d;
	always @(*)	vsync_o_d[0] = vsync_o;
	always @(`CLK_RST_EDGE)
		if (`RST)	vsync_o_d[7:1] <= 0;
		else 		vsync_o_d[7:1] <= vsync_o_d;
	reg	[7:0]	hsync_o_d;
	always @(*)	hsync_o_d[0] = hsync_o;
	always @(`CLK_RST_EDGE)
		if (`RST)	hsync_o_d[7:1] <= 0;
		else 		hsync_o_d[7:1] <= hsync_o_d;
	reg	[7:0]	de_o_d;
	always @(*)	de_o_d[0] = de_o;
	always @(`CLK_RST_EDGE)
		if (`RST)	de_o_d[7:1] <= 0;
		else 		de_o_d[7:1] <= de_o_d;
	reg	[7:0][`W_HDMITX:0]	data_o_d;
	always @(*)	data_o_d[0] = data_o;
	always @(`CLK_RST_EDGE)
		if (`RST)	data_o_d[7:1] <= 0;
		else 		data_o_d[7:1] <= data_o_d;
		
	always@* begin
		vo_vsync = vsync_o_d[3];
		vo_hsync = hsync_o_d[3];	
		vo_de = de_o_d[3];
		vo_data = data_o_d[3];
	end


	
endmodule
