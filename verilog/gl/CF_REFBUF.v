// Precheck LVS blackbox for the CF_REFBUF wrap. Empty: EXTRACT_ABSTRACT the wrap.
// Structural wrap+core Verilog stays in ip/CF_REFBUF/hdl/gl/.
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
endmodule
