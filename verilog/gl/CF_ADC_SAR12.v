// Structural PG wrapper. Analog leaf is CF_ADC_SAR12_core.
// Customer rails are vpwr/vgnd; well taps vpb/vnb/vpbe are tied inside.
module CF_ADC_SAR12 (
    en_pump_lv,
    sample_width,
    vreflo,
    resolution,
    scan_test_mode,
    test_scanin,
    test_scanen,
    test_scanout,
    en_csel_dft,
    sel_csel_dft,
    hiz,
    sof,
    test_sea,
    reset_n,
    eof,
    data_out,
    iso_en,
    next,
    vinp,
    vinm,
    vrefhi,
    vssa_q,
    dft_inp,
    dft_inm,
    dft_op,
    dft_om,
    trimunit,
    vpwr_lv_int,
    vdda,
    vdda_q,
    vgnd,
    VPUMP,
    vboost,
    vssa,
    refby2,
    cap_trim,
    pumpclk,
    dft_enc,
    pd,
    pd_ana,
    refclk,
    dft_inc,
    dft_outc,
    vccd_q,
    vpwr_int,
    vpwr,
    vpwrd_int,
    icont_lv,
    vsub_vic,
    vsub_agr,
    dly_inc,
    dcen,
    ibiasin,
    ibias2p5u,
    ibias2p5u_out,
    ibias2p5u_1,
    enable_hv
);
    input en_pump_lv;
    input [9:0] sample_width;
    inout vreflo;
    input [1:0] resolution;
    input scan_test_mode;
    input test_scanin;
    input test_scanen;
    output test_scanout;
    output en_csel_dft;
    input [3:0] sel_csel_dft;
    input hiz;
    input sof;
    input test_sea;
    input reset_n;
    output eof;
    output [11:0] data_out;
    input iso_en;
    input next;
    input vinp;
    input vinm;
    input vrefhi;
    inout vssa_q;
    inout dft_inp;
    inout dft_inm;
    inout dft_op;
    inout dft_om;
    input trimunit;
    inout vpwr_lv_int;
    inout vdda;
    inout vdda_q;
    input vgnd;
    inout VPUMP;
    inout vboost;
    inout vssa;
    input refby2;
    input [2:0] cap_trim;
    input pumpclk;
    output dft_enc;
    input pd;
    input pd_ana;
    input refclk;
    input [3:0] dft_inc;
    input [2:0] dft_outc;
    inout vccd_q;
    inout vpwr_int;
    input vpwr;
    inout vpwrd_int;
    input [1:0] icont_lv;
    inout vsub_vic;
    inout vsub_agr;
    input dly_inc;
    input dcen;
    inout ibiasin;
    input ibias2p5u;
    output ibias2p5u_out;
    input ibias2p5u_1;
    input enable_hv;
    CF_ADC_SAR12_core u_core (
        .en_pump_lv(en_pump_lv),
        .sample_width(sample_width),
        .vreflo(vreflo),
        .resolution(resolution),
        .scan_test_mode(scan_test_mode),
        .test_scanin(test_scanin),
        .test_scanen(test_scanen),
        .test_scanout(test_scanout),
        .en_csel_dft(en_csel_dft),
        .sel_csel_dft(sel_csel_dft),
        .hiz(hiz),
        .sof(sof),
        .test_sea(test_sea),
        .reset_n(reset_n),
        .eof(eof),
        .data_out(data_out),
        .iso_en(iso_en),
        .next(next),
        .vinp(vinp),
        .vinm(vinm),
        .vrefhi(vrefhi),
        .vssa_q(vssa_q),
        .dft_inp(dft_inp),
        .dft_inm(dft_inm),
        .dft_op(dft_op),
        .dft_om(dft_om),
        .trimunit(trimunit),
        .vpwr_lv_int(vpwr_lv_int),
        .vdda(vdda),
        .vdda_q(vdda_q),
        .vssd(vgnd),
        .VPUMP(VPUMP),
        .vboost(vboost),
        .vssa(vssa),
        .refby2(refby2),
        .cap_trim(cap_trim),
        .pumpclk(pumpclk),
        .dft_enc(dft_enc),
        .pd(pd),
        .pd_ana(pd_ana),
        .refclk(refclk),
        .dft_inc(dft_inc),
        .dft_outc(dft_outc),
        .vccd_q(vccd_q),
        .vpwr_int(vpwr_int),
        .vccd(vpwr),
        .vpwrd_int(vpwrd_int),
        .icont_lv(icont_lv),
        .vsub_vic(vsub_vic),
        .vsub_agr(vsub_agr),
        .dly_inc(dly_inc),
        .dcen(dcen),
        .ibiasin(ibiasin),
        .ibias2p5u(ibias2p5u),
        .ibias2p5u_out(ibias2p5u_out),
        .ibias2p5u_1(ibias2p5u_1),
        .enable_hv(enable_hv)
    );
endmodule
