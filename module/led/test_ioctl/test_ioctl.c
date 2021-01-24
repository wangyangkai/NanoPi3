#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	int cmd;
	int arg;
	int fd;

	if ((argc != 4) || (sscanf(argv[2], "%d", &cmd) != 1)  || (sscanf(argv[3], "%d", &arg) != 1) ||
		 (cmd < 0) || (cmd > 1) || (arg < 0) || (arg > 3)) {
			printf("Parameter error\n");
			printf("%s /dev/* cmd arg\n", argv[0]);
			exit(1);
	}

	fd = open(argv[1], O_RDWR);
	if (fd < 0) {
		perror("open device led-0");
		exit(1);
	}

	/*printf("cmd:%d, arg:%d\n", cmd, arg);*/

	ioctl(fd, cmd, arg);

	close(fd);

	return 0;
}
