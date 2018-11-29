// Copyright (c) 2018  LulinChen, All Rights Reserved
// AUTHOR : 	LulinChen
// AUTHOR'S EMAIL : lulinchen@aliyun.com 
// Release history
// VERSION Date AUTHOR DESCRIPTION

module DmtCnt0( // @[:@3.2]
  input         clock, // @[:@4.4]
  input         reset, // @[:@5.4]
  input         io_en, // @[:@6.4]
  input         io_go, // @[:@6.4]
  input  [10:0] io_maxCntM1, // @[:@6.4]
  output        io_inc_f, // @[:@6.4]
  output        io_Max_f // @[:@6.4]
);
  reg [10:0] cnt_reg; // @[monitor.scala 37:26:@8.4]
  reg [31:0] _RAND_0;
  reg  inc_f_reg; // @[monitor.scala 38:28:@9.4]
  reg [31:0] _RAND_1;
  wire  _GEN_0; // @[monitor.scala 42:33:@15.8]
  wire  _GEN_1; // @[monitor.scala 41:21:@11.6]
  wire [11:0] _T_18; // @[monitor.scala 43:43:@18.6]
  wire [10:0] _T_19; // @[monitor.scala 43:43:@19.6]
  wire [10:0] _T_21; // @[monitor.scala 43:23:@20.6]
  wire  _GEN_2; // @[monitor.scala 40:17:@10.4]
  wire [10:0] _GEN_3; // @[monitor.scala 40:17:@10.4]
  wire  _T_22; // @[monitor.scala 46:43:@23.4]
  assign _GEN_0 = io_Max_f ? 1'h0 : inc_f_reg; // @[monitor.scala 42:33:@15.8]
  assign _GEN_1 = io_go ? 1'h1 : _GEN_0; // @[monitor.scala 41:21:@11.6]
  assign _T_18 = cnt_reg + 11'h1; // @[monitor.scala 43:43:@18.6]
  assign _T_19 = _T_18[10:0]; // @[monitor.scala 43:43:@19.6]
  assign _T_21 = inc_f_reg ? _T_19 : 11'h0; // @[monitor.scala 43:23:@20.6]
  assign _GEN_2 = io_en ? _GEN_1 : inc_f_reg; // @[monitor.scala 40:17:@10.4]
  assign _GEN_3 = io_en ? _T_21 : cnt_reg; // @[monitor.scala 40:17:@10.4]
  assign _T_22 = io_maxCntM1 == cnt_reg; // @[monitor.scala 46:43:@23.4]
  assign io_inc_f = inc_f_reg; // @[monitor.scala 49:14:@32.4]
  assign io_Max_f = inc_f_reg & _T_22; // @[monitor.scala 46:14:@25.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  cnt_reg = _RAND_0[10:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  inc_f_reg = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      cnt_reg <= 11'h0;
    end else begin
      if (io_en) begin
        if (inc_f_reg) begin
          cnt_reg <= _T_19;
        end else begin
          cnt_reg <= 11'h0;
        end
      end
    end
    if (reset) begin
      inc_f_reg <= 1'h1;
    end else begin
      if (io_en) begin
        if (io_go) begin
          inc_f_reg <= 1'h1;
        end else begin
          if (io_Max_f) begin
            inc_f_reg <= 1'h0;
          end
        end
      end
    end
  end
