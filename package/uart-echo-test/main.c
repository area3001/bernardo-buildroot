#include <fcntl.h>
#include <termios.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <stdio.h>

#define BAUDRATE B115200
#define BUFSIZE 50

struct termios tty;
int uartfd = -1;
char buffer[BUFSIZE];
char *uartport;

void start_uart()
{
	uartfd = open (uartport, O_RDWR | O_NONBLOCK | O_NOCTTY | O_NDELAY);
	fcntl(uartfd, F_SETFL, 0);

	if(uartfd < 0) {
		printf("could not open uart\n");
		exit(-1);
	}

	// Apply Settings
	memset (&tty, 0, sizeof tty);

	// Error Handling
	if (tcgetattr (uartfd, &tty) != 0) {
		printf("error fron tcsetattr\n");
		exit(-1);
	}

	// Set Baud Rate
	cfsetospeed (&tty, BAUDRATE);
	cfsetispeed (&tty, BAUDRATE);
	tty.c_cflag     = BAUDRATE | CS8 | CLOCAL | CREAD;
	tty.c_iflag     = 0;
	tty.c_oflag     = 0;
	tty.c_lflag     = 0;
	tty.c_cc[VMIN]  = 0;
	tty.c_cc[VTIME] = 1;
	tcflush(uartfd, TCIFLUSH);

	// Flush Port, then applies attributes
	tcflush(uartfd, TCIFLUSH);

	if (tcsetattr (uartfd, TCSANOW, &tty) != 0)
	{
		printf("error fron tcsetattr\n");
		exit(-1);
	}

	printf("Serial Port %s Opened\n", uartport);
}

void print_help(char *exec_name)
{
	printf("Usage: %s <tty device>\n", exec_name);
}

int main(int argc, char * argv[])
{
	int size = 0;

	if (argc == 2) {
		uartport = argv[1];
	}
	else if( argc > 2 ) {
		fprintf(stderr, "Too many arguments supplied.\n");
		print_help(argv[0]);
		return -1;
	}
	else {
		fprintf(stderr, "One argument expected.\n");
		print_help(argv[0]);
		return -1;
	}

	printf("Starting UART echo on %s\n", uartport);

	start_uart(uartport);

	while(1) {
		size = read(uartfd, buffer, BUFSIZE);
		if(size > 0)
		{
			// printf("%s", buffer);
			// fflush(stdout);
			write(uartfd, buffer, size);
		}
	}
	
	return 0;
}
