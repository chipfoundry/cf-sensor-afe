`default_nettype none
/*
 * user_project_wrapper — drop 4: HIZ + SAR12 + BGR + REFBUF + sar_refs
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
 * CF_ADC_SAR12_sar_refs is wrapped: chip PDN is vpwr/vgnd.
 * Elaborate-only: structural instance wiring, no assign.
 *
 * HIZ LA [0:6]
 * SAR LA [8:52]
 * sar_refs LA [53:63] vref/mux; [108:122] S_LV and buffer enables
 * BGR LA [64:97]
 * REFBUF LA [104:107]
 *
 * Analog: analog_io[N] is Caravel GPIO N+7.
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

    .e_pd(la_data_in[0]),
    .en_pd(la_data_in[1]),
    .tp(la_data_in[2]),
    .clk2_boost(la_data_in[3]),
    .e_n_boost(la_data_in[4]),
    .e_na_boost(la_data_in[5]),
    .clk1_boostr(la_data_in[6]),

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
    .pd(la_data_in[8]),
    .pd_ana(la_data_in[9]),
    .reset_n(la_data_in[10]),
    .sof(la_data_in[11]),
    .next(la_data_in[12]),
    .hiz(la_data_in[13]),
    .iso_en(la_data_in[14]),
    .enable_hv(la_data_in[15]),
    .trimunit(la_data_in[16]),
    .dly_inc(la_data_in[17]),
    .dcen(la_data_in[18]),
    .pumpclk(la_data_in[19]),
    .en_pump_lv(la_data_in[20]),
    .scan_test_mode(la_data_in[21]),
    .test_scanin(la_data_in[22]),
    .test_scanen(la_data_in[23]),
    .test_sea(la_data_in[24]),
    .resolution(la_data_in[26:25]),
    .sample_width(la_data_in[36:27]),
    .cap_trim(la_data_in[39:37]),
    .icont_lv(la_data_in[41:40]),
    .dft_inc(la_data_in[45:42]),
    .dft_outc(la_data_in[48:46]),
    .sel_csel_dft(la_data_in[52:49]),

    .data_out(la_data_out[11:0]),
    .eof(la_data_out[12]),

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

    .trimTC(la_data_in[70:64]),
    .trimCurr(la_data_in[76:71]),
    .CurrAbsTrim(la_data_in[82:77]),
    .inl_ctrl(la_data_in[89:83]),
    .mux1sel(la_data_in[91:90]),
    .mux2sel(la_data_in[92]),
    .dft_sel(la_data_in[93]),
    .pd(la_data_in[94]),
    .pd_ibg(la_data_in[95]),
    .finetune(la_data_in[96]),
    .en_startb(la_data_in[97]),

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

    .pd(la_data_in[104]),
    .switchon(la_data_in[105]),
    .boost(la_data_in[106]),
    .ch_cont(la_data_in[107]),

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

    .pd(la_data_in[8]),
    .pd_ana(la_data_in[9]),
    .hiz(la_data_in[13]),
    .enable_hv(la_data_in[15]),
    .vref(la_data_in[57:53]),
    .PWR_CTRL_VREF(la_data_in[59:58]),
    .muxsarref(la_data_in[62:60]),
    .EN_RESVDA(la_data_in[63]),
    .sw_start(la_data_in[108]),
    .pd_vcmbuf(la_data_in[109]),
    .S_LV(la_data_in[117:110]),
    .refout_en(la_data_in[118]),
    .sw_holdb(la_data_in[119]),
    .enpdb_hv(la_data_in[120]),
    .PD_BUF_VREF(la_data_in[121]),
    .dft_comp_en(la_data_in[122]),

`ifdef USE_POWER_PINS
    .vgnd(vssd1),
    .vpwr(vccd1)
`endif
);

endmodule

`default_nettype wire
