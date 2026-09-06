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

#include <firmware_apis.h>

#define AFE_ID             0
#define AFE_CTRL           1
#define AFE_STATUS         2
#define AFE_CTRL_RESET_N   (1u << 0)
#define AFE_CTRL_SOF       (1u << 1)
#define AFE_CTRL_ENABLE_HV (1u << 4)
#define AFE_STATUS_EOF     (1u << 12)
#define AFE_ID_VALUE       0xAFE00001u

static void delay(int n)
{
	int i;
	for (i = 0; i < n; i++)
		asm volatile("nop");
}

static void print_hex12(unsigned int v)
{
	static const char hex[] = "0123456789ABCDEF";
	char buf[5];
	buf[0] = hex[(v >> 8) & 0xF];
	buf[1] = hex[(v >> 4) & 0xF];
	buf[2] = hex[v & 0xF];
	buf[3] = '\n';
	buf[4] = 0;
	print(buf);
}

static unsigned int afe_sample(void)
{
	unsigned int st;
	int i;

	USER_writeWord(AFE_CTRL_RESET_N | AFE_CTRL_ENABLE_HV | AFE_CTRL_SOF, AFE_CTRL);
	delay(40);
	USER_writeWord(AFE_CTRL_RESET_N | AFE_CTRL_ENABLE_HV, AFE_CTRL);
	for (i = 0; i < 4000; i++) {
		st = USER_readWord(AFE_STATUS);
		if (st & AFE_STATUS_EOF)
			return st & 0xFFFu;
		asm volatile("nop");
	}
	return USER_readWord(AFE_STATUS) & 0xFFFu;
}

void main()
{
	int i;

	ManagmentGpio_write(0);
	ManagmentGpio_outputEnable();
	enableHkSpi(0);

	GPIOs_configure(6, GPIO_MODE_MGMT_STD_OUTPUT);
	for (i = 7; i <= 34; i++)
		GPIOs_configure(i, GPIO_MODE_USER_STD_ANALOG);
	GPIOs_loadConfigs();
	UART_enableTX(1);

	User_enableIF();
	if (USER_readWord(AFE_ID) != AFE_ID_VALUE) {
		print("ID fail\n");
		return;
	}
	USER_writeWord(AFE_CTRL_RESET_N | AFE_CTRL_ENABLE_HV, AFE_CTRL);
	delay(40);

	ManagmentGpio_write(1);
	print("AFE ready\n");
	print("ID AFE00001\n");
	print("ADC ");
	print_hex12(afe_sample());
}
