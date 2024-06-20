/* Copyright 2019 SiFive, Inc */
/* SPDX-License-Identifier: Apache-2.0 */
#include <stdio.h>
extern void start_assembly(void);
extern void katan(void);
int main() {
	//start_assembly();
	katan();
    printf("Program finished!\n");
}
