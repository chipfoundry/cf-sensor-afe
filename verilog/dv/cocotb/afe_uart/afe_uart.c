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

	/* API stores ~mask in oenb. 0xFFFFFFFF => oenb=0 => CPU drives user. */
	LogicAnalyzer_outputEnable(LA_REG_0, 0xFFFFFFFF);
	LogicAnalyzer_outputEnable(LA_REG_1, 0xFFFFFFFF);
	LogicAnalyzer_outputEnable(LA_REG_2, 0xFFFFFFFF);
	LogicAnalyzer_outputEnable(LA_REG_3, 0xFFFFFFFF);
	LogicAnalyzer_inputEnable(LA_REG_0, 0xFFFFFFFF);
	LogicAnalyzer_inputEnable(LA_REG_1, 0xFFFFFFFF);
	LogicAnalyzer_inputEnable(LA_REG_2, 0xFFFFFFFF);
	LogicAnalyzer_inputEnable(LA_REG_3, 0xFFFFFFFF);

	LogicAnalyzer_write(LA_REG_0, LA_RESET_N | LA_ENABLE_HV);
	LogicAnalyzer_write(LA_REG_1, 0);
	LogicAnalyzer_write(LA_REG_2, 0);
	LogicAnalyzer_write(LA_REG_3, 0);

	ManagmentGpio_write(1);
	print("AFE ready\n");

	LogicAnalyzer_write(LA_REG_0, LA_RESET_N | LA_ENABLE_HV | LA_SOF);
	delay(40);
	LogicAnalyzer_write(LA_REG_0, LA_RESET_N | LA_ENABLE_HV);
	delay(400);

	print("ADC ");
	print_hex12(LogicAnalyzer_read(LA_REG_0) & 0xFFFu);
}
