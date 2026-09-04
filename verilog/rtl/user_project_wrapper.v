// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none
/*
 *-------------------------------------------------------------
 *
 * user_project_wrapper
 *
 * This wrapper enumerates all of the pins available to the
 * user for the user project.
 *
 * An example user project is provided in this wrapper.  The
 * example should be removed and replaced with the actual
 * user project.
 *
 *-------------------------------------------------------------
 */

module user_project_wrapper #(
    parameter BITS = 32
) (
`ifdef USE_POWER_PINS
    inout vdda1,	// User area 1 3.3V supply
    inout vdda2,	// User area 2 3.3V supply
    inout vssa1,	// User area 1 analog ground
    inout vssa2,	// User area 2 analog ground
    inout vccd1,	// User area 1 1.8V supply
    inout vccd2,	// User area 2 1.8v supply
    inout vssd1,	// User area 1 digital ground
    inout vssd2,	// User area 2 digital ground
`endif

    // Wishbone Slave ports (WB MI A)
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

    // Logic Analyzer Signals
    input  [127:0] la_data_in,
    output [127:0] la_data_out,
    input  [127:0] la_oenb,

    // IOs
    input  [`MPRJ_IO_PADS-1:0] io_in,
    output [`MPRJ_IO_PADS-1:0] io_out,
    output [`MPRJ_IO_PADS-1:0] io_oeb,

    // Analog (direct connection to GPIO pad---use with caution)
    // Note that analog I/O is not available on the 7 lowest-numbered
    // GPIO pads, and so the analog_io indexing is offset from the
    // GPIO indexing by 7 (also upper 2 GPIOs do not have analog_io).
    inout [`MPRJ_IO_PADS-10:0] analog_io,

    // Independent clock (on independent integer divider)
    input   user_clock2,

    // User maskable interrupt signals
    output [2:0] user_irq
);

/*
 * CF_BGR controls come straight from management-core Logic Analyzer outputs.
 * This wrapper is elaborated, not synthesized, so it must stay structural:
 * firmware selects trim codes and power state by driving these probes.
 *
 *   [6:0]   trimTC         [27:26] mux1sel
 *   [12:7]  trimCurr       [28]    mux2sel
 *   [18:13] CurrAbsTrim    [29]    dft_sel
 *   [25:19] inl_ctrl       [30]    pd
 *   [32]    finetune       [31]    pd_ibg
 *   [33]    en_startb (active low)
 *
 * Unused Caravel outputs are tied with sky130_fd_sc_hd__conb_1. LibreLane
 * rejects assign statements in an elaborate-only netlist.
 */

genvar tie_i;
generate
    sky130_fd_sc_hd__conb_1 tie_wbs_ack (
`ifdef USE_POWER_PINS
        .VPWR(vccd1),
        .VGND(vssd1),
        .VPB(vccd1),
        .VNB(vssd1),
`endif
        .LO(wbs_ack_o)
    );

    for (tie_i = 0; tie_i < 32; tie_i = tie_i + 1) begin : tie_wbs_dat
        sky130_fd_sc_hd__conb_1 conb (
`ifdef USE_POWER_PINS
            .VPWR(vccd1),
            .VGND(vssd1),
            .VPB(vccd1),
            .VNB(vssd1),
`endif
            .LO(wbs_dat_o[tie_i])
        );
    end

    for (tie_i = 0; tie_i < 128; tie_i = tie_i + 1) begin : tie_la_out
        sky130_fd_sc_hd__conb_1 conb (
`ifdef USE_POWER_PINS
            .VPWR(vccd1),
            .VGND(vssd1),
            .VPB(vccd1),
            .VNB(vssd1),
`endif
            .LO(la_data_out[tie_i])
        );
    end

    for (tie_i = 0; tie_i < `MPRJ_IO_PADS; tie_i = tie_i + 1) begin : tie_io
        sky130_fd_sc_hd__conb_1 conb (
`ifdef USE_POWER_PINS
            .VPWR(vccd1),
            .VGND(vssd1),
            .VPB(vccd1),
            .VNB(vssd1),
`endif
            .LO(io_out[tie_i]),
            .HI(io_oeb[tie_i])
        );
    end

    for (tie_i = 0; tie_i < 3; tie_i = tie_i + 1) begin : tie_irq
        sky130_fd_sc_hd__conb_1 conb (
`ifdef USE_POWER_PINS
            .VPWR(vccd1),
            .VGND(vssd1),
            .VPB(vccd1),
            .VNB(vssd1),
`endif
            .LO(user_irq[tie_i])
        );
    end
endgenerate

CF_BGR u_cf_bgr (
    // Analog outputs: analog_io[N] is Caravel GPIO N+7.
    .Vout(analog_io[0]),
    .ictat(analog_io[1]),
    .iptat(analog_io[2]),
    .ibg_2p375uA(analog_io[3]),
    .ibg_3uA(analog_io[4]),
    .mux1out(analog_io[5]),
    .mux2out(analog_io[6]),
    .vbias(analog_io[7]),
    .vbias_cascode(analog_io[8]),
    .dft_curr_in(analog_io[9]),
    .vb2_fast(analog_io[10]),
    .boost3(analog_io[11]),
    .boost4(analog_io[12]),
    .boost5(analog_io[13]),
    .boost6(analog_io[14]),
    .boost7(analog_io[15]),
    .vout_ictat(analog_io[16]),
    .pbias_ctat(analog_io[17]),

    .trimTC(la_data_in[6:0]),
    .trimCurr(la_data_in[12:7]),
    .CurrAbsTrim(la_data_in[18:13]),
    .inl_ctrl(la_data_in[25:19]),
    .mux1sel(la_data_in[27:26]),
    .mux2sel(la_data_in[28]),
    .dft_sel(la_data_in[29]),
    .pd(la_data_in[30]),
    .pd_ibg(la_data_in[31]),
    .finetune(la_data_in[32]),
    .en_startb(la_data_in[33]),

`ifdef USE_POWER_PINS
    .vgnd(vssd1),
    .vnb(vssd1),
    .vpb(vccd1),
    .vpwr(vccd1)
`else
    .vgnd(1'b0),
    .vnb(1'b0),
    .vpb(1'b1),
    .vpwr(1'b1)
`endif
);

endmodule	// user_project_wrapper

`default_nettype wire
