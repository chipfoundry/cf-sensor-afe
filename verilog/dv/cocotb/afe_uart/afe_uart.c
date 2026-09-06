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

#include <firmware_apis.h>

#define AFE_ID            0
#define AFE_CTRL          1
#define AFE_STATUS        2
#define AFE_CTRL_RESET_N  (1u << 0)
#define AFE_CTRL_SOF      (1u << 1)
#define AFE_CTRL_ENABLE_HV (1u << 4)

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
	USER_writeWord(AFE_CTRL_RESET_N | AFE_CTRL_ENABLE_HV, AFE_CTRL);
	delay(40);

	ManagmentGpio_write(1);
	print("AFE ready\n");

	USER_writeWord(AFE_CTRL_RESET_N | AFE_CTRL_ENABLE_HV | AFE_CTRL_SOF, AFE_CTRL);
	delay(40);
	USER_writeWord(AFE_CTRL_RESET_N | AFE_CTRL_ENABLE_HV, AFE_CTRL);
	delay(800);

	print("ADC ");
	print_hex12(USER_readWord(AFE_STATUS) & 0xFFFu);
}
