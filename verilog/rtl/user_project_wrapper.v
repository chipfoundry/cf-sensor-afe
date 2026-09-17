`default_nettype none
/*
 * user_project_wrapper — HIZ + SAR12 + BGR + REFBUF + sar_refs + afe_wb
 *
 * On-chip analog:
 *   afe_vout   : CF_BUF_HIZ.vout → CF_ADC_SAR12.vinp
 *   afe_ibias  : CF_BGR.ibg_2p375uA → HIZ.ibias, SAR.ibias2p5u,
 *                sar_refs.IREF_VCMBUF / IREF_VREFBUF
 *   afe_vref   : CF_BGR.Vout → CF_REFBUF.ref_1v2
 *   afe_nbias  : CF_BGR.ibg_3uA → CF_REFBUF.nbias
 *   afe_refhi  : sar_refs.REFHI → SAR.vrefhi
 *   afe_refby2 : sar_refs.REFBY2 → SAR.refby2
 *
 * Analog controls come from afe_wb.analog_ctrl[i]; indices match the
 * original LA map. Caravel la_data_in / la_data_out / la_oenb are unused.
 *
 * Elaborate-only: structural instance wiring, no assign.
 *
 * Analog: analog_io[N] is Caravel GPIO N+7.
 * analog_io[23] (GPIO 30) is unused; GPIO 30 is mgmt input.
 * Analog pads GPIO 7-34 are Hi-Z from afe_wb analog_io_oeb/out.
 * JsonHeader applies USE_POWER_PINS for PDN.
 */

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdda1,
    inout vdda2,
    inout vssa1,
    inout vssa2,
    inout vccd1,
    inout vccd2,
    inout vssd1,
    inout vssd2,
`endif

    input wb_clk_i,
    input wb_rst_i,
    input wbs_stb_i,
    input wbs_cyc_i,
    input wbs_we_i,
    input [3:0] wbs_sel_i,
    input [31:0] wbs_dat_i,
    input [31:0] wbs_adr_i,
    output wbs_ack_o,
    output [31:0] wbs_dat_o,

    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    inout [`MPRJ_IO_PADS-10:0] analog_io,

    input   user_clock2,

    output [2:0] user_irq
);

    wire afe_vout;
    wire afe_ibias;
    wire afe_vref;
    wire afe_nbias;
    wire afe_refhi;
    wire afe_refby2;
    wire [122:0] analog_ctrl;
    wire [11:0] afe_data;
    wire afe_eof;

afe_wb u_afe_wb (
    .wb_clk_i(wb_clk_i),
    .wb_rst_i(wb_rst_i),
    .wbs_stb_i(wbs_stb_i),
    .wbs_cyc_i(wbs_cyc_i),
    .wbs_we_i(wbs_we_i),
    .wbs_sel_i(wbs_sel_i),
    .wbs_dat_i(wbs_dat_i),
    .wbs_adr_i(wbs_adr_i),
    .wbs_ack_o(wbs_ack_o),
    .wbs_dat_o(wbs_dat_o),
    .adc_data(afe_data),
    .adc_eof(afe_eof),
    .analog_ctrl(analog_ctrl),
    .analog_io_oeb(io_oeb[34:7]),
    .analog_io_out(io_out[34:7])
`ifdef USE_POWER_PINS
    ,
    .vccd1(vccd1),
    .vssd1(vssd1)
`endif
);

CF_BUF_HIZ u_cf_buf_hiz (
    .vout(afe_vout),
    .ibias(afe_ibias),
    .vinp_p(analog_io[1]),
    .vinn_p(analog_io[2]),
    .vinp_n(analog_io[3]),
    .vinn_n(analog_io[4]),
    .vinp_na(analog_io[5]),
    .vinn_na(analog_io[6]),
    .vbpt(analog_io[9]),
    .vbnt(analog_io[10]),
    .vbpb(analog_io[11]),
    .vbpc(analog_io[12]),
    .vbnc(analog_io[13]),
    .vbpci(analog_io[14]),
    .vbnci(analog_io[15]),
    .vbpcis(analog_io[16]),
    .vbncis(analog_io[17]),
    .vbpcid(analog_io[18]),
    .vbptd(analog_io[19]),

    .e_pd(analog_ctrl[0]),
    .en_pd(analog_ctrl[1]),
    .tp(analog_ctrl[2]),
    .clk2_boost(analog_ctrl[3]),
    .e_n_boost(analog_ctrl[4]),
    .e_na_boost(analog_ctrl[5]),
    .clk1_boostr(analog_ctrl[6]),

`ifdef USE_POWER_PINS
    .vgnd(vssd1),
    .vpwr(vccd1)
`endif
);

CF_ADC_SAR12 u_cf_adc_sar12 (
    .vinp(afe_vout),
    .vinm(analog_io[20]),
    .vrefhi(afe_refhi),
    .vreflo(analog_io[22]),
    .refby2(afe_refby2),
    .ibias2p5u(afe_ibias),
    .ibias2p5u_1(afe_ibias),
    .vdda(analog_io[25]),
    .vssa(analog_io[26]),
    .VPUMP(analog_io[27]),

    .refclk(user_clock2),
    .pd(analog_ctrl[8]),
    .pd_ana(analog_ctrl[9]),
    .reset_n(analog_ctrl[10]),
    .sof(analog_ctrl[11]),
    .next(analog_ctrl[12]),
    .hiz(analog_ctrl[13]),
    .iso_en(analog_ctrl[14]),
    .enable_hv(analog_ctrl[15]),
    .trimunit(analog_ctrl[16]),
    .dly_inc(analog_ctrl[17]),
    .dcen(analog_ctrl[18]),
    .pumpclk(analog_ctrl[19]),
    .en_pump_lv(analog_ctrl[20]),
    .scan_test_mode(analog_ctrl[21]),
    .test_scanin(analog_ctrl[22]),
    .test_scanen(analog_ctrl[23]),
    .test_sea(analog_ctrl[24]),
    .resolution(analog_ctrl[26:25]),
    .sample_width(analog_ctrl[36:27]),
    .cap_trim(analog_ctrl[39:37]),
    .icont_lv(analog_ctrl[41:40]),
    .dft_inc(analog_ctrl[45:42]),
    .dft_outc(analog_ctrl[48:46]),
    .sel_csel_dft(analog_ctrl[52:49]),

    .data_out(afe_data),
    .eof(afe_eof),

`ifdef USE_POWER_PINS
    .vgnd(vssd1),
    .vpwr(vccd1)
`endif
);

CF_BGR u_cf_bgr (
    .ibg_2p375uA(afe_ibias),
    .ibg_3uA(afe_nbias),
    .Vout(afe_vref),
    .vb2_fast(analog_io[0]),
    .dft_curr_in(analog_io[24]),

    .trimTC(analog_ctrl[70:64]),
    .trimCurr(analog_ctrl[76:71]),
    .CurrAbsTrim(analog_ctrl[82:77]),
    .inl_ctrl(analog_ctrl[89:83]),
    .mux1sel(analog_ctrl[91:90]),
    .mux2sel(analog_ctrl[92]),
    .dft_sel(analog_ctrl[93]),
    .pd(analog_ctrl[94]),
    .pd_ibg(analog_ctrl[95]),
    .finetune(analog_ctrl[96]),
    .en_startb(analog_ctrl[97]),

`ifdef USE_POWER_PINS
    .vgnd(vssd1),
    .vpwr(vccd1)
`endif
);

CF_REFBUF u_cf_refbuf (
    .out(analog_io[7]),
    .ch1(analog_io[7]),
    .ch2(analog_io[7]),
    .ref_1v2(afe_vref),
    .nbias(afe_nbias),
    .ng(analog_io[8]),
    .vpwre(analog_io[8]),

    .pd(analog_ctrl[104]),
    .switchon(analog_ctrl[105]),
    .boost(analog_ctrl[106]),
    .ch_cont(analog_ctrl[107]),

`ifdef USE_POWER_PINS
    .vgnd(vssd1),
    .vpwr(vccd1)
`endif
);

CF_ADC_SAR12_sar_refs u_cf_adc_sar12_sar_refs (
    .REFHI(afe_refhi),
    .REFBY2(afe_refby2),
    .refout(analog_io[21]),
    .IREF_VCMBUF(afe_ibias),
    .IREF_VREFBUF(afe_ibias),
    .vdda(analog_io[25]),
    .vssa(analog_io[26]),
    .vssa_shield(analog_io[26]),
    .VPUMP(analog_io[27]),

    .pd(analog_ctrl[8]),
    .pd_ana(analog_ctrl[9]),
    .hiz(analog_ctrl[13]),
    .enable_hv(analog_ctrl[15]),
    .vref(analog_ctrl[57:53]),
    .PWR_CTRL_VREF(analog_ctrl[59:58]),
    .muxsarref(analog_ctrl[62:60]),
    .EN_RESVDA(analog_ctrl[63]),
    .sw_start(analog_ctrl[108]),
    .pd_vcmbuf(analog_ctrl[109]),
    .S_LV(analog_ctrl[117:110]),
    .refout_en(analog_ctrl[118]),
    .sw_holdb(analog_ctrl[119]),
    .enpdb_hv(analog_ctrl[120]),
    .PD_BUF_VREF(analog_ctrl[121]),
    .dft_comp_en(analog_ctrl[122]),

`ifdef USE_POWER_PINS
    .vgnd(vssd1),
    .vpwr(vccd1)
`endif
);

endmodule

`default_nettype wire
