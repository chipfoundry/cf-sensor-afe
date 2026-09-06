`default_nettype none
/*
 * afe_wb — Wishbone CSR for the sensor AFE analog macros.
 *
 * Harden as a digital hard macro, then instance in the elaborated
 * user_project_wrapper. analog_ctrl bit indices match the original LA
 * map so analog instance wiring stays the same.
 *
 * User space is 0x30000000. Word offsets:
 *   0 ID      RO  0xAFE00001
 *   1 CTRL    RW  [0] reset_n  [1] sof  [2] pd  [3] pd_ana
 *                 [4] enable_hv  [5] hiz  [6] iso_en  [7] next
 *   2 STATUS  RO  [11:0] data_out  [12] eof
 *   3 HIZ     RW  analog_ctrl[6:0]
 *   4 SAR_CFG RW  sample_width, resolution, cap_trim, icont, clocks
 *   5 SAR_DFT RW  scan / DFT
 *   6 BGR     RW  trim / mux / pd / en_startb
 *   7 REFBUF  RW  pd, switchon, boost, ch_cont
 *   8 REFS0   RW  vref, PWR_CTRL_VREF, muxsarref, EN_RESVDA
 *   9 REFS1   RW  S_LV and remaining sar_refs enables
 *
 * Product firmware: User_enableIF(), write CTRL, pulse sof, read STATUS.
 */

module afe_wb (
`ifdef USE_POWER_PINS
    inout vccd1,
    inout vssd1,
`endif
    input         wb_clk_i,
    input         wb_rst_i,
    input         wbs_stb_i,
    input         wbs_cyc_i,
    input         wbs_we_i,
    input  [3:0]  wbs_sel_i,
    input  [31:0] wbs_dat_i,
    input  [31:0] wbs_adr_i,
    output        wbs_ack_o,
    output [31:0] wbs_dat_o,

    input  [11:0] adc_data,
    input         adc_eof,
    output [122:0] analog_ctrl
);

    localparam [31:0] ID_VALUE = 32'hAFE0_0001;

    wire        valid = wbs_cyc_i & wbs_stb_i;
    wire [3:0]  waddr = wbs_adr_i[5:2];
    wire        wr    = valid & wbs_we_i;

    reg        ack;
    reg [31:0] rdata;
    reg [31:0] ctrl;
    reg [31:0] hiz;
    reg [31:0] sar_cfg;
    reg [31:0] sar_dft;
    reg [31:0] bgr;
    reg [31:0] refbuf;
    reg [31:0] refs0;
    reg [31:0] refs1;
    reg [122:0] csr_ctrl;

    assign wbs_ack_o   = ack;
    assign wbs_dat_o   = rdata;
    assign analog_ctrl = csr_ctrl;

    always @(*) begin
        csr_ctrl = 123'b0;
        csr_ctrl[6:0]     = hiz[6:0];
        csr_ctrl[8]       = ctrl[2];
        csr_ctrl[9]       = ctrl[3];
        csr_ctrl[10]      = ctrl[0];
        csr_ctrl[11]      = ctrl[1];
        csr_ctrl[12]      = ctrl[7];
        csr_ctrl[13]      = ctrl[5];
        csr_ctrl[14]      = ctrl[6];
        csr_ctrl[15]      = ctrl[4];
        csr_ctrl[16]      = sar_cfg[0];
        csr_ctrl[17]      = sar_cfg[1];
        csr_ctrl[18]      = sar_cfg[2];
        csr_ctrl[19]      = sar_cfg[3];
        csr_ctrl[20]      = sar_cfg[4];
        csr_ctrl[26:25]   = sar_cfg[6:5];
        csr_ctrl[36:27]   = sar_cfg[16:7];
        csr_ctrl[39:37]   = sar_cfg[19:17];
        csr_ctrl[41:40]   = sar_cfg[21:20];
        csr_ctrl[24:21]   = sar_dft[3:0];
        csr_ctrl[45:42]   = sar_dft[7:4];
        csr_ctrl[48:46]   = sar_dft[10:8];
        csr_ctrl[52:49]   = sar_dft[14:11];
        csr_ctrl[57:53]   = refs0[4:0];
        csr_ctrl[59:58]   = refs0[6:5];
        csr_ctrl[62:60]   = refs0[9:7];
        csr_ctrl[63]      = refs0[10];
        csr_ctrl[70:64]   = bgr[6:0];
        csr_ctrl[76:71]   = bgr[12:7];
        csr_ctrl[82:77]   = bgr[18:13];
        csr_ctrl[89:83]   = bgr[25:19];
        csr_ctrl[91:90]   = bgr[27:26];
        csr_ctrl[92]      = bgr[28];
        csr_ctrl[93]      = bgr[29];
        csr_ctrl[94]      = bgr[30];
        csr_ctrl[95]      = bgr[31];
        csr_ctrl[96]      = refbuf[4];
        csr_ctrl[97]      = refbuf[5];
        csr_ctrl[104]     = refbuf[0];
        csr_ctrl[105]     = refbuf[1];
        csr_ctrl[106]     = refbuf[2];
        csr_ctrl[107]     = refbuf[3];
        csr_ctrl[108]     = refs1[0];
        csr_ctrl[109]     = refs1[1];
        csr_ctrl[117:110] = refs1[9:2];
        csr_ctrl[118]     = refs1[10];
        csr_ctrl[119]     = refs1[11];
        csr_ctrl[120]     = refs1[12];
        csr_ctrl[121]     = refs1[13];
        csr_ctrl[122]     = refs1[14];
    end

    always @(posedge wb_clk_i) begin
        if (wb_rst_i) begin
            ack     <= 1'b0;
            rdata   <= 32'b0;
            ctrl    <= 32'b0;
            hiz     <= 32'b0;
            sar_cfg <= 32'b0;
            sar_dft <= 32'b0;
            bgr     <= 32'b0;
            refbuf  <= 32'b0;
            refs0   <= 32'b0;
            refs1   <= 32'b0;
        end else begin
            ack <= valid & ~ack;
            if (wr & ~ack) begin
                case (waddr)
                    4'd1: ctrl    <= wbs_dat_i;
                    4'd3: hiz     <= wbs_dat_i;
                    4'd4: sar_cfg <= wbs_dat_i;
                    4'd5: sar_dft <= wbs_dat_i;
                    4'd6: bgr     <= wbs_dat_i;
                    4'd7: refbuf  <= wbs_dat_i;
                    4'd8: refs0   <= wbs_dat_i;
                    4'd9: refs1   <= wbs_dat_i;
                    default: ;
                endcase
            end
            if (valid & ~wbs_we_i & ~ack) begin
                case (waddr)
                    4'd0: rdata <= ID_VALUE;
                    4'd1: rdata <= ctrl;
                    4'd2: rdata <= {19'b0, adc_eof, adc_data};
                    4'd3: rdata <= hiz;
                    4'd4: rdata <= sar_cfg;
                    4'd5: rdata <= sar_dft;
                    4'd6: rdata <= bgr;
                    4'd7: rdata <= refbuf;
                    4'd8: rdata <= refs0;
                    4'd9: rdata <= refs1;
                    default: rdata <= 32'b0;
                endcase
            end
        end
    end

endmodule

`default_nettype wire
