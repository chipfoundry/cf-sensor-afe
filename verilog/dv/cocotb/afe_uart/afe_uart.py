# SPDX-FileCopyrightText: 2026 ChipFoundry
# SPDX-License-Identifier: Apache-2.0

from caravel_cocotb.caravel_interfaces import test_configure
from caravel_cocotb.caravel_interfaces import report_test
import cocotb
from caravel_cocotb.caravel_interfaces import UART
from cocotb.triggers import Timer

# Mid-scale stimulus: HIZ vinp_p=1.65, vinn_p=0 → vout=1.65; SAR vrefhi=3.3
# → code 0x800 (ideal unipolar 12-bit).
ADC_MIDSCALE = "ADC 800"
AFE_ID_LINE = "ID AFE00001"
HIZ_VOUT_V = 1.65


async def _poke_afe_reals(dut):
    hiz = dut.uut.chip_core.mprj.u_cf_buf_hiz.u_core
    sar = dut.uut.chip_core.mprj.u_cf_adc_sar12.u_core
    hiz.vinp_p_v.value = HIZ_VOUT_V
    hiz.vinn_p_v.value = 0.0
    await Timer(1, units="ns")
    vout = float(hiz.vout_v.value)
    if abs(vout - HIZ_VOUT_V) > 1e-6:
        raise RuntimeError(f"HIZ vout_v={vout}, expected {HIZ_VOUT_V}")
    sar.vinp_v.value = vout
    sar.vinm_v.value = 0.0
    sar.vrefhi_v.value = 3.3
    sar.vreflo_v.value = 0.0


@cocotb.test()
@report_test
async def afe_uart(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=4000000)
    uart = UART(caravelEnv)
    await caravelEnv.wait_mgmt_gpio(1)
    try:
        await _poke_afe_reals(dut)
    except Exception as exc:
        cocotb.log.error(f"[TEST] could not poke HIZ/SAR reals: {exc}")
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
