module user_project_wrapper (user_clock2,
    wb_clk_i,
    wb_rst_i,
    wbs_ack_o,
    wbs_cyc_i,
    wbs_stb_i,
    wbs_we_i,
    vssa2,
    vdda2,
    vssa1,
    vdda1,
    vssd2,
    vccd2,
    vssd1,
    vccd1,
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
 inout vssa2;
 inout vdda2;
 inout vssa1;
 inout vdda1;
 inout vssd2;
 inout vccd2;
 inout vssd1;
 inout vccd1;
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


 CF_BUF_HIZ u_cf_buf_hiz (.tp(la_data_in[2]),
    .vgnd(vssd1),
    .clk2_boost(la_data_in[3]),
    .clk1_boostr(la_data_in[6]),
    .vbpt(analog_io[10]),
    .vbpcis(analog_io[17]),
    .vbncis(analog_io[18]),
    .vpwr(vccd1),
    .vout(analog_io[0]),
    .vbpci(analog_io[15]),
    .vbnt(analog_io[11]),
    .ibias(analog_io[1]),
    .ion(analog_io[8]),
    .iop(analog_io[9]),
    .e_pd(la_data_in[0]),
    .vbnci(analog_io[16]),
    .vbpcid(analog_io[19]),
    .vbptd(analog_io[20]),
    .vbnc(analog_io[14]),
    .vbpc(analog_io[13]),
    .en_pd(la_data_in[1]),
    .vbpb(analog_io[12]),
    .vinp_n(analog_io[4]),
    .vinn_n(analog_io[5]),
    .vinp_na(analog_io[6]),
    .vinn_na(analog_io[7]),
    .vinn_p(analog_io[3]),
    .vinp_p(analog_io[2]),
    .e_na_boost(la_data_in[5]),
    .e_n_boost(la_data_in[4]));
endmodule
