# SPDX-FileCopyrightText: 2026 ChipFoundry
# SPDX-License-Identifier: Apache-2.0

from caravel_cocotb.caravel_interfaces import test_configure
from caravel_cocotb.caravel_interfaces import report_test
import cocotb
from caravel_cocotb.caravel_interfaces import UART

@cocotb.test()
@report_test
async def afe_uart(dut):
    caravelEnv = await test_configure(dut, timeout_cycles=4000000)
    uart = UART(caravelEnv)
    await caravelEnv.wait_mgmt_gpio(1)
    ready = await uart.get_line()
    if "AFE ready" not in ready:
        cocotb.log.error(f"[TEST] expected AFE ready, got '{ready}'")
        return
    adc = await uart.get_line()
    if not adc.startswith("ADC "):
        cocotb.log.error(f"[TEST] expected ADC line, got '{adc}'")
        return
    cocotb.log.info(f"[TEST] Pass UART '{ready}' / '{adc}'")
