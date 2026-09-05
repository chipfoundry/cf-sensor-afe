`default_nettype none
/*
 * user_project_wrapper — 1-macro-first CF_BUF_HIZ
 *
 * Controls from management-core Logic Analyzer outputs.
 * This wrapper is elaborated, not synthesized, so it must stay structural.
 *
 *   [0] e_pd         [4] e_n_boost
 *   [1] en_pd        [5] e_na_boost
 *   [2] tp           [6] clk1_boostr
 *   [3] clk2_boost
 *
 * Analog: analog_io[N] is Caravel GPIO N+7.
 * Unused Caravel outputs stay undriven (elaborate-only forbids assign).
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

CF_BUF_HIZ u_cf_buf_hiz (
    .vout(analog_io[0]),
    .ibias(analog_io[1]),
    .vinp_p(analog_io[2]),
    .vinn_p(analog_io[3]),
    .vinp_n(analog_io[4]),
    .vinn_n(analog_io[5]),
    .vinp_na(analog_io[6]),
    .vinn_na(analog_io[7]),
    .ion(analog_io[8]),
    .iop(analog_io[9]),
    .vbpt(analog_io[10]),
    .vbnt(analog_io[11]),
    .vbpb(analog_io[12]),
    .vbpc(analog_io[13]),
    .vbnc(analog_io[14]),
    .vbpci(analog_io[15]),
    .vbnci(analog_io[16]),
    .vbpcis(analog_io[17]),
    .vbncis(analog_io[18]),
    .vbpcid(analog_io[19]),
    .vbptd(analog_io[20]),

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

endmodule

`default_nettype wire
