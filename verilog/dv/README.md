<!---
# SPDX-FileCopyrightText: 2026 ChipFoundry
# SPDX-License-Identifier: Apache-2.0
-->

# Sensor AFE verification

The only DV pattern in this tree is **`afe_uart`**.

Firmware talks to `afe_wb` over Wishbone (`0x30000000`): check `ID`, write
`CTRL` (`reset_n` + `enable_hv`), pulse `sof`, poll `STATUS` `eof`, print the
12-bit code on UART TX (GPIO 6). Analog GPIOs 7–34 match `user_defines.v`.
Caravel Logic Analyzer pins are unused.

## Run (ChipFoundry CLI)

```bash
cf verify afe_uart
# or
cf verify --all
```

`--all` uses `verilog/dv/cocotb/all_tests.yaml`. RTL sim compiles
`ip/CF_ADC_SAR12/verify/beh_model/*_core.v` in place of the empty
`hdl/gl/*_core.v` stubs.

Expected UART:

```
AFE ready
ID AFE00001
ADC 800
```

(`ADC 800` is mid-scale for `vinp=1.65`, `vrefhi=3.3` on the ideal SAR model.)

Classic Verilog TB (`verilog/dv/afe_uart/`): pass is GPIO 37 after a successful
Wishbone sample. SDF, when enabled, annotates `user_project_wrapper`, not a
removed `user_proj_example` netlist.

## Docker / Makefile (legacy)

```bash
make simenv
SIM=RTL make verify-afe_uart
```

See [local-install.md](./local-install.md) for a non-Docker setup.
