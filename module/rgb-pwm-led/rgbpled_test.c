/*
 * rgbpled_test.c
 *
 * Author: Yangkai Wang <wang_yangkai@163.com>
 * 2014.12.25
 */

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>
#include <string.h>

#define NODE_R "/sys/class/leds/ledpR/brightness"
#define NODE_G "/sys/class/leds/ledpG/brightness"
#define NODE_B "/sys/class/leds/ledpB/brightness"


int sys_node_set_buf(char *node, char *buf, int len)
{
	int ret;
	int fd;

	fd = open(node, O_RDWR);
	if (fd < 0) {
		printf("error open():%d\n", fd);
		return fd;
	}
	
	ret = write(fd, buf, len);
	if (ret < 0) {
		printf("error write():%d\n", ret);
		return ret;
	}

	ret = close(fd);

	return ret;
}

int sys_node_set_srt(char *node, char *str)
{
	return sys_node_set_buf(node, str, strlen(str));
}

int sys_node_set_int(char *node, int data)
{
	char str[16] = {0};
	int  len;
	
	len = sprintf(str, "%d", data);
	return sys_node_set_buf(node, str, len);
}

typedef enum {
	RGB = 1,
	RBG,
	GRB,
	GBR,
	BRG,
	BGR,
} rgb_seq_t;

void set_color(rgb_seq_t rgb_seq, int i, int j, int k)
{
	i = i / 10;
	j = j / 10;
	k = k / 10;
	
	switch (rgb_seq) {
	case RGB:
		sys_node_set_int(NODE_R, i);
		sys_node_set_int(NODE_G, j);
		sys_node_set_int(NODE_B, k);
		break ;
	case RBG:
		sys_node_set_int(NODE_R, i);
		sys_node_set_int(NODE_G, k);
		sys_node_set_int(NODE_B, j);
		break ;
	case GRB:
		sys_node_set_int(NODE_R, j);
		sys_node_set_int(NODE_G, i);
		sys_node_set_int(NODE_B, k);
		break ;
	case GBR:
		sys_node_set_int(NODE_R, j);
		sys_node_set_int(NODE_G, k);
		sys_node_set_int(NODE_B, i);
		break ;
	case BRG:
		sys_node_set_int(NODE_R, k);
		sys_node_set_int(NODE_G, i);
		sys_node_set_int(NODE_B, j);
		break ;
	case BGR:
		sys_node_set_int(NODE_R, k);
		sys_node_set_int(NODE_G, j);
		sys_node_set_int(NODE_B, i);
		break ;
	default:
		break ;
	}

	usleep(1000*200);
}
void test(void);

int main(int argc, char *argv[])
{
	int i = 0, j = 0, k = 0;
	int color = RGB;
	int i_speed = 10;
	int j_speed = 80;
	int k_speed = 10;
	
	test();

	do {
/*		
	switch (color) {
	case RGB:
		printf("GB\n");
		break ;
	case RBG:
		printf("BG\n");
		break ;
	case GRB:
		printf("RB\n");
		break ;
	case GBR:
		printf("RG\n");
		break ;
	case BRG:
		printf("BR\n");
		break ;
	case BGR:
		printf("GR\n");
		break ;
	default:
		break ;
	}
*/
	//for (i = 0; i < 255; i+=i_speed) {
		for (j = 0; j < 255; j+=j_speed) {
			for (k = 0; k < 255; k+=k_speed) {
				set_color(color, i, j, k);
			}
			for (k = 255; k > 0; k-=k_speed) {
				set_color(color, i, j, k);
			}
		}
		for (j = 255; j > 0; j-=j_speed) {
			for (k = 0; k < 255; k+=k_speed) {
				set_color(color, i, j, k);
			}
			for (k = 255; k > 0; k-=k_speed) {
				set_color(color, i, j, k);
			}
		}

		//printf("i:%d j:%d k:%d\n", i, j , k);
	//}
/*
	for (i = 255; i > 0; i-=i_speed) {
		for (j = 0; j < 255; j+=j_speed) {
			for (k = 0; k < 255; k+=k_speed) {
				set_color(color, i, j, k);
			}
			for (k = 255; k > 0; k-=k_speed) {
				set_color(color, i, j, k);
			}
		}
		for (j = 255; j > 0; j--) {
			for (k = 0; k < 255; k+=k_speed) {
				set_color(color, i, j, k);
			}
			for (k = 255; k > 0; k-=k_speed) {
				set_color(color, i, j, k);
			}
		}

		printf("i:%d j:%d k:%d\n", i, j , k);
	}
*/	
	color++;
	if (color > BGR)
		color = RGB;

	} while (color <= BGR);

/*	
	int cmd;
	int arg;
	int fd;

	if ((argc != 4) || (sscanf(argv[2], "%d", &cmd) != 1)  || (sscanf(argv[3], "%d", &arg) != 1) ||
		 (cmd < 0) || (cmd > 1) || (arg < 0) || (arg > 3)) {
			printf("Parameter error\n");
			printf("%s /dev/* cmd arg\n", argv[0]);
			exit(1);
	}
*/
	return 0;
}

void test(void)
{
	set_color(RGB, 0, 0, 0);
	sleep(1);
	
	//printf("R\n");
	set_color(RGB, 255, 0, 0);
	usleep(1000*200);
	//printf("G\n");
	set_color(RGB, 0, 255, 0);
	usleep(1000*200);
	//printf("B\n");
	set_color(RGB, 0, 0, 255);
	usleep(1000*200);
	//printf("RG\n");
	set_color(RGB, 255, 255, 0);
	usleep(1000*200);
	//printf("RB\n");
	set_color(RGB, 255, 0, 255);
	usleep(1000*200);
	//printf("GB\n");
	set_color(RGB, 0, 255, 255);
	usleep(1000*200);

	//printf("\nBLACK\n\n");
	set_color(RGB, 0, 0, 0);
	sleep(2);
}
