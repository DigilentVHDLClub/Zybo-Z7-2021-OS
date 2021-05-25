/*
 * Copyright (c) 2012 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <signal.h>

#define MAX_BUF 128
#define LED_BASE_ADDR 1012
#define SW_BASE_ADDR 1016
#define BTN_BASE_ADDR 1020
typedef enum {IN, OUT} dir;


int gpio;
int fd;
char buf[MAX_BUF];
void export_gpio(int gpio_base_addr, int channel){
	gpio =gpio_base_addr + channel;
	fd = open("/sys/class/gpio/export", O_WRONLY);
	sprintf(buf, "%d", gpio);
	write(fd, buf, strlen(buf)); //writing to buf the gpio address
	close(fd);
}

void set_gpio_direction(int gpio_base_addr, int channel, dir direction){
	gpio =gpio_base_addr + channel;
	sprintf(buf, "/sys/class/gpio/gpio%d/direction", gpio);
	fd = open(buf, O_WRONLY);
	if(direction == OUT){
		write(fd, "out", 3);// Set out direction
	}else{
		write(fd, "in", 2); // Set in direction
	}
	close(fd);
}

void set_gpio_value(int gpio_base_addr, int channel,char* value){
	gpio =gpio_base_addr + channel;
	sprintf(buf, "/sys/class/gpio/gpio%d/value", gpio);
	fd = open(buf, O_WRONLY);
	write(fd, value, 1); // Set GPIO high status or low
	close(fd);
}
char get_gpio_value(int gpio_base_addr, int channel){
	gpio = gpio_base_addr + channel;
	char value;
	sprintf(buf, "/sys/class/gpio/gpio%d/value", gpio);
	fd = open(buf, O_RDONLY);
	read(fd, &value, 1);
	close(fd);
	return value;

}
void unexport_gpio(int gpio_base_addr, int channel){
	gpio =gpio_base_addr + channel;
	fd = open("/sys/class/gpio/unexport", O_WRONLY);
	sprintf(buf, "%d", gpio);
	write(fd, buf, strlen(buf));
	close(fd);
}



void turnLedsON_from_switches(){
	char sw_values[4];
	for(int i=0;i<4;i++){
		sw_values[i]= get_gpio_value(SW_BASE_ADDR,i);
		set_gpio_value(LED_BASE_ADDR,i, &sw_values[i]);

	}
}

void turnLedsON_from_buttons(){
	char btn_values[4];
	for(int i=0;i<4;i++){
		btn_values[i]= get_gpio_value(BTN_BASE_ADDR,i);
		set_gpio_value(LED_BASE_ADDR,i, &btn_values[i]);

	}
}

int main()
{

	for(int i=0;i<4;i++){

    //export leds, buttons and switches
	export_gpio(LED_BASE_ADDR,i);
	export_gpio(BTN_BASE_ADDR,i);
	export_gpio(SW_BASE_ADDR,i);

    //set data direction for leds, buttons and switches
	set_gpio_direction(LED_BASE_ADDR, i, OUT);
	set_gpio_direction(BTN_BASE_ADDR, i, IN);
	set_gpio_direction(SW_BASE_ADDR, i, IN);

	}

	while(1){
		//turnLedsON_from_switches();
		turnLedsON_from_buttons();
	}


    return 0;
}
