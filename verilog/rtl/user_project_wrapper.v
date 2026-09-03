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
 * CF_BGR controls are driven by management-core Logic Analyzer outputs:
 *   [6:0]   trimTC
 *   [13:7]  trimCurr
 *   [15:14] CurrAbsTrim
 *   [17:16] inl_ctrl
 *   [19:18] mux1sel
 *   [20]    mux2sel
 *   [21]    dft_sel
 *   [22]    pd
 *   [23]    pd_ibg
 *
 * An LA bit is used when its active-low output enable is asserted. Otherwise
 * the safe default powers down both the voltage and current references.
 */
localparam [23:0] BGR_CONTROL_DEFAULT = 24'hC00000;
wire [23:0] bgr_control;

assign bgr_control =
    (~la_oenb[23:0] & la_data_in[23:0]) |
    ( la_oenb[23:0] & BGR_CONTROL_DEFAULT);

assign wbs_ack_o  = 1'b0;
assign wbs_dat_o  = 32'b0;
assign la_data_out = 128'b0;
assign io_out     = {`MPRJ_IO_PADS{1'b0}};
assign io_oeb     = {`MPRJ_IO_PADS{1'b1}};
assign user_irq   = 3'b000;

CF_BGR u_cf_bgr (
    // Analog outputs: analog_io[N] is Caravel GPIO N+7.
    .Vout(analog_io[0]),
    .ictat(analog_io[1]),
    .iptat(analog_io[2]),
    .ibg_2p5uA(analog_io[3]),
    .ibg_10uA(analog_io[4]),
    .mux1out(analog_io[5]),
    .mux2out(analog_io[6]),
    .vbias(analog_io[7]),
    .vbias_cascode(analog_io[8]),

    .trimTC(bgr_control[6:0]),
    .trimCurr(bgr_control[13:7]),
    .CurrAbsTrim(bgr_control[15:14]),
    .inl_ctrl(bgr_control[17:16]),
    .mux1sel(bgr_control[19:18]),
    .mux2sel(bgr_control[20]),
    .dft_sel(bgr_control[21]),
    .pd(bgr_control[22]),
    .pd_ibg(bgr_control[23]),

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
