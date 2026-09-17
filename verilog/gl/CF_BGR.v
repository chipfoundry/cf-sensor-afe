// Structural PG wrapper. Analog leaf is CF_BGR_core.
// Customer rails are vpwr/vgnd; well taps vpb/vnb are tied inside.
module CF_BGR (
    Vout,
    ictat,
    iptat,
    ibg_2p375uA,
    ibg_3uA,
    mux1out,
    mux2out,
    vbias,
    vbias_cascode,
    boost3,
    boost4,
    boost5,
    boost6,
    boost7,
    vb2_fast,
    en_startb,
    dft_curr_in,
    dft_sel,
    mux1sel,
    mux2sel,
    pd,
    pd_ibg,
    trimCurr,
    trimTC,
    finetune,
    vgnd,
    CurrAbsTrim,
    inl_ctrl,
    vpwr,
    vout_ictat,
    pbias_ctat
);
    output Vout;
    output ictat;
    output iptat;
    output ibg_2p375uA;
    output ibg_3uA;
    output mux1out;
    output mux2out;
    output vbias;
    output vbias_cascode;
    output boost3;
    output boost4;
    output boost5;
    output boost6;
    output boost7;
    input vb2_fast;
    input en_startb;
    input dft_curr_in;
    input dft_sel;
    input [1:0] mux1sel;
    input mux2sel;
    input pd;
    input pd_ibg;
    input [5:0] trimCurr;
    input [6:0] trimTC;
    input finetune;
    input vgnd;
    input [5:0] CurrAbsTrim;
    input [6:0] inl_ctrl;
    input vpwr;
    output vout_ictat;
    output pbias_ctat;
    CF_BGR_core u_core (
        .Vout(Vout),
        .ictat(ictat),
        .iptat(iptat),
        .ibg_2p375uA(ibg_2p375uA),
        .ibg_3uA(ibg_3uA),
        .mux1out(mux1out),
        .mux2out(mux2out),
        .vbias(vbias),
        .vbias_cascode(vbias_cascode),
        .boost3(boost3),
        .boost4(boost4),
        .boost5(boost5),
        .boost6(boost6),
        .boost7(boost7),
        .vb2_fast(vb2_fast),
        .en_startb(en_startb),
        .dft_curr_in(dft_curr_in),
        .dft_sel(dft_sel),
        .mux1sel(mux1sel),
        .mux2sel(mux2sel),
        .pd(pd),
        .pd_ibg(pd_ibg),
        .trimCurr(trimCurr),
        .trimTC(trimTC),
        .finetune(finetune),
        .vgnd(vgnd),
        .CurrAbsTrim(CurrAbsTrim),
        .inl_ctrl(inl_ctrl),
        .vnb(vgnd),
        .vpb(vpwr),
        .vpwr(vpwr),
        .vout_ictat(vout_ictat),
        .pbias_ctat(pbias_ctat)
    );
endmodule
