module user_project_wrapper (user_clock2,
    wb_clk_i,
    wb_rst_i,
    wbs_ack_o,
    wbs_cyc_i,
    wbs_stb_i,
    wbs_we_i,
    analog_io,
    io_in,
    io_oeb,
    io_out,
    la_data_in,
    la_data_out,
    la_oenb,
    user_irq,
    wbs_adr_i,
    wbs_dat_i,
    wbs_dat_o,
    wbs_sel_i);
 input user_clock2;
 input wb_clk_i;
 input wb_rst_i;
 output wbs_ack_o;
 input wbs_cyc_i;
 input wbs_stb_i;
 input wbs_we_i;
 inout [28:0] analog_io;
 input [37:0] io_in;
 output [37:0] io_oeb;
 output [37:0] io_out;
 input [127:0] la_data_in;
 output [127:0] la_data_out;
 input [127:0] la_oenb;
 output [2:0] user_irq;
 input [31:0] wbs_adr_i;
 input [31:0] wbs_dat_i;
 output [31:0] wbs_dat_o;
 input [3:0] wbs_sel_i;

 wire \afe_data[0] ;
 wire \afe_data[10] ;
 wire \afe_data[11] ;
 wire \afe_data[1] ;
 wire \afe_data[2] ;
 wire \afe_data[3] ;
 wire \afe_data[4] ;
 wire \afe_data[5] ;
 wire \afe_data[6] ;
 wire \afe_data[7] ;
 wire \afe_data[8] ;
 wire \afe_data[9] ;
 wire afe_eof;
 wire afe_ibias;
 wire afe_nbias;
 wire afe_refby2;
 wire afe_refhi;
 wire afe_vout;
 wire afe_vref;
 wire \analog_ctrl[0] ;
 wire \analog_ctrl[100] ;
 wire \analog_ctrl[101] ;
 wire \analog_ctrl[102] ;
 wire \analog_ctrl[103] ;
 wire \analog_ctrl[104] ;
 wire \analog_ctrl[105] ;
 wire \analog_ctrl[106] ;
 wire \analog_ctrl[107] ;
 wire \analog_ctrl[108] ;
 wire \analog_ctrl[109] ;
 wire \analog_ctrl[10] ;
 wire \analog_ctrl[110] ;
 wire \analog_ctrl[111] ;
 wire \analog_ctrl[112] ;
 wire \analog_ctrl[113] ;
 wire \analog_ctrl[114] ;
 wire \analog_ctrl[115] ;
 wire \analog_ctrl[116] ;
 wire \analog_ctrl[117] ;
 wire \analog_ctrl[118] ;
 wire \analog_ctrl[119] ;
 wire \analog_ctrl[11] ;
 wire \analog_ctrl[120] ;
 wire \analog_ctrl[121] ;
 wire \analog_ctrl[122] ;
 wire \analog_ctrl[12] ;
 wire \analog_ctrl[13] ;
 wire \analog_ctrl[14] ;
 wire \analog_ctrl[15] ;
 wire \analog_ctrl[16] ;
 wire \analog_ctrl[17] ;
 wire \analog_ctrl[18] ;
 wire \analog_ctrl[19] ;
 wire \analog_ctrl[1] ;
 wire \analog_ctrl[20] ;
 wire \analog_ctrl[21] ;
 wire \analog_ctrl[22] ;
 wire \analog_ctrl[23] ;
 wire \analog_ctrl[24] ;
 wire \analog_ctrl[25] ;
 wire \analog_ctrl[26] ;
 wire \analog_ctrl[27] ;
 wire \analog_ctrl[28] ;
 wire \analog_ctrl[29] ;
 wire \analog_ctrl[2] ;
 wire \analog_ctrl[30] ;
 wire \analog_ctrl[31] ;
 wire \analog_ctrl[32] ;
 wire \analog_ctrl[33] ;
 wire \analog_ctrl[34] ;
 wire \analog_ctrl[35] ;
 wire \analog_ctrl[36] ;
 wire \analog_ctrl[37] ;
 wire \analog_ctrl[38] ;
 wire \analog_ctrl[39] ;
 wire \analog_ctrl[3] ;
 wire \analog_ctrl[40] ;
 wire \analog_ctrl[41] ;
 wire \analog_ctrl[42] ;
 wire \analog_ctrl[43] ;
 wire \analog_ctrl[44] ;
 wire \analog_ctrl[45] ;
 wire \analog_ctrl[46] ;
 wire \analog_ctrl[47] ;
 wire \analog_ctrl[48] ;
 wire \analog_ctrl[49] ;
 wire \analog_ctrl[4] ;
 wire \analog_ctrl[50] ;
 wire \analog_ctrl[51] ;
 wire \analog_ctrl[52] ;
 wire \analog_ctrl[53] ;
 wire \analog_ctrl[54] ;
 wire \analog_ctrl[55] ;
 wire \analog_ctrl[56] ;
 wire \analog_ctrl[57] ;
 wire \analog_ctrl[58] ;
 wire \analog_ctrl[59] ;
 wire \analog_ctrl[5] ;
 wire \analog_ctrl[60] ;
 wire \analog_ctrl[61] ;
 wire \analog_ctrl[62] ;
 wire \analog_ctrl[63] ;
 wire \analog_ctrl[64] ;
 wire \analog_ctrl[65] ;
 wire \analog_ctrl[66] ;
 wire \analog_ctrl[67] ;
 wire \analog_ctrl[68] ;
 wire \analog_ctrl[69] ;
 wire \analog_ctrl[6] ;
 wire \analog_ctrl[70] ;
 wire \analog_ctrl[71] ;
 wire \analog_ctrl[72] ;
 wire \analog_ctrl[73] ;
 wire \analog_ctrl[74] ;
 wire \analog_ctrl[75] ;
 wire \analog_ctrl[76] ;
 wire \analog_ctrl[77] ;
 wire \analog_ctrl[78] ;
 wire \analog_ctrl[79] ;
 wire \analog_ctrl[7] ;
 wire \analog_ctrl[80] ;
 wire \analog_ctrl[81] ;
 wire \analog_ctrl[82] ;
 wire \analog_ctrl[83] ;
 wire \analog_ctrl[84] ;
 wire \analog_ctrl[85] ;
 wire \analog_ctrl[86] ;
 wire \analog_ctrl[87] ;
 wire \analog_ctrl[88] ;
 wire \analog_ctrl[89] ;
 wire \analog_ctrl[8] ;
 wire \analog_ctrl[90] ;
 wire \analog_ctrl[91] ;
 wire \analog_ctrl[92] ;
 wire \analog_ctrl[93] ;
 wire \analog_ctrl[94] ;
 wire \analog_ctrl[95] ;
 wire \analog_ctrl[96] ;
 wire \analog_ctrl[97] ;
 wire \analog_ctrl[98] ;
 wire \analog_ctrl[99] ;
 wire \analog_ctrl[9] ;

 afe_wb u_afe_wb (.adc_eof(afe_eof),
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_we_i(wbs_we_i),
    .adc_data({\afe_data[11] ,
    \afe_data[10] ,
    \afe_data[9] ,
    \afe_data[8] ,
    \afe_data[7] ,
    \afe_data[6] ,
    \afe_data[5] ,
    \afe_data[4] ,
    \afe_data[3] ,
    \afe_data[2] ,
    \afe_data[1] ,
    \afe_data[0] }),
    .analog_ctrl({\analog_ctrl[122] ,
    \analog_ctrl[121] ,
    \analog_ctrl[120] ,
    \analog_ctrl[119] ,
    \analog_ctrl[118] ,
    \analog_ctrl[117] ,
    \analog_ctrl[116] ,
    \analog_ctrl[115] ,
    \analog_ctrl[114] ,
    \analog_ctrl[113] ,
    \analog_ctrl[112] ,
    \analog_ctrl[111] ,
    \analog_ctrl[110] ,
    \analog_ctrl[109] ,
    \analog_ctrl[108] ,
    \analog_ctrl[107] ,
    \analog_ctrl[106] ,
    \analog_ctrl[105] ,
    \analog_ctrl[104] ,
    \analog_ctrl[103] ,
    \analog_ctrl[102] ,
    \analog_ctrl[101] ,
    \analog_ctrl[100] ,
    \analog_ctrl[99] ,
    \analog_ctrl[98] ,
    \analog_ctrl[97] ,
    \analog_ctrl[96] ,
    \analog_ctrl[95] ,
    \analog_ctrl[94] ,
    \analog_ctrl[93] ,
    \analog_ctrl[92] ,
    \analog_ctrl[91] ,
    \analog_ctrl[90] ,
    \analog_ctrl[89] ,
    \analog_ctrl[88] ,
    \analog_ctrl[87] ,
    \analog_ctrl[86] ,
    \analog_ctrl[85] ,
    \analog_ctrl[84] ,
    \analog_ctrl[83] ,
    \analog_ctrl[82] ,
    \analog_ctrl[81] ,
    \analog_ctrl[80] ,
    \analog_ctrl[79] ,
    \analog_ctrl[78] ,
    \analog_ctrl[77] ,
    \analog_ctrl[76] ,
    \analog_ctrl[75] ,
    \analog_ctrl[74] ,
    \analog_ctrl[73] ,
    \analog_ctrl[72] ,
    \analog_ctrl[71] ,
    \analog_ctrl[70] ,
    \analog_ctrl[69] ,
    \analog_ctrl[68] ,
    \analog_ctrl[67] ,
    \analog_ctrl[66] ,
    \analog_ctrl[65] ,
    \analog_ctrl[64] ,
    \analog_ctrl[63] ,
    \analog_ctrl[62] ,
    \analog_ctrl[61] ,
    \analog_ctrl[60] ,
    \analog_ctrl[59] ,
    \analog_ctrl[58] ,
    \analog_ctrl[57] ,
    \analog_ctrl[56] ,
    \analog_ctrl[55] ,
    \analog_ctrl[54] ,
    \analog_ctrl[53] ,
    \analog_ctrl[52] ,
    \analog_ctrl[51] ,
    \analog_ctrl[50] ,
    \analog_ctrl[49] ,
    \analog_ctrl[48] ,
    \analog_ctrl[47] ,
    \analog_ctrl[46] ,
    \analog_ctrl[45] ,
    \analog_ctrl[44] ,
    \analog_ctrl[43] ,
    \analog_ctrl[42] ,
    \analog_ctrl[41] ,
    \analog_ctrl[40] ,
    \analog_ctrl[39] ,
    \analog_ctrl[38] ,
    \analog_ctrl[37] ,
    \analog_ctrl[36] ,
    \analog_ctrl[35] ,
    \analog_ctrl[34] ,
    \analog_ctrl[33] ,
    \analog_ctrl[32] ,
    \analog_ctrl[31] ,
    \analog_ctrl[30] ,
    \analog_ctrl[29] ,
    \analog_ctrl[28] ,
    \analog_ctrl[27] ,
    \analog_ctrl[26] ,
    \analog_ctrl[25] ,
    \analog_ctrl[24] ,
    \analog_ctrl[23] ,
    \analog_ctrl[22] ,
    \analog_ctrl[21] ,
    \analog_ctrl[20] ,
    \analog_ctrl[19] ,
    \analog_ctrl[18] ,
    \analog_ctrl[17] ,
    \analog_ctrl[16] ,
    \analog_ctrl[15] ,
    \analog_ctrl[14] ,
    \analog_ctrl[13] ,
    \analog_ctrl[12] ,
    \analog_ctrl[11] ,
    \analog_ctrl[10] ,
    \analog_ctrl[9] ,
    \analog_ctrl[8] ,
    \analog_ctrl[7] ,
    \analog_ctrl[6] ,
    \analog_ctrl[5] ,
    \analog_ctrl[4] ,
    \analog_ctrl[3] ,
    \analog_ctrl[2] ,
    \analog_ctrl[1] ,
    \analog_ctrl[0] }),
    .analog_io_oeb({io_oeb[34],
    io_oeb[33],
    io_oeb[32],
    io_oeb[31],
    io_oeb[30],
    io_oeb[29],
    io_oeb[28],
    io_oeb[27],
    io_oeb[26],
    io_oeb[25],
    io_oeb[24],
    io_oeb[23],
    io_oeb[22],
    io_oeb[21],
    io_oeb[20],
    io_oeb[19],
    io_oeb[18],
    io_oeb[17],
    io_oeb[16],
    io_oeb[15],
    io_oeb[14],
    io_oeb[13],
    io_oeb[12],
    io_oeb[11],
    io_oeb[10],
    io_oeb[9],
    io_oeb[8],
    io_oeb[7]}),
    .analog_io_out({io_out[34],
    io_out[33],
    io_out[32],
    io_out[31],
    io_out[30],
    io_out[29],
    io_out[28],
    io_out[27],
    io_out[26],
    io_out[25],
    io_out[24],
    io_out[23],
    io_out[22],
    io_out[21],
    io_out[20],
    io_out[19],
    io_out[18],
    io_out[17],
    io_out[16],
    io_out[15],
    io_out[14],
    io_out[13],
    io_out[12],
    io_out[11],
    io_out[10],
    io_out[9],
    io_out[8],
    io_out[7]}),
    .wbs_adr_i({wbs_adr_i[31],
    wbs_adr_i[30],
    wbs_adr_i[29],
    wbs_adr_i[28],
    wbs_adr_i[27],
    wbs_adr_i[26],
    wbs_adr_i[25],
    wbs_adr_i[24],
    wbs_adr_i[23],
    wbs_adr_i[22],
    wbs_adr_i[21],
    wbs_adr_i[20],
    wbs_adr_i[19],
    wbs_adr_i[18],
    wbs_adr_i[17],
    wbs_adr_i[16],
    wbs_adr_i[15],
    wbs_adr_i[14],
    wbs_adr_i[13],
    wbs_adr_i[12],
    wbs_adr_i[11],
    wbs_adr_i[10],
    wbs_adr_i[9],
    wbs_adr_i[8],
    wbs_adr_i[7],
    wbs_adr_i[6],
    wbs_adr_i[5],
    wbs_adr_i[4],
    wbs_adr_i[3],
    wbs_adr_i[2],
    wbs_adr_i[1],
    wbs_adr_i[0]}),
    .wbs_dat_i({wbs_dat_i[31],
    wbs_dat_i[30],
    wbs_dat_i[29],
    wbs_dat_i[28],
    wbs_dat_i[27],
    wbs_dat_i[26],
    wbs_dat_i[25],
    wbs_dat_i[24],
    wbs_dat_i[23],
    wbs_dat_i[22],
    wbs_dat_i[21],
    wbs_dat_i[20],
    wbs_dat_i[19],
    wbs_dat_i[18],
    wbs_dat_i[17],
    wbs_dat_i[16],
    wbs_dat_i[15],
    wbs_dat_i[14],
    wbs_dat_i[13],
    wbs_dat_i[12],
    wbs_dat_i[11],
    wbs_dat_i[10],
    wbs_dat_i[9],
    wbs_dat_i[8],
    wbs_dat_i[7],
    wbs_dat_i[6],
    wbs_dat_i[5],
    wbs_dat_i[4],
    wbs_dat_i[3],
    wbs_dat_i[2],
    wbs_dat_i[1],
    wbs_dat_i[0]}),
    .wbs_dat_o({wbs_dat_o[31],
    wbs_dat_o[30],
    wbs_dat_o[29],
    wbs_dat_o[28],
    wbs_dat_o[27],
    wbs_dat_o[26],
    wbs_dat_o[25],
    wbs_dat_o[24],
    wbs_dat_o[23],
    wbs_dat_o[22],
    wbs_dat_o[21],
    wbs_dat_o[20],
    wbs_dat_o[19],
    wbs_dat_o[18],
    wbs_dat_o[17],
    wbs_dat_o[16],
    wbs_dat_o[15],
    wbs_dat_o[14],
    wbs_dat_o[13],
    wbs_dat_o[12],
    wbs_dat_o[11],
    wbs_dat_o[10],
    wbs_dat_o[9],
    wbs_dat_o[8],
    wbs_dat_o[7],
    wbs_dat_o[6],
    wbs_dat_o[5],
    wbs_dat_o[4],
    wbs_dat_o[3],
    wbs_dat_o[2],
    wbs_dat_o[1],
    wbs_dat_o[0]}),
    .wbs_sel_i({wbs_sel_i[3],
    wbs_sel_i[2],
    wbs_sel_i[1],
    wbs_sel_i[0]}));
 CF_ADC_SAR12 u_cf_adc_sar12 (.en_pump_lv(\analog_ctrl[20] ),
    .vreflo(analog_io[22]),
    .scan_test_mode(\analog_ctrl[21] ),
    .test_scanin(\analog_ctrl[22] ),
    .test_scanen(\analog_ctrl[23] ),
    .hiz(\analog_ctrl[13] ),
    .sof(\analog_ctrl[11] ),
    .test_sea(\analog_ctrl[24] ),
    .reset_n(\analog_ctrl[10] ),
    .eof(afe_eof),
    .iso_en(\analog_ctrl[14] ),
    .next(\analog_ctrl[12] ),
    .vinp(afe_vout),
    .vinm(analog_io[20]),
    .vrefhi(afe_refhi),
    .trimunit(\analog_ctrl[16] ),
    .vdda(analog_io[25]),
    .VPUMP(analog_io[27]),
    .vssa(analog_io[26]),
    .refby2(afe_refby2),
    .pumpclk(\analog_ctrl[19] ),
    .pd(\analog_ctrl[8] ),
    .pd_ana(\analog_ctrl[9] ),
    .refclk(user_clock2),
    .dly_inc(\analog_ctrl[17] ),
    .dcen(\analog_ctrl[18] ),
    .ibias2p5u(afe_ibias),
    .ibias2p5u_1(afe_ibias),
    .enable_hv(\analog_ctrl[15] ),
    .cap_trim({\analog_ctrl[39] ,
    \analog_ctrl[38] ,
    \analog_ctrl[37] }),
    .data_out({\afe_data[11] ,
    \afe_data[10] ,
    \afe_data[9] ,
    \afe_data[8] ,
    \afe_data[7] ,
    \afe_data[6] ,
    \afe_data[5] ,
    \afe_data[4] ,
    \afe_data[3] ,
    \afe_data[2] ,
    \afe_data[1] ,
    \afe_data[0] }),
    .dft_inc({\analog_ctrl[45] ,
    \analog_ctrl[44] ,
    \analog_ctrl[43] ,
    \analog_ctrl[42] }),
    .dft_outc({\analog_ctrl[48] ,
    \analog_ctrl[47] ,
    \analog_ctrl[46] }),
    .icont_lv({\analog_ctrl[41] ,
    \analog_ctrl[40] }),
    .resolution({\analog_ctrl[26] ,
    \analog_ctrl[25] }),
    .sample_width({\analog_ctrl[36] ,
    \analog_ctrl[35] ,
    \analog_ctrl[34] ,
    \analog_ctrl[33] ,
    \analog_ctrl[32] ,
    \analog_ctrl[31] ,
    \analog_ctrl[30] ,
    \analog_ctrl[29] ,
    \analog_ctrl[28] ,
    \analog_ctrl[27] }),
    .sel_csel_dft({\analog_ctrl[52] ,
    \analog_ctrl[51] ,
    \analog_ctrl[50] ,
    \analog_ctrl[49] }));
 CF_ADC_SAR12_sar_refs u_cf_adc_sar12_sar_refs (.vdda(analog_io[25]),
    .VPUMP(analog_io[27]),
    .vssa(analog_io[26]),
    .pd(\analog_ctrl[8] ),
    .hiz(\analog_ctrl[13] ),
    .REFBY2(afe_refby2),
    .pd_ana(\analog_ctrl[9] ),
    .EN_RESVDA(\analog_ctrl[63] ),
    .IREF_VCMBUF(afe_ibias),
    .sw_start(\analog_ctrl[108] ),
    .pd_vcmbuf(\analog_ctrl[109] ),
    .refout(analog_io[21]),
    .refout_en(\analog_ctrl[118] ),
    .sw_holdb(\analog_ctrl[119] ),
    .enpdb_hv(\analog_ctrl[120] ),
    .REFHI(afe_refhi),
    .enable_hv(\analog_ctrl[15] ),
    .IREF_VREFBUF(afe_ibias),
    .PD_BUF_VREF(\analog_ctrl[121] ),
    .vssa_shield(analog_io[26]),
    .dft_comp_en(\analog_ctrl[122] ),
    .PWR_CTRL_VREF({\analog_ctrl[59] ,
    \analog_ctrl[58] }),
    .S_LV({\analog_ctrl[117] ,
    \analog_ctrl[116] ,
    \analog_ctrl[115] ,
    \analog_ctrl[114] ,
    \analog_ctrl[113] ,
    \analog_ctrl[112] ,
    \analog_ctrl[111] ,
    \analog_ctrl[110] }),
    .muxsarref({\analog_ctrl[62] ,
    \analog_ctrl[61] ,
    \analog_ctrl[60] }),
    .vref({\analog_ctrl[57] ,
    \analog_ctrl[56] ,
    \analog_ctrl[55] ,
    \analog_ctrl[54] ,
    \analog_ctrl[53] }));
 CF_BGR u_cf_bgr (.finetune(\analog_ctrl[96] ),
    .en_startb(\analog_ctrl[97] ),
    .mux2sel(\analog_ctrl[92] ),
    .dft_sel(\analog_ctrl[93] ),
    .pd_ibg(\analog_ctrl[95] ),
    .pd(\analog_ctrl[94] ),
    .dft_curr_in(analog_io[24]),
    .vb2_fast(analog_io[0]),
    .Vout(afe_vref),
    .ibg_3uA(afe_nbias),
    .ibg_2p375uA(afe_ibias),
    .CurrAbsTrim({\analog_ctrl[82] ,
    \analog_ctrl[81] ,
    \analog_ctrl[80] ,
    \analog_ctrl[79] ,
    \analog_ctrl[78] ,
    \analog_ctrl[77] }),
    .inl_ctrl({\analog_ctrl[89] ,
    \analog_ctrl[88] ,
    \analog_ctrl[87] ,
    \analog_ctrl[86] ,
    \analog_ctrl[85] ,
    \analog_ctrl[84] ,
    \analog_ctrl[83] }),
    .mux1sel({\analog_ctrl[91] ,
    \analog_ctrl[90] }),
    .trimCurr({\analog_ctrl[76] ,
    \analog_ctrl[75] ,
    \analog_ctrl[74] ,
    \analog_ctrl[73] ,
    \analog_ctrl[72] ,
    \analog_ctrl[71] }),
    .trimTC({\analog_ctrl[70] ,
    \analog_ctrl[69] ,
    \analog_ctrl[68] ,
    \analog_ctrl[67] ,
    \analog_ctrl[66] ,
    \analog_ctrl[65] ,
    \analog_ctrl[64] }));
 CF_BUF_HIZ u_cf_buf_hiz (.tp(\analog_ctrl[2] ),
    .clk2_boost(\analog_ctrl[3] ),
    .clk1_boostr(\analog_ctrl[6] ),
    .vbpt(analog_io[9]),
    .vbpcis(analog_io[16]),
    .vbncis(analog_io[17]),
    .vout(afe_vout),
    .vbpci(analog_io[14]),
    .vbnt(analog_io[10]),
    .ibias(afe_ibias),
    .e_pd(\analog_ctrl[0] ),
    .vbnci(analog_io[15]),
    .vbpcid(analog_io[18]),
    .vbptd(analog_io[19]),
    .vbnc(analog_io[13]),
    .vbpc(analog_io[12]),
    .en_pd(\analog_ctrl[1] ),
    .vbpb(analog_io[11]),
    .vinp_n(analog_io[3]),
    .vinn_n(analog_io[4]),
    .vinp_na(analog_io[5]),
    .vinn_na(analog_io[6]),
    .vinn_p(analog_io[2]),
    .vinp_p(analog_io[1]),
    .e_na_boost(\analog_ctrl[5] ),
    .e_n_boost(\analog_ctrl[4] ));
 CF_REFBUF u_cf_refbuf (.nbias(afe_nbias),
    .out(analog_io[7]),
    .ref_1v2(afe_vref),
    .pd(\analog_ctrl[104] ),
    .ng(analog_io[8]),
    .switchon(\analog_ctrl[105] ),
    .ch_cont(\analog_ctrl[107] ),
    .boost(\analog_ctrl[106] ),
    .vpwre(analog_io[8]),
    .ch2(analog_io[7]),
    .ch1(analog_io[7]));
endmodule
