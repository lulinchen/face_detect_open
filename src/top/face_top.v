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
		input                           clk_ref_i,       
	`endif    
	`ifdef FPGA_0_XILINX
		input                           rst_i,           
	`else
		input                           rstn_i,          
	`endif
	
	input	                      	vi_clk,
    input	                      	vi_vsync,
    input	                      	vi_hsync,
    input	                      	vi_de,
	input		  [`W_HDMITX:0]     vi_data, 
	
	output                          vo_clk,
(* iob = "TRUE" *)    output reg                      vo_vsync,
(* iob = "TRUE" *)    output reg                      vo_hsync,
(* iob = "TRUE" *)    output reg                      vo_de,
(* iob = "TRUE" *)	  output reg	  [`W_HDMITX:0]     vo_data, 
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
	`else
		wire                            clk_ref = clk_ref_i;
	`endif
	
	dlyRst # (.W_CNTRST(24)) dlyRst0 (.clk(clk_ref), .rstn_i(rstn_i&pll_main_locked),  .rstn(rstn));

	//wire	clk = vi_clk;
	assign	vo_clk = vi_clk;
	
	reg	[7:0]	vi_vsync_d;
	always @(*)	vi_vsync_d[0] = vi_vsync;
	always @(posedge vo_clk)
		if (`RST)	vi_vsync_d[7:1] <= 0;
		else 		vi_vsync_d[7:1] <= vi_vsync_d;
	reg	[7:0]	vi_hsync_d;
	always @(*)	vi_hsync_d[0] = vi_hsync;
	always @(posedge vo_clk)
		if (`RST)	vi_hsync_d[7:1] <= 0;
		else 		vi_hsync_d[7:1] <= vi_hsync_d;
	reg	[7:0]	vi_de_d;
	always @(*)	vi_de_d[0] = vi_de;
	always @(posedge vo_clk)
		if (`RST)	vi_de_d[7:1] <= 0;
		else 		vi_de_d[7:1] <= vi_de_d;
		
	reg	[7:0][`W_HDMITX:0]	vi_data_d;
	always @(*)	vi_data_d[0] = vi_data;
	always @(posedge vo_clk)
		if (`RST)	vi_data_d[7:1] <= 0;
		else 		vi_data_d[7:1] <= vi_data_d;
	
	face face(
		.clk					(clk),
		.rstn					(rstn),
		
		.SCALE_FACTOR0 			( 2),
		.SCALE_FACTOR1 			( 3),
		.SCALE_FACTOR2 			( 4),
		.SCALE_FACTOR3 			( 6),
		.SCALE_FACTOR4 			(10),
			
		.MAX_SCALE_CNT 			(5), 
	
		.PIC_SCALED_WIDTH0  	(480),
		.PIC_SCALED_HEIGHT0 	(270),
		// .PIC_SCALED_WIDTH1  	(480/1.5),
		// .PIC_SCALED_HEIGHT1 	(270/1.5),
		.PIC_SCALED_WIDTH1  	(320),
		.PIC_SCALED_HEIGHT1 	(180),
		
		.PIC_SCALED_WIDTH2  	(480/2),
		.PIC_SCALED_HEIGHT2 	(270/2),
		.PIC_SCALED_WIDTH3  	(480/3),
		.PIC_SCALED_HEIGHT3 	(270/3),
		.PIC_SCALED_WIDTH4  	(480/5),
		.PIC_SCALED_HEIGHT4 	(270/5),			
		
		.cam_width				(1920),
		.cam_height				(1080),
		.pic_width				(1920/4),
		.pic_height				(1080/4),
		.cam_scale				(4),
		.en						(1'b1),	
		.cam_clk				(vi_clk),
		
		.cam_vsync_i			(vi_vsync_d[1]),
		.cam_hsync_i			(vi_hsync_d[1]),
		.cam_href_i				(vi_de_d[1]),
		.cam_data_i				(vi_data_d[1]),					
	
		// delay 4 clks 	
		.vsync_o				(vsync_o),
		.hsync_o				(hsync_o),
		.de_o					(de_o),
		.q        		   		(q_o)
	);
	

	always @(posedge vo_clk or negedge rstn) 
        if (!rstn) LED4 <= `LED_INIT_VALUE;
        else       LED4 <= `LED_POL vi_vsync_d[1];
	always @(posedge vo_clk or negedge rstn) 
        if (!rstn) LED5 <= `LED_INIT_VALUE;
        else       LED5 <= `LED_POL q_o;
	
	wire	[`W_HDMITX:0] data_o  = q_o ?  {vi_data_d[5][`W_HDMITX:8], 8'hff}: vi_data_d[5];
	
	
	reg	[7:0]	vsync_o_d;
	always @(*)	vsync_o_d[0] = vsync_o;
	always @(posedge vo_clk)
		if (`RST)	vsync_o_d[7:1] <= 0;
		else 		vsync_o_d[7:1] <= vsync_o_d;
	reg	[7:0]	hsync_o_d;
	always @(*)	hsync_o_d[0] = hsync_o;
	always @(posedge vo_clk)
		if (`RST)	hsync_o_d[7:1] <= 0;
		else 		hsync_o_d[7:1] <= hsync_o_d;
	reg	[7:0]	de_o_d;
	always @(*)	de_o_d[0] = de_o;
	always @(posedge vo_clk)
		if (`RST)	de_o_d[7:1] <= 0;
		else 		de_o_d[7:1] <= de_o_d;
	reg	[7:0][`W_HDMITX:0]	data_o_d;
	always @(*)	data_o_d[0] = data_o;
	always @(posedge vo_clk)
		if (`RST)	data_o_d[7:1] <= 0;
		else 		data_o_d[7:1] <= data_o_d;
		
	always@* begin
		vo_vsync = vsync_o_d[3];
		vo_hsync = hsync_o_d[3];	
		vo_de = de_o_d[3];
		vo_data = data_o_d[3];
	end

endmodule


	
module dlyRst  #  
	(
	parameter  W_CNTRST    =  16
	)
	(
	input			clk,
	input			rstn_i,
	output reg		rstn
	);
	reg		rstn_b2, rstn_b1; 
	`ifdef SIMULATING	
    	reg                 [ 3:0]  reset_cnt;				
		wire						reset_cnt_end = ( 4'hF            == reset_cnt);
	`else
    	reg         [W_CNTRST-1:0]  reset_cnt;				
		wire						reset_cnt_end = ({W_CNTRST{1'b1}} == reset_cnt);
	`endif
    always @(posedge clk or negedge rstn_i) 
        if (!rstn_i)           		reset_cnt <= 0;
        else if (!reset_cnt_end)	reset_cnt <= reset_cnt + 1;
    always @(posedge clk or negedge rstn_i)
    	if (!rstn_i)	{rstn_b2, rstn_b1, rstn} <= 0;
		else 			{rstn_b2, rstn_b1, rstn} <= {reset_cnt_end, rstn_b2, rstn_b1};
endmodule