endmodule
module DmtCnt( // @[:@34.2]
  input         clock, // @[:@35.4]
  input         reset, // @[:@36.4]
  input         io_en, // @[:@37.4]
  input         io_go, // @[:@37.4]
  input  [10:0] io_maxCntM1, // @[:@37.4]
  output [10:0] io_cnt, // @[:@37.4]
  output        io_inc_f, // @[:@37.4]
  output        io_Max_f // @[:@37.4]
);
  reg [10:0] cnt_reg; // @[monitor.scala 19:26:@39.4]
  reg [31:0] _RAND_0;
  reg  inc_f_reg; // @[monitor.scala 20:28:@40.4]
  reg [31:0] _RAND_1;
  wire  _GEN_0; // @[monitor.scala 24:29:@46.8]
  wire  _GEN_1; // @[monitor.scala 23:21:@42.6]
  wire [11:0] _T_18; // @[monitor.scala 25:43:@49.6]
  wire [10:0] _T_19; // @[monitor.scala 25:43:@50.6]
  wire [10:0] _T_21; // @[monitor.scala 25:23:@51.6]
  wire  _GEN_2; // @[monitor.scala 22:17:@41.4]
  wire [10:0] _GEN_3; // @[monitor.scala 22:17:@41.4]
  wire  _T_22; // @[monitor.scala 28:43:@54.4]
  assign _GEN_0 = io_Max_f ? 1'h0 : inc_f_reg; // @[monitor.scala 24:29:@46.8]
  assign _GEN_1 = io_go ? 1'h1 : _GEN_0; // @[monitor.scala 23:21:@42.6]
  assign _T_18 = cnt_reg + 11'h1; // @[monitor.scala 25:43:@49.6]
  assign _T_19 = _T_18[10:0]; // @[monitor.scala 25:43:@50.6]
  assign _T_21 = inc_f_reg ? _T_19 : 11'h0; // @[monitor.scala 25:23:@51.6]
  assign _GEN_2 = io_en ? _GEN_1 : inc_f_reg; // @[monitor.scala 22:17:@41.4]
  assign _GEN_3 = io_en ? _T_21 : cnt_reg; // @[monitor.scala 22:17:@41.4]
  assign _T_22 = io_maxCntM1 == cnt_reg; // @[monitor.scala 28:43:@54.4]
  assign io_cnt = cnt_reg; // @[monitor.scala 30:12:@62.4]
  assign io_inc_f = inc_f_reg; // @[monitor.scala 31:14:@63.4]
  assign io_Max_f = inc_f_reg & _T_22; // @[monitor.scala 28:14:@56.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  cnt_reg = _RAND_0[10:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  inc_f_reg = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    if (reset) begin
      cnt_reg <= 11'h0;
    end else begin
      if (io_en) begin
        if (inc_f_reg) begin
          cnt_reg <= _T_19;
        end else begin
          cnt_reg <= 11'h0;
        end
      end
    end
    if (reset) begin
      inc_f_reg <= 1'h0;
    end else begin
      if (io_en) begin
        if (io_go) begin
          inc_f_reg <= 1'h1;
        end else begin
          if (io_Max_f) begin
            inc_f_reg <= 1'h0;
          end
        end
      end
    end
  end
