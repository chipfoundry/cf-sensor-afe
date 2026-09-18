// Structural PG wrapper. Analog leaf is CF_REFBUF_core.
// Customer rails are vpwr/vgnd; well taps vpb/vnb/vpbe are tied inside.
module CF_REFBUF (
    out,
    switchoff,
    pd,
    switchon,
    boost,
    ch_cont,
    ch1,
    ch2,
    ref_1v2,
    nbias,
    ng,
    vpwr,
    vpwre,
    vgnd
);
    output out;
    output switchoff;
    input pd;
    input switchon;
    input boost;
    input ch_cont;
    input ch1;
    input ch2;
    input ref_1v2;
    input nbias;
    input ng;
    input vpwr;
    input vpwre;
    input vgnd;
    CF_REFBUF_core u_core (
        .out(out),
        .switchoff(switchoff),
        .pd(pd),
        .switchon(switchon),
        .boost(boost),
        .ch_cont(ch_cont),
        .ch1(ch1),
        .ch2(ch2),
        .ref_1v2(ref_1v2),
        .nbias(nbias),
        .ng(ng),
        .vpwr(vpwr),
        .vpwre(vpwre),
        .vgnd(vgnd),
        .vpb(vpwr),
        .vpbe(vpwre),
        .vnb(vgnd)
    );
endmodule
