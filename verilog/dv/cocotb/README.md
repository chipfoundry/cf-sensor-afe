# SPDX-FileCopyrightText: 2026 ChipFoundry
# SPDX-License-Identifier: Apache-2.0

# Cocotb tests

`afe_uart` is the sensor AFE UART bring-up test. `cocotb_tests.py` imports it.
`all_tests.yaml` is what `cf verify --all` runs.

## afe_uart

Firmware (`afe_uart/afe_uart.c`) enables the user Wishbone IF, checks CSR
`ID == 0xAFE00001`, writes `CTRL`, pulses `sof`, polls `eof`, and prints:

```
AFE ready
ID AFE00001
ADC 800
```

The Python bench pokes HIZ behavioral reals (`vinp_p_v=1.65`, `vinn_p_v=0`),
copies `vout_v` onto the SAR `vinp_v`, and pokes SAR `vrefhi_v=3.3` after
management GPIO goes high, then scores those UART lines.

```bash
cf verify afe_uart
```

Or, from this directory with `caravel_cocotb` on `PATH`:

```bash
caravel_cocotb -t afe_uart -tag afe_uart
```
