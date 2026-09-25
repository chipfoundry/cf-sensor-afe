# Sensor Analog Front-End

ChipFoundry **sensor analog front-end** reference application on Caravel.
It is the first catalog composition that takes a high-impedance sensor,
conditions it, digitizes it, and hands a 12-bit code to on-chip firmware.

![Sensor analog front-end block diagram](https://d29iwheft2g6v5.cloudfront.net/knowledge-base/2026/09/07/dd786b33-sensor_afe_block.png)

## Overview

Most SKY130 digital SoCs stop at GPIO. Sensing still needs a discrete
instrumentation amp, a SAR ADC, a bandgap, and a reference buffer — four
packages, board parasitics, and a reference that does not track the
converter. This project puts that chain on the same die as the RISC-V
management CPU so a product team can evaluate mixed-signal Caravel without
first becoming analog-layout experts.

**What it does.** Differential, high-Z pads (GPIO 8–13) enter `CF_BUF_HIZ`.
The buffer output is the SAR `vinp`. `CF_BGR` supplies the ~2.4 µA bias
and a 1.2 V bandgap; `CF_ADC_SAR12_sar_refs` makes `REFHI` / `REFBY2` for
the converter; `CF_REFBUF` brings a copy of `Vout` to GPIO 14 so the
reference can be monitored without loading the SAR. At 18 MHz `user_clock2`
the ADC is specified at 1 Msps, 12 bits — fast enough for multiplexed
industrial channels, battery and rail monitoring, and control loops.

Firmware on the management SoC owns power-down, trim, and framing through
`afe_wb`, a synthesized Wishbone CSR. The eval image writes `CTRL`, pulses
`sof`, and prints the 12-bit code on UART TX (GPIO 6). Caravel Logic
Analyzer pins are unused.

This drop is not a complete wireless sensor SoC (no radio, no flash, no
LDO). It is the analog acquisition island those products share. Teams
extend it with catalog digital IP (UART/SPI/I2C, timers, SRAM) or keep
Caravel’s management SoC and treat the AFE as a co-processor.

## Key features

* High-Z differential sensor inputs on GPIO 8–13 (`CF_BUF_HIZ`)
* 12-bit SAR at up to 1 Msps (`CF_ADC_SAR12` + `CF_ADC_SAR12_sar_refs`)
* On-die bandgap bias and 1.2 V reference (`CF_BGR`)
* Buffered reference monitor on GPIO 14 (`CF_REFBUF`)
* Wishbone CSR (`afe_wb`) for power-down, trim, and conversion framing
* Eval firmware prints 12-bit codes on UART TX (GPIO 6)
* Caravel 1.8 V user supply (`vccd1` / `vssd1` → wrap `vpwr` / `vgnd`)

## Catalog IPs

| IP | Version | Role |
| --- | --- | --- |
| [CF_BUF_HIZ](https://github.com/chipfoundry/CF_BUF_HIZ) | 0.2.6 | Sensor input buffer |
| [CF_ADC_SAR12](https://github.com/chipfoundry/CF_ADC_SAR12) | 0.2.8 | 12-bit SAR + wrapped `sar_refs` |
| [CF_BGR](https://github.com/chipfoundry/CF_BGR) | 0.2.9 | Bandgap bias / 1.2 V reference |
| [CF_REFBUF](https://github.com/chipfoundry/CF_REFBUF) | 0.2.8 | Buffered `Vout` monitor |

This reference design is Apache-2.0. Analog macros are separate catalog
IPs with their own licenses. Tapeout substitutes protected analog GDS
into the `*_core` leaves; public views stay pin-accurate abstracts.

## On-chip analog

| Net | From | To |
| --- | --- | --- |
| `afe_vout` | `CF_BUF_HIZ.vout` | `CF_ADC_SAR12.vinp` |
| `afe_ibias` | `CF_BGR.ibg_2p375uA` | HIZ `ibias`, SAR `ibias2p5u`, `sar_refs` `IREF_*` |
| `afe_vref` | `CF_BGR.Vout` | `CF_REFBUF.ref_1v2` |
| `afe_nbias` | `CF_BGR.ibg_3uA` | `CF_REFBUF.nbias` |
| `afe_refhi` | `sar_refs.REFHI` | SAR `vrefhi` |
| `afe_refby2` | `sar_refs.REFBY2` | SAR `refby2` |

`user_project_wrapper` is elaborated, not synthesized: macro instances and
wiring only.

## GPIO

`analog_io[N]` is Caravel GPIO N+7. GPIO 7–29 and 31–34 are user analog
at power-on. GPIO 30 is unused. Analog pads are held Hi-Z by `afe_wb`.

| GPIO | `analog_io` | Use |
| --- | --- | --- |
| 5 | — | UART RX |
| 6 | — | UART TX after firmware |
| 7 | 0 | BGR `vb2_fast` |
| 8–13 | 1–6 | HIZ sensor inputs `vinp_p` … `vinn_na` |
| 14 | 7 | REFBUF `out` / `ch1` / `ch2` (monitor + feedback) |
| 15 | 8 | REFBUF `ng` / `vpwre` |
| 16–26 | 9–19 | HIZ analog biases `vbpt` … `vbptd` |
| 27 | 20 | SAR `vinm` |
| 28 | 21 | `sar_refs.refout` |
| 29 | 22 | SAR `vreflo` |
| 30 | 23 | Unused |
| 31 | 24 | BGR `dft_curr_in` |
| 32–34 | 25–27 | Shared analog `vdda`, `vssa`, `VPUMP` |
| 35–37 | — | Unused |

GPIO 0–4 are Caravel system pins. `user_clock2` is SAR `refclk`.

## Wishbone CSR (`afe_wb`)

| Offset | Name | Access |
| --- | --- | --- |
| 0x00 | `ID` | RO `0xAFE00001` |
| 0x04 | `CTRL` | RW `reset_n`, `sof`, `pd`, `pd_ana`, `enable_hv`, `hiz`, `iso_en`, `next` |
| 0x08 | `STATUS` | RO `data_out[11:0]`, `eof` |
| 0x0C | `HIZ` | RW HIZ power-down / boost |
| 0x10 | `SAR_CFG` | RW sample width, resolution, cap trim, clocks |
| 0x14 | `SAR_DFT` | RW scan / DFT |
| 0x18 | `BGR` | RW trim / mux / pd |
| 0x1C | `REFBUF` | RW buffer enables; bits 4–5 are BGR `finetune` / `en_startb` |
| 0x20 | `REFS0` | RW `vref`, `PWR_CTRL_VREF`, `muxsarref`, `EN_RESVDA` |
| 0x24 | `REFS1` | RW `S_LV` and remaining `sar_refs` enables |

Word offsets are `address / 4`. Product firmware must call `User_enableIF()`.

## Specifications

| Parameter | Value |
| --- | --- |
| Process | SkyWater SKY130 (130 nm) |
| User area | 2920 × 3520 µm (~10.3 mm²) |
| Macros | 6 (`CF_BUF_HIZ`, `CF_ADC_SAR12`, `CF_ADC_SAR12_sar_refs`, `CF_BGR`, `CF_REFBUF`, `afe_wb`) |
| Conversion clock | 18 MHz `user_clock2` (SAR `refclk`) |
| Resolution / rate | 12 bits, up to 1 Msps |
| Digital supply | 1.8 V (`vccd1` / `vssd1`) |
| Host bus | Wishbone (`afe_wb`) |
| Platform | Caravel / chipIgnite |

## Resources

* [GitHub: chipfoundry/cf-sensor-afe](https://github.com/chipfoundry/cf-sensor-afe)
* [Caravel datasheet](https://github.com/chipfoundry/caravel/blob/main/docs/caravel_datasheet_2.pdf)
* [ChipFoundry Marketplace](https://platform.chipfoundry.io/marketplace)
