/*
 * SPDX-FileCopyrightText: 2026 ChipFoundry
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <defs.h>
#include <stub.c>

/*
 * Sensor AFE bring-up firmware.
 *
 * Enables Logic Analyzer probes so the management SoC can drive the analog
 * macros, takes the SAR out of reset, pulses sof, and prints data_out on UART
 * TX (GPIO 6). Analog GPIOs 7-34 match user_defines.v.
 *
 * LA oenb is active-low in mgmt_protect: 0 = management drives la_data_in.
 *
 *   reset_n    LA 10
 *   sof        LA 11
 *   enable_hv  LA 15
 *   data_out   LA out [11:0]
 *   eof        LA out 12
 */

#define LA_RESET_N    (1u << 10)
#define LA_SOF        (1u << 11)
#define LA_ENABLE_HV  (1u << 15)

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
	/* Active-low oenb: drive all probes toward the user project. */
	reg_la0_oenb = 0x00000000;
	reg_la1_oenb = 0x00000000;
	reg_la2_oenb = 0x00000000;
	reg_la3_oenb = 0x00000000;
	reg_la0_iena = 0xFFFFFFFF;
	reg_la1_iena = 0xFFFFFFFF;
	reg_la2_iena = 0xFFFFFFFF;
	reg_la3_iena = 0xFFFFFFFF;

	/* pd/pd_ana/hiz stay 0 (macros enabled). reset_n and enable_hv on. */
	reg_la0_data = LA_RESET_N | LA_ENABLE_HV;
	reg_la1_data = 0x00000000;
	reg_la2_data = 0x00000000;
	reg_la3_data = 0x00000000;
}

static unsigned int afe_sample(void)
{
	unsigned int la0;

	reg_la0_data = LA_RESET_N | LA_ENABLE_HV | LA_SOF;
	delay(40);
	reg_la0_data = LA_RESET_N | LA_ENABLE_HV;
	delay(400);
	la0 = reg_la0_data_in;
	return la0 & 0xFFFu;
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
