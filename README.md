<div align="center">

<img src="https://umsousercontent.com/lib_lnlnuhLgkYnZdkSC/hj0vk05j0kemus1i.png" alt="ChipFoundry Logo" height="140" />

[![Typing SVG](https://readme-typing-svg.demolab.com?font=Inter&size=44&duration=3000&pause=600&color=4C6EF5&center=true&vCenter=true&width=1100&lines=Caravel+User+Project+Template;OpenLane+%2B+ChipFoundry+Flow;Verification+and+Shuttle-Ready)](https://git.io/typing-svg)

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![ChipFoundry Marketplace](https://img.shields.io/badge/ChipFoundry-Marketplace-6E40C9.svg)](https://platform.chipfoundry.io/marketplace)

</div>

## Table of Contents
- [Overview](#overview)
- [Documentation & Resources](#documentation--resources)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Starting Your Project](#starting-your-project)
- [Development Flow](#development-flow)
- [GPIO Configuration](#gpio-configuration)
- [Local Precheck](#local-precheck)
- [Checklist for Shuttle Submission](#checklist-for-shuttle-submission)

## Overview
`cf-sensor-afe` is the ChipFoundry **sensor analog front-end** reference
application on Caravel. The intended chain is:

```
sensor pads → CF_BUF_HIZ → CF_ADC_SAR12 → firmware/UART
                 ↑                ↑
              CF_BGR bias    CF_ADC_SAR12_sar_refs
                 ↑
              CF_REFBUF (buffered Vout monitor)
```

This drop 4 adds wrapped `CF_ADC_SAR12_sar_refs` to the four other catalog
IPs. Chip PDN is Caravel's 1.8 V user supply (`vccd1`/`vssd1` → wrap
`vpwr`/`vgnd` on every macro). On-chip analog:

- `CF_BUF_HIZ.vout` → `CF_ADC_SAR12.vinp`
- `CF_BGR.ibg_2p375uA` → `CF_BUF_HIZ.ibias`, `CF_ADC_SAR12.ibias2p5u`, and
  `sar_refs` `IREF_*`
- `CF_BGR.Vout` → `CF_REFBUF.ref_1v2`
- `CF_BGR.ibg_3uA` → `CF_REFBUF.nbias`
- `sar_refs.REFHI` / `REFBY2` → `CF_ADC_SAR12.vrefhi` / `refby2`

Sensor inputs stay on GPIO 8–13. `CF_REFBUF.out` is the buffered `Vout`
monitor on GPIO 14. `sar_refs.refout` is on GPIO 28. West-edge `sar_refs`
controls use a local LEF overlay so OpenLane can access the vendor-skinny
pads; GDS and PDN still come from the 0.2.1 wrap.

`user_project_wrapper` is elaborated rather than synthesized. It contains only
the macro instances and wiring (no taps, stdcell rails, or tie cells). The
Logic Analyzer probes drive the macro inputs directly: firmware must enable
the probes (`la_oenb`).

### CF_BUF_HIZ connections

| Caravel connection | CF_BUF_HIZ signal |
| --- | --- |
| on-chip `afe_vout` | `vout` → `CF_ADC_SAR12.vinp` |
| on-chip `afe_ibias` | `ibias` ← `CF_BGR.ibg_2p375uA` |
| GPIO 8–13 / `analog_io[1:6]` | `vinp_p`, `vinn_p`, `vinp_n`, `vinn_n`, `vinp_na`, `vinn_na` |
| GPIO 16–26 / `analog_io[9:19]` | `vbpt`, `vbnt`, `vbpb`, `vbpc`, `vbnc`, `vbpci`, `vbnci`, `vbpcis`, `vbncis`, `vbpcid`, `vbptd` |
| LA 0–6 | `e_pd`, `en_pd`, `tp`, `clk2_boost`, `e_n_boost`, `e_na_boost`, `clk1_boostr` |
| `vccd1` / `vssd1` | wrap `vpwr` / `vgnd` |

### CF_ADC_SAR12 connections

| Caravel connection | CF_ADC_SAR12 signal |
| --- | --- |
| on-chip `afe_vout` | `vinp` |
| on-chip `afe_ibias` | `ibias2p5u`, `ibias2p5u_1` |
| GPIO 27 / `analog_io[20]` | `vinm` |
| on-chip `afe_refhi` / `afe_refby2` | `vrefhi`, `refby2` ← `sar_refs` |
| GPIO 29 / `analog_io[22]` | `vreflo` |
| GPIO 32–34 / `analog_io[25:27]` | `vdda`, `vssa`, `VPUMP` |
| `user_clock2` | `refclk` |
| LA in 8–52 | power-down, framing, trim, DFT (see wrapper header) |
| LA out 0–12 | `data_out[11:0]`, `eof` |
| `vccd1` / `vssd1` | wrap `vpwr` / `vgnd` |

### CF_BGR connections

| Caravel connection | CF_BGR signal |
| --- | --- |
| on-chip `afe_ibias` | `ibg_2p375uA` |
| on-chip `afe_nbias` | `ibg_3uA` → `CF_REFBUF.nbias` |
| on-chip `afe_vref` | `Vout` → `CF_REFBUF.ref_1v2` |
| GPIO 7 / `analog_io[0]` | `vb2_fast` |
| GPIO 31 / `analog_io[24]` | `dft_curr_in` |
| LA 64–97 | trim, mux, pd, `en_startb` (see wrapper header) |
| `vccd1` / `vssd1` | wrap `vpwr` / `vgnd` |

### CF_REFBUF connections

| Caravel connection | CF_REFBUF signal |
| --- | --- |
| on-chip `afe_vref` | `ref_1v2` |
| on-chip `afe_nbias` | `nbias` |
| GPIO 14 / `analog_io[7]` | `out`, `ch1`, `ch2` (monitor + feedback) |
| GPIO 15 / `analog_io[8]` | `ng`, `vpwre` |
| LA 104–107 | `pd`, `switchon`, `boost`, `ch_cont` |
| `vccd1` / `vssd1` | wrap `vpwr` / `vgnd` |

### CF_ADC_SAR12_sar_refs connections

| Caravel connection | CF_ADC_SAR12_sar_refs signal |
| --- | --- |
| on-chip `afe_refhi` / `afe_refby2` | `REFHI`, `REFBY2` → SAR `vrefhi` / `refby2` |
| on-chip `afe_ibias` | `IREF_VCMBUF`, `IREF_VREFBUF` |
| GPIO 28 / `analog_io[21]` | `refout` |
| GPIO 32–34 / `analog_io[25:27]` | `vdda`, `vssa` + `vssa_shield`, `VPUMP` |
| LA 8, 9, 13, 15 | `pd`, `pd_ana`, `hiz`, `enable_hv` (shared with SAR) |
| LA 53–63 | `vref[4:0]`, `PWR_CTRL_VREF[1:0]`, `muxsarref[2:0]`, `EN_RESVDA` |
| LA 108–122 | `sw_start`, `pd_vcmbuf`, `S_LV[7:0]`, `refout_en`, `sw_holdb`, `enpdb_hv`, `PD_BUF_VREF`, `dft_comp_en` |
| `vccd1` / `vssd1` | wrap `vpwr` / `vgnd` |

The IPs are installed reproducibly with:

```bash
ipm install CF_BUF_HIZ --version 0.2.0 --include-drafts \
  --local-file ip/catalog.json
ipm install CF_ADC_SAR12 --version 0.2.1 --include-drafts \
  --local-file ip/catalog.json
ipm install CF_BGR --version 0.2.3 --include-drafts \
  --local-file ip/catalog.json
ipm install CF_REFBUF --version 0.2.2 --include-drafts \
  --local-file ip/catalog.json
```

---

## Documentation & Resources
For detailed hardware specifications and register maps, refer to the following official documents:

* **[Caravel Datasheet](https://github.com/chipfoundry/caravel/blob/main/docs/caravel_datasheet_2.pdf)**: Detailed electrical and physical specifications of the Caravel harness.
* **[Caravel Technical Reference Manual (TRM)](https://github.com/chipfoundry/caravel/blob/main/docs/caravel_datasheet_2_register_TRM_r2.pdf)**: Complete register maps and programming guides for the management SoC.
* **[ChipFoundry Marketplace](https://platform.chipfoundry.io/marketplace)**: Access additional IP blocks, EDA tools, and shuttle services.

---

## Prerequisites
Ensure your environment meets the following requirements:

1. **Docker** [Linux](https://docs.docker.com/desktop/setup/install/linux/ubuntu/) | [Windows](https://docs.docker.com/desktop/setup/install/windows-install/) | [Mac](https://docs.docker.com/desktop/setup/install/mac-install/)
2. **Python 3.8+** with `pip`.
3. **Git**: For repository management.

---

## Project Structure
A successful Caravel project requires a specific directory layout for the automated tools to function:

| Directory | Description |
| :--- | :--- |
| `openlane/` | Configuration files for hardening macros and the wrapper. |
| `verilog/rtl/` | Source Verilog code for the project. |
| `verilog/gl/` | Gate-level netlists (generated after hardening). |
| `verilog/dv/` | Design Verification (cocotb and Verilog testbenches). |
| `gds/` | Final GDSII binary files for fabrication. |
| `lef/` | Library Exchange Format files for the macros. |

---

## Starting Your Project

### 1. Repository Setup
Create a new repository based on the `caravel_user_project` template and clone it to your local machine:

```bash
git clone <your-github-repo-URL>
pip install chipfoundry-cli
cd <project_name>
```

### 2. Platform Login

Log in to the ChipFoundry platform (required before `cf init`, `cf push`, `cf pull`, etc.):

```bash
cf login
```

### 3. Project Initialization

> [!IMPORTANT]
> Run this first! Initialize your project configuration:

```bash
cf init
```

This creates `.cf/project.json` with project metadata. **This must be run before any other commands** (`cf setup`, `cf gpio-config`, `cf harden`, `cf precheck`, `cf verify`).

### 4. Environment Setup
Install the ChipFoundry CLI tool and set up the local environment (PDKs, OpenLane, and Caravel lite):

```bash
cf setup
```

The `cf setup` command installs:

- Caravel Lite: The Caravel SoC template.
- Management Core: RISC-V management area required for simulation.
- OpenLane: The RTL-to-GDS hardening flow.
- PDK: Skywater 130nm process design kit.
- Timing Scripts: For Static Timing Analysis (STA).

---

## Development Flow

### Hardening the Design
Hardening is the process of synthesizing your RTL and performing Place & Route (P&R) to create a GDSII layout.

#### Macro Hardening
Create a subdirectory for each custom macro under `openlane/` containing your `config.tcl`.

```bash
cf harden --list         # List detected configurations
cf harden <macro_name>   # Harden a specific macro
```

#### Integration
Instantiate your module(s) in `verilog/rtl/user_project_wrapper.v`.

Update `openlane/user_project_wrapper/config.json` environment variables (`VERILOG_FILES_BLACKBOX`, `EXTRA_LEFS`, `EXTRA_GDS_FILES`) to point to your new macros.

#### Wrapper Hardening
Finalize the top-level user project:

```bash
cf harden user_project_wrapper
```

### Verification

#### 1. Simulation
We use cocotb for functional verification. Ensure your file lists are updated in `verilog/includes/`.

**Configure GPIO settings first (required before verification):**

```bash
cf gpio-config
```

This interactive command will:
- Configure all GPIO pins interactively
- Automatically update `verilog/rtl/user_defines.v`
- Automatically run `gen_gpio_defaults.py` to generate GPIO defaults for simulation

GPIO configuration is required before running any verification tests.

Run RTL Simulation:

```bash
cf verify <test_name>
```

Run Gate-Level (GL) Simulation:

```bash
cf verify <test_name> --sim gl
```

Run all tests:

```bash
cf verify --all
```

#### 2. Static Timing Analysis (STA)
Verify that your design meets timing constraints using OpenSTA:

```bash
make extract-parasitics
make create-spef-mapping
make caravel-sta
```

> [!NOTE]
> Run `make setup-timing-scripts` if you need to update the STA environment.

---

## GPIO Configuration
Configure the power-on default configuration for each GPIO using the interactive CLI tool.

**Use the GPIO configuration command:**
```bash
cf gpio-config
```

This command will:
- Present an interactive form for configuring GPIO pins 5-37 (GPIO 0-4 are fixed system pins)
- Show available GPIO modes with descriptions
- Allow selection by number, partial key, or full mode name
- Save configuration to `.cf/project.json` (as hex values)
- Automatically update `verilog/rtl/user_defines.v` with the new configuration
- Automatically run `gen_gpio_defaults.py` to generate GPIO defaults for simulation (if Caravel is installed)

**GPIO Pin Information:**
- GPIO[0] to GPIO[4]: Preset system pins (do not change).
- GPIO[5] to GPIO[37]: User-configurable pins.

**Available GPIO Modes:**
- Management modes: `mgmt_input_nopull`, `mgmt_input_pulldown`, `mgmt_input_pullup`, `mgmt_output`, `mgmt_bidirectional`, `mgmt_analog`
- User modes: `user_input_nopull`, `user_input_pulldown`, `user_input_pullup`, `user_output`, `user_bidirectional`, `user_output_monitored`, `user_analog`

> [!NOTE]
> GPIO configuration is required before running `cf precheck` or `cf verify`. Invalid modes cannot be saved - all GPIOs must have valid configurations.

---

## Local Precheck
Before submitting your design for fabrication, run the local precheck to ensure it complies with all shuttle requirements:

> [!IMPORTANT]
> GPIO configuration is required before running precheck. Make sure you've run `cf gpio-config` first.

```bash
cf precheck
```

You can also run specific checks or disable LVS:

```bash
cf precheck --disable-lvs                    # Skip LVS check
cf precheck --checks gpio_defines --checks xor  # Run specific checks only
```
---

## Checklist for Shuttle Submission
- [ ] Top-level macro is named user_project_wrapper.
- [ ] Full Chip Simulation passes for both RTL and GL.
- [ ] Hardened Macros are LVS and DRC clean.
- [ ] user_project_wrapper matches the required pin order/template.
- [ ] Design passes the local cf precheck.
- [ ] Documentation (this README) is updated with project-specific details.