endmodule
module monitor( // @[:@251.2]
  input         clock, // @[:@252.4]
  input         reset, // @[:@253.4]
  input         io_en, // @[:@254.4]
  input  [10:0] io_hfp_m1, // @[:@254.4]
  input  [10:0] io_hs_m1, // @[:@254.4]
  input  [10:0] io_hbp_m1, // @[:@254.4]
  input  [10:0] io_width_m1, // @[:@254.4]
  input  [10:0] io_vfp_m1, // @[:@254.4]
  input  [10:0] io_vs_m1, // @[:@254.4]
  input  [10:0] io_vbp_m1, // @[:@254.4]
  input  [10:0] io_height_m1, // @[:@254.4]
  output [10:0] io_cnt_h, // @[:@254.4]
  output [10:0] io_cnt_v, // @[:@254.4]
  output        io_vsync, // @[:@254.4]
  output        io_hsync, // @[:@254.4]
  output        io_de // @[:@254.4]
);
  wire  dmtc_hfp_clock; // @[monitor.scala 94:26:@273.4]
  wire  dmtc_hfp_reset; // @[monitor.scala 94:26:@273.4]
  wire  dmtc_hfp_io_en; // @[monitor.scala 94:26:@273.4]
  wire  dmtc_hfp_io_go; // @[monitor.scala 94:26:@273.4]
  wire [10:0] dmtc_hfp_io_maxCntM1; // @[monitor.scala 94:26:@273.4]
  wire  dmtc_hfp_io_inc_f; // @[monitor.scala 94:26:@273.4]
  wire  dmtc_hfp_io_Max_f; // @[monitor.scala 94:26:@273.4]
  wire  dmtc_hs_clock; // @[monitor.scala 95:26:@276.4]
  wire  dmtc_hs_reset; // @[monitor.scala 95:26:@276.4]
  wire  dmtc_hs_io_en; // @[monitor.scala 95:26:@276.4]
  wire  dmtc_hs_io_go; // @[monitor.scala 95:26:@276.4]
  wire [10:0] dmtc_hs_io_maxCntM1; // @[monitor.scala 95:26:@276.4]
  wire [10:0] dmtc_hs_io_cnt; // @[monitor.scala 95:26:@276.4]
  wire  dmtc_hs_io_inc_f; // @[monitor.scala 95:26:@276.4]
  wire  dmtc_hs_io_Max_f; // @[monitor.scala 95:26:@276.4]
  wire  dmtc_hbp_clock; // @[monitor.scala 96:26:@279.4]
  wire  dmtc_hbp_reset; // @[monitor.scala 96:26:@279.4]
  wire  dmtc_hbp_io_en; // @[monitor.scala 96:26:@279.4]
  wire  dmtc_hbp_io_go; // @[monitor.scala 96:26:@279.4]
  wire [10:0] dmtc_hbp_io_maxCntM1; // @[monitor.scala 96:26:@279.4]
  wire [10:0] dmtc_hbp_io_cnt; // @[monitor.scala 96:26:@279.4]
  wire  dmtc_hbp_io_inc_f; // @[monitor.scala 96:26:@279.4]
  wire  dmtc_hbp_io_Max_f; // @[monitor.scala 96:26:@279.4]
  wire  dmtc_h_clock; // @[monitor.scala 97:26:@282.4]
  wire  dmtc_h_reset; // @[monitor.scala 97:26:@282.4]
  wire  dmtc_h_io_en; // @[monitor.scala 97:26:@282.4]
  wire  dmtc_h_io_go; // @[monitor.scala 97:26:@282.4]
  wire [10:0] dmtc_h_io_maxCntM1; // @[monitor.scala 97:26:@282.4]
  wire [10:0] dmtc_h_io_cnt; // @[monitor.scala 97:26:@282.4]
  wire  dmtc_h_io_inc_f; // @[monitor.scala 97:26:@282.4]
  wire  dmtc_h_io_Max_f; // @[monitor.scala 97:26:@282.4]
  wire  dmtc_vfp_clock; // @[monitor.scala 99:26:@285.4]
  wire  dmtc_vfp_reset; // @[monitor.scala 99:26:@285.4]
  wire  dmtc_vfp_io_en; // @[monitor.scala 99:26:@285.4]
  wire  dmtc_vfp_io_go; // @[monitor.scala 99:26:@285.4]
  wire [10:0] dmtc_vfp_io_maxCntM1; // @[monitor.scala 99:26:@285.4]
  wire  dmtc_vfp_io_inc_f; // @[monitor.scala 99:26:@285.4]
  wire  dmtc_vfp_io_Max_f; // @[monitor.scala 99:26:@285.4]
  wire  dmtc_vs_clock; // @[monitor.scala 100:26:@288.4]
  wire  dmtc_vs_reset; // @[monitor.scala 100:26:@288.4]
  wire  dmtc_vs_io_en; // @[monitor.scala 100:26:@288.4]
  wire  dmtc_vs_io_go; // @[monitor.scala 100:26:@288.4]
  wire [10:0] dmtc_vs_io_maxCntM1; // @[monitor.scala 100:26:@288.4]
  wire [10:0] dmtc_vs_io_cnt; // @[monitor.scala 100:26:@288.4]
  wire  dmtc_vs_io_inc_f; // @[monitor.scala 100:26:@288.4]
  wire  dmtc_vs_io_Max_f; // @[monitor.scala 100:26:@288.4]
  wire  dmtc_vbp_clock; // @[monitor.scala 101:26:@291.4]
  wire  dmtc_vbp_reset; // @[monitor.scala 101:26:@291.4]
  wire  dmtc_vbp_io_en; // @[monitor.scala 101:26:@291.4]
  wire  dmtc_vbp_io_go; // @[monitor.scala 101:26:@291.4]
  wire [10:0] dmtc_vbp_io_maxCntM1; // @[monitor.scala 101:26:@291.4]
  wire [10:0] dmtc_vbp_io_cnt; // @[monitor.scala 101:26:@291.4]
  wire  dmtc_vbp_io_inc_f; // @[monitor.scala 101:26:@291.4]
  wire  dmtc_vbp_io_Max_f; // @[monitor.scala 101:26:@291.4]
  wire  dmtc_v_clock; // @[monitor.scala 102:26:@294.4]
  wire  dmtc_v_reset; // @[monitor.scala 102:26:@294.4]
  wire  dmtc_v_io_en; // @[monitor.scala 102:26:@294.4]
  wire  dmtc_v_io_go; // @[monitor.scala 102:26:@294.4]
  wire [10:0] dmtc_v_io_maxCntM1; // @[monitor.scala 102:26:@294.4]
  wire [10:0] dmtc_v_io_cnt; // @[monitor.scala 102:26:@294.4]
  wire  dmtc_v_io_inc_f; // @[monitor.scala 102:26:@294.4]
  wire  dmtc_v_io_Max_f; // @[monitor.scala 102:26:@294.4]
  wire  cnt_hfp_inc_f; // @[monitor.scala 79:29:@261.4 monitor.scala 121:20:@309.4]
  wire  _T_51; // @[monitor.scala 157:13:@337.4]
  reg  _T_53; // @[monitor.scala 157:37:@338.4]
  reg [31:0] _RAND_0;
  reg  hsync_reg; // @[monitor.scala 158:29:@342.4]
  reg [31:0] _RAND_1;
  wire  cnt_h_inc_f; // @[monitor.scala 82:27:@264.4 monitor.scala 124:20:@312.4]
  wire  cnt_v_inc_f; // @[monitor.scala 92:29:@272.4 monitor.scala 144:20:@328.4]
  reg  de_reg; // @[monitor.scala 159:26:@345.4]
  reg [31:0] _RAND_2;
  reg [10:0] _T_59; // @[monitor.scala 164:24:@350.4]
  reg [31:0] _RAND_3;
  reg [10:0] _T_61; // @[monitor.scala 165:24:@353.4]
  reg [31:0] _RAND_4;
  DmtCnt0 dmtc_hfp ( // @[monitor.scala 94:26:@273.4]
    .clock(dmtc_hfp_clock),
    .reset(dmtc_hfp_reset),
    .io_en(dmtc_hfp_io_en),
    .io_go(dmtc_hfp_io_go),
    .io_maxCntM1(dmtc_hfp_io_maxCntM1),
    .io_inc_f(dmtc_hfp_io_inc_f),
    .io_Max_f(dmtc_hfp_io_Max_f)
  );
  DmtCnt dmtc_hs ( // @[monitor.scala 95:26:@276.4]
    .clock(dmtc_hs_clock),
    .reset(dmtc_hs_reset),
    .io_en(dmtc_hs_io_en),
    .io_go(dmtc_hs_io_go),
    .io_maxCntM1(dmtc_hs_io_maxCntM1),
    .io_cnt(dmtc_hs_io_cnt),
    .io_inc_f(dmtc_hs_io_inc_f),
    .io_Max_f(dmtc_hs_io_Max_f)
  );
  DmtCnt dmtc_hbp ( // @[monitor.scala 96:26:@279.4]
    .clock(dmtc_hbp_clock),
    .reset(dmtc_hbp_reset),
    .io_en(dmtc_hbp_io_en),
    .io_go(dmtc_hbp_io_go),
    .io_maxCntM1(dmtc_hbp_io_maxCntM1),
    .io_cnt(dmtc_hbp_io_cnt),
    .io_inc_f(dmtc_hbp_io_inc_f),
    .io_Max_f(dmtc_hbp_io_Max_f)
  );
  DmtCnt dmtc_h ( // @[monitor.scala 97:26:@282.4]
    .clock(dmtc_h_clock),
    .reset(dmtc_h_reset),
    .io_en(dmtc_h_io_en),
    .io_go(dmtc_h_io_go),
    .io_maxCntM1(dmtc_h_io_maxCntM1),
    .io_cnt(dmtc_h_io_cnt),
    .io_inc_f(dmtc_h_io_inc_f),
    .io_Max_f(dmtc_h_io_Max_f)
  );
  DmtCnt0 dmtc_vfp ( // @[monitor.scala 99:26:@285.4]
    .clock(dmtc_vfp_clock),
    .reset(dmtc_vfp_reset),
    .io_en(dmtc_vfp_io_en),
    .io_go(dmtc_vfp_io_go),
    .io_maxCntM1(dmtc_vfp_io_maxCntM1),
    .io_inc_f(dmtc_vfp_io_inc_f),
    .io_Max_f(dmtc_vfp_io_Max_f)
  );
  DmtCnt dmtc_vs ( // @[monitor.scala 100:26:@288.4]
    .clock(dmtc_vs_clock),
    .reset(dmtc_vs_reset),
    .io_en(dmtc_vs_io_en),
    .io_go(dmtc_vs_io_go),
    .io_maxCntM1(dmtc_vs_io_maxCntM1),
    .io_cnt(dmtc_vs_io_cnt),
    .io_inc_f(dmtc_vs_io_inc_f),
    .io_Max_f(dmtc_vs_io_Max_f)
  );
  DmtCnt dmtc_vbp ( // @[monitor.scala 101:26:@291.4]
    .clock(dmtc_vbp_clock),
    .reset(dmtc_vbp_reset),
    .io_en(dmtc_vbp_io_en),
    .io_go(dmtc_vbp_io_go),
    .io_maxCntM1(dmtc_vbp_io_maxCntM1),
    .io_cnt(dmtc_vbp_io_cnt),
    .io_inc_f(dmtc_vbp_io_inc_f),
    .io_Max_f(dmtc_vbp_io_Max_f)
  );
  DmtCnt dmtc_v ( // @[monitor.scala 102:26:@294.4]
    .clock(dmtc_v_clock),
    .reset(dmtc_v_reset),
    .io_en(dmtc_v_io_en),
    .io_go(dmtc_v_io_go),
    .io_maxCntM1(dmtc_v_io_maxCntM1),
    .io_cnt(dmtc_v_io_cnt),
    .io_inc_f(dmtc_v_io_inc_f),
    .io_Max_f(dmtc_v_io_Max_f)
  );
  assign cnt_hfp_inc_f = dmtc_hfp_io_inc_f; // @[monitor.scala 79:29:@261.4 monitor.scala 121:20:@309.4]
  assign _T_51 = cnt_hfp_inc_f == 1'h0; // @[monitor.scala 157:13:@337.4]
  assign cnt_h_inc_f = dmtc_h_io_inc_f; // @[monitor.scala 82:27:@264.4 monitor.scala 124:20:@312.4]
  assign cnt_v_inc_f = dmtc_v_io_inc_f; // @[monitor.scala 92:29:@272.4 monitor.scala 144:20:@328.4]
  assign io_cnt_h = _T_59; // @[monitor.scala 164:14:@352.4]
  assign io_cnt_v = _T_61; // @[monitor.scala 165:14:@355.4]
  assign io_vsync = dmtc_vs_io_inc_f; // @[monitor.scala 161:14:@348.4]
  assign io_hsync = hsync_reg; // @[monitor.scala 160:14:@347.4]
  assign io_de = de_reg; // @[monitor.scala 162:14:@349.4]
  assign dmtc_hfp_clock = clock; // @[:@274.4]
  assign dmtc_hfp_reset = reset; // @[:@275.4]
  assign dmtc_hfp_io_en = io_en; // @[monitor.scala 104:20:@297.4]
  assign dmtc_hfp_io_go = dmtc_h_io_Max_f; // @[monitor.scala 116:20:@305.4]
  assign dmtc_hfp_io_maxCntM1 = io_hfp_m1; // @[monitor.scala 110:26:@301.4]
  assign dmtc_hs_clock = clock; // @[:@277.4]
  assign dmtc_hs_reset = reset; // @[:@278.4]
  assign dmtc_hs_io_en = io_en; // @[monitor.scala 105:19:@298.4]
  assign dmtc_hs_io_go = dmtc_hfp_io_Max_f; // @[monitor.scala 117:20:@306.4]
  assign dmtc_hs_io_maxCntM1 = io_hs_m1; // @[monitor.scala 111:26:@302.4]
  assign dmtc_hbp_clock = clock; // @[:@280.4]
  assign dmtc_hbp_reset = reset; // @[:@281.4]
  assign dmtc_hbp_io_en = io_en; // @[monitor.scala 106:20:@299.4]
  assign dmtc_hbp_io_go = dmtc_hs_io_Max_f; // @[monitor.scala 118:20:@307.4]
  assign dmtc_hbp_io_maxCntM1 = io_hbp_m1; // @[monitor.scala 112:26:@303.4]
  assign dmtc_h_clock = clock; // @[:@283.4]
  assign dmtc_h_reset = reset; // @[:@284.4]
  assign dmtc_h_io_en = io_en; // @[monitor.scala 107:18:@300.4]
  assign dmtc_h_io_go = dmtc_hbp_io_Max_f; // @[monitor.scala 119:20:@308.4]
  assign dmtc_h_io_maxCntM1 = io_width_m1; // @[monitor.scala 113:26:@304.4]
  assign dmtc_vfp_clock = clock; // @[:@286.4]
  assign dmtc_vfp_reset = reset; // @[:@287.4]
  assign dmtc_vfp_io_en = _T_51 & _T_53; // @[monitor.scala 126:20:@313.4]
  assign dmtc_vfp_io_go = dmtc_v_io_Max_f; // @[monitor.scala 136:20:@321.4]
  assign dmtc_vfp_io_maxCntM1 = io_vfp_m1; // @[monitor.scala 131:29:@317.4]
  assign dmtc_vs_clock = clock; // @[:@289.4]
  assign dmtc_vs_reset = reset; // @[:@290.4]
  assign dmtc_vs_io_en = _T_51 & _T_53; // @[monitor.scala 127:19:@314.4]
  assign dmtc_vs_io_go = dmtc_vfp_io_Max_f; // @[monitor.scala 137:20:@322.4]
  assign dmtc_vs_io_maxCntM1 = io_vs_m1; // @[monitor.scala 132:29:@318.4]
  assign dmtc_vbp_clock = clock; // @[:@292.4]
  assign dmtc_vbp_reset = reset; // @[:@293.4]
  assign dmtc_vbp_io_en = _T_51 & _T_53; // @[monitor.scala 128:20:@315.4]
  assign dmtc_vbp_io_go = dmtc_vs_io_Max_f; // @[monitor.scala 138:20:@323.4]
  assign dmtc_vbp_io_maxCntM1 = io_vbp_m1; // @[monitor.scala 133:29:@319.4]
  assign dmtc_v_clock = clock; // @[:@295.4]
  assign dmtc_v_reset = reset; // @[:@296.4]
  assign dmtc_v_io_en = _T_51 & _T_53; // @[monitor.scala 129:18:@316.4]
  assign dmtc_v_io_go = dmtc_vbp_io_Max_f; // @[monitor.scala 139:20:@324.4]
  assign dmtc_v_io_maxCntM1 = io_height_m1; // @[monitor.scala 134:29:@320.4]
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE
  integer initvar;
  initial begin
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
  `ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {1{`RANDOM}};
  _T_53 = _RAND_0[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_1 = {1{`RANDOM}};
  hsync_reg = _RAND_1[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_2 = {1{`RANDOM}};
  de_reg = _RAND_2[0:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_3 = {1{`RANDOM}};
  _T_59 = _RAND_3[10:0];
  `endif // RANDOMIZE_REG_INIT
  `ifdef RANDOMIZE_REG_INIT
  _RAND_4 = {1{`RANDOM}};
  _T_61 = _RAND_4[10:0];
  `endif // RANDOMIZE_REG_INIT
  end
`endif // RANDOMIZE
  always @(posedge clock) begin
    _T_53 <= dmtc_hfp_io_inc_f;
    hsync_reg <= dmtc_hs_io_inc_f;
    de_reg <= cnt_h_inc_f & cnt_v_inc_f;
    _T_59 <= dmtc_h_io_cnt;
    _T_61 <= dmtc_v_io_cnt;
  end
endmodule
