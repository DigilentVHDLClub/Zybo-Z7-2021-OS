/*
 * For every function, the OFFSET is between 0 and 3
 * The mode argument can receive only  "out" or "in"
 * The value argument can receive only  "0" or "1"
 *
 *
 *  */

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/stat.h>
#include <sys/types.h>


#define GPIO_ROOT "/sys/class/gpio"
#define GPIO_EXPORT "/sys/class/gpio/export"
#define GPIO_BASE 1012
#define BTN_BASE 1020


void export(int base,int OFFSET)
{
		char nbuf[5];
		int export_fd;
		char *gpio_export_file = GPIO_EXPORT;
		export_fd=open(gpio_export_file,O_WRONLY,0700);  // File export with write permissions
		if (export_fd == -1)
		{
			printf("Failed to open export file. \n");
			exit(1);
		}
		const int len = snprintf(nbuf, sizeof nbuf, "%d",base+OFFSET); //Creates a string inside nbuf with value "GPIO_BASE+OFFSET"
		printf("%s \n",nbuf);
		write(export_fd,nbuf,len);
		close(export_fd);
}


void direction(int base, int  OFFSET , char *mode)
{
		char gpio_direction_file[128];
		int export_fd;
		sprintf(gpio_direction_file, "%s/gpio%d/direction", GPIO_ROOT, base+OFFSET); //Creates a string with the address %s/gpio%d/direction inside gpio_direction_file
		export_fd=open(gpio_direction_file,O_WRONLY,0700); // The file location is givein to export_fd
		if (export_fd == -1)
			{
				printf("Failed to open export file. \n");
				exit(1);
			}

		write(export_fd,mode,4);  // Write to  direction file
		close(export_fd);


}

void value (int OFFSET,char *value)
{
	char gpio_value_file[128];
	int export_fd;
	sprintf(gpio_value_file, "%s/gpio%d/value", GPIO_ROOT, GPIO_BASE+OFFSET);
	export_fd=open(gpio_value_file,O_WRONLY,0700);
	if (export_fd == -1)
	 	 {
	printf("Failed to open export file. \n");
	exit(1);
	 	 }

	write(export_fd,value,4);
	close(export_fd);
}

void condition (int OFFSET)
{

	char gpio_value_read_file[128];
	char nbuf[2];
	int len=(sizeof(nbuf)/sizeof(nbuf[0]));
	int export_fd;
	sprintf(gpio_value_read_file, "%s/gpio%d/value", GPIO_ROOT, BTN_BASE+OFFSET);
	export_fd=open(gpio_value_read_file,O_RDONLY);
	if (export_fd == -1)
		 	 {
		printf("Failed to open export file. \n");
		exit(1);
		 	 }
	read(export_fd,nbuf,len); //Save the value read in export_fd to nbuf
	nbuf[1]='\0';
	printf("nbuf: %s \n",nbuf); //test if the btn is working
	if (nbuf[0]=='0') //Check if the value inside nbuf is either 1 or 0 (button pressed or relaxed)
	{
		value(OFFSET,"0");
	}
		else{
			value(OFFSET,"1");
		}
	close(export_fd);



}


int main()
{

	for(int i=0;i<=3;i++)
	{
		export(GPIO_BASE,i);
		direction(GPIO_BASE,i,"out");

		export(BTN_BASE,i);
		direction(BTN_BASE,i,"in");
	}
	while(1){
		condition(0);
		condition(1);
		condition(2);
		condition(3);
	}



	return 0;
}
