# SPDX-FileCopyrightText: 2026 ChipFoundry
# SPDX-License-Identifier: Apache-2.0

from caravel_cocotb.caravel_interfaces import test_configure
from caravel_cocotb.caravel_interfaces import report_test
import cocotb
from caravel_cocotb.caravel_interfaces import UART

# Mid-scale stimulus: vinp=1.65, vrefhi=3.3 → code 0x800 (ideal unipolar 12-bit).
ADC_MIDSCALE = "ADC 800"
AFE_ID_LINE = "ID AFE00001"


def _poke_sar_reals(dut):
    core = dut.uut.chip_core.mprj.u_cf_adc_sar12.u_core
    core.vinp_v.value = 1.65
    core.vinm_v.value = 0.0
    core.vrefhi_v.value = 3.3
    core.vreflo_v.value = 0.0


@cocotb.test()
@report_test
async def afe_uart(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=4000000)
    uart = UART(caravelEnv)
    await caravelEnv.wait_mgmt_gpio(1)
    try:
        _poke_sar_reals(dut)
    except Exception as exc:
        cocotb.log.error(f"[TEST] could not poke SAR reals: {exc}")
        return
    ready = await uart.get_line()
    if "AFE ready" not in ready:
        cocotb.log.error(f"[TEST] expected AFE ready, got '{ready}'")
        return
    ident = await uart.get_line()
    if ident.strip() != AFE_ID_LINE:
        cocotb.log.error(f"[TEST] expected '{AFE_ID_LINE}', got '{ident}'")
        return
    adc = await uart.get_line()
    if adc.strip() != ADC_MIDSCALE:
        cocotb.log.error(f"[TEST] expected '{ADC_MIDSCALE}', got '{adc}'")
        return
    cocotb.log.info(f"[TEST] Pass UART '{ready}' / '{ident}' / '{adc}'")
