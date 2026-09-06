/*
 * SPDX-FileCopyrightText: 2026 ChipFoundry
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <defs.h>
#include <stub.c>

/*
 * Sensor AFE bring-up firmware (Wishbone CSR).
 *
 * User space 0x30000000, word offsets:
 *   0 ID, 1 CTRL, 2 STATUS (data_out[11:0], eof)
 *
 * CTRL: [0] reset_n [1] sof [4] enable_hv
 *
 * Analog GPIOs 7-34 match user_defines.v. UART TX is GPIO 6.
 */

#define AFE_BASE          ((volatile uint32_t *)0x30000000)
#define AFE_ID            0
#define AFE_CTRL          1
#define AFE_STATUS        2
#define AFE_CTRL_RESET_N  (1u << 0)
#define AFE_CTRL_SOF      (1u << 1)
#define AFE_CTRL_ENABLE_HV (1u << 4)
#define AFE_ID_VALUE      0xAFE00001u

static void delay(int n)
{
	int i;
	for (i = 0; i < n; i++)
		asm volatile("nop");
}

static void print_hex12(unsigned int v)
{
	static const char hex[] = "0123456789ABCDEF";
	putchar(hex[(v >> 8) & 0xF]);
	putchar(hex[(v >> 4) & 0xF]);
	putchar(hex[v & 0xF]);
}

static void afe_enable(void)
{
	reg_wb_enable = 1;
	AFE_BASE[AFE_CTRL] = AFE_CTRL_RESET_N | AFE_CTRL_ENABLE_HV;
	delay(40);
}

static unsigned int afe_sample(void)
{
	AFE_BASE[AFE_CTRL] = AFE_CTRL_RESET_N | AFE_CTRL_ENABLE_HV | AFE_CTRL_SOF;
	delay(40);
	AFE_BASE[AFE_CTRL] = AFE_CTRL_RESET_N | AFE_CTRL_ENABLE_HV;
	delay(800);
	return AFE_BASE[AFE_STATUS] & 0xFFFu;
}

void main()
{
	reg_mprj_io_6 = GPIO_MODE_MGMT_STD_OUTPUT;
	reg_mprj_io_7 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_8 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_9 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_10 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_11 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_12 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_13 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_14 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_15 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_16 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_17 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_18 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_19 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_20 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_21 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_22 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_23 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_24 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_25 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_26 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_27 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_28 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_29 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_30 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_31 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_32 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_33 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_34 = GPIO_MODE_USER_STD_ANALOG;
	reg_mprj_io_37 = GPIO_MODE_MGMT_STD_OUTPUT;

	reg_uart_enable = 1;
	reg_mprj_xfer = 1;
	while (reg_mprj_xfer == 1)
		;

	afe_enable();
	print("AFE ready\n");

	print("ADC ");
	print_hex12(afe_sample());
	print("\n");

	/* GPIO 37 flags the testbench; keep sampling for the eval board. */
	reg_mprj_datah = 0x20;
	for (;;) {
		print("ADC ");
		print_hex12(afe_sample());
		print("\n");
	}
}
